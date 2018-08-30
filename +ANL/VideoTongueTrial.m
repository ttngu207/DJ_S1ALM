%{
#
-> EXP.BehaviorTrial
-> ANL.TongueEstimationType
---
tongue_tip_x                : longblob                      # fiducial coordinate along the X axis of the video image
tongue_tip_y                : longblob                      # fiducial coordinate along the Y axis of the video image
tongue_time_vec             : longblob                      # fiducial time, relative to Go cue
lick_peak_x=null            : longblob                      #
lick_peak_y=null            : longblob                      #

lick_yaw_peak=null          : longblob                      #
lick_yaw_protrusion=null    : longblob                      #
lick_horizdist_peak=null          : longblob                      #

lick_yaw_peak_relative=null          : longblob                      #
lick_yaw_protrusion_relative=null    : longblob                      #
lick_horizdist_peak_relative=null          : longblob                      #

lick_amplitude=null         : longblob                      #
lick_rt_electric=null       : longblob                      # rt based on electric lick port
lick_rt_video_onset=null    : double                        # rt based on video trough
lick_rt_video_peak=null     : longblob                      # rt based on video peak
%}


classdef VideoTongueTrial < dj.Imported
    properties
        keySource = (EXP.Session  & EXP.VideoFiducialsTrial) * (ANL.TongueEstimationType & 'tongue_estimation_type="center"');
    end
    methods(Access=protected)
        
        function makeTuples(self, key)
            
            dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
            dir_save_figure = [dir_root 'Results\video_tracking\'];
            
            close all;
            
            
            figure1=figure;
            set(gcf,'DefaultAxesFontName','helvetica');
            set(gcf,'PaperUnits','centimeters','PaperPosition',[0.5 7 21 21]);
            set(gcf,'PaperOrientation','portrait');
            set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -10 0 0]);
            
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
            fS(num).x=fetchn(ANL.VideoLandmarksSession & key & k,'session_median_x') - fS(1).x; %removing jaw position;
            fS(num).y=fetchn(ANL.VideoLandmarksSession & key & k,'session_median_y') - fS(1).y; %removing jaw position;
            fS(num).label = k.video_fiducial_name;
            
            
            % Trials
            num=1;
            k.video_fiducial_name='tongue_tip';
            fTr(num).x=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_x_position')')' - fS(1).x; %removing jaw position;
            fTr(num).y=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_y_position')')'- fS(1).y; %removing jaw position;
            fTr(num).p=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_p')')';
            fTr(num).label = k.video_fiducial_name;
            fTr(num).t = cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_time')')';
            
            num=2;
            k.video_fiducial_name='tongue_left';
            fTr(num).x=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_x_position')')' - fS(1).x;
            fTr(num).y=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_y_position')')' - fS(1).y;
            fTr(num).p=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_p')')';
            fTr(num).label = k.video_fiducial_name;
            
            num=3;
            k.video_fiducial_name='tongue_right';
            fTr(num).x=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_x_position')')' - fS(1).x;
            fTr(num).y=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_y_position')')' - fS(1).y;
            fTr(num).p=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_p')')';
            fTr(num).label = k.video_fiducial_name;
            
            
            
            % Trials
            num=4;
            k.video_fiducial_name='left_port';
            fTr(num).x=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_x_position')')' - fS(1).x;
            fTr(num).y=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_y_position')')' - fS(1).y;
            fTr(num).p=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_p')')';
            fTr(num).label = k.video_fiducial_name;
            
            num=5;
            k.video_fiducial_name='right_port';
            fTr(num).x=cell2mat(fetchn(EXP.VideoFiducialsTrial & key & k,'fiducial_x_position')')' - fS(1).x;
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
            
            
            
            p_threshold =0.99;
            
            
            
            counter=0;
            for ii =1:1:numTrials
                ii
                idx_P = fTr(1).p(ii,:)>p_threshold | fTr(2).p(ii,:)>p_threshold | fTr(3).p(ii,:)>p_threshold;
                
                t=fTr(1).t(ii,idx_P);
                if isempty(t) || numel(t)<20
                    continue;
                end
                counter=counter+1;
                
                % Extracting lick times based on electric lick port
                k.trial=trials(ii);
                time_lick_Elect = sort(fetchn(EXP.BehaviorTrial * EXP.ActionEvent * EXP.Session & key & k,'action_event_time'))-time_go(ii); %-0.2;
                trial_instruction = fetch1(EXP.BehaviorTrial * EXP.Session & key & k,'trial_instruction');
                trial_outcome = fetch1(EXP.BehaviorTrial  * EXP.Session & key & k,'outcome');
                early_lick = fetch1(EXP.BehaviorTrial  * EXP.Session & key & k,'early_lick');
                
                % Extracting lick kinematics based on video
                
                if strcmp(key.tongue_estimation_type,'tip')
                    Tongue.x{ii} = fTr(1).x(ii,idx_P);
                    Tongue.y{ii} = fTr(1).y(ii,idx_P);
                    Tongue.label = 'tongue_tip';
                elseif strcmp(key.tongue_estimation_type,'center')
                    Tongue.x{ii} = mean([fTr(1).x(ii,idx_P); fTr(2).x(ii,idx_P); fTr(3).x(ii,idx_P)]);
                    Tongue.y{ii} = mean([fTr(1).y(ii,idx_P); fTr(2).y(ii,idx_P); fTr(3).y(ii,idx_P)]);
                    Tongue.label = 'tongue_COM';
                end
                
                idx_P = fTr(4).p(ii,:)>p_threshold ;
                Ports.Left.X = median(fTr(4).x(ii,idx_P));
                Ports.Left.Y = median(fTr(4).y(ii,idx_P));
                idx_P = fTr(5).p(ii,:)>p_threshold ;
                Ports.Right.X = median(fTr(5).x(ii,idx_P));
                Ports.Right.Y = median(fTr(5).y(ii,idx_P));
                
                % Finding peaks and troughs
                X=Tongue.x{ii} ;
                Y=Tongue.y{ii} ;
                X=smooth(X,5)';
                Y=smooth(Y,5)';
                
                min_time_bin=0.025/(1/400);
                [~,pks_idx] = findpeaks(X, 'MinPeakDistance',min_time_bin,'MinPeakProminence',5);
                
                if isempty(pks_idx)
                    insert_key(counter).tongue_estimation_type = key.tongue_estimation_type;
                    
                    insert_key(counter).subject_id = key.subject_id;
                    insert_key(counter).session = key.session;
                    insert_key(counter).trial = trials(ii);
                    insert_key(counter).tongue_tip_x = X';
                    insert_key(counter).tongue_tip_y = Y';
                    insert_key(counter).tongue_time_vec = t;
                    
                    continue;
                end
                
                
                
                X_trough=-1*(X - max(X));
                if sum(t(pks_idx)>0)>0
                    X_trough(t<=0)=0;
                end
                [~,trough_idx] = findpeaks(X_trough, 'MinPeakDistance',min_time_bin,'MinPeakProminence',5);
                
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
                a=pks_idx(2:end)- pks_idx(1:end-1);
                b=pks_idx(2:end)- corresponding_trough_idx(2:end);
                pks_idx=[pks_idx(1), pks_idx(find((a-b)>0)+1)];
                corresponding_trough_idx=[corresponding_trough_idx(1), corresponding_trough_idx(find((a-b)>0)+1)]+2;
                
                %% angle, amplitude and reaction times
                
                idx_post_cue_peak=find(t(pks_idx)>0);
                [theta_peak,r_peak] = cart2pol(X(pks_idx(idx_post_cue_peak)),Y(pks_idx(idx_post_cue_peak)));
                theta_peak=rad2deg(theta_peak);
                
                RT_VideoPeak= t(pks_idx(idx_post_cue_peak));
                %                 RT_VideoOnset=t(find(t>0,1));
                RT_VideoOnset=t( corresponding_trough_idx(   find(t(corresponding_trough_idx)>0,1) ) );
                RT_Electric = time_lick_Elect(time_lick_Elect>0);
                
                
                %find lick angle from the entire tongue trajectory
                idx_peakstroughs_post_go_cue=  find(t(corresponding_trough_idx)>0);
                pks_idx_post_cue = pks_idx( idx_peakstroughs_post_go_cue);
                corresponding_trough_idx_post_cue = corresponding_trough_idx( idx_peakstroughs_post_go_cue);
                
                theta_protrusion=[];
                for ll=1:1:numel(pks_idx_post_cue)
                    idx=corresponding_trough_idx_post_cue(ll):pks_idx_post_cue(ll);
                    [temp_theta_lick,~] = cart2pol(X(idx),Y(idx));
                    theta_protrusion(ll)=nanmedian(rad2deg(temp_theta_lick));
                end
                
                
                % relative to left lickport
                offset=Ports.Left.Y;
                 [theta_peak_relative,~] = cart2pol(X(pks_idx(idx_post_cue_peak)),Y(pks_idx(idx_post_cue_peak)) - offset );
                theta_peak_relative=rad2deg(theta_peak_relative);

                 theta_protrusion_relative=[];
                for ll=1:1:numel(pks_idx_post_cue)
                    idx=corresponding_trough_idx_post_cue(ll):pks_idx_post_cue(ll);
                    [temp_theta_lick,~] = cart2pol(X(idx),Y(idx)- offset);
                    theta_protrusion_relative(ll)=nanmedian(rad2deg(temp_theta_lick));
                end
                
                
               lick_horizdist_peak=Y(pks_idx(idx_post_cue_peak));    

               lick_horizdist_peak_relative=Y(pks_idx(idx_post_cue_peak))- offset;      
                

                
                
                insert_key(counter).tongue_estimation_type = key.tongue_estimation_type;
                insert_key(counter).subject_id = key.subject_id;
                insert_key(counter).session = key.session;
                insert_key(counter).trial = trials(ii);
                insert_key(counter).tongue_tip_x = X';
                insert_key(counter).tongue_tip_y = Y';
                insert_key(counter).tongue_time_vec = t';
                insert_key(counter).lick_peak_x = X(pks_idx(idx_post_cue_peak))';
                insert_key(counter).lick_peak_y = Y(pks_idx(idx_post_cue_peak))';
                
                insert_key(counter).lick_yaw_peak = theta_peak';
                insert_key(counter).lick_yaw_protrusion = theta_protrusion';
                insert_key(counter).lick_horizdist_peak = lick_horizdist_peak';

                insert_key(counter).lick_yaw_peak_relative = theta_peak_relative';
                insert_key(counter).lick_yaw_protrusion_relative = theta_protrusion_relative';
                insert_key(counter).lick_horizdist_peak_relative = lick_horizdist_peak_relative';

                insert_key(counter).lick_amplitude = r_peak';
                insert_key(counter).lick_rt_video_onset = RT_VideoOnset;
                insert_key(counter).lick_rt_electric = RT_Electric;
                insert_key(counter).lick_rt_video_peak = RT_VideoPeak';
                
                
                
                %% Plotting entire trajectory
                xl=[t(1) t(end)];
                % plotting
                
                axes('position',[position_x1(1), position_y1(1), panel_width1*2, panel_height1]);
                hold on;
                plot(t,X,'.-b');
                if ~isempty(time_lick_Elect)
                    plot(time_lick_Elect, interp1(t,X,time_lick_Elect),'og','LineWidth',1.5)
                end
                xlim(xl);
                ylim([min([0;min(X)]), max([X])]);
                plot(t(pks_idx),X(pks_idx),'xr','LineWidth',1.5);
                plot(t(corresponding_trough_idx),X(corresponding_trough_idx),'xk','LineWidth',1.5);
                if ~isempty(RT_VideoOnset)
                    plot(RT_VideoOnset, X(t==RT_VideoOnset),'sm','LineWidth',3);
                end
                xlabel('Time(s)');
                ylabel('A-P axis (pixels)');
                title(sprintf('v%d %s %s     lick:%s',tracking_datafile_num(ii),trial_instruction,trial_outcome,early_lick))
                
                
                axes('position',[position_x1(1), position_y1(2), panel_width1*2, panel_height1]);
                hold on;
                plot(t,Y,'.-b');
                if ~isempty(time_lick_Elect)
                    plot(time_lick_Elect, interp1(t,Y,time_lick_Elect),'og','LineWidth',1.5)
                end
                xlim(xl);
                %     ylim([min([X]) max([X;1]) ]);
                ylim([min([0;min(Y)]), max([0;max(Y)])]);
                plot(t(pks_idx),Y(pks_idx),'xr','LineWidth',1.5);
                if ~isempty(RT_VideoOnset)
                    plot(RT_VideoOnset, Y(t==RT_VideoOnset),'sm','LineWidth',3);
                end
                xlabel('Time(s)');
                ylabel('M-L axis (pixels)');
                plot([-5 5],[0 0],'-k','LineWidth',2);
                
                axes('position',[position_x1(3), position_y1(2), panel_width1, panel_height1*2.5]);
                hold on;
                plot(Ports.Left.X, Ports.Left.Y,'.c','MarkerSize',100); %left lickport
                plot(Ports.Right.X, Ports.Right.Y,'.y','MarkerSize',100); %right lickport
                plot([0, fS(2).x],[0, fS(2).y],'-k','LineWidth',2); %nose tip
                plot(X, Y,'.-');
                plot(interp1(t,X,time_lick_Elect),interp1(t,Y,time_lick_Elect),'og','Clipping','off','LineWidth',1.5);
                set(gca,'Ydir','reverse')
                xlim([min([0, X, Ports.Left.X, Ports.Right.X]), max([X, Ports.Left.X, Ports.Right.X]) ]);
                ylim([min([0, Y, Ports.Left.Y, Ports.Right.Y]), max([Y, Ports.Left.Y, Ports.Right.Y]) ]);
                plot(X(pks_idx),Y(pks_idx),'xr','LineWidth',1.5);
                if ~isempty(RT_VideoOnset)
                    plot( X(t==RT_VideoOnset), Y(t==RT_VideoOnset),'sm','LineWidth',3);
                end
                xlabel('A-P axis (pixels)');
                ylabel('M-L axis (pixels)');
                
                
                %% Plotting trajectory aroung go cue
                xl=[-0.2 1];
                time_lick_Elect = time_lick_Elect( time_lick_Elect>xl(1) & time_lick_Elect<xl(2));
                idx_post_cue_peak=find(t(pks_idx)>xl(1) & t(pks_idx)<xl(2));
                pks_idx=pks_idx(idx_post_cue_peak);
                
                corresponding_trough_idx=corresponding_trough_idx(idx_post_cue_peak);
                
                idx_post_cue_traj = t>xl(1) & t<xl(2);
                XX=X(idx_post_cue_traj);
                YY=Y(idx_post_cue_traj);
                tt=t(idx_post_cue_traj);
                
                %for trough peak
                idx_post_cue_licks=find(t(pks_idx_post_cue)>xl(1) & t(pks_idx_post_cue)<xl(2));
                pks_idx_post_cue=pks_idx_post_cue(idx_post_cue_licks);
                corresponding_trough_idx_post_cue=corresponding_trough_idx_post_cue(idx_post_cue_licks);
                
                axes('position',[position_x1(1), position_y1(3), panel_width1*2, panel_height1]);
                hold on;
                plot(tt,XX,'.-b');
                if ~isempty(time_lick_Elect)
                    plot(time_lick_Elect, interp1(t,X,time_lick_Elect),'og','LineWidth',1.5)
                end
                xlim(xl);
                ylim([min([0;min(XX)]), max([XX,eps])]);
                plot(t(pks_idx),X(pks_idx),'xr','LineWidth',1.5);
                plot(t(corresponding_trough_idx),X(corresponding_trough_idx),'xk','LineWidth',1.5);
                if ~isempty(RT_VideoOnset)
                    plot(RT_VideoOnset, X(t==RT_VideoOnset),'sm','LineWidth',3);
                end
                xlabel('Time(s)');
                ylabel('A-P axis (pixels)');
                 if ~isempty(theta_peak)
                title(sprintf('yaw = %.1f deg rel yaw = %.1f deg y dist = %.1f rel rel y dist = %.1f', theta_peak(1), theta_peak_relative(1), lick_horizdist_peak(1), lick_horizdist_peak_relative(1)),'Color',[1 0 1],'HorizontalAlignment','Left');
                end
                
                axes('position',[position_x1(1), position_y1(4), panel_width1*2, panel_height1]);
                hold on;
                plot(tt,YY,'.-b');
                if ~isempty(time_lick_Elect)
                    plot(time_lick_Elect, interp1(t,Y,time_lick_Elect),'og','LineWidth',1.5)
                end
                xlim(xl);
                %     ylim([min([X]) max([X;1]) ]);
                ylim([min([0;min(YY)]), max([0;max([YY,eps])])]);
                plot(t(pks_idx),Y(pks_idx),'xr','LineWidth',1.5);
                if ~isempty(RT_VideoOnset)
                    plot(RT_VideoOnset, Y(t==RT_VideoOnset),'sm','LineWidth',3);
                end
                xlabel('Time(s)');
                ylabel('M-L axis (pixels)');
                plot([-5 5],[0 0],'-k','LineWidth',2);
                
                axes('position',[position_x1(3), position_y1(4), panel_width1, panel_height1*2.5]);
                hold on;
              plot(Ports.Left.X, Ports.Left.Y,'.c','MarkerSize',100); %left lickport
                plot(Ports.Right.X, Ports.Right.Y,'.y','MarkerSize',100); %right lickport
                plot([0, fS(2).x],[0, fS(2).y],'-k','LineWidth',2); %nose tip
                plot(XX, YY,'.-');
                plot(interp1(t,X,time_lick_Elect),interp1(t,Y,time_lick_Elect),'og','Clipping','off','LineWidth',1.5);
                if ~isempty(RT_VideoOnset)
                    plot( X(t==RT_VideoOnset), Y(t==RT_VideoOnset),'sm','LineWidth',3);
                end
                set(gca,'Ydir','reverse')
                xlim([min([0, XX, Ports.Left.X, Ports.Right.X]), max([XX, Ports.Left.X, Ports.Right.X]) ]);
                ylim([min([0, YY, Ports.Left.Y, Ports.Right.Y]), max([YY, Ports.Left.Y, Ports.Right.Y]) ]);
                plot(X(pks_idx),Y(pks_idx),'xr','LineWidth',1.5);
                xlabel('A-P axis (pixels)');
                ylabel('M-L axis (pixels)');
                
                
                axes('position',[position_x1(4), position_y1(4), panel_width1, panel_height1*2.5]);
                hold on;
              plot(Ports.Left.X, Ports.Left.Y,'.c','MarkerSize',100); %left lickport
                plot(Ports.Right.X, Ports.Right.Y,'.y','MarkerSize',100); %right lickport
                plot([0, fS(2).x],[0, fS(2).y],'-k','LineWidth',2); %nose tip
                plot(interp1(t,X,time_lick_Elect),interp1(t,Y,time_lick_Elect),'og','Clipping','off','LineWidth',1.5);
                if ~isempty(RT_VideoOnset)
                    plot( X(t==RT_VideoOnset), Y(t==RT_VideoOnset),'sm','LineWidth',3);
                end
                for ll=1:1:numel(pks_idx_post_cue)
                    idx_st=corresponding_trough_idx_post_cue(ll);
                    idx_end=pks_idx_post_cue(ll);
                    plot([X(idx_st),X(idx_end)],[Y(idx_st),Y(idx_end)],'-r');
                end
                set(gca,'Ydir','reverse')
                xlim([min([0, XX, Ports.Left.X, Ports.Right.X]), max([XX, Ports.Left.X, Ports.Right.X]) ]);
                ylim([min([0, YY, Ports.Left.Y, Ports.Right.Y]), max([YY, Ports.Left.Y, Ports.Right.Y]) ]);
                plot(X(pks_idx),Y(pks_idx),'xr','LineWidth',1.5);
                xlabel('A-P axis (pixels)');
                ylabel('M-L axis (pixels)');
               
                
                
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
            insert(self,insert_key)
        end
        
    end
end

