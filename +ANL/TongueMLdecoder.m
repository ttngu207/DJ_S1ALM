%{
#
-> EXP.Session
-> ANL.TongueTuningSmoothFlag
-> ANL.OutcomeType
-> ANL.FlagBasicTrials
-> ANL.TongueTuning1DType
---
total_cells_used                                : int                  # total valid cells used for decoding
mld_rmse_left_at_t                           : longblob                  # rmse (root-mean-sequare-error0 of an maximum-likelihood decoder along the trial time, on the first  lick, computed for left licks (left is defined by the horizontal offset at the end of the first lick, not by eventual contact with lickport)
mld_rmse_right_at_t                           : longblob                  # rmse of an maximum-likelihood decoder along the trial time, on the first  lick,  computed for right licks
mld_time_vector                                : longblob                  # time vector with bins for which the performance was computed

%}


classdef TongueMLdecoder < dj.Computed
    properties
        keySource = (EXP.Session & EPHYS.TrialSpikes& ANL.Video1stLickTrialNormalized)  *  (ANL.TongueTuningSmoothFlag & 'smooth_flag=0') * (ANL.OutcomeType & 'outcome_grouping="all"') * (ANL.FlagBasicTrials & 'flag_use_basic_trials=0')  * (ANL.TongueTuning1DType & 'tuning_param_name="lick_horizoffset_relative" or tuning_param_name="lick_rt_video_onset" or tuning_param_name="lick_peak_x"');
    end
    methods(Access=protected)
        function makeTuples(self, key)
            tic
            [rmse_left,rmse_right, time_window_start, total_cells_used] = fn_tongue_ML_decoder_lr_separate(key);
            if ~isempty(total_cells_used)
                key.mld_rmse_left_at_t = rmse_left;
                key.mld_rmse_right_at_t = rmse_right;
                key.mld_time_vector = time_window_start;
                key.total_cells_used = total_cells_used;
                
                insert(self,key)
            end
            toc
        end
        
    end
end