%{
# Trials are scaled to min-max during sample-delay
-> EXP.Session
-> EPHYS.CellType
-> EPHYS.UnitQualityType
-> ANL.ModeWeightsSign
-> EXP.SessionTrial
-> LAB.Hemisphere
-> LAB.BrainArea
-> ANL.ModeTypeName
---
num_units_projected       : int          # number of units projected in this trial
proj_trial                : longblob       # projection of the neural acitivity on the mode (weights vector) for this trial, given in arbitrary units. The time vector is psth_t_vector that could be found in ANL.Parameters
flag_outlier              : int          # indicates oultier
%}


classdef ProjTrialNormalized444 < dj.Computed
    properties
        
%         keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr" or cell_type="FS" or cell_type="all"') * (EPHYS.UnitQualityType & 'unit_quality="all" or unit_quality="good" or unit_quality="ok or good"') * EXP.Outcome * (ANL.ModeWeightsSign);
                    keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr"') * (EPHYS.UnitQualityType & 'unit_quality="all"')   * (ANL.ModeWeightsSign & 'mode_weights_sign="all"') *  (ANL.ModeTypeName & 'mode_type_name="Ramping Orthog.1" or mode_type_name="LateDelay"')
%                             keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr" or cell_type="FS" or cell_type="all"') * (EPHYS.UnitQualityType & 'unit_quality="all" or unit_quality="ok or good"') * EXP.Outcome * (ANL.ModeWeightsSign);

    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            k=key;
            Modes = fetch (ANL.Mode555  & k, '*');
            
            if contains(k.cell_type,'all')
                k = rmfield(k,'cell_type');
            end
            
            if contains(k.unit_quality,'ok or good')
                k = rmfield(k,'unit_quality');
                PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition * ANL.PSTHTrial * EXP.BehaviorTrial) & ANL.IncludeUnit2 & k & 'outcome="hit" or outcome="miss"' & 'unit_quality="ok" or unit_quality="good"' & 'early_lick="no early"', '*');
            else
                if contains(k.unit_quality,'all')
                    k = rmfield(k,'unit_quality');
                end
                PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition * ANL.PSTHTrial * EXP.BehaviorTrial) & ANL.IncludeUnit2 & k & 'outcome="hit" or outcome="miss"' & 'early_lick="no early"', '*');
            end
            Param = struct2table(fetch (ANL.Parameters,'*'));
            
            if numel(unique([PSTH.unit]))>1 %i.e. there are more than one cell
                if ~isempty(PSTH)
                    PSTH = struct2table(PSTH);
                    mode_names = unique({Modes.mode_type_name})';
                    counter=1;
                    for imod = 1:1:numel(mode_names)
                        M = Modes(strcmp(mode_names{imod},{Modes.mode_type_name}'));
                        [key, counter] = fn_projectSingleTrial_populateNormalized_median_left_right(M, PSTH, key, counter,Param);
                    end
                    insert(self,key);
                end
            end
        end
    end
end