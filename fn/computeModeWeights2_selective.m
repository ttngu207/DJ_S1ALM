function weights = computeModeWeights2_selective(psth_t_u_tr, trials1, trials2, tint1, tint2, psth_t_vector, mintrials_modeweights,unit_selective_idx)


%set 1 - trial average and variance, for the specified time-interval for all units
ix_t = psth_t_vector >= tint1(1) & psth_t_vector < tint1(2);
set1 = squeeze(mean(psth_t_u_tr( ix_t,:, trials1), 1));
set1avg = squeeze(nanmean(set1, 2));
set1var =  squeeze(nanvar(set1,[], 2));
unit_trials1 = sum(~isnan(set1),2);
%set 2 - trial average and variance, for the specified time-interval for all units
ix_t = psth_t_vector >= tint2(1) & psth_t_vector < tint2(2);
set2 = squeeze(mean(psth_t_u_tr( ix_t,:, trials2), 1));
set2avg = squeeze(nanmean(set2, 2));
set2var =  squeeze(nanvar(set2,[], 2));
unit_trials2 = sum(~isnan(set2),2);

% selects only units that have enough trials, for determining the coding direction
usable = unit_trials1 > mintrials_modeweights & unit_trials2 > mintrials_modeweights;
weights = (set1avg - set2avg);%./sqrt(set1var+set2var);
weights(~usable) = NaN;
weights(~unit_selective_idx)=0;
% weights(set1var+set2var<1e-9) = NaN;
% weights = weights./sqrt(nansum(weights.^2));
