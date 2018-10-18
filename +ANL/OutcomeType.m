%{
# This is the outcome of trials that were used to compute some parameters, say the regression coefficient of a single unit.
outcome_grouping                     : varchar(32)                    # 
%}


classdef OutcomeType < dj.Lookup
    properties
        contents = {
            'hit'
            'miss'
            'ignore'
            'all'
            }
    end
end