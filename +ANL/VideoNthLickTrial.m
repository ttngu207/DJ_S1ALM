%{
# units are cm, deg, and seconds
-> EXP.BehaviorTrial
-> ANL.TongueEstimationType
-> ANL.LickDirectionType
lick_number              : double                      # the lick after the go cue (first lick, second lick, etc)
---

lick_peak_x              : double                      # tongue x coordinate at the peak of the lick. peak is defined at 75% from trough
lick_peak_y              : double                      # tongue y coordinate at the peak of the lick. peak is defined at 75% from trough
lick_amplitude           : double                      # tongue displacement in x,y    at the peak of the lick, peak is defined at 75% from trough
lick_vel_linear          : double                      # median tongue linear velocity during the lick duration, from peak to trough
lick_vel_angular         : double                      # median tongue angular velocity during the lick duration, from peak to trough
lick_vel_angular_absolute         : double                      # median absolute tongue angular velocity during the lick duration, from peak to trough

lick_yaw                 : double                      #  tongue yaw at the peak of the lick
lick_yaw_relative        : double                      #  tongue yaw at the peak of the lick, relative to the left lick port
lick_yaw_avg             : double                      #  median tongue yaw  during the lick duration, from peak to trough
lick_yaw_avg_relative    : double                      #  median tongue yaw  during the lick duration, from peak to trough, relative to the left lick port

lick_horizoffset         : double                   # tongue horizontal displacement at the peak of the lick, relative to the midline
lick_horizoffset_relative : double                   # tongue horizontal displacement at the peak of the lick, relative to the middle of the lick port

lick_rt_video_onset      : double                        # rt based on video trough
lick_rt_video_peak       : double                      # rt based on video peak

%}


classdef VideoNthLickTrial < dj.Computed
    properties
        keySource = ANL.VideoTongueTrial;
    end
    methods(Access=protected)
        
        function makeTuples(self, key)
            
            
            T = fetch(ANL.VideoTongueTrial & key,'*');
            if isempty(T.lick_peak_x)
                return;
            end
            
            for i_d=1:1:2
                if i_d==1
                    key.lick_direction='all';
                end
                for i_l=1:1:numel(T.lick_peak_x)
                    
                    key.lick_number = i_l;
                    
                    if i_d==2
                        if T.lick_horizoffset(i_l)  <0
                            key.lick_direction = 'left';
                        else
                            key.lick_direction = 'right';
                        end
                    end
                    key.lick_peak_x = T.lick_peak_x(i_l);
                    key.lick_peak_y  = T.lick_peak_y(i_l);
                    key.lick_amplitude  = T.lick_amplitude(i_l);
                    key.lick_vel_linear  = T.lick_vel_linear(i_l);
                    key.lick_vel_angular  = T.lick_vel_angular(i_l);
                    key.lick_vel_angular_absolute  = abs(T.lick_vel_angular(i_l));
                    
                    key.lick_yaw  = T.lick_yaw(i_l);
                    key.lick_yaw_relative  = T.lick_yaw_relative(i_l);
                    
                    key.lick_yaw_avg  = T.lick_yaw_avg(i_l);
                    key.lick_yaw_avg_relative  = T.lick_yaw_avg_relative(i_l);
                    
                    key.lick_horizoffset  = T.lick_horizoffset(i_l);
                    key.lick_horizoffset_relative = T.lick_horizoffset_relative(i_l);
                    
                    if i_l==1
                        key.lick_rt_video_onset = T.lick_rt_video_onset(i_l);
                    else
                        key.lick_rt_video_onset = T.lick_rt_video_onset(i_l)-T.lick_rt_video_peak(i_l-1);
                    end
                    key.lick_rt_video_peak = T.lick_rt_video_peak(i_l);
                    
                    insert(self,key)
                    
                end
            end
            
        end
        
    end
end

