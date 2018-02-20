function   [data_Tracking] = Ingest_EXP_Tracking (obj, key, iTrials, tracking_data_dir, allVideoNames, tracking_device, data_Tracking)

if obj.video_flag ==1
    
    suffix = '000';
    file_num = flip(num2str(iTrials));
    for is = 1:1:numel(file_num)
        suffix (4-is) = file_num(is);
    end
    
    for iCamera=1:1:2
        catach_flag=0; %initialize
        
        tracking_data_filename = ['v_cam_' num2str(iCamera-1) '_v' suffix '.avi'];
        tracking_data_path = [tracking_data_dir, tracking_data_filename];
        
        if sum(contains(allVideoNames,tracking_data_filename))
            try
                xyloObj = VideoReader(tracking_data_path);
            catch
                warning('Problem with reading the video file, skipping to the next file');
                info.Duration = NaN;
                catach_flag=1;
            end
            if catach_flag==0
                info = get(xyloObj);
            end
            
            if info.Duration ==1998
                start_time = 2 + 2/400; %the first two frames are dropped
            elseif info.Duration== 2598
                start_time = 1 + 2/400; %the first two frames are dropped
            else
                start_time = NaN;
            end
            duration = info.Duration/400;
            data_Tracking (end+1) = struct(...
                'subject_id',  key.subject_id, 'session', key.session, 'trial', iTrials,'tracking_device', tracking_device{iCamera}, 'tracking_data_path',tracking_data_path, 'start_time',start_time, 'duration', duration  );
        end
    end
end