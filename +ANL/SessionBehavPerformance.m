%{
#
-> EXP.Session
trial_type_name                           : varchar(200)      # trial-type name
---
trial_type_name2                          : varchar(200)      # trial-type name
original_trial_type_name                  : varchar(200)      # original trial-type name from Solo/Bpod
trial_type_num                            : smallint          # trial-type number within a session
-> EXP.TrialInstruction

prcnt_hit = null                          : double            # prcnt of hit trials (out of all trials, exluding trials for which the animal stopped performing quit)
prcnt_ignore = null                       : double            # prcnt of ignore trials (out of all trials, exluding trials for which the animal stopped performing quit)
prcnt_early  = null                       : double            # prcnt of early-lick trials (out of all trials, exluding trials for which the animal stopped performing quit)
total_behaving                            : int               # total number of trials, exluding trials for which the animal stopped performing quit)
prcnt_hit_outof_noignore = null           : double            # prcnt of hit trials (out of NoIgnore trials, exluding trials for which the animal stopped performing quit)
total_noignore                            : int               # total number of NoIgnore trials, exluding trials for which the animal stopped performing quit)
prcnt_hit_outof_noearly = null            : double            # prcnt of hit trials (out of all NoEarly lick trials, exluding trials for which the animal stopped performing quit)
total_noearly                             : int               # total number of NoEarly lick trials, exluding trials for which the animal stopped performing quit)
prcnt_hit_outof_noignore_noearly = null   : double            # prcnt of hit trials (out of all NoEarly lick and NoIgnore trials, exluding trials for which the animal stopped performing quit)
total_noignore_noearly                    : int               # total number of NoIgnore and NoEarly lick  trials, exluding trials for which the animal stopped performing quit)
total_ignore_noearly_after_quitting       : int               # total number of Ignore, out of NoEarly lick trials AFTER the animal stopped performing quit)

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
            
            
            %% Populating ANL.SessionBehavPerformance
            trial_type_names = unique([fetchn(MISC.S1TrialTypeName & k, 'trial_type_name')]);
            
            RT_hit =cell(numel(trial_type_names),1);
            RT_miss =cell(numel(trial_type_names),1);
            go_trials = fetchn(EXP.BehaviorTrialEvent & k & 'trial_event_type="go"', 'trial_event_time');
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
                trnames2  = unique([fetchn(MISC.S1TrialTypeName & k, 'trial_type_name2')]);
                if numel(trnames2)>=2
                    warning('Multiple trial_type_name2 for trial_type_name: %s',trial_type_names {ityp})
                end
                oiginname = unique([fetchn(MISC.S1TrialTypeName & k, 'original_trial_type_name')]);
                if numel(oiginname)>=2
                    warning('Multiple original_trial_type_name for trial_type_name: %s',trial_type_names {ityp})
                end
                trial_type_names2 (ityp) =trnames2(1);
                original_trial_type_name (ityp)    = oiginname(1);
                
                
                b = (EXP.BehaviorTrial * MISC.S1TrialTypeName) & k ;
                hit{ityp} = (   setdiff(fetchn(b & 'outcome="hit"','trial'), tr_quit) );
                ignore{ityp} = (   setdiff(fetchn(b & 'outcome="ignore"','trial'), tr_quit) );
                early{ityp} = (   setdiff(fetchn(b & 'early_lick!="no early"','trial'), tr_quit) );
                total_behaving (ityp,1) = numel(  setdiff(fetchn(b,'trial'), tr_quit) );
                total_noearly (ityp,1) = numel(  setdiff(fetchn(b &  'early_lick="no early"','trial'), tr_quit) );
                total_noignore (ityp,1) = numel(  setdiff(fetchn(b &  'outcome!="ignore"','trial'), tr_quit) );
                total_noignore_noearly (ityp,1) = numel(  setdiff(fetchn(b &  'outcome!="ignore"' & 'early_lick="no early"','trial'), tr_quit) );
                total_ignore_noearly_after_quitting (ityp,1) = numel(   setdiff(fetchn(b & 'outcome="ignore"' & 'early_lick!="no early"','trial'), tr_quit) );
                
                ba = (EXP.BehaviorTrial * EXP.ActionEvent * MISC.S1TrialTypeName) & k;
                
                %reaction time hit
                [trials,licks_trials]=fetchn(ba & 'outcome="hit"' & 'early_lick="no early"','trial','action_event_time');
                u_trials=[];
                u_trials = setdiff(unique(trials), tr_quit);
                kt=k;
                for it=1:1:numel(u_trials)
                    licks = licks_trials(trials==u_trials(it));
                    go = go_trials(u_trials(it));
                    [ix] =find(licks>go,1);
                    if ~isempty(ix)
                        RT_hit{ityp}(it) = licks(ix) - go;
                    else
                        RT_hit{ityp}(it) = NaN;
                    end
                end
                RT_hit_mean (ityp) = mean(RT_hit{ityp});
                RT_hit_stem (ityp) = std(RT_hit{ityp})./sqrt(numel(RT_hit{ityp}));
                
                %reaction time miss
                [trials,licks_trials]=fetchn(ba & 'outcome="miss"' & 'early_lick="no early"','trial','action_event_time');
                u_trials=[];
                u_trials = setdiff(unique(trials), tr_quit);
                kt=k;
                for it=1:1:numel(u_trials)
                    licks = licks_trials(trials==u_trials(it));
                    go = go_trials(u_trials(it));
                    [ix] =find(licks>go,1);
                    if ~isempty(ix)
                        RT_miss{ityp}(it) = licks(ix) - go;
                    else
                        RT_miss{ityp}(it) = NaN;
                    end
                end
                RT_miss_mean (ityp) = mean(RT_miss{ityp});
                RT_miss_stem (ityp) = mean(RT_miss{ityp})./sqrt(numel(RT_miss{ityp}));
                
                
                
                prcnt_hit (ityp) = 100*numel(hit{ityp}) / total_behaving(ityp);
                prcnt_ignore (ityp) = 100*numel(ignore{ityp}) / total_behaving(ityp);
                prcnt_early  (ityp)= 100*numel(early{ityp}) / total_behaving(ityp);
                prcnt_hit_outof_noignore (ityp) = 100*numel(setdiff(hit{ityp},ignore{ityp}))/ total_noignore (ityp);
                prcnt_hit_outof_noearly (ityp) = 100*numel(setdiff(hit{ityp},early{ityp}))/ total_noearly(ityp);
                prcnt_hit_outof_noignore_noearly (ityp) = 100*numel(setdiff(hit{ityp},union(early{ityp},ignore{ityp})))/ total_noignore_noearly (ityp);
                
                key.trial_type_name = trial_type_names{ityp};
                key.trial_type_name2 = trial_type_names2{ityp};
                key.original_trial_type_name = original_trial_type_name{ityp};
                key.trial_type_num = ityp;
                key.trial_instruction = trial_instruction;
                key.prcnt_hit = prcnt_hit (ityp);
                key.prcnt_ignore = prcnt_ignore (ityp);
                key.prcnt_early = prcnt_early  (ityp);
                key.total_behaving = total_behaving  (ityp);
                key.prcnt_hit_outof_noignore = prcnt_hit_outof_noignore  (ityp);
                key.total_noignore  = total_noignore  (ityp);
                key.prcnt_hit_outof_noearly = prcnt_hit_outof_noearly  (ityp);
                key.total_noearly  = total_noearly  (ityp);
                key.prcnt_hit_outof_noignore_noearly = prcnt_hit_outof_noignore_noearly  (ityp);
                key.total_noignore_noearly  = total_noignore_noearly  (ityp);
                key.total_ignore_noearly_after_quitting  = total_ignore_noearly_after_quitting  (ityp);
                key.mean_reaction_time_hit  = RT_hit_mean (ityp);
                key.stem_reaction_time_hit  = RT_hit_stem (ityp);
                key.mean_reaction_time_miss = RT_miss_mean (ityp);
                key.stem_reaction_time_miss = RT_miss_stem (ityp);
                
                %Populating ANL.SessionBehavPerformance
                insert(self,key);
                
                
            end
            %Populating ANL.SessionBehavOverview
            insert(ANL.SessionBehavOverview,k_overview);
            toc
        end
    end
end