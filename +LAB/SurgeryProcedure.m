%{
# Other things you did to the animal
-> LAB.Surgery
procedure_id                : int                           # 
---
-> LAB.SkullReference
ml_location= null           : decimal(8,3)                  # um from ref right; is positive
ap_location= null           : decimal(8,3)                  # um from ref anterior; is positive
dv_location= null           : decimal(8,3)                  # um from dura ventral; is positive
description                 : varchar(1000)                 # 
%}


classdef SurgeryProcedure < dj.Part
    properties(SetAccess=protected)
        master= LAB.Surgery
    end
end