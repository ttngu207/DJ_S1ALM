%{
# Sorted unit
-> EPHYS.Unit
->EXP.TrialNameType
---
unit_total_spikes                           : int       # total number of spikes emitted by the unit during the session
mean_fr_presample                           : double    # mean firing rate (Hz) of the unit in the second before the sample period
mean_fr_sample                           : double    # mean firing rate (Hz) during the sample period
mean_fr_delay                           : double    # mean firing rate (Hz) of the unit in the delay period

%}

classdef UnitFiringRate500ms < dj.Computed
    properties
        keySource=(EXP.Session & EPHYS.Unit)* (EXP.TrialNameType & 'trial_type_name="l" or trial_type_name="r"');
    end
    methods(Access=protected)
        function makeTuples(self, key)
            tic
            %get params
            Param = struct2table(fetch (ANL.Parameters,'*'));
            mintrials_psth_typeoutcome= Param.parameter_value{(strcmp('mintrials_psth_typeoutcome',Param.parameter_name))};
            t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
            t_chirp1 = Param.parameter_value{(strcmp('t_chirp1',Param.parameter_name))};
            t_chirp2 = Param.parameter_value{(strcmp('t_chirp2',Param.parameter_name))};
            trial_start = -4.2;
            trial_end = 3;
            psth_time_bin = Param.parameter_value{(strcmp('psth_time_bin',Param.parameter_name))};
            smooth_time = Param.parameter_value{(strcmp('smooth_time_cell_psth',Param.parameter_name))};
            smooth_bins=ceil(smooth_time/psth_time_bin);
            U = struct2table(fetch(EPHYS.Unit & key,'*'));
            
            % fetch and compute total number of spikes and mean FR
            rel1 = (ANL.TrialSpikesGoAligned*EXP.TrialName) & key; %taking only trials that a had a go cue (i.e. some early lick trials won't be included)
            S=struct2table(fetch(rel1,'*'));
            units = unique([S.unit]);
            
            PSTHAverage = struct2table(fetch(ANL.PSTHAverage & key,'*'));
            PSTHAdaptiveAverage = struct2table(fetch(ANL.PSTHAdaptiveAverage & key,'*'));
            
            psth_t_vector=fetch1(ANL.PSTH & key,'psth_t_vector','LIMIT 1');
            
            for iu=1:1:numel(units)
                iu
                k(iu).subject_id=key.subject_id;
                k(iu).session=key.session;
                k(iu).electrode_group=U.electrode_group(U.unit==units(iu));
                k(iu).unit=units(iu);
                k(iu).task='s1 stim';
                k(iu).trial_type_name=key.trial_type_name;

                
                u_idx_S= (S.unit==units(iu));
                num_trials_in_unit = sum(u_idx_S);
                spike_times_go = cell2mat(S.spike_times_go(u_idx_S));
                k(iu).unit_total_spikes = numel(spike_times_go);
                
                k(iu).mean_fr_presample = sum(spike_times_go>=(t_chirp1-0.5) & spike_times_go<t_chirp1)/ ((0.4)*num_trials_in_unit);
                k(iu).mean_fr_sample = sum(spike_times_go>=(t_chirp2-0.4) & spike_times_go<t_chirp2+0.1)/ ((0.4)*num_trials_in_unit);
                k(iu).mean_fr_delay = sum(spike_times_go>=(t_go-0.5) & spike_times_go<t_go)/ ((0.4)*num_trials_in_unit);

               
            end
            insert(self,k);
            toc
        end
    end
end

