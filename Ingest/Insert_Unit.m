function key = Insert_Unit(key, iUnits)


obj = EXP.getObj(key);

key.unit = iUnits;
%                 key.unit_id = size(fetch(EPHYS.Unit),1) + 1;
%                 key.unit_hemisphere =  fetch1(s1.ExtracelProbe & key, 'recording_hemisphere');
%                 key.unit_brain_area =  fetch1(s1.ExtracelProbe & key, 'recording_brain_area');
%                 key.unit_x = obj.eventSeriesHash.value{iUnits}.position_ML;
%                 key.unit_y = obj.eventSeriesHash.value{iUnits}.position_AP;
%                 key.unit_z = obj.eventSeriesHash.value{iUnits}.depth;
quality = obj.eventSeriesHash.value{iUnits}.quality;

if quality ==0
    key.unit_quality = 'multi';
elseif  quality ==1
    key.unit_quality = 'ok';
elseif quality ==2
    key.unit_quality = 'good';
end

key.waveform = obj.eventSeriesHash.value{iUnits}.waveforms;
