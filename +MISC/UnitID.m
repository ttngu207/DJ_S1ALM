%{
#
-> Ephys.Unit
---
unit_uid                 : int auto_increment           # unique across sessions/animals

unique index (unit_uid)
%}


classdef UnitID < dj.Computed
    methods(Access=protected)
        function makeTuples(self, key)
            self.insert(key)
        end
    end
end