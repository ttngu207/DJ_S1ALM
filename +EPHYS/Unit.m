%{
# Sorted unit
-> EPHYS.ElectrodeGroup
unit  : smallint
---
-> EPHYS.UnitQualityType
waveform : blob    # unit average waveform, each point corresponds to a sample. (what are the amplitude units?)  To convert into time use the sampling_frequency.
unit_channel    = null      : float                      # channel on the probe for each the unit has the largest amplitude (verify that its based on amplitude or other feature)
%}


classdef Unit < dj.Imported
    
    methods(Access=protected)
        function makeTuples(self, key)
            
            obj = EXP.getObj(key);
            
            for iUnits = 1:size(obj.eventSeriesHash.value,2)
                unit_channel = obj.eventSeriesHash.value{iUnits}.channel;
                
                if unit_channel<=32 && key.electrode_group ==1
                    key = Insert_Unit(key, iUnits);
                    key.unit_channel = unit_channel;
                    self.insert(key);
                elseif unit_channel>32 && key.electrode_group ==2
                    key = Insert_Unit(key, iUnits);
                    key.unit_channel = unit_channel-32;
                    self.insert(key);
                else
                end
                
            end
            fprintf('Populated %d units recorded from animal %d  on %s', iUnits, key.subject_id, fetch1(EXP.Session & key,'session_date'))
            
        end
    end
end

