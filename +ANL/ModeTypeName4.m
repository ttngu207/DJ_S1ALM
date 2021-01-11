%{
#
mode_type_name                         : varchar(400)      # mode-type name
---
mode_type_name_description=null        : varchar(4000)     #
%}


classdef ModeTypeName4 < dj.Lookup
    properties
        contents = {
            'Stimulus'                              'Selectivity during sample period - i.e. response to stimulus, computed using all L/R trials'
            'Delay'                             'Selectivity during late delay, computed using all L/R trials'
            'Ramping'                               'Ramping during delay, computed using all L/R trials'
            
                      
            'Stimulus Orthog.1'                      'orthogonal (Gram–Schmidt process). Order: Delay-Ramping-Stim'
            'Ramping Orthog.1'                       'orthogonal (Gram–Schmidt process). Order: Delay-Ramping-Stim'
            
            'Stimulus Orthog.2'                      'orthogonal (Gram–Schmidt process). Order: ChoiceNV-Stim-Ramping'
            'Ramping Orthog.2'                       'orthogonal (Gram–Schmidt process). Order: ChoiceNV-Stim-Ramping'
            
            'ChoiceNV'                                'LateDelay mode computed using both correct and error trials, including distractors, not divided by variance'
            'ChoiceMatchedNV'                          'LateDelay mode computed using both correct and error trials - downsamle to match in numbers, including distractors, not divided by variance'

            }
    end
end