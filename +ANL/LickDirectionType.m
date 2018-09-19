%{
# 
lick_direction                     : varchar(32)                    # 
%}


classdef LickDirectionType < dj.Lookup
    properties
        contents = {
            'left'
            'right'
            'all'
            }
    end
end