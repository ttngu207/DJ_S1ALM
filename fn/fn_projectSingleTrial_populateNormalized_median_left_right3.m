function  [key] = fn_projectSingleTrial_populateNormalized_median_left_right3(M, PSTH, key, Param, trial_num_l, trial_num_r)

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
dir_save_figure = [dir_root 'Results\Population\SingleTrials\'];


counter_start=1;
counter=1;

k_mode.mode_type_name =M(1).mode_type_name;

Param = struct2table(fetch (ANL.Parameters,'*'));
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time =0.5; % for outlier calculation only %Param.parameter_value{(strcmp('smooth_time_proj_single_trial_normalized',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);



time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
% proj_avg=cell2mat(fetchn(ANL.ProjTrialAdaptiveAverage & key & k_mode,'proj_average'));
% mode_time1_st =  unique([M.mode_time1_st]);
% mode_time1_end =  unique([M.mode_time1_end]);
idx_time_to_normalize = time>-0.2 & time<=0;
idx_time_to_normalize2  = time>-3.5 & time<=3;
idx_time_to_outlier = time>-1 & time<=0; 
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
        proj_trial_smooth(itr,:) = p_tr_smooth;
        proj_trial(itr,:) = p_tr;
        proj_max_tr(itr)=mean(p_tr(idx_time_to_normalize));
        %         proj_min_tr(itr)=min(p_tr_smooth(idx_time_to_normalize));
        proj_max_tr2(itr)=mean(p_tr(idx_time_to_normalize2));
        
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

% proj_max = max(proj_max_tr(~isoutlier(proj_max_tr)));
% proj_min = min(proj_min_tr(~isoutlier(proj_min_tr)));


idx_l=ismember(trials,trial_num_l);
idx_r=ismember(trials,trial_num_r);

% isoutlier_l = isoutlier(proj_trial(idx_l,idx_time_to_outlier),2)';
% isoutlier_r = isoutlier(proj_trial(idx_r,idx_time_to_outlier),2)';
% 
% isoutlier_l=(sum(isoutlier_l,1)>40)';
% isoutlier_r=(sum(isoutlier_r,1)>40)';

% isoutlier_l = isoutlier(proj_max_tr(idx_l),'gesd')';
% isoutlier_r = isoutlier(proj_max_tr(idx_r),'gesd')';

% isoutlier_l=ismember(trials,trial_num_l(isoutlier_l));
% isoutlier_r=ismember(trials,trial_num_r(isoutlier_r));
% 


isout = sum(isoutlier(proj_trial_smooth(:,idx_time_to_outlier),'quartiles',1),2)>10;

isoutlier_l = idx_l & isout;
isoutlier_r = idx_r & isout;




session_uid = fetch1(EXP.SessionID & key,'session_uid');
brain_area = fetch1(ANL.SessionPosition & key,'brain_area');
hemisphere = fetch1(ANL.SessionPosition & key,'hemisphere');
training = fetch1(EXP.SessionTraining & key,'training_type');

%debug
time2plot=time>-3 & time<1;

if sum(isout)>0
    
subplot(3,2,1)
hold on
plot(time(time2plot),proj_trial_smooth(:,time2plot),'-k');
plot(time(time2plot),proj_trial_smooth(isout,time2plot),'-g')
title(sprintf('Session uid %d  %s %s %s training %d outliers',session_uid, brain_area, hemisphere, training, sum(isout))) 


subplot(3,2,2)
hold on
plot(time(time2plot),proj_trial_smooth(idx_l,time2plot),'-r')
plot(time(time2plot),proj_trial_smooth(idx_r,time2plot),'-b')
if sum(isoutlier_l)>0
plot(time(time2plot),proj_trial_smooth(isoutlier_l,time2plot),'-m')
end
if sum(isoutlier_r)>0
plot(time(time2plot),proj_trial_smooth(isoutlier_r,time2plot),'-c')
end

subplot(3,2,3)
hold on
plot(time(time2plot),median(proj_trial_smooth(idx_l,time2plot)),'-r')
plot(time(time2plot),median(proj_trial_smooth(idx_r,time2plot)),'-b')


idx_l(isout) =false;
idx_r(isout) =false;


subplot(3,2,4)
hold on
plot(time(time2plot),median(proj_trial_smooth(idx_l,time2plot)),'-r')
plot(time(time2plot),median(proj_trial_smooth(idx_r,time2plot)),'-b')

end


idx_l(isout) =false;
idx_r(isout) =false;


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
        key(itr+counter_start-1).is_outlier = isout(itr);

    %     p(itr,:) = key(itr+counter_start-1).proj_trial;
    p(itr,:) = proj_trial_norm;
    
    %     plot(time,proj_trial_norm)
end


subplot(3,2,5)
        p_norm_smoothed = movmean(p ,[smooth_bins 0], 2,'omitnan', 'Endpoints','shrink');

hold on
plot(time(time2plot),mean(p_norm_smoothed(idx_l,time2plot)),'-r')
plot(time(time2plot),mean(p_norm_smoothed(idx_r,time2plot)),'-b')


dir_save_figure2=[dir_save_figure training '\' brain_area '\' hemisphere '\'];
if isempty(dir(dir_save_figure2))
    mkdir (dir_save_figure2)
end

figure_name_out=[ dir_save_figure2 'suid' num2str(session_uid)];
eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);


clf
end
