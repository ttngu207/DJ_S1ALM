%{
# Estimated unit position in the brain
-> EPHYS.Unit
-> EPHYS.CFAnnotationType
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
end
