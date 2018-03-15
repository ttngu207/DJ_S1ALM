%{
#
-> EPHYS.Unit
---
unit_uid                 : int          # unique across sessions/animals

%}


classdef UnitID < dj.Computed
    methods(Access=protected)
        function makeTuples(self, key)
            rel = EPHYS.Unit;
            key.unit_uid=numel(fetch(EXP.Session));
            self.insert(key)
        end
    end
end