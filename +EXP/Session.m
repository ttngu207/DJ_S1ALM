%{
# 
-> LAB.Subject
session                     : smallint                      # session number
---
session_id                  : int                           # unique across sessions/animals
session_date                : date                          # 
-> LAB.Person
-> LAB.Rig
%}


classdef Session < dj.Manual
    methods(Access=protected)
    end
end