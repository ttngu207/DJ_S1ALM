%{
# 
trial_note_type             : varchar(12)                   # 
%}


classdef TrialNoteType < dj.Lookup
    properties
        contents = {
            'autolearn'
            'good'
            'bad'
            }
    end
end