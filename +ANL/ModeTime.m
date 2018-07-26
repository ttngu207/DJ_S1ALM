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

classdef ModeTime < dj.Computed
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
            
            
            t_step=0.1;
            t=-2.5:0.1:1;
            t_window=0.5;
            
            for it=1:1:numel(t)
                % Stimulus
                num = 1;
                label= 'Stimulus';
                
                trials1 = [fetchn( rel &   'stimtm_sample="-2.5"', 'trial', 'ORDER BY trial')];
                tint1 = [t(it)-t_window t(it)];
                trials2 = [fetchn( rel &  'stimtm_sample="1000"', 'trial', 'ORDER BY trial')];
                tint2 = [t(it)-t_window t(it)];
                weights = shuffleModeWeights(psth_t_u_tr,unit_num, trials1, trials2, tint1, tint2, psth_t_vector, mintrials_modeweights, shuffle_num_for_modeweights, trialfraction_for_modeweights);
                ingestMode (weights, tint1, tint2,  key, electrode_group, unit_num, label, num, self );
            end
            
        end
    end
end