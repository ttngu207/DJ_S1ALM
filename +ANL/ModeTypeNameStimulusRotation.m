%{
#
mode_type_name                         : varchar(400)      # mode-type name
---
mode_type_name_description=null        : varchar(4000)     #
%}


classdef ModeTypeNameStimulusRotation < dj.Lookup
    properties
        contents = {
            'Stimulus'                                  'Selectivity during sample period - i.e. response to stimulus, computed using all L/R trials'
            'ChoiceMatched'                             'Selectivity during late delay, computed using all L/R trials'
            'Ramping'                                   ''
            'Ramping Orthog.111'                        'Selectivity during sample period - i.e. response to stimulus, computed using all L/R trials'
            'Stimulus Orthog.111'                       'Selectivity during late delay, computed using all L/R trials'
            
            'Stimulus EarlyDelay'            ''
            'Stimulus LateDelay'             ''
            
            'Stimulus EarlyDelay Orthog.111'            ''
            'Stimulus LateDelay Orthog.111'             ''

                        }
    end
end