%{
#
mode_type_name                         : varchar(400)      # mode-type name
---
mode_type_name_description=null        : varchar(4000)     #
%}


classdef ModeTypeName3 < dj.Lookup
    properties
        contents = {
            'Stimulus'                              'Selectivity during sample period - i.e. response to stimulus, computed using all L/R trials'
            'EarlyDelay'                            'Selectivity during early delay, computed using all L/R trials'
            'LateDelay'                             'Selectivity during late delay, computed using all L/R trials'
            'Ramping'                               'Ramping during delay, computed using all L/R trials'
            'Movement'                              'Selectivity during movement, computed using all L/R trials'
            
            'Stimulus Pure'                         'Selectivity during sample period - i.e. response to stimulus, computed using L/R trials without distractors'
            'EarlyDelay Pure'                       'Selectivity during early delay, computed using L/R trials without distractors'
            'LateDelay Pure'                        'Selectivity during late delay, computed using L/R trials without distractors'
            'Ramping Pure'                          'Ramping during delay, computed using L/R trials without distractors'
            'Movement Pure'                         'Selectivity during movement, computed using L/R trials without distractors'
            
            'Stimulus Orthog.1'                      'orthogonal (Gram–Schmidt process). Order: LateDelay-Ramping-Stim'
            'Ramping Orthog.1'                       'orthogonal (Gram–Schmidt process). Order: LateDelay-Ramping-Stim'
            
            'Stimulus Orthog.2'                      'orthogonal (Gram–Schmidt process). Order: LateDelay-Stim-Ramping'
            'Ramping Orthog.2'                       'orthogonal (Gram–Schmidt process). Order: LateDelay-Stim-Ramping'
            
            'LateDelay orthogonal to Stimulus'       ''
            'LateDelay orthogonal to EarlyDelay'     ''
            'LateDelay orthogonal to Movement'       ''
            
            'EarlyDelay orthogonal to Stimulus'      ''
            'EarlyDelay orthogonal to LateDelay'     ''
            'EarlyDelay orthogonal to Ramping'       ''
            
            'Stimulus orthogonal to EarlyDelay'      ''
            'Movement orthogonal to LateDelay'       ''
            
            'Left vs. baseline'                     'Mode that differentiate left trajectry in the end of the delay vs. presample period'
            'Right vs. baseline'                    'Mode that differentiate right trajectry in the end of the delay vs. presample period'
            }
    end
end