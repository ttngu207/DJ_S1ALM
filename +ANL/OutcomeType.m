%{
# 
outcome                     : varchar(32)                    # 
%}


classdef OutcomeType < dj.Lookup
    properties
        contents = {
            'hit'
            'miss'
            'ignore'
            'all'
            }
    end
end