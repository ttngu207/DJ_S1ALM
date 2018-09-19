%{
#
tuning_param_name_y         : varchar(200)                  #
---
tuning_param_y_type_description  : varchar(1000)                 #
%}


classdef TongueTuningYType < dj.Lookup
    properties
        
        contents = {
            'lick_peak_x'           ''
            'lick_vel_linear'       ''
            'lick_amplitude'        ''
            'lick_rt_video_onset'       ''
            };
        
    end
end



