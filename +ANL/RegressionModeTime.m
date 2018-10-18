%{
#
regression_time_start                   : decimal(8,4)                    #

%}


classdef RegressionModeTime < dj.Lookup
    properties
        contents = {
            -0.2000
            0
            0.2000
            }
    end
end