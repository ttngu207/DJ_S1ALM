function  Ingest_EXP_TrialNameType (task, data_TrialName)
if strcmp(task,'s1 stim')
    trial_types_name = unique({data_TrialName.trial_type_name});
    for i_n=1:1:numel(trial_types_name)
        key_name=[];
        key_name.task=task;
        key_name.trial_type_name=trial_types_name{i_n};
        if isempty(fetch(EXP.TrialNameType & key_name))
            insert(EXP.TrialNameType, key_name)
        else
            continue;
        end
    end
end