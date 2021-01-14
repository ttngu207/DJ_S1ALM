clear all

% Load configuration
dj.config();
dj.config.load('dj_local_conf.json')

schema_names = {'CF', 'LAB',...
    'EXP', 'EPHYS',...
    'MISC', 'ANL'};
