%{
# Projection of the neural acitivity on a mode (neuron weights vector)
-> EPHYS.Unit
-> LAB.Hemisphere
-> LAB.BrainArea
-> EPHYS.CellType
-> EPHYS.UnitQualityType
-> EXP.TrainingType
---
heirar_cluster_id        : int            # cluster to which this cell belongs. Note that this id is not unique, because clustering is done independently for different combinations of the primary keys, and the cluster_id would change accordingly

%}


classdef UnitHierarCluster < dj.Computed
    properties
        keySource = (EPHYS.CellType & 'cell_type="Pyr" or cell_type="FS" or cell_type="all"') * (EPHYS.UnitQualityType & 'unit_quality="all" or unit_quality="good" or unit_quality="ok or good"') * LAB.BrainArea * EXP.TrainingType;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            k = key;
            if contains(k.cell_type,'all')
                k = rmfield(k,'cell_type');
            end
            if contains(k.unit_quality,'all')
                k = rmfield(k,'unit_quality');
            end
            if contains(k.training_type,'all')
                k = rmfield(k,'training_type');
            end
            
            PSTH_L = fetch ((ANL.PSTHAverage) & ANL.IncludeUnit & ((EPHYS.UnitCellType * EPHYS.UnitPosition) & k) & 'outcome="hit"' & 'trial_type_name="l"', '*');
            
            PSTH_R = fetch ((ANL.PSTHAverage) & ANL.IncludeUnit & ((EPHYS.UnitCellType * EPHYS.UnitPosition) & k) & 'outcome="hit"' & 'trial_type_name="R"', '*');

            
            
            %             k=key;
            %
            %             if contains(k.cell_type,'all')
            %                 k = rmfield(k,'cell_type');
            %             end
            %
            %             if contains(k.unit_quality,'ok or good')
            %                 k = rmfield(k,'unit_quality');
            %                 Modes = fetch ((ANL.Mode * EXP.SessionID * EPHYS.Unit  * EPHYS.UnitCellType) & ANL.IncludeUnit & k & 'unit_quality="ok" or unit_quality="good"', '*');
            %                 PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition * ANL.PSTHAverage) & ANL.IncludeUnit & k & 'unit_quality="ok" or unit_quality="good"', '*');
            %             else
            %                 if contains(k.unit_quality,'all')
            %                     k = rmfield(k,'unit_quality');
            %                 end
            %                 Modes = fetch ((ANL.Mode * EXP.SessionID * EPHYS.Unit  * EPHYS.UnitCellType) & ANL.IncludeUnit & k, '*');
            %                 PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition * ANL.PSTHAverage) & ANL.IncludeUnit & k, '*');
            %             end
            %
            %             if numel(unique([PSTH.unit]))>1 %i.e. there are more than one cell
            %                 if ~isempty(PSTH)
            %                     PSTH = struct2table(PSTH);
            %                     mode_names = unique({Modes.mode_type_name})';
            %                     counter=1;
            %                     for imod = 1:1:numel(mode_names)
            %                         M = Modes(strcmp(mode_names{imod},{Modes.mode_type_name}'));
            %                         [key, counter] = fn_projectTrialAvg_populate(M, PSTH, key, counter);
            %                     end
            %                     insert(self,key);
            %                 end
            %             end
        end
    end
end