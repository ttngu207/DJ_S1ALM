%{
# 
brain_area   :  varchar(32)
---
description= null   :  varchar(4000)
%}


classdef BrainArea < dj.Lookup
     properties
        contents = {
            'ALM' 'anterior lateral motor cortex'
            'vS1' 'vibrissal primary somatosensory cortex ("barrel cortex")'
            }
    end
end