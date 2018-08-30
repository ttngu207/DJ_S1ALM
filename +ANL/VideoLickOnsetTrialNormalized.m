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

first_lick_rt_video_onset     : double
first_lick_rt_video_peak     : double
first_lick_rt_electric=null  : double

%}


classdef VideoLickOnsetTrialNormalized < dj.Imported
    properties
        keySource = ANL.VideoLickOnsetTrial;
    end
    methods(Access=protected)
        
        function makeTuples(self, key)
            
            
            
            k=key;
            k=rmfield(k,'trial');
            T_all=fetch(ANL.VideoLickOnsetTrial & k,'*');
            T=fetch(ANL.VideoLickOnsetTrial & key,'*');
            
            x=[T_all.first_lick_peak_x];
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.first_lick_peak_x = (T.first_lick_peak_x - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all.first_lick_peak_y];
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.first_lick_peak_y = (T.first_lick_peak_y - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all.first_lick_yaw_peak];
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.first_lick_yaw_peak = (T.first_lick_yaw_peak - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all.first_lick_yaw_protrusion];
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.first_lick_yaw_protrusion = (T.first_lick_yaw_protrusion - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all.first_lick_amplitude];
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.first_lick_amplitude = (T.first_lick_amplitude - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all.lick_horizdist_peak];
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.lick_horizdist_peak = (T.lick_horizdist_peak - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all.lick_yaw_peak_relative];
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.lick_yaw_peak_relative = (T.lick_yaw_peak_relative - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all.lick_yaw_protrusion_relative];
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.lick_yaw_protrusion_relative = (T.lick_yaw_protrusion_relative - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all.lick_horizdist_peak_relative];
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.lick_horizdist_peak_relative = (T.lick_horizdist_peak_relative - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all.first_lick_rt_video_onset];
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.first_lick_rt_video_onset = (T.first_lick_rt_video_onset - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all.first_lick_rt_video_peak];
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.first_lick_rt_video_peak = (T.first_lick_rt_video_peak - nanmin(x))/(nanmax(x)-nanmin(x));
            
            x=[T_all.first_lick_rt_electric];
            idx_outlier = isoutlier(x,'quartiles'); x=x(~idx_outlier);
            key.first_lick_rt_electric = (T.first_lick_rt_electric - nanmin(x))/(nanmax(x)-nanmin(x));
            
            
            
            insert(self,key)
        end
        
    end
end

