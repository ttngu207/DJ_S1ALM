%{
#
-> EXP.Session
-> ANL.TongueTuning1DType
-> ANL.RegressionTime4
-> ANL.LickDirectionType
---
number_of_trials                                : int
rsq_linear                                  : decimal(8,4)              # rsquare of linear fit
rmse_linear                                  : decimal(8,4)              # root mean square error of linear fit
rmse_mean                                  : decimal(8,4)              # root mean square error with respect to the mean value of the dataponts
rmse_mean_left_right                      : decimal(8,4)              # root mean square error with respect to the mean value of the dataponts, when the mean is computed separately for left and right lick direction, if applicable

%}

classdef TongueVarianceExplainedRegression < dj.Computed
    properties
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            
        end
        
        
        
    end
end



