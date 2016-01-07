function analyseForR_CFS_obj_2afc( firstSub, lastSub )
% run this function after analyseFirst

% frequency subjects begin at 30 and end at 83
confusedSubjects = 0;
nValidSubjects = 0;

expforR.outPut = [];
subIndex = 0;

% sub 52 giving answers like 'black' 'karma' 'sleep'
% sub 53 not giving PAS or 2afc resps (maybe wrong keys?)
% sub 57 (missing)
% sub 59 (didn't even bother analyzing, too many 'idk')

missingData = [52, 53, 57, 59];

for subNum = firstSub:lastSub
    subIndex=subIndex+1;
    nValidSubjects = nValidSubjects+1;
    
    if any(subNum==missingData),
        subIndex = subIndex-1; 
        continue;
    end
    
    fileName = [pwd '\subjectData\scored\Subject' num2str(subNum) 'CFS_obj_2AFC_scored.mat'];
    load(fileName)
    
    %% Useful variables to be used as filters for the data
    
    % fill up column with subject number
    sub_subject = ones(1,p.nItems)*subIndex;

    % 1 = named item
    sub_named = results.study.named; 
    
    % how the subject responded to this item at study (needs to be in test
    % space)
%     NOTE, at the moment, this only looks at first occu
    pas=zeros(p.nItems,1);
    pas2=zeros(p.nItems,1);
    for trial = 1:p.nItems
        testItem = p.testOrder(trial);
        temp = p.responses.study(p.studyOrder==testItem);
        pas(trial) = temp(1);
        pas2(trial) = temp(2);
    end
        
    sub_pasResp = pas;
    sub_pasResp2 = pas2;
    
    % studied: foil==1, word==2, cfs==3, binoc = 4
    sub_condition = p.itemCondition_test; 
    
    % which item
    whichItem = p.testOrder;
        
    % trial number (in the case of something like fatigue)
    testTrial = 1:p.nItems;  
    
    afcCorrect = results.afc_correct;
        
    outPut(1:p.nItems,:) = [sub_subject', sub_condition, sub_pasResp, sub_pasResp2, sub_named', afcCorrect, whichItem, testTrial'];
    
    % tack each subjects' data to the total structure
    expforR.outPut = cat(1,expforR.outPut, outPut);
    
end % end of subject loop
   
% make entire structure a giant table
subject = expforR.outPut(:,1);
condition = expforR.outPut(:,2);
studyResp = expforR.outPut(:,3);
studyResp2 = expforR.outPut(:,4);
named = expforR.outPut(:,5);
afc = expforR.outPut(:,6);
whichItem = expforR.outPut(:,7);
trial = expforR.outPut(:,8);

outPutTable = table(subject,condition,studyResp,studyResp2...
    ,named,afc,whichItem,trial);


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

fileName = [pwd,'\subjectData\exported\cfs_obj_2afc.dat'];
writetable(outPutTable,fileName)

end

