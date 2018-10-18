%{
#
regression_time_start                   : decimal(8,4)                    #

%}


classdef RegressionTime3 < dj.Lookup
    properties
        contents = {
            -0.5000
            -0.4000
            -0.3000
            -0.2000
            -0.1000
            0
            0.1000
            0.2000
            0.3000
            0.4000
            0.5000
            }
    end
end