%{
# Estimated unit position in the brain
-> EPHYS.Unit
-> CF.CFAnnotationType
---
-> LAB.Hemisphere
-> LAB.BrainArea
-> LAB.SkullReference
unit_ml_location= null           : decimal(8,3)                  # um from ref; right is positive; based on manipulator coordinates (or histology) & probe config
unit_ap_location= null           : decimal(8,3)                  # um from ref; anterior is positive; based on manipulator coordinates (or histology) & probe config
unit_dv_location= null           : decimal(8,3)                  # um from dura; ventral is positive; based on manipulator coordinates (or histology) & probe config

%}


classdef UnitPosition < dj.Part
    properties(SetAccess=protected)
        master= EPHYS.Unit
    end
    methods
        function makeTuples(self, key, obj, iUnits)
            key.cf_annotation_type = 'manipulator and probe site';
            if obj.location(1) =='L'
                key.hemisphere='left';
            elseif obj.location(1) =='R'
                key.hemisphere='right';
            end
            
            if strcmp(obj.location(3:end),'ALM')
                key.brain_area='ALM';
            elseif strcmp(obj.location(3:end),'S1')
                key.brain_area='vS1';
            end
            
            key.skull_reference = 'Bregma';
            key.unit_ml_location = -(obj.eventSeriesHash.value{iUnits}.position_ML);
            key.unit_ap_location = obj.eventSeriesHash.value{iUnits}.position_AP;
            key.unit_dv_location = obj.eventSeriesHash.value{iUnits}.depth;
            self.insert(key)
        end
        
    end
end

