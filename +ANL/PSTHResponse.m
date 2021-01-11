%{
# Like ANL.PSTH but for all response trials (correct and error)
-> EPHYS.Unit
---
psth_t_vector                   : longblob    # time vector (seconds) of bin centers used to compute the PSTH, aligned to the go cue time
%}


classdef PSTHResponse < dj.Computed
    properties
        keySource = EXP.Session & EPHYS.TrialSpikes
    end
    methods(Access=protected)
        function makeTuples(self, key)
            tic
            
            dt=fetch1(ANL.Parameters & 'parameter_name="psth_time_bin"','parameter_value');
            t_edges = [-6.5:dt:4];
            psth_t_vector = t_edges(1:end-1)+dt/2;
            go_times =fetchn(EXP.BehaviorTrialEvent & key & 'trial_event_type="go"','trial_event_time','ORDER BY trial');
            ntrials =numel(go_times)';
            nunits = numel([fetchn(EPHYS.Unit & key,'unit')]);
            electrode_group = [fetchn(EPHYS.Unit & key,'electrode_group')];
            task = fetch1(EXP.SessionTask & key,'task');
            trial_names = [fetchn((MISC.S1TrialTypeName) & key, 'trial_type_name','ORDER BY trial')];
            outcome = fetchn(EXP.Outcome,'outcome');
            
            %% Compute PSTH and populate ANL.PSTH
            sp_first=[];
            sp_last=[];
            psth_t_u_tr = zeros(numel(psth_t_vector), nunits, ntrials)+NaN;
            for iu=1:1:nunits
                
                k_PSTH(iu).subject_id=key.subject_id;
                k_PSTH(iu).session=key.session;
                k_PSTH(iu).electrode_group = electrode_group(iu);
                k_PSTH(iu).unit = iu;
                k_PSTH(iu).psth_t_vector = psth_t_vector;
                
                kunit.unit = iu;
                TrialSpikes =(fetch(EPHYS.TrialSpikes & key & kunit,'*'));
                unit_trials{iu}= [TrialSpikes.trial];
                for itr=unit_trials{iu}
                    spike_times=TrialSpikes(unit_trials{iu}==itr).spike_times-go_times(itr);
                    if ~isempty(spike_times)
                        sp_first = [sp_first spike_times(1)];
                        sp_last = [sp_last spike_times(end)];
                    end
                    psth_t_u_tr(:, iu, itr) = histcounts(spike_times, t_edges)/dt;
                end
            end
            no_recording_times_mask=zeros(1,numel(psth_t_vector));
            no_recording_times_mask ((psth_t_vector<min(sp_first) |  psth_t_vector>max(sp_last)))=NaN;
            
            insert(self,k_PSTH);
            
            
            
            %% Populate  ANL.PSTHAverage and ANL.PSTHAdaptiveAverage
            % Adaptive average - If a trial contains a photostim stimulations, the time epochs before the first stimulation are averaged together with corresponding no-photostim epochs from other trials
            rel = (MISC.S1TrialTypeName * ANL.TrialTypeStimTime * EXP.BehaviorTrial) & key;
            [trialStim_epochs_mat, trialTypeStim_epochs_mat, stim_epochs, trial_type_names]  = fn_adaptive_trial_avg_stim_mat(rel);
            
            counter=0;
            outcome = 'response';
            for  ityp = 1:1:numel(trial_type_names)
                key_name.trial_type_name=trial_type_names{ityp};
                    key_condition.early_lick = 'no early';
                    trials_condition  = [fetchn(rel & key_condition & 'outcome!="ignore"', 'trial','ORDER BY trial')];
                    trials_condition_type  = [fetchn(rel & key_condition & key_name & 'outcome!="ignore"', 'trial','ORDER BY trial')];
                    for iu =1:1:nunits
                        
                        unit_trials_conditon_type  = intersect(unit_trials{iu},trials_condition_type);
                        psth_u = squeeze (psth_t_u_tr(:, iu, :));
                        if numel(unit_trials_conditon_type)>0
                            [psth_adaptive_avg] = fn_adaptive_trial_avg (trialStim_epochs_mat, trialTypeStim_epochs_mat(ityp,:), stim_epochs, psth_u, trials_condition, psth_t_vector);
                        else
                            psth_adaptive_avg = psth_t_vector+NaN;
                        end
                        psth_avg = mean(squeeze (psth_t_u_tr(:, iu, unit_trials_conditon_type)),2)';
                        
                        counter=counter+1;
                        k_PSTHAdaptiveAverage(counter).subject_id=key.subject_id;
                        k_PSTHAdaptiveAverage(counter).session=key.session;
                        k_PSTHAdaptiveAverage(counter).electrode_group = electrode_group(iu);
                        k_PSTHAdaptiveAverage(counter).unit = iu;
                        k_PSTHAdaptiveAverage(counter).task = task;
                        k_PSTHAdaptiveAverage(counter).trial_type_name=key_name.trial_type_name;
                        k_PSTHAdaptiveAverage(counter).outcome=outcome;
                        k_PSTHAdaptiveAverage(counter).num_trials_averaged = numel(unit_trials_conditon_type);
                        k_PSTHAdaptiveAverage(counter).psth_avg=psth_adaptive_avg + no_recording_times_mask;
                        k_PSTHAdaptiveAverage(counter).psth_avg_id=counter;
                        
                        k_PSTHAverage(counter).subject_id=key.subject_id;
                        k_PSTHAverage(counter).session=key.session;
                        k_PSTHAverage(counter).electrode_group = electrode_group(iu);
                        k_PSTHAverage(counter).unit = iu;
                        k_PSTHAverage(counter).task = task;
                        k_PSTHAverage(counter).trial_type_name=key_name.trial_type_name;
                        k_PSTHAverage(counter).outcome=outcome;
                        k_PSTHAverage(counter).num_trials_averaged =numel(unit_trials_conditon_type);
                        k_PSTHAverage(counter).psth_avg=psth_avg+no_recording_times_mask;
                        k_PSTHAverage(counter).psth_avg_id=counter;
                        
                    end
            end
            insert(ANL.PSTHAverage,k_PSTHAverage);
            insert(ANL.PSTHAdaptiveAverage,k_PSTHAdaptiveAverage);
            
            
            
            
            toc
            
        end
        
    end
end