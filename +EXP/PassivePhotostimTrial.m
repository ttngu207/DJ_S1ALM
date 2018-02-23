%{
# Non-behavioral trials with photostimulation
-> EXP.PhotostimTrial
%}


classdef PassivePhotostimTrial < dj.Computed
    methods(Access=protected)
        function makeTuples(self, key)
            key = EXP.PhotostimTrial - EXP.BehaviorTrial;
            self.insert1(key)
        end
    end
end