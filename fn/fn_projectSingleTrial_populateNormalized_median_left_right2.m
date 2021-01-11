function  [key] = fn_projectSingleTrial_populateNormalized_median_left_right2(M, PSTH, key, Param, trial_num_l, trial_num_r)

counter_start=1;
counter=1;

k_mode.mode_type_name =M(1).mode_type_name;

Param = struct2table(fetch (ANL.Parameters,'*'));
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time =0;%Param.parameter_value{(strcmp('smooth_time_proj_single_trial_normalized',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);



time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
% proj_avg=cell2mat(fetchn(ANL.ProjTrialAdaptiveAverage & key & k_mode,'proj_average'));
% mode_time1_st =  unique([M.mode_time1_st]);
% mode_time1_end =  unique([M.mode_time1_end]);
idx_time_to_normalize = time>-0.2 & time<=0;
idx_time_to_normalize2  = time>-3.5 & time<=3;

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
        proj_max_tr(itr)=mean(p_tr_smooth(idx_time_to_normalize));
        %         proj_min_tr(itr)=min(p_tr_smooth(idx_time_to_normalize));
        proj_max_tr2(itr)=mean(p_tr_smooth(idx_time_to_normalize2));
        
        %         p_tr_smooth = (p_tr_smooth - proj_min)/(proj_max-proj_min);
    else
        proj_trial(itr,:) = PSTH.psth_trial(1,:) +NaN;
        proj_max_tr(itr)=NaN;
        %         proj_min_tr(itr)=NaN;
        proj_max_tr2(itr)=NaN;
        
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

idx_l=ismember(trials,trial_num_l);
idx_r=ismember(trials,trial_num_r);

if strcmp(key(1).mode_type_name,'Ramping Orthog.1')
    median_l = median(proj_max_tr2);
    median_r = median(proj_max_tr);
else
    
    median_l = median(proj_max_tr(idx_l));
    median_r = median(proj_max_tr(idx_r));
end

diff_med =  abs(median_r - median_l);

for itr= 1:1:numel(trials)
    proj_trial_norm= key(itr+counter_start-1).proj_trial;
    proj_trial_norm = (proj_trial_norm-min([median_l,median_r]))/diff_med;
    %      proj_trial_norm = (proj_trial_norm-median_l)/diff_med;
    
    %     proj_trial_norm = (proj_trial_norm)/diff_med;
    
    key(itr+counter_start-1).proj_trial = proj_trial_norm;
    %     p(itr,:) = key(itr+counter_start-1).proj_trial;
    p(itr,:) = proj_trial_norm;
    
    %     plot(time,proj_trial_norm)
end

% %debug
% subplot(2,2,1)
% hold on
% plot(time,p(idx_l,:),'-r')
% plot(time,p(idx_r,:),'-b')
% subplot(2,2,3)
% hold on
% plot(time,median(p(idx_l,:)),'-r')
% plot(time,median(p(idx_r,:)),'-b')
end
