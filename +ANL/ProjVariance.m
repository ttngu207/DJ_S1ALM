%{
# Projection of the neural acitivity on a mode (neuron weights vector)
-> EXP.Session
-> EPHYS.CellType
-> EPHYS.UnitQualityType
-> ANL.ModeTypeName
-> ANL.ModeWeightsSign
-> LAB.Hemisphere
-> LAB.BrainArea
-> EXP.Outcome
flag_include_distractor_trials: smallint                    # 0 - no distractor trials included, 1 - distractor trials are included
---
variance_explained_t        : blob            # variance explained proj/psth at time bin t
time_bins              : blob            # time bin vector
%}


classdef ProjVariance < dj.Computed
    properties
        keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr"') * (EPHYS.UnitQualityType & 'unit_quality="all"') * (EXP.Outcome & 'outcome="response"') * (ANL.ModeWeightsSign & 'mode_weights_sign="all"') * (ANL.ModeTypeName & ANL.Mode10);
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
            

            time_window = 0.05;
            time_start = -4.5;
            time_end =2;
            time_bins=  time_start:time_window:time_end;
            k=key;
            
            k = rmfield(k,'outcome');
            if contains(k.unit_quality, 'ok or good')
                rel_Proj =(ANL.ProjTrial100*EXP.BehaviorTrial * ANL.TrialTypeGraphic) & k & 'outcome!="ignore"';
                k = rmfield(k,'unit_quality');
                rel_PSTH = (( ANL.PSTHTrial*EXP.BehaviorTrial * EPHYS.Unit * EPHYS.UnitPosition * EPHYS.UnitCellType * ANL.TrialTypeGraphic ) ) & ANL.IncludeUnit2 & k & 'unit_quality!="multi"' & 'outcome!="ignore"' ;
            elseif contains(k.unit_quality, 'all')
                rel_Proj =( ANL.ProjTrial100 * ANL.TrialTypeGraphic) & k & 'outcome!="ignore"';
                k = rmfield(k,'unit_quality');
                rel_PSTH = (( ANL.PSTHTrial*EXP.BehaviorTrial * EPHYS.Unit * EPHYS.UnitPosition * EPHYS.UnitCellType * ANL.TrialTypeGraphic ) ) & ANL.IncludeUnit2 & k & 'outcome!="ignore"';
            end
            
            
            key.time_bins = time_bins;

            % without distracto trials
            key.flag_include_distractor_trials=0;
            kkk.trialtype_left_and_right_no_distractors = 1;
            trial_var_explained = fn_compute_varaince_DJ (rel_Proj,rel_PSTH , time_bins, kkk);
            if isempty(trial_var_explained)
                return
            end
            key.variance_explained_t = trial_var_explained;
            
            insert(self,key);
            
            % with distracto trials
            key.flag_include_distractor_trials=1;
            kkk=[];
            trial_var_explained = fn_compute_varaince_DJ (rel_Proj,rel_PSTH , time_bins, kkk);
            key.variance_explained_t = trial_var_explained;
            
            insert(self,key);

        end
    end
end