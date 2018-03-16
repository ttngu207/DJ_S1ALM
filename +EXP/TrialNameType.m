%{
#
-> EXP.Task
trial_type_name                          : varchar(200)      # trial-type name
---
trial_type_name_description=null         : varchar(4000)     #
%}


classdef TrialNameType < dj.Imported
    methods(Access=protected)
        function makeTuples(self, key)
            
        end
    end
end