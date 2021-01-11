%{
# units are cm, deg, and seconds
-> EXP.BehaviorTrial
-> ANL.TongueEstimationType
-> ANL.LickDirectionType
lick_number              : double                      # the lick after the go cue (first lick, second lick, etc)
---
lick_rt_onset_diff      : double                        # rt based on video trough
lick_rt_peak_diff       : double                        # rt based on video peak

%}


classdef VideoLickIntervalTrial < dj.Computed
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
                for i_l=2:1:numel(T.lick_peak_x)
                    
                    key.lick_number = i_l;
                    
                    if i_d==2
                        if T.lick_horizoffset(i_l)  <0
                            key.lick_direction = 'left';
                        else
                            key.lick_direction = 'right';
                        end
                    end
                    
                   
                    key.lick_rt_onset_diff = T.lick_rt_video_onset(i_l)-T.lick_rt_video_onset(i_l-1);
                    key.lick_rt_peak_diff = T.lick_rt_video_peak(i_l)-T.lick_rt_video_peak(i_l-1);
                    
                    insert(self,key)
                    
                end
            end
            
        end
        
    end
end

