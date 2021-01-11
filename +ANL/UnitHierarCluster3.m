%{
# Projection of the neural acitivity on a mode (neuron weights vector)
-> EPHYS.Unit
-> LAB.Hemisphere
-> LAB.BrainArea
-> EPHYS.CellType
-> EPHYS.UnitQualityType
-> EXP.TrainingType
heirar_cluster_time_st             : double           #  beginning of the time interval used for heirarchical clustering (seconds, relative to go cue).
heirar_cluster_time_end            : double           #  end of the time interval used for heirarchical clustering (seconds, relative to go cue).
---
heirar_cluster_id        : int            # cluster to which this cell belongs. Note that this id is not unique, because clustering is done independently for different combinations of the primary keys, and the cluster_id would change accordingly

%}


classdef UnitHierarCluster3 < dj.Computed
    properties

%         keySource = ((EPHYS.CellType &  (ANL.IncludeSession- ANL.ExcludeSession)) & 'cell_type="Pyr"  or cell_type="FS"') * (EPHYS.UnitQualityType & 'unit_quality="ok or good"') * (LAB.BrainArea & 'brain_area="ALM"') * (LAB.Hemisphere & 'hemisphere="both"') * EXP.TrainingType ;
        
        keySource = ((EPHYS.CellType &  (ANL.IncludeSession- ANL.ExcludeSession)) & 'cell_type="Pyr" or cell_type="FS"') * (EPHYS.UnitQualityType & 'unit_quality="ok or good"') * (LAB.BrainArea & 'brain_area="vS1"') * (LAB.Hemisphere & 'hemisphere="left"') * EXP.TrainingType ;
        
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            
            
            k = key;
            
            
            key.heirar_cluster_time_st = -3.5;
            key.heirar_cluster_time_end = 0;
            
            if contains(k.brain_area,'all')
                k = rmfield(k,'brain_area');
            end
            
            if contains(k.hemisphere,'both')
                k = rmfield(k,'hemisphere');
            end
            
            if contains(k.cell_type,'all')
                k = rmfield(k,'cell_type');
            end
            if contains(k.training_type,'all')
                k = rmfield(k,'training_type');
            end
            
            
            if contains(k.unit_quality,'ok or good')
                k = rmfield(k,'unit_quality');
                %fetching data
                Units = fetch ((EPHYS.Unit * EPHYS.UnitPosition * EXP.SessionTraining * EPHYS.UnitCellType) & k & ANL.IncludeUnit & 'unit_quality!="multi"', 'ORDER BY unit_uid');
                PSTH_L = struct2table( fetch((ANL.PSTHAdaptiveAverage * EPHYS.Unit * EPHYS.UnitPosition * EPHYS.UnitCellType * EXP.SessionTraining) & ANL.IncludeUnit &  k & 'unit_quality!="multi"' & 'outcome="hit"' & 'trial_type_name="l"', '*', 'ORDER BY unit_uid'));
                PSTH_R = struct2table(fetch ((ANL.PSTHAdaptiveAverage * EPHYS.Unit * EPHYS.UnitPosition * EPHYS.UnitCellType * EXP.SessionTraining) & ANL.IncludeUnit &  k & 'unit_quality!="multi"' & 'outcome="hit"' & 'trial_type_name="r"', '*', 'ORDER BY unit_uid'));
            else
                if contains(k.unit_quality,'all')
                    k = rmfield(k,'unit_quality');
                end
                %fetching data
                Units = fetch ((EPHYS.Unit * EPHYS.UnitPosition * EXP.SessionTraining * EPHYS.UnitCellType) & k & ANL.IncludeUnit, 'ORDER BY unit_uid');
                PSTH_L = struct2table( fetch((ANL.PSTHAdaptiveAverage * EPHYS.Unit * EPHYS.UnitPosition * EPHYS.UnitCellType * EXP.SessionTraining) & ANL.IncludeUnit &  k & 'outcome="hit"' & 'trial_type_name="l"', '*', 'ORDER BY unit_uid'));
                PSTH_R = struct2table(fetch ((ANL.PSTHAdaptiveAverage * EPHYS.Unit * EPHYS.UnitPosition * EPHYS.UnitCellType * EXP.SessionTraining) & ANL.IncludeUnit &  k & 'outcome="hit"' & 'trial_type_name="r"', '*', 'ORDER BY unit_uid'));
            end
            
            % fetching params
            
            Param = struct2table(fetch (ANL.Parameters,'*'));
            psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
            smooth_time = Param.parameter_value{(strcmp('smooth_time_cell_psth_for_clustering',Param.parameter_name))};
            smooth_bins=ceil(smooth_time/psth_time_bin);
            
            
            % converting to table
            PSTH_L_mat=cell2mat({PSTH_L.psth_avg}');
            PSTH_R_mat=cell2mat({PSTH_R.psth_avg}');
            
            %smoothing
            PSTH_L_mat = movmean(PSTH_L_mat, [smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
            PSTH_R_mat = movmean(PSTH_R_mat, [smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
            % PSTH_L = movmean(PSTH_L, [smooth_bins +1], 2, 'omitnan','Endpoints','shrink');
            % PSTH_R = movmean(PSTH_R, [smooth_bins +1], 2, 'omitnan','Endpoints','shrink');
            
            
            %taking only some time interval
            time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
            t_idx= (time>=key.heirar_cluster_time_st & time<key.heirar_cluster_time_end);
            PSTH_L_mat=PSTH_L_mat(:,t_idx);
            PSTH_R_mat=PSTH_R_mat(:,t_idx);
            
            
            %concatenated
            PTSH_RLconcat = [PSTH_R_mat, PSTH_L_mat];
            PTSH_RLconcat = PTSH_RLconcat./nanmax(PTSH_RLconcat,[],2);
            
            
            
            
            if (size(Units,1) ~= size(PSTH_L_mat,1))
                return
            end
            
            
            %Perform Hierarchical Clustering
            if ~ishandle(1)
                close all;
                figure;
                set(gcf,'DefaultAxesFontName','helvetica');
                set(gcf,'PaperUnits','centimeters','PaperPosition',[0 0 20 30]);
                set(gcf,'PaperOrientation','portrait');
                set(gcf,'Units','centimeters','Position',get(gcf,'paperPosition')+[3 0 0 0]);
            end
            [cl_id] = fn_ClusterCells(PTSH_RLconcat, [1:1:2*numel(time(t_idx))], key);
            
            % Insert
            for i=1:1:numel(Units)
                key(i).subject_id=Units(i).subject_id;
                key(i).session=Units(i).session;
                key(i).electrode_group=Units(i).electrode_group;
                key(i).unit=Units(i).unit;
                
                key(i).cell_type=key(1).cell_type;
                key(i).unit_quality=key(1).unit_quality;
                key(i).brain_area=key(1).brain_area;
                key(i).hemisphere=key(1).hemisphere;
                key(i).training_type=key(1).training_type;
                key(i).heirar_cluster_time_st=key(1).heirar_cluster_time_st;
                key(i).heirar_cluster_time_end=key(1).heirar_cluster_time_end;
                key(i).heirar_cluster_id = cl_id(i);
            end
            
            insert(self,key);
            
            
        end
    end
end