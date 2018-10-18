function [tuning1D, SI, hist_bins_centers, FR_TRIAL] = fn_tongue_tuning1D_shuffling(X_behav, SPIKES,t_wnd, hist_bins, min_trials_1D_bin, smooth_bins, label,smooth_flag)

[N,~,bin] =histcounts(X_behav,hist_bins);
hist_bins_centers=hist_bins(1:end-1)+ diff(hist_bins)/2;

time_binned=N*diff(t_wnd);
remove_unoccupied_bins=N*0;
remove_unoccupied_bins(N<min_trials_1D_bin)=NaN;


for i_tr=1:1:numel(SPIKES)
    spk_t=SPIKES{i_tr};
    spk(i_tr)=sum(spk_t>t_wnd(1) & spk_t<t_wnd(2));%/diff(t_wnd);
end
FR_TRIAL=spk/diff(t_wnd);

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

[SI] = fn_compute_spatial_info (time_binned, tuning1D);
