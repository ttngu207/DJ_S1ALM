%{
#
-> EXP.Session
---
%}


classdef SessionWithDistractorPowerNotDocumented < dj.Computed
    methods(Access=protected)
        function makeTuples(self, key)
            %             key.session_uid=max(fetchn(EXP.SessionID,'session_uid'))+1;
            
            rel = EXP.PhotostimTrialEvent*EXP.TrialName*EXP.SessionID * (EXP.SessionTask & 'task="s1 stim"') & key;
            k.trial_type_name='l_-1.6Mini';
            p= mean(fetchn(rel & k,'power'));
            
            if p==0
                self.insert(key)
            end
        end
    end
end