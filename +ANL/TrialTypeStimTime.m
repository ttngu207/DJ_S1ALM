%{
#
-> EXP.TrialNameType
---
stim_onset = null               : blob              # photostim onset time(s) (seconds, relative to go-cue)
stim_duration = null            : blob              # photostim duration(s)  (seconds)
stimtm_presample = 1000         : double            # presample photostim onset time for this trial-type (seconds, relative to go-cue), 1000 means that there was no stimulus
stimtm_sample = 1000            : double            # sample photostim onset time for this trial-type (seconds, relative to go-cue), 1000 means that there was no stimulus
stimtm_earlydelay = 1000        : double            # earlydelay photostim onset time for this trial-type (seconds, relative to go-cue), 1000 means that there was no stimulus
stimtm_latedelay = 1000         : double            # latedelay photostim onset time for this trial-type (seconds, relative to go-cue), 1000 means that there was no stimulus
%}


classdef TrialTypeStimTime < dj.Computed
    methods(Access=protected)
        
        function makeTuples(self, key)
            stim_duration=[];
            stim_onset = cellfun(@str2num,regexp(key.trial_type_name,'-\d*\.?\d*','Match'));
            
            if  (key.trial_type_name(1)=='r' && ~contains(key.trial_type_name, '-2.5'))
                stim_onset(end+1) = -2.5;
            end
            
            stim_onset = unique(stim_onset,'sorted');
            
            if sum(stim_onset==-3.8)>0
                key.stimtm_presample=-3.8;
                if contains(key.trial_type_name,'-3.8Mini')
                    stim_duration(end+1) = 0.1;
                else
                    stim_duration(end+1) = 0.4;
                end
            end
            
            
            if sum(stim_onset==-2.5)>0
                key.stimtm_sample=-2.5;
                if contains(key.trial_type_name,'-2.5Mini')
                    stim_duration(end+1) = 0.1;
                else
                    stim_duration(end+1) = 0.4;
                end
            end
            
            if sum(stim_onset==-1.6)>0
                key.stimtm_earlydelay=-1.6;
                if contains(key.trial_type_name,'-1.6Mini')
                    stim_duration(end+1) = 0.1;
                else
                    stim_duration(end+1) = 0.4;
                end
            end
            
            if sum(stim_onset==-0.8)>0
                key.stimtm_latedelay=-0.8;
                if contains(key.trial_type_name,'-0.8Mini')
                    stim_duration(end+1) = 0.1;
                else
                    stim_duration(end+1) = 0.4;
                end
            end
            
             
            key.stim_onset = stim_onset;
            key.stim_duration = stim_duration;
            insert (self,key);
        end
    end
end