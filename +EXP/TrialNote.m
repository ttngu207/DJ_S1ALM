%{
# 
-> EXP.SessionTrial
-> EXP.TrialNoteType
---
trial_note                  : varchar(255)                  # 
%}


classdef TrialNote < dj.Imported
     methods(Access=protected)
        function makeTuples(self, key)
        end
    end
end