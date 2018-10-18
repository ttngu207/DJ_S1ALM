%{
# units are mm, deg, and seconds
-> EXP.BehaviorTrial
-> ANL.TongueEstimationType
---

lick_peak_x=null            : longblob                      # tongue x coordinate at the peak of the lick. peak is defined at 75% from trough
lick_peak_y=null            : longblob                      # tongue y coordinate at the peak of the lick, relative to midline. peak is defined at 75% from trough
lick_amplitude =null        : longblob                      # tongue displacement in x,y    at the peak of the lick, peak is defined at 75% from trough
lick_vel_linear =null       : longblob                      # median tongue linear velocity during the lick duration, from peak to trough
lick_vel_angular =null      : longblob                      # median tongue angular velocity during the lick duration, from peak to trough

lick_yaw=null               : longblob                      #  tongue yaw at the peak of the lick
lick_yaw_relative=null      : longblob                      #  tongue yaw at the peak of the lick, relative to the left lick port
lick_yaw_avg=null           : longblob                      #  median tongue yaw  during the lick duration, from peak to trough
lick_yaw_avg_relative=null  : longblob                      #  median tongue yaw  during the lick duration, from peak to trough, relative to the left lick port

lick_horizoffset=null          : longblob                   # tongue horizontal displacement at the peak of the lick, relative to midline. Positive values - right port, negative values - left port. Normalized to the distance between ports.
lick_horizoffset_relative=null : longblob                   # tongue horizontal displacement at the peak of the lick, relative to the left lick port

lick_rt_electric=null        : longblob                      # rt based on electric lick port
lick_rt_video_onset=null     : longblob                      # rt based on video trough
lick_rt_video_peak=null      : longblob                      # rt based on video peak
%}



% tongue_x       =null              : longblob                      # tongue x coordinate
% tongue_y       =null              : longblob                      # tongue x coordinate - note that it is reversed here compared to the real data - left appears as right
% tongue_yaw       =null            : longblob                      # yaw angle - turning towards the real left lick-port is negative
% tongue_amplitude   =null          : longblob                      # tongue displacement in x,y
% tongue_vel_linear   =null         : longblob                      # linear velocity
% tongue_vel_angular =null          : longblob                      # angular velocity - turning towards the real left lick-port is negative
% tongue_time =null                 : longblob                      # fiducial time, relative to Go cue
% 



classdef VideoTongueTrial < dj.Computed
    properties
        keySource = (EXP.Session  & EXP.VideoFiducialsTrial) * (ANL.TongueEstimationType & 'tongue_estimation_type="tip"');
    end
    methods(Access=protected)
        
        function makeTuples(self, key)
            
            MinPeakDistance=0.1/(1/400); %frames
            MinPeakProminence=2; %pixels
            
            dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
            dir_save_figure = [dir_root 'Results\video_tracking\'];
            
            close all;
            
            flag_plot=1;
            
            if flag_plot==1
                figure1=figure;
                set(gcf,'DefaultAxesFontName','helvetica');
                set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 7 21 21]);
                set(gcf,'PaperOrientation','portrait');
                set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -10 0 0]);
            end
            
            panel_width1=0.18;
            panel_height1=0.15;
            horizontal_distance1=0.23;
            vertical_distance1=0.22;
            
            position_x1(1)=0.07;
            position_x1(2)=position_x1(1)+horizontal_distance1;
            position_x1(3)=position_x1(2)+horizontal_distance1;
            position_x1(4)=position_x1(3)+horizontal_distance1;
            position_x1(5)=position_x1(4)+horizontal_distance1;
            position_x1(6)=position_x1(5)+horizontal_distance1;
            position_x1(7)=position_x1(6)+horizontal_distance1;
            
            position_y1(1)=0.77;
            position_y1(2)=position_y1(1)-vertical_distance1;
            position_y1(3)=position_y1(2)-vertical_distance1;
            position_y1(4)=position_y1(3)-vertical_distance1;
            
            % Session averages
            num=1;
            k.video_fiducial_name='jaw';
            fS(num).x=fetchn(ANL.VideoLandmarksSession & key & k,'session_median_x');
            fS(num).y=fetchn(ANL.VideoLandmarksSession & key & k,'session_median_y');
            fS(num).label = k.video_fiducial_name;
            
            num=2;
            k.video_fiducial_name='nose_tip';
            fS(num).x=fetchn(ANL.VideoLandmarksSession & key & k,'session_median_x'); %- fS(1).x; %removing jaw position;
            fS(num).y=fetchn(ANL.VideoLandmarksSession & key & k,'session_median_y') - fS(1).y; %removing jaw position;
            fS(num).label = k.video_fiducial_name;
            
            
            x_origin=(fS(2).x -fS(1).x)*0.5;
            fS(2).x=fS(2).x- x_origin;
            

            % Trials
            num=1;
            k.video_fiducial_name='tongue_tip';
            fTr(num).x=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_x_position')')' - x_origin; %removing jaw position;
            fTr(num).y=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_y_position')')'- fS(1).y; %removing jaw position;
            fTr(num).p=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_p')')';
            fTr(num).label = k.video_fiducial_name;
            fTr(num).t = cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_time')')';
            
            num=2;
            k.video_fiducial_name='tongue_left';
            fTr(num).x=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_x_position')')' - x_origin;
            fTr(num).y=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_y_position')')' - fS(1).y;
            fTr(num).p=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_p')')';
            fTr(num).label = k.video_fiducial_name;
            
            num=3;
            k.video_fiducial_name='tongue_right';
            fTr(num).x=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_x_position')')' - x_origin;
            fTr(num).y=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_y_position')')' - fS(1).y;
            fTr(num).p=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_p')')';
            fTr(num).label = k.video_fiducial_name;
            
            
            
            % Trials
            num=4;
            k.video_fiducial_name='left_port';
            fTr(num).x=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_x_position')')' - x_origin;
            fTr(num).y=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_y_position')')' - fS(1).y;
            fTr(num).p=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_p')')';
            fTr(num).label = k.video_fiducial_name;
            
            num=5;
            k.video_fiducial_name='right_port';
            fTr(num).x=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_x_position')')' - x_origin;
            fTr(num).y=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_y_position')')' - fS(1).y;
            fTr(num).p=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_p')')';
            fTr(num).label = k.video_fiducial_name;
            
            
            
            
            % Number of trials, filenames etc.
            key.session_date=fetch1(EXP.Session & key,'session_date');
            numTrials=size(fTr(1).x,1);
            trials = sort((unique(fetchn(EXP.VideoFiducialsTrial & key,'trial'))));
            time_go = fetchn(EXP.BehaviorTrial * EXP.BehaviorTrialEvent * EXP.Session & key & 'trial_event_type="go"','trial_event_time','ORDER BY trial'); % to be used to extrack electric lick port timing relative to Go cue
            time_go=time_go(trials);
            
            tracking_datafile_trials = fetchn(EXP.TrackingTrial & key,'trial','ORDER BY trial');
            tracking_datafile_num = fetchn(EXP.TrackingTrial & key,'tracking_datafile_num','ORDER BY trial');
            tracking_datafile_num =tracking_datafile_num(ismember(tracking_datafile_trials,trials));
            
            
            Param = struct2table(fetch (ANL.Parameters,'*'));
            camera_bottomview_pixels_to_mm = Param.parameter_value{(strcmp('camera_bottomview_pixels_to_mm',Param.parameter_name))};


            p_threshold =0.99;
            
            
            
            counter=0;
            for ii =1:1:numTrials
                ii
                
                if strcmp(key.tongue_estimation_type,'tip')
                                        idx_P = fTr(1).p(ii,:)>p_threshold | fTr(2).p(ii,:)>p_threshold | fTr(3).p(ii,:)>p_threshold;
%                     idx_P = fTr(1).p(ii,:)>p_threshold;
                    
                    X_all= fTr(1).x(ii,:);
                    Y_all = fTr(1).y(ii,:);
                elseif strcmp(key.tongue_estimation_type,'center')
                    idx_P = fTr(1).p(ii,:)>p_threshold | fTr(2).p(ii,:)>p_threshold | fTr(3).p(ii,:)>p_threshold;
                    
                    X_all = mean([fTr(1).x(ii,:); fTr(2).x(ii,:); fTr(3).x(ii,:)]);
                    Y_all = mean([fTr(1).y(ii,:); fTr(2).y(ii,:); fTr(3).y(ii,:)]);
                end
                t_all=fTr(1).t(ii,:);
                X_all(~idx_P)=-1;
                Y_all(~idx_P)=-1;
                
                % Taking only frames in which the tongue was seen
                t=fTr(1).t(ii,idx_P);
                X=X_all(idx_P);
                Y=Y_all(idx_P);
                
                X=smooth(X,5)';
                Y=smooth(Y,5)';
                
                
                if isempty(t) || numel(t)<20
                    continue;
                end
                counter=counter+1;
                
                
                % Extracting lick port positions
                idx_P4 = fTr(4).p(ii,:)>p_threshold ;
                Ports.Left.X = median(fTr(4).x(ii,idx_P4));
                Ports.Left.Y = median(fTr(4).y(ii,idx_P4));
                idx_P5 = fTr(5).p(ii,:)>p_threshold ;
                Ports.Right.X = median(fTr(5).x(ii,idx_P5));
                Ports.Right.Y = median(fTr(5).y(ii,idx_P5));
                
                
                % Extracting lick times based on electric lick port
                k.trial=trials(ii);
                time_lick_Elect = sort(fetchn(EXP.BehaviorTrial * EXP.ActionEvent * EXP.Session & key & k,'action_event_time'))-time_go(ii); %-0.2;
                trial_instruction = fetch1(EXP.BehaviorTrial * EXP.Session & key & k,'trial_instruction');
                trial_outcome = fetch1(EXP.BehaviorTrial  * EXP.Session & key & k,'outcome');
                early_lick = fetch1(EXP.BehaviorTrial  * EXP.Session & key & k,'early_lick');
                
                % Extracting lick kinematics based on video
                
                
                
                % finding tongue angle, amplitude and vel
                [tongue_yaw, tongue_amplitude] = cart2pol(X,Y);
                tongue_yaw=rad2deg(tongue_yaw);
                tongue_vel_linear = [0,diff(tongue_amplitude)];
                tongue_vel_linear=smooth(tongue_vel_linear,5)';
                tongue_vel_angular = [0,diff(Y)];
                tongue_vel_angular=smooth(tongue_vel_angular,5)';
                
                % Finding peaks and troughs
                [~,pks_idx] = findpeaks(X_all, 'MinPeakDistance',MinPeakDistance,'MinPeakProminence',MinPeakProminence);
                
                if isempty(pks_idx) ||  numel(X)>1000
                    insert_key(counter).tongue_estimation_type = key.tongue_estimation_type;
                    
                    insert_key(counter).subject_id = key.subject_id;
                    insert_key(counter).session = key.session;
                    insert_key(counter).trial = trials(ii);
                   
                    continue;
                end
                
                
                
                X_trough=-1*(X_all - max(X_all));
                if sum(t_all(pks_idx)>0)>0
                    X_trough(t_all<=0)=0;
                end
                [~,trough_idx] = findpeaks(X_trough, 'MinPeakDistance',MinPeakDistance,'MinPeakProminence',MinPeakProminence);
                
                corresponding_trough_idx=[];
                for ll=1:1:numel(pks_idx)
                    temp_idx=find((trough_idx - pks_idx(ll))<0,1,'last');
                    if isempty(temp_idx) && ll==1
                        trough_idx=[1,trough_idx];
                        corresponding_trough_idx(ll)=1;
                    else
                        corresponding_trough_idx(ll)=trough_idx(temp_idx);
                    end
                end
                trough_idx=corresponding_trough_idx; %take only troughs that match to peaks
                
                a=pks_idx(2:end)- pks_idx(1:end-1);
                b=pks_idx(2:end)- trough_idx(2:end);
                pks_idx=[pks_idx(1), pks_idx(find((a-b)>0)+1)];
                trough_idx=[trough_idx(1), trough_idx(find((a-b)>0)+1)]+1;
                
                add_idx=[];
                for ip=1:1:numel(trough_idx)
                    add_idx(ip)=find( X_all(trough_idx(ip):pks_idx(ip))>-0,1)-1;
                end
                trough_idx=trough_idx+add_idx;
                
%                 %%%for debug
%                                 hold on
%                                 plot(t_all,X_all,'.-')
%                                 plot(t_all(trough_idx),X_all(trough_idx),'xk')
%                                                 plot(t_all(pks_idx),X_all(pks_idx),'xr')
%                 
                pks_idx= find(ismember(t,t_all(pks_idx)));
                trough_idx= find(ismember(t,t_all(trough_idx)));
                
                bad=(pks_idx==trough_idx);
                pks_idx(bad)=[];
                trough_idx(bad)=[];

                if isempty(pks_idx)
                    insert_key(counter).tongue_estimation_type = key.tongue_estimation_type;
                    
                    insert_key(counter).subject_id = key.subject_id;
                    insert_key(counter).session = key.session;
                    insert_key(counter).trial = trials(ii);
                
                    
                    continue
                end
                
                
                % defining peak as 75% from trough to peak
                
                peak_to_trough=  tongue_amplitude(pks_idx) - tongue_amplitude(trough_idx);
                peak_at_75=peak_to_trough*0.75 + tongue_amplitude(trough_idx);
                pks75_idx=[];
                for i_p=1:1:numel(pks_idx)
                    current_idx=trough_idx(i_p):pks_idx(i_p);
                    [~,temp_idx]= min(abs(tongue_amplitude(current_idx) - peak_at_75(i_p)));
                    pks75_idx (i_p) = trough_idx(i_p) + (temp_idx-1);
                end
                
                % ensuring the trough is belonging to the same lick as the peak
                for i_p=1:1:numel(pks_idx)
                    current_idx=trough_idx(i_p):pks_idx(i_p);
                    lickbout_start_idx=find(diff(diff(t(current_idx)))>-(1/400),1);
                    if isempty(lickbout_start_idx)
                        lickbout_start_idx=1;
                    end
                    trough_idx(i_p) = current_idx(1)+lickbout_start_idx -1;
                end
                
                
            

                
                
                %% angle, amplitude and reaction times
                offset=(Ports.Left.Y+Ports.Right.Y)/2; %relative to the mid-distance between the lickports
                
                %find lick angle at peak
                %----------------------------------------------------------
                [lick_yaw,lick_amplitude] = cart2pol(X(pks_idx),Y(pks_idx));
                lick_yaw=rad2deg(lick_yaw); % reversing the angle because  the video recorded is flipped - left side appears on the right
                
                % relative to left lickport
                [lick_yaw_relative,~] = cart2pol(X(pks_idx),Y(pks_idx) - offset );
                lick_yaw_relative=rad2deg(lick_yaw_relative);
                
                
                %find the average lick angle and velocity during the entire outbound lick (not only at the peak of the lick)
                %----------------------------------------------------------
                yaw_avg=[];
                lick_vel_linear=[];
                lick_vel_angular=[];
                for ll=1:1:numel(pks_idx)
                    idx=trough_idx(ll):pks_idx(ll);
                    [temp_theta_lick,~] = cart2pol(X(idx),Y(idx));
                    yaw_avg(ll)=nanmedian(rad2deg(temp_theta_lick));
                    lick_vel_linear(ll)=nanmedian(tongue_vel_linear(idx));
                    lick_vel_angular(ll)=nanmedian(tongue_vel_angular(idx));
                end
                
                % relative to left lickport
                yaw_avg_relative=[];
                for ll=1:1:numel(pks_idx)
                    idx=trough_idx(ll):pks_idx(ll);
                    [temp_theta_lick,~] = cart2pol(X(idx),Y(idx)- offset);
                    yaw_avg_relative(ll)=nanmedian(rad2deg(temp_theta_lick));
                end
                
                % horizontal displacement
                %----------------------------------------------------------
                % relative to ML midline
%                 plot([0, fS(2).x],[0, fS(2).y],'-k','LineWidth',2); %nose tip
%                 midline_slope = fS(2).y/fS(2).x;
%                 eq_midline = @(b, x) (b*x); %Logistic function
                lick_horizoffset=Y(pks_idx);%-eq_midline(midline_slope, X(pks_idx)));

                
                % relative to the middle of the lickports
                lick_horizoffset_relative=Y(pks_idx)- offset;
                
%                                
                
                

                idx_noearly_licks= find(t(trough_idx)>0);
                
                
                % Reaction time
                %----------------------------------------------------------
                RT_VideoPeak= t (pks_idx (idx_noearly_licks));
                RT_VideoOnset=t (trough_idx (idx_noearly_licks));
                RT_Electric = time_lick_Elect(time_lick_Elect>0);
                
                
                
                insert_key(counter).tongue_estimation_type = key.tongue_estimation_type;
                insert_key(counter).subject_id = key.subject_id;
                insert_key(counter).session = key.session;
                insert_key(counter).trial = trials(ii);
%                 insert_key(counter).tongue_x = X';
%                 insert_key(counter).tongue_y = Y';
%                 insert_key(counter).tongue_yaw = tongue_yaw';
%                 insert_key(counter).tongue_amplitude = tongue_amplitude';
%                 insert_key(counter).tongue_vel_linear = tongue_vel_linear';
%                 insert_key(counter).tongue_vel_angular = tongue_vel_angular' *(-1);
%                 insert_key(counter).tongue_time = t;
                
                %parsed by licks
                insert_key(counter).lick_peak_x = X(pks_idx(idx_noearly_licks))'*camera_bottomview_pixels_to_mm;
                insert_key(counter).lick_peak_y = Y(pks_idx(idx_noearly_licks))'*camera_bottomview_pixels_to_mm;
                insert_key(counter).lick_amplitude = lick_amplitude(idx_noearly_licks)'*camera_bottomview_pixels_to_mm;
                insert_key(counter).lick_vel_linear = lick_vel_linear(idx_noearly_licks)'*camera_bottomview_pixels_to_mm;
                insert_key(counter).lick_vel_angular = lick_vel_angular(idx_noearly_licks)' *(-1);
                
                insert_key(counter).lick_yaw = lick_yaw(idx_noearly_licks)' *(-1);
                insert_key(counter).lick_yaw_relative = lick_yaw_relative(idx_noearly_licks)' *(-1);
                
                insert_key(counter).lick_yaw_avg = yaw_avg(idx_noearly_licks)' *(-1);
                insert_key(counter).lick_yaw_avg_relative = yaw_avg_relative(idx_noearly_licks)' *(-1);
                
                insert_key(counter).lick_horizoffset = lick_horizoffset(idx_noearly_licks)' *(-1)*camera_bottomview_pixels_to_mm;
                insert_key(counter).lick_horizoffset_relative = lick_horizoffset_relative(idx_noearly_licks)' *(-1)*camera_bottomview_pixels_to_mm;
                
                insert_key(counter).lick_rt_video_onset = RT_VideoOnset;
                insert_key(counter).lick_rt_electric = RT_Electric;
                insert_key(counter).lick_rt_video_peak = RT_VideoPeak';
                
                if flag_plot==1
                    
                    %% Plotting entire trajectory
                    xl=[t(1) t(end)];
                    
                    % A-P axis
                    axes('position',[position_x1(1), position_y1(1), panel_width1*2, panel_height1]);
                    hold on;
                    plot(t,X,'.b');
                    if ~isempty(time_lick_Elect)
                        plot(time_lick_Elect, interp1(t,X,time_lick_Elect),'og','LineWidth',1.5)
                    end
                    xlim(xl);
                    ylim([min([0;min(X)]), max([X])]);
                    plot(t(pks_idx),X(pks_idx),'xr','LineWidth',1.5);
                    plot(t(trough_idx),X(trough_idx),'xk','LineWidth',1.5);
                    if ~isempty(RT_VideoOnset)
                        plot(RT_VideoOnset(1), X(t==RT_VideoOnset(1)),'sm','LineWidth',3);
                    end
                    xlabel('Time(s)');
                    ylabel('A-P axis (pixels)');
                    title(sprintf('DJtrial %d video%d %s %s     lick:%s',trials(ii), tracking_datafile_num(ii),trial_instruction,trial_outcome,early_lick))
                    
                    %M-L axis
                    axes('position',[position_x1(1), position_y1(2), panel_width1*2, panel_height1]);
                    hold on;
                    plot(t,Y,'.b');
                    if ~isempty(time_lick_Elect)
                        plot(time_lick_Elect, interp1(t,Y,time_lick_Elect),'og','LineWidth',1.5)
                    end
                    xlim(xl);
                    %     ylim([min([X]) max([X;1]) ]);
                    ylim([min([0;min(Y)]), max([0;max(Y)])]);
                    plot(t(pks_idx),Y(pks_idx),'xr','LineWidth',1.5);
                    if ~isempty(RT_VideoOnset)
                        plot(RT_VideoOnset(1), Y(t==RT_VideoOnset(1)),'sm','LineWidth',3);
                    end
                    xlabel('Time(s)');
                    ylabel('M-L axis (pixels)');
                    plot([-5 5],[0 0],'-k','LineWidth',2);
                    
                    %X-Y
                    axes('position',[position_x1(3), position_y1(2), panel_width1, panel_height1*2.5]);
                    hold on;
                    plot(Ports.Left.X, Ports.Left.Y,'or','MarkerSize',20,'LineWidth',3); %left lickport
                    plot(Ports.Right.X, Ports.Right.Y,'ob','MarkerSize',20,'LineWidth',3); %right lickport
                    plot([0, fS(2).x],[0, fS(2).y],'-k','LineWidth',2); %nose tip
                    plot(X, Y,'.-');
                    plot(interp1(t,X,time_lick_Elect),interp1(t,Y,time_lick_Elect),'og','Clipping','off','LineWidth',1.5);
                    set(gca,'Ydir','reverse')
                    axis equal
                    xlim([min([0, X, Ports.Left.X-5, Ports.Right.X-5]), max([X, Ports.Left.X+5, Ports.Right.X]+5) ]);
                    ylim([min([0, Y, Ports.Left.Y-5, Ports.Right.Y-5]), max([Y, Ports.Left.Y+5, Ports.Right.Y+5]) ]);
                    plot(X(pks_idx),Y(pks_idx),'xr','LineWidth',1.5);
                    if ~isempty(RT_VideoOnset)
                        plot( X(t==RT_VideoOnset(1)), Y(t==RT_VideoOnset(1)),'sm','LineWidth',3);
                    end
                    xlabel('A-P axis (pixels)');
                    ylabel('M-L axis (pixels)');
                    
                    
                    
                    
                    
                    
                    
                    %% Plotting trajectory around go cue
                    
                    xl=[-0.2 1];
                    time_lick_Elect = time_lick_Elect( time_lick_Elect>xl(1) & time_lick_Elect<xl(2));
                    
                    idx_noearly_licks= find( t(trough_idx)>xl(1) & t(pks_idx)<xl(2));
                    
                    pks_idx=pks_idx(idx_noearly_licks);
                    trough_idx=trough_idx(idx_noearly_licks);
                    
                    idx_post_cue_t = t>xl(1) & t<xl(2);
                    XX=X(idx_post_cue_t);
                    YY=Y(idx_post_cue_t);
                    tt=t(idx_post_cue_t);
                    
                    tongue_amplitudePOSTCUE=tongue_amplitude(idx_post_cue_t);
                    tongue_velPOSTCUE=tongue_vel_linear(idx_post_cue_t);
                    
                    
                    
                    
                    % Amplitude
                    axes('position',[position_x1(1), position_y1(3), panel_width1*2, panel_height1]);
                    hold on;
                    plot(tt,tongue_amplitudePOSTCUE,'.b');
                    if ~isempty(time_lick_Elect)
                        plot(time_lick_Elect, interp1(t,tongue_amplitude,time_lick_Elect),'og','LineWidth',1.5)
                    end
                    xlim(xl);
                    ylim([min([0;min(tongue_amplitudePOSTCUE)]), max([tongue_amplitudePOSTCUE,eps])]);
                    plot(t(pks_idx),tongue_amplitude(pks_idx),'xr','LineWidth',1.5);
                    plot(t(trough_idx),tongue_amplitude(trough_idx),'xk','LineWidth',1.5);
                    if ~isempty(RT_VideoOnset)
                        plot(RT_VideoOnset(1), tongue_amplitude(t==RT_VideoOnset(1)),'sm','LineWidth',3);
                    end
                    xlabel('Time(s)');
                    ylabel('Amplitude (pixels)');
                    
                    %Velocity
                    axes('position',[position_x1(1), position_y1(4), panel_width1*2, panel_height1]);
                    hold on;
                    plot(tt,tongue_velPOSTCUE,'.b');
                    if ~isempty(time_lick_Elect)
                        plot(time_lick_Elect, interp1(t,tongue_vel_linear,time_lick_Elect),'og','LineWidth',1.5)
                    end
                    xlim(xl);
                    %     ylim([min([X]) max([X;1]) ]);
                    ylim([min([0;min(tongue_velPOSTCUE)]), max([0;max([tongue_velPOSTCUE,eps])])]);
                    plot(t(pks_idx),tongue_vel_linear(pks_idx),'xr','LineWidth',1.5);
                    if ~isempty(RT_VideoOnset)
                        plot(RT_VideoOnset(1), tongue_vel_linear(t==RT_VideoOnset(1)),'sm','LineWidth',3);
                    end
                    xlabel('Time(s)');
                    ylabel(sprintf('Linear Velocity \n(pixels/frame)'));
                    plot([-5 5],[0 0],'-k','LineWidth',2);
                    
                    
                    % X-Y
                    axes('position',[position_x1(3), position_y1(4), panel_width1, panel_height1*2.5]);
                    hold on;
                    plot(Ports.Left.X, Ports.Left.Y,'or','MarkerSize',20,'LineWidth',3); %left lickport
                    plot(Ports.Right.X, Ports.Right.Y,'ob','MarkerSize',20,'LineWidth',3); %right lickport
                    plot([0, fS(2).x],[0, fS(2).y],'-k','LineWidth',2); %nose tip
                    plot(XX, YY,'.-');
                    plot(interp1(t,X,time_lick_Elect),interp1(t,Y,time_lick_Elect),'og','Clipping','off','LineWidth',1.5);
                    if ~isempty(RT_VideoOnset)
                        plot( X(t==RT_VideoOnset(1)), Y(t==RT_VideoOnset(1)),'sm','LineWidth',3);
                    end
                    %                 set(gca,'Ydir','reverse')
                    axis equal
                    xlim([min([0, XX, Ports.Left.X-5, Ports.Right.X-5]), max([XX, Ports.Left.X+5, Ports.Right.X]+5) ]);
                    ylim([min([0, YY, Ports.Left.Y-5, Ports.Right.Y-5]), max([YY, Ports.Left.Y+5, Ports.Right.Y+5]) ]);
                    plot(X(pks_idx),Y(pks_idx),'xr','LineWidth',1.5);
                    xlabel('A-P axis (pixels)');
                    ylabel('M-L axis (pixels)');
                    set(gca,'Ydir','reverse')
                    if ~isempty(idx_noearly_licks)
                        title(sprintf('yaw = %.1f ; rel yaw = %.1f ; \n horzoffset = %.1f ;  rel horzoffset = %.1f\n', lick_yaw(idx_noearly_licks(1)), lick_yaw_relative(idx_noearly_licks(1)), lick_horizoffset(idx_noearly_licks(1)), lick_horizoffset_relative(idx_noearly_licks(1))),'Color',[1 0 1]);
                    end
                    
                    %X-Y licks
                    axes('position',[position_x1(4), position_y1(4), panel_width1, panel_height1*2.5]);
                    hold on;
                    plot(Ports.Left.X, Ports.Left.Y,'or','MarkerSize',20,'LineWidth',3); %left lickport
                    plot(Ports.Right.X, Ports.Right.Y,'ob','MarkerSize',20,'LineWidth',3); %right lickport
                    plot([0, fS(2).x],[0, fS(2).y],'-k','LineWidth',2); %nose tip
                    plot(interp1(t,X,time_lick_Elect),interp1(t,Y,time_lick_Elect),'og','Clipping','off','LineWidth',1.5);
                    if ~isempty(RT_VideoOnset)
                        plot( X(t==RT_VideoOnset(1)), Y(t==RT_VideoOnset(1)),'sm','LineWidth',3);
                    end
                    for ll=1:1:numel(pks_idx)
                        idx_st=trough_idx(ll);
                        idx_end=pks_idx(ll);
                        plot([X(idx_st),X(idx_end)],[Y(idx_st),Y(idx_end)],'-r');
                    end
                    %                 set(gca,'Ydir','reverse')
                    axis equal
                    xlim([min([0, XX, Ports.Left.X-5, Ports.Right.X-5]), max([XX, Ports.Left.X+5, Ports.Right.X]+5) ]);
                    ylim([min([0, YY, Ports.Left.Y-5, Ports.Right.Y-5]), max([YY, Ports.Left.Y+5, Ports.Right.Y+5]) ]);
                    plot(X(pks_idx),Y(pks_idx),'xr','LineWidth',1.5);
                    xlabel('A-P axis (pixels)');
                    %                 ylabel('M-L axis (pixels)');
                    set(gca,'Ydir','reverse')
                    
                    
                    %
                    filename = [ 'vid' num2str(tracking_datafile_num(ii)) '_bottom'];
                    dir_save_figure_full=[dir_save_figure 'anm' num2str(key.subject_id) '\' key.session_date '\'];
                    if isempty(dir(dir_save_figure_full))
                        mkdir (dir_save_figure_full)
                    end
                    figure_name_out=[dir_save_figure_full  filename '_' key.tongue_estimation_type];
                    eval(['print ', figure_name_out, ' -dtiff -cmyk -r200']);
                    %                 eval(['print ', figure_name_out, ' -painters -dpdf -cmyk -r200']);
                    
                    clf;
                    
                end
                
                
                
            end
            insert(self,insert_key)
        end
        
    end
end

