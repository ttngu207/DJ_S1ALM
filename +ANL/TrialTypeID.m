%{
#
-> EXP.TrialNameType
---
trialtype_uid                   : int              # trial-type color in rgb
%}


classdef TrialTypeID < dj.Computed
    methods(Access=protected)
        function makeTuples(self, key)
            rel=ANL.TrialTypeID;
            key.trialtype_uid = rel.count + 1;
            insert (self,key);
        end
    end
end