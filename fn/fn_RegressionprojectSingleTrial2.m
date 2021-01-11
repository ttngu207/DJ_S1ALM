function  [key] = fn_RegressionprojectSingleTrial2(M, PSTH, key)

Param = struct2table(fetch (ANL.Parameters,'*'));
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time =unique([M.time_window_duration]); %Param.parameter_value{(strcmp('smooth_time_proj',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);



time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
% proj_avg=cell2mat(fetchn(ANL.ProjTrialAdaptiveAverage & key & k_mode,'proj_average'));
mode_time1_st =  unique([M.time_window_start]);
mode_time1_end =   mode_time1_st + unique([M.time_window_duration]);
idx_time_to_normalize = time>=mode_time1_st & time<mode_time1_end;
% proj_min = min(nanmean(proj_avg(:,idx_time_to_normalize),2));
% proj_max = max(nanmean(proj_avg(:,idx_time_to_normalize),2));

trials = unique(PSTH.trial);
trials_direction = fetchn(ANL.LickDirectionTrial & key,'trial','ORDER BY trial');
trials=trials(ismember(trials,trials_direction));

unit_uids=unique(PSTH.unit_uid);
for  i_u=1:1:numel(unit_uids)

psth_trials = PSTH(PSTH.unit_uid == unit_uids(i_u),:).psth_trial;
        psth_trials = movmean(psth_trials ,[smooth_bins 0], 2,'omitnan', 'Endpoints','shrink');
        psth_max_all_trials=nanmax(nanmean(psth_trials(:,idx_time_to_normalize),2));
        psth_min_all_trials=nanmin(nanmean(psth_trials(:,idx_time_to_normalize),2));
        psth_trials = (psth_trials-psth_min_all_trials)./(psth_max_all_trials - psth_min_all_trials);
 PSTH(PSTH.unit_uid == unit_uids(i_u),:).psth_trial = psth_trials;
end

for itr= 1:1:numel(trials)
    
    P = PSTH(PSTH.trial == trials(itr),:);
    key(itr).hemisphere = PSTH.hemisphere{1}; % assumes the recording in this session where done in one hemisphere only
    key(itr).brain_area = PSTH.brain_area{1}; % assumes the recording in this session where done in one brain area only
    
    Mtrial=M(ismember([M.unit],[P.unit]),:);
    P=P(ismember([P.unit],[M.unit]),:);
    weights = ([Mtrial.regression_coeff_b2_normalized].*[Mtrial.regression_rsq])'; %weights are regression coefficients * regression R^2
    
    %     subplot(2,2,1)
    %     plot([Mtrial.regression_coeff_b2_normalized], [Mtrial.regression_rsq],'.')
    %     xlabel('beta normalized');
    %     ylabel('R^2');
    %
    %     subplot(2,2,2)
    %     plot([Mtrial.regression_coeff_b2], [Mtrial.regression_rsq],'.')
    %     xlabel('beta ');
    %     ylabel('R^2');
    %
    %     subplot(2,2,3)
    %     plot([Mtrial.regression_coeff_b2], [Mtrial.regression_coeff_b2_normalized],'.')
    %     xlabel('beta ');
    %     ylabel('beta normalized');
    %
    %     subplot(2,2,4)
    %     plot([weights], [Mtrial.regression_rsq],'.')
    %     xlabel('weights ');
    %     ylabel('R^2');
    %
    if strcmp(key(1).mode_weights_sign,'positive')
        weights(weights<0)= NaN;
    elseif strcmp(key(1).mode_weights_sign,'negative')
        weights(weights>=0)= NaN;
    end
    
    weights = weights./sqrt(nansum(weights.^2)); %normalize the weights vector by its norm, so that is magntiude won't depend on how many neurons are used
    w_mat = repmat(weights,1,size(P.psth_trial,2));
    
    if size(Mtrial,1)>1 %if there are enough units in this trial
        p_tr = nansum( (P.psth_trial.*w_mat));
        proj_trial(itr,:) = p_tr;
        num_units_projected(itr) =size(P,1); % number of units projected in this trial
        proj_max_tr(itr)=max(p_tr(idx_time_to_normalize));
        proj_min_tr(itr)=min(p_tr(idx_time_to_normalize));
        %         p_tr_smooth = (p_tr_smooth - proj_min)/(proj_max-proj_min);
    else
        proj_trial(itr,:) = PSTH.psth_trial(1,:) +NaN;
        num_units_projected(itr) = 0;
        proj_max_tr(itr)=NaN;
        proj_min_tr(itr)=NaN;
        
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

proj_max = max(proj_max_tr(~isoutlier(proj_max_tr)));
proj_min = min(proj_min_tr(~isoutlier(proj_min_tr)));
for itr= 1:1:numel(trials)
    proj_trial_norm= key(itr).proj_trial;
    proj_trial_norm = (proj_trial_norm-proj_min)/(proj_max-proj_min);
    key(itr).proj_trial = proj_trial_norm;
    %     plot(time,proj_trial_norm)
end
end
