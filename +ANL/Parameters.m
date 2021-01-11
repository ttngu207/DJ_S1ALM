%{
#
parameter_name                     :  varchar(200)
---
parameter_value  = null            : blob
parameter_description= null        :  varchar(4000)
%}

classdef Parameters < dj.Lookup
     properties
        contents = { 
        
            't_go' 0 'time of the go cue, relative to go cue'
            't_chirp1' -3 ' time (seconds) of the first chirp (beginning of sample period), relative to go cue'
            't_chirp2' -2.15 'time (seconds) of the second chirp (end of sample period), relative to go cue'
            't_presample_stim' -3.8 'time (seconds) of the onset of the sample photostimulus, relative to go cue'
            't_sample_stim' -2.5 'time (seconds) of the onset of the presample photostimulus, relative to go cue'
            't_earlydelay_stim' -1.6 'time (seconds) of the onset of the early-delay photostimulus, relative to go cue'
            't_latedelay_stim' -0.8 'time (seconds) of the onset of the late-delay photostimulus, relative to go cue'

            'mintrials_behav_typeoutcome' 5 'Minimal number of trials for a given trial-type/outcome combination (e.g. trial-type left_-0.8Full and outcome hit), to include it the behavior analysis for this session'
            'mintrials_unit' 10 'Minimal number of hit trials with no early licks in basic trial-type (i.e. left/right without distractors)'
            'mintrials_psth_typeoutcome' 5 'Minimal number of trials for a given trial-type/outcome combination (e.g. trial-type left_-0.8Full and outcome hit), to include it in the psth of this unit'
            'mintrials_modeweights' 10 'Minimal number of hit trials with no early licks in each set(left/right) during behaving trials, to include this unit weight in the weights-vector for a mode in the activity space'
            'mintrials_heirarclusters' 10 'Minimal number of trials per condition during behaving trials, for analysis of the hierarchical clusters'

            'inclusion_behav_prcnt_hit' 50 'a session with performance below this on pure left/right trials will be defined as session with bad behavior. By default this threshold is applied to  ANL.SessionBehavPerformance.prcnt_hit_outof_noignore'
            'inclusion_behav_prcnt_early' 50 'a session with early-licks above this on pure left/right trials will be defined as session with bad behavior. By default this threshold is applied to  ANL.SessionBehavPerformance.prcnt_early.'
            
             'minimal_mean_fr' 0.5 'Minimal mean firing rate (Hz) of all trials/conditions combined during the entire trial'

            'min_num_trials_projected_correct'  5 'Minimal number of trials in projection, in correct trials'
            'min_num_trials_projected_error_or_ignore'  5 'Minimal number of trials, in error/ignore trials'
            'min_num_trials_projected_response' 10 'Minimal number of trials, in correct and error trials combined (response trials)'
            'min_num_units_projected'  5 'Minimal number of units in projection'

            'psth_time_bin' 0.005 'time bin (second) used to compute PSTH, projections, etc'
            'psth_t_vector' [-6.4975:0.005:4] 'time vector (seconds) of bin centers used to compute the PSTH and the projection on modes, aligned to the go cue time'
            
            'smooth_time_cell_psth' 0.05 'smoothing time window (seconds)'
            'smooth_time_cell_psth_stimulus' 0.05 'smoothing time window (seconds)'
            'smooth_time_cell_psth_for_clustering' 0.2 'smoothing time window (seconds) for hierarchical clustering'
            'smooth_time_cell_psth_choice' 0.2 'smoothing time window (seconds)'

            'smooth_time_proj' 0.1 'smoothing time window (seconds) for projections'
            'smooth_time_proj_stimulus' 0.1  'smoothing time window (seconds) for projections'

            'smooth_time_proj_stimulus_single_session' 0.1  'smoothing time window (seconds) for projections'
            'smooth_time_proj_choice_single_session' 0.1  'smoothing time window (seconds) for projections'

            
            'smooth_time_proj_choice' 0.1  'smoothing time window (seconds) for projections'
            
            'smooth_time_proj_choice_negative_weights' 0.1 'smoothing time window (seconds) for projections'
          
            'smooth_time_proj_choice_mini' 0.1  'smoothing time window (seconds) for projections'
            'smooth_time_proj_choice_kinetics' 0.1 	 'smoothing time window (seconds) for projections'
            
            'smooth_time_proj_single_trial_normalized' 0.2	 'smoothing time window (seconds) for projections'
            
            
            'trialfraction_for_modeweights' 1 'use only this fraction of the trial to compute modes'
            'shuffle_num_for_modeweights' 2 ''
            'mode_mat_sliding_wind' 0.1 'slinding window duration (in seconds) used to compute the Coding Direction along the trial time'

            'minimal_num_units_sessions' 5 'Minimal number of ok or good units per session, to include this session'
            'minimal_num_hit_trials_sessions'     50 'Minimal number of hit trials  per session, to include this session'
            
            'minimal_num_units_proj_trial' 10 'Minimal number of units, per projected trial to include it in video analysis'
            
            'tongue_tuning_min_trials_1D_bin' 3 ''
            'tongue_tuning_min_trials_2D_bin' 3 ''
            
            'tongue_tuning_number_of_shuffles' 1000 ''
            'camera_bottomview_pixels_to_mm'  4/83.07 'pixels to mm conversion factor'

            'smooth_time_for_ran' 0.1 ''

            
            'svm_decoder_time_window' 0.2 'time window (seconds)'
            'svm_decoder_fraction_trials_for_unit_stability' 0.25 'If the cell was not active for more than xxx fraction of trials we consider it unstable'
            'svm_decoder_minimal_number_stable_units' 5 ''
            
            'smooth_time_proj2D' 0.2 'smoothing time window (seconds) for projections'

            
            'p_value_threshold_selectivity' 0.001 'pvalue for threshold selectivity during sample or delay'

            %% 2019/10/09 
%             't_go' 0 'time of the go cue, relative to go cue'
%             't_chirp1' -3 ' time (seconds) of the first chirp (beginning of sample period), relative to go cue'
%             't_chirp2' -2.15 'time (seconds) of the second chirp (end of sample period), relative to go cue'
%             't_presample_stim' -3.8 'time (seconds) of the onset of the sample photostimulus, relative to go cue'
%             't_sample_stim' -2.5 'time (seconds) of the onset of the presample photostimulus, relative to go cue'
%             't_earlydelay_stim' -1.6 'time (seconds) of the onset of the early-delay photostimulus, relative to go cue'
%             't_latedelay_stim' -0.8 'time (seconds) of the onset of the late-delay photostimulus, relative to go cue'
% 
%             'mintrials_behav_typeoutcome' 5 'Minimal number of trials for a given trial-type/outcome combination (e.g. trial-type left_-0.8Full and outcome hit), to include it the behavior analysis for this session'
%             'mintrials_unit' 5 'Minimal number of hit trials with no early licks in basic trial-type (i.e. left/right without distractors)'
%             'mintrials_psth_typeoutcome' 5 'Minimal number of trials for a given trial-type/outcome combination (e.g. trial-type left_-0.8Full and outcome hit), to include it in the psth of this unit'
%             'mintrials_modeweights' 5 'Minimal number of hit trials with no early licks in each set(left/right) during behaving trials, to include this unit weight in the weights-vector for a mode in the activity space'
%             'mintrials_heirarclusters' 5 'Minimal number of trials per condition during behaving trials, for analysis of the hierarchical clusters'
% 
%             'inclusion_behav_prcnt_hit' 50 'a session with performance below this on pure left/right trials will be defined as session with bad behavior. By default this threshold is applied to  ANL.SessionBehavPerformance.prcnt_hit_outof_noignore'
%             'inclusion_behav_prcnt_early' 50 'a session with early-licks above this on pure left/right trials will be defined as session with bad behavior. By default this threshold is applied to  ANL.SessionBehavPerformance.prcnt_early.'
%             
%             'minimal_mean_fr_sample' 0.5 'Minimal mean firing rate (Hz) of all trials/conditions combined during sample'
%             'minimal_mean_fr_delay' 0.5 'Minimal mean firing rate (Hz) of all trials/conditions combined during period'
%             'minimal_mean_fr_response' 0.5 'Minimal mean firing rate (Hz) of all trials/conditions combined during response'
%             'minimal_adaptive_peak_fr_basic_trials' 2 'Minimal peak firing rate (Hz) of hit basic trials at any time during the trial'
%               
%             'min_num_trials_projected_correct'  5 'Minimal number of trials in projection, in correct trials'
%             'min_num_trials_projected_error_or_ignore'  5 'Minimal number of trials, in error/ignore trials'
%             'min_num_trials_projected_response' 10 'Minimal number of trials, in correct and error trials combined (response trials)'
%             'min_num_units_projected'  5 'Minimal number of units in projection'
% 
%             'psth_time_bin' 0.005 'time bin (second) used to compute PSTH, projections, etc'
%             'psth_t_vector' [-6.4975:0.005:4] 'time vector (seconds) of bin centers used to compute the PSTH and the projection on modes, aligned to the go cue time'
%             'smooth_time_cell_psth' 0.1 'smoothing time window (seconds)'
%             'smooth_time_cell_psth_stimulus' 0.1 'smoothing time window (seconds)'
%             'smooth_time_cell_psth_for_clustering' 0.2 'smoothing time window (seconds) for hierarchical clustering'
%             'smooth_time_proj' 0.1 'smoothing time window (seconds) for projections'
%             'smooth_time_proj2D' 0.2 'smoothing time window (seconds) for projections'
% 
%             'smooth_time_cell_psth_choice' 0.2 'smoothing time window (seconds)'
%             'smooth_time_proj_choice' 0.1 'smoothing time window (seconds) for projections'
%             'smooth_time_proj_choice_mini' 0.1 'smoothing time window (seconds) for projections'
%             'smooth_time_proj_choice_mini_kinetics' 0.1	 'smoothing time window (seconds) for projections'
% 
%             'trialfraction_for_modeweights' 1 'use only this fraction of the trial to compute modes'
%             'shuffle_num_for_modeweights' 2 ''
%             'mode_mat_sliding_wind' 0.1 'slinding window duration (in seconds) used to compute the Coding Direction along the trial time'
% 
%             'minimal_num_units_sessions' 5 'Minimal number of ok or good units per session, to include this session'
%             'minimal_num_hit_trials_sessions'     50 'Minimal number of hit trials  per session, to include this session'
%             
%             'minimal_num_units_proj_trial' 10 'Minimal number of units, per projected trial to include it in video analysis'
%             
%             'tongue_tuning_min_trials_1D_bin' 3 ''
%             'tongue_tuning_min_trials_2D_bin' 3 ''
%             
%             'tongue_tuning_number_of_shuffles' 1000 ''
%             'camera_bottomview_pixels_to_mm'  4/83.07 'pixels to mm conversion factor'
% 
%             'smooth_time_for_ran' 0.1 ''

            
            
            
            
            
            
% %             't_go' 0 'time of the go cue, relative to go cue'
% %             't_chirp1' -3 ' time (seconds) of the first chirp (beginning of sample period), relative to go cue'
% %             't_chirp2' -2.15 'time (seconds) of the second chirp (end of sample period), relative to go cue'
% %             't_presample_stim' -3.8 'time (seconds) of the onset of the sample photostimulus, relative to go cue'
% %             't_sample_stim' -2.5 'time (seconds) of the onset of the presample photostimulus, relative to go cue'
% %             't_earlydelay_stim' -1.6 'time (seconds) of the onset of the early-delay photostimulus, relative to go cue'
% %             't_latedelay_stim' -0.8 'time (seconds) of the onset of the late-delay photostimulus, relative to go cue'
% % 
% %             'mintrials_behav_typeoutcome' 5 'Minimal number of trials for a given trial-type/outcome combination (e.g. trial-type left_-0.8Full and outcome hit), to include it the behavior analysis for this session'
% %             'mintrials_unit' 5 'Minimal number of hit trials with no early licks in basic trial-type (i.e. left/right without distractors)'
% %             'mintrials_psth_typeoutcome' 5 'Minimal number of trials for a given trial-type/outcome combination (e.g. trial-type left_-0.8Full and outcome hit), to include it in the psth of this unit'
% %             'mintrials_modeweights' 5 'Minimal number of hit trials with no early licks in each set(left/right) during behaving trials, to include this unit weight in the weights-vector for a mode in the activity space'
% %             'mintrials_heirarclusters' 5 'Minimal number of trials per condition during behaving trials, for analysis of the hierarchical clusters'
% % 
% %             'inclusion_behav_prcnt_hit' 50 'a session with performance below this on pure left/right trials will be defined as session with bad behavior. By default this threshold is applied to  ANL.SessionBehavPerformance.prcnt_hit_outof_noignore'
% %             'inclusion_behav_prcnt_early' 50 'a session with early-licks above this on pure left/right trials will be defined as session with bad behavior. By default this threshold is applied to  ANL.SessionBehavPerformance.prcnt_early.'
% %             
% %             'minimal_mean_fr_sample' 0.5 'Minimal mean firing rate (Hz) of all trials/conditions combined during sample'
% %             'minimal_mean_fr_delay' 0.5 'Minimal mean firing rate (Hz) of all trials/conditions combined during period'
% %             'minimal_mean_fr_response' 0.5 'Minimal mean firing rate (Hz) of all trials/conditions combined during response'
% %             'minimal_adaptive_peak_fr_basic_trials' 2 'Minimal peak firing rate (Hz) of hit basic trials at any time during the trial'
% %               
% %             'min_num_trials_projected_correct'  10 'Minimal number of trials in projection, in correct trials'
% %             'min_num_trials_projected_error_or_ignore'  10 'Minimal number of trials, in error/ignore trials'
% %             'min_num_units_projected'  20 'Minimal number of units in projection'
% % 
% %             'psth_time_bin' 0.005 'time bin (second) used to compute PSTH, projections, etc'
% %             'psth_t_vector' [-6.4975:0.005:4] 'time vector (seconds) of bin centers used to compute the PSTH and the projection on modes, aligned to the go cue time'
% %             'smooth_time_cell_psth' 0.1 'smoothing time window (seconds)'
% %             'smooth_time_cell_psth_stimulus' 0.1 'smoothing time window (seconds)'
% %             'smooth_time_cell_psth_for_clustering' 0.2 'smoothing time window (seconds) for hierarchical clustering'
% %             'smooth_time_proj' 0.1 'smoothing time window (seconds) for projections'
% %             'smooth_time_proj2D' 0.2 'smoothing time window (seconds) for projections'
% % 
% %             'trialfraction_for_modeweights' 1 'use only this fraction of the trial to compute modes'
% %             'shuffle_num_for_modeweights' 2 ''
% %             'mode_mat_sliding_wind' 0.1 'slinding window duration (in seconds) used to compute the Coding Direction along the trial time'
% % 
% %             'minimal_num_units_sessions' 25 'Minimal number of ok or good units per session, to include this session'
% %             'minimal_num_hit_trials_sessions'     200 'Minimal number of hit trials  per session, to include this session'
% %             
% %             'minimal_num_units_proj_trial' 20 'Minimal number of units, per projected trial to include it in video analysis'
% %             
% %             'tongue_tuning_min_trials_1D_bin' 3 ''
% %             'tongue_tuning_min_trials_2D_bin' 3 ''
% %             
% %             'tongue_tuning_number_of_shuffles' 1000 ''
% %             'camera_bottomview_pixels_to_mm'  4/83.07 'pixels to mm conversion factor'
            
            
            }
    end
end


