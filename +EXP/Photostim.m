%{
# 
-> EXP.PhotostimDevice
photo_stim                  : smallint                      # 
---
-> LAB.Hemisphere            
-> LAB.BrainArea            
-> LAB.SkullReference
photostim_ml_location= null            : decimal(8,3)       # um from ref ; right is positive; 
photostim_ap_location= null            : decimal(8,3)       # um from ref; anterior is positive; 
photostim_dv_location= null            : decimal(8,3)       # um from dura; ventral is positive; 
photostim_ml_angle = null              : decimal(8,3)       # Angle between the photostim path and the Medio-Lateral axis. A tilt towards the right hemishpere is positive. 
photostim_ap_angle = null              : decimal(8,3)       # Angle between the photostim path and the Anterior-Posterior axis. An anterior tilt is positive. 
duration                               : decimal(8,4)       # (s)
waveform                               : longblob           # normalized to maximal power. The value of the maximal power is specified for each PhotostimTrialEvent individually

%}


classdef Photostim < dj.Manual
end