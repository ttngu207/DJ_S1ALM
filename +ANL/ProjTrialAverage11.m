%{
# Projection of the neural acitivity on a mode (neuron weights vector)
-> EXP.Session
-> EPHYS.CellType
-> EPHYS.UnitQualityType
-> ANL.ModeTypeName
-> ANL.ModeWeightsSign
-> EXP.Outcome
-> LAB.Hemisphere
-> LAB.BrainArea
-> EXP.TrialNameType
---
num_trials_projected        : int            # number of projected trials in this trial-type/outcome
num_units_projected         : int            # number of units projected in this trial-type/outcome

proj_average                : longblob       # projection of the neural acitivity on the mode (weights vector) for this trial-type/outcome, given in arbitrary units. The time vector is psth_t_vector that could be found in ANL.Parameters

%}


classdef ProjTrialAverage11 < dj.Computed
    properties
        %         keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr" or cell_type="FS" or cell_type="all"') * (EPHYS.UnitQualityType & 'unit_quality="all" or unit_quality="good" or unit_quality="ok or good"') * EXP.Outcome * ANL.ModeWeightsSign;
%         keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr"') * (EPHYS.UnitQualityType & 'unit_quality="all" or unit_quality="ok or good"') * EXP.Outcome * (ANL.ModeWeightsSign) * ANL.ModeTypeName;
                keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr"') * (EPHYS.UnitQualityType & 'unit_quality="all" or unit_quality="ok or good"') * EXP.Outcome * (ANL.ModeWeightsSign) * (ANL.ModeTypeName & ANL.Mode11 );

    end
    methods(Access=protected)
        function makeTuples(self, key)
            key.task = fetch1(EXP.SessionTask & key,'task');
            k=key;
            if contains(k.cell_type,'all')
                k = rmfield(k,'cell_type');
            end
            
            if contains(k.unit_quality,'ok or good')
                k = rmfield(k,'unit_quality');
                Modes = fetch ( (ANL.Mode11 * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition)  & ANL.IncludeUnit2 & k & 'unit_quality="ok" or unit_quality="good"', '*');
                PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition * ANL.PSTHAverage) & ANL.IncludeUnit2 & k & 'unit_quality="ok" or unit_quality="good"', '*');
            else
                if contains(k.unit_quality,'all')
                    k = rmfield(k,'unit_quality');
                end
                Modes = fetch (ANL.Mode11*EPHYS.UnitCellType * EPHYS.UnitPosition & ANL.IncludeUnit2 & k, '*');
                PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition * ANL.PSTHAverage) & ANL.IncludeUnit2 & k, '*');
            end
            
            Param = struct2table(fetch (ANL.Parameters,'*'));
            
            if numel(unique([PSTH.unit]))>1 %i.e. there are more than one cell
                if ~isempty(PSTH)
                    PSTH = struct2table(PSTH);
                    mode_names = unique({Modes.mode_type_name})';
                    counter=1;
                    
%                     %debug
%                     if sum(unique(PSTH.unit) ~= unique([Modes.unit])')
%                         a=1
%                     end
                    
                    for imod = 1:1:numel(mode_names)
                        M = Modes(strcmp(mode_names{imod},{Modes.mode_type_name}'));
                        [key, counter] = fn_projectTrialAvg_populate(M, PSTH, key, counter,Param);
                    end
                    insert(self,key);
                end
            end
        end
    end
end