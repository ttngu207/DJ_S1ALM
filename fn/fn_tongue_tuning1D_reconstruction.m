function [tuningX_reconstructed, hist_bins_centers, SI_X_reconstr_by_Y, r_X_reconstr_by_Y, err_X_reconstr_by_Y] = fn_tongue_tuning1D_reconstruction (X_behav,Y_behav, TUNING_X, TUNING_Y, t_wnd, hist_bins_x,hist_bins_y, min_trials_1D_bin, smooth_bins, smooth_flag)

[N,~,bin] =histcounts(X_behav,hist_bins_x);
hist_bins_centers=hist_bins_x(1:end-1)+diff(hist_bins_x)/2;

time_binned=N*diff(t_wnd);
remove_unoccupied_bins=N*0;
remove_unoccupied_bins(N<min_trials_1D_bin)=NaN;

[~,~,bin_reconstructed] =histcounts(Y_behav,hist_bins_y);
bin_reconstructed(bin_reconstructed==0)=max(bin_reconstructed); %puts the value beyond the range into the last bin
for i_tr=1:1:numel(Y_behav)
    spk(i_tr)=TUNING_Y(bin_reconstructed(i_tr))*diff(t_wnd); %convert firing rate into spikes
end


%computing tuning curve
for i_bin=1:1:numel(hist_bins_centers)
    idx_bin = (bin==i_bin);
    temp (i_bin)= nansum(spk(idx_bin));
end
tuningX_reconstructed=temp./time_binned;

if smooth_flag==1
    tuningX_reconstructed=smooth(tuningX_reconstructed,smooth_bins)';
end

tuningX_reconstructed =  tuningX_reconstructed + remove_unoccupied_bins;
time_binned =  time_binned + remove_unoccupied_bins;

[SI_X_reconstr_by_Y] = fn_compute_spatial_info (time_binned, tuningX_reconstructed);

% Compute Correlation and Reconstruction Error
%--------------------------------------------------------------------------
pearson=corr([TUNING_X', tuningX_reconstructed'],'rows','pairwise','type','Pearson'); %takes only the lower part of the matrix
r_X_reconstr_by_Y = pearson(2,1); %takes the actual correlation coefficient of "vector_a" X "vector_b"
err_X_reconstr_by_Y = fn_compute_deviation_error (TUNING_X, tuningX_reconstructed);
if err_X_reconstr_by_Y==Inf
    err_X_reconstr_by_Y=NaN;
end
if err_X_reconstr_by_Y>1000
    err_X_reconstr_by_Y=NaN;
end    
