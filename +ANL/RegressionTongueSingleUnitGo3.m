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

classdef RegressionTongueSingleUnitGo3 < dj.Computed
    properties
        keySource = ((EPHYS.Unit & 'unit_quality!="multi"' & (EPHYS.UnitCellType & 'cell_type="PYR"')) & ANL.Video1stLickTrial)  * (ANL.OutcomeType & 'outcome_grouping="all"') * (ANL.FlagBasicTrials & 'flag_use_basic_trials=0')  * (ANL.TongueTuning1DType & 'tuning_param_name="lick_horizoffset" or tuning_param_name="lick_rt_video_onset" or tuning_param_name="lick_peak_x"') * ANL.RegressionTime33 * (ANL.LickDirectionType & 'lick_direction="left" or lick_direction="right"');
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
            % params
            num_repeat=10;
            fraction_train=0.50; % i.e. - compute regression on that fraction of trials, repeat num_repeat, and then average the regression coefficients
            time_window_duration=0.1;
            t_vec=fetch1(ANL.RegressionTime2 & key,'regression_time_start');
            
            % fetching spikes and video
            
            kk=key;
            
            if strcmp(key.outcome_grouping,'all')
                kk=rmfield(kk,'outcome_grouping');
            end
            
            key_lick_direction=EXP.TrialID & (ANL.LickDirectionTrial & key);            
            
            if kk.flag_use_basic_trials==1
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial *   (EXP.TrialName & (ANL.TrialTypeGraphic & 'trialtype_left_and_right_no_distractors=1')) & ANL.Video1stLickTrial  & kk & ANL.VideoTongueValidRTTrial &  'early_lick="no early"');
            else
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial & ANL.Video1stLickTrial & kk & ANL.VideoTongueValidRTTrial  &  'early_lick="no early"');
            end
            
            SPIKES=fetch(rel_spikes & key_lick_direction,'*','ORDER BY trial');
            
            if isempty(SPIKES)
                return
            end
            
            rel_video=(ANL.Video1stLickTrial & kk & rel_spikes ) &  key_lick_direction;
            if rel_video.count<4
                return
            end
            TONGUE=struct2table(fetch(rel_video,'*','ORDER BY trial'));
            
            % extracting param variable
            VariableNames=TONGUE.Properties.VariableNames';
            idx_v_name=find(strcmp(VariableNames,kk.tuning_param_name));
            Y=TONGUE{:,idx_v_name};
            
%             fn_regression_tongue_singleunit2  (Y, SPIKES, key,kk, time_window_duration, t_vec, num_repeat, fraction_train, self);
                        fn_regression_tongue_singleunit3  (Y, SPIKES, key,kk, time_window_duration, t_vec, num_repeat, fraction_train, self);

            
            
        end
    end
    
end


