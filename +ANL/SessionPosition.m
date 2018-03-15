%{
# Brain Areas recorded in this session
-> EXP.Session
-> LAB.Hemisphere
-> LAB.BrainArea
---

%}


classdef SessionPosition < dj.Computed
    properties
        keySource = EXP.Session & EPHYS.TrialSpikes
    end
    methods(Access=protected)
        function makeTuples(self, key)
            hemisphere = cellstr(unique(fetchn(EPHYS.UnitPosition & key, 'hemisphere')));
            brain_area= unique(fetchn(EPHYS.UnitPosition & key, 'brain_area'));
            key.hemisphere = hemisphere{1};
            key.brain_area = brain_area{1};
            insert(self,key);
        end
    end
end