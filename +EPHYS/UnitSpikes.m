%{
# 
-> EPHYS.Unit
---
spike_times                 : longblob                      #(s) spike times for the entire session (relative to the beginning of the session) 

%}


classdef UnitSpikes < dj.Part
    properties(SetAccess=protected)
        master= EPHYS.Unit
    end
    methods(Access=protected)
        function makeTuples(self, key)
        end
    end
end
