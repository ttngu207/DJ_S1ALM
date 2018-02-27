%{
#
-> EPHYS.Unit
-> EXP.SessionTrial
---
spike_times                 : longblob                      #(s) spike times for each trial (relative to the beginning of the trial)
%}


classdef TrialSpikes < dj.Imported
 
    methods (Access=protected)
        function makeTuples(self, key)
%             unit_trials = obj.eventSeriesHash.value{iUnits}.eventTrials(1):1:obj.eventSeriesHash.value{iUnits}.eventTrials(end);
%             key=repmat(key,1,numel(unit_trials));
%             unit_trials_temp = num2cell(unit_trials);
%             [key(:).trial] = unit_trials_temp{:};
%             insert(self,key);
%             counter =1;
%             for iTrials=unit_trials
%                 ix = find (obj.eventSeriesHash.value{iUnits}.eventTrials==iTrials);
%                 presample_t=obj.trialPropertiesHash.value{1}(iTrials);
%                 spike_times {counter} =  obj.eventSeriesHash.value{iUnits}.eventTimes(ix) + presample_t;
%                 counter=counter+1;
%             end
%             [key(:).spike_times] = spike_times{:};
%             insert(EPHYS.TrialSpikes,key);
        end
    end
end