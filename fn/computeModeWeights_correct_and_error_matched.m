function weights = computeModeWeights_correct_and_error_matched(psth_t_u_tr, trials_R_correct, trials_L_correct,trials_R_error, trials_L_error, tint1, tint2, psth_t_vector, mintrials_modeweights,smallest_set_num)


    
    
    
    trials1=  [datasample(trials_R_correct,smallest_set_num,'Replace',false);   datasample(trials_L_error,smallest_set_num,'Replace',false)];
    trials2=  [datasample(trials_L_correct,smallest_set_num,'Replace',false);   datasample(trials_R_error,smallest_set_num,'Replace',false)];
    
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
    
    usable = unit_trials1 > mintrials_modeweights & unit_trials2 > mintrials_modeweights;
weights = (set1avg - set2avg);%./sqrt(set1var+set2var);
weights(~usable) = NaN;
% weights(set1var+set2var<1e-9) = NaN;
% weights = weights./sqrt(nansum(weights.^2));

%     % selects only units that have enough trials, for determining the coding direction
%     usable = unit_trials1 > mintrials_modeweights & unit_trials2 > mintrials_modeweights;
%     weights = (set1avg - set2avg)./sqrt(set1var+set2var);
%     weights(~usable) = NaN;
%     weights(set1var+set2var<1e-9) = NaN;
%     % weights = weights./sqrt(nansum(weights.^2));
