%{
#  Modes in Activity Space
-> EPHYS.Unit
-> ANL.ModeTypeName
-> EPHYS.CellType
-> EPHYS.UnitQualityType
mode_time1_st             : double           # beginning of the first time interval used to compute the mode (seconds, relative to go cue).
---
mode_unit_weight  = null  : double           # contribution (weight) of each unit to this mode
mode_time1_end            : double           # end of the first time interval used to compute the mode (seconds, relative to go cue).
mode_time2_st  = null     : double           # beginning of the second time interval used to compute the mode (seconds, relative to go cue).
mode_time2_end  = null    : double           # end of the second time interval used to compute the mode (seconds, relative to go cue).
mode_uid                  : int              # unique id that could be used instead of specifying the mode_name
%}

classdef Mode < dj.Computed
    properties
        %         keySource = EXP.Session & EPHYS.TrialSpikes
        keySource = (EXP.Session  & EPHYS.Unit & ANL.IncludeUnit) * (EPHYS.CellType & 'cell_type="Pyr" or cell_type="FS" or cell_type="all"') * (EPHYS.UnitQualityType & 'unit_quality="all" or unit_quality="good" or unit_quality="ok or good"');
        
    end
    methods(Access=protected)
        function makeTuples(self, key)
            tic
            subject_id = key.subject_id;
            session = key.session;
            psth_t_vector=fetch1(ANL.Parameters & 'parameter_name="psth_t_vector"','parameter_value');
            mintrials_modeweights=fetch1(ANL.Parameters & 'parameter_name="mintrials_modeweights"','parameter_value');
            shuffle_num_for_modeweights=fetch1(ANL.Parameters & 'parameter_name="shuffle_num_for_modeweights"','parameter_value');
            trialfraction_for_modeweights=fetch1(ANL.Parameters & 'parameter_name="trialfraction_for_modeweights"','parameter_value');
            
            
            k=key;
            if contains(k.cell_type,'all')
                k = rmfield(k,'cell_type');
            end
            
            if contains(k.unit_quality,'all')
                k = rmfield(k,'unit_quality');
                unit_num=fetchn(((EPHYS.Unit & ANL.IncludeUnit) * EPHYS.UnitCellType) & k, 'unit', 'ORDER BY unit_uid');
                electrode_group=fetchn(((EPHYS.Unit & ANL.IncludeUnit) * EPHYS.UnitCellType) & k, 'electrode_group', 'ORDER BY unit_uid');
            else
                if contains(k.unit_quality,'ok or good')
                    k = rmfield(k,'unit_quality');
                    unit_num=fetchn(((EPHYS.Unit & ANL.IncludeUnit) * EPHYS.UnitCellType) & k & 'unit_quality="ok" or unit_quality="good"', 'unit', 'ORDER BY unit_uid');
                    electrode_group=fetchn(((EPHYS.Unit & ANL.IncludeUnit) * EPHYS.UnitCellType) & k & 'unit_quality="ok" or unit_quality="good"', 'electrode_group', 'ORDER BY unit_uid');
                else
                    unit_num=fetchn(((EPHYS.Unit & ANL.IncludeUnit) * EPHYS.UnitCellType) & k, 'unit', 'ORDER BY unit_uid');
                    electrode_group=fetchn(((EPHYS.Unit & ANL.IncludeUnit) * EPHYS.UnitCellType) & k, 'electrode_group', 'ORDER BY unit_uid');
                end
            end
            
            if numel(unit_num)<2
                return;
            end
            psth_t_u_tr = fetch1(ANL.PSTHMatrix & key, 'psth_t_u_tr');
            psth_t_u_tr =psth_t_u_tr(:,unit_num,:);
            
            
            rel = (MISC.S1TrialTypeName * ANL.TrialTypeStimTime * EXP.BehaviorTrial) & key & 'early_lick="no early"' & 'outcome="hit"' & ANL.TrialBehaving;
            
            % Stimulus
            num = 1;
            label{num} = 'Stimulus';
%             trials1{num} = [fetchn( rel  & 'stimtm_presample="1000"' &  'stimtm_sample="-2.5"', 'trial', 'ORDER BY trial')];  tint1{num} = [-2.5 -2.0];
%             trials2{num} = [fetchn( rel  & 'stimtm_presample="1000"' &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-2.5 -2.0];
                        trials1{num} = [fetchn( rel &   'stimtm_sample="-2.5"', 'trial', 'ORDER BY trial')];  tint1{num} = [-2.5 -2];
                        trials2{num} = [fetchn( rel &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-2.5 -2];
            weights{num} = shuffleModeWeights(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            
            % EarlyDelay
            num = 2;
            label{num}  = 'EarlyDelay';
%             trials1{num} = [fetchn( rel  & 'stimtm_presample="1000"' &  'stimtm_sample="-2.5"', 'trial', 'ORDER BY trial')];  tint1{num} = [-2 -1] ;
%             trials2{num} = [fetchn( rel  & 'stimtm_presample="1000"' &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-2 -1] ;
                        trials1{num} = [fetchn( rel  &  'stimtm_sample="-2.5"', 'trial', 'ORDER BY trial')];  tint1{num} = [-2 -1] ;
                        trials2{num} = [fetchn( rel  &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-2 -1] ;
            weights{num} = shuffleModeWeights(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            
            % LateDelay
            num = 3;
            label{num} = 'LateDelay';
%             trials1{num} = [fetchn( rel  & 'stimtm_presample="1000"' &  'stimtm_sample="-2.5"' & 'stimtm_earlydelay="1000"' & 'stimtm_latedelay="1000"', 'trial', 'ORDER BY trial')];  tint1{num} = [-1 0] ;
%             trials2{num} = [fetchn( rel  & 'stimtm_presample="1000"' &  'stimtm_sample="1000"' & 'stimtm_earlydelay="1000"' & 'stimtm_latedelay="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-1 0] ;
                        trials1{num} = [fetchn( rel  & 'stimtm_sample="-2.5"' , 'trial', 'ORDER BY trial')];  tint1{num} = [-0.5 0] ;
                        trials2{num} = [fetchn( rel   &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-0.5 0] ;
            
            weights{num} = shuffleModeWeights(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            
            % Ramping
            num = 4;
            label{num} = 'Ramping';
            %             trials1{num} = [fetchn( rel  & 'stimtm_presample="1000"' & 'stimtm_earlydelay="1000"' & 'stimtm_latedelay="1000"', 'trial', 'ORDER BY trial')];  tint1{num} = [-0.5 0] ; %tint1{num} = [-1 0] ;
            %             trials2{num} = [fetchn( rel  & 'stimtm_presample="1000"' & 'stimtm_earlydelay="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-3.5 -3] ; %tint2{num} = [-2 -1] ;
            trials1{num} = [fetchn( rel , 'trial', 'ORDER BY trial')];  tint1{num} = [-0.5 0] ; %tint1{num} = [-1 0] ;
            trials2{num} = [fetchn( rel  , 'trial', 'ORDER BY trial')];  tint2{num} = [-3.5 -3] ; %tint2{num} = [-2 -1] ;
            weights{num} = shuffleModeWeights(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            
            % Movement
            num = 5;
            label{num} = 'Movement';
            %             trials1{num} = [fetchn( rel  & 'stimtm_presample="1000"' &  'stimtm_sample="-2.5"' & 'stimtm_earlydelay="1000"' & 'stimtm_latedelay="1000"', 'trial', 'ORDER BY trial')];  tint1{num} = [0 0.4] ;
            %             trials2{num} = [fetchn( rel  & 'stimtm_presample="1000"' &  'stimtm_sample="1000"' & 'stimtm_earlydelay="1000"' & 'stimtm_latedelay="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [0 0.4] ;
            trials1{num} = [fetchn( rel & 'stimtm_sample="-2.5"' , 'trial', 'ORDER BY trial')];  tint1{num} = [0 0.5] ;
            trials2{num} = [fetchn( rel &  'stimtm_sample="1000"' , 'trial', 'ORDER BY trial')];  tint2{num} = [0 0.5] ;
            weights{num} = shuffleModeWeights(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            
            %             % MiddleDelay
            %             num = 6;
            %             label{num}  = 'MiddleDelay';
            %             %             trials1{num} = [fetchn( rel  & 'stimtm_presample="1000"' &  'stimtm_sample="-2.5"', 'trial', 'ORDER BY trial')];
            %             %             trials2{num} = [fetchn( rel  & 'stimtm_presample="1000"' &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];
            %             trials1{num} = [fetchn( rel  &  'stimtm_sample="-2.5"', 'trial', 'ORDER BY trial')];  tint1{num} = [-1.5 -1] ;
            %             trials2{num} = [fetchn( rel  &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-1.5 -1] ;
            %             weights{num} = shuffleModeWeights(psth_t_u_tr,n_units, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            %             ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, n_units, label{num}, num, self );
            
            % %% Orthogonolize  all the modes to each other via a Gram–Schmidt process
            %             vectors_set = [weights{1},weights{2},weights{3},weights{4},weights{5}]
            %
            %             mode_orthogonal = fn_gram_schmidt_process(vectors_set)
            %
            %             % Stimulus
            %             num = 11;
            %             label{num} = 'Stimulus Orthog.';
            %             weights{num} = mode_orthogonal(:,1);
            %             ingestMode (weights{num}, tint1{1}, tint2{1},  key, electrode_group, n_units, label{num}, num, self );
            %
            %             % EarlyDelay
            %             num = 12;
            %             label{num}  = 'EarlyDelay Orthog.';
            %           weights{num} = mode_orthogonal(:,2);
            %             ingestMode (weights{num}, tint1{2}, tint2{2},  key, electrode_group, n_units, label{num}, num, self );
            %
            %             % LateDelay
            %             num = 13;
            %             label{num} = 'LateDelay Orthog.';
            %           weights{num} = mode_orthogonal(:,3);
            %             ingestMode (weights{num}, tint1{3}, tint2{3},  key, electrode_group, n_units, label{num}, num, self );
            %
            %             % Ramping
            %             num = 14;
            %             label{num} = 'Ramping Orthog.';
            %             weights{num} = mode_orthogonal(:,4);
            %             ingestMode (weights{num}, tint1{4}, tint2{4},  key, electrode_group, n_units, label{num}, num, self );
            %
            %             % Movement
            %             num = 15;
            %             label{num} = 'Movement Orthog.';
            %             weights{num} = mode_orthogonal(:,5);
            %             ingestMode (weights{num}, tint1{5}, tint2{5},  key, electrode_group, n_units, label{num}, num, self );
            
            
            
            
            %% Orthogonolize  all the modes to each other via a Gram–Schmidt process
            vectors_set = [weights{3},weights{4},weights{1},weights{2},weights{5}];
            
            mode_orthogonal = fn_gram_schmidt_process(vectors_set);
            
            % Stimulus
            num = 11;
            label{num} = 'Stimulus Orthog.';
            weights{num} = mode_orthogonal(:,3);
            ingestMode (weights{num}, tint1{1}, tint2{1},  key, electrode_group, unit_num, label{num}, num, self );
            
            % EarlyDelay
            num = 12;
            label{num}  = 'EarlyDelay Orthog.';
            weights{num} = mode_orthogonal(:,4);
            ingestMode (weights{num}, tint1{2}, tint2{2},  key, electrode_group, unit_num, label{num}, num, self );
            
            % LateDelay
            num = 13;
            label{num} = 'LateDelay Orthog.';
            weights{num} = mode_orthogonal(:,1);
            ingestMode (weights{num}, tint1{3}, tint2{3},  key, electrode_group, unit_num, label{num}, num, self );
            
            % Ramping
            num = 14;
            label{num} = 'Ramping Orthog.';
            weights{num} = mode_orthogonal(:,2);
            ingestMode (weights{num}, tint1{4}, tint2{4},  key, electrode_group, unit_num, label{num}, num, self );
            
            % Movement
            num = 15;
            label{num} = 'Movement Orthog.';
            weights{num} = mode_orthogonal(:,5);
            ingestMode (weights{num}, tint1{5}, tint2{5},  key, electrode_group, unit_num, label{num}, num, self );
            
            %% Additional modes
            
            % Left vs. baseline
            num = 16;
            label{num} = 'Left vs. baseline';
            trials1{num} = [fetchn( rel &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint1{num} = [-0.5 0] ; %tint1{num} = [-1 0] ;
            trials2{num} = [fetchn( rel &  'stimtm_sample="1000"' , 'trial', 'ORDER BY trial')];  tint2{num} = [-3.5 -3] ; %tint2{num} = [-2 -1] ;
            weights{num} = shuffleModeWeights(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );
            
            % Right vs. baseline
            num = 17;
            label{num} = 'Right vs. baseline';
            trials1{num} = [fetchn( rel &  'stimtm_sample="-2.5"', 'trial', 'ORDER BY trial')];  tint1{num} = [-0.5 0] ; %tint1{num} = [-1 0] ;
            trials2{num} = [fetchn( rel &  'stimtm_sample="-2.5"' , 'trial', 'ORDER BY trial')];  tint2{num} = [-3.5 -3] ; %tint2{num} = [-2 -1] ;
            weights{num} = shuffleModeWeights(psth_t_u_tr,unit_num, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, unit_num, label{num}, num, self );

            
            %% Orthogonolize  X directions to Y direction
            
            
            %             % Stimulus without LateDelay
            %             num = 7;
            %             label{num}  = 'Stimulus orthogonal to LateDelay';
            %             weights{num} = fn_orthogonalize(weights{1}, weights{3});
            %             ingestMode (weights{num}, tint1{1}, tint2{1},  key, electrode_group, n_units, label{num}, num, self );
            %
            %
            %             % EarlyDelay without LateDelay
            %             num = 8;
            %             label{num}  = 'EarlyDelay orthogonal to LateDelay';
            %             weights{num} = fn_orthogonalize(weights{2}, weights{3});
            %             ingestMode (weights{num}, tint1{2}, tint2{2},  key, electrode_group, n_units, label{num}, num, self );
            %
            %             % Ramping without LateDelay
            %             num = 9;
            %             label{num}  = 'Ramping orthogonal to LateDelay';
            %             weights{num} = fn_orthogonalize(weights{4}, weights{3});
            %             ingestMode (weights{num}, tint1{4}, tint2{4},  key, electrode_group, n_units, label{num}, num, self );
            %
            %
            %             % LateDelay without EarlyDelay
            %             num = 10;
            %             label{num}  = 'LateDelay orthogonal to EarlyDelay';
            %             weights{num} = fn_orthogonalize(weights{3}, weights{2});
            %             ingestMode (weights{num}, tint1{3}, tint2{3},  key, electrode_group, n_units, label{num}, num, self );
            %
            %             % Movement without LateDelay
            %             num = 11;
            %             label{num}  = 'Movement orthogonal to LateDelay';
            %             weights{num} = fn_orthogonalize(weights{5}, weights{3});
            %             ingestMode (weights{num}, tint1{5}, tint2{5},  key, electrode_group, n_units, label{num}, num, self );
            %
            %             % LateDelay without Movement
            %             num = 12;
            %             label{num}  = 'LateDelay orthogonal to Movement';
            %             weights{num} = fn_orthogonalize(weights{3}, weights{5});
            %             ingestMode (weights{num}, tint1{3}, tint2{3},  key, electrode_group, n_units, label{num}, num, self );
            %
            %             % Stimulus without EarlyDelay
            %             num = 13;
            %             label{num}  = 'Stimulus orthogonal to EarlyDelay';
            %             weights{num} = fn_orthogonalize(weights{1}, weights{2});
            %             ingestMode (weights{num}, tint1{1}, tint2{1},  key, electrode_group, n_units, label{num}, num, self );
            %
            % %             % MiddleDelay without LateDelay
            % %             num = 13;
            % %             label{num}  = 'MiddleDelay orthogonal to LateDelay';
            % %             weights{num} = fn_orthogonalize(weights{6}, weights{3});
            % %             ingestMode (weights{num}, tint1{6}, tint2{6},  key, electrode_group, n_units, label{num}, num, self );
            
        end
    end
end