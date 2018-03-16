function [data_S1PhotostimTrial, data_PhotostimTrial, data_PhotostimTrialEvent, data_S1TrialTypeName, data_TrialName] = Ingest_EXP_Photo (obj, key, iTrials, data_S1PhotostimTrial,data_PhotostimTrial, data_PhotostimTrialEvent, data_S1TrialTypeName,data_TrialName, task)
trial_type_name=[];
trial_type_name2=[];

stimEpochFlags = cell2mat(obj.trialPropertiesHash.stimEpochFlags);
original_trial_type_name = obj.trialPropertiesHash.stimEpochNames {stimEpochFlags (iTrials,:)};

all_stim_onsets = cellfun(@str2num,regexp(original_trial_type_name,'\d*','Match'));
if ~isempty(all_stim_onsets) %if there is no stimulation (neither stim nor distractor)
    
    data_PhotostimTrial (end+1) = struct(...
        'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials);
    
    for iStim = 1:length(all_stim_onsets) % loop through the stimulation onsets
        onset = (all_stim_onsets(iStim))/1000;
        stim_pulse_num = obj.laser_power.stimulus.num_pulses(iTrials);
        pulse_dur = obj.laser_power.stimulus.pulse_dur_in_ms(iTrials);
        duration =stim_pulse_num*pulse_dur;
        
        if contains(original_trial_type_name,'Stim1700') && onset==1.7 %if stimulus (i.e. full stimulus occurs during sample period)
            stim_type = 'stim';
            power = obj.laser_power.stimulus.pow(iTrials);
            if contains(original_trial_type_name,'Stim1700intermed')
                stim_power_type = 'FullX0.5';
            elseif contains(original_trial_type_name,'Stim1700double')
                stim_power_type = 'FullX2';
            else % if it's a regular stimulus
                stim_power_type = 'Full';
            end
        else % if it's a distractor
            stim_type = 'distractor';
            power = obj.laser_power.distractor.pow(iTrials);
            if power == mode(obj.laser_power.stimulus.pow) || obj.task==3 ||  obj.task==4 || obj.task==6 %if distractor power equals to the typical stimulus power
                stim_power_type = 'Full';
                power = obj.laser_power.stimulus.pow(iTrials);
            elseif contains(original_trial_type_name,'intermed')
                stim_power_type = 'Mini(FullX0.5)';
            elseif contains(original_trial_type_name,'strong')
                stim_power_type = 'Mini(FullX0.75)';
            else % if it's a regular mini distractor
                stim_power_type = 'Mini';
            end
        end
        
        
        % Renaming the trial type
        if onset ==0.4
            onset_name = 'preS';
        elseif onset ==1.7
            onset_name = 'S';
        elseif onset ==2.6
            onset_name = 'earlyD';
        elseif onset ==3.4
            onset_name = 'lateD';
        end
        
        if onset==1.7 && strcmp(stim_power_type, 'Full')
            trial_type_name = [trial_type_name];
        else
            trial_type_name = [trial_type_name '_' num2str(onset-4.2) stim_power_type];
        end
        
        trial_type_name2 = [trial_type_name2 '_' onset_name '-' stim_power_type];
        
        % data_S1PhotostimTrial
        data_S1PhotostimTrial (end+1) = struct(...
            'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials, 'stim_num',iStim, 'stim_type',stim_type, 'stim_power_type',stim_power_type, 'onset',onset, 'power',power, 'duration',duration);
        
        % data_PhotostimTrialEvent
        photostim_device = 'LaserGem473';
        wave_t = obj.trialPropertiesHash.value{1}(iTrials);
        photostim_event_time = onset + wave_t ; %relative to trial onset
        
        if stim_pulse_num ==1
            photo_stim = 2;
        else
            photo_stim = 1;
        end
        data_PhotostimTrialEvent (end+1) = struct(...
            'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials, 'photostim_device',photostim_device, 'photo_stim',photo_stim, 'photostim_event_time',photostim_event_time, 'power',power);
    end
    
else %it's a no-stim trial
    trial_type_name2 = '_NoStim';
    data_S1PhotostimTrial (end+1) = struct(...
        'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials, 'stim_num',1, 'stim_type','nostim', 'stim_power_type','NoStim', 'onset', NaN, 'power',NaN, 'duration',NaN);
end

%prefixing and suffixing trial_type_name
trial_type_name =[original_trial_type_name(1) trial_type_name];
trial_type_name2 =[original_trial_type_name(1) trial_type_name2];

if contains(original_trial_type_name,'NoCue')
    trial_type_name =[trial_type_name '_NoAudCue'];
    trial_type_name2 =[trial_type_name2 '_NoAudCue'];
end


data_S1TrialTypeName (end+1) = struct(...
    'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials, 'task',task, 'trial_type_name',trial_type_name, 'trial_type_name2', trial_type_name2, 'original_trial_type_name',original_trial_type_name);

data_TrialName (end+1) = struct(...
    'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials, 'task',task, 'trial_type_name',trial_type_name);

