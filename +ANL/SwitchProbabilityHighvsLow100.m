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


classdef SwitchProbabilityHighvsLow100 < dj.Computed
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
            
            rel_Proj = ( ANL.ProjTrial100 * EXP.Session * EXP.SessionID  * ANL.SVMdecoderFindErrorTrials ) & key & 'outcome!="ignore"' & (EXP.BehaviorTrial & 'early_lick="no early"') & sprintf('num_units_projected>=%d', min_num_units_projected); %note that if ANL.ProjTrial22 also has outcome "response" it should be exluded too
            trial_decoded_type = {'all','correct','error'};
            for i=1:1:numel(trial_decoded_type)
                key.trial_decoded_type =trial_decoded_type{i};
                if strcmp(key.trial_decoded_type,'all')
                    proj(i).proj =  movmean(cell2mat(fetchn(rel_Proj,'proj_trial','ORDER BY trial')),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
                    proj(i).outcome =  fetchn(rel_Proj,'outcome','ORDER BY trial');
                elseif strcmp(key.trial_decoded_type,'correct')
                    proj(i).proj =  movmean(cell2mat(fetchn(rel_Proj & 'trial_decoded_as_error<0.25','proj_trial','ORDER BY trial')),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
                    proj(i).outcome =  fetchn(rel_Proj & 'trial_decoded_as_error=0','outcome','ORDER BY trial');
                elseif  strcmp(key.trial_decoded_type,'error')
                    proj(i).proj =  movmean(cell2mat(fetchn(rel_Proj & 'trial_decoded_as_error>=0.25','proj_trial','ORDER BY trial')),[smooth_bins 0], 2, 'omitnan','Endpoints','shrink');
                    proj(i).outcome =  fetchn(rel_Proj & 'trial_decoded_as_error=1','outcome','ORDER BY trial');
                end
                
                
                tidx = time>=key.time_used_for_decoding_start & time<key.time_used_for_decoding_end;
                
                p = fn_compute_proj_binning_high_vs_low5(proj(i),proj(1), tidx, time);
                key.switch_prob = p.bin_percent;
                key.normalized_proj_bins = p.edges;
                insert(self,key)
                
            end
           
        end
        
    end
end