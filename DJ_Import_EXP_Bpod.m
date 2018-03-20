function DJ_Import_EXP_Bpod
close all;
DJconnect; %connect to the database using stored user credentials

global dir_data
dir_data = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\RawData\bpod_behavior\';

% DJconnect; %connect to the database using stored user credentials
% erd LAB MISC EXP EPHYS CF ANL
%Initialize
EXP.SessionComment;
EXP.PassivePhotostimTrial
EPHYS.LabeledTrack;
EXP.PhotostimProfile;
EPHYS.UnitCellType;
EPHYS.UnitComment;
EPHYS.UnitSpikes;

%% for DEBUG
del_key=fetch(EXP.SessionID,'ORDER BY session_uid');
if ~isempty(del_key)
    del_key=del_key(end);
    del(EXP.Session & del_key)
end

%% Initialize some tables

if isempty(fetch(EXP.Photostim))
    % mini stim
    x = linspace(0,pi,100);
    waveform = sin(x); %plot([1:1:100],waveform)
    insert(EXP.Photostim, {'LaserGem473', 2, 0.1, waveform} );
    insert(EXP.PhotostimLocation, {'LaserGem473', 2, 'left', 'vS1', 'Bregma',-3500,-1300,0, NaN, NaN} );
    insert(EXP.Photostim, {'LED470', 2, 0.1, waveform} );
    insert(EXP.PhotostimLocation, {'LED470', 2, 'left', 'vS1', 'Bregma',-3500,-1300,0, NaN, NaN} );
    
    
    % full stim
    x = linspace(0,pi,100);
    waveform = repmat( sin(x),1,4); %plot([1:1:400],waveform)
    insert(EXP.Photostim, {'LaserGem473', 1, 0.4, waveform} );
    insert(EXP.PhotostimLocation, {'LaserGem473', 1, 'left', 'vS1', 'Bregma',-3500,-1300,0,NaN,NaN} );
    insert(EXP.Photostim, {'LED470', 1, 0.4, waveform} );
    insert(EXP.PhotostimLocation, {'LED470', 1, 'left', 'vS1', 'Bregma',-3500,-1300,0,NaN,NaN} );
end

%% Insert/Populate Sessions and dependent tables
allFiles = dir(dir_data); %gets  the names of all files and nested directories in this folder
allFileNames = {allFiles(~[allFiles.isdir]).name}; %gets only the names of all files

for iFile = 1:1:numel (allFileNames)
    tic
    % Get the current session name/date
    currentFileName = allFileNames{iFile};
    currentSubject_id = str2num(currentFileName(10:15));
    currentSessionDate = currentFileName(17:26);
    currentSessionDate = char(datetime(currentFileName(17:26),'Format','yyyy-MM-dd','InputFormat','MMMMd_yyyy'));
    
    % Get the  name/date of sessions that are already in the DJ database
    exisitingSubject_id = fetchn(EXP.Session,'subject_id');
    exisitingSession = fetchn(EXP.Session,'session');
    exisitingSessionDate = fetchn(EXP.Session,'session_date');
    
    key.subject_id = currentSubject_id;  key.session_date = currentSessionDate;
    
    key_test.subject_id = currentSubject_id;  key_test.session_date = currentSessionDate;
    % Insert a session (and all the dependent tables) only if the animalXsession combination doesn't exist
    if isempty( fetch(EXP.Session & key_test))
        
        currentFileName
        
        if  sum(currentSubject_id == exisitingSubject_id)>0 % test if to restart the session numbering
            temp_key.subject_id = key.subject_id;
            s_n = fetchn(EXP.Session & temp_key,'session');
            currentSession = s_n(end) + 1;
        else
            currentSession =1;
        end
        
        key.session = currentSession;
        
        
        %load session
        temp = load([dir_data currentFileName]);
        obj=temp.SessionData;
        StimLength = obj.TrialSettings(1).GUI.StimLength;
        if sum(StimLength==[0.1,0.4])==0
            continue;
        end
        
        %% Insert Session
        insert(EXP.Session, {currentSubject_id, currentSession, currentSessionDate, 'ars','ephys'} );
        populate(EXP.SessionID);
        
        key_task.subject_id = key.subject_id;
        key_task.session = key.session;
        key_task.task = 's1 stim';
        key_task.task_protocol = str2num(currentFileName(5));
        insert(EXP.SessionTask, key_task);
        
        key_training.subject_id = key.subject_id;
        key_training.session = key.session;
        key_training.training_type = 'distractor';
        insert(EXP.SessionTraining, key_training);
        
        obj.task = key_task.task_protocol';
        
        %% Insert Trial-based data
        
        %initializing
        [data_SessionTrial] = fn_EmptyStruct ('EXP.SessionTrial');
        [data_ActionEvent] = fn_EmptyStruct ('EXP.ActionEvent');
        [data_TrialEvent] = fn_EmptyStruct ('EXP.BehaviorTrialEvent');
        [data_BehaviorTrial] = fn_EmptyStruct ('EXP.BehaviorTrial');
        [data_S1PhotostimTrial] = fn_EmptyStruct ('MISC.S1PhotostimTrial');
        [data_PhotostimTrial] = fn_EmptyStruct ('EXP.PhotostimTrial');
        [data_PhotostimTrialEvent] = fn_EmptyStruct ('EXP.PhotostimTrialEvent');
        [data_S1TrialTypeName] = fn_EmptyStruct ('MISC.S1TrialTypeName');
        [data_TrialNote] = fn_EmptyStruct ('EXP.TrialNote');
        [data_TrialName] = fn_EmptyStruct ('EXP.TrialName');
        
        outcome_types = fetchn(EXP.Outcome,'outcome');
        
        total_trials = numel(fetchn(EXP.SessionTrial,'trial_uid'));
        
        for iTrials = 1:1:obj.nTrials
            
            % EXP.SessionTrial
            data_SessionTrial (iTrials) = struct(...
                'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials, 'trial_uid', total_trials + iTrials, 'start_time', obj.TrialStartTimestamp(iTrials) - obj.TrialStartTimestamp(1));
            
            % EXP.ActionEvent
            [data_ActionEvent, action_event_time]  = Ingest_bpod_EXP_ActionEvent (obj, key, iTrials, data_ActionEvent);
            
            % EXP.TrialEvent
            [data_TrialEvent, early_lick, trial_note_type, go_t] = Ingest_bpod_EXP_TrialEvent (obj, key, iTrials, data_TrialEvent, action_event_time, currentFileName);
            
            % EXP.BehaviorTrial
            data_BehaviorTrial = Ingest_bpod_EXP_BehaviorTrial (obj, key, iTrials, data_BehaviorTrial, early_lick, go_t, action_event_time,outcome_types);
            
            % Photostim related tables
            [data_S1PhotostimTrial, data_PhotostimTrial, data_PhotostimTrialEvent, data_S1TrialTypeName, data_TrialName]= Ingest_bpod_EXP_Photo(obj, key, iTrials, data_S1PhotostimTrial, data_PhotostimTrial, data_PhotostimTrialEvent, data_S1TrialTypeName,data_TrialName, 's1 stim');
            
            % TrialNote
            if ~isempty(trial_note_type)
                data_TrialNote (end+1) = struct(...
                    'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials, 'trial_note_type',trial_note_type, 'trial_note','');
            end
            
            %iTrials
            
        end
        
        Ingest_EXP_TrialNameType ('s1 stim', data_TrialName)
        
        insert(EXP.TrialName, data_TrialName);
        insert(EXP.SessionTrial, data_SessionTrial);
        insert(EXP.BehaviorTrial, data_BehaviorTrial);
        insert(EXP.ActionEvent, data_ActionEvent);
        insert(EXP.BehaviorTrialEvent, data_TrialEvent);
        insert(MISC.S1PhotostimTrial, data_S1PhotostimTrial);
        insert(EXP.PhotostimTrial, data_PhotostimTrial);
        insert(EXP.PhotostimTrialEvent, data_PhotostimTrialEvent);
        insert(MISC.S1TrialTypeName, data_S1TrialTypeName);
        toc
    end
end
DJ_populate_schemas();
