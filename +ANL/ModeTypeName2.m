%{
#
mode_type_name                         : varchar(400)      # mode-type name
---
mode_type_name_description=null        : varchar(4000)     #
%}


classdef ModeTypeName2 < dj.Lookup
    properties
        contents = {
            'LateDelay'                             'Selectivity during late delay'
            'Ramping'                               'Non-specific ramping during delay'
            'Movement'                              'Selectivity during movement'
            'Ramping Orthog.'                        'orthogonal (Gram–Schmidt process)'
            'Movement Orthog.'                       'orthogonal (Gram–Schmidt process)'
            'Left vs. baseline'                     'Mode that differentiate left trajectry in the end of the delay vs. presample period'
            'Right vs. baseline'                      'Mode that differentiate right trajectry in the end of the delay vs. presample period'
            }
    end
end