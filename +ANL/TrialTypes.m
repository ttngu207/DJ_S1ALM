%{
#
-> EXP.Task
trial_type_name                          : varchar(200)      # trial-type name
---
-> EXP.TrialInstruction
trial_type_name_description=null         : varchar(4000)      #
%}


classdef TrialTypes < dj.Computed
    methods(Access=protected)
        function makeTuples(self, key)
            if strcmp(key.task,'s1 stim')
                trial_types_name = unique(fetchn(MISC.S1TrialTypeName, 'trial_type_name'));
                for i_n=1:1:numel(trial_types_name)
                    key_name.task=key.task;
                    if  trial_types_name{i_n}(1)=='r'
                        key_name.trial_instruction = 'right';
                    elseif trial_types_name{i_n}(1)=='l'
                        key_name.trial_instruction = 'left';
                    end
                    key_name.trial_type_name=trial_types_name{i_n};
                    if isempty(fetch(ANL.TrialTypes & key_name))
                        insert(ANL.TrialTypes, key_name)
                    else
                        continue;
                    end
                end
            end
        end
    end
end