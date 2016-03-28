function [ texs_study, texs_test, studyWords, testWords ] = genBlockTexs( stimTab_full, list, window )
%genBlockTexs generates textures for 1 study/text cycle (block)

%% load


%   Four study conditions (1/4 stims in each condition)
% 1 = baseline (foil) 
% 2 = words
% 3 = cfs
% 4 = binoc
% NOTE: secs refers to total presentation time, which includes ramping up
% and raming down

% items studied in sets of 16 (including foils), presented x3 times

%% condense full stim table to just this list

stimTab_block = stimTab_full(stimTab_full.block == list,:);


%% study textures

% create study structure
texs_study = struct('name', num2cell(stimTab_block.studyOrder));

% create field with trial type
itemCondition_study_cell = num2cell(stimTab_block.itemCond_study);
[texs_study(1:size(texs_study,1)).tType] = deal(itemCondition_study_cell{:});

% read data from all items, making composite image matrix (RGB + alpha columns) 
[study_images, ~, transperancy_study] = arrayfun(@(x) imread( [pwd, '/stims/expt/whole/object', num2str(x.name), '_noBkgrd'], 'png'), texs_study, 'UniformOutput', 0);
study_images_wAlpha = cellfun(@(x, n) cat(3,x(:,:),n(:,:)), study_images, transperancy_study, 'UniformOutput', 0);

% make textures of images
cellStudy = num2cell(cellfun(@(x) Screen('MakeTexture',window,x), study_images_wAlpha));

% name textures of each stim
[texs_study(1:size(texs_study,1)).tex] = deal(cellStudy{:}); 

%--------------------------------------------------------------------------
% Next, make study word textures
%--------------------------------------------------------------------------
load('objectNames_2afc.mat');
% this loads variable 'stimNames', a 221x3 cell

studyWords = stimNames(stimTab_block.studyOrder,1);
testWords = stimNames(stimTab_block.testOrder,1);


%% test textures

% grab the names of all test items
% create study structure
texs_test = struct('name', num2cell(stimTab_block.testOrder));

% create field with pairing
itemPair_test_cell = num2cell(stimTab_block.testPair);
[texs_test(1:size(texs_test,1)).pair] = deal(itemPair_test_cell{:});

% grab all of each apertures
[test_ap1, ~, alpha1] = arrayfun(@(x) imread( [pwd,...
    '/stims/expt/apertures/object', num2str(x.name), '_paired', num2str(x.pair), '_ap1'], 'png'), ...
    texs_test, 'UniformOutput', 0);
test_ap1_wAlpha = cellfun(@(x, n) cat(3,x,x,x,n), test_ap1, alpha1, 'UniformOutput', 0);


[test_ap2, ~, alpha2] = arrayfun(@(x) imread( [pwd,...
    '/stims/expt/apertures/object', num2str(x.name), '_paired', num2str(x.pair), '_ap2'], 'png'), ...
    texs_test, 'UniformOutput', 0);
testOne = cellfun(@(x, n) cat(3,x,x,x,n), test_ap2, alpha2, 'UniformOutput', 0);

[test_ap3, ~, alpha3] = arrayfun(@(x) imread( [pwd,...
    '/stims/expt/apertures/object', num2str(x.pair), '_paired', num2str(x.name), '_ap3'], 'png'), ...
    texs_test, 'UniformOutput', 0);
testTwo = cellfun(@(x, n) cat(3,x,x,x,n), test_ap3, alpha3, 'UniformOutput', 0);

% make textures of images
cellTestAp1 = num2cell(cellfun(@(x) Screen('MakeTexture',window,x), test_ap1_wAlpha));
cellTestAp2 = num2cell(cellfun(@(x) Screen('MakeTexture',window,x), testOne));
cellTestAp3 = num2cell(cellfun(@(x) Screen('MakeTexture',window,x), testTwo));

% name textures of each stim
[texs_test(1:size(texs_test,1)).ap1] = deal(cellTestAp1{:}); 

% the following get randomly chosen so that each are presented on left and
% right sides of screen during 2afc (don't want the 1 / 2 pair to always be
% on the same side)
[texs_test(1:size(texs_test,1)).ap2] = deal(cellTestAp2{:}); 
[texs_test(1:size(texs_test,1)).ap3] = deal(cellTestAp3{:});


end