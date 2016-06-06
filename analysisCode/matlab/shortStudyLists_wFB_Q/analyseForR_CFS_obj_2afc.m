function analyseForR_CFS_obj_2afc( firstSub, lastSub )
% run this function after analyseFirst

if ~exist([pwd, '\subjectData\exported'], 'dir')
    mkdir([pwd, '\subjectData\exported']);
end



% frequency subjects begin at 30 and end at 83
confusedSubjects = 0;
nValidSubjects = 0;

expforR.outPut = [];
expforR.outPut_study = [];
subIndex = 0;

% subs 1:8 too long of study lists
% sub 30 stopped responding half way through
% sub 24 didn't finish
% sub 28 didn't finish
% sub 21 is the first one with the correct stimTab
% sub 30 stopped giving responses
% prior to sub 38, not working
missingData = [1:38,39,42,43,46,47,52,56,59,60,61,62];

% the following were missing afc responses
missingData = [missingData, 44, 45, 48, 49, 50, 57, 58];


for sub = firstSub:lastSub
    subIndex=subIndex+1;
    nValidSubjects = nValidSubjects+1;
    
    if any(sub==missingData),
        subIndex = subIndex-1; 
        continue;
    end
    
    fileName = [pwd '\subjectData\scored\Subject' num2str(sub) 'CFS_AFC_ss1_wFB_Q_scored_noCheck.mat'];
    load(fileName)
    
    %% Useful variables to be used as filters for the data
    
    % fill up column with subject number
    sub_subject = ones(1,p.nItems.unique)*subIndex;

    % 1 = named item
    sub_named = results.study.named; 
    
    
    %% study items
    whichItem = p.stimTab.studyOrder;
    studyCond = p.stimTab.itemCond_study;
    
    pas = zeros(p.nItems.unique,1);
    pas2 = zeros(p.nItems.unique,1);
    trial = 0;
    for list = 1:p.nStudyLists
        for rep = 1:p.nReps
            for item = 1:p.nItems.studyList
              trial = trial + 1;  
                if rep == 1
                    pas(p.ind.study(trial)) = results.study.pas(trial);
                else
                    pas2(p.ind.study(trial)) = results.study.pas(trial);
                end
            end
        end
    end
        
     
    %----------------------------------------------------------------------
    % RT
    %----------------------------------------------------------------------
    rt1 = zeros(p.nItems.unique,1);
    rt2 = zeros(p.nItems.unique,1);
    trial=0;
    for list = 1:p.nStudyLists
        for rep = 1:p.nReps
            for item = 1:p.nItems.studyList
                trial = trial + 1;
                if rep == 1
                    rt1(p.ind.study(trial)) = p.dur.study_whole(trial);
                else
                    rt2(p.ind.study(trial)) = p.dur.study_whole(trial);
                end
            end
        end
    end
        
    %----------------------------------------------------------------------
    % study List
    %----------------------------------------------------------------------
    
    list = p.stimTab.block;
    
    outPut_study(1:p.nItems.unique,:) = [sub_subject', studyCond, pas, pas2, rt1,rt2, whichItem, list];
    
    % tack each subjects' data to the total structure
    expforR.outPut_study = cat(1,expforR.outPut_study, outPut_study);
    
    %% test stuff
    
    % studied: foil==1, word==2, cfs==3, binoc = 4
    sub_condition = p.stimTab.itemCond_test; 
    
    % which item
    whichItem = p.stimTab.testOrder;
        
    % trial number (in the case of something like fatigue)
    testTrial = 1:p.nItems.unique;  
    
    afcCorrect = results.afc_correct;
     
    % left gets stored as 0, right as 1
    whichSide = p.test_leftRight - 1;
    whichResp = p.responses.afc - 1;
    
    
    %% output
    outPut(1:p.nItems.unique,:) = [sub_subject', sub_condition, sub_named',...
        afcCorrect, whichSide, whichResp, whichItem, testTrial'];
    
    % tack each subjects' data to the total structure
    expforR.outPut = cat(1,expforR.outPut, outPut);
    
end % end of subject loop

% make entire structure a giant table
subject = expforR.outPut_study(:,1);
condition = expforR.outPut_study(:,2);
studyResp = expforR.outPut_study(:,3);
studyResp2 = expforR.outPut_study(:,4);
rt1 = expforR.outPut_study(:,5);
rt2 = expforR.outPut_study(:,6);
whichItem = expforR.outPut_study(:,7);
list = expforR.outPut_study(:,8);

outPutTable_study = table(subject,condition,studyResp,studyResp2,rt1,rt2,whichItem,list);

% make entire structure a giant table
subject = expforR.outPut(:,1);
condition = expforR.outPut(:,2);
named = expforR.outPut(:,3);
afc = expforR.outPut(:,4);
whichSide = expforR.outPut(:,5);
whichResp = expforR.outPut(:,6);
whichItem = expforR.outPut(:,7);
trial = expforR.outPut(:,8);

outPutTable = table(subject,condition,named,afc,whichSide,whichResp,whichItem,trial);


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

fileName = [pwd,'\subjectData\exported\cfs_afc_ss1_wFB_Q_noCheck.dat'];
writetable(outPutTable,fileName)

fileName = [pwd,'\subjectData\exported\cfs_afc_ss1_wFB_Q_noCheck_study.dat'];
writetable(outPutTable_study,fileName)


end

