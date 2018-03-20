%{
#
-> EXP.Session
mode_mat_corr_id                            : smallint                  # id of the mode_mat_t_weights matrix
---
mode_mat_t_weights                          : longblob                  # matrix of Time X Weight pf the Coding Direction mode computed at different times along the trial
mode_mat_t_weights_corr                     : longblob                  # corelation matrix of mode_mat_t_weights
mode_mat_sliding_wind                       : double                    # slinding window duration (in seconds) used to compute the Coding Direction along the trial time
mode_mat_timebin_vector                     : longblob                  # time bin vector corresponding to bin centers of the mode_mat_t_weights
mode_mat_corr_description = null            : varchar(4000)             #
%}


classdef CDrotation < dj.Computed
    properties
        keySource = EXP.Session & EPHYS.TrialSpikes
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            tic
            subject_id = key.subject_id;
            session = key.session;
            psth_t_u_tr = fetch1(ANL.PSTHMatrix & key, 'psth_t_u_tr');
            n_units = size(psth_t_u_tr,2);
            psth_t_vector=fetch1(ANL.Parameters & 'parameter_name="psth_t_vector"','parameter_value');
            mintrials_modeweights=fetch1(ANL.Parameters & 'parameter_name="mintrials_modeweights"','parameter_value');
            shuffle_num_for_modeweights=1;
            trialfraction_for_modeweights=1;
            mode_mat_sliding_wind=fetch1(ANL.Parameters & 'parameter_name="mode_mat_sliding_wind"','parameter_value');
            
            rel = (MISC.S1TrialTypeName * ANL.TrialTypeStimTime * EXP.BehaviorTrial) & key & 'early_lick="no early"' & 'outcome="hit"' & ANL.TrialBehaving;
            
            
            time_vector = psth_t_vector(psth_t_vector>=-4.6 &  psth_t_vector< 1.6 );
            mode_mat_timebin_vector = time_vector + mode_mat_sliding_wind/2;
            
            %% CD using only l/r trials that didn't have photostim
            trials1 = [fetchn( rel  & 'stimtm_presample="1000"' &  'stimtm_sample="-2.5"' & 'stimtm_earlydelay="1000"' & 'stimtm_latedelay="1000"', 'trial', 'ORDER BY trial')];
            trials2 = [fetchn( rel  & 'stimtm_presample="1000"' &  'stimtm_sample="1000"' & 'stimtm_earlydelay="1000"' & 'stimtm_latedelay="1000"', 'trial', 'ORDER BY trial')];
            mode_mat_t_weights = zeros(numel(time_vector),n_units);
            for it=1:1:numel(time_vector)
                tint1 = [time_vector(it) time_vector(it)+mode_mat_sliding_wind];
                tint2 = tint1;
                mode_mat_t_weights(it,:) = shuffleModeWeights(psth_t_u_tr,n_units, trials1, trials2, tint1, tint2, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            end
            r = corr(mode_mat_t_weights','rows','Pairwise');
            
            key.mode_mat_corr_id=1;
            key.mode_mat_t_weights=mode_mat_t_weights;
            key.mode_mat_t_weights_corr=r;
            
            key.mode_mat_sliding_wind=mode_mat_sliding_wind;
            key.mode_mat_timebin_vector=mode_mat_timebin_vector;
            key.mode_mat_corr_description='using only l/r trials that did not have photostim';
            insert(self,key);
            
            %% CD using all l/r trials, incuding those that had photostim
            trials1 = [fetchn( rel &  'stimtm_sample="-2.5"', 'trial', 'ORDER BY trial')];
            trials2 = [fetchn( rel &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];
            mode_mat_t_weights = zeros(numel(time_vector),n_units);
            for it=1:1:numel(time_vector)
                tint1 = [time_vector(it) time_vector(it)+mode_mat_sliding_wind];
                tint2 = tint1;
                mode_mat_t_weights(it,:) = shuffleModeWeights(psth_t_u_tr,n_units, trials1, trials2, tint1, tint2, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            end
            
            r = corr(mode_mat_t_weights','rows','Pairwise');
            
            key.mode_mat_corr_id=2;
            key.mode_mat_t_weights=mode_mat_t_weights;
            key.mode_mat_t_weights_corr=r;
            key.mode_mat_sliding_wind=mode_mat_sliding_wind;
            key.mode_mat_timebin_vector=mode_mat_timebin_vector;
            key.mode_mat_corr_description='using all l/r trials, incuding those that had photostim';
            insert(self,key);
            toc
        end
        
    end
end