clear all, close all, clc

% Load configuration
dj.config();
dj.config.load('dj_local_conf.json')
cfg = dj.config;

package_names = {'CF', 'LAB','EXP', 'EPHYS', 'MISC', 'ANL'};
schema_names = {'cf', 'lab','experiment', 'ephys', 'misc', 'analysis'};

% Create schemas 
for s_idx = 1 : numel(schema_names)
    dj.createSchema(package_names{s_idx}, './',...
    [cfg.custom.databasePrefix, schema_names{s_idx}])
end

% Instantiate tables
for s_idx = 1 : numel(schema_names)
   schema_pkg = ['+', package_names{s_idx}];
   mfiles = dir([schema_pkg, '/*.m']);
   for f_idx = 1: numel(mfiles)
       fname = mfiles(f_idx).name(1:end-2);
       if strcmp(fname, 'getSchema')
          continue 
       end
       fprintf('---- %s ----\n', [package_names{s_idx}, '.', fname])
       try
           eval([package_names{s_idx}, '.', fname, '()'])
       catch e
           disp(e)
       end
   end
end

