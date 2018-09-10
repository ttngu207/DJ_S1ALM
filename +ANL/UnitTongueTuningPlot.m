%{
#
-> EPHYS.Unit
---
tongue_tip_x=null                : longblob                      # fiducial coordinate along the X axis of the video image

%}


classdef UnitTongueTuningPlot < dj.Computed
    properties
        keySource = (EPHYS.Unit & 'unit_quality!="multi"' & (EPHYS.UnitCellType & 'cell_type="PYR" or cell_type="FS"')) & ANL.Video1stLickTrialNormalized;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            close all;
            
            
            smooth_bins=3;
            min_num_spikes=100;
            min_num_trials=100;
            
            smooth_flag=1;
            plot_flag=1;
            dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
            dir_save_figure = [dir_root 'Results\video_tracking\tuning1D\'];
            
            
            figure1=figure;
            set(gcf,'DefaultAxesFontName','helvetica');
            set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 7 21 21]);
            set(gcf,'PaperOrientation','portrait');
            set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -10 0 0]);
            
            
            
            Param = struct2table(fetch (ANL.Parameters,'*'));
            min_trials_1D_bin = Param.parameter_value{(strcmp('tongue_tuning_min_trials_1D_bin',Param.parameter_name))};
            min_trials_2D_bin = Param.parameter_value{(strcmp('tongue_tuning_min_trials_1D_bin',Param.parameter_name))};
            
            
            
            rel2=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType & ANL.Video1stLickTrialNormalized & key);
            SPIKES=fetch(rel2,'*','ORDER BY trial');
            
            if numel(SPIKES)<100
                return
            end
            
            rel1=(ANL.Video1stLickTrialNormalized & key & rel2);
            TONGUE=fetch(rel1,'*','ORDER BY trial');
            num_of_trials=numel(TONGUE);
            
            hist_bins=linspace(0,1,8);
            hist_bins_X=linspace(0,1,8);
            hist_bins_Y=linspace(0,1,8);
            
            labels{1}='Horiz. offset';
            labels{2}='X amplitude';
            X{1}=[TONGUE.lick_horizoffset_relative];
            X{2}=[TONGUE.lick_peak_x];
            
            t_wnd=[-0.4, 0];
            
            subplot(3,3,1)
            num=1;
            [~, ~, number_of_spikes1] = fn_tongue_tuning1D (X{num}, SPIKES, t_wnd, hist_bins, min_trials_1D_bin, smooth_bins, labels{num} ,smooth_flag, plot_flag);
            title(sprintf('                     %s %s %s %s cell=%d trials %d \ntime = [%.1f %.1f] spikes %d',SPIKES(1).brain_area, SPIKES(1).hemisphere, SPIKES(1).training_type, SPIKES(1).cell_type, SPIKES(1).unit_uid,num_of_trials,   ...
                t_wnd(1), t_wnd(2), number_of_spikes1));
            
            subplot(3,3,2)
            num=2;
            [~, ~, ~] = fn_tongue_tuning1D (X{num}, SPIKES, t_wnd, hist_bins, min_trials_1D_bin, smooth_bins, labels{num},smooth_flag, plot_flag);
            
            ax1= subplot(3,3,3);
            [~, ~, ~] = fn_tongue_tuning2D(X{1},X{2}, SPIKES, t_wnd, labels, min_trials_2D_bin, ax1, hist_bins_X ,hist_bins_Y ,smooth_flag, plot_flag);
            
            
            
            t_wnd=[0, 0.2];
            subplot(3,3,4)
            num=1;
            [~, ~, number_of_spikes1] = fn_tongue_tuning1D (X{num}, SPIKES, t_wnd, hist_bins, min_trials_1D_bin, smooth_bins, labels{num},smooth_flag, plot_flag);
            title(sprintf('                     %s %s %s %s cell=%d trials %d \ntime = [%.1f %.1f] spikes %d',SPIKES(1).brain_area, SPIKES(1).hemisphere, SPIKES(1).training_type, SPIKES(1).cell_type, SPIKES(1).unit_uid,num_of_trials,   ...
                t_wnd(1), t_wnd(2), number_of_spikes1));
            
            subplot(3,3,5)
            num=2;
            [~, ~, number_of_spikes2] = fn_tongue_tuning1D (X{num}, SPIKES, t_wnd, hist_bins, min_trials_1D_bin, smooth_bins, labels{num},smooth_flag, plot_flag);
            
            ax2= subplot(3,3,6);
            [~, ~, ~] = fn_tongue_tuning2D(X{1},X{2}, SPIKES, t_wnd, labels, min_trials_2D_bin, ax2, hist_bins_X ,hist_bins_Y ,smooth_flag, plot_flag);
            
            
            
            filename = [SPIKES(1).brain_area, SPIKES(1).hemisphere, SPIKES(1).training_type, SPIKES(1).cell_type, num2str(SPIKES(1).unit_uid), '_tuning1D'];
            
            if (number_of_spikes1+number_of_spikes2)<min_num_spikes  || num_of_trials<min_num_trials %if there is too few data
                dir_save_figure_full=[dir_save_figure '\insufficient_data\'];
                
            else
                dir_save_figure_full=[dir_save_figure];
            end
            
            if isempty(dir(dir_save_figure_full))
                mkdir (dir_save_figure_full)
            end
            dir_save_figure_full=[dir_save_figure_full '\' filename ];
            eval(['print ', dir_save_figure_full, ' -dtiff -cmyk -r200']);
            %                 eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);
            
            insert(self,key)
            
            
        end
    end
    
end


