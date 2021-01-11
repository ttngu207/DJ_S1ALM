
%% Should be inserted only in case this info isn't already in the database

insert(LAB.ModifiedGene, {'CamK2a-tTA', 'When these Camk2a-tTA transgenic mice are mated to strain carrying a gene of interest under the regulatory control of a tetracycline-responsive promoter element (TRE; tetO), expression of the target gene can be blocked by administration of the tetracycline analog, doxycycline'} );
insert(LAB.ModifiedGene, {'slc17a7 IRES Cre 1D12', 'Cre recombinase expression directed to Vglut1-expressing cells'} );
insert(LAB.ModifiedGene, {'Ai94', 'TITL-GCaMP6s Cre/Tet-dependent, fluorescent calcium indicator GCaMP6s inserted into the Igs7 locus (TIGRE)'} );

insert(LAB.Person, {'ars','ArsenyFinkelstein'} );
insert(LAB.Rig, {'imaging1','2C.384','Two-photon imaging and photostimulation rig'} );

insert(LAB.SubjectGeneModification, {subject_id, 'CamK2a-tTA','Unknown','Unknown'} );
insert(LAB.SubjectGeneModification, {subject_id, 'slc17a7 IRES Cre 1D12','Unknown','Unknown'} );
insert(LAB.SubjectGeneModification, {subject_id, 'Ai94','Unknown','Unknown'} );

%% Should be inserted for each new animal
subject_id=437545;
insert(LAB.Subject, {subject_id, 'ars', 164858,'2018-08-24','F','Other'} );

insert(LAB.Surgery, {subject_id, 1, 'ars',['2018-12-18' ' 00:00:00'],['2018-12-18' ' 00:00:00'],'Cranial Window ALM Left'} );
insert(LAB.SurgeryProcedure, {subject_id, 1, 1, 'Bregma',-1500,2500,0,'Cranial Window 2.5/2.5/3'} );
insert(LAB.SurgeryLocation, {subject_id, 1, 1, 'left','ALM'} );

populate(LAB.CompleteGenotype)
