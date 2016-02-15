function [ p, demoTrials ] = createStimSequence( p )
%createStimOrders loads participant's stim information and makes textures
%of it all

% 1/7/16 
% ps
% generates the stimulus order for cfs study, version 2AFC -> shortStudyLists. 


%% grab all items in stim folder
items = dir([p.root,'\demoStims']);
items = items(3:end);

p.nItems = length(items);

order = repmat(randperm(length(items)),[1,5]);
p.condition = Shuffle(repelem(1:4,length(order)/4));
p.condition(p.condition==3 | p.condition==4 | p.condition==2) = 0;

%% make textures for all of the stimuli

test=struct2cell(items);
fileNames = Shuffle(repelem(test(1,:),5));

p.nTrials = length(fileNames);
% create study structure
demoTrials = struct('name', num2cell(order));

% create field with trial type
itemCondition_study_cell = num2cell(p.condition);
[demoTrials(1:p.nTrials).tType] = deal(itemCondition_study_cell{:});

% read data from all items, making composite image matrix (RGB + alpha columns) 
[study_images, ~, transperancy_study] = cellfun(@(x) imread( [p.root, '\demoStims\' , x], 'png'), fileNames, 'UniformOutput', 0);
study_images_wAlpha = cellfun(@(x, n) cat(3,x(:,:),n(:,:)), study_images, transperancy_study, 'UniformOutput', 0);

% make textures of images
cellStudy = num2cell(cellfun(@(x) Screen('MakeTexture',p.window,x), study_images_wAlpha));

% name textures of each stim
[demoTrials(1:p.nTrials).tex] = deal(cellStudy{:}); 


end

