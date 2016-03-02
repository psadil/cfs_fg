function analyseForR_CFS_obj_2afc( firstSub, lastSub )
% run this function after analyseFirst

if ~exist([pwd, '\subjectData\exported'], 'dir')
    mkdir([pwd, '\subjectData\exported']);
end



% frequency subjects begin at 30 and end at 83
confusedSubjects = 0;
nValidSubjects = 0;

expforR.outPut = [];
subIndex = 0;

% 1:6 -- program broke (slowly reusing those numbers...)
% 17 -- arrived late, decided to stop running
% 8 -- really not sure...no afc responses recorded at all
% 12 -- too few answers given
% 13 -- apparently didn't give any afc responses?
% 7:18 -- already analyzed
% 19 -- didn't respond
% 21 -- not responding
% 24 -- not responding...
% 27 -- not responding...
% missingData = [2,4:6,8,12,13,17,19,21,24,27];
missingData = [2,4,8,12,17];


for subNum = firstSub:lastSub
    subIndex=subIndex+1;
    nValidSubjects = nValidSubjects+1;
    
    if any(subNum==missingData),
        subIndex = subIndex-1; 
        continue;
    end
    
    fileName = [pwd '\subjectData\scored\Subject' num2str(subNum) 'CFS_obj_2AFC_ss1_scored_noCheck.mat'];
    load(fileName)
    
    %% Useful variables to be used as filters for the data
    
    % fill up column with subject number
    sub_subject = ones(1,p.nItems.unique)*subIndex;

    % 1 = named item
    sub_named = results.study.named; 
    
    % how the subject responded to this item at study (needs to be in test
    % space)
    pas=zeros(p.nItems.unique,1);
    pas2=zeros(p.nItems.unique,1);
    pas3 = zeros(p.nItems.unique,1);
    %     trial = 1;
    for list = 1:p.nStudyLists
        
        currentListInd = p.ind.studyList(list):(p.ind.studyList(list) + p.nItems.list_total-1);
        for rep = 1:3
            
            for studyItem = 1:p.nItems.studyList
              
                trial = currentListInd(studyItem + (p.nItems.studyList * (rep-1)));
                item = p.ind.study(trial);
                
                % how does the 17th item in the study position get us to
                % checking the [49, 65, 81] study resp?
                % now, what about the 13nd item in the study position, we
                % want to check the...[13, 29, 45] study resp
                % for item 33, we want to check... [97, 113, 129]
                testItem = p.stimTab.testOrder(item);
                studyInd = ((list-1) * p.nItems.list_total) + ((rep-1) * p.nItems.studyList) + ...
                    find(p.stimTab.studyOrder==testItem) - (p.nItems.studyList * (list-1));
                temp = p.responses.study(studyInd);
                
                if rep == 1
                    pas(item) = temp;
                elseif rep == 2
                    pas2(item) = temp;
                elseif rep == 3
                    pas3(item) = temp;
                end
                %             respNum = respNum+1;
                
            end
        end
    end
    
    sub_pasResp = pas;
    sub_pasResp2 = pas2;
    sub_pasResp3 = pas3;
    
    % studied: foil==1, word==2, cfs==3, binoc = 4
    sub_condition = p.stimTab.itemCond_test; 
    
    % which item
    whichItem = p.stimTab.testOrder;
        
    % trial number (in the case of something like fatigue)
    testTrial = 1:p.nItems.unique;  
    
    afcCorrect = results.afc_correct;
        
    outPut(1:p.nItems.unique,:) = [sub_subject', sub_condition, sub_pasResp, sub_pasResp2, sub_pasResp3, sub_named', afcCorrect, whichItem, testTrial'];
    
    % tack each subjects' data to the total structure
    expforR.outPut = cat(1,expforR.outPut, outPut);
    
end % end of subject loop
   
% make entire structure a giant table
subject = expforR.outPut(:,1);
condition = expforR.outPut(:,2);
studyResp = expforR.outPut(:,3);
studyResp2 = expforR.outPut(:,4);
studyResp3 = expforR.outPut(:,5);
named = expforR.outPut(:,6);
afc = expforR.outPut(:,7);
whichItem = expforR.outPut(:,8);
trial = expforR.outPut(:,9);

outPutTable = table(subject,condition,studyResp,studyResp2,studyResp3...
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

fileName = [pwd,'\subjectData\exported\cfs_obj_2afc_ss1_noCheck.dat'];
writetable(outPutTable,fileName)

end

