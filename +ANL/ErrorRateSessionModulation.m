%{
# Projection of the neural acitivity on a mode (neuron weights vector)
-> EXP.Session
-> LAB.BrainArea
-> LAB.Hemisphere
---
num_trials_session_bin                          : int            # number of projected trials in this session time-bin
error_rate_session_time_binned                  : blob       # average error rate, binned according to session time
session_time_binned_vector                      : blob                # contains the relative time bin for computing trials. i.e 0.25 - the first 0-25% of the trials, 0.5 - 25%-50% of the trials etc
%}


classdef ErrorRateSessionModulation < dj.Computed
    properties
        keySource = (EXP.Session  & EPHYS.Unit);
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            k=key;
            
            
            
            prctile_vector= [0 20 40 60 80];
            
            k.session_time_binned_vector = prctile_vector;
            
            rel=EXP.BehaviorTrial & k & 'outcome!="ignore"' & 'early_lick="no early"';
            
            if rel.count<10
                return
            end
            
            Outcome =  (fetchn(rel,'outcome','ORDER BY trial'));
            prctile_start=prctile([1:1:size(Outcome)],prctile_vector);
            prctile_end=prctile([1:1:size(Outcome)],prctile_vector+mean(diff(prctile_vector)));
            for i_prctile=1:1:numel(prctile_start)
                outcome_prctile=Outcome( floor(prctile_start(i_prctile)):ceil(prctile_end(i_prctile)));
                error_rate(i_prctile)=sum(strcmp(outcome_prctile,'hit'))/numel(outcome_prctile);
            end
            k.error_rate_session_time_binned =error_rate;
            k.num_trials_session_bin=floor(prctile_end(1)-prctile_start(1));
            %                         plot(prctile_vector,ramping_slope_prctile)
            %                         hold on;
            insert(self,k);
            
        end
    end
end