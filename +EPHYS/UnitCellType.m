%{
# 
-> EPHYS.Unit
-> EPHYS.CellType
%}


classdef UnitCellType < dj.Part
    properties(SetAccess=protected)
        master= EPHYS.Unit
    end
end
