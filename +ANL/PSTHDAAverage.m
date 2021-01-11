%{
#
-> ANL.PSTHDA
-> EXP.TrialNameType
-> EXP.Outcome
---
num_trials_averaged             : int         # number of trials averaged per condition, for this unit
psth_avg                        : longblob    # trial-type averaged PSTH aligned to go cue time
psth_avg_id                     : smallint    # id specific for a combination of trialname / outome 

%}


classdef PSTHDAAverage < dj.Part
    properties(SetAccess=protected)
        master= ANL.PSTH
    end
    methods
        function makeTuples(self, key)
        end
    end
end