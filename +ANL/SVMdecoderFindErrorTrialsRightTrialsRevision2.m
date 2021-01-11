%{
#
-> EXP.Session
-> EXP.SessionTrial
-> EXP.TrialNameType
---
trial_decoded_as_error                           : int                  # 1 - decoded as error, 0 decoded as correct
%}


classdef SVMdecoderFindErrorTrialsRightTrialsRevision2 < dj.Computed
    properties
        keySource = (EXP.Session & EPHYS.Unit) * (EXP.TrialNameType & 'trial_type_name="r" or trial_type_name="r_-1.6Full" or trial_type_name="r_-0.8Full"') & (ANL.SessionGrouping & 'session_flag_full=1');

    end
    methods(Access=protected)
        function makeTuples(self, key)
            
                [decoded_as_error, test_trial_num] = fn_SVM_decoder_to_identify_RIGHTerror_trials2(key);
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
                
            end
            
        
    end
end