function [ p, trialsStudy, trialsTest, trialsPracticeStudy, trialsPracticeTest ] = createStimSequence( p )
%createStimOrders create randomized stimuli sequence to be presented at
%test and study

% 8/17/15 ps - updated so that items are now only shown once, and there is
% no binoc + CFS condition


%   Three study conditions (1/4 stims in each condition)
% 0 = no study (foils, seen as just mondrians)
% 1 = binocular study (whole object)
% 2 = CFS study (masked)

%   Half of each stims from each study condition are seen in each test
%   phase
% 1 = Inclusion
% 2 = Exclusion

% ANOVA will be 3 Study Conds X 2 Test Conds, repeated measures

%% variables that define how many stimuli
% load objectNames.mat
% if p.includeStudy
%     p.nItems = 32;
% else
    p.nItems = 120; % nItems must be in multiples of 32
% end
p.nItems_practice = 6;

p.nItemsPerStudyCond = p.nItems/3; % 1/3 of total items for each condition
p.nItemsPerTestCond = p.nItemsPerStudyCond/2; % number of items from each condition displayed during each In/Ex block
% p.nBinocCFS = p.nItemsPerTestCond/2;
% p.nBinocCFS_half = p.nBinocCFS/2;
% p.nInEx = p.nItems/2;

%% Set up item Conditions

% choose random order of items.
p.tTypeStudy = randperm(p.nItems);

% set items into each condition
% 0 == foil
% 1 == binocular
% 2 == CFS
p.itemCondition = zeros(1,p.nItems);

p.itemCondition(1:p.nItemsPerStudyCond) = 1; % first third goes to binocular
p.itemCondition(1+p.nItemsPerStudyCond:p.nItemsPerStudyCond*2) = 2; % second thrid to CFS
% last fourth left for foils

p.foils = p.tTypeStudy(p.itemCondition==0);
p.binoc = p.tTypeStudy(p.itemCondition==1);
p.CFS = p.tTypeStudy(p.itemCondition==2);

%% Set up study order

% only all of binocCFS seen in first and second half
studyFirstHalf = [p.binoc(1:p.nItemsPerTestCond), p.CFS(1:p.nItemsPerTestCond), p.foils(1:p.nItemsPerTestCond)];
studyOrder_firstHalf = Shuffle(studyFirstHalf);

studySecondHalf = [p.binoc(1+p.nItemsPerTestCond:p.nItemsPerStudyCond), p.CFS(1+p.nItemsPerTestCond:p.nItemsPerStudyCond), p.foils(1+p.nItemsPerTestCond:p.nItemsPerStudyCond)];
studyOrder_secondHalf = Shuffle(studySecondHalf);

% combine havles of study items
p.studyOrder = [studyOrder_firstHalf, studyOrder_secondHalf];

% determine they type of each study item
p.itemCondition_study = p.itemCondition(p.studyOrder);

%% Set up test order
% NOTE: need to be careful that In/Ex conditions contained balanced amounts
% of stims see in first and second half of study phase (so, p.nBinocCFS)

%rows go
% 1 = goes to FIRST half of test
% 2 = goes to SECOND half of test

binoc_test = [p.binoc(1:p.nItemsPerTestCond); p.binoc(1+p.nItemsPerTestCond:end)];
CFS_test = [p.CFS(1:p.nItemsPerTestCond); p.CFS(1+p.nItemsPerTestCond:end)];
foil_test = [p.foils(1:p.nItemsPerTestCond); p.foils(1+p.nItemsPerTestCond:end)];

% make the two test halves
itemsInTest_first = Shuffle([binoc_test(1,:),CFS_test(1,:),foil_test(1,:)]);
itemsInTest_second = Shuffle([binoc_test(2,:),CFS_test(2,:),foil_test(2,:)]);

% combine the two halves of test stimuli
p.testOrder = [itemsInTest_first, itemsInTest_second];

% find which kind of study item each test item was
p.itemCondition_test = p.itemCondition(p.testOrder);

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
[study_images, ~, transperancy_study] = arrayfun(@(x) imread( [p.root, '/stims/object', num2str(x.name), '_whole_noBackground'], 'png'), trialsStudy, 'UniformOutput', 0);
study_images_wAlpha = cellfun(@(x, n) cat(3,x(:,:,1:3),n(:,:)), study_images, transperancy_study, 'UniformOutput', 0);

% make textures of images
cellStudy = num2cell(cellfun(@(x) Screen('MakeTexture',p.window,x), study_images_wAlpha));

% name textures of each stim
[trialsStudy(1:p.nItems).tex] = deal(cellStudy{:}); 


%--------------------------------------------------------------------------
% Next, make test trials' textures
%--------------------------------------------------------------------------

% grab the names of all test items
% create study structure
trialsTest = struct('name', num2cell(p.testOrder));

% create field with trial type
itemCondition_test_cell = num2cell(p.itemCondition_test);
[trialsTest(1:p.nItems).tType] = deal(itemCondition_test_cell{:});

% grab the names of all test items
% testNames = dir([p.root, '/stims/*.jpeg']);

% read data from all items, making composite image matrix (RGB + alpha columns) 
[test_images, ~, transperancy_test] = arrayfun(@(x) imread( [p.root, '/stims/object', num2str(x.name), '_aperture_noBackground'], 'png'), trialsTest, 'UniformOutput', 0);
test_images_wAlpha = cellfun(@(x, n) cat(3,x(:,:,1:3),n(:,:)), test_images, transperancy_test, 'UniformOutput', 0);

% make textures of images
cellTest = num2cell(cellfun(@(x) Screen('MakeTexture',p.window,x), test_images_wAlpha));

% name textures of each stim
[trialsTest(1:p.nItems).tex] = deal(cellTest{:}); 


%% finally, make textures for practice phase
p.practiceOrder_study = randperm(6)+120; % practice items are numbered 120-125
p.practiceOrder_test = [Shuffle(p.practiceOrder_study(1:3)), Shuffle(p.practiceOrder_study(4:6))];

p.itemCondition_practice_study = [randperm(3), randperm(3)]-1;
p.itemCondition_practice_test = [randperm(3), randperm(3)]-1;

% create practice_study structure
trialsPractice_study = struct('name', num2cell(p.practiceOrder_study));

% create practice_study structure
trialsPractice_test = struct('name', num2cell(p.practiceOrder_test));

% create field with trial type
itemCondition_practice_study_cell = num2cell(p.itemCondition_practice_study);
[trialsPractice_study(1:p.nItems_practice).tType] = deal(itemCondition_practice_study_cell{:});
itemCondition_practice_test_cell = num2cell(p.itemCondition_practice_test);
[trialsPractice_test(1:p.nItems_practice).tType] = deal(itemCondition_practice_test_cell{:});

% read data from all items, making composite image matrix (RGB + alpha columns) 
[practiceStudy_images, ~, transperancy_pracStudy] = arrayfun(@(x) imread( [p.root, '/stims/object', num2str(x.name), '_whole_noBackground'], 'png'), trialsPractice_study, 'UniformOutput', 0);
practiceStudy_images_wAlpha = cellfun(@(x, n) cat(3,x(:,:,1:3),n(:,:)), practiceStudy_images, transperancy_pracStudy, 'UniformOutput', 0);
[practiceTest_images, ~, transperancy_pracTest] = arrayfun(@(x) imread( [p.root, '/stims/object', num2str(x.name), '_aperture_noBackground'], 'png'), trialsPractice_test, 'UniformOutput', 0);
practiceTest_images_wAlpha = cellfun(@(x, n) cat(3,x(:,:,1:3),n(:,:)), practiceTest_images, transperancy_pracTest, 'UniformOutput', 0);

% make textures of images
cellPracticeStudy = num2cell(cellfun(@(x) Screen('MakeTexture',p.window,x), practiceStudy_images_wAlpha));
cellPracticeTest = num2cell(cellfun(@(x) Screen('MakeTexture',p.window,x), practiceTest_images_wAlpha));

% cellPracticeStudy = num2cell(arrayfun(@(x) Screen('MakeTexture',p.window,imread( [p.root, '/stims/object', num2str(x.name), '_whole_noBackground'], 'png', 'background', 'none')),trialsPractice_study));
% cellPracticeTest = num2cell(arrayfun(@(x) Screen('MakeTexture',p.window,imread( [p.root, '/stims/object', num2str(x.name), '_aperture_noBackground'], 'png', 'BackgroundColor', 'none')),trialsPractice_test));

% name textures of each stim
[trialsPracticeStudy(1:p.nItems_practice).tex] = deal(cellPracticeStudy{:}); 
[trialsPracticeTest(1:p.nItems_practice).tex] = deal(cellPracticeTest{:}); 


end

