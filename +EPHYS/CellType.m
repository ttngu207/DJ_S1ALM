%{
# 
cell_type   :  varchar(100)
---
description :  varchar(100)
%}


classdef CellType < dj.Lookup
     properties
        contents = {
            'Putative pyramidal' ''
            'FS' 'fast spiking'
            }
    end
end