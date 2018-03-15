%{
#
-> EXP.Task
trial_type_name                          : varchar(200)      # trial-type name
---
stim_onsets=null                         : blob              # photostim onset time/s for this trial-type (in seconds, relative to go-cue)
trial_type_name_description=null         : varchar(4000)     #
%}


classdef TrialTypes < dj.Imported
    methods(Access=protected)
        function makeTuples(self, key)
            
        end
    end
end