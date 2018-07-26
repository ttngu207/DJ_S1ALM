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


classdef ProjTrialAverageIndividualBaseline < dj.Computed
    properties
        %         keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr" or cell_type="FS" or cell_type="all"') * (EPHYS.UnitQualityType & 'unit_quality="all" or unit_quality="good" or unit_quality="ok or good"') * EXP.Outcome * ANL.ModeWeightsSign;
        keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr" or cell_type="FS" or cell_type="all"') * (EPHYS.UnitQualityType & 'unit_quality="all" or unit_quality="good" or unit_quality="ok or good"') * EXP.Outcome * ANL.ModeWeightsSign ;
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
            key.task = fetch1(EXP.SessionTask & key,'task');
            
            k=key;
            Modes = fetch (ANL.Mode  & k, '*');
            
            
            Param = struct2table(fetch (ANL.Parameters,'*'));
            time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
            mode_names = unique({Modes.mode_type_name})';
            
            if ~isempty(mode_names)
                for imod = 1:1:numel(mode_names)
                    key.mode_type_name = mode_names{imod};
                    Proj =  fetch(ANL.ProjTrialAverage & key,'*');
                    for ii=1:1:size(Proj,1)
                        baseline = nanmean(Proj(ii).proj_average(time>=-4.3 & time<-3.8));
                        Proj(ii).proj_average = Proj(ii).proj_average -baseline;
                        %                     hold on
                        %                         plot(time,Proj(ii).proj_average)
                    end
                    insert(self,Proj);
                end
                
            end
        end
    end
end