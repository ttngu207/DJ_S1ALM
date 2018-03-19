%{
#
-> EXP.TrialNameType
---
-> EXP.TrialInstruction
%}


classdef TrialTypeInstruction < dj.Computed
    methods(Access=protected)
        function makeTuples(self, key)
            if key.trial_type_name(1)=='l'
                key.trial_instruction = 'left';
            elseif key.trial_type_name(1)=='r'
                key.trial_instruction = 'right';
            end
            insert (self,key);
        end
    end
end