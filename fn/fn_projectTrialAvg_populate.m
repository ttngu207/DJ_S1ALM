function  [key, counter] = fn_projectTrialAvg_populate(M, PSTH, key, counter, Param)


mintrials_psth_typeoutcome = Param.parameter_value{(strcmp('mintrials_psth_typeoutcome',Param.parameter_name))};

% mintrials_psth_typeoutcome = 2; %Param.parameter_value{(strcmp('mintrials_psth_typeoutcome',Param.parameter_name))};

trial_types = unique(PSTH.trial_type_name);
for itype= 1:1:numel(trial_types)
    P = PSTH(strcmp(trial_types{itype},PSTH.trial_type_name),:);
    key(counter).hemisphere = P.hemisphere{1}; % assumes the recording in this session where done in one hemisphere only
    key(counter).brain_area = P.brain_area{1}; % assumes the recording in this session where done in one brain area only
    
    idx_include =(P.num_trials_averaged >=mintrials_psth_typeoutcome);
    P=P(idx_include,:);
    
    weights = [M.mode_unit_weight]';
    weights=weights(idx_include);
    
    if strcmp(key(1).mode_weights_sign,'positive')
        weights(weights<0)= NaN;
    elseif strcmp(key(1).mode_weights_sign,'negative')
            weights(weights>=0)= NaN;
            weights=-weights; %inverting the sign
    end
    
    weights = weights./sqrt(nansum(weights.^2)); %normalize the weights vector by its norm, so that is magntiude won't depend on how many neurons are used
    w_mat = repmat(weights,1,size(P.psth_avg,2));
        
    if size(P,1)>1 %if there are enough cells with sufficient number of trials
        proj_avg(itype,:) = nansum( (P.psth_avg.*w_mat));
        num_trials_projected(itype) = mode(P.num_trials_averaged); % most common number of trials among the units for this trial-type
    else
        proj_avg(itype,:) = PSTH.psth_avg(1,:) +NaN;
        num_trials_projected(itype) = 0;
    end
    
    key(counter).subject_id = key(1).subject_id;
    key(counter).session = key(1).session;
    key(counter).cell_type = key(1).cell_type;
    key(counter).unit_quality = key(1).unit_quality;
    key(counter).outcome = key(1).outcome;
    key(counter).task = key(1).task;
    key(counter).trial_type_name = trial_types{itype};
    key(counter).mode_type_name = M(1).mode_type_name;
    key(counter).mode_weights_sign = key(1).mode_weights_sign;

    key(counter).proj_average = proj_avg(itype,:);
    key(counter).num_trials_projected = num_trials_projected(itype);
    key(counter).num_units_projected = size(P,1);
    
    counter = counter +1;
    
end
end
