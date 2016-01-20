% Creates blocked design (in set of 8), for CFS_shortStudyList expt.

% 1/19/16
% ps
% initial write


%%
p.nItems.unique = 192; % nItems must be in multiples of 16
p.nItems.practice = 16; % items seen in practice phase
p.nConds = 4; % number of item conditions
p.nItems.studyList = 16; % number of items seen in study list
p.nReps = 3; % number of times items repeated per study list

p.nStudyLists = p.nItems.unique/p.nItems.studyList;
p.nItems.list_total = p.nItems.studyList * p.nReps;
p.nTrials = p.nItems.unique*p.nReps;

p.nItems.studyCond = p.nItems.unique/p.nConds; % 1/4 of total items for each condition
p.nItems.testCond = p.nItems.studyCond/2; % number of items from each condition displayed during each In/Ex block

p.ind.study = repmat(repmat(1:p.nItems.studyList,[1,p.nReps]),[1,p.nStudyLists]) + ...
    repelem(0:p.nItems.studyList:p.nItems.unique-p.nItems.studyList,p.nItems.studyList*p.nReps);

p.ind.test = repmat(1:p.nItems.studyList,[1,p.nStudyLists]) + ...
    repelem(0:p.nItems.studyList:p.nItems.unique-p.nItems.studyList,p.nItems.studyList);

p.ind.studyList = 1:p.nItems.list_total:p.nTrials;

p.ind.testList = 1:p.nItems.studyList:p.nItems.unique;





%% Set up item Conditions

% note: items must be put into conditions such that items in a 2afc pair
% are seen in the same condition

% load a list of which objects are paired together
[pairs,~] = xlsread('stimPairings.xlsx');

% put pairs in to table
stimTab = table(pairs);
stimTab = stimTab(1:p.nItems.unique,:);

% randomize order
stimTab.pairs = Shuffle(stimTab.pairs,2);

tmp = stimTab.pairs';
probe = unique(tmp(:),'stable');

% set items into each condition
% 1 = baseline (foil)
% 2 = words
% 3 = cfs
% 4 = binoc

% assign the randomized stimuli an item condition
itemConds = repelem(1:4,p.nItems.studyCond)';
whichPairFirst = repelem(1:2,p.nItems.unique/2)';

[~, itemCond_ind] = ismember(probe,stimTab.pairs(:,1));
[~, whichPairFirst_ind] = ismember(probe,stimTab.pairs(:,1));

for block = 0:7
    
    % assign item condition
    itemConds_block = mod(itemConds+block, p.nConds);
    itemConds_block(itemConds_block==0) = p.nConds;
    stimTab.itemConds = itemConds_block(itemCond_ind);
    
    % assign which item in a pair is seen first
    whichPairFirst_block = mod(whichPairFirst+block, 2);
    whichPairFirst_block(whichPairFirst==0) = 2;
    stimTab.whichPairFirst = whichPairFirst_block(whichPairFirst_ind);
    
    % set up study order
    [stimTab.studyOrder, studyOrder_ind] = Shuffle(stimTab{:,{'pairs'}},2);
    stimTab.itemCond_study = stimTab.itemConds(studyOrder_ind(:,1));
    
    
    
    % set up test order
    [stimTab.testOrder, testOrder_ind] = Shuffle(stimTab{:,{'pairs'}},2);
    stimTab.itemCond_test = stimTab.itemConds(testOrder_ind(:,1));
    
    if block > 3
       
    else
        
    end
    
    save([pwd, '/stimTabs/stimTab_sub', num2str(block+1)], 'stimTab')
end