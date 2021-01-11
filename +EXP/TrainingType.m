%{
# Mouse training
training_type                      : varchar(100)                   # mouse training
---
training_type_description          : varchar(2000)                  #

%}


classdef TrainingType < dj.Lookup
    properties
        contents = {'regular' 'regular training on the photostim task without any distractors'
            'distractor' 'mice were first trained on the regular S1 photostimulation task  without distractors, then the training continued in the presence of distractors'
            'all' 'includes both training options'
            'regular sound' 'regular training on the sound task'}
    end
end