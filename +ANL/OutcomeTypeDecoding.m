%{
# 
outcome_trials_for_decoding                     : varchar(32)                    # 
%}


classdef OutcomeTypeDecoding < dj.Lookup
    properties
        contents = {
            'hit'
            'miss'
            'all'
            }
    end
end