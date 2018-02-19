%{
# 
-> EXP.SessionTrial
---
-> EXP.TaskProtocol
-> EXP.TrialInstruction
-> EXP.EarlyLick
-> EXP.Outcome
%}


classdef BehaviorTrial < dj.Imported
     methods(Access=protected)
        function makeTuples(self, key)
        end
    end
end