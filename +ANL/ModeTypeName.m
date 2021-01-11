%{
#
mode_type_name                         : varchar(400)      # mode-type name
---
mode_type_name_description=null        : varchar(4000)     #
%}


classdef ModeTypeName < dj.Lookup
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
            'Choice'                                'LateDelay mode computed using both correct and error trials, including distractors'
            'ChoiceMatched'                          'LateDelay mode computed using both correct and error trials - downsamle to match in numbers, including distractors'
            'ChoiceNV'                                'LateDelay mode computed using both correct and error trials, including distractors, not divided by variance'
            'ChoiceMatchedNV'                          'LateDelay mode computed using both correct and error trials - downsamle to match in numbers, including distractors, not divided by variance'

            'Delay'                                'Selectivity during the entire Delay, computed using all L/R trials'
            
             'Stimulus Orthog.11'                      'orthogonal (Gram–Schmidt process). Order: LateDelay-Ramping-Stim'
            'Ramping Orthog.11'                       'orthogonal (Gram–Schmidt process). Order: LateDelay-Ramping-Stim'
            
            'Stimulus Orthog.22'                      'orthogonal (Gram–Schmidt process). Order: LateDelay-Stim-Ramping'
            'Ramping Orthog.22'                       'orthogonal (Gram–Schmidt process). Order: LateDelay-Stim-Ramping'

             'Stimulus Orthog.111'                      'orthogonal (Gram–Schmidt process). Order: LateDelay-Ramping-Stim'
            'Ramping Orthog.111'                       'orthogonal (Gram–Schmidt process). Order: LateDelay-Ramping-Stim'
            
            'Stimulus Orthog.222'                      'orthogonal (Gram–Schmidt process). Order: LateDelay-Stim-Ramping'
            'Ramping Orthog.222'                       'orthogonal (Gram–Schmidt process). Order: LateDelay-Stim-Ramping'

             'Stimulus Pure Orthog.1'                      'orthogonal (Gram–Schmidt process). Order: LateDelay-Ramping-Stim'
            'Ramping Pure Orthog.1'                       'orthogonal (Gram–Schmidt process). Order: LateDelay-Ramping-Stim'
            
            'Stimulus Pure Orthog.2'                      'orthogonal (Gram–Schmidt process). Order: LateDelay-Stim-Ramping'
            'Ramping Pure Orthog.2'                       'orthogonal (Gram–Schmidt process). Order: LateDelay-Stim-Ramping'
            
            'LateDelay Selective'                       ''

            
                        'ChoiceMatched2'                          ''
                        'Choice2'                           ''
                        'Choice3'                         ''
                        'Choice4'                           ''
                        
                                                'ChoiceMatched Pure'                          ''
                        'Choice Pure'                           ''
             'Stimulus Orthog.111'                      'orthogonal (Gram–Schmidt process). Order: LateDelay-Ramping-Stim'
            'Ramping Orthog.111'                       'orthogonal (Gram–Schmidt process). Order: LateDelay-Ramping-Stim'

                        'Stimulus EarlyDelay Orthog.111'                      'stimulus mode computed during early delay distractor stimulation, orthogonal (Gram–Schmidt process). Order: LateDelay-Ramping-Stim'
                        'Stimulus LateDelay Orthog.111'                      'stimulus mode computed during late delay distractor stimulation, orthogonal (Gram–Schmidt process). Order: LateDelay-Ramping-Stim'

                        }
    end
end