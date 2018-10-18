%{
# Charachterizing the trial as lick left or licl left trial, based on the direction of the tongue on the first lick
-> EXP.BehaviorTrial
---
%}


classdef VideoTongueValidRTTrial < dj.Computed
    properties
        keySource = ANL.Video1stLickTrial;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            key=rmfield(key,'tongue_estimation_type');
            rel=(ANL.Video1stLickTrial & key & 'lick_rt_video_onset<0.2');
%             fetchn(ANL.Video1stLickTrialNormalized & key ,'lick_horizoffset_relative')
            if rel.count  >0
            insert (self,key);
            end
        end
    end
end