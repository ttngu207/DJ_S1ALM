%{
#  Modes in Activity Space
-> EPHYS.Unit
-> ANL.ModeTypeName                    
mode_time_interval1_st             : double           #  time interval used to compute the mode (start interval, in seconds).
---
mode_unit_weight  = null           : double           # contribution (weight) of each unit to this mode
mode_time_interval1_end            : double           #  time interval used to compute the mode (end time, in seconds).
mode_time_interval2_st  = null     : double           # optional, second time interval used to compute the mode(start interval, in seconds).
mode_time_interval2_end = null     : double           # optional, second time interval used to compute the mode(end interval, in seconds).
mode_uid                           : int              # unique id that could be used instead of specifying the mode_name
%}


classdef Mode < dj.Computed
    properties
        keySource = EXP.Session & EPHYS.TrialSpikes
    end
    methods(Access=protected)
        function makeTuples(self, key)
            tic
            subject_id = key.subject_id;
            session = key.session;
            electrode_group = [fetchn(EPHYS.Unit & key,'electrode_group')];
            psth_t_u_tr = fetch1(ANL.PSTHMatrix & key, 'psth_t_u_tr');
            n_units = size(psth_t_u_tr,2);
            psth_t_vector=fetch1(ANL.Parameters & 'parameter_name="psth_t_vector"','parameter_value');
            mintrials_modeweights=fetch1(ANL.Parameters & 'parameter_name="mintrials_modeweights"','parameter_value');
            shuffle_num_for_modeweights=fetch1(ANL.Parameters & 'parameter_name="shuffle_num_for_modeweights"','parameter_value');
            trialfraction_for_modeweights=fetch1(ANL.Parameters & 'parameter_name="trialfraction_for_modeweights"','parameter_value');
            rel = (MISC.S1TrialTypeName * ANL.TrialTypeStimTime * EXP.BehaviorTrial) & key & 'early_lick="no early"' & 'outcome="hit"' & ANL.TrialBehaving;
            
            % Stimulus
            num = 1;
            label{num} = 'Stimulus';
            trials1{num} = [fetchn( rel  & 'stimtm_presample="1000"' &  'stimtm_sample="-2.5"', 'trial', 'ORDER BY trial')];  tint1{num} = [-2.5 -2.1];
            trials2{num} = [fetchn( rel  & 'stimtm_presample="1000"' &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-2.5 -2.1];
            weights{num} = shuffleModeWeights(psth_t_u_tr,n_units, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, n_units, label{num}, num );
            
            % EarlyDelay
            num = 2;
            label{num}  = 'EarlyDelay';
            trials1{num} = [fetchn( rel  & 'stimtm_presample="1000"' &  'stimtm_sample="-2.5"', 'trial', 'ORDER BY trial')];  tint1{num} = [-2 -1.6] ;
            trials2{num} = [fetchn( rel  & 'stimtm_presample="1000"' &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-2 -1.6] ;
            weights{num} = shuffleModeWeights(psth_t_u_tr,n_units, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, n_units, label{num}, num );
            
            % LateDelay
            num = 3;
            label{num} = 'LateDelay';
            trials1{num} = [fetchn( rel  & 'stimtm_presample="1000"' &  'stimtm_sample="-2.5"' & 'stimtm_earlydelay="1000"' & 'stimtm_latedelay="1000"', 'trial', 'ORDER BY trial')];  tint1{num} = [-0.4 0] ;
            trials2{num} = [fetchn( rel  & 'stimtm_presample="1000"' &  'stimtm_sample="1000"' & 'stimtm_earlydelay="1000"' & 'stimtm_latedelay="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-0.4 0] ;
            weights{num} = shuffleModeWeights(psth_t_u_tr,n_units, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, n_units, label{num}, num );
            
            % Ramping
            num = 4;
            label{num} = 'Ramping';
            trials1{num} = [fetchn( rel  & 'stimtm_presample="1000"' & 'stimtm_earlydelay="1000"' & 'stimtm_latedelay="1000"', 'trial', 'ORDER BY trial')];  tint1{num} = [-1 0] ;
            trials2{num} = [fetchn( rel  & 'stimtm_presample="1000"' & 'stimtm_earlydelay="1000"', 'trial', 'ORDER BY trial')];  tint2{num} = [-2 -1] ;
            weights{num} = shuffleModeWeights(psth_t_u_tr,n_units, trials1{num}, trials2{num}, tint1{num}, tint2{num}, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
            ingestMode (weights{num}, tint1{num}, tint2{num},  key, electrode_group, n_units, label{num}, num );
            
            %% Orthogonolize  X directions to Y direction 
            
            % EarlyDelay without LateDelay
            num = 5;
            label{num}  = 'Stimulus orthogonal to LateDelay';
            weights{num} = fn_orthogonalize(weights{1}, weights{3});
            ingestMode (weights{num}, tint1{1}, tint2{1},  key, electrode_group, n_units, label{num}, num );

            
            % EarlyDelay without LateDelay
            num = 6;
            label{num}  = 'EarlyDelay orthogonal to LateDelay';
            weights{num} = fn_orthogonalize(weights{2}, weights{3});
            ingestMode (weights{num}, tint1{2}, tint2{2},  key, electrode_group, n_units, label{num}, num );

            % Ramping without LateDelay
            num = 7;
            label{num}  = 'Ramping orthogonal to LateDelay';
            weights{num} = fn_orthogonalize(weights{4}, weights{3});
            ingestMode (weights{num}, tint1{4}, tint2{4},  key, electrode_group, n_units, label{num}, num );

            
            % LateDelay without EarlyDelay
            num = 8;
            label{num}  = 'LateDelay orthogonal to EarlyDelay';
            weights{num} = fn_orthogonalize(weights{3}, weights{2});
            ingestMode (weights{num}, tint1{3}, tint2{3},  key, electrode_group, n_units, label{num}, num );
            
                       
        end
    end
end