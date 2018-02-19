%{
# 
early_lick                  : varchar(12)                   # 
%}


classdef EarlyLick < dj.Lookup
    properties
        contents = {
            'early'
            'no early'
            }
    end
end