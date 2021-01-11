function fn_regression_decoding_lick_number (key,self, rel_Nth_lick)

Param = struct2table(fetch (ANL.Parameters,'*'));
time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
minimal_num_units_proj_trial = 3; %Param.parameter_value{(strcmp('minimal_num_units_proj_trial',Param.parameter_name))};

k_proj=key;
k_proj.regression_time_start=key.regression_time_start;

rel_Proj = ((ANL.RegressionProjTrialGo	 & rel_Nth_lick) &k_proj  )*EXP.TrialID*EXP.TrialName*EXP.BehaviorTrial;

if rel_Proj.count<=10
    return
end

rel_TONGUE= ((ANL.VideoNthLickTrial & rel_Nth_lick & key )*EXP.TrialID) & rel_Proj.proj;
TONGUE = struct2table(fetch(rel_TONGUE,'*' , 'ORDER BY trial_uid'));

idx_v=~isoutlier(table2array(TONGUE(:,key.tuning_param_name)));
TONGUE=TONGUE(idx_v,:);

proj_trial=cell2mat(fetchn(rel_Proj,'proj_trial', 'ORDER BY trial_uid'));
proj_trial= proj_trial(idx_v,:);


%exlude trials with too few neurons to project
num_units_projected=fetchn(rel_Proj,'num_units_projected', 'ORDER BY trial_uid');
include_proj_idx=num_units_projected>minimal_num_units_proj_trial;
include_proj_idx=include_proj_idx(idx_v);

if sum(include_proj_idx)<=10
    return
end

TONGUE=TONGUE(include_proj_idx,:);
proj_trial= proj_trial(include_proj_idx,:);


t=-1:0.1:1;
time_window=0.1;
for i_t=1:1:numel(t)
    
    for i_trial=1:1:size(TONGUE,1)
        t_lick_onset= table2array(TONGUE(i_trial,'lick_rt_video_peak'));
        time_idx_2plot = ((time-t_lick_onset) >=t(i_t) & (time -t_lick_onset)<t(i_t) + time_window);
        P.endpoint(i_trial)=nanmean(proj_trial(i_trial,time_idx_2plot),2);
    end
    
    %exlude outliers
    P_outlier_idx= isoutlier(P.endpoint,'quartiles');
    
    P.endpoint=P.endpoint(~P_outlier_idx);
    TONGUE_current=TONGUE(~P_outlier_idx,:);
    
    Y=table2array(TONGUE_current(:,key.tuning_param_name));
    X=(P.endpoint)';
    [X,Y,Linear] = fn_compute_linear_regression (X,Y);
    
    
    
    %% Computing R2 of both types of fits (linear and logistic)
    R2_LinearRegression(i_t)=Linear.R2;
    %     R2_LogisticRegression(i_t)=Logistic.R2;
end

key.rsq_linear_regression_t=R2_LinearRegression;
key.t_for_decoding=t;
key.number_of_trials=size(TONGUE,1);
insert(self,key);