%{
# Sorted unit
-> EPHYS.ElectrodeGroup
unit  : smallint
---
unit_uid                 : int          # unique across sessions/animals
-> EPHYS.UnitQualityType
unit_channel    = null      : float     # channel on the electrode for which the unit has the largest amplitude
%}


classdef Unit < dj.Imported
    
    methods(Access=protected)
        function makeTuples(self, key)
            
            obj = EXP.getObj(key);
            counter=0;
            for iUnits = 1:size(obj.eventSeriesHash.value,2)
                unit_channel = mode(obj.eventSeriesHash.value{iUnits}.channel);

                if unit_channel<=32 && key.electrode_group ==1
                    Insert_Unit(self, key, iUnits, unit_channel);
                    counter=counter+1;
                elseif unit_channel>32 && key.electrode_group ==2
                    unit_channel = unit_channel-32;
                    Insert_Unit(self, key, iUnits, unit_channel);
                    counter=counter+1;
                else
                end
                
            end
            fprintf('Populated %d units recorded from animal %d  on %s', counter, key.subject_id, fetch1(EXP.Session & key,'session_date'))
        end
    end
end

