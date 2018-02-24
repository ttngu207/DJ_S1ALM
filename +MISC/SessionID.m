%{
#
-> EXP.Session
---
session_uid                 : int auto_increment           # unique across sessions/animals

unique index (session_uid)
%}


classdef SessionID < dj.Computed
    methods(Access=protected)
        function makeTuples(self, key)
            self.insert(key)
        end
    end
end