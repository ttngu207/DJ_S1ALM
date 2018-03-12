%{
#
-> ANL.PSTH
-> ANL.TrialTypes
-> EXP.Outcome
---
num_trials_averaged             : longblob    # number of trials averaged per condition, for this unit
psth_avg                        : longblob    # trial-type averaged PSTH aligned to go cue time
%}


classdef PSTHAverage < dj.Part
    properties(SetAccess=protected)
        master= ANL.PSTH
    end
    methods
        function makeTuples(self, key)
        end
    end
end