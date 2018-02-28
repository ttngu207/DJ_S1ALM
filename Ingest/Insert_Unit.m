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


waveform = -1*mean(obj.eventSeriesHash.value{iUnits}.waveforms, 1);
[~,spk_width,wave_ms] =  fn_spike_width(waveform);

key.waveform_ms = wave_ms;
key.spk_width_ms = spk_width;
self.insert(key);

if numel(waveform)==123
    key_comments=key_child;
    key_comments.unit_comment ='waveform old filter format';
    insert(EPHYS.UnitComment,key_comments);
end

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
    wave_t = obj.trialPropertiesHash.value{1}(iTrials);
    ephys_t = wave_t - obj.presampleStartTimes_relative_to_trial(iTrials);
    presample_t = obj.presampleStartTimes_relative_to_trial(iTrials);
    spike_times {counter} =  obj.eventSeriesHash.value{iUnits}.eventTimes(ix) + presample_t +ephys_t;
    counter=counter+1;
end
[key_child(:).spike_times] = spike_times{:};
insert(EPHYS.TrialSpikes,key_child);