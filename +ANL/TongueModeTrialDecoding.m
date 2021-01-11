%{
# Decoding tongue kinematic based on the regression mode
-> EXP.Session
-> EPHYS.CellType
-> EPHYS.UnitQualityType
-> ANL.TongueTuning1DType
-> ANL.LickDirectionType
-> ANL.OutcomeTypeDecoding
-> ANL.FlagBasicTrialsDecoding
-> ANL.ModeWeightsSign
-> ANL.ModeTypeName2
---
rsq_linear_regression_t                         : blob       # rsquare (coefficient of determination) based on linear regression computed at one time and projected at various times
rsq_logistic_regression_t                       : blob       # rsquare (coefficient of determination) based on logistic regression computed at one time and projected at various times
t_for_decoding                                  : blob       #
%}


classdef TongueModeTrialDecoding < dj.Computed
    properties
        keySource = (EXP.Session & EPHYS.Unit & ANL.Video1stLickTrial) * (EPHYS.CellType & 'cell_type="Pyr"') * (EPHYS.UnitQualityType & 'unit_quality="ok or good"') * (ANL.TongueTuning1DType & 'tuning_param_name="lick_horizoffset" or tuning_param_name="lick_rt_video_onset" or tuning_param_name="lick_peak_x"') * ANL.LickDirectionType * ANL.OutcomeTypeDecoding * ANL.FlagBasicTrialsDecoding * ANL.ModeWeightsSign * ANL.ModeTypeName2 & (ANL.IncludeSession -ANL.ExcludeSession);
    end
    methods(Access=protected)
        function makeTuples(self, key)
            k=key;
            
            Param = struct2table(fetch (ANL.Parameters,'*'));
            minimal_num_units_proj_trial=Param.parameter_value{(strcmp('minimal_num_units_proj_trial',Param.parameter_name))};
            
            
            %             if strcmp(k.lick_direction,'all')
            %                 k=rmfield(k,'lick_direction');
            %             end
            
            k_proj=key;
            
            k.tongue_estimation_type='tip';
            
            if k.flag_use_basic_trials_decoding==1
                k.trialtype_left_and_right_no_distractors=1;
            end
            
            if ~strcmp(k.outcome_trials_for_decoding,'all')
                k.outcome=k.outcome_trials_for_decoding;
            end
            
            
            
            time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
            
            rel_behav= EXP.TrialID & ((EXP.BehaviorTrial * EXP.TrialName  * ANL.TrialTypeGraphic* ANL.Video1stLickTrial *ANL.LickDirectionTrial )   & k  & 'early_lick="no early"')& ANL.ProjTrialNormalized & ANL.VideoTongueValidRTTrial;
            if rel_behav.count==0
                return
            end
            TONGUE = struct2table(fetch((ANL.Video1stLickTrial & rel_behav &k )*EXP.TrialID,'*' , 'ORDER BY trial_uid'));
            
%             idx_v1=~isoutlier(TONGUE.lick_rt_video_onset);
            idx_v=~isoutlier(table2array(TONGUE(:,key.tuning_param_name)));
%             idx_v = idx_v1 | idx_v2;

            TONGUE=TONGUE(idx_v,:);
                        
            rel_Proj = ((ANL.ProjTrialNormalized & rel_behav) &k_proj  )*EXP.TrialID*EXP.TrialName*EXP.BehaviorTrial;
            proj_trial=cell2mat(fetchn(rel_Proj,'proj_trial', 'ORDER BY trial_uid'));
            if rel_Proj.count==0
                return
            end
            
            %exlude trials with too few neurons to project
            num_units_projected=fetchn(rel_Proj,'num_units_projected', 'ORDER BY trial_uid');
            include_proj_idx=num_units_projected>minimal_num_units_proj_trial;
            include_proj_idx=include_proj_idx(idx_v);
            
            if sum(include_proj_idx)<=10
                return
            end
            
            t=-4:0.1:2;
            time_window=0.5;
            for i_t=1:1:numel(t)
                time_idx_2plot = (time >=t(i_t) & time<t(i_t) + time_window);
                
                P.endpoint=nanmean(proj_trial(idx_v,time_idx_2plot),2);
                
                %exlude outliers
                P_outlier_idx= isoutlier(P.endpoint,'quartiles');
                
                P.endpoint=(P.endpoint(~P_outlier_idx & include_proj_idx));
                TONGUE_current=TONGUE(~P_outlier_idx & include_proj_idx,:);
                
                Y=table2array(TONGUE_current(:,key.tuning_param_name));
                
                X=P.endpoint;
                [X,Y,Linear, Logistic] = fn_compute_linear_and_logistic_regression (X,Y);
                
                
                
                %% Computing R2 of both types of fits (linear and logistic)
                R2_LinearRegression(i_t)=Linear.R2;
                R2_LogisticRegression(i_t)=Logistic.R2;
                

            end
            
            key.rsq_linear_regression_t=R2_LinearRegression;
            key.rsq_logistic_regression_t=R2_LogisticRegression;
            key.t_for_decoding=t;
            insert(self,key);
            
        end
    end
end