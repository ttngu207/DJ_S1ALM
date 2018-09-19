%{
#
regression_time_start                   : decimal(8,4)                    #

%}


classdef RegressionTime < dj.Lookup
    properties
        contents = {
            -3.0000
            -2.7500
            -2.5000
            -2.2500
            -2.0000
            -1.7500
            -1.5000
            -1.2500
            -1.0000
            -0.7500
            -0.5000
            -0.2500
            0
            0.2500
            0.5000
            0.7500
            1.0000
            1.2500
            1.5000
            1.7500
            2.0000
            }
    end
end