%{
#
early_lick                  : varchar(32)                   #
%}


classdef EarlyLick < dj.Lookup
    properties
        contents = {
            'early'
            'early, presample only'
            'no early'
            }
    end
end