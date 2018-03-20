%{
# Projection of the neural acitivity on a mode (neuron weights vector)
-> EXP.Session
-> LAB.Hemisphere
-> LAB.BrainArea
-> EPHYS.CellType
-> EPHYS.UnitQualityType
-> EXP.Outcome
-> ANL.ModeTypeName
-> EXP.TrialNameType

---
num_trials_projected        : int            # number of projected trials in this trial-type/outcome
proj_average                : longblob       # projection of the neural acitivity on the mode (weights vector) for this trial-type/outcome, given in arbitrary units. The time vector is psth_t_vector that could be found in ANL.Parameters

%}


classdef ProjTrialAverage < dj.Computed
    properties
        keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr" or cell_type="FS" or cell_type="all"') * (EPHYS.UnitQualityType & 'unit_quality="all" or unit_quality="good" or unit_quality="ok or good"') * EXP.Outcome;
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
                Modes = fetch ((ANL.Mode * EXP.SessionID * EPHYS.Unit  * EPHYS.UnitCellType) & ANL.IncludeUnit & k & 'unit_quality="ok" or unit_quality="good"', '*');
                PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition * ANL.PSTHAverage) & ANL.IncludeUnit & k & 'unit_quality="ok" or unit_quality="good"', '*');
            else
                if contains(k.unit_quality,'all')
                    k = rmfield(k,'unit_quality');
                end
                Modes = fetch ((ANL.Mode * EXP.SessionID * EPHYS.Unit  * EPHYS.UnitCellType) & ANL.IncludeUnit & k, '*');
                PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition * ANL.PSTHAverage) & ANL.IncludeUnit & k, '*');
            end

            if numel(unique([PSTH.unit]))>1 %i.e. there are more than one cell
                if ~isempty(PSTH)
                    PSTH = struct2table(PSTH);
                    mode_names = unique({Modes.mode_type_name})';
                    counter=1;
                    for imod = 1:1:numel(mode_names)
                        M = Modes(strcmp(mode_names{imod},{Modes.mode_type_name}'));
                        [key, counter] = fn_projectTrialAvg_populate(M, PSTH, key, counter);
                    end
                    insert(self,key);
                end
            end
        end
    end
end