%{
#
-> EXP.Session
---
trials_hit = null            : longblob
trials_miss = null           : longblob
trials_ignore  = null        : longblob
trials_quit  = null          : longblob
trials_early  = null         : longblob
trials_all   = null          : longblob
sliding_window_for_ignore    : longblob
%}


classdef SessionBehavOverview < dj.Computed
    methods(Access=protected)
        function makeTuples(self, key)
        end
    end
end