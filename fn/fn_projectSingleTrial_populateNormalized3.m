function  [key, counter] = fn_projectSingleTrial_populateNormalized3(M, PSTH, key, counter, Param)

counter_start=counter;


k_mode.mode_type_name =M(1).mode_type_name;

Param = struct2table(fetch (ANL.Parameters,'*'));
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time =0.4; %Param.parameter_value{(strcmp('smooth_time_proj',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);



time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
% proj_avg=cell2mat(fetchn(ANL.ProjTrialAdaptiveAverage & key & k_mode,'proj_average'));
mode_time1_st =  unique(fetchn(ANL.Mode & k_mode,'mode_time1_st'));
mode_time1_end =  unique(fetchn(ANL.Mode & k_mode,'mode_time1_end'));
idx_time_to_normalize = time>=mode_time1_st & time<mode_time1_end;
% proj_min = min(nanmean(proj_avg(:,idx_time_to_normalize),2));
% proj_max = max(nanmean(proj_avg(:,idx_time_to_normalize),2));

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
        p_tr = nansum( (P.psth_trial.*w_mat));
        p_tr_smooth = movmean(p_tr ,[smooth_bins 0], 2,'omitnan', 'Endpoints','shrink');
        proj_trial(itr,:) = p_tr_smooth;
        num_units_projected(itr) =size(P,1); % number of units projected in this trial
        proj_max_tr(itr)=max(p_tr_smooth(idx_time_to_normalize));
        proj_min_tr(itr)=min(p_tr_smooth(idx_time_to_normalize));
        %         p_tr_smooth = (p_tr_smooth - proj_min)/(proj_max-proj_min);
    else
        proj_trial(itr,:) = PSTH.psth_trial(1,:) +NaN;
        num_units_projected(itr) = 0;
        proj_max_tr(itr)=NaN;
        proj_min_tr(itr)=NaN;
        
    end
    
    key(counter).subject_id = key(1).subject_id;
    key(counter).session = key(1).session;
    key(counter).cell_type = key(1).cell_type;
    key(counter).unit_quality = key(1).unit_quality;
    key(counter).trial = trials(itr);
    key(counter).mode_type_name = M(1).mode_type_name;
    key(counter).mode_weights_sign = key(1).mode_weights_sign;
    key(counter).proj_trial = proj_trial(itr,:);
    key(counter).num_units_projected = size(P,1);
    
    counter = counter +1;
    
end

% proj_max = max(proj_max_tr(~isoutlier(proj_max_tr)));
% proj_min = min(proj_min_tr(~isoutlier(proj_min_tr)));
proj_max = prctile(proj_max_tr,95);
proj_min = prctile(proj_max_tr,5);
for itr= 1:1:numel(trials)
    proj_trial_norm= key(itr+counter_start-1).proj_trial;
    proj_trial_norm = (proj_trial_norm-proj_min)/(proj_max-proj_min);
    key(itr+counter_start-1).proj_trial = proj_trial_norm;
%     plot(time,proj_trial_norm)
end
end
