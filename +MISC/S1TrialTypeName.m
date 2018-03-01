%{
# S1PhotostimTrial
-> EXP.SessionTrial
-----
trial_type_name          : varchar(100)      # trial-type name in Solo/Bpod 

%}

classdef S1TrialTypeName < dj.Imported
    
   methods(Access=protected)

		function makeTuples(self, key)
		%!!! compute missing fields for key here
			 self.insert(key)
		end
   end
    
end
