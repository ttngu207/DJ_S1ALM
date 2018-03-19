%{
#
-> EPHYS.Unit
-> EXP.SessionTrial
---
spike_times_go                 : longblob                      #(s) spike times for each trial, aligned to the go cue. Includes only trials with a go cue (i.e. some early lick trials might be exluded)
%}


classdef TrialSpikesGoAligned < dj.Computed
    properties
        keySource=EXP.Session & EPHYS.Unit;
    end
    methods (Access=protected)
        function makeTuples(self, key)
            tic
            % fetch
            U = struct2table(fetch(EPHYS.Unit & key,'*'));
            rel1 = ((EPHYS.TrialSpikes * EXP.BehaviorTrialEvent) & ('trial_event_type="go"')) & key; %taking only trials that a had a go cue (i.e. no early licks)
            S=struct2table(fetch(rel1,'*'));
            units = unique([S.unit]);
            counter = 1;
            for iu=1:1:numel(units)
                u_idx_S= (S.unit==units(iu));
                go_event_t = num2cell(S.trial_event_time(u_idx_S));
                trial = [S.trial(u_idx_S)];
                spike_times = S.spike_times(u_idx_S);
                spike_times_go = cellfun(@minus,spike_times,go_event_t,'UniformOutput',false);
                for itr =1:1:numel(trial)
                    k(counter).subject_id=key.subject_id;
                    k(counter).session=key.session;
                    k(counter).electrode_group=U.electrode_group(U.unit==units(iu));
                    k(counter).unit=units(iu);
                    k(counter).trial=trial(itr);
                    k(counter).spike_times_go=spike_times_go{itr};
                    counter = counter + 1;
                end
            end
            insert(self,k);
            toc
        end
    end
end