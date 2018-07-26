% requires fn_adaptive_trial_avg_stim_mat
function [adaptive_avg] = fn_adaptive_trial_avg(trialStim_epochs_mat, trialTypeStim_epochs_mat, stim_epochs, mat_TimeXTrials, trials_subset, t_vector)
adaptive_avg=[];
for i_e =1:1: numel(stim_epochs)-1
    trials_to_average = trials_subset(find (sum(trialStim_epochs_mat(trials_subset, 1:i_e) == trialTypeStim_epochs_mat(1:i_e),2)==i_e));
    t_idx =  t_vector>=stim_epochs(i_e) & t_vector<stim_epochs(i_e+1);
    temp_psth = nanmean(mat_TimeXTrials(t_idx, trials_to_average),2)';
    adaptive_avg = [adaptive_avg,temp_psth];
end
