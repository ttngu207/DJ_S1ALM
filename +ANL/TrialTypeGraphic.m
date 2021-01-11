%{
#
-> EXP.TrialNameType
---
trialtype_rgb                                               : blob              # trial-type color in rgb
trialtype_plot_order                                        : int               # order in which trial-types should be plotted (first to last)
trialtype_flag_standard                                     : smallint          # flag indicating whether a trial type is standard (1) or special (0)
trialtype_flag_mini=0                                       : smallint          # flag include in display set (1) or not(0)
trialtype_flag_full=0                                       : smallint          # flag include in display set (1) or not(0)
trialtype_flag_full_late=0                                  : smallint          # flag include in display set (1) or not(0)
trialtype_flag_left_and_control_right=0                     : smallint          # flag include all left trials (with/withour distractors) and basic right trial
trialtype_flag_left_and_control_right_nopresample=0         : smallint          # flag include all left trials (with/withour distractors) and basic right trial; does not include presample trials
trialtype_flag_left_and_control_right_nopresample_nosample=0         : smallint          # flag include all left trials (with/withour distractors) and basic right trial; does not include presample trials or sample distractors
trialtype_flag_left_full_nopresample=0                      : smallint          # flag include all left trials (with/without full distractors); does not include presample trials
trialtype_flag_right_and_control_left=0                     : smallint          # flag include all right trials (with/without distractors) and basic left trial
trialtype_flag_right_full_nopresample_and_control_left=0    : smallint          # flag include right trials (with full distractors), no presample, and basic left trial
trialtype_flag_right_full_only_presample_and_control_left=0 : smallint          # flag include full distractors presample trial , and basic left and right trial
trialtype_flag_double_sample_amplitude=0                    : smallint          # flag include basic right and left trials, as well as trials with  double sample stimulus values
trialtype_flag_left_stim_full =0                            : smallint          # trials with full stimuli (on left trials) and also right basic trial
trialtype_flag_left_stim_full_nopresample =0                : smallint          # trials with full stimuli (on left trials) and also right basic trial; ; does not include presample trials
trialtype_flag_left_stim_mini =0                            : smallint          # trials with mini stimuli (on left trials)
trialtype_flag_left_stim_mini_nopresample =0                : smallint          # trials with mini stimuli (on left trials); does not include presample trials
trialtype_flag_left_stim_mini_and_control_right =0          : smallint          # trials with mini stimuli (on left trials) and also right basic trial
trialtype_flag_left_stim_mini_nopresample_and_control_right =0 : smallint          # trials with mini stimuli (on left trials) and also right basic trial; does not include presample trials
trialtype_flag_left_full_only_presample_and_control_right=0 : smallint          # flag include full distractors presample trial , and basic left and right trial
trialtype_left_and_right_no_distractors=0                   : smallint          # only pure left and right trials (without any distractors)
trialtype_no_presample=0                   : smallint          #all trial-types withpout pre-sample stimulation
trialtype_flag_all_left=0                     : smallint          # flag all left trials(including distractors)
trialtype_flag_right_early_delay_and_control_pure=0 : smallint          # flag include full distractors early-delay trial , and basic left and right trial
trialtype_flag_mini_sample_and_earlydelay_and_control_pure=0 : smallint          # flag include mini distractors at sample and early-delay trial, and basic left and right trials
trialtype_flag_left_stim_full_nopresample_no_right =0                : smallint          # trials with full stimuli (on left trials) ; ; does not include presample trials and no right trials

trialtype_flag_left_right_pure_and_early_delay_full_left =0                : smallint          #
trialtype_flag_left_right_pure_and_late_delay_full_left =0                : smallint          #

%}


classdef TrialTypeGraphic < dj.Computed
    methods(Access=protected)
        function makeTuples(self, key)
            if contains(key.trial_type_name,'Partial')
                key.trialtype_rgb = [0 0 0];
                key.trialtype_plot_order = 0;
                key.trialtype_flag_standard = 0;
            else
                switch key.trial_type_name
                    case 'l'
                        key.trialtype_rgb = [1 0 0];     % [0.96 0.26 0.26] % [1 0 0]  % red
                        key.trialtype_plot_order = 100;
                        key.trialtype_flag_standard = 1;
                        key.trialtype_flag_mini = 1;
                        key.trialtype_flag_full=1;
                        key.trialtype_flag_full_late = 1;
                        key.trialtype_flag_left_and_control_right = 1;
                        key.trialtype_flag_left_and_control_right_nopresample=1;
                        key.trialtype_flag_left_and_control_right_nopresample_nosample=1;
                        key.trialtype_flag_right_and_control_left = 1;
                        key.trialtype_flag_double_sample_amplitude=1;
                        key.trialtype_flag_left_stim_full =1;
                        key.trialtype_flag_left_stim_full_nopresample =1;
                        key.trialtype_flag_left_stim_mini =1;
                        key.trialtype_flag_left_stim_mini_nopresample=1;
                        key.trialtype_flag_left_stim_mini_and_control_right =1;
                        key.trialtype_flag_left_stim_mini_nopresample_and_control_right=1;
                        key.trialtype_flag_left_full_nopresample=1;
                        key.trialtype_flag_right_full_nopresample_and_control_left=1;
                        key.trialtype_flag_right_full_only_presample_and_control_left=1;
                        key.trialtype_flag_left_full_only_presample_and_control_right=1;
                        key.trialtype_left_and_right_no_distractors=1;
                        key.trialtype_no_presample=1;
                        key.trialtype_flag_all_left=1;
                        key.trialtype_flag_right_early_delay_and_control_pure=1;
                        key.trialtype_flag_mini_sample_and_earlydelay_and_control_pure=1;
                        key.trialtype_flag_left_stim_full_nopresample_no_right=1;
                        key.trialtype_flag_left_right_pure_and_early_delay_full_left=1;
                        key.trialtype_flag_left_right_pure_and_late_delay_full_left=1;
                    case 'l_-0.8Full'
                        key.trialtype_rgb = [0 0.13 0.13]; % [0.9 0.8 0]  % dark-yellow
                        key.trialtype_plot_order = 3;
                        key.trialtype_flag_standard = 1;
                        key.trialtype_flag_full=1;
                        key.trialtype_flag_full_late = 1;
                        key.trialtype_flag_left_and_control_right = 1;
                        key.trialtype_flag_left_and_control_right_nopresample=1;
                        key.trialtype_flag_left_and_control_right_nopresample_nosample=1;
                        key.trialtype_flag_left_stim_full =1;
                        key.trialtype_flag_left_stim_full_nopresample =1;
                        key.trialtype_flag_left_full_nopresample=1;
                        key.trialtype_no_presample=1;
                        key.trialtype_flag_all_left=1;
                        key.trialtype_flag_left_stim_full_nopresample_no_right=1;
                        key.trialtype_flag_left_right_pure_and_late_delay_full_left=1;
                    case 'l_-0.8Mini'
                        %                         key.trialtype_rgb = [1 1 0];        % yellow
                        key.trialtype_rgb = [0 0.13 0.13]; %[0.9 0.8 0];    % dark-yellow
                        key.trialtype_plot_order = 4;
                        key.trialtype_flag_standard = 1;
                        key.trialtype_flag_mini = 1;
                        key.trialtype_flag_left_and_control_right = 1;
                        key.trialtype_flag_left_and_control_right_nopresample = 1;
                        key.trialtype_flag_left_and_control_right_nopresample_nosample=1;
                        key.trialtype_flag_left_stim_mini =1;
                        key.trialtype_flag_left_stim_mini_nopresample=1;
                        key.trialtype_flag_left_stim_mini_and_control_right =1;
                        key.trialtype_flag_left_stim_mini_nopresample_and_control_right=1;
                        key.trialtype_no_presample=1;
                        key.trialtype_flag_all_left=1;
                        
                    case 'l_-1.6Full'
                        key.trialtype_rgb = [0.5 0.5 0.5]; %error [1 0.71 0.46];  %[1 0.5 0.3]  % orange
                        key.trialtype_plot_order = 5;
                        key.trialtype_flag_standard = 1;
                        key.trialtype_flag_full=1;
                        key.trialtype_flag_left_and_control_right = 1;
                        key.trialtype_flag_left_and_control_right_nopresample=1;
                        key.trialtype_flag_left_and_control_right_nopresample_nosample=1;
                        key.trialtype_flag_left_stim_full =1;
                        key.trialtype_flag_left_stim_full_nopresample =1;
                        key.trialtype_flag_left_full_nopresample=1;
                        key.trialtype_no_presample=1;
                        key.trialtype_flag_all_left=1;
                        key.trialtype_flag_left_stim_full_nopresample_no_right=1;
                        key.trialtype_flag_left_right_pure_and_early_delay_full_left=1;
                    case 'l_-1.6Full_-0.8Full'
                        key.trialtype_rgb = [1 0.5 0.3];    % orange
                        key.trialtype_plot_order = 6;
                        key.trialtype_flag_standard = 0;
                        key.trialtype_flag_left_and_control_right = 1;
                        key.trialtype_no_presample=1;
                        key.trialtype_flag_all_left=1;
                        
                    case 'l_-1.6Mini'
                        key.trialtype_rgb = [0.5 0.5 0.5]; % [1 0.71 0.46];   % orange
                        key.trialtype_plot_order = 7;
                        key.trialtype_flag_standard = 1;
                        key.trialtype_flag_mini = 1;
                        key.trialtype_flag_left_and_control_right = 1;
                        key.trialtype_flag_left_and_control_right_nopresample=1;
                        key.trialtype_flag_left_and_control_right_nopresample_nosample=1;
                        key.trialtype_flag_left_stim_mini =1;
                        key.trialtype_flag_left_stim_mini_nopresample=1;
                        key.trialtype_flag_left_stim_mini_and_control_right =1;
                        key.trialtype_flag_left_stim_mini_nopresample_and_control_right=1;
                        key.trialtype_no_presample=1;
                        key.trialtype_flag_all_left=1;
                        key.trialtype_flag_mini_sample_and_earlydelay_and_control_pure=1;
                        
                    case 'l_-2.5Mini'
                        key.trialtype_rgb = [1 0 1];        % magenta
                        key.trialtype_plot_order = 8;
                        key.trialtype_flag_standard = 1;
                        key.trialtype_flag_mini = 1;
                        key.trialtype_flag_left_and_control_right = 1;
                        key.trialtype_flag_left_and_control_right_nopresample=1;
                        
                        key.trialtype_flag_left_stim_mini =1;
                        key.trialtype_flag_left_stim_mini_nopresample=1;
                        key.trialtype_flag_left_stim_mini_and_control_right =1;
                        key.trialtype_flag_left_stim_mini_nopresample_and_control_right=1;
                        key.trialtype_no_presample=1;
                        key.trialtype_flag_all_left=1;
                        key.trialtype_flag_mini_sample_and_earlydelay_and_control_pure=1;
                    case 'l_-2.5Mini(FullX0.5)'
                        key.trialtype_rgb = [0 1 0];        % green
                        key.trialtype_plot_order = 9;
                        key.trialtype_flag_standard = 0;
                        key.trialtype_flag_left_and_control_right = 1;
                        key.trialtype_flag_left_and_control_right_nopresample=1;
                        key.trialtype_no_presample=1;
                        key.trialtype_flag_all_left=1;
                        
                    case 'l_-2.5Mini(FullX0.75)'
                        key.trialtype_rgb = [0.25 1 0.25];  % light-green
                        key.trialtype_plot_order = 10;
                        key.trialtype_flag_standard = 0;
                        key.trialtype_flag_left_and_control_right = 1;
                        key.trialtype_no_presample=1;
                        key.trialtype_flag_all_left=1;
                        
                    case 'l_-3.8Full'
                        key.trialtype_rgb = [0.7 0.2 0.1];  % brown
                        key.trialtype_plot_order = 11;
                        key.trialtype_flag_standard = 1;
                        key.trialtype_flag_full=1;
                        key.trialtype_flag_left_and_control_right = 1;
                        key.trialtype_flag_left_stim_full =1;
                        key.trialtype_flag_left_full_only_presample_and_control_right=1;
                        key.trialtype_flag_all_left=1;
                        
                    case 'l_-3.8Full_-0.8Full'
                        key.trialtype_rgb = [0.9 0.8 0 ];   % darky-yellow
                        key.trialtype_plot_order = 12;
                        key.trialtype_flag_standard = 0;
                        key.trialtype_flag_left_and_control_right = 1;
                        key.trialtype_flag_all_left=1;
                        
                    case 'l_-3.8Full_-1.6Full'
                        key.trialtype_rgb = [0.7 0.2 0.1];  % brown
                        key.trialtype_plot_order = 13;
                        key.trialtype_flag_standard = 0;
                        key.trialtype_flag_left_and_control_right = 1;
                        key.trialtype_flag_all_left=1;
                        
                    case 'l_-3.8Mini'
                        key.trialtype_rgb = [0.7 0.2 0.1];  % brown
                        key.trialtype_plot_order = 14;
                        key.trialtype_flag_standard = 1;
                        key.trialtype_flag_mini = 1;
                        key.trialtype_flag_left_and_control_right = 1;
                        key.trialtype_flag_left_stim_mini =1;
                        key.trialtype_flag_left_stim_mini_and_control_right =1;
                        key.trialtype_flag_all_left=1;
                        
                        
                    case 'r'                        % blue
                        key.trialtype_rgb = [0 0 1];
                        key.trialtype_plot_order = 1;
                        key.trialtype_flag_standard = 1;
                        key.trialtype_flag_mini = 1;
                        key.trialtype_flag_full=1;
                        key.trialtype_flag_full_late = 1;
                        key.trialtype_flag_left_and_control_right = 1;
                        key.trialtype_flag_right_and_control_left = 1;
                        key.trialtype_flag_double_sample_amplitude=1;
                        key.trialtype_flag_left_stim_full =1;
                        key.trialtype_flag_left_stim_full_nopresample =1;
                        key.trialtype_flag_left_stim_mini_and_control_right =1;
                        key.trialtype_flag_left_and_control_right_nopresample=1;
                        key.trialtype_flag_left_and_control_right_nopresample_nosample=1;
                        key.trialtype_flag_left_stim_mini_nopresample_and_control_right=1;
                        key.trialtype_flag_right_full_nopresample_and_control_left=1;
                        key.trialtype_flag_right_full_only_presample_and_control_left=1;
                        key.trialtype_flag_left_full_only_presample_and_control_right=1;
                        key.trialtype_left_and_right_no_distractors=1;
                        key.trialtype_no_presample=1;
                        key.trialtype_flag_right_early_delay_and_control_pure=1;
                        key.trialtype_flag_mini_sample_and_earlydelay_and_control_pure=1;
                        
                        key.trialtype_flag_left_right_pure_and_early_delay_full_left=1;
                        key.trialtype_flag_left_right_pure_and_late_delay_full_left=1;
                    case 'r_-0.8Full'
                        key.trialtype_rgb = [0 0.9 1];      % dark-cyan
                        key.trialtype_plot_order = 15;
                        key.trialtype_flag_standard = 1;
                        key.trialtype_flag_full=1;
                        key.trialtype_flag_full_late = 1;
                        key.trialtype_flag_right_and_control_left = 1;
                        key.trialtype_flag_right_full_nopresample_and_control_left=1;
                        key.trialtype_no_presample=1;
                    case 'r_-0.8Mini'
                        key.trialtype_rgb = [0 1 1];        % cyan
                        key.trialtype_plot_order = 16;
                        key.trialtype_flag_standard = 1;
                        key.trialtype_flag_mini = 1;
                        key.trialtype_flag_right_and_control_left = 1;
                        key.trialtype_no_presample=1;
                    case 'r_-1.6Full'
                        key.trialtype_rgb = [0.55 0.55 1];  % light-blue
                        key.trialtype_plot_order = 17;
                        key.trialtype_flag_standard = 1;
                        key.trialtype_flag_full=1;
                        key.trialtype_flag_right_and_control_left = 1;
                        key.trialtype_flag_right_full_nopresample_and_control_left=1;
                        key.trialtype_no_presample=1;
                        key.trialtype_flag_right_early_delay_and_control_pure=1;
                        
                    case 'r_-1.6Mini'
                        key.trialtype_rgb = [0.55 0.55 1];  % light-blue
                        key.trialtype_plot_order = 18;
                        key.trialtype_flag_standard = 1;
                        key.trialtype_flag_mini = 1;
                        key.trialtype_flag_right_and_control_left = 1;
                        key.trialtype_no_presample=1;
                    case 'r_-2.5FullX0.5'
                        key.trialtype_rgb = [0.5 0.5 0.5];  % gray
                        key.trialtype_plot_order = 19;
                        key.trialtype_flag_standard = 0;
                        key.trialtype_no_presample=1;
                    case 'r_-2.5FullX2'
                        key.trialtype_rgb = [0 0 0];        % black
                        key.trialtype_plot_order = 20;
                        key.trialtype_flag_standard = 0;
                        key.trialtype_flag_double_sample_amplitude=1;
                        key.trialtype_no_presample=1;
                    case 'r_-2.5Mini(FullX0.5)'
                        key.trialtype_rgb = [0 1 0];        % green
                        key.trialtype_plot_order = 21;
                        key.trialtype_flag_standard = 0;
                        key.trialtype_no_presample=1;
                    case 'r_-2.5Mini(FullX0.75)'
                        key.trialtype_rgb = [0.25 1 0.25];  % light-green
                        key.trialtype_plot_order = 22;
                        key.trialtype_flag_standard = 0;
                        key.trialtype_no_presample=1;
                    case 'r_-3.8Full'
                        key.trialtype_rgb = [0 0.2 0.4];    %  dark-blue
                        key.trialtype_plot_order = 23;
                        key.trialtype_flag_standard = 1;
                        key.trialtype_flag_full=1;
                        key.trialtype_flag_right_and_control_left = 1;
                        key.trialtype_flag_right_full_only_presample_and_control_left=1;
                    case 'r_-3.8Mini'
                        key.trialtype_rgb = [0 0.2 0.4];    %  dark-blue
                        key.trialtype_plot_order = 24;
                        key.trialtype_flag_standard = 1;
                        key.trialtype_flag_mini = 1;
                        key.trialtype_flag_right_and_control_left = 1;
                    case 'r_NoAudCue'
                        key.trialtype_rgb = [0 0 0];        %  black
                        key.trialtype_plot_order = 25;
                        key.trialtype_flag_standard = 0;
                        key.trialtype_no_presample=1;
                end
                
            end
            
            insert (self,key);
            
        end
    end
end