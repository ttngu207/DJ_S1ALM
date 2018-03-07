function data_BehaviorTrial = Ingest_bpod_EXP_BehaviorTrial (obj, key, iTrials, data_BehaviorTrial, early_lick, go_t, action_event_time, outcome_types)

task =  's1 stim';
task_protocol = obj.task;
if obj.task ==3
    l=[5,6,7,8];
    r=[1,2,3,4];
end

if obj.task ==4
    l=[5,6,7,8];
    r=[1,2,3,4];
end

if sum(obj.TrialTypes(iTrials) == l)>0
    trial_instruction = 'left';
else sum(obj.TrialTypes(iTrials) == r)>0;
    trial_instruction = 'right';
end


for iOutcome = 1:1:length(outcome_types) % loop through outcomes (e.g. Hit, Ignore, Miss)
    if sum(action_event_time>go_t)>0
        if ~isnan(obj.RawEvents.Trial{iTrials}.States.Reward(1))
            outcome = 'hit';
        else
            outcome = 'miss';
        end
    else
        outcome = 'ignore';
    end
end

data_BehaviorTrial (iTrials) = struct(...
    'subject_id',key.subject_id, 'session',key.session, 'trial',iTrials, 'task',task, 'task_protocol',task_protocol, 'trial_instruction',trial_instruction, 'early_lick',early_lick, 'outcome',outcome);

