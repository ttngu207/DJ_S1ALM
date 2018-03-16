function DJconnect
clear all;
setenv('DJ_HOST', 'mesoscale-activity.datajoint.io')
setenv('DJ_USER', 'arseny')
setenv('DJ_PASS', 'kosoy111')
dj.conn()

erd LAB MISC EXP EPHYS CF ANL
