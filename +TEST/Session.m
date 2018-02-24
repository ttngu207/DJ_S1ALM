%{
# 
session                     : smallint                      # session number
---
session_uid                 : int auto_increment            # unique across sessions/animals

unique index (session_uid)

%}


classdef Session < dj.Manual
    methods(Access=protected)
    end
end