%{
#
-> EXP.Session
-> LAB.Hemisphere
-> LAB.BrainArea
-> EPHYS.CellType
-> EPHYS.UnitQualityType
-> ANL.ModeTypeName
-> ANL.ModeWeightsSign
-> EXP.TrialNameType
time_used_start                      : double                  # beginning of the time interval used 
time_used_end                        : double                  # end of the time interval used 
---
switch_prob                          : blob                  # probability of switching (making an error) vs. normalized distance along the mode
normalized_proj_bins                 : blob                  # binned distance along the mode

%}


classdef SwitchProbabilityHighvsLowStimulus < dj.Computed
    properties
        keySource = (EXP.Session & (EXP.SessionTask  &'task="s1 stim"')  & (EPHYS.Unit))*ANL.SessionPosition * (EPHYS.CellType & 'cell_type="Pyr"') * (EPHYS.UnitQualityType & 'unit_quality="ok or good" or unit_quality="all"') * (ANL.ModeTypeName & 'mode_type_name="Stimulus Orthog.1"') * (ANL.ModeWeightsSign & 'mode_weights_sign="all"') * (EXP.TrialNameType &  'trial_type_name="r" or trial_type_name="l_-1.6Full" or trial_type_name="l_-0.8Full"');
        
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
            tic
            
            key.time_used_start = fetch1(ANL.TrialTypeStimTime & key,'stim_onset');
            key.time_used_end = key.time_used_start + fetch1(ANL.TrialTypeStimTime & key,'stim_duration') + 0.1;

            Param = struct2table(fetch (ANL.Parameters,'*'));
            time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
            psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
            smooth_time = 0.1; %Param.parameter_value{(strcmp('smooth_time_proj',Param.parameter_name))};
            smooth_bins=ceil(smooth_time/psth_time_bin);
            rel_Proj = ( ANL.ProjTrial * EXP.Session * EXP.SessionID ) & key & 'outcome!="ignore"' & (EXP.BehaviorTrial & 'early_lick="no early"');

            proj =  movmean(cell2mat(fetchn(rel_Proj,'proj_trial','ORDER BY trial')),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
            outcome =  fetchn(rel_Proj,'outcome','ORDER BY trial');
            
            tidx = time>= key.time_used_start & time<key.time_used_end ;
            
            p = fn_compute_proj_binning_high_vs_low_stimulus (proj, outcome, tidx, time);
            key.switch_prob = p.bin_percent;
            key.normalized_proj_bins = p.edges;
            insert(self,key)
                
            
           
        end
        
    end
end