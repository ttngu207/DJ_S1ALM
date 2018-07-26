%{
# Projection of the neural acitivity on a mode (neuron weights vector)
-> EXP.Session
-> LAB.Hemisphere
-> LAB.BrainArea
-> EPHYS.CellType
-> EPHYS.UnitQualityType
-> ANL.ModeTypeName
-> ANL.ModeWeightsSign
-> EXP.TrialNameType
-> EXP.Outcome
mode_time1_st             : double           # beginning of the first time interval used to compute the mode (seconds, relative to go cue).

---
num_trials_projected        : int            # number of projected trials in this trial-type/outcome
num_units_projected         : int            # number of units projected in this trial-type/outcome

proj_average                : longblob       # projection of the neural acitivity on the mode (weights vector) for this trial-type/outcome, given in arbitrary units. The time vector is psth_t_vector that could be found in ANL.Parameters

%}


classdef ProjTrialAdaptiveAverageTime < dj.Computed
    properties
        keySource = (EXP.Session  & EPHYS.Unit) * (EPHYS.CellType & 'cell_type="Pyr" or cell_type="FS" or cell_type="all"') * (EPHYS.UnitQualityType & 'unit_quality="all" or unit_quality="good" or unit_quality="ok or good"') * EXP.Outcome * ANL.ModeWeightsSign ;

    end
    methods(Access=protected)
        function makeTuples(self, key)
            key.task = fetch1(EXP.SessionTask & key,'task');
            
            k=key;
                        ModeTime = fetch (ANL.ModeTime  & k, '*');

            if contains(k.cell_type,'all')
                k = rmfield(k,'cell_type');
            end
            
            if contains(k.unit_quality,'ok or good')
                k = rmfield(k,'unit_quality');
                %                 Modes = fetch ((ANL.Mode * EXP.SessionID * EPHYS.Unit  * EPHYS.UnitCellType) & ANL.IncludeUnit & k & 'unit_quality="ok" or unit_quality="good"', '*');
                PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition * ANL.PSTHAdaptiveAverage) & ANL.IncludeUnit & k & 'unit_quality="ok" or unit_quality="good"', '*');
            else
                if contains(k.unit_quality,'all')
                    k = rmfield(k,'unit_quality');
                end
                %                 Modes = fetch ((ANL.Mode * EXP.SessionID * EPHYS.Unit  * EPHYS.UnitCellType) & ANL.IncludeUnit & k, '*');
                PSTH = fetch ((EXP.SessionID * EPHYS.Unit * EPHYS.UnitCellType * EPHYS.UnitPosition * ANL.PSTHAdaptiveAverage) & ANL.IncludeUnit & k, '*');
            end
            
            
            
            
            Param = struct2table(fetch (ANL.Parameters,'*'));
            
            if numel(unique([PSTH.unit]))>1 %i.e. there are more than one cell
                if ~isempty(PSTH)
                    PSTH = struct2table(PSTH);
                    mode_times = unique([ModeTime.mode_time1_st])';
                    counter=1;
                    key(1).mode_time1_st=[];
                    for it = 1:1:numel(mode_times)
                        M = ModeTime([ModeTime.mode_time1_st] == mode_times(it));
                        key_idx = size(key,2);
                        if key_idx==1
                            key_idx=0;
                        end
                        [key, counter] = fn_projectTrialAvg_populate(M, PSTH, key, counter,Param);
                        
                        for ic=(key_idx+1):1:(counter-1)
                        key(ic).mode_time1_st=mode_times(it);
                        end
                    end
                    insert(self,key);
                end
            end
        end
    end
end