%{
#
-> EXP.PhotostimTrial
-> EXP.Photostim
photostim_event_time        : decimal(8,3)                  # (s) from trial start
power                       : decimal(8,3)                  # Maximal power (mW)

%}


classdef PhotostimTrialEvent < dj.Part
    
    properties(SetAccess=protected)
        master= EXP.PhotostimTrial
    end
    
end