%{
# 
-> LAB.Rig
tracking_device_type        : varchar(20)          # e.g. camera, microphone
tracking_device_id          : int                  # number of the device, e.g. in case there are multiple cameras
---
tracking_device_description:   varchar(1000)       # e.g. side-view camera
tracking_device_model:         varchar(1000)       # make and model of the tracking device

%}


classdef TrackingDevice < dj.Lookup
     properties
        contents = {
            'ephys' 'Camera' 0   'side view'   'Chameleon3 CM3-U3-13Y3M-CS (FLIR)'
            'ephys' 'Camera' 1   'bottom view' 'Chameleon3 CM3-U3-13Y3M-CS (FLIR)'
            }
    end
end