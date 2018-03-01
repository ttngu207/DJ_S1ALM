%{
# S1PhotostimTrial
-> EXP.SessionTrial
stim_num                      : tinyint     # resets for every trial
-----
-> MISC.S1StimType
-> MISC.S1StimPowerType
onset = null             : double      # onset of the stimulation relative to the go-cue (s); None for no-stim trials
power = null             : double      # laser power (mW)
duration = null          : double      # total stimulation duration (s)
trial_type_name          : varchar(100)      # trial-type name in Solo/Bpod 

%}

classdef S1PhotostimTrial < dj.Imported
    
   methods(Access=protected)

		function makeTuples(self, key)
		%!!! compute missing fields for key here
			 self.insert(key)
		end
   end
    
end
