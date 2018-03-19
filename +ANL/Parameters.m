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
            'inclusion_behav_mintrials' 5 'Minimal trial per condition in a given behavior session, for this condition to be included in the behavior analysis for this session'
            'inclusion_behav_prcnt_hit' 50 'a session with performance below this on pure left/right trials will be defined as session with bad behavior. By default this threshold is applied to  ANL.SessionBehavPerformance.prcnt_hit_outof_noignore.'
            'inclusion_behav_prcnt_early' 50 'a session with early-licks above this on pure left/right trials will be defined as session with bad behavior. By default this threshold is applied to  ANL.SessionBehavPerformance.prcnt_early.'
            'psth_time_bin' 0.005 'time bin (second) used to compute PSTH, projections, etc'
            'psth_t_vector' [-6.4975:0.005:4] 'time vector (seconds) of bin centers used to compute the PSTH, aligned to the go cue time'
            'mintrials_for_modeweights' 10 'uses only units that have more than this number of trials in each set (e.g. left/right), to determine weights-vector for a mode in the activity space'
            'trialfraction_for_modeweights' 0.5 'use only this fraction of the trial to compute modes'
            'shuffle_num_for_modeweights' 100 ''
            'mode_mat_sliding_wind' 0.1 'slinding window duration (in seconds) used to compute the Coding Direction along the trial time'
            't_go' 0 'time of the go cue, relative to go cue'
            't_chirp1' -3 ' time (seconds) of the first chirp (beginning of sample period), relative to go cue'
            't_chirp2' -2.15 'time (seconds) of the second chirp (end of sample period), relative to go cue'
            't_presample_stim' -3.8 'time (seconds) of the onset of the sample photostimulus, relative to go cue'
            't_sample_stim' -2.5 'time (seconds) of the onset of the presample photostimulus, relative to go cue'
            't_earlydelay_stim' -1.6 'time (seconds) of the onset of the early-delay photostimulus, relative to go cue'
            't_latedelay_stim' -0.8 'time (seconds) of the onset of the late-delay photostimulus, relative to go cue'
            'smooth_time_cell_psth' 0.2 'smoothing time window (seconds)'
            'mintrials_for_psth' 5 'uses only units that have more than this number of trials in each-trial type/condition'

            }
    end
end

