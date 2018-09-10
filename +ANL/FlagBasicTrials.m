%{
#
flag_use_basic_trials                         :smallint                  # 1 to use only basic trials - i.e left/right without, 0 to use all trials including distractors
%}


classdef FlagBasicTrials < dj.Lookup
    properties
        
        contents = {
           0
            1
            };
        
    end
end



