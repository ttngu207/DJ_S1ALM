%{
#
-> ANL.PSTH
-> EXP.TrialNameType
-> EXP.SessionTrial
---
psth_trial                      : longblob    # PSTH of a single trial, aligned to go cue time
%}


classdef PSTHTrial < dj.Part
    properties(SetAccess=protected)
        master= ANL.PSTH
    end
    methods
        function makeTuples(self, key)
        end
    end
end