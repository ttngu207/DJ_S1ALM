%{
# Electrode
-> EXP.Session
electrode_group : tinyint           # shank number
---
-> EPHYS.Probe
%}


classdef ElectrodeGroup < dj.Manual
end