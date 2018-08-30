%{
#
-> EXP.TrackingTrial
-> EXP.VideoFiducialsType
---
fiducial_x_position                 : longblob                   # fiducial coordinate along the X axis of the video image
fiducial_y_position                 : longblob                   # fiducial coordinate along the Y axis of the video image
fiducial_p                          : longblob                   # fiducial probability
fiducial_time                       : longblob                   # fiducial time, relative to Go cue
fiduical_x_position_median=null     : double
fiduical_y_position_median=null     : double
%}


classdef VideoFiducialsTrial < dj.Imported
    properties
        keySource = (EXP.Session  & EXP.TrackingTrial) * EXP.VideoFiducialsType;
    end
    methods(Access=protected)
        
        function makeTuples(self, key)
            p_threshold =0.99;
            dt=1/400;
            
            parent='Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\RawData\video\Test_Set\';
            date=fetch1(EXP.Session & key,'session_date');
            dir_video =[parent 'anm' num2str(key.subject_id) '\' date '\'];
            
            % Get all files in the current folder
            files = dir(dir_video);
            files=files([files.isdir]==0); % get filename (not directory names)
            
            if isempty(files)
                return;
            end
            
            
            video_num_DJ =fetchn(EXP.TrackingTrial  & key,'tracking_datafile_num');
            video_trial =fetchn(EXP.TrackingTrial  & key,'trial');
            
            k.trial_event_type = 'go';
            time_go = fetchn((EXP.BehaviorTrial * EXP.BehaviorTrialEvent * EXP.Session) & EXP.TrackingTrial & key & k,'trial_event_time');
            
            k.trial_event_type = 'trigger ephys rec.';
            time_start_ephys = fetchn((EXP.BehaviorTrial * EXP.BehaviorTrialEvent * EXP.Session) & EXP.TrackingTrial & key & k,'trial_event_time');
            
            time_go_aligned=time_go-time_start_ephys;
            
            
            
            % Loop through each
            for ii = 1:length(files)
                fname = files(ii).name;
                ext(ii) = regexp(fname, '(?<=\.)[^.]*$', 'match');     % Check for extension
            end
            files=files(strcmp(ext,'csv')); % get only csv files
            
            if isempty(files)
                return;
            end
            
            for ii = 1:length(files)
                video_num_CSV (ii) =  str2num(files(ii).name(10:12));
            end
            
            files=files(ismember(video_num_CSV,video_num_DJ)); % get only CSV files with ephys data
            
            video_trial=video_trial(ismember(video_num_DJ,video_num_CSV)); % get only files with ephys data  and decoded video data
            time_go_aligned=time_go_aligned(ismember(video_num_DJ,video_num_CSV)) - 0.2; % get only files with ephys and decoded video data
            
            
            
            [~,temp_fiducial_labels,~] = xlsread([dir_video  files(1).name],'B2:X3');
            fiducial_labels = unique(temp_fiducial_labels(1,:));
            
            for jj= 1: length(fiducial_labels)
                column_idx = find(strcmp(temp_fiducial_labels(1,:),fiducial_labels{jj}),1);
                fiducials_idx(jj).label=fiducial_labels{jj};
                fiducials_idx(jj).XColumn=column_idx;
                fiducials_idx(jj).YColumn=column_idx+1;
                fiducials_idx(jj).ProbColumn=column_idx+2;
            end
            
            
            for ii =1:1:length(video_trial)
                kk=[];
                kk=key;
                
                fname = files(ii).name;
                data = csvread([dir_video fname],3,1);
                
                % temporary fix
                if strcmp(key.video_fiducial_name,'tongue_right')
                    f_idx = find(strcmp({fiducials_idx.label},'tongue_left'));
                elseif  strcmp(key.video_fiducial_name,'tongue_left')
                    f_idx = find(strcmp({fiducials_idx.label},'tongue_right'));
                elseif  strcmp(key.video_fiducial_name,'left_port')
                    f_idx = find(strcmp({fiducials_idx.label},'right_port'));
                elseif  strcmp(key.video_fiducial_name,'right_port')
                    f_idx = find(strcmp({fiducials_idx.label},'left_port'));
                else
                    f_idx = find(strcmp({fiducials_idx.label},key.video_fiducial_name));
                end
                
                X=data(:,fiducials_idx(f_idx).XColumn);
                Y=data(:,fiducials_idx(f_idx).YColumn);
                P=data(:,fiducials_idx(f_idx).ProbColumn);
%                 idx_P = P<p_threshold;
%                 X(idx_P)=[];
%                 Y(idx_P)=[];
%                 P(idx_P)=[];
                
%                 t=1:1:numel(idx_P);
                t=1:1:numel(P);
                t=t*dt+1*dt;
                temp_t = (t + 1) -time_go_aligned(ii);
%                 temp_t(idx_P) = [];
                kk=key;
                
                kk.trial=video_trial(ii);
                
                kk.fiducial_x_position=X;
                kk.fiducial_y_position=Y;
                kk.fiducial_p=P;
                kk.fiducial_time=temp_t';
                
                %for median values we only take those values that passed
                
                idx_P = P<p_threshold;
                X(idx_P)=[];
                Y(idx_P)=[];
                P(idx_P)=[];
                
                kk.fiduical_x_position_median=nanmedian(X);
                kk.fiduical_y_position_median=nanmedian(Y);
                
                insert(self,kk)
            end
            
        end
    end
    
end