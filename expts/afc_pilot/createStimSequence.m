function [ p, trialsStudy, trialsTest, trialsPracticeStudy, trialsPracticeTest ] = createStimSequence( p )
%createStimOrders create randomized stimuli sequence to be presented at
%test and study

% 11/20/15 
% ps
% generates the stimulus order for cfs study, version 2AFC, pilot. 

%   Four study conditions (1/4 stims in each condition)
% 0 = .5 secs 
% 1 = 1 secs
% 2 = 1.5 secs
% 3 = 2 secs
% NOTE: secs refers to total presentation time, which includes ramping up
% and raming down

% also: items are presented x2 times


%% variables that define how many stimuli
p.nItems = 200; % nItems must be in multiples of 32
p.nItems_practice = 20;
p.nConds = 4;

p.nItemsPerStudyCond = p.nItems/p.nConds; % 1/4 of total items for each condition
p.nItemsPerTestCond = p.nItemsPerStudyCond/2; % number of items from each condition displayed during each In/Ex block

%% Set up item Conditions

% choose random order of items.
p.tTypeStudy = randperm(p.nItems);

% set items into each condition
% 0 = .5 secs 
% 1 = 1 secs
% 2 = 1.5 secs
% 3 = 2 secs
p.itemCondition = zeros(1,p.nItems);

p.itemCondition(1:p.nItemsPerStudyCond) = 1; 
p.itemCondition(1+p.nItemsPerStudyCond:p.nItemsPerStudyCond*2) = 2; 
p.itemCondition(1+p.nItemsPerStudyCond*2:p.nItemsPerStudyCond*3) = 3; 
p.itemCondition(1+p.nItemsPerStudyCond*3:p.nItemsPerStudyCond*4) = 4;

p.cond.one = p.tTypeStudy(p.itemCondition==1);
p.cond.two = p.tTypeStudy(p.itemCondition==2);
p.cond.three = p.tTypeStudy(p.itemCondition==3);
p.cond.four = p.tTypeStudy(p.itemCondition==4);

stimTable = table(p.tTypeStudy',p.itemCondition');
stimTable.Properties.VariableNames{'Var1'} = 'stim';
stimTable.Properties.VariableNames{'Var2'} = 'itemCondition';

%% Set up study order

% first presentation
[studyOrder_first, index_first] = Shuffle(stimTable.stim);
itemCondition_study_first = stimTable.itemCondition(index_first);


p.studyOrder = studyOrder_first;
p.itemCondition_study = itemCondition_study_first;

p.stimTable = stimTable;
%% make textures for all of the stimuli

%--------------------------------------------------------------------------
% First, make study trials' textures
%--------------------------------------------------------------------------

% create study structure
trialsStudy = struct('name', num2cell(p.studyOrder));

% create field with trial type
itemCondition_study_cell = num2cell(p.itemCondition_study);
[trialsStudy(1:p.nItems).tType] = deal(itemCondition_study_cell{:});

% grab the names of all test items
% testNames = dir([p.root, '/stims/*.jpeg']);

% read data from all items, making composite image matrix (RGB + alpha columns) 
[study_images, ~, transperancy_study] = arrayfun(@(x) imread( [p.root, '/stims/testStim/object', num2str(x.name), '_lum150_sd32'], 'png'), trialsStudy, 'UniformOutput', 0);
study_images_wAlpha = cellfun(@(x, n) cat(3,x(:,:),n(:,:)), study_images, transperancy_study, 'UniformOutput', 0);

% make textures of images
cellStudy = num2cell(cellfun(@(x) Screen('MakeTexture',p.window,x), study_images_wAlpha));

% name textures of each stim
[trialsStudy(1:p.nItems).tex] = deal(cellStudy{:}); 

%--------------------------------------------------------------------------
% Next, make test trials' textures
%--------------------------------------------------------------------------

% grab the names of all test items
% create study structure
trialsTest = struct('name', num2cell(p.studyOrder));

% % create field with trial type
% itemCondition_test_cell = num2cell(p.itemCondition_test);
% [trialsTest(1:p.nItems).tType] = deal(itemCondition_test_cell{:});

% read data from all items, making composite image matrix (RGB + alpha columns) 
[test_images, ~, ~] = arrayfun(@(x) imread( [p.root, '/stims/apertures/object', num2str(x.name), '_pilotAp'], 'png'), trialsTest, 'UniformOutput', 0);
% test_images_wAlpha = cellfun(@(x, n) cat(3,x(:,:,1:3),n(:,:)), test_images, transperancy_test, 'UniformOutput', 0);

% make textures of images
cellTest = num2cell(cellfun(@(x) Screen('MakeTexture',p.window,x), test_images));

% name textures of each stim
[trialsTest(1:p.nItems).tex] = deal(cellTest{:}); 


%% finally, make textures for practice phase
p.practiceOrder_study = randperm(p.nItems_practice)+p.nItems; % practice items are numbered 120-125
p.itemCondition_practice_study = randi(p.nConds,1,p.nItems_practice);

% create practice_study structure
trialsPractice_study = struct('name', num2cell(p.practiceOrder_study));
trialsPractice_test = trialsPractice_study;

% create field with trial type
itemCondition_practice_study_cell = num2cell(p.itemCondition_practice_study);
[trialsPractice_study(1:p.nItems_practice).tType] = deal(itemCondition_practice_study_cell{:});


% read data from all items, making composite image matrix (RGB + alpha columns) 
[practiceStudy_images, ~, transperancy_pracStudy] = arrayfun(@(x) imread( [p.root, '/stims/whole/object', num2str(x.name), '_noBkgrd'], 'png'), trialsPractice_study, 'UniformOutput', 0);
practiceStudy_images_wAlpha = cellfun(@(x, n) cat(3,x(:,:),n(:,:)), practiceStudy_images, transperancy_pracStudy, 'UniformOutput', 0);
[practiceTest_images, ~, ~] = arrayfun(@(x) imread( [p.root, '/stims/apertures/object', num2str(x.name), '_pilotAp'], 'png'), trialsPractice_test, 'UniformOutput', 0);
% practiceTest_images_wAlpha = cellfun(@(x, n) cat(3,x(:,:,1:3),n(:,:)), practiceTest_images, transperancy_pracTest, 'UniformOutput', 0);

% make textures of images
cellPracticeStudy = num2cell(cellfun(@(x) Screen('MakeTexture',p.window,x), practiceStudy_images_wAlpha));
cellPracticeTest = num2cell(cellfun(@(x) Screen('MakeTexture',p.window,x), practiceTest_images));


% name textures of each stim
[trialsPracticeStudy(1:p.nItems_practice).tex] = deal(cellPracticeStudy{:}); 
[trialsPracticeTest(1:p.nItems_practice).tex] = deal(cellPracticeTest{:}); 


end

