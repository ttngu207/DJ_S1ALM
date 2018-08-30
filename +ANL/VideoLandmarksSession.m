%{
#
-> EXP.Session
-> EXP.VideoFiducialsType
---
session_median_x                 : double                   # median fiducial coordinate along the X axis of the video image, for the entire session
session_median_y                 : double                   # median fiducial coordinate along the Y axis of the video image, for the entire session
%}


classdef VideoLandmarksSession < dj.Imported
    properties
        keySource = (EXP.Session  & EXP.TrackingTrial & EXP.VideoFiducialsTrial)* EXP.VideoFiducialsType
    end
    methods(Access=protected)
        
        function makeTuples(self, key)
            
            key.session_median_x= nanmedian(fetchn(EXP.VideoFiducialsTrial & key,'fiduical_x_position_median'));
            key.session_median_y= nanmedian(fetchn(EXP.VideoFiducialsTrial & key,'fiduical_y_position_median'));
            
            insert(self,key)
        end
        
    end
end

