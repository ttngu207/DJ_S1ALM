%{
# 
-> EXP.PhotostimDevice
photo_stim                  : smallint                      # 
---
duration                               : decimal(8,4)       # (s)
waveform                               : longblob           # normalized to maximal power. The value of the maximal power is specified for each PhotostimTrialEvent individually
%}


classdef Photostim < dj.Imported
     methods(Access=protected)
        function makeTuples(self, key)
        end
    end
end