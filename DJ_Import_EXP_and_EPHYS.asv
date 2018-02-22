function DJ_Import_EXP
close all; clear all;

global dir_data
dir_data = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\ProcessedData\';
dir_video = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\RawData\video\';

DJconnect; %connect to the database using stored user credentials

% del(EXP.Session) % for DEBUG
temp=fetchn(EXP.Session,'session_id');
if ~isempty(temp)
    session_id=temp(end);
    del(EXP.Session & session_id)
end

%% Initialize some tables

if isempty(fetch(EXP.Photostim))
    % full stim
    x = linspace(0,pi,100);
    waveform = repmat( sin(x),1,4); %plot([1:1:400],waveform)
    insert(EXP.Photostim, {'LaserGem473', 1, 0.4, waveform} );
    
    % mini stim
    x = linspace(0,pi,100);
    waveform = sin(x); %plot([1:1:100],waveform)
    insert(EXP.Photostim, {'LaserGem473', 2, 0.1, waveform} );
end

%% Insert/Populate Sessions and dependent tables
allFiles = dir(dir_data); %gets  the names of all files and nested directories in this folder
allFileNames = {allFiles(~[allFiles.isdir]).name}; %gets only the names of all files

for iFile = 1:1:numel (allFileNames)
    tic
    % Get the current session name/date
    currentFileName = allFileNames{iFile};
    currentSubject_id = str2num(currentFileName(19:24));
    currentSessionDate = currentFileName(26:35);
    
    % Get the  name/date of sessions that are already in the DJ database
    exisitingSubject_id = fetchn(EXP.Session,'subject_id');
    exisitingSession = fetchn(EXP.Session,'session');
    exisitingSessionDate = fetchn(EXP.Session,'session_date');
    
    key.subject_id = currentSubject_id;  key.session_date = currentSessionDate;
    
    % Insert a session (and all the dependent tables) only if the animalXsession combination doesn't exist
    if isempty( fetch(EXP.Session & key))
        
        currentFileName
        
        if  sum(currentSubject_id == exisitingSubject_id)>0 % test if to restart the session numbering
            currentSession = numel(fetchn(EXP.Session & sprintf('subject_id = %d',key.subject_id),'session')) + 1;
        else
            currentSession =1;
        end
        
        key.session = currentSession;
        %% Insert Session
        insert(EXP.Session, {currentSubject_id, currentSession, numel(exisitingSession)+1, currentSessionDate, 'ars','ephys'} );
        
        %% Load Obj
        obj = EXP.getObj (key);
        
        % EPHYS.Probe
        inserti(EPHYS.Probe, {obj.probeName , obj.probeType, ''}); %ignores duplicates
        
         % EPHYS.ElectrodeGroup
        insert(EPHYS.ElectrodeGroup, {currentSubject_id, currentSession, 1,obj.probeName  }); %shank 1 (left)
        insert(EPHYS.ElectrodeGroup, {currentSubject_id, currentSession, 2,obj.probeName  }); %shank 2 (right)
        
        % EPHYS.ElectrodeGroupPosition
        ml = -(obj.position_ML);
        ap = obj.position_AP;
        dv = obj.depth;

        insert(EPHYS.ElectrodeGroupPosition, {currentSubject_id, currentSession, 1, 'manipulator','Bregma', ml, ap, dv  }); %shank 1
        insert(EPHYS.ElectrodeGroupPosition, {currentSubject_id, currentSession, 2, 'manipulator','Bregma', ml + 250, ap, dv  }); %shank 1

        manipulator
        % EXP.TaskTraining
        data_TaskTraining = Ingest_EXP_TaskTraining (obj, key);
        
        
       %% Insert Trial-based data

        
        %initializing
        [data_SessionTrial] = fn_EmptyStruct ('EXP.SessionTrial');
        [data_ActionEvent] = fn_EmptyStruct ('EXP.ActionEvent');
        [data_TrialEvent] = fn_EmptyStruct ('EXP.TrialEvent');
        [data_BehaviorTrial] = fn_EmptyStruct ('EXP.BehaviorTrial');
        [data_S1PhotostimTrial] = fn_EmptyStruct ('EXP.S1PhotostimTrial');
        [data_PhotostimTrial] = fn_EmptyStruct ('EXP.PhotostimTrial');
        [data_PhotostimTrialEvent] = fn_EmptyStruct ('EXP.PhotostimTrialEvent');
        [data_Tracking] = fn_EmptyStruct ('EXP.Tracking');
        [data_TrialNote] = fn_EmptyStruct ('EXP.TrialNote');
        
        % for video tracking
        tracking_device = fetchn(EXP.TrackingDevice, 'tracking_device');
        tracking_data_dir = [dir_video 'anm'  num2str(key.subject_id) '\' num2str(key.session_date) '\' ];
        allVideoFiles = dir(tracking_data_dir); %gets  the names of all files and nested directories in this folder
        allVideoNames = {allVideoFiles(~[allVideoFiles.isdir]).name}; %gets only the names of all files
        
        total_trials = numel(fetchn(EXP.SessionTrial,'trial_id'));
        
        for iTrials = 1:1:numel(obj.trialIDs)
            
            % EXP.SessionTrial
            data_SessionTrial (iTrials) = struct(...
                'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials, 'trial_id', total_trials + iTrials, 'start_time', obj.trialStartTimes(iTrials));
            
            % EXP.ActionEvent
            [data_ActionEvent, action_event_time]  = Ingest_EXP_ActionEvent (obj, key, iTrials, data_ActionEvent);
            
            % EXP.TrialEvent
            [data_TrialEvent, early_lick, trial_note_type ]  = Ingest_EXP_TrialEvent (obj, key, iTrials, data_TrialEvent, action_event_time);
            
            % EXP.BehaviorTrial
            data_BehaviorTrial = Ingest_EXP_BehaviorTrial (obj, key, iTrials, data_BehaviorTrial, early_lick);
            
            % Photostim related tables
            [data_S1PhotostimTrial, data_PhotostimTrial, data_PhotostimTrialEvent] = Ingest_EXP_Photo (obj, key, iTrials, data_S1PhotostimTrial,data_PhotostimTrial, data_PhotostimTrialEvent);
            
            % Tracking
            [data_Tracking] = Ingest_EXP_Tracking (obj, key, iTrials, tracking_data_dir, allVideoNames,  tracking_device, data_Tracking);
            
            
            % TrialNote
            if ~isempty(trial_note_type)
                data_TrialNote (end+1) = struct(...
                    'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials, 'trial_note_type',trial_note_type, 'trial_note','');
            end
            
            %iTrials
            
        end
        
        
        
        
        insert(EXP.SessionTrial, data_SessionTrial);
        insert(EXP.BehaviorTrial, data_BehaviorTrial);
        insert(EXP.TaskTraining, data_TaskTraining);
        insert(EXP.ActionEvent, data_ActionEvent);
        insert(EXP.TrialEvent, data_TrialEvent);
        insert(EXP.S1PhotostimTrial, data_S1PhotostimTrial);
        insert(EXP.PhotostimTrial, data_PhotostimTrial);
        insert(EXP.PhotostimTrialEvent, data_PhotostimTrialEvent);
        insert(EXP.Tracking, data_Tracking);
                
        clear obj;
        toc
    end
end
