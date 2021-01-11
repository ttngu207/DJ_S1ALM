%{
#
trial_epoch_name                         : varchar(400)      # 
---
trial_epoch_name_name_description=null        : varchar(4000)     #
%}


classdef EpochName < dj.Lookup
    properties
        contents = {
            'sample'                              ''
            'delay'                               ''
            }
    end
end