function [data_SessionTask, data_SessionTraining] = Ingest_EXP_TaskTraining (obj, key)

task =  's1 stim';
task_protocol = obj.task;

if strcmp(obj.training_type,'full_distractor')
    training_type = 'distractor';
elseif strcmp(obj.training_type,'basic_task')
    training_type = 'regular';
end

data_SessionTask  = struct(...
    'subject_id',key.subject_id, 'session',key.session, 'task',task, 'task_protocol',task_protocol);

data_SessionTraining  = struct(...
    'subject_id',key.subject_id, 'session',key.session, 'training_type',training_type);
