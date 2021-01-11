%{
#
-> EXP.SessionTrial
---
reaction_time_electric    : double          # in s, relative to go cue
%}


classdef ReactionTimeElectric < dj.Computed
    properties
        keySource = EXP.Session
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            k = key;
            go_trials = fetchn(EXP.BehaviorTrialEvent & key & 'trial_event_type="go"', 'trial_event_time','ORDER BY trial');
            
            ba = (EXP.BehaviorTrial * EXP.ActionEvent) & key;
            
            %reaction time hit
            [trials,licks_trials]=fetchn(ba & 'outcome="hit" or outcome="miss"' & 'early_lick="no early"','trial','action_event_time');
            u_trials = unique(trials);
            k = repmat(k,numel(u_trials),1);
            for it=1:1:numel(u_trials)
                licks = licks_trials(trials==u_trials(it));
                go = go_trials(u_trials(it));
                [ix] =find(licks>go,1);
                k(it).trial = u_trials(it);
                k(it).reaction_time_electric = licks(ix) - go;
            end
            
            insert(self,k);
            
        end
    end
end