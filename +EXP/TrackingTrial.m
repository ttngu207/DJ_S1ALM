%{
#
-> EXP.SessionTrial
-> EXP.TrackingDevice
---
tracking_datafile_num  = null        : int                        # tracking data file number associated with this trial
tracking_datafile_path = null        : varchar(1000)              #
tracking_start_time = null           : decimal(8,4)                   # (s) from trial start (which should coincide with the beginning of the ephys recordings)
tracking_duration = null             : decimal(8,4)                   # (s)
tracking_sampling_rate = null        : decimal(8,4)                   # Hz

%}


classdef TrackingTrial < dj.Imported
    properties
        keySource = (EXP.Session  & EPHYS.Unit)  * (EXP.TrackingDevice & 'tracking_device_id=1') ;
    end
    methods(Access=protected)
        
        function makeTuples(self, key)
            root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\RawData\';
            m = getSessions(root);
            
            datadir = 'SpikeGL';
            date=fetch1(EXP.Session & key,'session_date')
            key.subject_id=fetch1(EXP.Session & key,'subject_id')
            key.tracking_sampling_rate=400;
            
            current_session = find(strcmp({m.anm_name},['anm' num2str(key.subject_id)]) & contains({m.parent},date ));
            if ~isempty(current_session)
                
                m= m(current_session);
                
                parent = m.parent(1:end-18);
                day = m.parent(end-17:end-8);
                load(fullfile(parent, day, datadir, 'MetaData.mat'));
                
                
                
                %%
                dir_data_video = [root 'video\' meta.anm_name '\' meta.day '\' ];
                if meta.video_flag && isdir(dir_data_video)
                    dir_data_SpikeGL = meta.parent;
                    session_name = [meta.anm_name '-' meta.day]
                    [ephysVideoTrials]= getVideoTrialNum(dir_data_SpikeGL, dir_data_video,root, session_name, meta);
                end
                
                
                %                   parent = m.parent(1:end-18);
                %                 day = m.parent(end-17:end-8);
                % %                 load(fullfile(parent, day, datadir, 'MetaData.mat'));
                %                 anmix =strfind(parent, 'anm');
                %                 anm = parent(anmix:anmix+8);
                %
                %                 obj_file_name = fullfile('Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\ProcessedData', ['data_structure_' anm '_' day '.mat']);
                %                 if exist(obj_file_name, 'file') == 2
                %                     load(obj_file_name)
                %                 else
                %                     return;
                %                 end
                
                sessionType = 'sensoryInput'; %sensoryInput or Epsilon
                parent = meta.parent(1:end-18);
                day = meta.parent(end-17:end-8);
                behav = getSoloData(fullfile(parent, day), day, sessionType);
                [c,idx_u,~]=unique(meta.bitcode,'stable');
                usableTrials = intersect(meta.bitcode(idx_u), 1:behav.Ntrials);
                behavTrialsToUse = ismember(1:behav.Ntrials, usableTrials);
                ephysTrialsToUse = ismember(meta.bitcode(idx_u), usableTrials);
                Nusable = numel(usableTrials);
                
                ephys_videos =ephysVideoTrials.Cam{key(1).tracking_device_id+1}.videoNum'; %note that some ephys files might not contain video
                fileName =ephysVideoTrials.Cam{key(1).tracking_device_id+1}.fileName';
                trial=fetchn(EXP.BehaviorTrial & key,'trial');
                
                if numel(ephys_videos)~=numel(trial)
                    disp(['mismatch']);
                end
                
                %use only those trials that have bitcode
                ephys_videos=ephys_videos(ephysTrialsToUse);
                fileName=fileName(ephysTrialsToUse);
                
                %use only those trials that have video associated with them
                idx_ephys_with_videos = ~isnan(ephys_videos);
                ephys_videos = ephys_videos(idx_ephys_with_videos);
                fileName = fileName(idx_ephys_with_videos);
                trial = trial(idx_ephys_with_videos);
                
                
                
                
                %
                for i=1:numel(trial)
                    key(i).subject_id=key(1).subject_id; % repmat((key.subject_id),numel(trial),1);
                    key(i).session=key(1).session;    % repmat(key.session,numel(trial),1);
                    key(i).trial=trial(i);
                    key(i).rig=key(1).rig; %repmat({key.rig},numel(trial),1);
                    key(i).tracking_device_type=key(1).tracking_device_type;   %repmat({key.tracking_device_type},numel(trial),1);
                    key(i).tracking_device_id=key(1).tracking_device_id; %repmat(key.tracking_device_id,numel(trial),1);
                    key(i).tracking_datafile_num=ephys_videos(i);
                    key(i).tracking_datafile_path=fileName{i};
                    key(i).tracking_start_time=1;
                    key(i).tracking_duration=1;
                    key(i).tracking_sampling_rate=400;
                end
                
                insert(self,key)
                
            else
                return
            end
        end
    end
    
end