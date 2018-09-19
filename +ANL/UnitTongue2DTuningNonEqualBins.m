%{
#
-> EPHYS.Unit
-> ANL.TongueTuningXType
-> ANL.TongueTuningYType
-> ANL.OutcomeType
time_window_start                               : decimal(8,4)              #
->ANL.TongueTuningSmoothFlag
---
number_of_trials                                : int
time_window_end                                 : decimal(8,4)              #
number_of_spikes_window                         : int                       #
tongue_tuning_2d_peak_fr=null                   : decimal(8,4)              #
tongue_tuning_2d_min_fr=null                    : decimal(8,4)              #
tongue_tuning_2d_peak_fr_bin=null               : decimal(8,4)              #
tongue_tuning_2d_si=null                        : decimal(8,4)              # spatial information
tongue_tuning_2d                                : blob                      #
tongue_tuning_2d_odd                            : blob                      #
tongue_tuning_2d_even                           : blob                      #
hist_bins_centers_x                             : blob                      #
hist_bins_centers_y                             : blob                      #
stability_odd_even_corr_r=null                  : decimal(8,4)              # Pearson correlation r, between tuning curves computed using odd vs even trials
%}

classdef UnitTongue2DTuningNonEqualBins < dj.Computed
    properties
        keySource = ((EPHYS.Unit & 'unit_quality!="multi"' & (EPHYS.UnitCellType & 'cell_type="PYR" or cell_type="FS"')) & ANL.Video1stLickTrialNormalized) * (ANL.TongueTuningXType) * (ANL.TongueTuningYType) * (ANL.OutcomeType & 'outcome="all"') * (ANL.TongueTuningSmoothFlag & 'smooth_flag=0');
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            smooth_flag=key.smooth_flag;
            
            
            kk=key;
            if strcmp(key.outcome,'all')
                kk=rmfield(kk,'outcome');
            end
            
            plot_flag=0;
            
            Param = struct2table(fetch (ANL.Parameters,'*'));
            min_trials_2D_bin = Param.parameter_value{(strcmp('tongue_tuning_min_trials_2D_bin',Param.parameter_name))};
            
            
            rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial & ANL.Video1stLickTrialNormalized & kk  &  'early_lick="no early"');
            SPIKES=fetch(rel_spikes,'*','ORDER BY trial');
            
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
            
            kk.number_of_trials=number_of_trials;
            
            idx_v_name=find(strcmp(VariableNames,kk.tuning_param_name_x));
            X=TONGUE{:,idx_v_name+var_table_offset-1};
            
            idx_v_name=find(strcmp(VariableNames,kk.tuning_param_name_y));
            Y=TONGUE{:,idx_v_name+var_table_offset-1};
            
            
            hist_bins_X=prctile(X,linspace(0,100,6)); %equally occupued bins
            hist_bins_Y=prctile(Y,linspace(0,100,6));
            
%             hist_bins_X=linspace(0,1,6);
%             hist_bins_Y=linspace(0,1,6);

            
            
            labels=VariableNames{idx_v_name};
            
            t_wnd{1}=[-0.2, 0];
            t_wnd{2}=[0, 0.2];
            for i_twnd=1:numel(t_wnd)
                
                
                [kk.tongue_tuning_2d, kk.hist_bins_centers_x, kk.hist_bins_centers_y, kk.number_of_spikes_window, kk.tongue_tuning_2d_peak_fr, kk.tongue_tuning_2d_min_fr, kk.tongue_tuning_2d_peak_fr_bin, kk.tongue_tuning_2d_si] = fn_tongue_tuning2D(X,Y, SPIKES, t_wnd{i_twnd}, [], min_trials_2D_bin, [],hist_bins_X, hist_bins_Y ,smooth_flag, plot_flag);
                kk.time_window_start=t_wnd{i_twnd}(1);
                kk.time_window_end=t_wnd{i_twnd}(2);
              
                
                % computing stability between odd vs even trials
                odd_trials=1:2:number_of_trials;
                [kk.tongue_tuning_2d_odd]= ...
                    fn_tongue_tuning2D(X(odd_trials),Y(odd_trials), SPIKES, t_wnd{i_twnd}, [], min_trials_2D_bin, [],hist_bins_X, hist_bins_Y ,smooth_flag, plot_flag);
                
                even_trials=2:2:number_of_trials;
                [kk.tongue_tuning_2d_even]= ...
                    fn_tongue_tuning2D(X(even_trials),Y(even_trials), SPIKES, t_wnd{i_twnd}, [], min_trials_2D_bin, [],hist_bins_X, hist_bins_Y ,smooth_flag, plot_flag);
                
                r =corr([kk.tongue_tuning_2d_odd(:),kk.tongue_tuning_2d_even(:)],'type','Pearson','rows','pairwise');
                
                kk.stability_odd_even_corr_r=r(2);
                
                
                kk.outcome=key.outcome;
                insert(self,kk)
            end
            
            
            
        end
    end
    
end


