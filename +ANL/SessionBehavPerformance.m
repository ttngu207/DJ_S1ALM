%{
#
-> EXP.Session
trial_type_name                           : varchar(200)      # trial-type name
---
original_trial_type_name                  : varchar(200)      # original trial-type name from Solo/Bpod
trial_type_num                            : smallint
-> EXP.TrialInstruction
percent_hit = null                        : double
percent_hit_response_trials = null        : double
percent_ignore = null                     : double
percent_early  = null                     : double
total_ignore_trials_after_quitting        : int
total_no_early_lick_trials                : int
total_no_quit_trials                      : int
mean_reaction_time_hit = null             : double
stem_reaction_time_hit = null             : double
mean_reaction_time_miss  = null           : double
stem_reaction_time_miss  = null           : double

%}


classdef SessionBehavPerformance < dj.Computed
    methods(Access=protected)
        function makeTuples(self, key)
            tic
            R_trials=[];
            L_trials=[];
            
            k = key;
            
            %% Populating ANL.SessionBehavOverview
            tr_hit = fetchn(EXP.BehaviorTrial & k & 'outcome="hit"','trial');
            tr_miss = fetchn(EXP.BehaviorTrial & k & 'outcome="miss"','trial');
            tr_ignore = fetchn(EXP.BehaviorTrial & k & 'outcome="ignore"','trial');
            tr_early = fetchn(EXP.BehaviorTrial & k & 'early_lick!="no early"','trial');
            tr_all = fetchn(EXP.BehaviorTrial & k,'trial');
            
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
            
            k_overview = key;
            k_overview.trials_hit = tr_hit;
            k_overview.trials_miss = tr_miss;
            k_overview.trials_ignore = tr_ignore;
            k_overview.trials_quit = tr_quit;
            k_overview.trials_early = tr_early;
            k_overview.trials_all = tr_all;
            k_overview.sliding_window_for_ignore = ign_wind;
            
            insert(ANL.SessionBehavOverview,k_overview);
            
            %% Populating ANL.SessionBehavPerformance
            trial_type_names = unique([fetchn(MISC.S1TrialTypeName & k, 'trial_type_name')]);
            original_trial_type_name    = unique([fetchn(MISC.S1TrialTypeName & k, 'original_trial_type_name')]);

            RT_hit =cell(numel(trial_type_names),1);
            RT_miss =cell(numel(trial_type_names),1);
            
            for  ityp = 1:1:numel(trial_type_names)
                
                if  trial_type_names{ityp}(1)=='r'
                    R_trials = [R_trials,ityp];
                    hit_lick_direction ='right lick';
                    miss_lick_direction ='left lick';
                    trial_instruction = 'right';
                elseif trial_type_names{ityp}(1)=='l'
                    L_trials = [L_trials,ityp];
                    hit_lick_direction ='left lick';
                    miss_lick_direction ='right lick';
                    trial_instruction = 'left';
                end
                
                k.trial_type_name = trial_type_names{ityp};
                b = (EXP.BehaviorTrial * MISC.S1TrialTypeName) & k ;
                
                hit (ityp,1) = numel(   setdiff(fetchn(b & 'outcome="hit"' & 'early_lick="no early"','trial'), tr_quit) );
                miss (ityp,1) = numel(   setdiff(fetchn(b & 'outcome="miss"' & 'early_lick="no early"','trial'), tr_quit) );
                ignore (ityp,1) = numel(   setdiff(fetchn(b & 'outcome="ignore"' & 'early_lick="no early"','trial'), tr_quit) );
                early (ityp,1) = numel(   setdiff(fetchn(b & 'early_lick!="no early"','trial'), tr_quit) );
                total_ignore_quit (ityp,1) = numel(   setdiff(fetchn(b & 'outcome="ignore"' & 'early_lick!="no early"','trial'), tr_quit) );
                total_no_early (ityp,1) = numel(  setdiff(fetchn(b &  'early_lick="no early"','trial'), tr_quit) );
                total_no_quit (ityp,1) = numel(  setdiff(fetchn(b,'trial'), tr_quit') );
                
                ba = (EXP.BehaviorTrial * EXP.ActionEvent * MISC.S1TrialTypeName) & k;
                
                %reaction time hit
                trials=[];
                trials = setdiff(fetchn(b & 'outcome="hit"' & 'early_lick="no early"','trial'), tr_quit);
                kt=k;
                for it=1:1:numel(trials)
                    kt.trial=trials(it);
                    kt.action_event_type=hit_lick_direction;
                    lick_t = fetchn(ba & kt, 'action_event_time');
                    go = fetch1(EXP.BehaviorTrialEvent & kt & 'trial_event_type="go"', 'trial_event_time');
                    [ix] =find(lick_t>go,1);
                    RT_hit {ityp}(it) = lick_t(ix) - go;
                end
                RT_hit_mean (ityp) = mean(RT_hit{ityp});
                RT_hit_stem (ityp) = std(RT_hit{ityp})./sqrt(numel(RT_hit{ityp}));
                
                %reaction time miss
                trials=[];
                trials = setdiff(fetchn(b & 'outcome="miss"' & 'early_lick="no early"' ,'trial'), tr_quit);
                for it=1:1:numel(trials)
                    kt.trial=trials(it);
                    kt.action_event_type=miss_lick_direction;
                    lick_t = fetchn(ba & kt', 'action_event_time');
                    go = fetch1(EXP.BehaviorTrialEvent & kt & 'trial_event_type="go"', 'trial_event_time');
                    [ix] =find(lick_t>go,1);
                    RT_miss{ityp}(it) = lick_t(ix) - go;
                end
                RT_miss_mean (ityp) = mean(RT_miss{ityp});
                RT_miss_stem (ityp) = mean(RT_miss{ityp})./sqrt(numel(RT_miss{ityp}));
                
                percent_hit (ityp) = 100*hit(ityp) / sum([hit(ityp),miss(ityp),ignore(ityp)]); %exluding early licks
                percent_hit_response (ityp) = 100*hit(ityp) / sum([hit(ityp),miss(ityp)]); %exluding early licks or no response
                percent_ignore (ityp) = 100*ignore(ityp) / sum([hit(ityp),miss(ityp),ignore(ityp)]);
                percent_early  (ityp)= 100*early(ityp) / total_no_quit(ityp);
                
                
                key.trial_type_name = trial_type_names{ityp};
                key.original_trial_type_name = original_trial_type_name{ityp};
                key.trial_type_num = ityp;
                key.trial_instruction = trial_instruction;
                key.percent_hit = percent_hit (ityp);
                key.percent_hit_response_trials = percent_hit_response (ityp);
                key.percent_ignore = percent_ignore (ityp);
                key.percent_early = percent_early  (ityp);
                key.total_ignore_trials_after_quitting = total_ignore_quit (ityp);
                key.total_no_early_lick_trials = total_no_early (ityp);
                key.total_no_quit_trials = total_no_quit (ityp);
                key. mean_reaction_time_hit         = RT_hit_mean (ityp);
                key.stem_reaction_time_hit  = RT_hit_stem (ityp);
                key.mean_reaction_time_miss            = RT_miss_mean (ityp);
                key.stem_reaction_time_miss         = RT_miss_stem (ityp);
                
                insert(self,key);
                
            end
            toc
        end
    end
end