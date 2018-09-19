%{
# Charachterizing the trial as lick left or licl left trial, based on the direction of the tongue on the first lick
-> EXP.BehaviorTrial
-> ANL.LickDirectionType
---
%}


classdef LickDirectionTrial < dj.Computed
    properties
        keySource = ANL.Video1stLickTrial;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            key=rmfield(key,'tongue_estimation_type');
            rel=(ANL.Video1stLickTrialNormalized & key & 'lick_horizoffset_relative<0.5');
%             fetchn(ANL.Video1stLickTrialNormalized & key ,'lick_horizoffset_relative')
            if rel.count  >0
                key.lick_direction = 'left';
            else
                key.lick_direction = 'right';
            end
            insert (self,key);
        end
    end
end