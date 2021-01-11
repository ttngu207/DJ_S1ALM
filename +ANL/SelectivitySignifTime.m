%{
#
-> EPHYS.Unit
-> EXP.EpochName
---
selectivity_pvalue_ranksum                 : double    # R-L PSTH
selectivity_pvalue_ttest                 : double    # R-L PSTH

%}


classdef SelectivitySignifTime < dj.Computed
    properties
        %         keySource = (EXP.Session & EPHYS.TrialSpikes) * EXP.EpochName
    end
    methods(Access=protected)
        function makeTuples(self, key)
            electrode_group = [fetchn(EPHYS.Unit & key,'electrode_group')];
            
            
            Param = struct2table(fetch (ANL.Parameters,'*'));
            t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
            t_chirp2 = Param.parameter_value{(strcmp('t_chirp2',Param.parameter_name))};
            t_sample_stim = Param.parameter_value{(strcmp('t_sample_stim',Param.parameter_name))};
            time = Param.parameter_value{(strcmp('psth_t_vector',Param.parameter_name))};
            mintrials_psth_typeoutcome = Param.parameter_value{(strcmp('mintrials_psth_typeoutcome',Param.parameter_name))};
            if strcmp(key.trial_epoch_name,'sample')
                t_idx  = time>t_sample_stim & time<t_chirp2;
            elseif strcmp(key.trial_epoch_name,'delay')
                t_idx  = time>t_chirp2 & time<t_go;
            end
            
            L = cell2mat(fetchn(ANL.PSTHTrial*EXP.BehaviorTrial & key  & 'outcome="hit"' & 'trial_type_name="l"','psth_trial'));
            R = cell2mat(fetchn(ANL.PSTHTrial*EXP.BehaviorTrial & key & key  & 'outcome="hit"' & 'trial_type_name="r"','psth_trial'));
            
            if numel(L)<mintrials_psth_typeoutcome || numel(R)<mintrials_psth_typeoutcome
                return;
            end
            
            p_ranksum= ranksum(mean(R(:,t_idx),2),mean(L(:,t_idx),2));
            if isnan(p_ranksum)
                return;
            end
            key.selectivity_pvalue_ranksum =p_ranksum;
            
            [~,p_ttest]= ttest2(mean(R(:,t_idx),2),mean(L(:,t_idx),2));

              if isnan(p_ttest)
                return;
            end
            key.selectivity_pvalue_ttest =p_ttest;

            insert(self,key)
        end
    end
end