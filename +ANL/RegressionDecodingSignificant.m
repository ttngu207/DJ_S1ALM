%{
# Decoding tongue kinematic based on the regression mode
-> EXP.Session
-> ANL.TongueTuning1DType
-> ANL.LickDirectionType
-> ANL.OutcomeTypeDecoding
-> ANL.FlagBasicTrialsDecoding
-> ANL.RegressionTime4
---
%}


classdef RegressionDecodingSignificant < dj.Computed
    properties
        
        keySource = ANL.RegressionDecoding;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            p=fetch(ANL.RegressionDecoding & key,'*');
            
            t_for_significance=p.t_for_decoding>=-0.2 & p.t_for_decoding <=0.2;
            
            if sum(p.rsq_linear_regression_t(t_for_significance)>0.2)>0
                insert(self,key);
            end
        end
    end
end