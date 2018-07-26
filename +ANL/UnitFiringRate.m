%{
# Sorted unit
-> EPHYS.Unit
smoothing_time_peak_fr                      : double       # smoothing time window (seconds) used to compute the peak firing rates
---
unit_total_spikes                           : int       # total number of spikes emitted by the unit during the session
mean_fr                                     : double    # mean firing rate (Hz) of the unit for the entire trial duration
mean_fr_presample                           : double    # mean firing rate (Hz) of the unit in the second before the sample period
mean_fr_sample                           : double    # mean firing rate (Hz) during the sample period
mean_fr_delay                           : double    # mean firing rate (Hz) of the unit in the delay period
mean_fr_sample_delay                        : double    # mean firing rate (Hz) of the unit during sample and delay periods
mean_fr_response                            : double    # mean firing rate (Hz) of the unit during the response period

peak_fr                                     : double    # peak firing rate (Hz) of the unit for the entire trial duration, psth averaged for each trial-type and the highest peak is chosen from the averaged psths
peak_fr_sample_delay                        : double    # mean firing rate (Hz) of the unit during sample and delay periods, psth averaged for each trial-type and the highest peak is chosen from the averaged psths
peak_fr_response                            : double    # mean firing rate (Hz) of the unit during the response period, psth averaged for each trial-type and the highest peak is chosen from the averaged psths
peak_fr_basic_trials                        : double    # peak firing rate (Hz) of the unit for the entire trial duration, psth averaged for  basic left/right trialy types (without addionatal photostims) and the highest peak is chosen from the averaged psths
peak_fr_sample_delay_basic_trials           : double    # mean firing rate (Hz) of the unit during sample and delay periods, psth averaged for  basic left/right trialy types (without addionatal photostims) and the highest peak is chosen from the averaged psths
peak_fr_response_basic_trials               : double    # mean firing rate (Hz) of the unit during the response period, psth averaged for  basic left/right trialy types (without addionatal photostims) and the highest peak is chosen from the averaged psths

adaptive_peak_fr                            : double    # peak firing rate (Hz) of the unit for the entire trial duration, adaptive psth averaged for each trial-type and the highest peak is chosen from the averaged psths
adaptive_peak_fr_sample_delay               : double    # mean firing rate (Hz) of the unit during sample and delay periods, adaptive psth averaged for each trial-type and the highest peak is chosen from the averaged psths
adaptive_peak_fr_response                   : double    # mean firing rate (Hz) of the unit during the response period, adaptive psth averaged for each trial-type and the highest peak is chosen from the averaged psths
adaptive_peak_fr_basic_trials               : double    # peak firing rate (Hz) of the unit for the entire trial duration, adaptive psth averaged for  basic left/right trialy types (without addionatal photostims) and the highest peak is chosen from the averaged psths
adaptive_peak_fr_sample_delay_basic_trials  : double    # mean firing rate (Hz) of the unit during sample and delay periods, adaptive psth averaged for  basic left/right trialy types (without addionatal photostims) and the highest peak is chosen from the averaged psths
adaptive_peak_fr_response_basic_trials      : double    # mean firing rate (Hz) of the unit during the response period, adaptive psth averaged for  basic left/right trialy types (without addionatal photostims) and the highest peak is chosen from the averaged psths

%}

classdef UnitFiringRate < dj.Computed
    properties
        keySource=EXP.Session & EPHYS.Unit;
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
            rel1 = (ANL.TrialSpikesGoAligned) & key; %taking only trials that a had a go cue (i.e. some early lick trials won't be included)
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
              
                k(iu).smoothing_time_peak_fr = smooth_time;
                
                u_idx_S= (S.unit==units(iu));
                num_trials_in_unit = sum(u_idx_S);
                spike_times_go = cell2mat(S.spike_times_go(u_idx_S));
                k(iu).unit_total_spikes = numel(spike_times_go);
                
                k(iu).mean_fr = sum(spike_times_go>=trial_start & trial_end>spike_times_go)/ ((trial_end-trial_start)*num_trials_in_unit);
                k(iu).mean_fr_presample = sum(spike_times_go>=(t_chirp1-1) & spike_times_go<t_chirp1)/ ((1)*num_trials_in_unit);
                k(iu).mean_fr_sample = sum(spike_times_go>=(t_chirp2-0.4) & spike_times_go<t_chirp2)/ ((0.4)*num_trials_in_unit);
                k(iu).mean_fr_delay = sum(spike_times_go>=(t_go-2) & spike_times_go<t_go)/ ((2)*num_trials_in_unit);

                k(iu).mean_fr_sample_delay = sum(spike_times_go>=t_chirp1 & t_go>spike_times_go)/ ((t_go-t_chirp1)*num_trials_in_unit);
                k(iu).mean_fr_response = sum(spike_times_go>=t_go & trial_end>spike_times_go)/ ((trial_end-t_go)*num_trials_in_unit);
                
                
                u_idx_PSTH= (PSTHAverage.unit==units(iu));
                PSTH_U = PSTHAverage(u_idx_PSTH,:);
                
                for ipsth = 1:1:numel(find(u_idx_PSTH))
                    psth_avg = smooth(PSTH_U.psth_avg(ipsth,:),smooth_bins);
                    if PSTH_U.num_trials_averaged (ipsth)<mintrials_psth_typeoutcome
                        psth_avg=psth_avg+NaN;
                    end
                    peak_fr(ipsth) = nanmax(psth_avg);
                    peak_fr_sample_delay(ipsth) = nanmax(psth_avg((psth_t_vector>=t_chirp1 & t_go>psth_t_vector)));
                    peak_fr_response(ipsth) = nanmax(psth_avg((psth_t_vector>=t_go & trial_end>psth_t_vector)));
                end
                ix_basic_trials_types=strcmp(PSTH_U.trial_type_name,'l') | strcmp(PSTH_U.trial_type_name,'r'); %trial types without distractor
                
                k(iu).peak_fr = nanmax([0,peak_fr]);
                k(iu).peak_fr_sample_delay = nanmax([0,peak_fr_sample_delay]);
                k(iu).peak_fr_response = nanmax([0,peak_fr_response]);
                
                k(iu).peak_fr_basic_trials = nanmax([0,peak_fr(ix_basic_trials_types)]);
                k(iu).peak_fr_sample_delay_basic_trials = nanmax([0,peak_fr_sample_delay(ix_basic_trials_types)]);
                k(iu).peak_fr_response_basic_trials = nanmax([0,peak_fr_response(ix_basic_trials_types)]);
                
                
                u_idx_PSTH=[];
                PSTH_U=[];
                
                u_idx_PSTH= (PSTHAdaptiveAverage.unit==units(iu));
                PSTH_U = PSTHAverage(u_idx_PSTH,:);
                
                for ipsth = 1:1:numel(find(u_idx_PSTH))
                    psth_avg = smooth(PSTH_U.psth_avg(ipsth,:),smooth_bins);
                    if PSTH_U.num_trials_averaged (ipsth)<mintrials_psth_typeoutcome
                        psth_avg=psth_avg+NaN;
                    end
                    adaptive_peak_fr(ipsth) = nanmax(psth_avg);
                    adaptive_peak_fr_sample_delay(ipsth) = nanmax(psth_avg((psth_t_vector>=t_chirp1 & t_go>psth_t_vector)));
                    adaptive_peak_fr_response(ipsth) = nanmax(psth_avg((psth_t_vector>=t_go & trial_end>psth_t_vector)));
                end
                ix_basic_trials_types=strcmp(PSTH_U.trial_type_name,'l') | strcmp(PSTH_U.trial_type_name,'r'); %trial types withot distractor
                
                k(iu).adaptive_peak_fr = nanmax([0,adaptive_peak_fr]);
                k(iu).adaptive_peak_fr_sample_delay = nanmax([0,adaptive_peak_fr_sample_delay]);
                k(iu).adaptive_peak_fr_response = nanmax([0,adaptive_peak_fr_response]);
                
                k(iu).adaptive_peak_fr_basic_trials = nanmax([0,adaptive_peak_fr(ix_basic_trials_types)]);
                k(iu).adaptive_peak_fr_sample_delay_basic_trials = nanmax([0,adaptive_peak_fr_sample_delay(ix_basic_trials_types)]);
                k(iu).adaptive_peak_fr_response_basic_trials = nanmax([0,adaptive_peak_fr_response(ix_basic_trials_types)]);
                
            end
            insert(self,k);
            toc
        end
    end
end

