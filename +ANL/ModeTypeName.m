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
            'MiddleDelay'                            'Selectivity during middle delay'
            'LateDelay'                             'Selectivity during late delay'
            'Ramping'                               'Non-specific ramping during delay'
            'Movement'                              'Selectivity during movement'
            'Stimulus Orthog.'                              'orthogonal (Gram–Schmidt process)'
            'EarlyDelay Orthog.'                            'orthogonal (Gram–Schmidt process)'
            'LateDelay Orthog.'                            'orthogonal (Gram–Schmidt process)'
            'Ramping Orthog.'                               'orthogonal (Gram–Schmidt process)'
            'Movement Orthog.'                             'orthogonal (Gram–Schmidt process)'
            'Left vs. baseline'    'Mode that differentiate left trajectry in the end of the delay vs. presample period'
            'Right vs. baseline'    'Mode that differentiate right trajectry in the end of the delay vs. presample period'
            
            }
    end
end