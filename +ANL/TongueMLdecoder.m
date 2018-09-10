%{
#
-> EXP.Session
---
ml_performance_left_at_t                           : longblob                  # mean performance of an maximum-likelihood decoder along the trial time, on the first  lick, computed for left licks (left is defined by the horizontal offset at the end of the first lick, not by eventual contact with lickport)
ml_performance_right_at_t                           : longblob                  # mean performance of an maximum-likelihood decoder along the trial time, on the first  lick,  computed for right licks
time_vector_ml                                : longblob                  # time vector with bins for which the performance was computed
%}


classdef TongueMLdecoder < dj.Computed
    properties
        keySource = EXP.Session & EPHYS.TrialSpikes& ANL.Video1stLickTrial %& 'session=8' & 'subject_id=365942'
    end
    methods(Access=protected)
        function makeTuples(self, key)
            tic
            [performance_left,performance_right,time_window_start] = fn_tongue_ML_decoder_lr_separate(key);
            key.ml_performance_left_at_t = performance_left;
            key.ml_performance_right_at_t = performance_right;
            key.time_vector_ml = time_window_start;
            insert(self,key)
            toc
        end
        
    end
end