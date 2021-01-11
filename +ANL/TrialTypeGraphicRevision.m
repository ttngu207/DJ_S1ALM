%{
#
-> EXP.TrialNameType
---
trialtype_rgb                                               : blob              # trial-type color in rgb
trialtype_plot_order                                        : int               # order in which trial-types should be plotted (first to last)
trialtype_flag_control_left_and_right_and_no_audio_cue=0                     : smallint          # flag include all left trials (with/withour distractors) and basic right trial
%}


classdef TrialTypeGraphicRevision < dj.Computed
    methods(Access=protected)
        function makeTuples(self, key)
            if contains(key.trial_type_name,'Partial')
                key.trialtype_rgb = [0 0 0];
                key.trialtype_plot_order = 0;
            else
                switch key.trial_type_name
                    case 'l'
                        key.trialtype_rgb = [1 0 0];     % [0.96 0.26 0.26] % [1 0 0]  % red
                        key.trialtype_plot_order = 100;
                        key.trialtype_flag_control_left_and_right_and_no_audio_cue=1;
                    case 'r'                        % blue
                        key.trialtype_rgb = [0 0 1];
                        key.trialtype_plot_order = 1;
                        key.trialtype_flag_control_left_and_right_and_no_audio_cue=1;
                    case 'r_NoAudCue'
                        key.trialtype_rgb = [1 0 1];        %  black
                        key.trialtype_plot_order = 2;
                        key.trialtype_flag_control_left_and_right_and_no_audio_cue=1;

                end
                
            end
            
            insert (self,key);
            
        end
    end
end