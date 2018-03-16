%{
#
-> EXP.TrialNameType
---
stimtm_presample = 1000               : double            # presample photostim onset time for this trial-type (in seconds, relative to go-cue), 1000 means that there was no stimulus
stimtm_sample = 1000                  : double            # sample photostim onset time for this trial-type (in seconds, relative to go-cue), 1000 means that there was no stimulus
stimtm_earlydelay = 1000              : double            # earlydelay photostim onset time for this trial-type (in seconds, relative to go-cue), 1000 means that there was no stimulus
stimtm_latedelay = 1000               : double            # latedelay photostim onset time for this trial-type (in seconds, relative to go-cue), 1000 means that there was no stimulus


%}


classdef TrialNameTypeStimTime < dj.Computed
    methods(Access=protected)
        
        function makeTuples(self, key)
            stim_onsets=[];
            stim_onsets = cellfun(@str2num,regexp(key.trial_type_name,'-\d*\.?\d*','Match'));
            if  key.trial_type_name(1)=='r'
                stim_onsets(end+1) = -2.5;
            end
            
            if sum(stim_onsets==-3.8)>0
                key.stimtm_presample=-3.8;
            end
            if sum(stim_onsets==-2.5)>0
                key.stimtm_sample=-2.5;
            end
            if sum(stim_onsets==-1.6)>0
                key.stimtm_earlydelay=-1.6;
            end
            if sum(stim_onsets==-0.8)>0
                key.stimtm_latedelay=-0.8;
            end
            
            
            insert (self,key);
        end
    end
end