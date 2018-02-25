function key = Insert_Unit (self, key, iUnits, unit_channel)
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

makeTuples(EPHYS.UnitPosition, key_child, obj, iUnits)
