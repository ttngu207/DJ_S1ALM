%{
# 
unit_quality   :  varchar(100)
---
unit_quality_description :  varchar(4000)
%}


classdef UnitQualityType < dj.Lookup
     properties
        contents = {
            'good'  'single unit'
            'ok'    'probably a single unit, but could be contaminated'
            'multi' 'multi unit'
            }
    end
end