%{
#
-> EXP.Session
---
num_trials_hit           : int
num_ok_or_good_units     : int
good_session_flag        :smallint
%}


classdef IncludeSession < dj.Computed
    properties
        keySource = (EXP.Session  & EPHYS.Unit);
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            num_ok_or_good_units =numel(fetchn((EPHYS.Unit & ANL.IncludeUnit) & 'unit_quality="ok" or unit_quality="good"' & key,'unit_uid'));
            num_trials_hit =numel(fetch1(ANL.SessionBehavOverview & key,'trials_hit'));
            
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

            insert(self,key);
        end
    end
end