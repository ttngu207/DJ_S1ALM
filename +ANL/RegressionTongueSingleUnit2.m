%{
#
-> EPHYS.Unit
-> ANL.TongueTuning1DType
-> ANL.OutcomeType
-> ANL.FlagBasicTrials
-> ANL.RegressionTime2
-> ANL.LickDirectionType
---
number_of_trials                                : int
mean_fr_window                                  : decimal(8,4)              #  mean fr at this time window
regression_coeff_b1                             : decimal(8,4)              # linear regression coefficient   tongue kinematic =b1 + b2*fr
regression_coeff_b2                             : decimal(8,4)              # linear regression coefficient
regression_rsq                                  : decimal(8,4)              # coefficient of determination
regression_p                                    : decimal(8,4)              # regression p value
regression_coeff_b2_normalized                  : decimal(8,4)              # witht the fr normalized, so that it can be compared across cells
time_window_start                               : decimal(8,4)              #
time_window_duration                            : decimal(8,4)              #

%}

classdef RegressionTongueSingleUnit2 < dj.Computed
    properties
        keySource = ((EPHYS.Unit & 'unit_quality!="multi"' & (EPHYS.UnitCellType & 'cell_type="PYR" or cell_type="FS"')) & ANL.Video1stLickTrial)  * (ANL.OutcomeType & 'outcome_grouping="all"') * (ANL.FlagBasicTrials & 'flag_use_basic_trials=0')  * (ANL.TongueTuning1DType & 'tuning_param_name="lick_horizoffset_relative" or tuning_param_name="lick_rt_video_onset" or tuning_param_name="lick_peak_x"') * ANL.RegressionTime2 * ANL.LickDirectionType;
%                 keySource = ((EPHYS.Unit & 'unit_quality!="multi"' & (EPHYS.UnitCellType & 'cell_type="PYR" or cell_type="FS"')) & ANL.Video1stLickTrial)  * (ANL.OutcomeType & 'outcome_grouping="all"') * (ANL.FlagBasicTrials & 'flag_use_basic_trials=0')  * (ANL.TongueTuning1DType & 'tuning_param_name="lick_rt_video_onset"') * ANL.RegressionTime2 * ANL.LickDirectionType;
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
            % params
            num_repeat=10;
            fraction_train=0.50; % i.e. - compute regression on that fraction of trials, repeat num_repeat, and then average the regression coefficients
            time_window_duration=0.2;
            t_vec=fetch1(ANL.RegressionTime2 & key,'regression_time_start');
            time_window_start=t_vec;
            
            % fetching spikes and video
            
            kk=key;
            
            if strcmp(key.outcome_grouping,'all')
                kk=rmfield(kk,'outcome_grouping');
            end
            
            if strcmp(key.lick_direction,'left')
                key_lick_direction=EXP.TrialID & (ANL.LickDirectionTrial & key);
            elseif strcmp(key.lick_direction,'right')
                key_lick_direction=EXP.TrialID & (ANL.LickDirectionTrial & key);
            else
                key_lick_direction=EXP.TrialID & (ANL.Video1stLickTrial);
            end
            
            
            if kk.flag_use_basic_trials==1
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial *   (EXP.TrialName & (ANL.TrialTypeGraphic & 'trialtype_left_and_right_no_distractors=1')) & ANL.Video1stLickTrial & kk  &  'early_lick="no early"');
            else
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial & ANL.Video1stLickTrial & kk  &  'early_lick="no early"');
            end
            
            SPIKES=fetch(rel_spikes & key_lick_direction,'*','ORDER BY trial');
            
            if isempty(SPIKES)
                return
            end
            
            rel_video=(ANL.Video1stLickTrial & kk & rel_spikes ) &  key_lick_direction;
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
                
                
                %remove outliers
                idx_outlier=isoutlier(Y);
                Y(idx_outlier)=[];
                FR_TRIAL(idx_outlier)=[];
                
                Y=zscore(Y);
                
                
                Predictor = [ones(size(FR_TRIAL,2),1) FR_TRIAL'];
                Predictor_normalized = [ones(size(FR_TRIAL,2),1) zscore(FR_TRIAL)'];
                %                 Predictor =FR_TRIAL';
                %                 Predictor_normalized = FR_TRIAL'/max([FR_TRIAL,eps]);
                
                
                num_trials=numel(FR_TRIAL);
                for i_repeat=1:1:num_repeat
                    train_set=randsample(num_trials,round(num_trials*fraction_train));
                    train_Y=Y(train_set);
                    
                    train_Predictor=Predictor(train_set,:);
                    %                     [beta(:,i_repeat),stats]= robustfit(train_Predictor,train_Y);
                    [beta(:,i_repeat),~,~,~,stats]= regress(train_Y,train_Predictor);
                    Rsq(i_repeat) = stats(1);  %stats [Rsq, F-statistic, p-value, and an estimate of the error variance.]
                    regression_p(i_repeat)=stats(3);
                    
                    train_Predictor_normalized=Predictor_normalized(train_set,:);
                    [beta_normalized(:,i_repeat),~,~,~,~]= regress(train_Y,train_Predictor_normalized);
                    
                    %                     [beta_normalized(:,i_repeat)]= robustfit(train_Predictor_normalized,train_Y);
                    
                    %                     yCalc1 =  beta(1,i_repeat) + beta(2,i_repeat)*train_Predictor;
                    %                     Rsq= 1 - sum((train_Y - yCalc1).^2)/sum((train_Y - mean(train_Y)).^2); %coefficient of determination
                end
                
                kk.regression_coeff_b1=nanmean(beta(1,:));
                kk.regression_coeff_b2=nanmean(beta(2,:));
                kk.regression_rsq=nanmean(Rsq);
                p= nanmean(regression_p);
                if isnan(p)
                    kk.regression_p=1;
                else
                    kk.regression_p=p;
                end
                kk.regression_coeff_b2_normalized=nanmean(beta_normalized(2,:));
                
                
                
                %                 if isnan(stats(3))
                %                     kk.regression_pvalue=1;
                %                 else
                %                     kk.regression_pvalue=stats(3);
                %                 end
                
                %                 kk.regression_coeff=beta;
                %                                        yCalc1 =  beta(1) + beta(2)*FR_TRIAL';
                %
                %                 b1 = FR_TRIAL'\Y;
                %
                %                yCalc1 = b1*FR_TRIAL';
%                 scatter(FR_TRIAL',Y)
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


