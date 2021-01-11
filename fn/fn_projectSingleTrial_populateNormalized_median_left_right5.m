function  [key] = fn_projectSingleTrial_populateNormalized_median_left_right5(M, PSTH, key, Param, trial_num_l, trial_num_r)

dir_root = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\';
dir_save_figure = [dir_root 'Results\Population\SingleTrials\'];


counter_start=1;
counter=1;

k_mode.mode_type_name =M(1).mode_type_name;

Param = struct2table(fetch (ANL.Parameters,'*'));
psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
smooth_time =0.2; % for outlier calculation only %Param.parameter_value{(strcmp('smooth_time_proj_single_trial_normalized',Param.parameter_name))};
smooth_bins=ceil(smooth_time/psth_time_bin);



time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
% proj_avg=cell2mat(fetchn(ANL.ProjTrialAdaptiveAverage & key & k_mode,'proj_average'));
% mode_time1_st =  unique([M.mode_time1_st]);
% mode_time1_end =  unique([M.mode_time1_end]);
idx_time_to_normalize = time>-0.2 & time<=0;
idx_time_to_normalize2  = time>-3.5 & time<=3;
idx_time_to_outlier = time>-0.005 & time<0;
trials = unique(PSTH.trial);

time2plot=time>-3 & time<0;

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
            elseif size(P,1)==1
        p_tr = (P.psth_trial.*w_mat);
        p_tr_smooth = movmean(p_tr ,[smooth_bins 0], 2,'omitnan', 'Endpoints','shrink');
        proj_trial_smooth(itr,:) = p_tr_smooth;
        proj_trial(itr,:) = p_tr;
        proj_max_tr(itr)=mean(p_tr(idx_time_to_normalize));
        %         proj_min_tr(itr)=min(p_tr_smooth(idx_time_to_normalize));
        proj_max_tr2(itr)=mean(p_tr(idx_time_to_normalize2));
        
        %         p_tr_smooth = (p_tr_smooth - proj_min)/(proj_max-proj_min);

    elseif size(P,1)==0
        proj_trial(itr,:) = PSTH.psth_trial(1,:) +NaN;
        proj_max_tr(itr)=NaN;
        %         proj_min_tr(itr)=NaN;
        proj_max_tr2(itr)=NaN;
        proj_trial_smooth (itr,:) =PSTH.psth_trial(1,:) + NaN;
        
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


% proj_trial_smooth(idx_l,idx_time_to_outlier)
% isoutlier_l = sum(isoutlier(proj_trial_smooth(idx_l,idx_time_to_outlier),'mean',1),2)>5;
% isoutlier_r = sum(isoutlier(proj_trial_smooth(idx_r,idx_time_to_outlier),'mean',1),2)>5;

z_l = zscore(proj_trial_smooth(idx_l,idx_time_to_outlier));
z_r = zscore(proj_trial_smooth(idx_r,idx_time_to_outlier));

% z_l = zscore(mean(proj_trial_smooth(idx_l,idx_time_to_outlier),2));
isoutlier_l = abs(z_l)>2;
% z_r = zscore(mean(proj_trial_smooth(idx_r,idx_time_to_outlier),2));
isoutlier_r = abs(z_r)>2;

isoutlier_l=ismember(trials,trial_num_l(isoutlier_l));
isoutlier_r=ismember(trials,trial_num_r(isoutlier_r));

% %debug
% hold on;
% plot(time(time2plot), proj_trial_smooth(idx_l,time2plot))
% plot(time(idx_time_to_outlier), proj_trial_smooth(isoutlier_l,idx_time_to_outlier),'.g','MarkerSize',10)

%initialize
    idx_l_no_outliers =idx_l;
    idx_r_no_outliers =idx_r;
    
    
isout_all =isoutlier_l | isoutlier_r;

% isoutlier_l = idx_l & isout_all;
% isoutlier_r = idx_r & isout_all;




session_uid = fetch1(EXP.SessionID & key,'session_uid');
brain_area = fetch1(ANL.SessionPosition & key,'brain_area');
hemisphere = fetch1(ANL.SessionPosition & key,'hemisphere');
training = fetch1(EXP.SessionTraining & key,'training_type');

%debug



if sum(isout_all)>0
    idx_l_no_outliers(isoutlier_l) =false;
    idx_r_no_outliers(isoutlier_r) =false;
else
    idx_l_no_outliers = idx_l;
    idx_r_no_outliers = idx_r;
end

% if sum(isout_all)>0
%     
%     subplot(3,2,1)
%     hold on
%     plot(time(time2plot),proj_trial_smooth(idx_l,time2plot),'-r')
%     if sum(isoutlier_l)>0
%         plot(time(time2plot),proj_trial_smooth(isoutlier_l,time2plot),'-g')
%     end
%     % plot(time(time2plot),proj_trial_smooth(:,time2plot),'-k');
%     % plot(time(time2plot),proj_trial_smooth(isout_all,time2plot),'-g')
%     title(sprintf('Session uid %d  %s %s %s training \n%d outliers',session_uid, brain_area, hemisphere, training, sum(isoutlier_l)))
%     
%     
%     subplot(3,2,2)
%     hold on
%     plot(time(time2plot),proj_trial_smooth(idx_r,time2plot),'-b')
%     if sum(isoutlier_r)>0
%         plot(time(time2plot),proj_trial_smooth(isoutlier_r,time2plot),'-g')
%     end
%     title(sprintf('\n%d outliers',sum(isoutlier_r)))
%     
%     
% 
% 
%     idx_l_no_outliers(isoutlier_l) =false;
%     idx_r_no_outliers(isoutlier_r) =false;
%     
% %     subplot(3,2,3)
% %     hold on
% %     plot(time(time2plot),median(proj_trial_smooth(idx_l,time2plot)),'-r')
% %     plot(time(time2plot),median(proj_trial_smooth(idx_r,time2plot)),'-b')
% %     title('with outliers')
% %     
% %     
% 
% %     
% %     
% %     subplot(3,2,4)
% %     hold on
% %     plot(time(time2plot),median(proj_trial_smooth(idx_l_no_outliers,time2plot)),'-r')
% %     plot(time(time2plot),median(proj_trial_smooth(idx_r_no_outliers,time2plot)),'-b')
% %     title('without outliers')
% else
%     idx_l_no_outliers = idx_l;
%     idx_r_no_outliers = idx_r;
%     
% end


% idx_l(isout_all) =false;
% idx_r(isout_all) =false;


if strcmp(key(1).mode_type_name,'Ramping Orthog.1')
    median_l = median(proj_max_tr2);
    median_r = median(proj_max_tr);
else %Late delay etc

    median_l = median(proj_max_tr(idx_l));
    median_r = median(proj_max_tr(idx_r));
    
    median_l_no_outliers = median(proj_max_tr(idx_l_no_outliers));
    median_r_no_outliers = median(proj_max_tr(idx_r_no_outliers));

end

diff_med =  abs(median_r - median_l);
diff_med_no_outliers =  abs(median_r_no_outliers - median_l_no_outliers);

for itr= 1:1:numel(trials)
    ppp= key(itr+counter_start-1).proj_trial;
    proj_trial_norm = (ppp-min([median_l,median_r]))/diff_med;
    proj_trial_norm_no_outliers = (ppp-min([median_l_no_outliers,median_r_no_outliers]))/diff_med_no_outliers;

    
    
    %      proj_trial_norm = (proj_trial_norm-median_l)/diff_med;
    
    %     proj_trial_norm = (proj_trial_norm)/diff_med;
    
    key(itr+counter_start-1).proj_trial = proj_trial_norm;
    key(itr+counter_start-1).proj_trial_no_outliers = proj_trial_norm_no_outliers;

    key(itr+counter_start-1).is_outlier = isout_all(itr);
    
    %     p(itr,:) = key(itr+counter_start-1).proj_trial;
    ppp_norm(itr,:) = movmean(proj_trial_norm ,[smooth_bins 0], 2,'omitnan', 'Endpoints','shrink') ;
        ppp_norm_no_outliers(itr,:) = movmean(proj_trial_norm_no_outliers ,[smooth_bins 0], 2,'omitnan', 'Endpoints','shrink') ;

    %     plot(time,proj_trial_norm)
end
x=ppp_norm;
xx = ppp_norm_no_outliers;
%  x = movmean(ppp_norm ,[smooth_bins 0], 2,'omitnan', 'Endpoints','shrink');
%     xx = movmean(ppp_norm_no_outliers ,[smooth_bins 0], 2,'omitnan', 'Endpoints','shrink');

    subplot(3,2,1)
   
    hold on
    plot(time(time2plot),x(idx_l,time2plot),'-r')
    if sum(isoutlier_l)>0
        plot(time(time2plot),xx(isoutlier_l,time2plot),'-g')
    end
    % plot(time(time2plot),proj_trial_smooth(:,time2plot),'-k');
    % plot(time(time2plot),proj_trial_smooth(isout_all,time2plot),'-g')
    title(sprintf('Session uid %d  %s %s %s training \n%d outliers',session_uid, brain_area, hemisphere, training, sum(isoutlier_l)))
    
    
    subplot(3,2,2)
    hold on
    plot(time(time2plot),x(idx_r,time2plot),'-b')
    if sum(isoutlier_r)>0
        plot(time(time2plot),xx(isoutlier_r,time2plot),'-g')
    end
    title(sprintf('\n%d outliers',sum(isoutlier_r)))


subplot(3,2,3)
% x = movmean(ppp_norm ,[smooth_bins 0], 2,'omitnan', 'Endpoints','shrink');
hold on
plot(time(time2plot),mean(x(idx_l,time2plot)),'-r')
plot(time(time2plot),mean(x(idx_r,time2plot)),'-b')
title('With outliers');

subplot(3,2,4)
% x = movmean(ppp_norm_no_outliers ,[smooth_bins 0], 2,'omitnan', 'Endpoints','shrink');
hold on
plot(time(time2plot),mean(xx(idx_l_no_outliers,time2plot)),'-r')
plot(time(time2plot),mean(xx(idx_r_no_outliers,time2plot)),'-b')
title('Without outliers');

set(gcf,'DefaultAxesFontName','helvetica');
set(gcf,'PaperUnits','centimeters','PaperPosition',[0 7 21 21]);
set(gcf,'PaperOrientation','portrait');
set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 -10 0 0]);
set(gcf,'color',[1 1 1]);

numbins=linspace(-2,3,15);

subplot(3,2,5)
hold on;
endpoints = x(idx_l,idx_time_to_outlier);
h=100*histcounts(endpoints,numbins)/numel(endpoints);
plot(numbins(1:end-1),h,'-r');
endpoints = x(idx_r,idx_time_to_outlier);
h=100*histcounts(endpoints,numbins)/numel(endpoints);
plot(numbins(1:end-1),h,'-b'); 

subplot(3,2,6)
hold on;
endpoints = xx(idx_l_no_outliers,idx_time_to_outlier);
h=100*histcounts(endpoints,numbins)/numel(endpoints);
plot(numbins(1:end-1),h,'-r');
endpoints = xx(idx_r_no_outliers,idx_time_to_outlier);
h=100*histcounts(endpoints,numbins)/numel(endpoints);
plot(numbins(1:end-1),h,'-b'); 


% dir_save_figure2=[dir_save_figure training '\' brain_area '\' hemisphere '\'];
% if isempty(dir(dir_save_figure2))
%     mkdir (dir_save_figure2)
% end
% 
% figure_name_out=[ dir_save_figure2 'suid' num2str(session_uid)];
% eval(['print ', figure_name_out, ' -dtiff -cmyk -r300']);
% 

clf
end
