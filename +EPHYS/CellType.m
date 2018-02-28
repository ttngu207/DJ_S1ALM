%{
# 
cell_type   :  varchar(100)
---
description :  varchar(4000)
%}


classdef CellType < dj.Lookup
     properties
        contents = {
            'Pyr' 'putative pyramidal'
            'FS' 'fast spiking'
            'not classified' 'intermediate spike-width that falls between spike-width thresholds for FS or Putative pyramidal cells'
            }
    end
end