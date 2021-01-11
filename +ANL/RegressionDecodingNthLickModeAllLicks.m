%{
# Decoding tongue kinematic based on the regression mode
-> EXP.Session
-> ANL.TongueTuning1DType
-> ANL.LickDirectionType
-> ANL.OutcomeTypeDecoding
-> ANL.FlagBasicTrialsDecoding
-> ANL.RegressionTime25
lick_number              : double                            # the lick after the go cue (first lick, second lick, etc)
---
rsq_linear_regression_t                         : blob       # rsquare (coefficient of determination) based on linear regression computed at one time and projected at various times
t_for_decoding                                  : blob       #
%}


classdef RegressionDecodingNthLickModeAllLicks < dj.Computed
    properties
        
        keySource = (EXP.Session  & EPHYS.Unit & ANL.Video1stLickTrial) *ANL.LickDirectionType *  ANL.FlagBasicTrialsDecoding* ANL.OutcomeTypeDecoding* (ANL.TongueTuning1DType & 'tuning_param_name="lick_horizoffset" or tuning_param_name="lick_rt_video_onset" or tuning_param_name="lick_peak_x"')*ANL.RegressionTime25;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            k=key;
            k.regression_time_start=round(0,4);
            
            
            
            %             if strcmp(k.lick_direction,'all')
            %                 k=rmfield(k,'lick_direction');
            %             end
            
            
            k.tongue_estimation_type='tip';
            
            if k.flag_use_basic_trials_decoding==1
                k.trialtype_left_and_right_no_distractors=1;
            end
            
            if ~strcmp(k.outcome_trials_for_decoding,'all')
                k.outcome=k.outcome_trials_for_decoding;
            end
            
            
            
            rel_behav= EXP.TrialID & ((EXP.BehaviorTrial * EXP.TrialName  * ANL.TrialTypeGraphic* ANL.VideoNthLickTrial)   & k  & 'early_lick="no early"' ) & ANL.RegressionProjTrialGo & ANL.VideoTongueValidRTTrial ;
            if rel_behav.count==0
                return
            end
            
            rel_all_lick= (ANL.VideoNthLickTrial & key ) & rel_behav;
            max_lick=max(fetchn(rel_all_lick,'lick_number'));
            
            for i_l=1:1:max_lick
                key.lick_number=i_l;
                rel_Nth_lick = EXP.TrialID & (rel_all_lick& key);
%                 temp_rel_lick.count
            
                fn_regression_decoding_lick_number2 (key,self, rel_Nth_lick)
            end
        end
    end
end