%{
#
-> EXP.BehaviorTrial
-> ANL.TongueEstimationType
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

lick_horizoffset         : double                   # tongue horizontal displacement at the peak of the lick
lick_horizoffset_relative : double                   # tongue horizontal displacement at the peak of the lick, relative to the left lick port

lick_rt_electric=null    : double                      # rt based on electric lick port
lick_rt_video_onset      : double                        # rt based on video trough
lick_rt_video_peak       : double                      # rt based on video peak


%}


classdef Video1stLickTrialNormalized < dj.Computed
    properties
        keySource = ANL.Video1stLickTrial;
    end
    methods(Access=protected)
        
        function makeTuples(self, key)
            
            
            
            k=key;
            k=rmfield(k,'trial');
            T_all_trias=fetch(ANL.Video1stLickTrial & k,'*');
            T=fetch(ANL.Video1stLickTrial & key,'*');
            
            x=[T_all_trias.lick_peak_x];
            idx_outlier = isoutlier(x,'median'); x=x(~idx_outlier);
            key.lick_peak_x = (T.lick_peak_x - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all_trias.lick_peak_y];
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.lick_peak_y = (T.lick_peak_y - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all_trias.lick_amplitude];
            idx_outlier = isoutlier(x,'median'); x=x(~idx_outlier);
            key.lick_amplitude = (T.lick_amplitude - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all_trias.lick_vel_linear];
            idx_outlier = isoutlier(x,'median'); x=x(~idx_outlier);
            key.lick_vel_linear = (T.lick_vel_linear - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all_trias.lick_vel_angular]; 
            idx_outlier = isoutlier(x,'median'); x=x(~idx_outlier);
            key.lick_vel_angular = (T.lick_vel_angular - nanmin(x))/(nanmax(x)-nanmin(x));

            x=[T_all_trias.lick_vel_angular_absolute]; 
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.lick_vel_angular_absolute = (T.lick_vel_angular_absolute - nanmin(x))/(nanmax(x)-nanmin(x));
 
            x=[T_all_trias.lick_yaw];
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.lick_yaw = (T.lick_yaw - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all_trias.lick_yaw_relative];
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.lick_yaw_relative = (T.lick_yaw_relative - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all_trias.lick_yaw_avg];
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.lick_yaw_avg = (T.lick_yaw_avg - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all_trias.lick_yaw_avg_relative];
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.lick_yaw_avg_relative = (T.lick_yaw_avg_relative - nanmin(x))/(nanmax(x)-nanmin(x));
            
            
            
            x=[T_all_trias.lick_horizoffset];
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.lick_horizoffset = (T.lick_horizoffset - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all_trias.lick_horizoffset_relative];
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.lick_horizoffset_relative = (T.lick_horizoffset_relative - nanmin(x))/(nanmax(x)-nanmin(x));
            
            
            
            x=[T_all_trias.lick_rt_electric];
            idx_outlier = isoutlier(x,'median'); x=x(~idx_outlier);
            key.lick_rt_electric = (T.lick_rt_electric - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all_trias.lick_rt_video_onset];
            idx_outlier = isoutlier(x,'median'); x=x(~idx_outlier);
            key.lick_rt_video_onset = (T.lick_rt_video_onset - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all_trias.lick_rt_video_peak];
            idx_outlier = isoutlier(x,'median'); x=x(~idx_outlier);
            key.lick_rt_video_peak = (T.lick_rt_video_peak - nanmin(x))/(nanmax(x)-nanmin(x));
            
            
            
            
%              x=[T_all_trias.lick_peak_x];
%             idx_outlier = isoutlier(x,'median'); x=x(~idx_outlier);
%             key.lick_peak_x = (T.lick_peak_x - nanmin(x))/(nanmax(x)-nanmin(x));
%             
%             x=[T_all_trias.lick_peak_y];
%             idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
%             key.lick_peak_y = (T.lick_peak_y - nanmin(x))/(nanmax(x)-nanmin(x));
%             
%             x=[T_all_trias.lick_amplitude];
%             idx_outlier = isoutlier(x,'median'); x=x(~idx_outlier);
%             key.lick_amplitude = (T.lick_amplitude - nanmin(x))/(nanmax(x)-nanmin(x));
%             
%             x=[T_all_trias.lick_vel_linear];
%             idx_outlier = isoutlier(x,'median'); x=x(~idx_outlier);
%             key.lick_vel_linear = (T.lick_vel_linear - nanmin(x))/(nanmax(x)-nanmin(x));
%             
%             x=[T_all_trias.lick_vel_angular]; 
%             idx_outlier = isoutlier(x,'median'); x=x(~idx_outlier);
%             key.lick_vel_angular = (T.lick_vel_angular - nanmin(x))/(nanmax(x)-nanmin(x));
% 
%             x=[T_all_trias.lick_vel_angular_absolute]; 
%             idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
%             key.lick_vel_angular_absolute = (T.lick_vel_angular_absolute - nanmin(x))/(nanmax(x)-nanmin(x));
%  
%             x=[T_all_trias.lick_yaw];
%             idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
%             key.lick_yaw = (T.lick_yaw - nanmin(x))/(nanmax(x)-nanmin(x));
%             
%             x=[T_all_trias.lick_yaw_relative];
%             idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
%             key.lick_yaw_relative = (T.lick_yaw_relative - nanmin(x))/(nanmax(x)-nanmin(x));
%             
%             x=[T_all_trias.lick_yaw_avg];
%             idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
%             key.lick_yaw_avg = (T.lick_yaw_avg - nanmin(x))/(nanmax(x)-nanmin(x));
%             
%             x=[T_all_trias.lick_yaw_avg_relative];
%             idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
%             key.lick_yaw_avg_relative = (T.lick_yaw_avg_relative - nanmin(x))/(nanmax(x)-nanmin(x));
%             
%             
%             
%             x=[T_all_trias.lick_horizoffset];
%             idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
%             key.lick_horizoffset = (T.lick_horizoffset - nanmin(x))/(nanmax(x)-nanmin(x));
%             
%             x=[T_all_trias.lick_horizoffset_relative];
%             idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
%             key.lick_horizoffset_relative = (T.lick_horizoffset_relative - nanmin(x))/(nanmax(x)-nanmin(x));
%             
%             
%             
%             x=[T_all_trias.lick_rt_electric];
%             idx_outlier = isoutlier(x,'median'); x=x(~idx_outlier);
%             key.lick_rt_electric = (T.lick_rt_electric - nanmin(x))/(nanmax(x)-nanmin(x));
%             
%             x=[T_all_trias.lick_rt_video_onset];
%             idx_outlier = isoutlier(x,'median'); x=x(~idx_outlier);
%             key.lick_rt_video_onset = (T.lick_rt_video_onset - nanmin(x))/(nanmax(x)-nanmin(x));
%             
%             x=[T_all_trias.lick_rt_video_peak];
%             idx_outlier = isoutlier(x,'median'); x=x(~idx_outlier);
%             key.lick_rt_video_peak = (T.lick_rt_video_peak - nanmin(x))/(nanmax(x)-nanmin(x));
            
            insert(self,key)
        end
        
    end
end

