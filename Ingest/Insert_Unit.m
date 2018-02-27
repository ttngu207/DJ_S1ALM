function key = Insert_Unit (self, key, iUnits, unit_channel)

% Inserting Unit
key.unit = iUnits;
key_child = key;
obj = EXP.getObj(key);
quality = obj.eventSeriesHash.value{iUnits}.quality;
if quality ==0
    key.unit_quality = 'multi';
elseif  quality ==1
    key.unit_quality = 'ok';
elseif quality ==2
    key.unit_quality = 'good';
end

key.unit_channel = unit_channel;
key.waveform = obj.eventSeriesHash.value{iUnits}.waveforms;
self.insert(key);

%Inserting UnitPosition
makeTuples(EPHYS.UnitPosition, key_child, obj, iUnits);


%Inserting TrialSpikes
unit_trials = obj.eventSeriesHash.value{iUnits}.eventTrials(1):1:obj.eventSeriesHash.value{iUnits}.eventTrials(end);
key_child=repmat(key_child,1,numel(unit_trials));
unit_trials_temp = num2cell(unit_trials);
[key_child(:).trial] = unit_trials_temp{:};

counter =1;
for iTrials=unit_trials
    ix = find (obj.eventSeriesHash.value{iUnits}.eventTrials==iTrials);
    presample_t=obj.trialPropertiesHash.value{1}(iTrials);
    spike_times {counter} =  obj.eventSeriesHash.value{iUnits}.eventTimes(ix) + presample_t;
    counter=counter+1;
end
[key_child(:).spike_times] = spike_times{:};
insert(EPHYS.TrialSpikes,key_child);