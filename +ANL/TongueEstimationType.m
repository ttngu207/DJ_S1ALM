%{
#
tongue_estimation_type         : varchar(200)                  #
---
tongue_estimation_type_description  : varchar(1000)                 #
%}


classdef TongueEstimationType < dj.Lookup
    properties
        
        contents = {
            'tip'    'tongue tip'
            'center'    'center of mass of  tongue tip'
            };
        
    end
end



