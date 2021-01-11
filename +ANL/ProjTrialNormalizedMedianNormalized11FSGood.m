%{
# Trials are scaled to min-max during sample-delay
-> EXP.Session
-> EPHYS.CellType
-> EPHYS.UnitQualityType
-> ANL.ModeWeightsSign
-> EXP.SessionTrial
-> LAB.Hemisphere
-> LAB.BrainArea
-> ANL.ModeTypeName
---
num_units_projected       : int          # number of units projected in this trial
proj_trial                : longblob       # projection of the neural acitivity on the mode (weights vector) for this trial, given in arbitrary units. The time vector is psth_t_vector that could be found in ANL.Parameters
proj_trial_no_outliers    : longblob       # projection without outliers
is_outlier                : int
%}


classdef ProjTrialNormalizedMedianNormalized11FSGood < dj.Computed
    properties
        
        %         keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr" or cell_type="FS" or cell_type="all"') * (EPHYS.UnitQualityType & 'unit_quality="all" or unit_quality="good" or unit_quality="ok or good"') * EXP.Outcome * (ANL.ModeWeightsSign);
        keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="FS"') * (EPHYS.UnitQualityType & 'unit_quality="ok or good"')   * (ANL.ModeWeightsSign & 'mode_weights_sign="all"') *  (ANL.ModeTypeName & 'mode_type_name="ChoiceMatched" or mode_type_name="Ramping Orthog.111"');
        %                             keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr" or cell_type="FS" or cell_type="all"') * (EPHYS.UnitQualityType & 'unit_quality="all" or unit_quality="ok or good"') * EXP.Outcome * (ANL.ModeWeightsSign);
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            k=key;
            Modes = fetch (ANL.Mode11FS & k, '*');
            
            if contains(k.cell_type,'all')
                k = rmfield(k,'cell_type');
            end
            
            if contains(k.unit_quality,'ok or good')
                k = rmfield(k,'unit_quality');
                PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition * ANL.PSTHTrial * EXP.BehaviorTrial) & ANL.IncludeUnit2 & k & 'outcome="hit" or outcome="miss"' & 'unit_quality="ok" or unit_quality="good"' & 'early_lick="no early"', '*');
            else
                if contains(k.unit_quality,'all')
                    k = rmfield(k,'unit_quality');
                end
                PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition * ANL.PSTHTrial * EXP.BehaviorTrial) & ANL.IncludeUnit2 & k & 'outcome="hit" or outcome="miss"' & 'early_lick="no early"', '*');
            end
            Param = struct2table(fetch (ANL.Parameters,'*'));
            
            
            k.trial_instruction='left';
            %             k.trial_type_name='l'
            trial_num_l_hit = fetchn (( EXP.BehaviorTrial * EXP.TrialName)  & k & 'outcome="hit"' & 'early_lick="no early"', 'trial');
            trial_num_l_miss = fetchn (( EXP.BehaviorTrial * EXP.TrialName)  & k & 'outcome="miss"' & 'early_lick="no early"', 'trial');
            
            k.trial_instruction='right';
            %              k.trial_type_name='r';
            trial_num_r_hit = fetchn (( EXP.BehaviorTrial * EXP.TrialName) & k & 'outcome="hit"' & 'early_lick="no early"', 'trial');
            trial_num_r_miss = fetchn (( EXP.BehaviorTrial * EXP.TrialName) & k & 'outcome="miss"' & 'early_lick="no early"', 'trial');
            
            
            trial_num_l =  sort([trial_num_l_hit;trial_num_r_miss],'ascend');
            trial_num_r =  sort([trial_num_r_hit;trial_num_l_miss],'ascend');
            
            
            if numel(unique([PSTH.unit]))>1 %i.e. there are more than one cell
                if ~isempty(PSTH)
                    PSTH = struct2table(PSTH);
                    [key] = fn_projectSingleTrial_populateNormalized_median_left_right5(Modes, PSTH, key,Param, trial_num_l, trial_num_r );
                    insert(self,key);
                end
            end
        end
    end
end