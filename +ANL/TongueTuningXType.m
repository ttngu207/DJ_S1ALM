%{
#
tuning_param_name_x         : varchar(200)                  #
---
tuning_param_x_type_description  : varchar(1000)                 #
%}


classdef TongueTuningXType < dj.Lookup
    properties
        
        contents = {
            'lick_peak_y'           ''
            'lick_yaw'              ''
            'lick_yaw_relative'     ''
            'lick_yaw_avg'          ''
            'lick_horizoffset_relative' ''
            'lick_horizoffset' ''
            'lick_rt_video_onset' ''
            };
        
    end
end



