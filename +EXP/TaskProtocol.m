%{
# SessionType
-> EXP.Task
task_protocol       : tinyint                   # task ptotcol
-----
task_protocol_description           : varchar(4000)                 # 
%}

classdef TaskProtocol < dj.Lookup
    properties
         contents = {
            's1 stim' 2 'mini-distractors'
            's1 stim' 3 'full distractors, with 2 distractors (at different times) on some of the left trials'
            's1 stim' 4 'full distractors'
            's1 stim' 5 'mini-distractors, with different levels of the mini-stim during sample period'
            's1 stim' 6 'full distractors; same as protocol 4 but with a no-chirp trial-type'
            's1 stim' 7 'mini-distractors and full distractors (only at late delay)'
            's1 stim' 8 'mini-distractors and full distractors (only at late delay), with different levels of the mini-stim and the full-stim during sample period'
            's1 stim' 9 'mini-distractors and full distractors (only at late delay), with different levels of the mini-stim and the full-stim during sample period'
            'sound' 1 '3 Khz - lick right; 12kHz - lick left'
            }
    end
end