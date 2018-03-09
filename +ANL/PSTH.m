%{
#
-> EPHYS.Unit
---
-> EPHYS.TrialSpikes
trial_type_name                           : varchar(200)      # trial-type name
-> EXP.TrialInstruction
ptsh_trial                                : blob          # trial-type number within a session
%}


classdef PSTH < dj.Computed
    methods(Access=protected)
        function makeTuples(self, key)
            tic
            key_s.subject_id=key.subject_id;
            key_s.session=key.session;
            dt=0.001;
            t_edges = [-6.5:dt:3];
            go_times =fetchn(EXP.BehaviorTrialEvent & key_s & 'trial_event_type="go"','trial_event_time');
            TrialSpikes =(fetch(EPHYS.TrialSpikes & key,'*'));
            trials_with_spikes = [TrialSpikes.trial];
            sp_first=[];
            sp_last=[];
            for it=1:1:numel(trials_with_spikes)
                 tr_n=trials_with_spikes(it);
                 spike_times=TrialSpikes(tr_n).spike_times-go_times(tr_n);
                 sp_first = [sp_first spike_times(1)];
                 sp_last = [sp_last spike_times(end)];
                 psth(it, :) = histc(spike_times, t_edges)'/dt;
            end
            psth_smoothed=smooth(mean(psth,1),10)';
            toc
%             ephys_st=fetchn((EXP.BehaviorTrialEvent * EXP.BehaviorTrial) & EPHYS.Unit & 'trial_event_type="trigger ephys rec."' & 'early_lick="no early"','trial_event_time');
%             go=fetchn((EXP.BehaviorTrialEvent * EXP.BehaviorTrial) & EPHYS.Unit & 'trial_event_type="go"' & 'early_lick="no early"','trial_event_time');
%             hist((go-ephys_st),[0:0.1:10])
        end
        
    end
end