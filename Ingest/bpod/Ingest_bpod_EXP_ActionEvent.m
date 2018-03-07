function [data_ActionEvent, action_event_time] = Ingest_bpod_EXP_ActionEvent (obj, key, iTrials, data_ActionEvent)

action_event_type = [];
action_event_time =[];
if   isfield(obj.RawEvents.Trial{iTrials}.Events,'Port1In')
    left_lick_times = obj.RawEvents.Trial{iTrials}.Events.Port1In';
    action_event_time = [action_event_time; left_lick_times];
    [action_event_type{1:numel(left_lick_times),1}] = deal( 'left lick');
end
if   isfield(obj.RawEvents.Trial{iTrials}.Events,'Port2In')
    right_lick_times = obj.RawEvents.Trial{iTrials}.Events.Port2In';
    action_event_time = [action_event_time; right_lick_times];
    [action_event_type{end+1:end+numel(right_lick_times),1}] = deal( 'right lick');
end

for iActionEvent=1:1:numel(action_event_time)
    data_ActionEvent (end+1) = struct(...
        'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials, 'action_event_type',action_event_type(iActionEvent), 'action_event_time',action_event_time(iActionEvent) );
end

