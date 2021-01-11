%{
# 
nth_lick_direction                     : varchar(32)                    # 
%}


classdef LickDirectionNthType < dj.Lookup
    properties
        contents = {
            'left'
            'right'
            'all'
            }
    end
end