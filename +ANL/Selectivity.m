%{
#
-> EPHYS.Unit
---
unit_selectivity        : longblob    # R-L PSTH
%}


classdef Selectivity < dj.Computed
    properties
        keySource = EXP.Session & EPHYS.TrialSpikes
    end
    methods(Access=protected)
        function makeTuples(self, key)
            electrode_group = [fetchn(EPHYS.Unit & key,'electrode_group')];
            
            PSTH_l = fetchn(ANL.PSTHAverageLR & key  & 'outcome="hit"' & 'trial_type_name="l"','psth_avg', 'ORDER BY unit');
            PSTH_r = fetchn(ANL.PSTHAverageLR & key  & 'outcome="hit"' & 'trial_type_name="r"','psth_avg', 'ORDER BY unit');
            unit = fetchn(ANL.PSTHAverageLR & key  & 'outcome="hit"' & 'trial_type_name="l"','unit', 'ORDER BY unit');
            
            for i_u = 1:1:numel(PSTH_l)
                r =PSTH_r{i_u};
                r(isnan(r))=0;
                l =PSTH_l{i_u};
                l(isnan(l))=0;
                unit_selectivity =r - l;
                
                key(i_u).subject_id=key(1).subject_id;
                key(i_u).session=key(1).session;
                key(i_u).electrode_group=electrode_group(i_u);
                key(i_u).unit=unit(i_u);
                key(i_u).unit_selectivity =unit_selectivity;
            end
            insert(self,key)
        end
    end
end