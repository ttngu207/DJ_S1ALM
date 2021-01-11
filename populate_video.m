function populate_video()
close all;
populate(EXP.TrackingTrial);
populate(EXP.VideoFiducialsTrial);
populate(ANL.VideoLandmarksSession);
populate(ANL.VideoTongueTrial);
populate(ANL.Video1stLickTrial);

populate(ANL.VideoNthLickTrial);

populate(ANL.LickDirectionTrial);
populate(ANL.VideoTongueValidRTTrial);
populate(ANL.Video1stLickTrialNormalized);

populate(ANL.RegressionTongueSingleUnitGo);
% populate(ANL.RegressionTongueSingleUnit);
populate(ANL.RegressionProjTrialGo);
% populate(ANL.RegressionProjTrial);

populate(ANL.RegressionDecoding);
populate(ANL.RegressionDecodingSignificant);
populate(ANL.RegressionDecodingLickNumber);
populate(ANL.RegressionRotation);
populate(ANL.RegressionRotationAverage);
populate(ANL.RegressionRotationAverageSignif);


populate(ANL.UnitTongue1DTuning)
populate(ANL.UnitTongue1DTuningShufflingGo)
% populate(ANL.UnitTongue1DTuningShuffling)
populate(ANL.UnitTongue1DTuningSignificanceGo)
% populate(ANL.UnitTongue1DTuningSignificance)

populate(ANL.UnitTongue1DTuningReconstruction)
populate(ANL.UnitTongue2DTuning);