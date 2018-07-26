function  [key, counter] = fn_projectSingleTrial_populate(M, PSTH, key, counter, Param)


trials = unique(PSTH.trial);


for itr= 1:1:numel(trials)
    P = PSTH(PSTH.trial == trials(itr),:);
    key(counter).hemisphere = PSTH.hemisphere{1}; % assumes the recording in this session where done in one hemisphere only
    key(counter).brain_area = PSTH.brain_area{1}; % assumes the recording in this session where done in one brain area only
    
    Mtrial=M(ismember([M.unit],[P.unit]),:);
    weights = [Mtrial.mode_unit_weight]';
    
    
    if strcmp(key(1).mode_weights_sign,'positive')
        weights(weights<0)= NaN;
    elseif strcmp(key(1).mode_weights_sign,'negative')
        weights(weights>=0)= NaN;
    end
    
    weights = weights./sqrt(nansum(weights.^2)); %normalize the weights vector by its norm, so that is magntiude won't depend on how many neurons are used
    w_mat = repmat(weights,1,size(P.psth_trial,2));
    
    if size(P,1)>1 %if there are enough units in this trial
        proj_trial(itr,:) = nansum( (P.psth_trial.*w_mat));
        num_units_projected(itr) =size(P,1); % number of units projected in this trial
    else
        proj_trial(itr,:) = PSTH.psth_trial(1,:) +NaN;
        num_units_projected(itr) = 0;
    end
    
    key(counter).subject_id = key(1).subject_id;
    key(counter).session = key(1).session;
    key(counter).cell_type = key(1).cell_type;
    key(counter).unit_quality = key(1).unit_quality;
    key(counter).outcome = key(1).outcome;
    key(counter).task = key(1).task;
    key(counter).trial = trials(itr);
    key(counter).trial_type_name = P.trial_type_name{1};
    key(counter).mode_type_name = M(1).mode_type_name;
    key(counter).mode_weights_sign = key(1).mode_weights_sign;
    key(counter).proj_trial = proj_trial(itr,:);
    key(counter).num_units_projected = size(P,1);
    
    counter = counter +1;
    
end
end
