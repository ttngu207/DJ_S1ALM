function  [key] = fn_RegressionprojectSingleTrial_populateNormalized2(M, PSTH, key)

Param = struct2table(fetch (ANL.Parameters,'*'));
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time =0.5; %Param.parameter_value{(strcmp('smooth_time_proj',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);



time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};

trials = unique(PSTH.trial);
if ~strcmp(key.lick_direction,'all') %if this is a left or right trial, based on tongue direction
    trials_direction = fetchn(ANL.LickDirectionTrial & key,'trial','ORDER BY trial');
    trials=trials(ismember(trials,trials_direction));
end

for itr= 1:1:numel(trials)
    
    P = PSTH(PSTH.trial == trials(itr),:);
    key(itr).hemisphere = PSTH.hemisphere{1}; % assumes the recording in this session where done in one hemisphere only
    key(itr).brain_area = PSTH.brain_area{1}; % assumes the recording in this session where done in one brain area only
    
    Mtrial=M(ismember([M.unit],[P.unit]),:);
    P=P(ismember([P.unit],[M.unit]),:);
    
    weights = [Mtrial.regression_coeff_b2]';
    
    %     sifnificant= [Mtrial.regression_p]
    
    if strcmp(key(1).mode_weights_sign,'positive')
        weights(weights<0)= NaN;
    elseif strcmp(key(1).mode_weights_sign,'negative')
        weights(weights>=0)= NaN;
    end
    
    weights = weights./sqrt(nansum(weights.^2)); %normalize the weights vector by its norm, so that is magntiude won't depend on how many neurons are used
    w_mat = repmat(weights,1,size(P.psth_trial,2));
    
    if size(Mtrial,1)>1 %if there are enough units in this trial
        p_tr = nansum( (P.psth_trial.*w_mat));
        p_tr_smooth = movmean(p_tr ,[smooth_bins 0], 2,'omitnan', 'Endpoints','shrink');
        proj_trial(itr,:) = p_tr_smooth;
        num_units_projected(itr) =size(P,1); % number of units projected in this trial
        %         p_tr_smooth = (p_tr_smooth - proj_min)/(proj_max-proj_min);
    else
        proj_trial(itr,:) = PSTH.psth_trial(1,:) +NaN;
        num_units_projected(itr) = 0;
    end
    
    key(itr).subject_id = key(1).subject_id;
    key(itr).session = key(1).session;
    key(itr).cell_type = key(1).cell_type;
    key(itr).unit_quality = key(1).unit_quality;
    key(itr).trial = trials(itr);
    key(itr).regression_time_start = M(1).regression_time_start;
    key(itr).mode_weights_sign = key(1).mode_weights_sign;
    key(itr).proj_trial = proj_trial(itr,:);
    key(itr).num_units_projected = size(P,1);
    key(itr).tuning_param_name =  key(1).tuning_param_name;
    key(itr).outcome_grouping =  key(1).outcome_grouping;
    key(itr).flag_use_basic_trials = key(1).flag_use_basic_trials;
    key(itr).lick_direction = key(1).lick_direction;
    
end


X=proj_trial;
if any(isnan(X(:)))
    xmu=nanmean(X);
    xsigma=nanstd(X);
    Z=(X-repmat(xmu,size(X,1),1))./repmat(xsigma,size(X,1),1);
else
    Z=zscore(X);
end
proj_trialZ=Z;

for itr= 1:1:numel(trials)
    key(itr).proj_trial = proj_trialZ(itr,:);
    %     plot(time,proj_trial_norm)
end
end
