%{
#
-> EXP.Session
---
trials_hit = null            : longblob
trials_miss = null           : longblob
trials_ignore  = null        : longblob
trials_quit  = null          : longblob
trials_early  = null         : longblob
trials_all   = null          : longblob
sliding_window_for_ignore    : longblob
%}


classdef SessionBehavOverview < dj.Computed
    methods(Access=protected)
        function makeTuples(self, key)

            tr_hit = fetchn(EXP.BehaviorTrial & key & 'outcome="hit"','trial');
            tr_miss = fetchn(EXP.BehaviorTrial & key & 'outcome="miss"','trial');
            tr_ignore = fetchn(EXP.BehaviorTrial & key & 'outcome="ignore"','trial');
            tr_early = fetchn(EXP.BehaviorTrial & key & 'early_lick!="no early"','trial');
            tr_all = fetchn(EXP.BehaviorTrial & key,'trial');
            
            tr_quit = [];
            ign_wind=10;
            for i_tr= floor(ign_wind/2) : 1 : numel(tr_all)
                remaining_trials = numel(tr_all) - i_tr;
                if remaining_trials>=ceil(ign_wind/2)
                    wnd_st = i_tr-floor(ign_wind/2) +1;
                    wnd_end = i_tr+ceil(ign_wind/2);
                else
                    wnd_st = i_tr - (ign_wind - remaining_trials) + 1;
                    wnd_end = i_tr + remaining_trials ;
                end
                tr_in_wind= tr_all(wnd_st : wnd_end);
                if (sum(ismember (tr_in_wind,tr_ignore))/ign_wind >=0.5)
                    tr_quit(end+1,1) = i_tr;
                end
            end
            
            key.trials_hit = tr_hit;
            key.trials_miss = tr_miss;
            key.trials_ignore = tr_ignore;
            key.trials_quit = tr_quit;
            key.trials_early = tr_early;
            key.trials_all = tr_all;
            key.sliding_window_for_ignore = ign_wind;
            
            %Populating ANL.SessionBehavOverview
            insert(self,key);
        end
    end
end