function data_TrialEvent = Ingest_Tracking (obj, key, iTrials, data_TrialEvent)

chirp_dur = 0.015;
sample_dur = 0.7;
delay_dur = 2;
go_dur = 0.01;

go_t = obj.trialPropertiesHash.value{3}(iTrials);
first_chirp_t = go_t - delay_dur - sample_dur - 2*chirp_dur;
second_chirp_t = go_t - delay_dur - chirp_dur;
delay_t = go_t - delay_dur;


trial_event_type ={'sample start chirp';'sample end chirp';'delay';'go'};
trial_event_time = [first_chirp_t; second_chirp_t; delay_t; go_t];
duration = [chirp_dur; chirp_dur; delay_dur; go_dur];


for iTrialEvent=1:1:numel(trial_event_time)
    data_TrialEvent (end+1) = struct(...
        'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials, 'trial_event_type',trial_event_type(iTrialEvent), 'trial_event_time',trial_event_time(iTrialEvent), 'duration',duration(iTrialEvent) );
end