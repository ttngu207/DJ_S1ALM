function [data_S1PhotostimTrial, data_PhotostimTrial, data_PhotostimTrialEvent] = Ingest_EXP_Photo (obj, key, iTrials, data_S1PhotostimTrial,data_PhotostimTrial, data_PhotostimTrialEvent)

stimEpochFlags = cell2mat(obj.trialPropertiesHash.stimEpochFlags);
trial_type_name = obj.trialPropertiesHash.stimEpochNames {stimEpochFlags (iTrials,:)};

offset = - 4.2;
all_stim_onsets = cellfun(@str2num,regexp(trial_type_name,'\d*','Match'));
if ~isempty(all_stim_onsets) %if there is no stimulation (neither stim nor distractor)
    
      data_PhotostimTrial (end+1) = struct(...
            'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials);

    for iStim = 1:length(all_stim_onsets) % loop through the stimulation onsets
        onset = (all_stim_onsets(iStim))/1000 + offset;
        power = obj.laser_power.stimulus.pow(iTrials);
        stim_pulse_num = obj.laser_power.stimulus.num_pulses(iTrials);
        pulse_dur = obj.laser_power.stimulus.pulse_dur_in_ms(iTrials);
        duration =stim_pulse_num*pulse_dur;
        
        if contains(trial_type_name,'Stim1700') %if stimulus (i.e. full stimulus occurs during sample period)
            stim_type = 'stim';
            if contains(trial_type_name,'Stim1700intermed') || contains(trial_type_name,'Stim1700double')
                stim_power_type = 'other';
            else % if it's a regular stimulus
                stim_power_type = 'full';
            end
        else % if it's a distractor
            stim_type = 'distractor';
            if power == mode(obj.laser_power.stimulus.pow) %if distractor power equals to the typical stimulus power
                stim_power_type = 'full';
            elseif  (contains(trial_type_name,'Eps1700intermedL') || ...
                    contains(trial_type_name,'Eps1700weak') || ...
                    contains(trial_type_name,'Eps1700intermedR') || ...
                    contains(trial_type_name,'Eps1700strong') || ...
                    contains(trial_type_name,'Eps1700strongR') )
                stim_power_type = 'other';
            else
                stim_power_type = 'mini';
            end
        end
        
        % data_S1PhotostimTrial
        data_S1PhotostimTrial (end+1) = struct(...
            'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials, 'stim_num',iStim, 'stim_type',stim_type, 'stim_power_type',stim_power_type, 'onset',onset, 'power',power, 'duration',duration);
        
        % data_PhotostimTrialEvent
        photostim_device = 'LaserGem473';
        go_t = obj.trialPropertiesHash.value{3}(iTrials);
        photostim_event_time = onset + go_t ; %relative to trial onset
        
        if stim_pulse_num ==1
            photo_stim = 2;
        else
            photo_stim = 1;
        end
        data_PhotostimTrialEvent (end+1) = struct(...
            'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials, 'photostim_device',photostim_device, 'photo_stim',photo_stim, 'photostim_event_time',photostim_event_time, 'power',power);
        
    end
    
else %it's a no-stim trial
    data_S1PhotostimTrial (end+1) = struct(...
        'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials, 'stim_num',1, 'stim_type','nostim', 'stim_power_type','none', 'onset', NaN, 'power',NaN, 'duration',NaN);
end
