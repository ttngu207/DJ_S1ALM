%{
# Projection of the neural acitivity on a mode (neuron weights vector)
-> EXP.Session
-> LAB.Hemisphere
-> LAB.BrainArea
-> EPHYS.CellType
-> EPHYS.UnitQualityType
-> ANL.ModeTypeName
-> ANL.ModeWeightsSign
-> EXP.TrialNameType
-> EXP.Outcome

---
num_trials_projected        : int            # number of projected trials in this trial-type/outcome
num_units_projected         : int            # number of units projected in this trial-type/outcome

proj_average                : longblob       # projection of the neural acitivity on the mode (weights vector) for this trial-type/outcome, given in arbitrary units. The time vector is psth_t_vector that could be found in ANL.Parameters

%}


classdef ProjTrialAdaptiveAverageNormalized < dj.Computed
    properties
        %         keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr" or cell_type="FS" or cell_type="all"') * (EPHYS.UnitQualityType & 'unit_quality="all" or unit_quality="good" or unit_quality="ok or good"') * EXP.Outcome * ANL.ModeWeightsSign;
        keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr"') * (EPHYS.UnitQualityType & 'unit_quality="ok or good"') * EXP.Outcome * (ANL.ModeWeightsSign & 'mode_weights_sign="all"') * (ANL.ModeTypeName & 'mode_type_name="LateDelay"');
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
            key.task = fetch1(EXP.SessionTask & key,'task');
            
            k=key;
            Modes = fetch (ANL.Mode  & k, '*');
            
            if contains(k.cell_type,'all')
                k = rmfield(k,'cell_type');
            end
            
            if contains(k.unit_quality,'ok or good')
                k = rmfield(k,'unit_quality');
                %                 Modes = fetch ((ANL.Mode * EXP.SessionID * EPHYS.Unit  * EPHYS.UnitCellType) & ANL.IncludeUnit & k & 'unit_quality="ok" or unit_quality="good"', '*');
                PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition * ANL.PSTHAdaptiveAverage) & ANL.IncludeUnit & k & 'unit_quality="ok" or unit_quality="good"', '*');
            else
                if contains(k.unit_quality,'all')
                    k = rmfield(k,'unit_quality');
                end
                %                 Modes = fetch ((ANL.Mode * EXP.SessionID * EPHYS.Unit  * EPHYS.UnitCellType) & ANL.IncludeUnit & k, '*');
                PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition * ANL.PSTHAdaptiveAverage) & ANL.IncludeUnit & k, '*');
            end
            
            
            Param = struct2table(fetch (ANL.Parameters,'*'));
            time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
            psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
            smooth_time = Param.parameter_value{(strcmp('smooth_time_proj',Param.parameter_name))};
            smooth_bins=ceil(smooth_time/psth_time_bin);
            mode_names = unique({Modes.mode_type_name})';
            
            if ~isempty(mode_names)
                for imod = 1:1:numel(mode_names)
                    key.mode_type_name = mode_names{imod};
                    Proj =  fetch(ANL.ProjTrialAdaptiveAverage & key,'*');
                    mode_time1_st =  unique(fetchn(ANL.Mode & key,'mode_time1_st'));
                    mode_time1_end =  unique(fetchn(ANL.Mode & key,'mode_time1_end'));
                    
                    kkl.trial_type_name='l';
                    kkr.trial_type_name='r';

                    rel =ANL.ProjTrialAdaptiveAverage & key;
                    if rel.count==0
                        return
                    end
                    l_proj = fetch1(rel & kkl,'proj_average');
                    r_proj = fetch1(rel & kkr,'proj_average');
                    selectivity = r_proj-l_proj;
                    selectivity = movmean(selectivity,[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
                    max_selectivity = nanmax(selectivity (time>=mode_time1_st & time<mode_time1_end));
                    baseline = mean(l_proj(time>=-4 & time<-3));
                    for ii=1:1:size(Proj,1)
                        Proj(ii).proj_average = (Proj(ii).proj_average -baseline)/max_selectivity;
%                     hold on
%                         plot(time,Proj(ii).proj_average)
                    end
                    insert(self,Proj);
                end
                
            end
        end
    end
end