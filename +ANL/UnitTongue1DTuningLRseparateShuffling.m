%{
#
-> EPHYS.Unit
-> ANL.TongueTuning1DType
-> ANL.OutcomeType
time_window_start                               : decimal(8,4)              #
-> ANL.TongueTuningSmoothFlag
-> ANL.FlagBasicTrials
-> ANL.LickDirectionType
time_window_duration                            : decimal(8,4)              #
---
tongue_tuning_1d_si_shuffled                    : longblob              # spatial information, shuffled values
tongue_tuning_1d_si_shuffled_mean=null               : decimal(8,4)          # spatial information, mean shuffled values
%}

classdef UnitTongue1DTuningLRseparateShuffling < dj.Computed
    properties
        keySource = ((EPHYS.Unit & 'unit_quality!="multi"' & (EPHYS.UnitCellType & 'cell_type="PYR" or cell_type="FS"')) & ANL.Video1stLickTrialNormalized) *  (ANL.TongueTuningSmoothFlag & 'smooth_flag=0') * (ANL.OutcomeType & 'outcome_grouping="all"') * (ANL.FlagBasicTrials & 'flag_use_basic_trials=0')  * (ANL.TongueTuning1DType & 'tuning_param_name="lick_horizoffset_relative" or tuning_param_name="lick_rt_video_onset" or tuning_param_name="lick_peak_x"') *ANL.LickDirectionType;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            % params
            Param = struct2table(fetch (ANL.Parameters,'*'));
            min_trials_1D_bin = Param.parameter_value{(strcmp('tongue_tuning_min_trials_1D_bin',Param.parameter_name))};
            number_of_shuffles = Param.parameter_value{(strcmp('tongue_tuning_number_of_shuffles',Param.parameter_name))};

            plot_flag=0;
            
            time_window_duration=0.5;
            t_vec=-3:0.2:2;
            
            smooth_flag=key.smooth_flag;
            smooth_bins=3;
            
            % fetching spikes and video
            
            kk=key;
            
            if strcmp(key.outcome_grouping,'all')
                kk=rmfield(kk,'outcome_grouping');
            end
                        
            if strcmp(key.lick_direction,'left')
                key_lick_direction=EXP.TrialID & (ANL.Video1stLickTrialNormalized & 'lick_horizoffset_relative <0.5');
%                 hist_bins=linspace(0,0.4,5);
            elseif strcmp(key.lick_direction,'right')
                key_lick_direction=EXP.TrialID & (ANL.Video1stLickTrialNormalized & 'lick_horizoffset_relative >=0.5');
%                 hist_bins=linspace(0.6,1,5);
              else
                return;
            end
            
            
            if kk.flag_use_basic_trials==1
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial *   (EXP.TrialName & (ANL.TrialTypeGraphic & 'trialtype_left_and_right_no_distractors=1')) & ANL.Video1stLickTrialNormalized & kk  &  'early_lick="no early"');
            else
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial & ANL.Video1stLickTrialNormalized & kk  &  'early_lick="no early"');
            end
            
            SPIKES=fetchn(rel_spikes & key_lick_direction,'spike_times_go','ORDER BY trial');
            
            if isempty(SPIKES)
                return
            end
            
            rel_video=(ANL.Video1stLickTrialNormalized & kk & rel_spikes ) & key_lick_direction;
            TONGUE=struct2table(fetch(rel_video,'*','ORDER BY trial'));
            number_of_trials=size(TONGUE,1);
            
            if number_of_trials<10
                return
            end
            
            
            % extracting param variable
            VariableNames=TONGUE.Properties.VariableNames';
            var_table_offset=5;
            VariableNames=VariableNames(var_table_offset:18);
            idx_v_name=find(strcmp(VariableNames,kk.tuning_param_name));
            labels=VariableNames{idx_v_name};

            X=TONGUE{:,idx_v_name+var_table_offset-1};
            
            hist_bins=prctile(X,linspace(0,100,5)); %equally occupued bins

            kk.outcome_grouping=key.outcome_grouping;
            kk.time_window_duration=time_window_duration;

            
            % computing tuning for various time windows
            for it=1:1:numel(t_vec)
                t_wnd{it}=[t_vec(it), t_vec(it)+time_window_duration];
            end
            
            trials_vec=1:1:size(TONGUE,1);

            for i_twnd=1:numel(t_wnd)
                kk.time_window_start=t_wnd{i_twnd}(1);
                tongue_tuning_1d_si_shuffled=[];
                
                for i_s=1:1:number_of_shuffles
                    trials_vec_shuffled = trials_vec(randperm(length(trials_vec)));
                    SPIKES_SHUFFLED=SPIKES(trials_vec_shuffled);
                    [~, SI, ~, ~]=  fn_tongue_tuning1D_shuffling (X, SPIKES_SHUFFLED, t_wnd{i_twnd}, hist_bins, min_trials_1D_bin, smooth_bins, labels,smooth_flag);
                    tongue_tuning_1d_si_shuffled(i_s)=SI;
                    
%                     % MLE decoder
%                     fns_tuning=@(x)  interp1(hist_bins_centers,tuning1D_shuffled,x,'linear','extrap');
%                     tol=0.05;
%                     for i_tr=1:1:numel(FR_TRIAL)
%                         fr_tr = FR_TRIAL(i_tr);
%                         mle =@(x) -fr_tr(1)*log(fns_tuning(x))+fns_tuning(x);
%                         mle_real=@(x) real(mle(x)); %debug why this is needed
%                         xest(i_tr) = fminbnd(mle_real,x_est_range_trials(i_tr,1),x_est_range_trials(i_tr,2),optimset('TolX',tol)) ;
%                         %                     xest(i_tr) = fminbnd(mle,0,1,optimset('TolX',tol)) ;
%                     end
%                     ml_error_left(i_s)=nanmean(abs(X(left_trials)-xest(left_trials)'));
%                     ml_error_right(i_s)=nanmean(abs(X(right_trials)-xest(right_trials)'));
                    
                end
                kk.tongue_tuning_1d_si_shuffled=tongue_tuning_1d_si_shuffled;
                kk.tongue_tuning_1d_si_shuffled_mean=nanmean(tongue_tuning_1d_si_shuffled);
                
%                 kk.ml_error_left_shuffled=ml_error_left;
%                 kk.ml_error_left_shuffled_mean=nanmean(ml_error_left);
%                 kk.ml_error_right_shuffled=ml_error_right;
%                 kk.ml_error_right_shuffled_mean=nanmean(ml_error_right);
                
                
                insert(self,kk)
            end
            
        end
    end
    
end


