%{
# 
brain_area   :  varchar(32)
---
description   :  varchar(4000)
%}


classdef BrainArea < dj.Lookup
     properties
        contents = {
            'ALM' 'anterior lateral motor cortex'
            }
    end
end