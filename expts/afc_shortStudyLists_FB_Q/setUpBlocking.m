function [] = setUpBlocking(nSubBlocks)

% Creates blocked design (in set of 8), for CFS_shortStudyList expt.

% 1/19/16
% ps
% initial write


if ~exist([pwd, '\stimTabs\'], 'dir')
    mkdir([pwd, '\stimTabs\']);
end

seed= round(sum(100*clock));
rng(seed); 

%----------------------------------------------------------------------
% save seed
%----------------------------------------------------------------------
save([pwd, '/stimTabs/seed.txt'], 'seed');

%%
p.nPerBlocking = 8;

p.nItems.unique = 128; % nItems must be in multiples of 16
firstPracticeItem = 193;
p.nItems.practice = 16; % items seen in practice phase
p.nConds = 4; % number of item conditions
p.nItems.studyList = 16; % number of items seen in study list
p.nReps = 2; % number of times items repeated per study list


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
stimTab = stimTab(1:192,:);

% pairs to not use
delItems = [5,9,10,12,17,21,22,24,27,35,38,36,41,42,46,48,49,51,54,55,63,65,67,70,75,77,82,83,84,87,91,92,93,94,101,106,105,108,109,114,116,120,127,130,132,134,136,138,142,148,149,152,158,160,164,168,169,171,173,175,178,180,182,190];

stimTab = removerows(stimTab,delItems);

% randomize order
stimTab.pairs = Shuffle(stimTab.pairs,2);



tmp = stimTab.pairs';
[probe, ~, ~] = unique(tmp(:),'stable');

% set items into each condition
% 1 = baseline (foil)
% 2 = words
% 3 = cfs
% 4 = binoc

% assign the randomized stimuli an item condition

items = probe(1:p.nItems.unique,1);

[~, ind] = ismember(items,stimTab.pairs(:,1));

itemConds = repelem(1:p.nConds,p.nItems.unique/p.nConds)';
leftPairFirst = repmat([0;1],[p.nItems.unique/2,1]);

for sub = 1:nSubBlocks*p.nPerBlocking
    % assign item condition
    itemConds_block = mod(itemConds+sub, p.nConds);
    itemConds_block(itemConds_block==0) = p.nConds;
    
    % assign which pair comes first
    if sub < p.nPerBlocking/2
        leftPairFirst_block = mod(leftPairFirst, 2);
    else
        leftPairFirst_block = mod(leftPairFirst+1, 2);
    end
    
    
    stimTmp = table([stimTab.pairs(ind,1) , stimTab.pairs(ind,2)]);
    stimTmp.Properties.VariableNames{'Var1'} = 'pairs';
    stimTmp.itemConds = itemConds_block;
    stimTmp.leftPairFirst = leftPairFirst_block;
    
    % grab enough items for first list
    b = 1:p.nConds;
    inds = arrayfun(@(x) find(stimTmp.itemConds == x), b,'UniformOutput',0 );
    
    studyOrder = zeros(p.nItems.unique,1);
    itemCond_study = zeros(p.nItems.unique,1);
    testOrder = zeros(p.nItems.unique,1);
    itemCond_test = zeros(p.nItems.unique,1);
    leftFirst_test = zeros(p.nItems.unique,1);
    
    firstToFill=(1:p.nItems.studyList:p.nItems.unique);
    lastToFill = firstToFill+p.nItems.studyList-1;
    
    firstToFind=(1:p.nConds:p.nItems.unique);
    lastToFind = firstToFind+p.nConds-1;
    
    
    for list = 1:p.nStudyLists
        tTable = stimTmp([inds{1}(firstToFind(list):lastToFind(list))...
            ; inds{2}(firstToFind(list):lastToFind(list)) ...
            ; inds{3}(firstToFind(list):lastToFind(list)) ...
            ; inds{4}(firstToFind(list):lastToFind(list))],:);
        
        % set up study order
        [studyOrder(firstToFill(list):lastToFill(list)), studyOrder_ind] = Shuffle(tTable.pairs(:,1));
        itemCond_study(firstToFill(list):lastToFill(list)) = tTable.itemConds(studyOrder_ind);
        
        % set up test order

        [~, firstInd] = ismember(tTable.pairs(tTable.leftPairFirst==1),tTable.pairs);
        [~, secondInd] = ismember(tTable.pairs(tTable.leftPairFirst==0),tTable.pairs);

        firstInd = Shuffle(firstInd);
        secondInd = Shuffle(secondInd);
        
        testOrder(firstToFill(list):lastToFill(list)) = tTable.pairs([firstInd;secondInd],1);
        testPairs(firstToFill(list):lastToFill(list)) = tTable.pairs([firstInd;secondInd],2);
        itemCond_test(firstToFill(list):lastToFill(list)) = tTable.itemConds([firstInd;secondInd]);
        leftFirst_test(firstToFill(list):lastToFill(list)) = tTable.leftPairFirst([firstInd;secondInd]);
        
        
    end
    
    stimTmp.studyOrder = studyOrder;
    stimTmp.itemCond_study = itemCond_study;
    stimTmp.testOrder = testOrder;
    stimTmp.testPair = testPairs';
    stimTmp.itemCond_test = itemCond_test;
    stimTmp.leftFirst_test = leftFirst_test;
    stimTmp.block = repelem(1:p.nStudyLists, p.nItems.studyList)';
    
    stims = stimTmp;
    
    %----------------------------------------------------------------------
    % set up practice stim list
    %----------------------------------------------------------------------
    studyOrder = randperm(p.nItems.practice)'+firstPracticeItem-1;
    itemCond_study = randi(p.nConds,1,p.nItems.practice)';
    testOrder = randperm(p.nItems.practice)'+p.nItems.unique;
    
    [~ , idx] = ismember(testOrder,pairs(:,1)); 
    
    testPair = pairs(idx,2);
    block = ones(p.nItems.practice,1);
    
    stims_prac = table(studyOrder, itemCond_study, testOrder, testPair, block);
    
    %----------------------------------------------------------------------
    % save stim variables
    %----------------------------------------------------------------------
    save([pwd, '/stimTabs/stimTab_sub', num2str(sub)], 'stims', 'stims_prac');
    
end