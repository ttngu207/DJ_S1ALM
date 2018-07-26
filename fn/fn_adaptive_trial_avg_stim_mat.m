function [trialStim_epochs_mat, trialTypeStim_epochs_mat, stim_epochs, trial_type_names] = fn_adaptive_trial_avg_stim_mat(rel)
rel=rel * ANL.TrialTypeGraphic;
trial_type_names = unique([fetchn(rel, 'trial_type_name','ORDER BY trial')],'stable');

trialStim_onset{1}= [fetchn(rel, 'stimtm_presample','ORDER BY trial')];
trialStim_onset{2}= [fetchn(rel, 'stimtm_sample','ORDER BY trial')];
trialStim_onset{3}= [fetchn(rel, 'stimtm_earlydelay','ORDER BY trial')];
trialStim_onset{4}= [fetchn(rel, 'stimtm_latedelay','ORDER BY trial')];
trialStim_onset=cell2mat(trialStim_onset);

stim_epochs = [-inf,unique(trialStim_onset)'];
for  i_e =1:1: numel(stim_epochs)-1
    trialStim_epochs_mat(:,i_e)=sum(trialStim_onset>=stim_epochs(i_e) & trialStim_onset<stim_epochs(i_e+1),2);
end



for i=1:1:numel(trial_type_names)
    key.trial_type_name = trial_type_names{i};
    trialTypeStim_onsets(i,1)= fetch1(ANL.TrialTypeStimTime & key, 'stimtm_presample');
    trialTypeStim_onsets(i,2)= fetch1(ANL.TrialTypeStimTime & key, 'stimtm_sample');
    trialTypeStim_onsets(i,3)= fetch1(ANL.TrialTypeStimTime & key, 'stimtm_earlydelay');
    trialTypeStim_onsets(i,4)= fetch1(ANL.TrialTypeStimTime & key, 'stimtm_latedelay');
end

for  i_e =1:1: numel(stim_epochs)-1
    trialTypeStim_epochs_mat(:,i_e)=sum(trialTypeStim_onsets>=stim_epochs(i_e) & trialTypeStim_onsets<stim_epochs(i_e+1),2);
end

% ammend the adaptive grouping matrix for non-standard trials, and those that had a mini/partial stimulus diring the sample period, so that they won't group with those trials with regular full stimulus at the sample period
trial_type_names_all =[fetchn(rel, 'trial_type_name','ORDER BY trial')];
trial_type_names_non_standard = unique([fetchn(rel & 'trialtype_flag_standard=0', 'trial_type_name')]);
trial_type_names_non_standard{end+1} = 'l_-2.5Mini';

for ii =1:1:numel(trial_type_names_non_standard)
    idx1=strcmp(trial_type_names_all, trial_type_names_non_standard{ii});
    trialStim_epochs_mat(idx1,3) = 0.8/ii;
    
        idx2=strcmp(trial_type_names, trial_type_names_non_standard{ii});
trialTypeStim_epochs_mat(idx2,3) = 0.8/ii;
end

