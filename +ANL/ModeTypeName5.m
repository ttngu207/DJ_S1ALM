%{
#
mode_type_name                         : varchar(400)      # mode-type name
---
mode_type_name_description=null        : varchar(4000)     #
%}


classdef ModeTypeName5 < dj.Lookup
    properties
        contents = {
            'LateDelay'                             'Selectivity during late delay, computed using all L/R trials'
            
            'Stimulus Orthog.1'                      'orthogonal (Gram–Schmidt process). Order: LateDelay-Ramping-Stim'
            'Ramping Orthog.1'                       'orthogonal (Gram–Schmidt process). Order: LateDelay-Ramping-Stim'
           
            'ChoiceNV'                                'LateDelay mode computed using both correct and error trials, including distractors'
            'ChoiceMatchedNV'                          'LateDelay mode computed using both correct and error trials - downsamle to match in numbers, including distractors'
        
            }
    end
end