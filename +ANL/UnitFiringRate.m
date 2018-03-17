%{
# Sorted unit
-> EPHYS.Unit
smoothing_time_peak_fr             : int       # smoothing time window (seconds) used to compute the peak firing rates
---
unit_unit_total_spikes             : int       # total number of spikes emitted by the unit during the session
mean_fr                            : double    # mean firing rate (Hz) of the unit for the entire trial duration
mean_fr_sample_delay               : double    # mean firing rate (Hz) of the unit during sample and delay periods
mean_fr_response                   : double    # mean firing rate (Hz) of the unit during the response period
peak_fr                            : double    # peak firing rate (Hz) of the unit for the entire trial duration, psth averaged for each trial-type and the highest peak is chosen from the averaged psths
peak_fr_sample_delay               : double    # mean firing rate (Hz) of the unit during sample and delay periods, psth averaged for each trial-type and the highest peak is chosen from the averaged psths
peak_fr_response                   : double    # mean firing rate (Hz) of the unit during the response period, psth averaged for each trial-type and the highest peak is chosen from the averaged psths
peak_fr_basic_trials               : double    # peak firing rate (Hz) of the unit for the entire trial duration, psth averaged for  basic left/right trialy types (without addionatal photostims) and the highest peak is chosen from the averaged psths
peak_fr_sample_delay_basic_trials  : double    # mean firing rate (Hz) of the unit during sample and delay periods, psth averaged for  basic left/right trialy types (without addionatal photostims) and the highest peak is chosen from the averaged psths
peak_fr_response_basic_trials      : double    # mean firing rate (Hz) of the unit during the response period, psth averaged for  basic left/right trialy types (without addionatal photostims) and the highest peak is chosen from the averaged psths
%}
classdef UnitFiringRate < dj.Computed
    
    methods(Access=protected)
        function makeTuples(self, key)
            Param = struct2table(fetch (ANL.Parameters,'*'));

            rel = ((EPHYS.TrialSpikes * EXP.BehaviorTrialEvent) & ('trial_event_type="go"')) & key; %taking only trials that a had a go coue (i.e. no early licks)
            key.unit_total_spikes = numel(cell2mat([fetchn(EPHYS.TrialSpikes & key,'spike_times')]));
            go_event_t = num2cell(fetchn(rel,'trial_event_time'));

            spike_times = [fetchn(rel,'spike_times')];
            t_go = Param.parameter_value{(strcmp('t_go',Param.parameter_name))};
            t_chirp1 = Param.parameter_value{(strcmp('t_chirp1',Param.parameter_name))};
            C = cellfun(@minus,spike_times,go_event_t,'UniformOutput',false)           
            PSTHMatrix=cell2mat([fetchn(ANL.PSTHMatrix & key)]);
            
        end
    end
end

