%{
#
-> EPHYS.Unit
-> ANL.TongueTuning1DType
-> ANL.OutcomeType
-> ANL.TongueTuningSmoothFlag
-> ANL.FlagBasicTrials
-> ANL.LickDirectionType
time_window_start                               : decimal(8,4)              #
---
time_window_duration                           : decimal(8,4)              #
pvalue_si_1d=null                       : decimal(8,4)              #p-value of spatial information, computed using shuffled distribution
tongue_tuning_1d_si_relative_to_shuffle=null                     : decimal(8,4)
%}

classdef UnitTongue1DTuningSignificanceGo < dj.Computed
    properties
        keySource = ANL.UnitTongue1DTuningShufflingGo;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            tongue_tuning_1d_si_shuffled= fetch1(ANL.UnitTongue1DTuningShufflingGo & key,'tongue_tuning_1d_si_shuffled');
            tongue_tuning_1d_si_shuffled_mean= fetch1(ANL.UnitTongue1DTuningShufflingGo & key,'tongue_tuning_1d_si_shuffled_mean');
            tongue_tuning_1d_si= fetch1(ANL.UnitTongue1DTuning & key,'tongue_tuning_1d_si');
            
            if isnan(tongue_tuning_1d_si)
                key.pvalue_si_1d=NaN;
                key.tongue_tuning_1d_si_relative_to_shuffle=NaN;
            else
                key.pvalue_si_1d= sum(tongue_tuning_1d_si<=tongue_tuning_1d_si_shuffled)/numel(tongue_tuning_1d_si_shuffled);
                key.tongue_tuning_1d_si_relative_to_shuffle=tongue_tuning_1d_si-tongue_tuning_1d_si_shuffled_mean;
            end
            
            insert(self,key);
            
        end
    end
    
end


