function weights = shuffleModeWeights(psth_t_u_tr, n_units, trials1, trials2, tint1, tint2, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights)

weights_shuffle = zeros(numel(n_units), shuffle_num_for_modeweights);
for i_shuffle = 1:1:shuffle_num_for_modeweights
    randtrials1 = randsample(trials1,ceil(numel(trials1)*trialfraction_for_modeweights));
    randtrials2 = randsample(trials2,ceil(numel(trials2)*trialfraction_for_modeweights));
    weights_shuffle(:,i_shuffle) = computeModeWeights (psth_t_u_tr, randtrials1, randtrials2, tint1, tint2, psth_t_vector, mintrials_modeweights);
end
weights = nanmean(weights_shuffle,2);