%{
# 
early_lick                  : varchar(32)                   # 
%}


classdef EarlyLick < dj.Lookup
    properties
        contents = {
            'early'
            'no early'
            }
    end
end