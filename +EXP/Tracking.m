%{
# 
-> EXP.SessionTrial
-> EXP.TrackingDevice
---
tracking_data_path          : varchar(1000)                  # 
start_time                  : decimal(8,4)                   # (s) from trial start
duration                  : decimal(8,4)                   # (s)

%}


classdef Tracking < dj.Imported

	methods(Access=protected)

		function makeTuples(self, key)
		%!!! compute missing fields for key here
			 self.insert(key)
		end
	end

end