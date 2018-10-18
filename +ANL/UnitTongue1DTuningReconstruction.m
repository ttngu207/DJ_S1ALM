%{
#
-> EPHYS.Unit
-> ANL.TongueTuning1DType
-> ANL.TongueTuning1DTypeReconstruction
-> ANL.OutcomeType
-> ANL.TongueTuningSmoothFlag
-> ANL.FlagBasicTrials
-> ANL.LickDirectionType
time_window_start                               : decimal(8,4)              #
---
time_window_end                                 : decimal(8,4)              #
reconstruction_r=null                           : decimal(8,4)              # correlation between original and reconstructed tuning curve
reconstruction_error=null                       : decimal(8,4)              # reconstruction error - eucledian distance between the tuning curve, computed as  Normalized mean-square deviation
si_reconstructed=null                           : decimal(8,4)              # spatial information
tongue_tuning_1d_reconstructed                  : blob                      # reconstructed tuning curve
hist_bins_centers                               : blob                      #
%}

classdef UnitTongue1DTuningReconstruction < dj.Computed
    properties
        keySource = ((EPHYS.Unit & 'unit_quality!="multi"' & (EPHYS.UnitCellType & 'cell_type="PYR" or cell_type="FS"')) & ANL.Video1stLickTrial) *  (ANL.TongueTuningSmoothFlag & 'smooth_flag=0') * (ANL.OutcomeType & 'outcome_grouping="all"') * (ANL.FlagBasicTrials & 'flag_use_basic_trials=0')  * (ANL.TongueTuning1DType & 'tuning_param_name="lick_horizoffset" or tuning_param_name="lick_rt_video_onset" or tuning_param_name="lick_peak_x"') * (ANL.TongueTuning1DTypeReconstruction & 'reconstruction_tuning_param_name="lick_horizoffset" or reconstruction_tuning_param_name="lick_rt_video_onset" or reconstruction_tuning_param_name="lick_peak_x"') * (ANL.LickDirectionType);
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            if strcmp(key.tuning_param_name,key.reconstruction_tuning_param_name)
                return
            end
            smooth_bins=3;
            Param = struct2table(fetch (ANL.Parameters,'*'));
            min_trials_1D_bin = Param.parameter_value{(strcmp('tongue_tuning_min_trials_1D_bin',Param.parameter_name))};
            
            
             key_lick_direction=EXP.TrialID & (ANL.LickDirectionTrial & key) & ANL.VideoTongueValidRTTrial;
            
            kk=key;
            smooth_flag=key.smooth_flag;
            
            if strcmp(key.outcome_grouping,'all')
                kk=rmfield(kk,'outcome_grouping');
            end
            TUNING_X=fetch(ANL.UnitTongue1DTuning & key,'*', 'ORDER BY time_window_start');
            key_reconstruction=key;
            key_reconstruction.tuning_param_name=key.reconstruction_tuning_param_name;
            TUNING_Y=fetch(ANL.UnitTongue1DTuning & key_reconstruction,'*', 'ORDER BY time_window_start'); % the tuning to variable Y that is used to reconstruct X
            
            
            if kk.flag_use_basic_trials==1
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial *   (EXP.TrialName & (ANL.TrialTypeGraphic & 'trialtype_left_and_right_no_distractors=1')) & ANL.Video1stLickTrial & kk  &  'early_lick="no early"');
            else
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial & ANL.Video1stLickTrial & kk  &  'early_lick="no early"');
            end
            
            rel_spikes=rel_spikes & key_lick_direction;
            if rel_spikes.count==0
                return
            end
            
            rel_video=(ANL.Video1stLickTrial & kk & rel_spikes) ;
            if rel_video.count<10
                return
            end
            TONGUE=struct2table(fetch(rel_video,'*','ORDER BY trial'));
            
            
            VariableNames=TONGUE.Properties.VariableNames';
            
            kk.tuning_param_name;
            idx_v_name=find(strcmp(VariableNames,kk.tuning_param_name));
            X=TONGUE{:,idx_v_name};
            
            idx_v_name=find(strcmp(VariableNames,kk.reconstruction_tuning_param_name));
            Y=TONGUE{:,idx_v_name};
            
            
            %remove outliers
            idx_outlier1=isoutlier(X);
            idx_outlier2=isoutlier(Y);
            
            idx_outlier=idx_outlier1|idx_outlier2;
            X(idx_outlier)=[];
            Y(idx_outlier)=[];
            
            time_window_start=[TUNING_X.time_window_start];
            time_window_duration=TUNING_X(1).time_window_duration;
            hist_bins_x=TUNING_X(1).hist_bins;
            hist_bins_y=TUNING_Y(1).hist_bins;
            
            kk.outcome_grouping=key.outcome_grouping;
            
            % Reconstruction
            for i_twnd=1:numel(time_window_start)
                
                t_wnd(1)=time_window_start(i_twnd);
                t_wnd(2)=time_window_start(i_twnd)+time_window_duration;
                [kk.tongue_tuning_1d_reconstructed, kk.hist_bins_centers, kk.si_reconstructed, kk.reconstruction_r, kk.reconstruction_error ]= ...
                    fn_tongue_tuning1D_reconstruction (X, Y, TUNING_X(i_twnd).tongue_tuning_1d, TUNING_Y(i_twnd).tongue_tuning_1d, t_wnd, hist_bins_x,hist_bins_y, min_trials_1D_bin, smooth_bins, smooth_flag);
                kk.time_window_start=t_wnd(1);
                kk.time_window_end=t_wnd(1);
                insert(self,kk)
            end
            
            
        end
    end
    
end


