%{
#
-> EPHYS.Unit
---
-> EPHYS.CellType
%}


classdef UnitCellType < dj.Imported
    methods(Access=protected)
        
        function makeTuples(self, key)
            
            spk_width_ms = fetchn(EPHYS.Unit & key , 'spk_width_ms');
            
            if isempty(fetchn(MISC.UnitWaveformComment & key , 'unit_comment'))
                if spk_width_ms >=0.6
                    cell_type = 'Putative pyramidal';
                elseif spk_width_ms < 0.45
                    cell_type = 'FS';
                else
                    cell_type = 'not classified';
                end
                
            else
                if spk_width_ms >=0.59
                    cell_type = 'Putative pyramidal';
                elseif spk_width_ms < 0.4
                    cell_type = 'FS';
                else
                    cell_type = 'not classified';
                end
            end
            
        end
    end
end
