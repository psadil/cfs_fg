function analyse_CFS_objects_forR_pilot( firstSub, lastSub )
% run this third

% frequency subjects begin at 30 and end at 83
confusedSubjects = 0;
nValidSubjects = 0;

expforR.outPut = [];
subIndex = 0;

% subjects 1 - 7 in pilot data were checking their phones
% subject 20 writes "drum i can see things now i think it was my glasses i
% turned them on and sat up straight"
% not sure about 13
% subjects 8-9 had 337 and 312 '3' pas responses, respectively
% subject 14 had 296 3s
% subject 18 had 308 3s
missingData = [1:7,13,20];

for subNum = firstSub:lastSub
    subIndex=subIndex+1;
    nValidSubjects = nValidSubjects+1;
    
    if any(subNum==missingData),
        subIndex = subIndex-1;
        continue;
    end
    
    fileName = [pwd '\Subject Data\currentVersion\pilotData\scored\Subject' num2str(subNum) 'PDP_CFS_objects_scored.mat'];
    load(fileName)
    
    %% Useful variables to be used as filters for the data
    
    % fill up column with subject number
    sub_subject = ones(1,p.nItems)*subIndex;

    % 1 = named item
    sub_named = results.study.named; 
    
    % how the subject responded to this item at study
    sub_studyResp = p.responses.study;
    
    % studied: foil==0, binoc==1, cfs==2
    sub_condition = p.itemCondition_study; 
    
    % which item
    sub_whichItem = p.studyOrder;
        
    % trial number (in the case of something like fatigue)
    sub_trial = 1:p.nItems;  
    
    outPut(1:p.nItems,:) = [sub_subject', sub_condition, sub_studyResp, sub_named', sub_whichItem, sub_trial'];
    
    % tack each subjects' data to the total structure
    expforR.outPut = cat(1,expforR.outPut, outPut);
    
end % end of subject loop
   
% make entire structure a giant table
subject = expforR.outPut(:,1);
condition = expforR.outPut(:,2);
studyResp = expforR.outPut(:,3);
named = expforR.outPut(:,4);
whichItem = expforR.outPut(:,5);
trial = expforR.outPut(:,6);

outPutTable = table(subject,condition,studyResp...
    ,named,whichItem,trial);


%% create data file for R


% % generally don't need the csv, but here's the code to write it, just in
% % case:
% fName = 'Bayes_objects_apertures.csv';
% csvwrite(fName, heirPD.outPut);
% fclose('all');

% % similarly, don't really need to generate a .mat file (since all of the
% % analyses on the data in this structure is easier done in R, but here's
% % the code for a mat file, just in case
% fileName = [pwd '\Subject Data\Bayes_objects_apertures.mat'];
% save(fileName, 'heirPD');

fileName = [pwd,'\Subject Data\currentVersion\pilotData\collected\objects_cfs_psychPhys.dat'];
writetable(outPutTable,fileName)

end

