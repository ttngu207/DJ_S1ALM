function  [key] = fn_RegressionprojectSingleTrialAllLicks(M, PSTH, key, TONGUE)

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

VariableNames=TONGUE.Properties.VariableNames';
idx_v_name=find(strcmp(VariableNames,key.tuning_param_name));
Y=TONGUE{:,idx_v_name};

%removing video outliers
idx_outlier=isoutlier(Y);
Y(idx_outlier)=[];
TONGUE(idx_outlier,:)=[];
neural_trial_num=[PSTH.trial ];

t_start=-0.5; %relative to lick peak
t_end=0.5;  %relative to lick peak

for i_LickXTrial=1:1:size(TONGUE, 1)
    t_lick_onset= table2array(TONGUE(i_LickXTrial,'lick_rt_video_peak'));
    time_idx_2plot = ((time-t_lick_onset) >=t_start)  &   ((time -t_lick_onset) < t_end);
    current_trial_num=table2array(TONGUE(i_LickXTrial,'trial'));
    %                 idx_trial= find(proj_trial_num==current_trial_num);
    %                 spk_t=SPIKES(idx_trial).spike_times_go;
    %                 spk(i_LickXTrial)=sum(spk_t>t_start & spk_t<t_end);%/diff(t_wnd);
    
    
    
    P = PSTH(PSTH.trial == current_trial_num,:);
    key(i_LickXTrial).hemisphere = PSTH.hemisphere{1}; % assumes the recording in this session where done in one hemisphere only
    key(i_LickXTrial).brain_area = PSTH.brain_area{1}; % assumes the recording in this session where done in one brain area only
    
    Mtrial=M(ismember([M.unit],[P.unit]),:);
    P=P(ismember([P.unit],[M.unit]),:);
    weights = ([Mtrial.regression_coeff_b2].*[Mtrial.regression_rsq])'; %weights are regression coefficients * regression R^2
    
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
        p_tr_smooth = movmean(p_tr ,[smooth_bins 0], 2,'omitnan', 'Endpoints','shrink');
        p_tr_smooth = p_tr_smooth(time_idx_2plot);
        proj_trial(i_LickXTrial,:) = p_tr_smooth;
        num_units_projected(i_LickXTrial) =size(P,1); % number of units projected in this trial
        proj_max_tr(i_LickXTrial)=max(p_tr_smooth);
        proj_min_tr(i_LickXTrial)=min(p_tr_smooth);
    else
        proj_trial(i_LickXTrial,:) = time(time_idx_2plot) +NaN;
        num_units_projected(i_LickXTrial) = 0;
        proj_max_tr(i_LickXTrial)=NaN;
        proj_min_tr(i_LickXTrial)=NaN;
        
    end
    
    key(i_LickXTrial).subject_id = key(1).subject_id;
    key(i_LickXTrial).session = key(1).session;
    key(i_LickXTrial).cell_type = key(1).cell_type;
    key(i_LickXTrial).unit_quality = key(1).unit_quality;
    key(i_LickXTrial).trial = current_trial_num;
    key(i_LickXTrial).mode_weights_sign = key(1).mode_weights_sign;
    key(i_LickXTrial).proj_trial = proj_trial(i_LickXTrial,:);
    key(i_LickXTrial).num_units_projected = size(P,1);
    key(i_LickXTrial).tuning_param_name =  key(1).tuning_param_name;
    key(i_LickXTrial).outcome_grouping =  key(1).outcome_grouping;
    key(i_LickXTrial).flag_use_basic_trials = key(1).flag_use_basic_trials;
    key(i_LickXTrial).lick_direction = key(1).lick_direction;
    key(i_LickXTrial).lick_number = TONGUE{i_LickXTrial,'lick_number'};
    
end

proj_max = max(proj_max_tr(~isoutlier(proj_max_tr)));
proj_min = min(proj_min_tr(~isoutlier(proj_min_tr)));
for i_LickXTrial= 1:1:size(TONGUE, 1)
    proj_trial_norm= key(i_LickXTrial).proj_trial;
    proj_trial_norm = (proj_trial_norm-proj_min)/(proj_max-proj_min);
    key(i_LickXTrial).proj_trial = proj_trial_norm;
    %     plot(time,proj_trial_norm)
end
end
