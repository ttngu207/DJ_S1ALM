%{
#
-> EXP.Session
session_flag_mini=0           : smallint          # flag indicating whether the session contains mini stimuli in display set (1) or not(0)
session_flag_full=0           : smallint          # flag indicating whether the session contains full stimuli at different times
session_flag_full_late=0      : smallint          # flag indicating whether the session contains full stimuli at late delay
session_flag_double_sample_amplitude=0      : smallint          # flag indicating whether the session contains during the sample full stimuli (in duration, i.e. 0.4 s) and double in amplitud

---
%}


classdef SessionGrouping < dj.Computed
    properties
        keySource = EXP.Session & EPHYS.TrialSpikes
    end
    methods(Access=protected)
        function makeTuples(self, key)
            task_protocol = fetchn(EXP.SessionTask  & key, 'task_protocol');
            
            if  sum(ismember ([4,6], task_protocol))>0
                key.session_flag_full =1;
                key.session_flag_full_late =1;
            elseif sum(ismember ([2,5], task_protocol))>0
                key.session_flag_mini =1;
            elseif sum(ismember ([7,8,9], task_protocol))>0
                key.session_flag_mini =1;
                key.session_flag_full_late =1;
            end
            
            if sum(ismember ([8], task_protocol))>0
                key.session_flag_double_sample_amplitude =1;
            end
            insert(self,key);
        end
    end
end