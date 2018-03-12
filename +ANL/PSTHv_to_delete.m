%{
#
-> EPHYS.Unit
---
psth                              : longblob
%}


classdef PSTH < dj.Computed
    properties
        keySource = EXP.Session & EPHYS.TrialSpikes
    end
    methods(Access=protected)
        function makeTuples(self, key)
            tic
            
            dt=0.001;
            t_edges = [-6.5:dt:4];
            t_vector = t_edges(1:end-1)+dt/2;
            go_times =fetchn(EXP.BehaviorTrialEvent & key & 'trial_event_type="go"','trial_event_time');
            ntrials =numel(go_times)';
            nunits = numel([fetchn(EPHYS.Unit & key,'unit')]);
            %             trials_with_spikes = [TrialSpikes.trial];
            sp_first=[];
            sp_last=[];
            psth_all = zeros(nunits, ntrials, numel(t_vector))+NaN;
            for iu=1:1:nunits
                kunit.unit = iu;
                TrialSpikes =(fetch(EPHYS.TrialSpikes & key & kunit,'*'));
                for it=[TrialSpikes.trial]
                        spike_times=TrialSpikes([TrialSpikes.trial]==it).spike_times-go_times(it);
                        if ~isempty(spike_times)
                            sp_first = [sp_first spike_times(1)];
                            sp_last = [sp_last spike_times(end)];
                        end
                        psth_all(iu, it, :) = histcounts(spike_times, t_edges)/dt;
                end
                k(iu).subject_id=key.subject_id;
                k(iu).session=key.session;
                k(iu).electrode_group = TrialSpikes(1).electrode_group;
                k(iu).unit = iu;
                %iu
            end
            no_recording_times_mask=zeros(1,numel(t_vector));
            no_recording_times_mask ((t_vector<min(sp_first) |  t_vector>max(sp_last)))=NaN;
            no_recording_times_mask =repmat(no_recording_times_mask,ntrials,1);
            for iu =1:1:nunits
                k(iu).psth=squeeze(psth_all(iu, :, :))+no_recording_times_mask;
            end
            insert(self,k);
            %             psth_smoothed=smooth(mean(psth,1),10)';
            
            %             for it=1:1:numel(trials_with_spikes)
            %                  tr_n=trials_with_spikes(it);
            %                  spike_times=TrialSpikes(tr_n).spike_times-go_times(tr_n);
            %                  sp_first = [sp_first spike_times(1)];
            %                  sp_last = [sp_last spike_times(end)];
            %                  psth(it, :) = histc(spike_times, t_edges)'/dt;
            %             end
            %             psth_smoothed=smooth(mean(psth,1),10)';
            toc
            %             ephys_st=fetchn((EXP.BehaviorTrialEvent * EXP.BehaviorTrial) & EPHYS.Unit & 'trial_event_type="trigger ephys rec."' & 'early_lick="no early"','trial_event_time');
            %             go=fetchn((EXP.BehaviorTrialEvent * EXP.BehaviorTrial) & EPHYS.Unit & 'trial_event_type="go"' & 'early_lick="no early"','trial_event_time');
            %             hist((go-ephys_st),[0:0.1:10])
        end
        
    end
end