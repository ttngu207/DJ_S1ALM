%{
# S1StimPowerType    - full or mini
stim_power_type = 'none'              : varchar(24)   # stim power category (e.g. full or mini)
%}

classdef S1StimPowerType < dj.Lookup
    properties
        contents = {
            'none'
            'full'
            'mini'
            'other'
            }
    end
end