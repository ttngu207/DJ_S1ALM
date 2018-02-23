%{
-> EXP.Photostim
---                         
intensity_timecourse   :  longblob  # (mW/mm^2)

%}


classdef PhotostimProfile < dj.Part
   properties(SetAccess=protected)
        master= EXP.Photostim
    end
end