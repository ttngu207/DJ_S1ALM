%{
#
-> EXP.Session
trial                       : smallint                      #
---
trial_uid                   : int                           # unique across sessions/animals
%}


classdef TrialID < dj.Computed
    properties
        keySource = (EXP.Session & EXP.SessionTrial);
    end
    methods(Access=protected)
        
        function makeTuples(self, key)
            key=fetch(EXP.SessionTrial & key,'*');
            
            key=rmfield(key,'start_time');
            insert(self,key);
        end
    end
end
