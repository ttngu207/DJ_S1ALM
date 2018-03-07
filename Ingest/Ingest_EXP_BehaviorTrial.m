function data_BehaviorTrial = Ingest_EXP_BehaviorTrial (obj, key, iTrials, data_BehaviorTrial, early_lick, outcome_types)

task =  's1 stim';
task_protocol = obj.task;
stimEpochFlags = cell2mat(obj.trialPropertiesHash.stimEpochFlags);
trial_instruction = obj.trialPropertiesHash.stimEpochNames {stimEpochFlags (iTrials,:)};
if contains(trial_instruction,'l_s')
    trial_instruction = 'left';
else
    trial_instruction = 'right';
end

outcome_types_obj = {'Hit','NoLick','Err'};

for iOutcome = 1:1:length(outcome_types) % loop through outcomes (e.g. Hit, Ignore, Miss)
    % the original data contains instruction and outcomes mixed (i.e. HitR) but we want outcomes only, regardless of the instruction
    % (e.g. if we look for a Hit - the relevant_outcomes would be HitR or HitL)
    relevant_outcomes_names = (strfind(obj.trialTypeStr,outcome_types_obj{iOutcome}));
    outcomes_vec = obj.trialTypeMat(:,iTrials); % a boolean vector with instruction-outcomes for this trial
    if sum(outcomes_vec(~cellfun(@isempty,relevant_outcomes_names))) >0 % if this particular outcome occured - insert it into the table
        outcome = outcome_types{iOutcome};
        break
    end
end
           
data_BehaviorTrial (iTrials) = struct(...
    'subject_id',key.subject_id, 'session',key.session, 'trial',iTrials, 'task',task, 'task_protocol',task_protocol, 'trial_instruction',trial_instruction, 'early_lick',early_lick, 'outcome',outcome);

% Not using
% relevant_outcomes_names = (strfind((obj.trialTypeStr),'LickEarly'));
% if sum(outcomes_vec(~cellfun(@isempty,relevant_outcomes_names))) >0 % if this particular outcome occured - insert it into the table
%     early_lick = 'early';
% else
%     early_lick = 'no early';
% end
% 