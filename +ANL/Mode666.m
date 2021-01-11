%{
#  Modes in Activity Space
-> EPHYS.Unit
-> ANL.ModeTypeName
mode_time1_st             : double           # beginning of the first time interval used to compute the mode (seconds, relative to go cue).
---
mode_unit_weight  = null  : double           # contribution (weight) of each unit to this mode
mode_time1_end            : double           # end of the first time interval used to compute the mode (seconds, relative to go cue).
mode_time2_st  = null     : double           # beginning of the second time interval used to compute the mode (seconds, relative to go cue).
mode_time2_end  = null    : double           # end of the second time interval used to compute the mode (seconds, relative to go cue).
mode_uid                  : int              # unique id that could be used instead of specifying the mode_name
%}

classdef Mode666 < dj.Computed
    properties
        %         keySource = EXP.Session & EPHYS.TrialSpikes
        %         keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType  & 'cell_type="Pyr"') & (EPHYS.UnitQualityType & 'unit_quality="ok" or unit_quality="good"');
        keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType  & 'cell_type="Pyr"');
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
            
            psth_t_vector=fetch1(ANL.Parameters & 'parameter_name="psth_t_vector"','parameter_value');
            mintrials_modeweights=fetch1(ANL.Parameters & 'parameter_name="mintrials_modeweights"','parameter_value');
            shuffle_num_for_modeweights=fetch1(ANL.Parameters & 'parameter_name="shuffle_num_for_modeweights"','parameter_value');
            trialfraction_for_modeweights=fetch1(ANL.Parameters & 'parameter_name="trialfraction_for_modeweights"','parameter_value');
            
            unit_num=fetchn(((EPHYS.Unit & ANL.IncludeUnit3) * EPHYS.UnitCellType) & key, 'unit', 'ORDER BY unit_uid');
            electrode_group=fetchn(((EPHYS.Unit & ANL.IncludeUnit3) * EPHYS.UnitCellType) & key, 'electrode_group', 'ORDER BY unit_uid');
            
            
            if numel(unit_num)<2
                return;
            end
            psth_t_u_tr = fetch1(ANL.PSTHMatrix & key, 'psth_t_u_tr');
            psth_t_u_tr =psth_t_u_tr(:,unit_num,:);
            
            
            key=rmfield(key,'cell_type');
            
            
            % Using all Left and Right trials (including distractors)
            
            % Stimulus
            rel = (MISC.S1TrialTypeName * ANL.TrialTypeStimTime * EXP.BehaviorTrial) & key & 'early_lick="no early"' & 'outcome!="ignore"' ;
            num = 1;
            label{num} = 'Stimulus';
            trials1{num} = [fetchn( rel &   'stimtm_sample="-2.5"', 'trial', 'ORDER BY trial')];  tint1{num} = [-2.5 -2];
            trials2{num} = [fetchn( rel &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-2.5 -2];
            weights{num} = shuffleModeWeights2(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            
            
            % LateDelay
            rel = (MISC.S1TrialTypeName * ANL.TrialTypeStimTime * EXP.BehaviorTrial) & key & 'early_lick="no early"' & 'outcome="hit"' ;
            num = 3;
            label{num} = 'LateDelay';
            trials1{num} = [fetchn( rel  & 'stimtm_sample="-2.5"' , 'trial', 'ORDER BY trial')];  tint1{num} = [-0.5 0] ;
            trials2{num} = [fetchn( rel   &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-0.5 0] ;
            weights{num} = shuffleModeWeights2(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            
            
            
            % Ramping
            rel = (MISC.S1TrialTypeName * ANL.TrialTypeStimTime * EXP.BehaviorTrial) & key & 'early_lick="no early"' & 'outcome!="ignore"' ;
            num = 4;
            label{num} = 'Ramping';
            trials1{num} = [fetchn( rel , 'trial', 'ORDER BY trial')];  tint1{num} = [-0.5 0];
            trials2{num} = [fetchn( rel  , 'trial', 'ORDER BY trial')];  tint2{num} = [-3.5 -3];
            weights{num} = shuffleModeWeights2(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            
            
            
            
            
            %             %% Orthogonolize modes to each other via a Gram–Schmidt process - LateDelay Ramping Stimulus
            %             vectors_set = [weights{3},weights{4},weights{1}]; %order of orthogonalization
            %             mode_orthogonal = fn_gram_schmidt_process(vectors_set);
            %
            %             % Ramping
            %             num = 11;
            %             label{num} = 'Ramping Orthog.1';
            %             weights{num} = mode_orthogonal(:,2);
            %             ingestMode (weights{num}, tint1{4}, tint2{4},  key, electrode_group, unit_num, label{num}, num, self );
            %
            %             % Stimulus
            %             num = 12;
            %             label{num} = 'Stimulus Orthog.1';
            %             weights{num} = mode_orthogonal(:,3);
            %             ingestMode (weights{num}, tint1{1}, tint2{1},  key, electrode_group, unit_num, label{num}, num, self );
            
            
            %             %% Orthogonolize modes to each other via a Gram–Schmidt process - LateDelay Stimulus Ramping
            %             vectors_set = [weights{3},weights{1},weights{4}]; %order of orthogonalization
            %             mode_orthogonal = fn_gram_schmidt_process(vectors_set);
            %
            %             % Stimulus
            %             num = 13;
            %             label{num} = 'Stimulus Orthog.2';
            %             weights{num} = mode_orthogonal(:,2);
            %             ingestMode (weights{num}, tint1{1}, tint2{1},  key, electrode_group, unit_num, label{num}, num, self );
            %
            %             % Ramping
            %             num = 14;
            %             label{num} = 'Ramping Orthog.2';
            %             weights{num} = mode_orthogonal(:,3);
            %             ingestMode (weights{num}, tint1{4}, tint2{4},  key, electrode_group, unit_num, label{num}, num, self );
            
            
            
            %             % EarlyDelay
            %             rel = (MISC.S1TrialTypeName * ANL.TrialTypeStimTime * EXP.BehaviorTrial) & key & 'early_lick="no early"' & 'outcome="hit"' ;
            %             num = 5;
            %             label{num} = 'EarlyDelay';
            %             trials1{num} = [fetchn( rel  & 'stimtm_sample="-2.5"' , 'trial', 'ORDER BY trial')];  tint1{num} = [-1 0] ;
            %             trials2{num} = [fetchn( rel   &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-1 0] ;
            %             weights{num} = shuffleModeWeights2(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            %             ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            %
            %             % Delay
            %             rel = (MISC.S1TrialTypeName * ANL.TrialTypeStimTime * EXP.BehaviorTrial) & key & 'early_lick="no early"' & 'outcome="hit"' ;
            %             num = 6;
            %             label{num} = 'Delay';
            %             trials1{num} = [fetchn( rel  & 'stimtm_sample="-2.5"' , 'trial', 'ORDER BY trial')];  tint1{num} = [-2 0] ;
            %             trials2{num} = [fetchn( rel   &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-2 0] ;
            %             weights{num} = shuffleModeWeights2(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            %             ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            %
            %             % Delay
            %             rel = (MISC.S1TrialTypeName * ANL.TrialTypeStimTime * EXP.BehaviorTrial) & key & 'early_lick="no early"' & 'outcome="miss"' ;
            %             num = 7;
            %             label{num} = 'Choice';
            %             trials1{num} = [fetchn( rel  &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint1{num} = [-1 0] ;
            %             trials2{num} = [fetchn( rel  & 'stimtm_sample="-2.5"' , 'trial', 'ORDER BY trial')];  tint2{num} = [-1 0] ;
            %             weights{num} = shuffleModeWeights2(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            %             ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            %
            %             % Delay
            %             rel = (MISC.S1TrialTypeName * ANL.TrialTypeStimTime * EXP.BehaviorTrial) & key & 'early_lick="no early"' & 'outcome="miss"' ;
            %             num = 8;
            %             label{num} = 'ChoiceMatched';
            %             trials1{num} = [fetchn( rel  &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint1{num} = [-2 0] ;
            %             trials2{num} = [fetchn( rel  & 'stimtm_sample="-2.5"' , 'trial', 'ORDER BY trial')];  tint2{num} = [-2 0] ;
            %             weights{num} = shuffleModeWeights2(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            %             ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            
            %% Choice mode (using correct and error trials)
            rel_correct = (MISC.S1TrialTypeName * ANL.TrialTypeStimTime * EXP.BehaviorTrial) & key & 'early_lick="no early"' & 'outcome="hit"' & ANL.TrialBehaving;
            rel_error = (MISC.S1TrialTypeName * ANL.TrialTypeStimTime * EXP.BehaviorTrial) & key & 'early_lick="no early"' & 'outcome="miss"' & ANL.TrialBehaving;
            
            % LateDelay
            num = 35;
            label{num} = 'Choice';
            trials_R_correct = [fetchn( rel_correct  & 'stimtm_sample="-2.5"', 'trial', 'ORDER BY trial')];  tint1{num} = [-1 0] ;
            trials_L_correct = [fetchn( rel_correct  & 'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-1 0] ;
            trials_R_error = [fetchn( rel_error  & 'stimtm_sample="-2.5"', 'trial', 'ORDER BY trial')];  tint1{num} = [-1 0] ;
            trials_L_error = [fetchn( rel_error  & 'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-1 0] ;
            weights {num}= computeModeWeights_correct_and_error  (psth_t_u_tr, trials_R_correct, trials_L_correct,trials_R_error, trials_L_error, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            
            
            % LateDelay
            num = 36;
            label{num} = 'ChoiceMatched';
            tint1{num} = [-1 0] ;
            tint2{num} = [-1 0] ;
            smallest_set_num = min([numel(trials_L_correct),numel(trials_R_correct),numel(trials_L_error),numel(trials_R_error)]);
            
            if smallest_set_num>=5
                for i_subsample = 1:1:50
                    weights_subsample(i_subsample,:)= computeModeWeights_correct_and_error_matched  (psth_t_u_tr, trials_R_correct, trials_L_correct,trials_R_error, trials_L_error, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights,smallest_set_num);
                    
                end
                weights{num}=nanmean(weights_subsample,1)';
            else
                weights {num}= computeModeWeights_correct_and_error  (psth_t_u_tr, trials_R_correct, trials_L_correct,trials_R_error, trials_L_error, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights);
            end
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            
            
            
            % LateDelay
            num = 37;
            label{num} = 'Choice2';
            trials_R_correct = [fetchn( rel_correct  & 'stimtm_sample="-2.5"', 'trial', 'ORDER BY trial')];  tint1{num} = [-2 0] ;
            trials_L_correct = [fetchn( rel_correct  & 'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-2 0] ;
            trials_R_error = [fetchn( rel_error  & 'stimtm_sample="-2.5"', 'trial', 'ORDER BY trial')];  tint1{num} = [-2 0] ;
            trials_L_error = [fetchn( rel_error  & 'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-2 0] ;
            weights {num}= computeModeWeights_correct_and_error  (psth_t_u_tr, trials_R_correct, trials_L_correct,trials_R_error, trials_L_error, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            
            
            % LateDelay
            num = 38;
            label{num} = 'ChoiceMatched2';
            tint1{num} = [-2 0] ;
            tint2{num} = [-2 0] ;
            smallest_set_num = min([numel(trials_L_correct),numel(trials_R_correct),numel(trials_L_error),numel(trials_R_error)]);
            
            if smallest_set_num>=5
                for i_subsample = 1:1:50
                    weights_subsample(i_subsample,:)= computeModeWeights_correct_and_error_matched  (psth_t_u_tr, trials_R_correct, trials_L_correct,trials_R_error, trials_L_error, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights,smallest_set_num);
                    
                end
                weights{num}=nanmean(weights_subsample,1)';
            else
                weights {num}= computeModeWeights_correct_and_error  (psth_t_u_tr, trials_R_correct, trials_L_correct,trials_R_error, trials_L_error, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights);
            end
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            
            
            % Delay
            rel = (MISC.S1TrialTypeName * ANL.TrialTypeStimTime * EXP.BehaviorTrial) & key & 'early_lick="no early"' & 'outcome="miss"' ;
            num = 39;
            label{num} = 'Choice3';
            trials1{num} = [fetchn( rel  &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint1{num} = [-1 0] ;
            trials2{num} = [fetchn( rel  & 'stimtm_sample="-2.5"' , 'trial', 'ORDER BY trial')];  tint2{num} = [-1 0] ;
            weights{num} = shuffleModeWeights2(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            
            % Delay
            rel = (MISC.S1TrialTypeName * ANL.TrialTypeStimTime * EXP.BehaviorTrial) & key & 'early_lick="no early"' & 'outcome="miss"' ;
            num = 40;
            label{num} = 'Choice4';
            trials1{num} = [fetchn( rel  &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint1{num} = [-2 0] ;
            trials2{num} = [fetchn( rel  & 'stimtm_sample="-2.5"' , 'trial', 'ORDER BY trial')];  tint2{num} = [-2 0] ;
            weights{num} = shuffleModeWeights2(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            
            
            
        end
    end
end