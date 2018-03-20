%{
#
-> LAB.BrainArea
-> LAB.Hemisphere
-> EXP.TrainingType
mode_avg_mat_corr_id                        : smallint                  # id of the mode_mat_t_weights matrix
---
avg_mode_mat_t_weights_corr                 : longblob                  # corelation matrix of mode_mat_t_weights, averaged across session
mode_mat_sliding_wind                       : double                    # slinding window duration (in seconds) used to compute the Coding Direction along the trial time
mode_mat_timebin_vector                     : longblob                  # time bin vector corresponding to bin centers of the mode_mat_t_weights
mode_mat_corr_description = null            : varchar(4000)             #
%}


classdef CDrotationAverage < dj.Computed
    properties
                keySource = (LAB.BrainArea *  LAB.Hemisphere) & ANL.SessionPosition;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            primary_key = key;
            
            rel = (EXP.Session & EPHYS.TrialSpikes ) * EXP.SessionID * EXP.SessionTraining * ANL.SessionPosition * (ANL.CDrotation);
            
            % 'distractor'
            %--------------------------------------------------------------------------
            key = primary_key;
            key.training_type ='distractor';
            k= key;
            sess_uids = unique([fetchn(rel & key ,'session_uid', 'ORDER BY session_uid' )],'stable');
            key.mode_mat_timebin_vector = fetch1 (rel & 'mode_mat_corr_id=1', 'mode_mat_timebin_vector', 'LIMIT 1');
            key.mode_mat_sliding_wind = fetch1 (rel & 'mode_mat_corr_id=1', 'mode_mat_sliding_wind', 'LIMIT 1');

            r1_s = zeros(numel(sess_uids), numel(key.mode_mat_timebin_vector), numel(key.mode_mat_timebin_vector));
            r2_s = zeros(numel(sess_uids), numel(key.mode_mat_timebin_vector), numel(key.mode_mat_timebin_vector));
            for i_s =1:1:numel(sess_uids)
                session_uid = sess_uids(i_s);
                k.session_uid = session_uid;
                r1_s(i_s,:,:)=fetch1 (rel & k & 'mode_mat_corr_id=1','mode_mat_t_weights_corr');
                r2_s(i_s,:,:)=fetch1 (rel & k & 'mode_mat_corr_id=2','mode_mat_t_weights_corr');
            end
            r1_s_avg = squeeze(nanmean(r1_s,1));
            r2_s_avg = squeeze(nanmean(r2_s,1));
            
            key.avg_mode_mat_t_weights_corr = r1_s_avg;
            key.mode_avg_mat_corr_id =1;
            key.mode_mat_corr_description = 'using only l/r trials that did not have photostim';
            insert(self,key);
            
            key.avg_mode_mat_t_weights_corr = r2_s_avg;
            key.mode_avg_mat_corr_id =2;
            key.mode_mat_corr_description = 'using all l/r trials, incuding those that had photostim';
            insert(self,key);

            % 'regular'
            %--------------------------------------------------------------------------
            key = primary_key;
            key.training_type ='regular';
            k= key;
            sess_uids = unique([fetchn(rel & key ,'session_uid', 'ORDER BY session_uid' )],'stable');
            key.mode_mat_timebin_vector = fetch1 (rel & 'mode_mat_corr_id=1', 'mode_mat_timebin_vector', 'LIMIT 1');
            key.mode_mat_sliding_wind = fetch1 (rel & 'mode_mat_corr_id=1', 'mode_mat_sliding_wind', 'LIMIT 1');
            
            r1_s = zeros(numel(sess_uids), numel(key.mode_mat_timebin_vector), numel(key.mode_mat_timebin_vector));
            r2_s = zeros(numel(sess_uids), numel(key.mode_mat_timebin_vector), numel(key.mode_mat_timebin_vector));
            for i_s =1:1:numel(sess_uids)
                session_uid = sess_uids(i_s);
                k.session_uid = session_uid;
                r1_s(i_s,:,:)=fetch1 (rel & k & 'mode_mat_corr_id=1','mode_mat_t_weights_corr');
                r2_s(i_s,:,:)=fetch1 (rel & k & 'mode_mat_corr_id=2','mode_mat_t_weights_corr');
            end
            r1_s_avg = squeeze(nanmean(r1_s,1));
            r2_s_avg = squeeze(nanmean(r2_s,1));
            
            key.avg_mode_mat_t_weights_corr = r1_s_avg;
            key.mode_avg_mat_corr_id =1;
            key.mode_mat_corr_description = 'using only l/r trials that did not have photostim';
            insert(self,key);
            
            key.avg_mode_mat_t_weights_corr = r2_s_avg;
            key.mode_avg_mat_corr_id =2;
            key.mode_mat_corr_description = 'using all l/r trials, incuding those that had photostim';
            insert(self,key);

            % all training types
            %--------------------------------------------------------------------------
            key = primary_key;
            k= key;
            sess_uids = unique([fetchn(rel & key ,'session_uid', 'ORDER BY session_uid' )],'stable');
            key.mode_mat_timebin_vector = fetch1 (rel & 'mode_mat_corr_id=1', 'mode_mat_timebin_vector', 'LIMIT 1');
            key.mode_mat_sliding_wind = fetch1 (rel & 'mode_mat_corr_id=1', 'mode_mat_sliding_wind', 'LIMIT 1');
            key.training_type ='all';

            r1_s = zeros(numel(sess_uids), numel(key.mode_mat_timebin_vector), numel(key.mode_mat_timebin_vector));
            r2_s = zeros(numel(sess_uids), numel(key.mode_mat_timebin_vector), numel(key.mode_mat_timebin_vector));
            for i_s =1:1:numel(sess_uids)
                session_uid = sess_uids(i_s);
                k.session_uid = session_uid;
                r1_s(i_s,:,:)=fetch1 (rel & k & 'mode_mat_corr_id=1','mode_mat_t_weights_corr');
                r2_s(i_s,:,:)=fetch1 (rel & k & 'mode_mat_corr_id=2','mode_mat_t_weights_corr');
            end
            r1_s_avg = squeeze(nanmean(r1_s,1));
            r2_s_avg = squeeze(nanmean(r2_s,1));
            
            key.avg_mode_mat_t_weights_corr = r1_s_avg;
            key.mode_avg_mat_corr_id =1;
            key.mode_mat_corr_description = 'using only l/r trials that did not have photostim';
            insert(self,key);
            
            key.avg_mode_mat_t_weights_corr = r2_s_avg;
            key.mode_avg_mat_corr_id =2;
            key.mode_mat_corr_description = 'using all l/r trials, incuding those that had photostim';
            insert(self,key);
            
            
        end
    end
end