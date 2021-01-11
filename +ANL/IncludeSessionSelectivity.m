%{
#
-> EXP.Session
---
num_trials_hit           : int
num_ok_or_good_units     : int
num_sample_selective_units     : int
num_delay_selective_units     : int
good_session_flag        :smallint
%}


classdef IncludeSessionSelectivity < dj.Computed
    properties
        keySource = (EXP.Session  & EPHYS.Unit);
    end
    methods(Access=protected)
        function makeTuples(self, key)
            pval_threshold=0.00001;
%             rel=(EPHYS.Unit & ANL.IncludeUnit) & 'unit_quality="ok" or unit_quality="good"' & key;
            rel=(EPHYS.Unit & ANL.IncludeUnit)  & key;
            num_ok_or_good_units =rel.count;
            num_trials_hit =numel(fetch1(ANL.SessionBehavOverview & key,'trials_hit'));
            
            
            rel2=rel & (ANL.SelectivitySignifEpoch & sprintf('selectivity_pvalue<%.6f',pval_threshold) & 'trial_epoch_name="delay"');
            num_delay_selective_units =rel2.count;
           
            rel3=rel & (ANL.SelectivitySignifEpoch & sprintf('selectivity_pvalue<%.6f',pval_threshold) & 'trial_epoch_name="sample"');
            num_sample_selective_units =rel3.count;
            
            
            Param = struct2table(fetch (ANL.Parameters,'*'));
            minimal_num_units_sessions = Param.parameter_value{(strcmp('minimal_num_units_sessions',Param.parameter_name))};
            minimal_num_hit_trials_sessions = Param.parameter_value{(strcmp('minimal_num_hit_trials_sessions',Param.parameter_name))};

            
            if (num_ok_or_good_units>=minimal_num_units_sessions && num_trials_hit>=minimal_num_hit_trials_sessions)
                key.good_session_flag =1;
            else
                key.good_session_flag =0;
            end
            
            key.num_ok_or_good_units=num_ok_or_good_units;
            key.num_trials_hit=num_trials_hit;
            key.num_sample_selective_units=num_sample_selective_units;
            key.num_delay_selective_units=num_delay_selective_units;

            insert(self,key);
        end
    end
end