%{
#
-> EPHYS.Unit
-> ANL.TongueTuningXType
-> ANL.TongueTuningYType
-> ANL.OutcomeType
time_window_start                               : decimal(8,4)              #
->ANL.TongueTuningSmoothFlag
---
pvalue_si_2d=null                       : decimal(8,4)              #p-value of spatial information, computed using shuffled distribution
%}

classdef UnitTongue2DTuningSignificance < dj.Computed
    properties
        keySource = ANL.UnitTongue2DTuningShuffling;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            tongue_tuning_2d_si_shuffled= fetch1(ANL.UnitTongue2DTuningShuffling & key,'tongue_tuning_2d_si_shuffled');
            tongue_tuning_2d_si= fetch1(ANL.UnitTongue2DTuning & key,'tongue_tuning_2d_si');
            if isnan(tongue_tuning_2d_si)
                key.pvalue_si_2d=NaN;
            else
                key.pvalue_si_2d= sum(tongue_tuning_2d_si<=tongue_tuning_2d_si_shuffled)/numel(tongue_tuning_2d_si_shuffled);
            end
            insert(self,key);
            
        end
    end
    
end


