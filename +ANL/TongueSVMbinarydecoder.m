%{
#
-> EXP.Session
-> ANL.OutcomeType
-> ANL.FlagBasicTrials
---
performance_left_at_t                      : longblob                  # mean performance of a binary decoder (center or edge) along the trial time on the first  lick, computed for left licks (left is defined by the horizontal offset at the end of the first lick, not by eventual contact with lickport)
performance_right_at_t                     : longblob                  # mean performance of a binary decoder (center or edge) along the trial time on the first  lick,  computed for right licks
time_vector                                : longblob                  # time vector with bins for which the performance was computed

%}


classdef TongueSVMbinarydecoder < dj.Computed
    properties
        keySource = (EXP.Session & EPHYS.TrialSpikes & ANL.Video1stLickTrial) * (ANL.OutcomeType & 'outcome!="ignore"') * ANL.FlagBasicTrials
    end
    methods(Access=protected)
        function makeTuples(self, key)
            tic
            [time_window_start, performance_left,performance_right] = fn_SVM_tongue_binary(key);
            key.performance_left_at_t = performance_left;
            key.performance_right_at_t = performance_right;
            key.time_vector = time_window_start;
            insert(self,key)
            toc
        end
        
    end
end