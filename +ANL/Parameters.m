%{
#
parameter_name           :  varchar(200)
---
parameter_value  = null  : blob
description= null        :  varchar(4000)
%}

classdef Parameters < dj.Lookup
     properties
        contents = {
            'inclusion_behav_mintrials' 5 'Minimal trial per condition in a given behavior session, for this condition to be included in the behavior analysis for this session'
            'inclusion_behav_prcnt_hit' 50 'a session with performance below this on pure left/right trials will be defined as session with bad behavior. By default this threshold is applied to  ANL.SessionBehavPerformance.prcnt_hit_outof_noignore.'
            'inclusion_behav_prcnt_early' 50 'a session with early-licks above this on pure left/right trials will be defined as session with bad behavior. By default this threshold is applied to  ANL.SessionBehavPerformance.prcnt_early.'
            'psth_time_bin' 0.001 'time bin (second) used to compute PSTH, projections, etc'
            }
    end
end


