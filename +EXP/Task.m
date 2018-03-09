%{
# Type of tasks
task                        : varchar(12)                   # task type
---
task_description            : varchar(4000)                 # 
%}


classdef Task < dj.Lookup
    properties
        contents = {
            's1 stim' 'S1 photostimulation task (2AFC)'
            }
    end
end