%{
# Projection of the neural acitivity on a mode (neuron weights vector)
-> EXP.Session
-> EPHYS.CellType
-> EPHYS.UnitQualityType
-> ANL.ModeWeightsSign
-> ANL.TongueTuning1DType
-> ANL.OutcomeType
-> ANL.FlagBasicTrials
-> ANL.RegressionTime25
-> ANL.LickDirectionType
-> LAB.BrainArea
-> LAB.Hemisphere
-> EXP.SessionTrial
---
num_units_projected       : int          # number of units projected in this trial
proj_trial                : longblob       # projection of the neural acitivity on the mode (weights vector) for this trial, given in arbitrary units. The time vector is psth_t_vector that could be found in ANL.Parameters

%}


classdef RegressionProjTrialGo2 < dj.Computed
    properties
         keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr"') * (EPHYS.UnitQualityType & 'unit_quality="ok or good"') * (ANL.ModeWeightsSign & 'mode_weights_sign="all"') *  (ANL.TongueTuning1DType & 'tuning_param_name="lick_horizoffset" or tuning_param_name="lick_rt_video_onset" or tuning_param_name="lick_peak_x"')  * (ANL.OutcomeType & 'outcome_grouping="all"') *  (ANL.FlagBasicTrials & 'flag_use_basic_trials=0') * ANL.RegressionTime25 * (ANL.LickDirectionType)  &  ANL.Video1stLickTrialNormalized
    end
    methods(Access=protected)
        function makeTuples(self, key)
            k=key;
            rel=ANL.RegressionTongueSingleUnitGo2  & k;
            if rel.count==0
                return
            end
            Modes = fetch (rel, '*', 'ORDER BY unit');
            
            if contains(k.outcome_grouping,'all')
                k = rmfield(k,'outcome_grouping');
            end
            
            if contains(k.cell_type,'all')
                k = rmfield(k,'cell_type');
            end
            
            if contains(k.unit_quality,'ok or good')
                k = rmfield(k,'unit_quality');
                PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition * ANL.PSTHTrial * EXP.BehaviorTrial) & ANL.IncludeUnit & k & 'unit_quality="ok" or unit_quality="good"' & 'early_lick="no early"', '*');
            else
                if contains(k.unit_quality,'all')
                    k = rmfield(k,'unit_quality');
                end
                PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition * ANL.PSTHTrial * EXP.BehaviorTrial) & ANL.IncludeUnit & k & 'early_lick="no early"' , '*');
            end
            
            if numel(unique([PSTH.unit]))>1 %i.e. there are more than one cell
                if ~isempty(PSTH)
                    PSTH = struct2table(PSTH);
                    M = Modes;
                    [key] = fn_RegressionprojectSingleTrial (M, PSTH, key);
                    insert(self,key);
                end
            end
        end
    end
end