%{
# Sorted unit
-> EPHYS.ElectrodeGroup
unit  : smallint
---
unit_id   : int    # unique across sessions/animals
unit_quality    = null      : smallint                      # unit quality; 2 - single unit; 1 - probably single unit; 0 - multiunit
waveform : blob    # unit average waveform, each point corresponds to a sample. (what are the amplitude units?)  To convert into time use the sampling_frequency.
unit_channel    = null      : float                      # channel on the probe for each the unit has the largest amplitude (verify that its based on amplitude or other feature)

%}


classdef Unit < dj.Imported
    
    methods(Access=protected)
        function makeTuples(self, key)
        end
    end
end

