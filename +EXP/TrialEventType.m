%{
# 
trial_event_type            : varchar(24)                   # 
%}


classdef TrialEventType < dj.Lookup
     properties
        contents = {
            'ephys rec. trigger'
            'delay'
            'go'
            'sample'
            'presample'
            'bitcode'
            'sample-start chirp'
            'sample-end chirp'
            }
    end
end