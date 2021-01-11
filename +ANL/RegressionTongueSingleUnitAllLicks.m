%{
#
-> EPHYS.Unit
-> ANL.TongueTuning1DType
-> ANL.OutcomeType
-> ANL.FlagBasicTrials
-> ANL.LickDirectionType
-> ANL.RegressionTime25
---
number_of_licks                                : int
mean_fr_window                                  : decimal(8,4)              #  mean fr at this time window
regression_coeff_b1                             : decimal(8,4)              # linear regression coefficient   tongue kinematic =b1 + b2*fr
regression_coeff_b2                             : decimal(8,4)              # linear regression coefficient
regression_rsq                                  : decimal(8,4)              # coefficient of determination
regression_p                                    : decimal(8,4)              # regression p value
regression_coeff_b2_normalized                  : decimal(8,4)              # witht the fr normalized, so that it can be compared across cells
time_window_duration                            : decimal(8,4)              #
time_window_start                               : decimal(8,4)              #

%}

classdef RegressionTongueSingleUnitAllLicks < dj.Computed
    properties
        keySource = ((EPHYS.Unit & 'unit_quality!="multi"' & (EPHYS.UnitCellType & 'cell_type="PYR" or cell_type="FS"')) & ANL.Video1stLickTrial)  * (ANL.OutcomeType & 'outcome_grouping="all"') * (ANL.FlagBasicTrials & 'flag_use_basic_trials=0')  * (ANL.TongueTuning1DType & 'tuning_param_name="lick_horizoffset" or tuning_param_name="lick_rt_video_onset" or tuning_param_name="lick_peak_x"') * ANL.LickDirectionType;
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
            % params
            Param = struct2table(fetch (ANL.Parameters,'*'));
            time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
            
            num_repeat=10;
            fraction_train=0.50; % i.e. - compute regression on that fraction of trials, repeat num_repeat, and then average the regression coefficients
            time_window_duration=0.05;
            t_vec=fetchn(ANL.RegressionTime25 ,'regression_time_start');
            
            % fetching spikes and video
            
            kk=key;
            
            if strcmp(key.outcome_grouping,'all')
                kk=rmfield(kk,'outcome_grouping');
            end
            
            %             key_lick_direction=EXP.TrialID & (ANL.LickDirectionTrial & key);
            
            if kk.flag_use_basic_trials==1
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial *   (EXP.TrialName & (ANL.TrialTypeGraphic & 'trialtype_left_and_right_no_distractors=1')) & ANL.VideoNthLickTrial  & kk & ANL.VideoTongueValidRTTrial &  'early_lick="no early"');
            else
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial & ANL.VideoNthLickTrial & kk & ANL.VideoTongueValidRTTrial  &  'early_lick="no early"');
            end
            
            if rel_spikes.count==0
                return
            end
            
            SPIKES=fetch(rel_spikes ,'*','ORDER BY trial');
            
            rel_video=(ANL.VideoNthLickTrial &  kk & rel_spikes );
            if rel_video.count<20
                return
            end
            TONGUE=struct2table(fetch(rel_video,'*','ORDER BY trial'));
            
            % extracting param variable
            VariableNames=TONGUE.Properties.VariableNames';
            idx_v_name=find(strcmp(VariableNames,kk.tuning_param_name));
            Y=TONGUE{:,idx_v_name};
            
            %removing video outliers
            idx_outlier=isoutlier(Y);
            Y(idx_outlier)=[];
            TONGUE(idx_outlier,:)=[];
            
            Y=zscore(Y);
            
            kk.number_of_licks=numel(Y);
            kk.outcome_grouping=key.outcome_grouping;
            
%             t_start=time_window_start;
%             t_end=time_window_start+time_window_duration;
            
            neural_trial_num=[SPIKES.trial];
            
            
            % computing tuning for various time windows
            for it=1:1:numel(t_vec)
                t_wnd{it}=[t_vec(it), t_vec(it)+time_window_duration];
            end
            
            for i_twnd=1:numel(t_wnd)
                current_twnd= t_wnd{i_twnd};
                
                
                spk=[];
                for i_LickXTrial=1:1:size(TONGUE, 1)
                    t_lick_onset= table2array(TONGUE(i_LickXTrial,'lick_rt_video_peak'));
%                     time_idx_2plot = ((time-t_lick_onset) >=time_window_start & (time -t_lick_onset)<time_window_start + time_window_duration);
                    current_trial_num=table2array(TONGUE(i_LickXTrial,'trial'));
                    idx_trial= find(neural_trial_num==current_trial_num);
                    spk_t=SPIKES(idx_trial).spike_times_go;
                    spk(i_LickXTrial)=sum(spk_t>[t_lick_onset + current_twnd(1)] & spk_t<[t_lick_onset + current_twnd(2)]);%/diff(t_wnd);
                end
                
                
                FR_TRIAL=spk/time_window_duration;
                number_of_spikes = sum(spk);
                kk.mean_fr_window=(number_of_spikes/time_window_duration)/size(TONGUE, 1);
                
                
                [beta,Rsq, regression_p,beta_normalized]= fn_regression_parameters (FR_TRIAL,Y, num_repeat, fraction_train);
                
                
                kk.regression_coeff_b1=nanmean(beta(1,:));

                kk.regression_coeff_b2=nanmean(beta(2,:));
                kk.regression_rsq=nanmean(Rsq);
                kk.regression_time_start=current_twnd(1);
                kk.time_window_duration=time_window_duration;
                kk.time_window_start=time_window_duration;

                p= nanmean(regression_p);
                if isnan(p)
                    kk.regression_p=1;
                else
                    kk.regression_p=p;
                end
                kk.regression_coeff_b2_normalized=nanmean(beta_normalized(2,:));
                
                insert(self,kk)
            end
        end
    end
    
end


