%{
#
-> EXP.Session
---
%}


classdef ExcludeSession < dj.Computed
    properties
        keySource = (EXP.Session  & EPHYS.Unit);
    end
    methods(Access=protected)
        function makeTuples(self, key)
%             bad_sessions = [1,17, 46,61];
%                         bad_sessions = [16,77,9];
                        bad_sessions = [16,77,9,2,3];

            session_uid = fetch1(EXP.SessionID & key,'session_uid');
            
            if ismember(session_uid, bad_sessions)
            insert(self,key);
            end
            
        end
    end
end