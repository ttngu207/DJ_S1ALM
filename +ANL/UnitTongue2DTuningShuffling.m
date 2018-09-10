%{
#
-> EPHYS.Unit
-> ANL.TongueTuningXType
-> ANL.TongueTuningYType
-> ANL.OutcomeType
time_window_start                               : decimal(8,4)              #
->ANL.TongueTuningSmoothFlag
---
tongue_tuning_2d_si_shuffled                       : longblob              # spatial information, shuffled values
%}

classdef UnitTongue2DTuningShuffling < dj.Computed
    properties
        keySource = ((EPHYS.Unit & 'unit_quality!="multi"' & (EPHYS.UnitCellType & 'cell_type="PYR" or cell_type="FS"')) & ANL.Video1stLickTrialNormalized) * (ANL.TongueTuningXType) * (ANL.TongueTuningYType) * (ANL.OutcomeType & 'outcome="all"') * (ANL.TongueTuningSmoothFlag);
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            smooth_flag=key.smooth_flag;
            
            
            kk=key;
            if strcmp(key.outcome,'all')
                kk=rmfield(kk,'outcome');
            end
            hist_bins_X=linspace(0,1,7);
            hist_bins_Y=linspace(0,1,7);
            
            Param = struct2table(fetch (ANL.Parameters,'*'));
            number_of_shuffles = Param.parameter_value{(strcmp('tongue_tuning_number_of_shuffles',Param.parameter_name))};
            
            min_trials_2D_bin = Param.parameter_value{(strcmp('tongue_tuning_min_trials_2D_bin',Param.parameter_name))};
            
            
            rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial & ANL.Video1stLickTrialNormalized & kk  &  'early_lick="no early"');
            SPIKES=fetchn(rel_spikes,'spike_times_go','ORDER BY trial');
            
            if isempty(SPIKES)
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
                        
            idx_v_name=find(strcmp(VariableNames,kk.tuning_param_name_x));
            X=TONGUE{:,idx_v_name+var_table_offset-1};
            
            idx_v_name=find(strcmp(VariableNames,kk.tuning_param_name_y));
            Y=TONGUE{:,idx_v_name+var_table_offset-1};
            
            
            
            t_wnd{1}=[-0.4, 0];
            t_wnd{2}=[0, 0.2];
            kk.outcome=key.outcome;
            
            for i_twnd=1:numel(t_wnd)
                
                kk.time_window_start=t_wnd{i_twnd}(1);
                
                
                tongue_tuning_2d_si_shuffled=[];
                
                trials_vec=1:1:size(TONGUE,1);
                
                for i_s=1:1:number_of_shuffles
                    trials_vec_shuffled = trials_vec(randperm(length(trials_vec)));
                    SPIKES_SHUFFLED=SPIKES(trials_vec_shuffled);
                    [SI] = fn_tongue_tuning2D_shuffling(X,Y, SPIKES_SHUFFLED, t_wnd{i_twnd},  min_trials_2D_bin, hist_bins_X, hist_bins_Y ,smooth_flag);
                    tongue_tuning_2d_si_shuffled(i_s)=SI;
                end
                kk.tongue_tuning_2d_si_shuffled=tongue_tuning_2d_si_shuffled;
                
                
                insert(self,kk)
            end
            
            
            
        end
    end
    
end


