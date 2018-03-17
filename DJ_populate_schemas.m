function DJ_populate_schemas()
close all;
DJconnect; %connect to the database using stored user credentials

populate(ANL.TrialNameTypeStimTime);

populate(ANL.SessionBehavOverview);
populate(ANL.SessionBehavPerformance);
behv_sessions();

populate(ANL.PSTH);
populate(ANL.PSTHMatrix);
populate(ANL.SessionPosition);
populate(ANL.CDrotation);
populate(ANL.CDrotationAverage);
%  populate(EXP.PassivePhotostimTrial);

ANL.UnitFiringRate;
ANL.UnitISI;