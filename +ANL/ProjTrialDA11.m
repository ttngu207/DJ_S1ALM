%{
# Projection of the neural acitivity on a mode (neuron weights vector)
-> EXP.Session
-> EPHYS.CellType
-> EPHYS.UnitQualityType
-> ANL.ModeWeightsSign
-> EXP.Outcome
-> ANL.ModeTypeName
-> EXP.TrialNameType
-> EXP.SessionTrial
-> LAB.Hemisphere
-> LAB.BrainArea

---
num_units_projected       : int          # number of units projected in this trial
proj_trial                : longblob       # projection of the neural acitivity on the mode (weights vector) for this trial, given in arbitrary units. The time vector is psth_t_vector that could be found in ANL.Parameters

%}


classdef ProjTrialDA11 < dj.Computed
    properties
        
%         keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr"') * (EPHYS.UnitQualityType & 'unit_quality="all"') * (EXP.Outcome & 'outcome="hit" or outcome="miss"') * (ANL.ModeTypeName & 'mode_type_name="Ramping Orthog.111" or mode_type_name="Stimulus Orthog.111" or mode_type_name="ChoiceMatched"') * (ANL.ModeWeightsSign & 'mode_weights_sign="all"');
        keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr"') * (EPHYS.UnitQualityType & 'unit_quality="all"') * (EXP.Outcome & 'outcome="hit" or outcome="miss"') * (ANL.ModeTypeName & ANL.Mode11) * (ANL.ModeWeightsSign & 'mode_weights_sign="all"');

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
                PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition *  ANL.PSTHDATrial * EXP.BehaviorTrial) & ANL.IncludeUnit2 & k & 'unit_quality="ok" or unit_quality="good"', '*');
            else
                if contains(k.unit_quality,'all')
                    k = rmfield(k,'unit_quality');
                end
                Modes = fetch (ANL.Mode11*EPHYS.UnitCellType * EPHYS.UnitPosition & ANL.IncludeUnit2 & k, '*');
                PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition *  ANL.PSTHDATrial * EXP.BehaviorTrial) & ANL.IncludeUnit2 & k, '*');
            end
            
            Param = struct2table(fetch (ANL.Parameters,'*'));
            
            if numel(unique([PSTH.unit]))>1 %i.e. there are more than one cell
                if ~isempty(PSTH)
                    PSTH = struct2table(PSTH);
                    mode_names = unique({Modes.mode_type_name})';
                    counter=1;
                    for imod = 1:1:numel(mode_names)
                        M = Modes(strcmp(mode_names{imod},{Modes.mode_type_name}'));
                        [key, counter] = fn_projectSingleTrial_populate(M, PSTH, key, counter,Param);
                    end
                    insert(self,key);
                end
            end
        end
    end
end