function [tuning_smooth, hist_bins_centers, number_of_spikes] = fn_tongue_tuning1D(X_behav, SPIKES,t_wnd, hist_bins, min_trials_1D_bin, smooth_bins)

[N,~,bin] =histcounts(X_behav,hist_bins);
hist_bins_centers=hist_bins(1:end-1)+mean(diff(hist_bins))/2;




for i_tr=1:1:numel(SPIKES)
    spk_t=SPIKES(i_tr).spike_times_go;
    spk(i_tr)=sum(spk_t>t_wnd(1) & spk_t<t_wnd(2));%/diff(t_wnd);
end

number_of_spikes = sum(spk);
%computing tunign curve
for i_bin=1:1:numel(hist_bins_centers)
    idx_bin = (bin==i_bin);
    tuning (i_bin)= sum(spk(idx_bin))/ (N(i_bin)*diff(t_wnd));
end
tuning_smooth=smooth(tuning,smooth_bins)';
tuning_smooth(N<min_trials_1D_bin)=NaN;

