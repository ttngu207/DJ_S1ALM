%{
#
mode_type_name                         : varchar(400)      # mode-type name
---
mode_type_name_description=null        : varchar(4000)     #
%}


classdef ModeTypeNameStimulus < dj.Lookup
    properties
        contents = {
            'Stimulus'                              'Selectivity during sample period - i.e. response to stimulus, computed using all L/R trials'
            'StimulusPreSample'                     'Selectivity during pre sample stimulus'
            'StimulusEarlyDelay'                    'Selectivity during early delay stimulus'
            'StimulusLateDelay'                     'Selectivity during late stimulus'
            'StimulusAverage'                       'Selectivity for stimulus averaged across different time-specific stimuli modes'
            
            'Stimulus Orthog.1'                     'orthogonal (Gram–Schmidt process). Order: LateDelay-Ramping-Stim'
            'StimulusPreSample Orthog.1'            'orthogonal (Gram–Schmidt process). Order: LateDelay-Ramping-Stim'
            'StimulusEarlyDelay Orthog.1'           'orthogonal (Gram–Schmidt process). Order: LateDelay-Ramping-Stim'
            'StimulusLateDelay Orthog.1'            'orthogonal (Gram–Schmidt process). Order: LateDelay-Ramping-Stim'
            'StimulusAverage Orthog.1'              'orthogonal (Gram–Schmidt process). Order: LateDelay-Ramping-Stim'
            }
    end
end