%{
 # 
-> EPHYS.ElectrodeGroup
---
labeling_date                : date                          # in case we labeled the track not during a recorded session
dye_color  : varchar(32)

%}


classdef LabeledTrack < dj.Manual
end