%{
#
-> EXP.BehaviorTrial
-> ANL.TongueEstimationType
---
first_lick_peak_x            : double
first_lick_peak_y            : double
first_lick_yaw_peak          : double
first_lick_yaw_protrusion=null    : double
first_lick_amplitude         : double

lick_horizdist_peak         : double                  
lick_yaw_peak_relative          : double                      
lick_yaw_protrusion_relative=null    : double                      
lick_horizdist_peak_relative        : longblob                      

first_lick_rt_video_onset    : double
first_lick_rt_video_peak     : double
first_lick_rt_electric=null  : double

%}


classdef VideoLickOnsetTrial < dj.Imported
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
            
            key.lick_horizdist_peak  = T.lick_horizdist_peak(1);
            key.lick_yaw_peak_relative = T.lick_yaw_peak_relative(1);
            key.lick_yaw_protrusion_relative = T.lick_yaw_protrusion_relative(1);
            key.lick_horizdist_peak_relative    = T.lick_horizdist_peak_relative(1);
            
            
            if ~isempty(T.lick_rt_electric)
                key.first_lick_rt_electric  = T.lick_rt_electric(1);
            end
            
            
            insert(self,key)
        end
        
    end
end

