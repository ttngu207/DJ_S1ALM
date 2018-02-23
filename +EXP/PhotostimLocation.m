%{
# 
-> EXP.Photostim
---
-> LAB.Hemisphere            
-> LAB.BrainArea            
-> LAB.SkullReference
photostim_ml_location= null            : decimal(8,3)       # um from ref ; right is positive; 
photostim_ap_location= null            : decimal(8,3)       # um from ref; anterior is positive; 
photostim_dv_location= null            : decimal(8,3)       # um from dura; ventral is positive; 
photostim_ml_angle = null              : decimal(8,3)       # Angle between the photostim path and the Medio-Lateral axis. A tilt towards the right hemishpere is positive. 
photostim_ap_angle = null              : decimal(8,3)       # Angle between the photostim path and the Anterior-Posterior axis. An anterior tilt is positive. 
%}


classdef PhotostimLocation < dj.Manual
end