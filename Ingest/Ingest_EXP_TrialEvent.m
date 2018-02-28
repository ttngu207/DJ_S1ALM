function [data_TrialEvent, early_lick, trial_note_type] = Ingest_EXP_TrialEvent (obj, key, iTrials, data_TrialEvent, action_event_time, currentFileName)

% For sanity check - unless there is an early licks the timings/durations should be:
%----------------------------------------------------------------------------------
chirp_dur = 0.015;
% sample_dur = 0.7;
% delay_dur = 2;
go_dur = 0.01;
% chirp1_t = go_t - delay_dur - sample_dur - 2*chirp_dur;
% chirp2_t = go_t - delay_dur - chirp_dur;
% delay_t = go_t - delay_dur;

wave_t = obj.trialPropertiesHash.value{1}(iTrials);
delay_t = obj.trialPropertiesHash.value{2}(iTrials);
go_t = obj.trialPropertiesHash.value{3}(iTrials);
chirp1_t = obj.trialPropertiesHash.value{4}(iTrials);
chirp2_t = obj.trialPropertiesHash.value{5}(iTrials);
sample_t = obj.trialPropertiesHash.value{8}(iTrials);

sample_dur = chirp2_t-sample_t;
delay_dur = go_t - delay_t;

if strcmp(currentFileName(1:4),'data') %insert ephys trigger unless it's a behavior-only object
    ephys_t = wave_t - obj.presampleStartTimes_relative_to_trial(iTrials);
    
    trial_event_type ={'trigger ephys rec.'; 'send scheduled wave'; 'sample-start chirp'; 'sample'; 'sample-end chirp'; 'delay'; 'go'};
    trial_event_time = [ephys_t; wave_t; chirp1_t; sample_t; chirp2_t; delay_t; go_t];
    duration = [0; 0; chirp_dur; sample_dur; chirp_dur; delay_dur; go_dur];
else
    trial_event_type ={'send scheduled wave'; 'sample-start chirp'; 'sample'; 'sample-end chirp'; 'delay'; 'go'};
    trial_event_time = [wave_t; chirp1_t; sample_t; chirp2_t; delay_t; go_t];
    duration = [ 0; chirp_dur; sample_dur; chirp_dur; delay_dur; go_dur];
end
 
for iTrialEvent=1:1:numel(trial_event_time)
    data_TrialEvent (end+1) = struct(...
        'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials, 'trial_event_type',trial_event_type(iTrialEvent), 'trial_event_time',trial_event_time(iTrialEvent), 'duration',duration(iTrialEvent) );
end


% Detecting early lick
%---------------------------------------------------------------------------

% early lick: after scheduled-wave onset and before the go cue
early_lick_flag_scdwave_onwards = sum(action_event_time >= wave_t & action_event_time <= go_t); %if the flag has other elements than 0 - it means that there was an early lick

% early lick: aftter sample onset and before the go cue
early_lick_flag_sample_onwards = sum(action_event_time >= sample_t & action_event_time <= go_t); %if the flag has other elements than 0 - it means that there was an early lick

if early_lick_flag_scdwave_onwards >0 && early_lick_flag_sample_onwards==0
    early_lick ='early, presample only'; %in the presample only
elseif early_lick_flag_sample_onwards >0
    early_lick ='early'; %in the sample or delay
else
    early_lick ='no early';
end

% Registering if its a bad trial, based on strange timing of the go cue
%---------------------------------------------------------------------------
trial_note_type=[];
if go_t>=20 %if for some reason the go_t happens very late, we consider it as a bad trial
    trial_note_type='bad';
end

