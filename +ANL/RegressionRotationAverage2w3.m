%{
#
-> LAB.BrainArea
-> LAB.Hemisphere
-> EXP.TrainingType
-> EPHYS.CellType
-> ANL.TongueTuning1DType
-> ANL.OutcomeType
-> ANL.FlagBasicTrials
-> ANL.LickDirectionType
---
avg_regress_b2_mat_corr                     : longblob                  # corelation matrix, averaged across sessions
avg_regress_rsq_mat_corr                     : longblob                  # corelation matrix, averaged across sessions
avg_regress_weights_mat_corr                     : longblob                  # corelation matrix, averaged across sessions
avg_regress_weights2_mat_corr                     : longblob                  # corelation matrix, averaged across sessions

regress_mat_timebin_vector                     : longblob                  # time bin vector corresponding to bin centers of the regress_mat_t_weights
%}


classdef RegressionRotationAverage2w3 < dj.Computed
    properties
        keySource = (LAB.BrainArea & 'brain_area="all" or brain_area="vS1" or brain_area="ALM"') *  LAB.Hemisphere * EXP.TrainingType * (EPHYS.CellType & 'cell_type="PYR" or cell_type="FS" or cell_type="all"')   * (ANL.OutcomeType & 'outcome_grouping="all"') * (ANL.FlagBasicTrials & 'flag_use_basic_trials=0')  * (ANL.TongueTuning1DType & 'tuning_param_name="lick_horizoffset_relative" or tuning_param_name="lick_rt_video_onset" or tuning_param_name="lick_peak_x"') * (ANL.LickDirectionType);
    end
    methods(Access=protected)
        function makeTuples(self, key)
            kk = key;
            if strcmp(kk.brain_area	,'all')
                kk=rmfield(kk,'brain_area');
            end
            if strcmp(kk.hemisphere,'both')
                kk=rmfield(kk,'hemisphere');
            end
            if strcmp(kk.training_type,'all')
                kk=rmfield(kk,'training_type');
            end
            
            rel =(ANL.RegressionRotation2w3*ANL.SessionPosition* EXP.SessionTraining*EXP.SessionID) & kk ;
            
            list_session_uid=fetchn(rel,'session_uid');
            if isempty(list_session_uid)
                return
            end
            
            
            for i_s =1:1:numel(list_session_uid)
                k.session_uid = list_session_uid(i_s);
                regress_b2_mat_corr(i_s,:,:)=fetch1 (rel & k,'regress_b2_mat_corr');
                regress_rsq_mat_corr(i_s,:,:)=fetch1 (rel & k,'regress_rsq_mat_corr');
                regress_weights_mat_corr(i_s,:,:)=fetch1 (rel & k,'regress_weight_corr');
                regress_weights2_mat_corr(i_s,:,:)=fetch1 (rel & k,'regress_weight2_corr');
                
            end
            avg_regress_b2_mat_corr = squeeze(nanmean(regress_b2_mat_corr,1));
            avg_regress_rsq_mat_corr = squeeze(nanmean(regress_rsq_mat_corr,1));
            avg_regress_weights_mat_corr = squeeze(nanmean(regress_weights_mat_corr,1));
            avg_regress_weights2_mat_corr = squeeze(nanmean(regress_weights2_mat_corr,1));
            
            %             imagesc(regress_mat_timebin_vector,regress_mat_timebin_vector,r_s_avg)
            
            regress_mat_timebin_vector=fetch1 (rel & k,'regress_mat_timebin_vector');
            
            key.avg_regress_b2_mat_corr = avg_regress_b2_mat_corr;
            key.avg_regress_rsq_mat_corr = avg_regress_rsq_mat_corr;
            key.avg_regress_weights_mat_corr = avg_regress_weights_mat_corr;
            key.avg_regress_weights2_mat_corr = avg_regress_weights2_mat_corr;

            key.regress_mat_timebin_vector =regress_mat_timebin_vector;
            
            insert(self,key);
            
        end
    end
end