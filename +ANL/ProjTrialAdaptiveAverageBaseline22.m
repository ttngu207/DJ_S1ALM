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


classdef ProjTrialAdaptiveAverageBaseline22 < dj.Computed
    properties
        %         keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr" or cell_type="FS" or cell_type="all"') * (EPHYS.UnitQualityType & 'unit_quality="all" or unit_quality="good" or unit_quality="ok or good"') * EXP.Outcome * ANL.ModeWeightsSign;
%         keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr" or cell_type="FS" or cell_type="all"') * (EPHYS.UnitQualityType & 'unit_quality="all" or unit_quality="ok or good"') * EXP.Outcome * ANL.ModeWeightsSign * ANL.ModeTypeName;
                keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr"') * (EPHYS.UnitQualityType & 'unit_quality="all"') * EXP.Outcome * (ANL.ModeWeightsSign) * (ANL.ModeTypeName & ANL.Mode5);

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
                Modes = fetch ( (ANL.Mode5 * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition)  & ANL.IncludeUnit & k & 'unit_quality="ok" or unit_quality="good"', '*');
                PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition * ANL.PSTHAdaptiveAverage) & ANL.IncludeUnit & k & 'unit_quality="ok" or unit_quality="good"', '*');
            else
                if contains(k.unit_quality,'all')
                    k = rmfield(k,'unit_quality');
                end
                Modes = fetch (ANL.Mode5 *EPHYS.UnitCellType * EPHYS.UnitPosition & ANL.IncludeUnit & k, '*');
                PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition * ANL.PSTHAdaptiveAverage) & ANL.IncludeUnit & k, '*');
            end
            
            
            Param = struct2table(fetch (ANL.Parameters,'*'));
            time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
            mode_names = unique({Modes.mode_type_name})';
            
            if ~isempty(mode_names)
                for imod = 1:1:numel(mode_names)
                    key.mode_type_name = mode_names{imod};
                    Proj =  fetch(ANL.ProjTrialAdaptiveAverage22 & key,'*');
                     if numel(Proj)==0
                         return
                     end
                     % for baseline we take correct left trials
                    key.outcome='hit';
                    kkl.trial_type_name='l';
                    l_proj = fetch1(ANL.ProjTrialAdaptiveAverage22 & key & kkl,'proj_average');
                    baseline = mean(l_proj(time>=-4 & time<-3));
                    for ii=1:1:size(Proj,1)
                        Proj(ii).proj_average = (Proj(ii).proj_average -baseline);
%                     hold on
%                         plot(time,Proj(ii).proj_average)
                    end
                    insert(self,Proj);
                end
                
            end
        end
    end
end