%{
# Decoding tongue kinematic based on the regression mode
-> EXP.Session
-> ANL.TongueTuning1DType
-> ANL.LickDirectionType
-> ANL.OutcomeTypeDecoding
-> ANL.FlagBasicTrialsDecoding
-> ANL.RegressionTime25
---
rsq_linear_regression_t                         : blob       # rsquare (coefficient of determination) based on linear regression computed at one time and projected at various times
t_for_decoding                                  : blob       #
%}


classdef RegressionDecodingAllLicksMode2 < dj.Computed
    properties
        
        keySource = ((EXP.Session  & EPHYS.Unit & ANL.VideoNthLickTrial) *ANL.LickDirectionType *  (ANL.FlagBasicTrialsDecoding & 'flag_use_basic_trials_decoding=0') * (ANL.OutcomeTypeDecoding & 'outcome_trials_for_decoding="all"')* (ANL.TongueTuning1DType & 'tuning_param_name="lick_horizoffset" or tuning_param_name="lick_rt_video_onset" or tuning_param_name="lick_peak_x"') * ANL.RegressionTime25);
    end
    methods(Access=protected)
        function makeTuples(self, key)
            k=key;
            
            k.tongue_estimation_type='tip';
            
            if k.flag_use_basic_trials_decoding==1
                k.trialtype_left_and_right_no_distractors=1;
            end
            
            if ~strcmp(k.outcome_trials_for_decoding,'all')
                k.outcome=k.outcome_trials_for_decoding;
            end
            
            
            rel_behav= (EXP.TrialID & ((EXP.BehaviorTrial * EXP.TrialName  * ANL.TrialTypeGraphic* ANL.VideoNthLickTrial	)   & k  & 'early_lick="no early"' )) ;
            if rel_behav.count==0
                return
            end
            
            rel_all_lick= (ANL.VideoNthLickTrial & k ) & rel_behav & ANL.VideoTongueValidRTTrial;
            
            fn_regression_decoding_all_licks_mode2 (key,self, rel_all_lick)
            
        end
    end
end