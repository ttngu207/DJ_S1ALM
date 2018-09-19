%{
#
-> EPHYS.Unit
-> ANL.TongueTuning1DType
-> ANL.OutcomeType
-> ANL.FlagBasicTrials
-> ANL.RegressionTime
-> ANL.LickDirectionType
---
number_of_trials                                : int
mean_fr_window                                  : decimal(8,4)              #  mean fr at this time window
regression_coeff_b1                             : decimal(8,4)              # linear regression coefficient   tongue kinematic =b1 + b2*fr
regression_coeff_b2                             : decimal(8,4)              # linear regression coefficient
regression_rsq                                  : decimal(8,4)              # coefficient of determination
regression_pvalue                               : decimal(8,4)              # p-value of the  F-test of the overall significance of the regression model
time_window_start                               : decimal(8,4)              #
time_window_duration                            : decimal(8,4)              #

%}

classdef RegressionTongueSingleUnit < dj.Computed
    properties
        keySource = ((EPHYS.Unit & 'unit_quality!="multi"' & (EPHYS.UnitCellType & 'cell_type="PYR" or cell_type="FS"')) & ANL.Video1stLickTrialNormalized)  * (ANL.OutcomeType & 'outcome_grouping="all"') * (ANL.FlagBasicTrials & 'flag_use_basic_trials=0')  * (ANL.TongueTuning1DType & 'tuning_param_name="lick_horizoffset_relative" or tuning_param_name="lick_rt_video_onset" or tuning_param_name="lick_peak_x"') * ANL.RegressionTime * ANL.LickDirectionType;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            % params
            time_window_duration=0.25;
            t_vec=fetch1(ANL.RegressionTime & key,'regression_time_start');
            time_window_start=t_vec;
            
            % fetching spikes and video
            
            kk=key;
            
            if strcmp(key.outcome_grouping,'all')
                kk=rmfield(kk,'outcome_grouping');
            end
            
             if strcmp(key.lick_direction,'left')
                key_lick_direction=EXP.TrialID & (ANL.Video1stLickTrialNormalized & 'lick_horizoffset_relative <0.4');
            elseif strcmp(key.lick_direction,'right')
                key_lick_direction=EXP.TrialID & (ANL.Video1stLickTrialNormalized & 'lick_horizoffset_relative >0.6');
            else
                key_lick_direction=EXP.TrialID & (ANL.Video1stLickTrialNormalized);
             end
            
            
            if kk.flag_use_basic_trials==1
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial *   (EXP.TrialName & (ANL.TrialTypeGraphic & 'trialtype_left_and_right_no_distractors=1')) & ANL.Video1stLickTrialNormalized & kk  &  'early_lick="no early"');
            else
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial & ANL.Video1stLickTrialNormalized & kk  &  'early_lick="no early"');
            end
            
            SPIKES=fetch(rel_spikes & key_lick_direction,'*','ORDER BY trial');
            
            if isempty(SPIKES)
                return
            end
            
            rel_video=(ANL.Video1stLickTrialNormalized & kk & rel_spikes ) &  key_lick_direction;
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
            
            Y=TONGUE{:,idx_v_name+var_table_offset-1};
            
            kk.outcome_grouping=key.outcome_grouping;
            kk.time_window_duration=time_window_duration;
            kk.number_of_trials=number_of_trials;
            
            
            % computing tuning for various time windows
            for it=1:1:numel(t_vec)
                t_wnd{it}=[t_vec(it), t_vec(it)+time_window_duration];
            end
            
            for i_twnd=1:numel(t_wnd)
                current_twnd= t_wnd{i_twnd};
                kk.time_window_start=current_twnd(1);
                
                for i_tr=1:1:numel(SPIKES)
                    
                    spk_t=SPIKES(i_tr).spike_times_go;
                    spk(i_tr)=sum(spk_t>current_twnd(1) & spk_t<current_twnd(2));%/diff(t_wnd);
                end
                FR_TRIAL=spk/time_window_duration;
                
                number_of_spikes = sum(spk);
                kk.mean_fr_window=(number_of_spikes/time_window_duration)/numel(SPIKES);
                
                Predictor = [ones(size(SPIKES)) FR_TRIAL'];
                [beta,~,~,~,stats]= regress(Y,Predictor); %stats [Rsq, F-statistic, p-value, and an estimate of the error variance.]
                yCalc1 =  beta(1) + beta(2)*FR_TRIAL';
                Rsq = 1 - sum((Y - yCalc1).^2)/sum((Y - mean(Y)).^2); %coefficient of determination
                
                
                kk.regression_coeff_b1=beta(1);
                kk.regression_coeff_b2=beta(2);
                kk.regression_rsq=Rsq;
                if isnan(stats(3))
                    kk.regression_pvalue=1;
                else
                    kk.regression_pvalue=stats(3);
                end
                
                %                 kk.regression_coeff=beta;
                %                                        yCalc1 =  beta(1) + beta(2)*FR_TRIAL';
                %
                %                 b1 = FR_TRIAL'\Y;
                %
                %                yCalc1 = b1*FR_TRIAL';
                % scatter(FR_TRIAL',Y)
                % hold on
                % plot(FR_TRIAL',yCalc1)
                % xlabel('Population of state')
                % ylabel('Fatal traffic accidents per state')
                % title('Linear Regression Relation Between Accidents & Population')
                % grid on
                
                
                
                insert(self,kk)
            end
            
            
            
        end
    end
    
end


