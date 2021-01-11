%{
# Projection of the neural acitivity on a mode (neuron weights vector)
-> EXP.Session
-> EPHYS.CellType
-> EPHYS.UnitQualityType
-> ANL.ModeWeightsSign
-> ANL.OutcomeType
-> LAB.BrainArea
-> LAB.Hemisphere
-> ANL.ModeTypeName
---
num_trials_session_bin                          : int            # number of projected trials in this session time-bin
ramping_slope_session_time_binned               : blob       # average slope of the mode, binned according to session time
session_time_binned_vector                      : blob                # contains the relative time bin for computing trials. i.e 0.25 - the first 0-25% of the trials, 0.5 - 25%-50% of the trials etc
%}


classdef RampingSessionModulationProjTrialAverage < dj.Computed
    properties
        %         keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr" or cell_type="FS" or cell_type="all"') * (EPHYS.UnitQualityType & 'unit_quality="all" or unit_quality="good" or unit_quality="ok or good"') * EXP.Outcome * ANL.ModeWeightsSign;
        keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr" or cell_type="all"') * (EPHYS.UnitQualityType & 'unit_quality="all" or unit_quality="ok or good"') * (ANL.OutcomeType & 'outcome_grouping!="ignore"') * (ANL.ModeWeightsSign & 'mode_weights_sign="all"') ;
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            k=key;
            
            
            
            Modes = fetch (ANL.Mode  & k, '*');
            
            Param = struct2table(fetch (ANL.Parameters,'*'));
            time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
            mode_names = unique({Modes.mode_type_name})';
            
            mode_time1_interval=[-4, -3];
            mode_time2_interval=[-1, 0];
            t_idx_1= time>=mode_time1_interval(1) & time<mode_time1_interval(2);
            
            t_idx_2= time>=mode_time2_interval(1) & time<mode_time2_interval(2);
            
            prctile_vector= [0 20 40 60 80];
            
            k.session_time_binned_vector = prctile_vector;
            
            if ~isempty(mode_names)
                for imod = 1:1:numel(mode_names)
%                     if contains(mode_names{imod},'Ramping')
                        
                        k.mode_type_name = mode_names{imod};
                        
                        if strcmp(k.outcome_grouping,'all')
                            rel=ANL.ProjTrial & k & 'outcome!="ignore"';
                        else
                            key_outcome.outcome=k.outcome_grouping;
                            rel=ANL.ProjTrial & k & key_outcome;
                        end
                        
                        if rel.count<10
                            return
                        end
                        
                        Proj =  struct2table(fetch(rel,'*','ORDER BY trial'));
                        prctile_start=prctile([1:1:size(Proj)],prctile_vector);
                        prctile_end=prctile([1:1:size(Proj)],prctile_vector+mean(diff(prctile_vector)));
                        for i_prctile=1:1:numel(prctile_start)
                            proj_prctile=table2array(Proj( floor(prctile_start(i_prctile)):ceil(prctile_end(i_prctile)), 'proj_trial'));
                            proj_prctile_avg=nanmean(proj_prctile,1);
                            ramping_slope_prctile(i_prctile)= nanmean(proj_prctile_avg(t_idx_2)) - nanmean(proj_prctile_avg(t_idx_1));
                        end
                        k.ramping_slope_session_time_binned =ramping_slope_prctile;
                        k.num_trials_session_bin=floor(prctile_end(1)-prctile_start(1));
                        %                         plot(prctile_vector,ramping_slope_prctile)
                        %                         hold on;
                        insert(self,k);
%                     end
                end
                
            end
        end
    end
end