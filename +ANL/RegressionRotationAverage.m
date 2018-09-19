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
avg_regress_mat_t_weights_corr                 : longblob                  # corelation matrix of  regress_mat_t_weights, averaged across session
regress_mat_timebin_vector                     : longblob                  # time bin vector corresponding to bin centers of the regress_mat_t_weights
%}


classdef RegressionRotationAverage < dj.Computed
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
            
            rel =(ANL.RegressionRotation*ANL.SessionPosition* EXP.SessionTraining*EXP.SessionID) & kk ;

            list_session_uid=fetchn(rel,'session_uid');
            if isempty(list_session_uid)
                return
            end
                
                
            for i_s =1:1:numel(list_session_uid)
                k.session_uid = list_session_uid(i_s);
                r_s(i_s,:,:)=fetch1 (rel & k,'regress_mat_t_weights_corr');
            end
            r_s_avg = squeeze(nanmean(r_s,1));
            regress_mat_timebin_vector=fetch1 (rel & k,'regress_mat_timebin_vector');
            
%             imagesc(regress_mat_timebin_vector,regress_mat_timebin_vector,r_s_avg)
            
            key.avg_regress_mat_t_weights_corr = r_s_avg;
            key.regress_mat_timebin_vector =regress_mat_timebin_vector;
          
            insert(self,key);

        end
    end
end