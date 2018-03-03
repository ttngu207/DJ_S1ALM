%{
-> EXP.SessionTrial
-----
trial_type_name                   : varchar(200)      # renamed
trial_type_name2                  : varchar(200)      # numeric
original_trial_type_name          : varchar(200)      # original trial-type name from Solo/Bpod

%}

classdef S1TrialTypeName < dj.Imported
    
    methods(Access=protected)
        
        function makeTuples(self, key)
            %!!! compute missing fields for key here
            self.insert(key)
        end
    end
    
end
