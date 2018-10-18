%{
#
-> EPHYS.Unit
-> ANL.TongueTuning1DType
-> ANL.OutcomeType
-> ANL.TongueTuningSmoothFlag
-> ANL.FlagBasicTrials
-> ANL.LickDirectionType
time_window_start                               : decimal(8,4)              #
time_window_duration                            : decimal(8,4)              #
---
number_of_trials                                : int
mean_fr_window                                  : decimal(8,4)              #  mean fr at this time window
total_number_of_spikes_window                   : int                       # sum over trials inn this time window
tongue_tuning_1d_peak_fr=null                   : decimal(8,4)              #
tongue_tuning_1d_min_fr=null                    : decimal(8,4)              #
tongue_tuning_1d_peak_fr_bin=null               : decimal(8,4)              #
tongue_tuning_1d_si=null                        : decimal(8,4)              # spatial information
tongue_tuning_1d                                : blob                      #
tongue_tuning_1d_odd                            : blob                      #
tongue_tuning_1d_even                           : blob                      #
hist_bins_centers                               : blob                      #
hist_bins                                       : blob                      #
stability_odd_even_corr_r=null                  : decimal(8,4)              # Pearson correlation r, between tuning curves computed using odd vs even trials
%}

classdef UnitTongue1DTuning < dj.Computed
    properties
        keySource = ((EPHYS.Unit & 'unit_quality!="multi"' & (EPHYS.UnitCellType & 'cell_type="PYR" or cell_type="FS"')) & ANL.Video1stLickTrial) *  (ANL.TongueTuningSmoothFlag & 'smooth_flag=0') * (ANL.OutcomeType & 'outcome_grouping="all"') * (ANL.FlagBasicTrials & 'flag_use_basic_trials=0')  * (ANL.TongueTuning1DType & 'tuning_param_name="lick_horizoffset" or tuning_param_name="lick_rt_video_onset" or tuning_param_name="lick_peak_x"') *ANL.LickDirectionType;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            % params
            Param = struct2table(fetch (ANL.Parameters,'*'));
            min_trials_1D_bin = Param.parameter_value{(strcmp('tongue_tuning_min_trials_1D_bin',Param.parameter_name))};

            plot_flag=0;
            
            t_vec=-3.5:0.1:2;
            time_window_duration=0.2;
            
            smooth_flag=key.smooth_flag;
            smooth_bins=3;
            
            % fetching spikes and video
            
            kk=key;
            
            if strcmp(key.outcome_grouping,'all')
                kk=rmfield(kk,'outcome_grouping');
            end
                        
            key_lick_direction=EXP.TrialID & (ANL.LickDirectionTrial & key) & ANL.VideoTongueValidRTTrial;

            if kk.flag_use_basic_trials==1
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial *   (EXP.TrialName & (ANL.TrialTypeGraphic & 'trialtype_left_and_right_no_distractors=1')) & ANL.Video1stLickTrial & kk  &  'early_lick="no early"');
            else
                rel_spikes=(ANL.TrialSpikesGoAligned*EPHYS.Unit*EXP.SessionTraining*EPHYS.UnitPosition*EPHYS.UnitCellType*EXP.BehaviorTrial & ANL.Video1stLickTrial & kk  &  'early_lick="no early"');
            end
            
            SPIKES=fetch(rel_spikes & key_lick_direction,'*','ORDER BY trial');
            
            if isempty(SPIKES)
                return
            end
            
            rel_video=(ANL.Video1stLickTrial & kk & rel_spikes ) & key_lick_direction;
            if rel_video.count<10
                return
            end
            TONGUE=struct2table(fetch(rel_video,'*','ORDER BY trial'));
            
            
            % extracting param variable
            VariableNames=TONGUE.Properties.VariableNames';
            idx_v_name=find(strcmp(VariableNames,kk.tuning_param_name));
            labels=VariableNames{idx_v_name};

            X=TONGUE{:,idx_v_name};
            
            kk.outcome_grouping=key.outcome_grouping;
            kk.time_window_duration=time_window_duration;

            %remove video outliers
            idx_outlier=isoutlier(X);
            X(idx_outlier)=[];
            SPIKES(idx_outlier)=[];

            number_of_trials=numel(X);
            kk.number_of_trials=number_of_trials;
            
            hist_bins=prctile(X,linspace(0,100,5)); %equally occupied bins
            kk.hist_bins=hist_bins;
            
            % computing tuning for various time windows
            for it=1:1:numel(t_vec)
                t_wnd{it}=[t_vec(it), t_vec(it)+time_window_duration];
            end
            
            for i_twnd=1:numel(t_wnd)
                
                %% computing tuning curve and SI
                [kk.tongue_tuning_1d, kk.hist_bins_centers, kk.total_number_of_spikes_window, kk.tongue_tuning_1d_peak_fr, kk.tongue_tuning_1d_min_fr, kk.tongue_tuning_1d_peak_fr_bin, kk.tongue_tuning_1d_si, ~]= ...
                    fn_tongue_tuning1D (X, SPIKES, t_wnd{i_twnd}, hist_bins, min_trials_1D_bin, smooth_bins, labels,smooth_flag, plot_flag);
                kk.time_window_start=t_wnd{i_twnd}(1);
                
                kk.mean_fr_window=kk.total_number_of_spikes_window/diff(t_wnd{i_twnd})/numel(SPIKES);
                
                % computing stability between odd vs even trials
                odd_trials=1:2:number_of_trials;
                [kk.tongue_tuning_1d_odd]= ...
                    fn_tongue_tuning1D (X(odd_trials), SPIKES(odd_trials), t_wnd{i_twnd}, hist_bins, min_trials_1D_bin, smooth_bins, labels,smooth_flag, plot_flag);
                
                even_trials=2:2:number_of_trials;
                [kk.tongue_tuning_1d_even]= ...
                    fn_tongue_tuning1D (X(even_trials), SPIKES(even_trials), t_wnd{i_twnd}, hist_bins, min_trials_1D_bin, smooth_bins, labels,smooth_flag, plot_flag);
                
                r =corr([kk.tongue_tuning_1d_odd',kk.tongue_tuning_1d_even'],'type','Pearson','rows','pairwise');
                kk.stability_odd_even_corr_r=r(2);
                insert(self,kk)
            end
            
            
            
        end
    end
    
end


