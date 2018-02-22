%{
#
-> EPHYS.UnitTrial
---
spike_times                 : longblob                      #(s) spike times for each trial (relative to the beginning of the trial)
%}


classdef TrialSpikes < dj.Imported
    
    methods(Access=protected)
        
        function makeTuples(self, key)
%             key =rmfield(key,'trial_id');
%             obj = s1.getObj(key);
%             key_child = key;
%             tuples = [];
%             % Extracting spikes corresponding to this trial only
%             unit_num = fetch1(s1.UnitExtracel & key,'unit_num');
%             trial_num = fetchn(s1.Trial & key,'trial_num');
%             trial_id = fetchn(s1.Trial & key,'trial_id');
% 
%             spikes = obj.eventSeriesHash.value{unit_num}.eventTimes; %all spikes for this unit
%             spikeTrials = obj.eventSeriesHash.value{unit_num}.eventTrials; % trial number during which each spike was recorded
%             
%             for iTrial = 1:1:numel(trial_num)
%                 % take only spikes corresponding to this trial
%                 key_child.spike_times = spikes(spikeTrials == trial_num(iTrial));
%                 key_child.trial_id = trial_id(iTrial);
%                 tuples = [tuples; key_child];
%             end
%             
%             % insert the key into self
%             self.insert(tuples)
        end
    end
    
end