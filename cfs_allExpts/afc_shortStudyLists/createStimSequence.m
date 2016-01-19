function [ p, trialsStudy, trialsTest, trialsPracticeStudy, trialsPracticeTest ] = createStimSequence( p )
%createStimOrders create randomized stimuli sequence to be presented at
%test and study

% 1/7/16 
% ps
% generates the stimulus order for cfs study, version 2AFC -> shortStudyLists. 

%   Four study conditions (1/4 stims in each condition)
% 1 = baseline (foil) 
% 2 = words
% 3 = cfs
% 4 = binoc
% NOTE: secs refers to total presentation time, which includes ramping up
% and raming down

% items studied in sets of 16 (including foils), presented x3 times

%% variables that define how many stimuli
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

% % choose random order of items.
% p.tTypeStudy = randperm(p.nItems);

% rearange the study items with this order
stimTab.pairs = Shuffle(stimTab.pairs,2);

tmp = stimTab.pairs';
test = unique(tmp(:),'stable');

% set items into each condition
% 1 = baseline (foil) 
% 2 = words
% 3 = cfs
% 4 = binoc

% assign the randomized stimuli an item condition
itemConds = repelem(1:4,p.nItems.studyCond)';

[~, itemCond_ind] = ismember(test,stimTab.pairs(:,1));

stimTab.itemConds = itemConds(itemCond_ind);

% set up study order
[stimTab.studyOrder, studyOrder_ind] = Shuffle(stimTab{:,{'pairs'}},2);
stimTab.itemCond_study = stimTab.itemConds(studyOrder_ind(:,1));

% set up test order
[stimTab.testOrder, testOrder_ind] = Shuffle(stimTab{:,{'pairs'}},2);
stimTab.itemCond_test = stimTab.itemConds(testOrder_ind(:,1));


%% make textures for all of the stimuli

%--------------------------------------------------------------------------
% First, make study trials' textures
%--------------------------------------------------------------------------

% create study structure
trialsStudy = struct('name', num2cell(stimTab.studyOrder(:,1)));

% create field with trial type
itemCondition_study_cell = num2cell(stimTab.itemCond_study);
[trialsStudy(1:p.nItems.unique).tType] = deal(itemCondition_study_cell{:});

% grab the names of all test items
% testNames = dir([p.root, '/stims/*.jpeg']);

% read data from all items, making composite image matrix (RGB + alpha columns) 
[study_images, ~, transperancy_study] = arrayfun(@(x) imread( [p.root, '/stims/expt/whole/object', num2str(x.name), '_noBkgrd'], 'png'), trialsStudy, 'UniformOutput', 0);
study_images_wAlpha = cellfun(@(x, n) cat(3,x(:,:),n(:,:)), study_images, transperancy_study, 'UniformOutput', 0);

% make textures of images
cellStudy = num2cell(cellfun(@(x) Screen('MakeTexture',p.window,x), study_images_wAlpha));

% name textures of each stim
[trialsStudy(1:p.nItems.unique).tex] = deal(cellStudy{:}); 

%--------------------------------------------------------------------------
% Next, make study word textures
%--------------------------------------------------------------------------
load('objectNames_2afc.mat');
% this loads variable 'stimNames', a 221x3 cell

p.words = stimNames(stimTab.studyOrder(:,1),1);

%--------------------------------------------------------------------------
% Next, make test trials' textures
%--------------------------------------------------------------------------

% grab the names of all test items
% create study structure
trialsTest = struct('name', num2cell(stimTab.testOrder(:,1)));

% create field with pairing
itemPair_test_cell = num2cell(stimTab.testOrder(:,2));
[trialsTest(1:p.nItems.unique).pair] = deal(itemPair_test_cell{:});

% create field with trial type
itemCondition_test_cell = num2cell(stimTab.itemCond_test);
[trialsTest(1:p.nItems.unique).tType] = deal(itemCondition_test_cell{:});

% grab all of each apertures
[test_ap1, ~, alpha1] = arrayfun(@(x) imread( [p.root,...
    '/stims/expt/apertures/object', num2str(x.name), '_paired', num2str(x.pair), '_ap1'], 'png'), ...
    trialsTest, 'UniformOutput', 0);
test_ap1_wAlpha = cellfun(@(x, n) cat(3,x(:,:),n(:,:)), test_ap1, alpha1, 'UniformOutput', 0);

[test_ap2, ~, ~] = arrayfun(@(x) imread( [p.root,...
    '/stims/expt/apertures/object', num2str(x.name), '_paired', num2str(x.pair), '_ap2'], 'png'), ...
    trialsTest, 'UniformOutput', 0);
testOne = cellfun(@(x, n) x+n, test_ap1, test_ap2, 'UniformOutput', 0);
testOne = cellfun(@(x, n) cat(3,x(:,:),n(:,:)), testOne, alpha1, 'UniformOutput', 0);
% test_ap2_wAlpha = cellfun(@(x, n) cat(3,x(:,:),n(:,:)), test_ap2, alpha2, 'UniformOutput', 0);

[test_ap3, ~, ~] = arrayfun(@(x) imread( [p.root,...
    '/stims/expt/apertures/object', num2str(x.pair), '_paired', num2str(x.name), '_ap3'], 'png'), ...
    trialsTest, 'UniformOutput', 0);
testTwo = cellfun(@(x, n) x+n, test_ap1, test_ap3, 'UniformOutput', 0);
testTwo = cellfun(@(x, n) cat(3,x(:,:),n(:,:)), testTwo, alpha1, 'UniformOutput', 0);
% test_ap3_wAlpha = cellfun(@(x, n) cat(3,x(:,:),n(:,:)), test_ap3, alpha3, 'UniformOutput', 0);

% make textures of images
cellTestAp1 = num2cell(cellfun(@(x) Screen('MakeTexture',p.window,x), test_ap1_wAlpha));
cellTestOne = num2cell(cellfun(@(x) Screen('MakeTexture',p.window,x), testOne));
cellTestTwo = num2cell(cellfun(@(x) Screen('MakeTexture',p.window,x), testTwo));

% name textures of each stim
[trialsTest(1:p.nItems).ap1] = deal(cellTestAp1{:}); 

% the following get randomly chosen so that each are presented on left and
% right sides of screen during 2afc (don't want the 1 / 2 pair to always be
% on the same side)
[trialsTest(1:p.nItems).p1] = deal(cellTestOne{:}); 
[trialsTest(1:p.nItems).p2] = deal(cellTestTwo{:}); 

%% finally, make textures for practice phase
p.practiceOrder_study = randperm(p.nItems.practice)+p.nItems.unique; 
p.itemCondition_practice_study = randi(p.nConds,1,p.nItems.practice);

% create practice_study structure
trialsPractice_study = struct('name', num2cell(p.practiceOrder_study));

% create field with trial type
itemCondition_practice_study_cell = num2cell(p.itemCondition_practice_study);
[trialsPractice_study(1:p.nItems.practice).tType] = deal(itemCondition_practice_study_cell{:});


% read data from all items, making composite image matrix (RGB + alpha columns) 
% study
[practiceStudy_images, ~, transperancy_pracStudy] = arrayfun(@(x) imread( [p.root, '/stims/practice/whole/object', num2str(x.name), '_noBkgrd'], 'png'), trialsPractice_study, 'UniformOutput', 0);
practiceStudy_images_wAlpha = cellfun(@(x, n) cat(3,x(:,:),n(:,:)), practiceStudy_images, transperancy_pracStudy, 'UniformOutput', 0);

cellPracticeStudy = num2cell(cellfun(@(x) Screen('MakeTexture',p.window,x), practiceStudy_images_wAlpha));
[trialsPracticeStudy(1:p.nItems_practice).tex] = deal(cellPracticeStudy{:}); 

%test
[practiceTest_ap1, ~, pracAlpha1] = arrayfun(@(x) imread( [p.root,...
    '/stims/practice/apertures/object', num2str(x.name), '_paired', num2str(x.pair), '_ap1'], 'png'), ...
    trialsTest, 'UniformOutput', 0);
pracTest_ap1_wAlpha = cellfun(@(x, n) cat(3,x(:,:),n(:,:)), practiceTest_ap1, pracAlpha1, 'UniformOutput', 0);

[practiceTest_ap2, ~, ~] = arrayfun(@(x) imread( [p.root,...
    '/stims/practice/apertures/object', num2str(x.name), '_paired', num2str(x.pair), '_ap2'], 'png'), ...
    trialsTest, 'UniformOutput', 0);
pracTestOne = cellfun(@(x, n) x+n, test_ap1, practiceTest_ap2, 'UniformOutput', 0);
pracTestOne = cellfun(@(x, n) cat(3,x(:,:),n(:,:)), pracTestOne, pracAlpha1, 'UniformOutput', 0);
% test_ap2_wAlpha = cellfun(@(x, n) cat(3,x(:,:),n(:,:)), test_ap2, alpha2, 'UniformOutput', 0);

[practiceTest_ap3, ~, ~] = arrayfun(@(x) imread( [p.root,...
    '/stims/practice/apertures/object', num2str(x.pair), '_paired', num2str(x.name), '_ap3'], 'png'), ...
    trialsTest, 'UniformOutput', 0);
pracTestTwo = cellfun(@(x, n) x+n, test_ap1, practiceTest_ap3, 'UniformOutput', 0);
pracTestTwo = cellfun(@(x, n) cat(3,x(:,:),n(:,:)), pracTestTwo, pracAlpha1, 'UniformOutput', 0);
% test_ap3_wAlpha = cellfun(@(x, n) cat(3,x(:,:),n(:,:)), test_ap3, alpha3, 'UniformOutput', 0);

% make textures of images
cellpracTestAp1 = num2cell(cellfun(@(x) Screen('MakeTexture',p.window,x), pracTest_ap1_wAlpha));
cellpracTestOne = num2cell(cellfun(@(x) Screen('MakeTexture',p.window,x), pracTestOne));
cellpracTestTwo = num2cell(cellfun(@(x) Screen('MakeTexture',p.window,x), pracTestTwo));

% name textures of each stim
[trialsPracticeTest(1:p.nItems).ap1] = deal(cellpracTestAp1{:}); 

% the following get randomly chosen so that each are presented on left and
% right sides of screen during 2afc (don't want the 1 / 2 pair to always be
% on the same side)
[trialsPracticeTest(1:p.nItems).p1] = deal(cellpracTestOne{:}); 
[trialsPracticeTest(1:p.nItems).p2] = deal(cellpracTestTwo{:}); 


p.stimTable=stimTab;
end

