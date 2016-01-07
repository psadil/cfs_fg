function analyseForR_CFS_obj_2afc_pilot( firstSub, lastSub )
% run this function after analyseFirst

% frequency subjects begin at 30 and end at 83
confusedSubjects = 0;
nValidSubjects = 0;

expforR.outPut = [];
subIndex = 0;


missingData = [];

for subNum = firstSub:lastSub
    subIndex=subIndex+1;
    nValidSubjects = nValidSubjects+1;
    
    if any(subNum==missingData),
        subIndex = subIndex-1;
        continue;
    end
    
    fileName = [pwd '\Subject Data\currentVersion\Subject Data_2afc_pilot\scored\Subject' num2str(subNum) 'CFS_obj_2AFC_pilot1_scored.mat'];
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

fileName = [pwd,'\Subject Data\currentVersion\Subject Data_2afc_pilot\collected\cfs_obj_2afc_pilot1.dat'];
writetable(outPutTable,fileName)

end

