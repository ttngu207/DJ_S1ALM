function key = Insert_Unit (self, key, iUnits, unit_channel)

% Inserting Unit
key.unit = iUnits;
key_child = key;
rel=EPHYS.Unit;
key.unit_uid  =rel.count+1;

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
self.insert(key);

% Inserting UnitWaveform and UnitWaveformComment
key_waveform=key_child;
uVperBit =  0.3815;
waveform = -1*mean(obj.eventSeriesHash.value{iUnits}.waveforms, 1);
[wav,spk_width,~] =  fn_spike_width(waveform);
waveform =  -(wav-wav(1))*uVperBit;
key_waveform.waveform = waveform;
key_waveform.spk_width_ms = spk_width;
key_waveform.sampling_fq = 25000;
key_waveform.waveform_amplitude = max(abs(waveform));

insert(EPHYS.UnitWaveform,key_waveform);

if numel(waveform)==123
    key_comments=key_child;
    key_comments.unit_waveform_comment ='waveform old filter format';
    insert(MISC.UnitWaveformComment,key_comments);
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