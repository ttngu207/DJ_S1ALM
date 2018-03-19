%{
# Trials in which the animal was engaged in the task (behaving). Can include occassional ignore (no-lick triaks), but exlcudes epochs in which the animal was mostly no licking

-> EXP.SessionTrial
---
%}


classdef TrialBehaving < dj.Computed
    properties
        keySource = EXP.Session;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            trials_quit = fetch1(ANL.SessionBehavOverview & key,'trials_quit');
            trials_all = fetch1(ANL.SessionBehavOverview & key,'trials_all');
            trials_behaving = setdiff(trials_all,trials_quit);
            
            for it = 1:1:numel(trials_behaving)
                k(it).subject_id = key.subject_id;
                k(it).session = key.session;
                k(it).trial = trials_behaving (it);
            end
            
            insert(self,k)
        end
    end
end
