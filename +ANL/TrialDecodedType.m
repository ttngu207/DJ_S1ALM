%{
# 
trial_decoded_type   :  varchar(100)
---
trial_decoded_type_description :  varchar(4000)
%}


classdef TrialDecodedType < dj.Lookup
     properties
        contents = {
            'all' 'all trials, regardless of their decoding'
            'correct' 'trials decoded as correct, at the time point used for the decoding'
            'error' 'trials decoded as error, at the time point used for the decoding'
            }
    end
end