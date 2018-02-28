%{
#
early_lick                  : varchar(32)                   #
---
early_lick_description      : varchar(4000)                   #
%}


classdef EarlyLick < dj.Lookup
    properties
        contents = {
            'early' 'early lick during sample and/or delay'
            'early, presample only' 'early lick in the presampe period, after the onset of the sceduled wave but before the sample period'
            'no early' ''
            }
    end
end