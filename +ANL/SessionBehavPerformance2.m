%{
#
-> EXP.Session
-> EXP.TrialNameType
---
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


classdef SessionBehavPerformance2 < dj.Computed
    properties
        keySource = EXP.Session
    end
    methods(Access=protected)
        function makeTuples(self, key)
            tic
            R_trials=[];
            L_trials=[];
            k = key;
            
            %% Populating ANL.SessionBehavPerformance
            task = fetch1(EXP.SessionTask & key,'task');
            trials_quit = fetch1(ANL.SessionBehavOverview & key,'trials_quit');
            
            trial_type_names = unique([fetchn((EXP.TrialName) & key, 'trial_type_name')]);
            
            RT_hit =cell(numel(trial_type_names),1);
            RT_miss =cell(numel(trial_type_names),1);
            go_trials = fetchn(EXP.BehaviorTrialEvent & key & 'trial_event_type="go"', 'trial_event_time','ORDER BY trial');
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
                
                key.trial_type_name = trial_type_names{ityp};
%                 trnames2  = unique([fetchn(MISC.S1TrialTypeName & key, 'trial_type_name2')]);
%                 if numel(trnames2)>=2
%                     warning('Multiple trial_type_name2 for trial_type_name: %s',trial_type_names {ityp})
%                 end
%                 oiginname = unique([fetchn(MISC.S1TrialTypeName & key, 'original_trial_type_name')]);
%                 if numel(oiginname)>=2
%                     warning('Multiple original_trial_type_name for trial_type_name: %s',trial_type_names {ityp})
%                 end
%                 trial_type_names2 (ityp) =trnames2(1);
%                 original_trial_type_name (ityp)    = oiginname(1);
                
                b = (EXP.BehaviorTrial * EXP.TrialName) & key ;
                hit{ityp} = (   setdiff(fetchn(b & 'outcome="hit"','trial'), trials_quit) );
                ignore{ityp} = (   setdiff(fetchn(b & 'outcome="ignore"','trial'), trials_quit) );
                early{ityp} = (   setdiff(fetchn(b & 'early_lick!="no early"','trial'), trials_quit) );
                total_behaving (ityp,1) = numel(  setdiff(fetchn(b,'trial'), trials_quit) );
                total_noearly (ityp,1) = numel(  setdiff(fetchn(b &  'early_lick="no early"','trial'), trials_quit) );
                total_noignore (ityp,1) = numel(  setdiff(fetchn(b &  'outcome!="ignore"','trial'), trials_quit) );
                total_noignore_noearly (ityp,1) = numel(  setdiff(fetchn(b &  'outcome!="ignore"' & 'early_lick="no early"','trial'), trials_quit) );
                total_ignore_noearly_after_quitting (ityp,1) = numel(   setdiff(fetchn(b & 'outcome="ignore"' & 'early_lick!="no early"','trial'), trials_quit) );
                
                ba = (EXP.BehaviorTrial * EXP.ActionEvent* EXP.TrialName) & key;
                
                %reaction time hit
                [trials,licks_trials]=fetchn(ba & 'outcome="hit"' & 'early_lick="no early"','trial','action_event_time');
                u_trials=[];
                u_trials = setdiff(unique(trials), trials_quit);
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
                yyyy=RT_hit{ityp};
                yyyy(isoutlier(yyyy))=[];
                RT_hit_median (ityp) = nanmedian(yyyy);
                RT_hit_stem (ityp) = nanstd(yyyy)./sqrt(numel(yyyy));

%                 RT_hit_median (ityp) = median(RT_hit{ityp});
%                 RT_hit_stem (ityp) = std(RT_hit{ityp})./sqrt(numel(RT_hit{ityp}));
                
                %reaction time miss
                [trials,licks_trials]=fetchn(ba & 'outcome="miss"' & 'early_lick="no early"','trial','action_event_time');
                u_trials=[];
                u_trials = setdiff(unique(trials), trials_quit);
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
%                 RT_miss_median (ityp) = nanmedian(RT_miss{ityp});
%                 RT_miss_stem (ityp) = nanstd(RT_miss{ityp})./sqrt(numel(RT_miss{ityp}));
                
                     yyyy=RT_miss{ityp};
                yyyy(isoutlier(yyyy))=[];
                RT_miss_median (ityp) = nanmedian(yyyy);
                RT_miss_stem (ityp) = nanstd(yyyy)./sqrt(numel(yyyy));


                
                prcnt_hit (ityp) = 100*numel(hit{ityp}) / total_behaving(ityp);
                prcnt_ignore (ityp) = 100*numel(ignore{ityp}) / total_behaving(ityp);
                prcnt_early  (ityp)= 100*numel(early{ityp}) / total_behaving(ityp);
                prcnt_hit_outof_noignore (ityp) = 100*numel(setdiff(hit{ityp},ignore{ityp}))/ total_noignore (ityp);
                prcnt_hit_outof_noearly (ityp) = 100*numel(setdiff(hit{ityp},early{ityp}))/ total_noearly(ityp);
                prcnt_hit_outof_noignore_noearly (ityp) = 100*numel(setdiff(hit{ityp},union(early{ityp},ignore{ityp})))/ total_noignore_noearly (ityp);
                
                
                k(ityp).subject_id = key.subject_id;
                k(ityp).session = key.session;
                k(ityp).task = task;
                k(ityp).trial_type_name = trial_type_names{ityp};
                k(ityp).trial_type_num = ityp;
                k(ityp).trial_instruction = trial_instruction;
                k(ityp).prcnt_hit= prcnt_hit (ityp);
                k(ityp).prcnt_ignore = prcnt_ignore (ityp);
                k(ityp).prcnt_early = prcnt_early  (ityp);
                k(ityp).total_behaving = total_behaving  (ityp);
                k(ityp).prcnt_hit_outof_noignore = prcnt_hit_outof_noignore  (ityp);
                k(ityp).total_noignore  = total_noignore  (ityp);
                k(ityp).prcnt_hit_outof_noearly = prcnt_hit_outof_noearly  (ityp);
                k(ityp).total_noearly = total_noearly  (ityp);
                k(ityp).prcnt_hit_outof_noignore_noearly = prcnt_hit_outof_noignore_noearly  (ityp);
                k(ityp).total_noignore_noearly = total_noignore_noearly  (ityp);
                k(ityp).total_ignore_noearly_after_quitting  = total_ignore_noearly_after_quitting  (ityp);
                k(ityp).mean_reaction_time_hit  = RT_hit_median (ityp);
                k(ityp).stem_reaction_time_hit = RT_hit_stem (ityp);
                k(ityp).mean_reaction_time_miss  = RT_miss_median (ityp);
                k(ityp).stem_reaction_time_miss  = RT_miss_stem (ityp);
            end
            %Populating ANL.SessionBehavPerformance
            insert(self,k);
            toc
        end
    end
end