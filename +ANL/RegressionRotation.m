%{
#
-> EXP.Session
-> EPHYS.CellType
-> ANL.TongueTuning1DType
-> ANL.OutcomeType
-> ANL.FlagBasicTrials
-> ANL.LickDirectionType
---
regress_mat_t_weights                          : longblob                  # matrix of Time X Weight of the regression coefficient at different times along the trial
regress_mat_t_weights_corr                     : longblob                  # corelation matrix of regress_mat_t_weights
regress_mat_timebin_vector                     : longblob                  # time bin vector corresponding to bin centers of the regress_mat_t_weights
%}


classdef RegressionRotation < dj.Computed
    properties
        keySource = (EXP.Session & ANL.RegressionTongueSingleUnit) * (EPHYS.CellType & 'cell_type="PYR" or cell_type="FS" or cell_type="all"')   * (ANL.OutcomeType & 'outcome_grouping="all"') * (ANL.FlagBasicTrials & 'flag_use_basic_trials=0')  * (ANL.TongueTuning1DType & 'tuning_param_name="lick_horizoffset_relative" or tuning_param_name="lick_rt_video_onset" or tuning_param_name="lick_peak_x"') * (ANL.LickDirectionType);
    end
    methods(Access=protected)
        
        function makeTuples(self, key)
            kk=key;
            if strcmp(kk.cell_type,'all')
                kk=rmfield(kk,'cell_type');
            end
            tic
                     
            rel = (MISC.S1TrialTypeName * ANL.TrialTypeStimTime * EXP.BehaviorTrial) & key & 'early_lick="no early"' & 'outcome="hit"' & ANL.TrialBehaving;
            
            time_vector=fetchn(ANL.RegressionTime,'regression_time_start','ORDER BY regression_time_start');
            
            for it=1:1:numel(time_vector)
                k_time.regression_time_start = time_vector (it);
                regression_coeff_b2(it,:) =fetchn(ANL.RegressionTongueSingleUnit*EPHYS.UnitCellType & kk & k_time,'regression_coeff_b2','ORDER BY unit');
                
            end
            r = corr(regression_coeff_b2','rows','Pairwise');
            
            imagesc(time_vector,time_vector,r)
            

            
            key.regress_mat_t_weights=regression_coeff_b2;
            key.regress_mat_t_weights_corr=r;
            key.regress_mat_timebin_vector=time_vector;
            insert(self,key);
            toc
        end
        
    end
end