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
            'mintrials_unit' 10 'Minimal number of hit trials with no early licks in basic trial-type (i.e. left/right without distractors) during behaving trials'
            'mintrials_psth_typeoutcome' 5 'Minimal number of trials for a given trial-type/outcome combination (e.g. trial-type left_-0.8Full and outcome hit), to include it in the psth of this unit'
            'mintrials_modeweights' 10 'Minimal number of hit trials with no early licks in each set(left/right) during behaving trials, to include this unit weight in the weights-vector for a mode in the activity space'
            'mintrials_heirarclusters' 10 'Minimal number of trials per condition during behaving trials, for analysis of the hierarchical clusters'

            'inclusion_behav_prcnt_hit' 50 'a session with performance below this on pure left/right trials will be defined as session with bad behavior. By default this threshold is applied to  ANL.SessionBehavPerformance.prcnt_hit_outof_noignore'
            'inclusion_behav_prcnt_early' 50 'a session with early-licks above this on pure left/right trials will be defined as session with bad behavior. By default this threshold is applied to  ANL.SessionBehavPerformance.prcnt_early.'
            
            'minimal_mean_fr_sample_delay' 1 'Minimal mean firing rate (Hz) of all trials/conditions combined during sample and delay period'
            'minimal_mean_fr_response'     1 'Minimal mean firing rate (Hz) of all trials/conditions combined during response period'

                       
            'psth_time_bin' 0.005 'time bin (second) used to compute PSTH, projections, etc'
            'psth_t_vector' [-6.4975:0.005:4] 'time vector (seconds) of bin centers used to compute the PSTH and the projection on modes, aligned to the go cue time'
            'smooth_time_cell_psth' 0.4 'smoothing time window (seconds)'
            'smooth_time_cell_psth_for_clustering' 0.25 'smoothing time window (seconds) for hierarchical clustering'

            'trialfraction_for_modeweights' 0.5 'use only this fraction of the trial to compute modes'
            'shuffle_num_for_modeweights' 100 ''
            'mode_mat_sliding_wind' 0.1 'slinding window duration (in seconds) used to compute the Coding Direction along the trial time'

            
            }
    end
end


