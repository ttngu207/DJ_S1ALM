function DJ_Import_LAB
close all; clear all;


dir_data = 'Z:\users\Arseny\Projects\SensoryInput\SiProbeRecording\ProcessedData\';

DJconnect; %connect to the database using stored user credentials

%% Insert/Populate tables
allFiles = dir(dir_data); %gets  the names of all files and nested directories in this folder
allFileNames = {allFiles(~[allFiles.isdir]).name}; %gets only the names of all files
for iFile = 1:1:numel (allFileNames)
    
    currentFileName = allFileNames{iFile};
    currentSubject_id = str2num(currentFileName(19:24));
    currentSessionDate = currentFileName(26:35);
    currentSessionSuffix = currentFileName(36);
    if currentSessionSuffix == '.'
        currentSessionSuffix ='a';
    end
    
    
    % Insert Animal table
    exisitingAnimal = fetchn(LAB.Subject,'subject_id');
    % inserts animal only if it was not inserted before
    if isempty(exisitingAnimal) ||  sum(currentSubject_id == exisitingAnimal)<1
        insert(LAB.Subject, {currentSubject_id, 'ars',123456, '2000-01-01','Unknown', 'Other'} );
        insert(LAB.SubjectGeneModification, {currentSubject_id, 'Scnn1a-TG3-Cre','Unknown','Unknown'} );
        insert(LAB.SubjectGeneModification, {currentSubject_id, 'Ai32','Unknown','Unknown'} );
        
        %         insert(LAB.Surgery, {currentSubject_id, 1, 'ars',[currentSessionDate ' 00:00:00'],[currentSessionDate ' 00:00:00'],'Craniotomy ALM Left'} );
        insert(LAB.SurgeryProcedure, {currentSubject_id, 1, 1, 'Bregma',-1500,2500,0,'Craniotomy ALM Left'} );
        
        
    end
    
end

populate(LAB.CompleteGenotype)


