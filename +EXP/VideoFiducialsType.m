%{
#
-> EXP.TrackingDevice
video_fiducial_name         : varchar(200)                  #
---
video_fiducial_description  : varchar(1000)                 #
%}


classdef VideoFiducialsType < dj.Imported
    
    methods(Access=protected)
        
        function makeTuples(self, key)
            video_fiducial_name = {
                'ephys'    'Camera'                1    'jaw'               'anterior edge of the jaw/mouth'
                'ephys'    'Camera'                1    'nose_tip'           'anterior edge of the nose at the midline'
                'ephys'    'Camera'                1    'left_port'          'tip of the left lick port'
                'ephys'    'Camera'                1    'right_port'          'tip of the right lick port'
                'ephys'    'Camera'                1    'tongue_left'       'left edge of the tongue, at the point of minimal curvuture close to the tip'
                'ephys'    'Camera'                1    'tongue_right'        'right edge of the tongue, at the point of minimal curvuture close to the tip'
                'ephys'    'Camera'                1    'tongue_tip'         'tip of the tongue'
                };
            
            insert(self,video_fiducial_name);
        end
    end
    
end

