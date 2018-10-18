%{
#
reconstruction_tuning_param_name         : varchar(200)                  #
---
%}


classdef TongueTuning1DTypeReconstruction < dj.Lookup
    properties
        
        contents = {
            'lick_peak_x'           
            %             'lick_peak_y'          
%             'lick_amplitude'        
            %             'lick_vel_linear'       
            %             'lick_vel_angular'      
            'lick_yaw'              
            'lick_yaw_relative'     
            %             'lick_yaw_avg'          
            %             'lick_yaw_avg_relative' 
            'lick_horizoffset'      
            'lick_horizoffset_relative' 
            'lick_rt_video_onset'       
            };
        
    end
end



