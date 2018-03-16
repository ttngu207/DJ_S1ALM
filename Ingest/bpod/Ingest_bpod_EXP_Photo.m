function [data_S1PhotostimTrial, data_PhotostimTrial, data_PhotostimTrialEvent, data_S1TrialTypeName, data_TrialName] = Ingest_bpod_EXP_Photo (obj, key, iTrials, data_S1PhotostimTrial,data_PhotostimTrial, data_PhotostimTrialEvent, data_S1TrialTypeName, data_TrialName, task)
trial_type_name=[];
trial_type_name2=[];

if obj.task ==3
    l=[5,6,7,8];
    r=[1,2,3,4];
    original_trial_type_name{1}='r_400_1700';
    original_trial_type_name{end+ 1}='r_1700';
    original_trial_type_name{end+ 1}='r_1700_2600';
    original_trial_type_name{end+ 1}='r_1700_3400';
    original_trial_type_name{end+ 1}='l';
    original_trial_type_name{end+ 1}='l_400_2600';
    original_trial_type_name{end+ 1}='l_400_3400';
    original_trial_type_name{end+ 1}='l_2600_3400';
end

if obj.task ==4
    l=[5,6,7,8];
    r=[1,2,3,4];
    
    original_trial_type_name{1}='r_400_1700';
    original_trial_type_name{end+ 1}='r_1700';
    original_trial_type_name{end+ 1}='r_1700_2600';
    original_trial_type_name{end+ 1}='r_1700_3400';
    original_trial_type_name{end+ 1}='l_400';
    original_trial_type_name{end+ 1}='l';
    original_trial_type_name{end+ 1}='l_2600';
    original_trial_type_name{end+ 1}='l_3400';
    
       
end

original_trial_type_name = original_trial_type_name{obj.TrialTypes(iTrials)};

all_stim_onsets = cellfun(@str2num,regexp(original_trial_type_name,'\d*','Match'));
if ~isempty(all_stim_onsets) %if there is no stimulation (neither stim nor distractor)
    
    data_PhotostimTrial (end+1) = struct(...
        'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials);
    
    for iStim = 1:length(all_stim_onsets) % loop through the stimulation onsets
        onset = (all_stim_onsets(iStim))/1000;
        stim_pulse_num = obj.TrialSettings(iTrials).GUI.StimLength *10 ;
        pulse_dur = 0.1;
        duration =stim_pulse_num*pulse_dur;
        
        if contains(original_trial_type_name,'r_1700') && onset==1.7 %if stimulus (i.e. full stimulus occurs during sample period)
            stim_type = 'stim';
            power = obj.TrialSettings(iTrials).GUI.StimPower;
            stim_power_type = 'Full';
        else % if it's a distractor
            stim_type = 'distractor';
            power = obj.TrialSettings(iTrials).GUI.StimPower * obj.TrialSettings(iTrials).GUI.DistractorPercentage/100;
            if power == mode(obj.TrialSettings(iTrials).GUI.StimPower) %if distractor power equals to the typical stimulus power
                stim_power_type = 'Full';
            elseif power ==0
                continue;
            elseif power< obj.TrialSettings(iTrials).GUI.StimPower
                stim_power_type = 'FullPartial';
            end
        end
        
        
        % Renaming the trial type
        if onset ==0.4
            onset_name = 'preS';
            onset_relative_to_trial_start = obj.RawEvents.Trial{iTrials}.States.PreSample2(1);
        elseif onset ==1.7
            onset_name = 'S';
                        onset_relative_to_trial_start = obj.RawEvents.Trial{iTrials}.States.Sample3(1);
        elseif onset ==2.6
            onset_name = 'earlyD';
                        onset_relative_to_trial_start = obj.RawEvents.Trial{iTrials}.States.Delay2(1);
        elseif onset ==3.4
            onset_name = 'lateD';
                        onset_relative_to_trial_start = obj.RawEvents.Trial{iTrials}.States.Delay4(1);
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
        photostim_device = 'LED470';
        photostim_event_time = onset_relative_to_trial_start; %relative to trial onset
        
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

data_S1TrialTypeName (end+1) = struct(...
    'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials, 'task',task, 'trial_type_name',trial_type_name, 'trial_type_name2', trial_type_name2, 'original_trial_type_name',original_trial_type_name);

data_TrialName (end+1) = struct(...
    'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials, 'task',task, 'trial_type_name',trial_type_name);