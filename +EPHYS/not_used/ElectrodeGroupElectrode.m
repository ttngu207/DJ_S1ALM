%{
#
-> EPHYS.ElectrodeGroup
electrode   : smallint    # sites on the electrode
%}


classdef ElectrodeGroupElectrode < dj.Part
    properties(SetAccess=protected)
        master= EPHYS.ElectrodeGroup
    end
end
