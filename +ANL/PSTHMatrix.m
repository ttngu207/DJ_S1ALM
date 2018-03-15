%{
#
-> EXP.Session
---
psth_t_u_tr     : longblob                  # psth matrix (Time x Unit  X Trial)
psth_t_vector   : longblob                  # time vector (seconds) of bin centers used to compute the PSTH, aligned to the go cue time

%}


classdef PSTHMatrix < dj.Computed
    properties
        keySource = EXP.Session & EPHYS.TrialSpikes
    end
    methods(Access=protected)
        function makeTuples(self, key)
            tic
            
            dt=fetch1(ANL.Parameters & 'parameter_name="psth_time_bin"','parameter_value');
            t_edges = [-6.5:dt:4];
            t_vector = t_edges(1:end-1)+dt/2;
            go_times =fetchn(EXP.BehaviorTrialEvent & key & 'trial_event_type="go"','trial_event_time','ORDER BY trial');
            ntrials =numel(go_times)';
            nunits = numel([fetchn(EPHYS.Unit & key,'unit')]);
            sp_first=[];
            sp_last=[];
            psth_t_u_tr = zeros(numel(t_vector), nunits, ntrials)+NaN;
            for iu=1:1:nunits
                kunit.unit = iu;
                TrialSpikes =(fetch(EPHYS.TrialSpikes & key & kunit,'*','ORDER BY trial'));
                for it=[TrialSpikes.trial]
                    spike_times=TrialSpikes([TrialSpikes.trial]==it).spike_times-go_times(it);
                    if ~isempty(spike_times)
                        sp_first = [sp_first spike_times(1)];
                        sp_last = [sp_last spike_times(end)];
                    end
                    psth_t_u_tr(:, iu, it) = histcounts(spike_times, t_edges)/dt;
                end
                k.subject_id=key.subject_id;
                k.session=key.session;
                %iu
            end
            no_recording_times_mask=zeros(size(psth_t_u_tr));
            no_recording_times_mask ((t_vector<min(sp_first) |  t_vector>max(sp_last)),:,:)=NaN;
            k.psth_t_u_tr = psth_t_u_tr + no_recording_times_mask;
            k.psth_t_vector = t_vector;
            insert(self,k);
            toc
        end
        
    end
end