%{
#
-> EXP.TrialNameType
---
trialtype_rgb                   : blob              # trial-type color in rgb
trialtype_plot_order            : int               # order in which trial-types should be plotted (first to last)
trialtype_flag_standard         : smallint          # flag indicating whether a trial type is standard (1) or special (0)
trialtype_flag_displayset1=0      : smallint       # flag include in display set (1) or not(0)

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
                        key.trialtype_rgb = [1 0 0];        % red
                        key.trialtype_plot_order = 1;
                        key.trialtype_flag_standard = 1;
                        key.trialtype_flag_displayset1 = 1;
                    case 'l_-0.8Full'
                        key.trialtype_rgb = [0.9 0.8 0];    % dark-yellow
                        key.trialtype_plot_order = 3;
                        key.trialtype_flag_standard = 1;
                        key.trialtype_flag_displayset1 = 1;
                    case 'l_-0.8Mini'
                        key.trialtype_rgb = [1 1 0];        % yellow
                        key.trialtype_plot_order = 4;
                        key.trialtype_flag_standard = 1;
                    case 'l_-1.6Full'
                        key.trialtype_rgb = [1 0.5 0.3];    % orange
                        key.trialtype_plot_order = 5;
                        key.trialtype_flag_standard = 1;
                    case 'l_-1.6Full_-0.8Full'
                        key.trialtype_rgb = [1 0.5 0.3];    % orange
                        key.trialtype_plot_order = 6;
                        key.trialtype_flag_standard = 0;
                    case 'l_-1.6Mini'
                        key.trialtype_rgb = [1 0.5 0.3];    % orange
                        key.trialtype_plot_order = 7;
                        key.trialtype_flag_standard = 1;
                    case 'l_-2.5Mini'
                        key.trialtype_rgb = [1 0 1];        % magenta
                        key.trialtype_plot_order = 8;
                        key.trialtype_flag_standard = 1;
                    case 'l_-2.5Mini(FullX0.5)'
                        key.trialtype_rgb = [0 1 0];        % green
                        key.trialtype_plot_order = 9;
                        key.trialtype_flag_standard = 0;
                    case 'l_-2.5Mini(FullX0.75)'
                        key.trialtype_rgb = [0.25 1 0.25];  % light-green
                        key.trialtype_plot_order = 10;
                        key.trialtype_flag_standard = 0;
                    case 'l_-3.8Full'
                        key.trialtype_rgb = [0.7 0.2 0.1];  % brown
                        key.trialtype_plot_order = 11;
                        key.trialtype_flag_standard = 1;
                    case 'l_-3.8Full_-0.8Full'
                        key.trialtype_rgb = [0.9 0.8 0 ];   % darky-yellow
                        key.trialtype_plot_order = 12;
                        key.trialtype_flag_standard = 0;
                    case 'l_-3.8Full_-1.6Full'
                        key.trialtype_rgb = [0.7 0.2 0.1];  % brown
                        key.trialtype_plot_order = 13;
                        key.trialtype_flag_standard = 0;
                    case 'l_-3.8Mini'
                        key.trialtype_rgb = [0.7 0.2 0.1];  % brown
                        key.trialtype_plot_order = 14;
                        key.trialtype_flag_standard = 1;
                        
                        
                    case 'r'                        % blue
                        key.trialtype_rgb = [0 0 1];
                        key.trialtype_plot_order = 2;
                        key.trialtype_flag_standard = 1;
                         key.trialtype_flag_displayset1 = 1;
                    case 'r_-0.8Full'
                        key.trialtype_rgb = [0 0.9 1];      % dark-cyan
                        key.trialtype_plot_order = 15;
                        key.trialtype_flag_standard = 1;
                        key.trialtype_flag_displayset1 = 1;
                    case 'r_-0.8Mini'
                        key.trialtype_rgb = [0 1 1];        % cyan
                        key.trialtype_plot_order = 16;
                        key.trialtype_flag_standard = 1;
                    case 'r_-1.6Full'
                        key.trialtype_rgb = [0.55 0.55 1];  % light-blue
                        key.trialtype_plot_order = 17;
                        key.trialtype_flag_standard = 1;
                    case 'r_-1.6Mini'
                        key.trialtype_rgb = [0.55 0.55 1];  % light-blue
                        key.trialtype_plot_order = 18;
                        key.trialtype_flag_standard = 1;
                    case 'r_-2.5FullX0.5'
                        key.trialtype_rgb = [0.5 0.5 0.5];  % gray
                        key.trialtype_plot_order = 19;
                        key.trialtype_flag_standard = 0;
                    case 'r_-2.5FullX2'
                        key.trialtype_rgb = [0 0 0];        % black
                        key.trialtype_plot_order = 20;
                        key.trialtype_flag_standard = 0;
                    case 'r_-2.5Mini(FullX0.5)'
                        key.trialtype_rgb = [0 1 0];        % green
                        key.trialtype_plot_order = 21;
                        key.trialtype_flag_standard = 0;
                    case 'r_-2.5Mini(FullX0.75)'
                        key.trialtype_rgb = [0.25 1 0.25];  % light-green
                        key.trialtype_plot_order = 22;
                        key.trialtype_flag_standard = 0;
                    case 'r_-3.8Full'
                        key.trialtype_rgb = [0 0.2 0.4];    %  dark-blue
                        key.trialtype_plot_order = 23;
                        key.trialtype_flag_standard = 1;
                    case 'r_-3.8Mini'
                        key.trialtype_rgb = [0 0.2 0.4];    %  dark-blue
                        key.trialtype_plot_order = 24;
                        key.trialtype_flag_standard = 1;
                    case 'r_NoAudCue'
                        key.trialtype_rgb = [0 0 0];        %  black
                        key.trialtype_plot_order = 25;
                        key.trialtype_flag_standard = 0;
                end
                
            end
            
            insert (self,key);
            
        end
    end
end