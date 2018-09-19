%{
#
-> EPHYS.Unit
-> ANL.TongueTuning1DType
-> ANL.TongueTuning1DTypeReconstruction
-> ANL.OutcomeType
time_window_start                               : decimal(8,4)              #
-> ANL.TongueTuningSmoothFlag
-> ANL.FlagBasicTrials
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
        keySource = ((EPHYS.Unit & 'unit_quality!="multi"' & (EPHYS.UnitCellType & 'cell_type="PYR" or cell_type="FS"')) & ANL.Video1stLickTrialNormalized) *  (ANL.TongueTuningSmoothFlag & 'smooth_flag=0') * (ANL.OutcomeType & 'outcome_grouping="all"') * ANL.FlagBasicTrials  * ANL.TongueTuning1DType * (ANL.TongueTuning1DTypeReconstruction);
    
%             keySource = ((EPHYS.Unit & 'unit_quality!="multi"' & (EPHYS.UnitCellType & 'cell_type="PYR" or cell_type="FS"')) & ANL.Video1stLickTrialNormalized) *  (ANL.TongueTuningSmoothFlag & 'smooth_flag=0') * (ANL.OutcomeType & 'outcome_grouping="all"') * ANL.FlagBasicTrials  * (ANL.TongueTuning1DType & 'tuning_param_name="lick_peak_x"') * (ANL.TongueTuning1DTypeReconstruction & 'reconstruction_tuning_param_name="lick_horizoffset_relative"') & 'subject_id=365943' & 'session=6' & 'unit=42';
end
    methods(Access=protected)
        function makeTuples(self, key)
            
            if strcmp(key.tuning_param_name,key.reconstruction_tuning_param_name)
                return
            end
            smooth_bins=3;
            Param = struct2table(fetch (ANL.Parameters,'*'));
            min_trials_1D_bin = Param.parameter_value{(strcmp('tongue_tuning_min_trials_1D_bin',Param.parameter_name))};
            
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
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial *   (EXP.TrialName & (ANL.TrialTypeGraphic & 'trialtype_left_and_right_no_distractors=1')) & ANL.Video1stLickTrialNormalized & kk  &  'early_lick="no early"');
            else
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial & ANL.Video1stLickTrialNormalized & kk  &  'early_lick="no early"');
            end
            
            if rel_spikes.count==0
                return
            end
            rel_video=(ANL.Video1stLickTrialNormalized & kk & rel_spikes);
            TONGUE=struct2table(fetch(rel_video,'*','ORDER BY trial'));
            
            number_of_trials=size(TONGUE,1);
            
            if number_of_trials<10
                return
            end
            
            VariableNames=TONGUE.Properties.VariableNames';
            var_table_offset=5;
            VariableNames=VariableNames(var_table_offset:18);
            
            
            kk.tuning_param_name;
            idx_v_name=find(strcmp(VariableNames,kk.tuning_param_name));
            X=TONGUE{:,idx_v_name+var_table_offset-1};
            
            idx_v_name=find(strcmp(VariableNames,kk.reconstruction_tuning_param_name));
            Y=TONGUE{:,idx_v_name+var_table_offset-1};
            
            
            hist_bins=linspace(0,1,numel(TUNING_X(1).hist_bins_centers)+1);
            time_window_start=[TUNING_X.time_window_start];
            time_window_end=[TUNING_X.time_window_end];
            
            
            kk.outcome_grouping=key.outcome_grouping;
            
            % Reconstruction
            for i_twnd=1:numel(time_window_start)
                
                t_wnd(1)=time_window_start(i_twnd);
                t_wnd(2)=time_window_end(i_twnd);
                [kk.tongue_tuning_1d_reconstructed, kk.hist_bins_centers, kk.si_reconstructed, kk.reconstruction_r, kk.reconstruction_error ]= ...
                    fn_tongue_tuning1D_reconstruction (X, Y, TUNING_X(i_twnd).tongue_tuning_1d, TUNING_Y(i_twnd).tongue_tuning_1d, t_wnd, hist_bins, min_trials_1D_bin, smooth_bins, smooth_flag);
                kk.time_window_start=t_wnd(1);
                kk.time_window_end=t_wnd(1);
                insert(self,kk)
            end
            
            
        end
    end
    
end


