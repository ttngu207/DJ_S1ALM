%{
# units are cm, deg, and seconds
-> EXP.BehaviorTrial
-> ANL.TongueEstimationType
---

lick_peak_x              : double                      # tongue x coordinate at the peak of the lick. peak is defined at 75% from trough
lick_peak_y              : double                      # tongue y coordinate at the peak of the lick. peak is defined at 75% from trough
lick_amplitude           : double                      # tongue displacement in x,y    at the peak of the lick, peak is defined at 75% from trough
lick_vel_linear          : double                      # median tongue linear velocity during the lick duration, from peak to trough
lick_vel_angular         : double                      # median tongue angular velocity during the lick duration, from peak to trough
lick_vel_angular_absolute         : double             # median absolute tongue angular velocity during the lick duration, from peak to trough

lick_yaw                 : double                      #  tongue yaw at the peak of the lick
lick_yaw_relative        : double                      #  tongue yaw at the peak of the lick, relative to the left lick port
lick_yaw_avg             : double                      #  median tongue yaw  during the lick duration, from peak to trough
lick_yaw_avg_relative    : double                      #  median tongue yaw  during the lick duration, from peak to trough, relative to the left lick port

lick_horizoffset         : double                   # tongue horizontal displacement at the peak of the lick, relative to the midline
lick_horizoffset_relative : double                   # tongue horizontal displacement at the peak of the lick, relative to the middle of the lick port

lick_rt_electric=null    : double                      # rt based on electric lick port
lick_rt_video_onset      : double                        # rt based on video trough
lick_rt_video_peak       : double                      # rt based on video peak

%}


classdef Video1stLickTrial < dj.Computed
    properties
        keySource = ANL.VideoTongueTrial;
    end
    methods(Access=protected)
        
        function makeTuples(self, key)
            
            
            T = fetch(ANL.VideoTongueTrial & key,'*');
            if isempty(T.lick_peak_x)
                return;
            end
            
            
            key.lick_peak_x = T.lick_peak_x(1);
            key.lick_peak_y  = T.lick_peak_y(1);
            key.lick_amplitude  = T.lick_amplitude(1);
            key.lick_vel_linear  = T.lick_vel_linear(1);
            key.lick_vel_angular  = T.lick_vel_angular(1);
            key.lick_vel_angular_absolute  = abs(T.lick_vel_angular(1));

            key.lick_yaw  = T.lick_yaw(1);
            key.lick_yaw_relative  = T.lick_yaw_relative(1);
            
            key.lick_yaw_avg  = T.lick_yaw_avg(1);
            key.lick_yaw_avg_relative  = T.lick_yaw_avg_relative(1);
            
            key.lick_horizoffset  = T.lick_horizoffset(1);
            key.lick_horizoffset_relative = T.lick_horizoffset_relative(1);
            
            key.lick_rt_video_onset = T.lick_rt_video_onset(1);
            key.lick_rt_video_peak = T.lick_rt_video_peak(1);
            
         
            
            if ~isempty(T.lick_rt_electric)
                key.lick_rt_electric  = T.lick_rt_electric(1);
            end
            
            
            insert(self,key)
        end
        
    end
end

