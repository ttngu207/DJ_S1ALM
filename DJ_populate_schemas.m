function DJ_populate_schemas()
close all;
DJconnect; %connect to the database using stored user credentials
%  populate(EXP.PassivePhotostimTrial);

% populate(ANL.TrialTypeID)
% populate(ANL.TrialTypeStimTime);
% populate(ANL.TrialTypeInstruction);
% populate(ANL.TrialTypeGraphic);
% 
% populate(ANL.SessionBehavOverview);
% populate(ANL.TrialBehaving);
% 
% populate(ANL.SessionBehavPerformance);
% behv_sessions();
% populate(ANL.SessionPosition);

populate(ANL.TrialSpikesGoAligned);



populate(ANL.PSTH);
populate(ANL.PSTHMatrix);
populate(ANL.Mode);
populate(ANL.CDrotation);
populate(ANL.CDrotationAverage);


populate(ANL.UnitFiringRate);
populate(ANL.UnitISI);
populate(ANL.IncludeUnit);

% populate(ANL.ProjTrialAverage);
populate(ANL.UnitHierarCluster);