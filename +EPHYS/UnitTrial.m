%{
# Entries for trials a unit is in
-> EPHYS.Unit
-> EXP.SessionTrial
%}


classdef UnitTrial < dj.Part
    properties(SetAccess=protected)
        master= EPHYS.Unit
    end
    methods(Access=protected)
        function makeTuples(self, key)
        end
    end
end
