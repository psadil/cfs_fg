function [ p, trialsStudy, trialsPracticeStudy ] = createStimSequence( p )
%createStimOrders create randomized stimuli sequence to be presented at
%test and study

% 8/17/15 ps - updated so that items are now only shown once, and there is
% no binoc + CFS condition

% 19/4/15 ps - for pilot version, the different conditions relate only to
% the duration of cfs presentation (all items are in show with cfs)

%   Three study conditions (1/4 stims in each condition)
% 0 = 1.5 secs 
% 1 = 2 secs
% 2 = 2.5 secs
% 3 = 3 secs
% NOTE: secs refers to total presentation time, which includes ramping up
% and raming down

% also: items are presented x3 times

% ANOVA will be 4 Study Conds X 3 sutdy resps, repeated measures

%% variables that define how many stimuli
p.nItems = 120; % nItems must be in multiples of 32
p.nItems_practice = 6;
p.nConds = 4;

p.nItemsPerStudyCond = p.nItems/p.nConds; % 1/4 of total items for each condition
p.nItemsPerTestCond = p.nItemsPerStudyCond/2; % number of items from each condition displayed during each In/Ex block
% p.nBinocCFS = p.nItemsPerTestCond/2;
% p.nBinocCFS_half = p.nBinocCFS/2;
% p.nInEx = p.nItems/2;

%% Set up item Conditions

% choose random order of items.
p.tTypeStudy = randperm(p.nItems);

% set items into each condition
% 0 = 1.5 secs 
% 1 = 2 secs
% 2 = 2.5 secs
% 3 = 3 secs
p.itemCondition = zeros(1,p.nItems);

p.itemCondition(1:p.nItemsPerStudyCond) = 1; % first fourth goes to binocular
p.itemCondition(1+p.nItemsPerStudyCond:p.nItemsPerStudyCond*2) = 2; % second fourth to CFS
p.itemCondition(1+p.nItemsPerStudyCond*2:p.nItemsPerStudyCond*3) = 3; % second fourth to CFS

p.onePfive = p.tTypeStudy(p.itemCondition==0);
p.two = p.tTypeStudy(p.itemCondition==1);
p.twoPfive = p.tTypeStudy(p.itemCondition==2);
p.three = p.tTypeStudy(p.itemCondition==3);

stimTable = table(p.tTypeStudy',p.itemCondition');
stimTable.Properties.VariableNames{'Var1'} = 'stim';
stimTable.Properties.VariableNames{'Var2'} = 'itemCondition';

%% Set up study order

[p.studyOrder, index] = Shuffle(stimTable.stim);
p.itemCondition_study = stimTable.itemCondition(index);

stimTable.studyOrder = p.studyOrder;
stimTable.itemCondition_study = p.itemCondition_study;

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
[study_images, ~, transperancy_study] = arrayfun(@(x) imread( [p.root, '/stims/object', num2str(x.name), '_whole_noBackground'], 'png'), trialsStudy, 'UniformOutput', 0);
study_images_wAlpha = cellfun(@(x, n) cat(3,x(:,:,1:3),n(:,:)), study_images, transperancy_study, 'UniformOutput', 0);

% make textures of images
cellStudy = num2cell(cellfun(@(x) Screen('MakeTexture',p.window,x), study_images_wAlpha));

% name textures of each stim
[trialsStudy(1:p.nItems).tex] = deal(cellStudy{:}); 


%% finally, make textures for practice phase
p.practiceOrder_study = randperm(6)+120; % practice items are numbered 120-125
p.itemCondition_practice_study = [randperm(3), randperm(3)]-1;

% create practice_study structure
trialsPractice_study = struct('name', num2cell(p.practiceOrder_study));

% create field with trial type
itemCondition_practice_study_cell = num2cell(p.itemCondition_practice_study);
[trialsPractice_study(1:p.nItems_practice).tType] = deal(itemCondition_practice_study_cell{:});

% read data from all items, making composite image matrix (RGB + alpha columns) 
[practiceStudy_images, ~, transperancy_pracStudy] = arrayfun(@(x) imread( [p.root, '/stims/object', num2str(x.name), '_whole_noBackground'], 'png'), trialsPractice_study, 'UniformOutput', 0);
practiceStudy_images_wAlpha = cellfun(@(x, n) cat(3,x(:,:,1:3),n(:,:)), practiceStudy_images, transperancy_pracStudy, 'UniformOutput', 0);

% make textures of images
cellPracticeStudy = num2cell(cellfun(@(x) Screen('MakeTexture',p.window,x), practiceStudy_images_wAlpha));

% name textures of each stim
[trialsPracticeStudy(1:p.nItems_practice).tex] = deal(cellPracticeStudy{:}); 

end

