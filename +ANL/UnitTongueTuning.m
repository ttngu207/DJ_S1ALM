%{
#
-> EPHYS.Unit
---
tongue_tip_x=null                : longblob                      # fiducial coordinate along the X axis of the video image

%}


classdef UnitTongueTuning < dj.Computed
    properties
        keySource = (EPHYS.Unit & 'unit_quality!="multi"' & (EPHYS.UnitCellType & 'cell_type="PYR" or cell_type="FS"')) & ANL.VideoLickOnsetTrialNormalized;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            close all;
            
            min_trials_1D_bin=3;
            smooth_bins=3;
            min_num_spikes=100;
            min_num_trials=100;
            dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
            dir_save_figure = [dir_root 'Results\video_tracking\tuning1D\'];
            
            
            figure1=figure;
            set(gcf,'DefaultAxesFontName','helvetica');
            set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 7 21 21]);
            set(gcf,'PaperOrientation','portrait');
            set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -10 0 0]);
            
            
            
            %             Param = struct2table(fetch (ANL.Parameters,'*'));
            %             time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
            %             time_idx=(time<0 & time>-0.5);
            
            
            rel2=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType & ANL.VideoLickOnsetTrialNormalized & key);
            SPIKES=fetch(rel2,'*','ORDER BY trial');
            
            if isempty(SPIKES)
                return
            end
            
            rel1=(ANL.VideoLickOnsetTrialNormalized & key & rel2);
            TONGUE=fetch(rel1,'*','ORDER BY trial');
            num_of_trials=numel(TONGUE);
            
            hist_bins=linspace(0,1,8);
            
            subplot(3,3,1)
            k.lick_measurement_name='Horiz. offset relative';
            t_wnd=[-0.4, 0];
            X_behav=[TONGUE.lick_horizdist_peak_relative];
            [tuning, hist_bins_centers, number_of_spikes1] = fn_tongue_tuning1D (X_behav, SPIKES, t_wnd, hist_bins, min_trials_1D_bin, smooth_bins);
            plot(hist_bins_centers,tuning);
            xlabel(k.lick_measurement_name);
            ylabel('FR (Hz)');
            title(sprintf('                     %s %s %s %s cell=%d trials %d \ntime = [%.1f %.1f] spikes %d',SPIKES(1).brain_area, SPIKES(1).hemisphere, SPIKES(1).training_type, SPIKES(1).cell_type, SPIKES(1).unit_uid,num_of_trials,   ...
                t_wnd(1), t_wnd(2), number_of_spikes1));
            
            
            subplot(3,3,2)
            k.lick_measurement_name='Horiz. offset relative';
            t_wnd=[0, 0.2];
            X_behav=[TONGUE.lick_horizdist_peak_relative];
            [tuning, hist_bins_centers, number_of_spikes2] = fn_tongue_tuning1D(X_behav, SPIKES, t_wnd, hist_bins, min_trials_1D_bin, smooth_bins);
            plot(hist_bins_centers,tuning);
            xlabel(k.lick_measurement_name);
            ylabel('FR (Hz)');
            title(sprintf('time = [%.1f %.1f] spikes %d', t_wnd(1), t_wnd(2),number_of_spikes2));
            
            
            
            subplot(3,3,4)
            k.lick_measurement_name='RT';
            t_wnd=[-0.4, 0];
            X_behav=[TONGUE.first_lick_rt_video_onset];
            [tuning, hist_bins_centers] = fn_tongue_tuning1D (X_behav, SPIKES, t_wnd, hist_bins, min_trials_1D_bin, smooth_bins);
            plot(hist_bins_centers,tuning);
            xlabel(k.lick_measurement_name);
            ylabel('FR (Hz)');
            title(sprintf('time = [%.1f %.1f]', t_wnd(1), t_wnd(2)));
            
            
            subplot(3,3,5)
            k.lick_measurement_name='RT';
            t_wnd=[0, 0.2];
            X_behav=[TONGUE.first_lick_rt_video_onset];
            [tuning, hist_bins_centers] = fn_tongue_tuning1D(X_behav, SPIKES, t_wnd, hist_bins, min_trials_1D_bin, smooth_bins);
            plot(hist_bins_centers,tuning);
            xlabel(k.lick_measurement_name);
            ylabel('FR (Hz)');
            title(sprintf('time = [%.1f %.1f]', t_wnd(1), t_wnd(2)));
            
            
            subplot(3,3,7)
            k.lick_measurement_name='Amplitude';
            t_wnd=[-0.4, 0];
            X_behav=[TONGUE.first_lick_amplitude];
            [tuning, hist_bins_centers] = fn_tongue_tuning1D (X_behav, SPIKES, t_wnd, hist_bins, min_trials_1D_bin, smooth_bins);
            plot(hist_bins_centers,tuning);
            xlabel(k.lick_measurement_name);
            ylabel('FR (Hz)');
            title(sprintf('time = [%.1f %.1f]', t_wnd(1), t_wnd(2)));
            
            
            subplot(3,3,8)
            k.lick_measurement_name='Amplitude';
            t_wnd=[0, 0.2];
            X_behav=[TONGUE.first_lick_amplitude];
            [tuning, hist_bins_centers] = fn_tongue_tuning1D(X_behav, SPIKES, t_wnd, hist_bins, min_trials_1D_bin, smooth_bins);
            plot(hist_bins_centers,tuning);
            xlabel(k.lick_measurement_name);
            ylabel('FR (Hz)');
            title(sprintf('time = [%.1f %.1f]', t_wnd(1), t_wnd(2)));
            
            
            
            
            subplot(3,3,3)
            X_behav1=[TONGUE.lick_horizdist_peak_relative];
            X_behav2=[TONGUE.first_lick_rt_video_onset];
            plot(X_behav1,X_behav2,'.')
            xlim([0 1]);
            ylim([0 1]);
            xlabel('Horiz. offset relative');
            ylabel('RT');
            
            subplot(3,3,6)
            X_behav1=[TONGUE.lick_horizdist_peak_relative];
            X_behav2=[TONGUE.first_lick_amplitude];
            plot(X_behav1,X_behav2,'.')
            xlim([0 1]);
            ylim([0 1]);
            xlabel('Horiz. offset relative');
            ylabel('Amplitude');
            
            subplot(3,3,9)
            X_behav1=[TONGUE.first_lick_rt_video_onset];
            X_behav2=[TONGUE.first_lick_amplitude];
            plot(X_behav1,X_behav2,'.')
            xlim([0 1]);
            ylim([0 1]);
            xlabel('RT');
            ylabel('Amplitude');
            
            
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


