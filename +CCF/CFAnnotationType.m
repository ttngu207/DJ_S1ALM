%{
# 
cf_annotation_type           : varchar(200)                 # coordinate frame annotation type 
---
description                  : varchar(4000) #
%}


classdef CFAnnotationType < dj.Lookup
     properties
        contents = {
            'manipulator' 'position based on manipulator coordinates' 
            'manipulator and probe site'  'position based on manipulator coordinates and probe site layout' 
            }
    end
end


