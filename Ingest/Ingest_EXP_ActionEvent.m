function [data_ActionEvent, action_event_time] = Ingest_EXP_ActionEvent (obj, key, iTrials, data_ActionEvent)

action_event_type = [];
action_event_time =[];
            
left_lick_times = unique(obj.trialPropertiesHash.value{6}{iTrials});
action_event_time = [action_event_time; left_lick_times];
[action_event_type{1:numel(left_lick_times),1}] = deal( 'left lick');

right_lick_times = unique(obj.trialPropertiesHash.value{7}{iTrials});
action_event_time = [action_event_time; right_lick_times];
[action_event_type{end+1:end+numel(right_lick_times),1}] = deal( 'right lick');

for iActionEvent=1:1:numel(action_event_time)
    data_ActionEvent (end+1) = struct(...
        'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials, 'action_event_type',action_event_type(iActionEvent), 'action_event_time',action_event_time(iActionEvent) );
end

