%{
#
-> EXP.Session
-> LAB.Hemisphere
-> LAB.BrainArea
-> EPHYS.CellType
-> EPHYS.UnitQualityType
-> ANL.ModeTypeName
-> ANL.ModeWeightsSign
---
switch_prob                          : blob                  # probability of switching (making an error) vs. normalized distance along the mode
normalized_proj_bins                 : blob                  # binned distance along the mode
%}


classdef SwitchProbabilityHighvsLow11LateEarlyDelayCombined < dj.Computed
    properties
        keySource = (EXP.Session & (EXP.SessionTask  &'task="s1 stim"')  & (EPHYS.Unit))*ANL.SessionPosition * (EPHYS.CellType & 'cell_type="Pyr"') * (EPHYS.UnitQualityType & 'unit_quality="ok or good" or unit_quality="all"') * (ANL.ModeTypeName & 'mode_type_name="Ramping Orthog.111"') * (ANL.ModeWeightsSign & 'mode_weights_sign="all"');
        
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
            tic
            
            Param = struct2table(fetch (ANL.Parameters,'*'));
            time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
            psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
            smooth_time = Param.parameter_value{(strcmp('smooth_time_proj',Param.parameter_name))};
            smooth_bins=ceil(smooth_time/psth_time_bin);
            
            min_num_units_projected = Param.parameter_value{(strcmp('min_num_units_projected',Param.parameter_name))};
            
            t_early_delay = [-2, -1.6];
            kkk.trial_type_name='l_-1.6Full';
            rel_Proj = ( ANL.ProjTrial11 * EXP.Session * EXP.SessionID) & key & 'outcome="hit" or outcome="miss"' & (EXP.BehaviorTrial & 'early_lick="no early"') & sprintf('num_units_projected>=%d', min_num_units_projected) &kkk;
            proj =  movmean(cell2mat(fetchn(rel_Proj,'proj_trial','ORDER BY trial')),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
            if isempty(proj)
                return
            end
            
            tidx = time>=t_early_delay(1) & time<t_early_delay(2);
            proj1 = proj(:,tidx);
            outcome1 =  fetchn(rel_Proj,'outcome','ORDER BY trial');
            
            t_late_delay = [-1.2, -0.8];
            kkk.trial_type_name='l_-0.8Full';
            rel_Proj = ( ANL.ProjTrial11 * EXP.Session * EXP.SessionID) & key & 'outcome="hit" or outcome="miss"' & (EXP.BehaviorTrial & 'early_lick="no early"') & sprintf('num_units_projected>=%d', min_num_units_projected) &kkk;
            proj =  movmean(cell2mat(fetchn(rel_Proj,'proj_trial','ORDER BY trial')),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
            tidx = time>=t_late_delay(1) & time<t_late_delay(2);
            proj2 = proj(:,tidx);
            outcome2 =  fetchn(rel_Proj,'outcome','ORDER BY trial');

            proj = [proj1;proj2];
            outcome = [outcome1;outcome2];

            p = fn_compute_proj_binning_high_vs_low_earlylatedelay_combined (proj,outcome );
            key.switch_prob = p.bin_percent;
            key.normalized_proj_bins = p.edges;
            insert(self,key)
            
            
            
        end
        
    end
end