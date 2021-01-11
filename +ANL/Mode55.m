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

classdef Mode55 < dj.Computed
    properties
        %         keySource = EXP.Session & EPHYS.TrialSpikes
        keySource = EXP.Session  & EPHYS.Unit & ANL.IncludeUnit2 & (EPHYS.UnitCellType  & 'cell_type="Pyr"');
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
            tic
            
            psth_t_vector=fetch1(ANL.Parameters & 'parameter_name="psth_t_vector"','parameter_value');
            mintrials_modeweights=fetch1(ANL.Parameters & 'parameter_name="mintrials_modeweights"','parameter_value');
            shuffle_num_for_modeweights=fetch1(ANL.Parameters & 'parameter_name="shuffle_num_for_modeweights"','parameter_value');
            trialfraction_for_modeweights=fetch1(ANL.Parameters & 'parameter_name="trialfraction_for_modeweights"','parameter_value');
            
            k=key;
            
            unit_num=fetchn(((EPHYS.Unit & ANL.IncludeUnit2) * EPHYS.UnitCellType) & k, 'unit', 'ORDER BY unit_uid');
            electrode_group=fetchn(((EPHYS.Unit & ANL.IncludeUnit2) * EPHYS.UnitCellType) & k, 'electrode_group', 'ORDER BY unit_uid');
            
            
            if numel(unit_num)<2
                return;
            end
            psth_t_u_tr = fetch1(ANL.PSTHMatrix & key, 'psth_t_u_tr');
            psth_t_u_tr =psth_t_u_tr(:,unit_num,:);
            
            
            rel = (MISC.S1TrialTypeName * ANL.TrialTypeStimTime * EXP.BehaviorTrial) & key & 'early_lick="no early"' & 'outcome="hit"' ;
            
            
            %% Using all Left and Right trials (including distractors)
            
            % Stimulus
            num = 1;
            label{num} = 'Stimulus';
            trials1{num} = [fetchn( rel &   'stimtm_sample="-2.5"', 'trial', 'ORDER BY trial')];  tint1{num} = [-2.5 -2];
            trials2{num} = [fetchn( rel &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-2.5 -2];
            weights{num} = shuffleModeWeights2(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            
                 
            % LateDelay
            num = 3;
            label{num} = 'LateDelay';
            trials1{num} = [fetchn( rel  & 'stimtm_sample="-2.5"' , 'trial', 'ORDER BY trial')];  tint1{num} = [-1 0] ;
            trials2{num} = [fetchn( rel   &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-1 0] ;
            weights{num} = shuffleModeWeights2(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            
            % Ramping
            num = 4;
            label{num} = 'Ramping';
            trials1{num} = [fetchn( rel , 'trial', 'ORDER BY trial')];  tint1{num} = [-0.5 0];
            trials2{num} = [fetchn( rel  , 'trial', 'ORDER BY trial')];  tint2{num} = [-3.5 -3];
            weights{num} = shuffleModeWeights2(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            
                   
                     
            
            %% Orthogonolize modes to each other via a Gram–Schmidt process - LateDelay Ramping Stimulus
            vectors_set = [weights{3},weights{4},weights{1}]; %order of orthogonalization
            mode_orthogonal = fn_gram_schmidt_process(vectors_set);
            
            % Ramping
            num = 11;
            label{num} = 'Ramping Orthog.1';
            weights{num} = mode_orthogonal(:,2);
            ingestMode (weights{num}, tint1{4}, tint2{4},  key, electrode_group, unit_num, label{num}, num, self );
            
            % Stimulus
            num = 12;
            label{num} = 'Stimulus Orthog.1';
            weights{num} = mode_orthogonal(:,3);
            ingestMode (weights{num}, tint1{1}, tint2{1},  key, electrode_group, unit_num, label{num}, num, self );
            
            
            %% Orthogonolize modes to each other via a Gram–Schmidt process - LateDelay Ramping Stimulus
            vectors_set = [weights{3},weights{1},weights{4}]; %order of orthogonalization
            mode_orthogonal = fn_gram_schmidt_process(vectors_set);
            
        
            % Stimulus
            num = 13;
            label{num} = 'Stimulus Orthog.2';
            weights{num} = mode_orthogonal(:,2);
            ingestMode (weights{num}, tint1{1}, tint2{1},  key, electrode_group, unit_num, label{num}, num, self );
            
            % Ramping
            num = 14;
            label{num} = 'Ramping Orthog.2';
            weights{num} = mode_orthogonal(:,3);
            ingestMode (weights{num}, tint1{4}, tint2{4},  key, electrode_group, unit_num, label{num}, num, self );
            
              % LateDelay
            num = 15;
            label{num} = 'Delay';
            trials1{num} = [fetchn( rel  & 'stimtm_sample="-2.5"' , 'trial', 'ORDER BY trial')];  tint1{num} = [-2 0] ;
            trials2{num} = [fetchn( rel   &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-2 0] ;
            weights{num} = shuffleModeWeights2(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );

            
        end
    end
end