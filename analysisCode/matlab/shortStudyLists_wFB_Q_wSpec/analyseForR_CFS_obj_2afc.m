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


missingData = [1,3,4,6,8,10,12,13,16,19,25,27];


%other thoughts
% sub 26 basically only responded on those ones that were correct...DIDN"T
% GUESS!!

for subNum = firstSub:lastSub
    subIndex=subIndex+1;
    nValidSubjects = nValidSubjects+1;
    
    if any(subNum==missingData),
        subIndex = subIndex-1; 
        continue;
    end
    
    fileName = [pwd '\subjectData\scored\Subject' num2str(subNum) 'CFS_AFC_ss1_wFB_Q_scored_noCheck.mat'];
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
    for trial = 1:p.nItems.unique*p.nReps
        tmp = p.rt.study(trial,find(p.rt.study(trial,:)));
        if ~isempty(tmp)
            if trial <= p.nItems.unique
                rt1(trial) = tmp(end) - tmp(1);
            else
                rt2(trial - p.nItems.unique) = tmp(end) - tmp(1);
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
        
    outPut(1:p.nItems.unique,:) = [sub_subject', sub_condition, sub_named', afcCorrect, whichItem, testTrial'];
    
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
whichItem = expforR.outPut(:,5);
trial = expforR.outPut(:,6);

outPutTable = table(subject,condition,named,afc,whichItem,trial);


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

