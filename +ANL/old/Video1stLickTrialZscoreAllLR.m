%{
#
-> EXP.BehaviorTrial
-> ANL.TongueEstimationType
-> ANL.LickDirectionType
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


classdef Video1stLickTrialZscoreAllLR < dj.Computed
    properties
        keySource = (EXP.Session & ANL.Video1stLickTrial)*ANL.LickDirectionType;
    end
    methods(Access=protected)
        
        function makeTuples(self, key)
            
            
            
            k=key;
            if strcmp(k.lick_direction,'all')
                k=rmfield(k,'lick_direction');
            end
            T_all_trias=fetch(ANL.Video1stLickTrial*ANL.LickDirectionTrial & k,'*','ORDER BY trial');
            fields = fieldnames(T_all_trias);
            T=struct2table(T_all_trias);
            for i=6:1:numel(fields)
                T{:,i}=zscore(T{:,i});
            end
            if strcmp(key.lick_direction,'all')
                T.lick_direction=repmat('all',size(T,1),1);
            end
            key=table2struct(T);
            
            insert(self,key)
        end
        
    end
end

