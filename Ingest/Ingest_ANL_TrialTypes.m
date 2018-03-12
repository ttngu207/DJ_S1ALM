function  Ingest_ANL_TrialTypes (task, data_S1TrialTypeName)
if strcmp(task,'s1 stim')
    trial_types_name = unique({data_S1TrialTypeName.trial_type_name});
    for i_n=1:1:numel(trial_types_name)
        key_name=[];
        key_name.task=task;
        stim_onsets=[];
        stim_onsets = cellfun(@str2num,regexp(trial_types_name{i_n},'-\d*\.?\d*','Match'));
        if  trial_types_name{i_n}(1)=='r'
            stim_onsets(end+1) = -2.5;
        end
        stim_onsets=unique(stim_onsets,'sorted');
        key_name.trial_type_name=trial_types_name{i_n};
        if isempty(fetch(ANL.TrialTypes & key_name))
            key_name.stim_onsets=stim_onsets;
            insert(ANL.TrialTypes, key_name)
        else
            continue;
        end
    end
end