%{
# Mouse training
training_type                      : varchar(100)                   # mouse training
---
description                        : varchar(2000)                   #description

%}


classdef TrainingType < dj.Lookup
    properties
        contents = {'regular' ''
            'regular + distractor' 'mice were first trained on the regular S1 photostimulation task  without distractors, then the training continued in the presence of distractors'
            'regular or regular + distractor' 'includes both training options'}
    end
end