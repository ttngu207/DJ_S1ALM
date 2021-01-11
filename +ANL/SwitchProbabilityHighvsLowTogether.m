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
-> ANL.TrialDecodedType
time_used_for_decoding_start         : double                  # beginning of the time interval used for decoding
time_used_for_decoding_end           : double                  # end of the time interval used for decoding
---
switch_prob                          : blob                  # probability of switching (making an error) vs. normalized distance along the mode
normalized_proj_bins                 : blob                  # binned distance along the mode

%}


classdef SwitchProbabilityHighvsLowTogether < dj.Computed
    properties
        keySource = (EXP.Session & (EXP.SessionTask  &'task="s1 stim"')  & (EPHYS.Unit))*ANL.SessionPosition * (EPHYS.CellType & 'cell_type="Pyr"') * (EPHYS.UnitQualityType & 'unit_quality="ok or good" or unit_quality="all"') * (ANL.ModeTypeName & 'mode_type_name="Ramping Orthog.111"') * (ANL.ModeWeightsSign & 'mode_weights_sign="all"') * (EXP.TrialNameType &  'trial_type_name="l" or trial_type_name="l_-1.6Full" or trial_type_name="l_-1.6Mini"');
        
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
            tic
            
            key.time_used_for_decoding_start=-2;
            key.time_used_for_decoding_end=-1.6;
            Param = struct2table(fetch (ANL.Parameters,'*'));
            time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
            psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
            smooth_time = Param.parameter_value{(strcmp('smooth_time_proj',Param.parameter_name))};
            smooth_bins=ceil(smooth_time/psth_time_bin);
            
            min_num_units_projected = Param.parameter_value{(strcmp('min_num_units_projected',Param.parameter_name))};
            
            
            % main trial type
            rel_Proj = ( ANL.ProjTrial11 * EXP.Session * EXP.SessionID  * ANL.SVMdecoderFindErrorTrials ) & key & 'outcome="hit" or outcome="miss"' & (EXP.BehaviorTrial & 'early_lick="no early"') & sprintf('num_units_projected>=%d', min_num_units_projected); 

            
            kkk=key;
            kkk=rmfield(kkk,'trial_type_name');
           
            if strcmp(key.trial_type_name,'l')
                rel_Proj_more = ( ANL.ProjTrial11 * EXP.Session * EXP.SessionID  * ANL.SVMdecoderFindErrorTrials ) & 'trial_type_name="l_-1.6Full" or trial_type_name="l_-1.6Mini"' & kkk & 'outcome="hit" or outcome="miss"' & (EXP.BehaviorTrial & 'early_lick="no early"') & sprintf('num_units_projected>=%d', min_num_units_projected);
            else
                rel_Proj_more = ( ANL.ProjTrial11 * EXP.Session * EXP.SessionID  * ANL.SVMdecoderFindErrorTrials ) & 'trial_type_name="l"' & kkk & 'outcome="hit" or outcome="miss"' & (EXP.BehaviorTrial & 'early_lick="no early"') & sprintf('num_units_projected>=%d', min_num_units_projected);
            end
            
            
            
            
%             trial_decoded_type = {'all','correct','error'};
             key.trial_decoded_type ='all';
             proj.proj =  movmean(cell2mat(fetchn(rel_Proj,'proj_trial','ORDER BY trial')),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
             proj.outcome =  fetchn(rel_Proj,'outcome','ORDER BY trial');
             
             proj_more.proj =  movmean(cell2mat(fetchn(rel_Proj_more,'proj_trial','ORDER BY trial')),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
             proj_more.outcome =  fetchn(rel_Proj_more,'outcome','ORDER BY trial');
             
             
             tidx = time>=key.time_used_for_decoding_start & time<key.time_used_for_decoding_end;
             
             p = fn_compute_proj_binning_high_vs_lowTogether(proj,proj_more, tidx, time);
             key.switch_prob = p.bin_percent;
             key.normalized_proj_bins = p.edges;
             insert(self,key)
             
            
           
        end
        
    end
end