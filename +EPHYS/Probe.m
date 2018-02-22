%{
# 
probe_part_no   :  varchar(20)
---
probe_type      :  varchar(32)
probe_comment   :  varchar(4000)
%}


classdef Probe < dj.Lookup
     properties
        contents = {
            'H-194'  'janelia2x32' ''
            }
    end
end