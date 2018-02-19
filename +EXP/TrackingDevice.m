%{
# 
tracking_device             : varchar(20)                    # e.g. camera, microphone
---
sampling_rate               : decimal(8,4)                  # Hz
tracking_device_description: varchar(1000)                   # 

%}


classdef TrackingDevice < dj.Lookup
     properties
        contents = {
            'Camera 0, side' 400 'Chameleon3 CM3-U3-13Y3M-CS (FLIR)'
            'Camera 1, bottom' 400 'Chameleon3 CM3-U3-13Y3M-CS (FLIR)'
            }
    end
end