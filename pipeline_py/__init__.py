import datajoint as dj
import time

db_prefix = dj.config['custom']['database.prefix']
print(f'Database prefix is: {db_prefix}')

is_initialized = False

while not is_initialized:
    try:
        cf = dj.create_virtual_module('cf', db_prefix + 'cf')
        lab = dj.create_virtual_module('lab', db_prefix + 'lab')
        experiment = dj.create_virtual_module('experiment', db_prefix + 'experiment')
        ephys = dj.create_virtual_module('ephys', db_prefix + 'ephys')
        misc = dj.create_virtual_module('misc', db_prefix + 'misc')

        is_initialized = True
    except dj.DataJointError as e:
        print('The schemas/tables have not yet been created - awaiting MATLAB "init.m"')
        time.sleep(120)  # sleep for 2 minutes
        pass
