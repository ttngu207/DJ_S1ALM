%{
#
mode_type_name                         : varchar(400)      # mode-type name
---
mode_type_name_description=null        : varchar(4000)     #
%}


classdef ModeTypeName < dj.Lookup
    properties
        contents = {
        'Stimulus'                              'Selectivity during sample period - i.e. response to stimulus'
        'EarlyDelay'                            'Selectivity during early delay'
        'LateDelay'                             'Selectivity during late delay'
        'Ramping'                               'Non-specific ramping during delay'
        'Stimulus orthogonal to LateDelay'      'orthogonal'
        'EarlyDelay orthogonal to LateDelay'    'orthogonal'
        'Ramping orthogonal to LateDelay'       'orthogonal'
        'LateDelay orthogonal to EarlyDelay'    'orthogonal'
        }
    end
end