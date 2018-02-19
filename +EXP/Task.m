%{
# Type of tasks
task                        : varchar(12)                   # task type
---
task_description            : varchar(4000)                 # 
%}


classdef Task < dj.Lookup
    properties
        contents = {
            'audio delay' 'auditory delayed response task (2AFC)'
            'audio mem' 'auditory working memory task'
            's1 stim' 'S1 photostimulation task (2AFC)'
            }
    end
end