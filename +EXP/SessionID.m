%{
#
-> EXP.Session
---
session_uid                 : int          # unique across sessions/animals
%}


classdef SessionID < dj.Computed
    methods(Access=protected)
        function makeTuples(self, key)
            key.session_uid=numel(fetch(EXP.Session));
            self.insert(key)
        end
    end
end