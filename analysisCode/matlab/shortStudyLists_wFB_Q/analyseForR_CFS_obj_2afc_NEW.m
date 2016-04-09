function analyseForR_CFS_obj_2afc_NEW( firstSub, lastSub )
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
missingData = [1:8,9,10,14:20,24,28,30];

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
    pas = results.study.pas(1:length(p.stimTab.studyOrder));
    pas2 = results.study.pas(1+length(p.stimTab.studyOrder):end);    
    studyCond = p.stimTab.itemCond_study; 
    
    
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

