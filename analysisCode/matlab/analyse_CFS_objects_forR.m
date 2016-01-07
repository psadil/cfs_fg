function analyse_CFS_objects_forR( firstSub, lastSub )
% run this third

% frequency subjects begin at 30 and end at 83
confusedSubjects = 0;
nValidSubjects = 0;
heirPD.outPut = [];
subIndex = -1;
missingData = [];
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

    % whether trial was inclusion (so, 1 = inclusion, 0 = exclusion)
    sub_inclusion = results.test.inclusion;

    % 1 = stem competed with studied word)
    sub_named = results.test.named; 
    
    % how the subject responded to this item at study
    sub_studyResp = results.test.studyResp;
    
    % studied: foil==0, binoc==1, cfs==2
    sub_condition = p.itemCondition_test; 
    
    % which item
    sub_whichItem = p.testOrder;
    
    % whether item was studied
    sub_studied = results.test.studied;
    
    % trial number (in the case of something like fatigue)
    sub_trial = 1:p.nItems;  
    
    outPut(1:p.nItems,:) = [sub_subject', sub_condition', sub_studyResp', sub_inclusion', sub_named', sub_whichItem', sub_studied', sub_trial'];
    
    % tack each subjects' data to the total structure
    heirPD.outPut = cat(1,heirPD.outPut, outPut);
    
end % end of subject loop
   
% make entire structure a giant table
subject = heirPD.outPut(:,1);
condition = heirPD.outPut(:,2);
studyResp = heirPD.outPut(:,3);
inclusion = heirPD.outPut(:,4);
named = heirPD.outPut(:,5);
whichItem = heirPD.outPut(:,6);
studied = heirPD.outPut(:,7);
trial = heirPD.outPut(:,8);

outPutTable = table(subject,condition,studyResp...
    ,inclusion,named,whichItem,studied,trial);


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

fileName = [pwd,'\Subject Data\currentVersion\pilotData\collected\objects_cfs.dat'];
writetable(outPutTable,fileName)

end

