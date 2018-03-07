%{
# S1StimPowerType    
stim_power_type = 'NoStim'              : varchar(100)   # stim power category (e.g. full or mini)
---
stim_power_type_description           : varchar(4000)
%}

classdef S1StimPowerType < dj.Lookup
    properties
        contents = {
            'NoStim' ''
            'Full'   ''
            'FullX2' ''
            'FullX0.5' ''
            'FullPartial' ''
            'Mini' ''
            'Mini(FullX0.5)' ''
            'Mini(FullX0.75)' ''
            }
    end
end