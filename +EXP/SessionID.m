%{
#
-> EXP.Session
---
session_uid                 : int          # unique across sessions/animals
%}


classdef SessionID < dj.Computed
    methods(Access=protected)
        function makeTuples(self, key)
            key.session_uid=max(fetchn(EXP.SessionID,'session_uid'))+1;
            self.insert(key)
        end
    end
end