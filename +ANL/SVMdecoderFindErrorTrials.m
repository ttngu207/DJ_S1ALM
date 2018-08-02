%{
#
-> EXP.Session
-> EXP.SessionTrial
-> EXP.TrialNameType
---
trial_decoded_as_error                           : int                  # 1 - decoded as error, 0 decoded as correct
%}


classdef SVMdecoderFindErrorTrials < dj.Computed
    properties
        keySource = (EXP.Session & EPHYS.Unit) * (EXP.TrialNameType & 'trial_type_name="l" or trial_type_name="l_-1.6Mini" or trial_type_name="l_-1.6Full"');

    end
    methods(Access=protected)
        function makeTuples(self, key)
            tic
            if  strcmp(key.trial_type_name,'l_-1.6Full') || strcmp(key.trial_type_name,'l_-1.6Mini') || strcmp(key.trial_type_name,'l') 
                [decoded_as_error, test_trial_num] = fn_SVM_decoder_to_identify_LEFTerror_trials(key);
                if ~isempty(decoded_as_error)
                    for it=1:1:numel(test_trial_num)
                        key(it).subject_id = key(1).subject_id;
                        key(it).session = key(1).session;
                        key(it).task = key(1).task;
                        key(it).trial_type_name = key(1).trial_type_name;
                        key(it).trial = test_trial_num(it);
                        
                        key(it).trial_decoded_as_error = decoded_as_error(it);
                    end
                    insert(self,key)
                end
                toc
            end
            
        end
        
    end
end