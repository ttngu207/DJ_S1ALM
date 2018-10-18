function [tuning1D, hist_bins_centers, number_of_spikes, peak_FR, min_FR, peak_FR_bin, SI, FR_TRIAL] = fn_tongue_tuning1D(X_behav, SPIKES,t_wnd, hist_bins, min_trials_1D_bin, smooth_bins, label,smooth_flag, plot_flag)

[N,~,bin] =histcounts(X_behav,hist_bins);
hist_bins_centers=hist_bins(1:end-1)+diff(hist_bins)/2;

time_binned=N*diff(t_wnd);
remove_unoccupied_bins=N*0;
remove_unoccupied_bins(N<min_trials_1D_bin)=NaN;

for i_tr=1:1:numel(SPIKES)
    spk_t=SPIKES(i_tr).spike_times_go;
    spk(i_tr)=sum(spk_t>t_wnd(1) & spk_t<t_wnd(2));%/diff(t_wnd);
end

FR_TRIAL=spk/diff(t_wnd);
number_of_spikes = sum(spk);
%computing tunign curve
for i_bin=1:1:numel(hist_bins_centers)
    idx_bin = (bin==i_bin);
    temp (i_bin)= sum(spk(idx_bin));
end
tuning1D=temp./time_binned;

if smooth_flag==1
    tuning1D=smooth(tuning1D,smooth_bins)';
end

tuning1D =  tuning1D + remove_unoccupied_bins;
time_binned =  time_binned + remove_unoccupied_bins;

if plot_flag==1
    plot(hist_bins_centers,tuning1D);
    ylim([0 nanmax(tuning1D)+eps]);
    xlabel(label);
    ylabel('FR (Hz)');
end

[peak_FR,peak_FR_bin]=nanmax(tuning1D);
min_FR=nanmin(tuning1D);
[SI] = fn_compute_spatial_info (time_binned, tuning1D);
