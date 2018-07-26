%{
# List of included units, based on number of trials and firing rate

-> EPHYS.Unit
---

%}

classdef IncludeUnit < dj.Computed
    properties
        keySource= EPHYS.Unit;
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            Param = struct2table(fetch (ANL.Parameters,'*'));
            mintrials_unit = Param.parameter_value{(strcmp('mintrials_unit',Param.parameter_name))};
            minimal_mean_fr_sample = Param.parameter_value{(strcmp('minimal_mean_fr_sample',Param.parameter_name))};
            minimal_mean_fr_delay = Param.parameter_value{(strcmp('minimal_mean_fr_delay',Param.parameter_name))};
            minimal_mean_fr_response = Param.parameter_value{(strcmp('minimal_mean_fr_response',Param.parameter_name))};
                        minimal_adaptive_peak_fr_basic_trials = Param.parameter_value{(strcmp('minimal_adaptive_peak_fr_basic_trials',Param.parameter_name))};

            
            % number of trials (basic left/right) trials without additional photostim, exluding early licks. Only trials that happened while the animal was behaving are considered
            rel1 = (EPHYS.TrialSpikes * EPHYS.Unit * EXP.BehaviorTrial * EXP.TrialName) & key & 'outcome ="hit"' & 'early_lick="no early"'  & 'trial_type_name="r"'; % & ANL.TrialBehaving 
            trials_r = rel1.count;
            
            rel2 = (EPHYS.TrialSpikes * EPHYS.Unit * EXP.BehaviorTrial * EXP.TrialName) & key & 'outcome ="hit"' & 'early_lick="no early"'  & 'trial_type_name="l"';
            trials_l = rel2.count;
            
            %firing rates
            FR = fetch(ANL.UnitFiringRate & key,'*');
          
            if (trials_r>= mintrials_unit &&  trials_l>= mintrials_unit) && ...
                    (FR.mean_fr_sample >= minimal_mean_fr_sample || FR.mean_fr_delay >= minimal_mean_fr_delay || FR.mean_fr_response >= minimal_mean_fr_response) && ...
                    (FR.adaptive_peak_fr_basic_trials >= minimal_adaptive_peak_fr_basic_trials)
                insert(self,key);
            end
            
        end
    end
end

