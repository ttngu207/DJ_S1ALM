%{
#
-> EXP.BehaviorTrial
-> ANL.TongueEstimationType
---

lick_peak_x          : double                      # tongue x coordinate at the peak of the lick. peak is defined at 75% from trough
lick_peak_y           : double                      # tongue y coordinate at the peak of the lick. peak is defined at 75% from trough
lick_amplitude       : double                      # tongue displacement in x,y    at the peak of the lick, peak is defined at 75% from trough
lick_vel_linear      : double                      # median tongue linear velocity during the lick duration, from peak to trough
lick_vel_angular      : double                      # median tongue angular velocity during the lick duration, from peak to trough

lick_yaw            : double                      #  tongue yaw at the peak of the lick
lick_yaw_relative      : double                      #  tongue yaw at the peak of the lick, relative to the left lick port
lick_yaw_avg          : double                      #  median tongue yaw  during the lick duration, from peak to trough
lick_yaw_avg_relative  : double                      #  median tongue yaw  during the lick duration, from peak to trough, relative to the left lick port

lick_horizoffset        : double                   # tongue horizontal displacement at the peak of the lick
lick_horizoffset_relative : double                   # tongue horizontal displacement at the peak of the lick, relative to the left lick port

lick_rt_electric=null        : double                      # rt based on electric lick port
lick_rt_video_onset    : double                        # rt based on video trough
lick_rt_video_peak      : double                      # rt based on video peak

%}


classdef VideoLickOnsetTrial < dj.Computed
    properties
        keySource = ANL.VideoTongueTrial;
    end
    methods(Access=protected)
        
        function makeTuples(self, key)
            
            
            T = fetch(ANL.VideoTongueTrial & key,'*');
            if isempty(T.lick_peak_x)
                return;
            end
            
            key.first_lick_peak_x = T.lick_peak_x(1);
            key.first_lick_peak_y = T.lick_peak_y(1);
            key.first_lick_yaw_peak =  T.lick_yaw_peak(1);
            key.first_lick_yaw_protrusion =  T.lick_yaw_protrusion(1);
            key.first_lick_amplitude = T.lick_amplitude(1);
            key.first_lick_rt_video_onset = T.lick_rt_video_onset(1);
            key.first_lick_rt_video_peak = T.lick_rt_video_peak(1);
            
            key.first_lick_horizdist_peak  = T.lick_horizdist_peak(1);
            key.first_lick_yaw_peak_relative = T.lick_yaw_peak_relative(1);
            key.first_lick_yaw_protrusion_relative = T.lick_yaw_protrusion_relative(1);
            key.first_lick_horizdist_peak_relative    = T.lick_horizdist_peak_relative(1);
            
            
            if ~isempty(T.lick_rt_electric)
                key.first_lick_rt_electric  = T.lick_rt_electric(1);
            end
            
            
            insert(self,key)
        end
        
    end
end

