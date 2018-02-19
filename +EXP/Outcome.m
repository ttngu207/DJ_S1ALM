%{
# 
outcome                     : varchar(8)                    # 
%}


classdef Outcome < dj.Lookup
    properties
        contents = {
            'hit'
            'miss'
            'ignore'
            }
    end
end