%{
# Estimated unit position in the brain
-> EPHYS.Unit
---
waveform                    : blob      # unit average waveform. time in samples, amplitude in microvolts.
spk_width_ms                : float     # unit average spike width, in ms
sampling_fq                 : float     # Hz
waveform_amplitude          : float     # unit amplitude (peak) in microvolts
%}


classdef UnitWaveform < dj.Part
    properties(SetAccess=protected)
        master= EPHYS.Unit
    end
    methods
        function makeTuples(self, key)
            self.insert(key)
        end
    end
end

