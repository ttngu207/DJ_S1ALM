%{
# 
-> EXP.Session
trial                       : smallint                      # 
---
trial_id                    : int                           # unique across sessions/animals
start_time                  : decimal(8,4)                  # (s) % relative to session beginning
%}


classdef SessionTrial < dj.Part
    properties(SetAccess=protected)
        master= EXP.Session
    end
end