%{
#
-> EPHYS.Unit
---
-> EPHYS.CellType
%}


classdef UnitCellType < dj.Computed
    methods(Access=protected)
        
        function makeTuples(self, key)
            
            spk_width_ms = fetchn(EPHYS.UnitWaveform & key , 'spk_width_ms');
            
            if isempty(fetchn(MISC.UnitWaveformComment & key , 'unit_waveform_comment'))
                if spk_width_ms >=0.6
                    key.cell_type = 'Pyr';
                elseif spk_width_ms < 0.45
                    key.cell_type = 'FS';
                else
                    key.cell_type = 'not classified';
                end
                
            else
                if spk_width_ms >=0.59
                    key.cell_type = 'Pyr';
                elseif spk_width_ms < 0.4
                    key.cell_type = 'FS';
                else
                    key.cell_type = 'not classified';
                end
            end
            insert(self,key);
        end
    end
end
