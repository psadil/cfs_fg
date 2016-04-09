function [ p ] = experimentalPhase(p, practice, input, inputHandler, subDir)
%experimentalPhase calls study and practice phases, for real this time
%   Detailed explanation goes here


%% Define text and placement

if practice
    
    %text to display
    text_beginPrac1_1 = 'In this experiment, you will be asked to study 8 lists of objects. After studying each list, your memory for details of those objects will be tested.';
    text_beginPrac2_1 = 'You will first complete one study/test cycle as practice. This cycle will look exactly like what you will encounter in the full experiment. Feel free to grab the experimenter if you have any questions.';
    text_end = 'Congrats! That''s the end of the practice phase. Please find the experimentor to continue';
    
    %placement of that text
    tCenter_BeginPrac1_1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_beginPrac1_1))/2  p.yCenter-160];
    tCenter_BeginPrac2_1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_beginPrac2_1))/2  p.yCenter];
    
else
    text_end = 'The experiment is now over. Thanks for participating!';
end

% text
text_endStudy1 = 'Congratulations! This study phase is over.';
text_endStudy2 = 'A test phase will begin in a few seconds.';

% begin study phase text
text_start_study = 'A study phase will begin when you press the space bar. DO NOT lean towards the monitor. REMEMBER: please keep your eyes relaxed and focused on the white square in the center of the screen.';

% begin test phase text
text_start_test = 'A test phase will begin when you press the space bar.';


% placement of text
tCenterEndStudy1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_endStudy1))/2  p.yCenter-120];
tCenterEndStudy2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_endStudy2))/2  p.yCenter];
tCenterEnd = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_end))/2  p.yCenter];
tCenterStartStudy = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_start_study))/2  p.yCenter];
tCenterStartTest = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_start_test))/2  p.yCenter];


%% initialize storage variables

%--------------------------------------------------------------------------
% Study
%--------------------------------------------------------------------------

% timing variables
p.timing.upStudy_whole = zeros(p.nTrials,1);
p.timing.downStudy_whole = zeros(p.nTrials,1);

p.dur.study_whole = zeros(p.nTrials,1); % also contains rt for breakthrough
p.dur.trial_study = zeros(p.nTrials,1);

p.timing.trialStart_study = zeros(p.nTrials,1);
p.timing.trialEnd_study = zeros(p.nTrials,1);

p.timing.startStudyResp_dur = zeros(1,p.nTrials);
p.timing.endStudyResp_dur = zeros(1,p.nTrials);
p.timing.startStudyResp_rt = zeros(1,p.nTrials);
p.timing.endStudyResp_rt = zeros(1,p.nTrials);

p.timing.startStudyPhase = zeros(p.nStudyLists,1);
p.timing.endStudyPhase = zeros(p.nStudyLists,1);
p.dur.studyPhase = zeros(p.nStudyLists,1);

% item name variables
p.responses.study = char(zeros(p.nTrials,50));
p.testQ = zeros(p.nTrials,1);
p.rt.study = zeros(p.nTrials,50);
p.dur.studyInstr = zeros(p.nTrials,1);

p.wordTrial = zeros(p.nTrials,1);
p.foilPresent = zeros(p.nTrials,1);

%--------------------------------------------------------------------------
% Test
%--------------------------------------------------------------------------

p.timing.stimUpTest = zeros(p.nItems.unique,1);
p.timing.stimDownTest = zeros(p.nItems.unique,1);
p.dur.recall = zeros(p.nItems.unique,1);

p.timing.startRecallResp_dur = zeros(1,p.nItems.unique,1);
p.timing.endRecallResp_dur = zeros(1,p.nItems.unique,1);
p.timing.startRecallResp_rt = zeros(1,p.nItems.unique,1);
p.timing.endRecallResp_rt = zeros(1,p.nItems.unique,1);

p.timing.trialStart_test = zeros(1, p.nItems.unique);
p.timing.trialEnd_test = zeros(1, p.nItems.unique);

p.timing.startTestPhase = zeros(p.nStudyLists,1);
p.timing.endTestPhase = zeros(p.nStudyLists,1);
p.dur.testPhase = zeros(1,p.nStudyLists);

p.rt.recall = zeros(p.nItems.unique,50);
p.responses.recall = char(zeros(p.nItems.unique,50));
p.responses.afc = zeros(p.nItems.unique,1);
p.rt.afc = zeros(p.nItems.unique,50);

p.test_leftRight = zeros(p.nItems.unique,1);


vbl = iti(p.window,p.iti);
if practice
    %% preliminary text to introduce practice
    
    KbQueueCreate(0,p.keys_Navigation);
    KbQueueStart;
    KbQueueReserve(1, 2, 0)
    
    
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0));
    DrawFormattedText(p.window,text_beginPrac1_1,'center', tCenter_BeginPrac1_1(2),[],p.wrapat,[],[],1.5);
    DrawFormattedText(p.window,text_beginPrac2_1,'center', tCenter_BeginPrac2_1(2),[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar
    
    % other eye
    Screen('SelectStereoDrawBuffer',p.window,(1));
    DrawFormattedText(p.window,text_beginPrac1_1,'center', tCenter_BeginPrac1_1(2),[],p.wrapat,[],[],1.5);
    DrawFormattedText(p.window,text_beginPrac2_1,'center', tCenter_BeginPrac2_1(2),[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar
    
    % flip
    Screen('DrawingFinished', p.window);
    Screen('Flip', p.window,vbl + (p.hzRate-.5)*p.ifi);
    
    while 1
        listen(input.debugLevel, 'space');
        
        % receive input
        [pressed, resp] = KbQueueCheck;
        if pressed
            if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
            if resp(p.space)
                break;
            end
        end
        
    end
    
end


%% run study/test cycles as per number of study lists

if practice
    nStudyLists = 1;
else
    nStudyLists = p.nStudyLists;
end

for list = 1:nStudyLists
    
    if practice
        listText = ['You are on practice list ', num2str(list), ' out of ', num2str(nStudyLists)];
    else
        listText = ['You are on study list ', num2str(list), ' out of ', num2str(nStudyLists)];
    end
    %----------------------------------------------------------------------
    % study phase
    %----------------------------------------------------------------------
    
    if list == 1
        studyInstructions(p, input);
    end
    
    
    %----------------------------------------------------------------------
    % brief 'get prepared for a study list'
    %----------------------------------------------------------------------
    vbl = iti(p.window,p.iti);
    
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0));
    DrawFormattedText(p.window,text_start_study,'center', tCenterStartStudy(2) - 100,[],p.wrapat,[],[],1.5);
    DrawFormattedText(p.window,listText,'center', tCenterStartStudy(2)+40,[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar
    
    % other eye
    Screen('SelectStereoDrawBuffer',p.window,(1));
    DrawFormattedText(p.window,text_start_study,'center', tCenterStartStudy(2)- 100,[],p.wrapat,[],[],1.5);
    DrawFormattedText(p.window,listText,'center', tCenterStartStudy(2)+40,[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar
    
    % present to screen
    Screen('DrawingFinished', p.window);
    Screen('Flip', p.window,vbl + (p.hzRate-.5)*p.ifi);
    
    while 1
        listen(input.debugLevel, 'space');
        
        % receive input
        [pressed, resp] = KbQueueCheck;
        if pressed
            if resp(p.escape); sca; return; end
            if resp(p.space)
                break;
            end
        end
    end
    %----------------------------------------------------------------------
    % generate study textures
    %----------------------------------------------------------------------
    if practice
        [ texs, words ] = genBlockTexs(p.stimTab_prac, list, p.window,1);
    else
        [ texs, words ] = genBlockTexs(p.stimTab, list, p.window,1);
    end
    
    
    
    %-----------------------------------------------
    % enter study phase trials
    %-----------------------------------------------
    
    if p.studyPhase
        [p] = studyPhase(p, texs, list, words, inputHandler, input);
    end
    Screen('Close', [texs.tex]);
    
    
    %----------------------------------------------------------------------
    % brief break
    %----------------------------------------------------------------------
    vbl = iti(p.window,p.iti);
    KbQueueCreate(0,p.keys_Navigation);
    now = GetSecs;
    KbQueueStart;
    
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0));
    Screen('DrawText', p.window, text_endStudy1, tCenterEndStudy1(1), tCenterEndStudy1(2), p.textColor);
    Screen('DrawText', p.window, text_endStudy2, tCenterEndStudy2(1), tCenterEndStudy2(2), p.textColor);
    
    % other eye
    Screen('SelectStereoDrawBuffer',p.window,(1));
    Screen('DrawText', p.window, text_endStudy1, tCenterEndStudy1(1), tCenterEndStudy1(2), p.textColor);
    Screen('DrawText', p.window, text_endStudy2, tCenterEndStudy2(1), tCenterEndStudy2(2), p.textColor);
    
    % present to screen
    Screen('DrawingFinished', p.window);
    Screen('Flip', p.window,vbl + (p.hzRate-.5)*p.ifi);
    
    while GetSecs <= now + p.break
        listen(input.debugLevel, 'space');
        
        % wait for input
        [pressed, resp] = KbQueueCheck;
        if pressed
            if resp(p.escape); ListenChar(0); sca; return; end
        end
    end
    
    %----------------------------------------------------------------------
    % generate test textures
    %----------------------------------------------------------------------
    if practice
        [ texs, words ] = genBlockTexs(p.stimTab_prac, list, p.window,0);
    else
        [ texs, words ] = genBlockTexs(p.stimTab, list, p.window,0);
    end
    
    %----------------------------------------------------------------------
    %  test phase
    %----------------------------------------------------------------------
    
    if list == 1
        testInstructions(p, input);
    end
    
    
    %----------------------------------------------------------------------
    % brief 'get prepared for testing'
    %----------------------------------------------------------------------
    vbl = iti(p.window,p.iti);
    
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0));
    Screen('DrawText', p.window, text_start_test, tCenterStartTest(1), tCenterStartTest(2), p.textColor);
    
    % other eye
    Screen('SelectStereoDrawBuffer',p.window,(1));
    Screen('DrawText', p.window, text_start_test, tCenterStartTest(1), tCenterStartTest(2), p.textColor);
    
    % present to screen
    Screen('DrawingFinished', p.window);
    Screen('Flip', p.window,vbl + (p.hzRate-.5)*p.ifi);
    
    while 1
        listen(input.debugLevel, 'space');
        
        % input
        [pressed, resp] = KbQueueCheck;
        if pressed
            if resp(p.escape); ListenChar(0); sca;
                return;
            elseif resp(p.space)
                break
            end
        end
    end
    
    
    [p] = testPhase(p, texs, list, practice, words, input, inputHandler);
    Screen('Close', [texs.ap1, texs.ap2, texs.ap3]);
    
    % save after each list
    if practice
        save([subDir, '\practiceList.mat'], 'p', 'input');
    else
        save([subDir, '\list', num2str(list), '.mat'], 'p', 'input');
    end
end


%% closing remarks, or instructions to grab experimentor

vbl = iti(p.window,p.iti);
KbQueueCreate(0,p.keys_Navigation);
KbQueueStart;


now = GetSecs;


% one eye
Screen('SelectStereoDrawBuffer',p.window,(0));
DrawFormattedText(p.window,text_end,'center', tCenterEnd(2),[],p.wrapat,[],[],1.5);

% other eye
Screen('SelectStereoDrawBuffer',p.window,(1));
DrawFormattedText(p.window,text_end,'center', tCenterEnd(2),[],p.wrapat,[],[],1.5);

% present to screen
Screen('DrawingFinished', p.window);
Screen('Flip', p.window,vbl + (p.hzRate-.5)*p.ifi);

while (GetSecs <= now + p.break) || practice
    listen(input.debugLevel, 'space');
    
    % input
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); sca;
            return;
        elseif resp(p.space)
            break;
        end
    end
end



end



function [ texs, words ] = genBlockTexs( stimTab_full, list,window,study )
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



% load('objectNames_2afc.mat');
[~, stimNames] = xlsread('objectNames_2afc.xlsx');

% this loads variable 'stimNames', a 221x3 cell

if study
    %% study textures
    
    % create study structure
    texs = struct('name', num2cell(stimTab_block.studyOrder));
    
    % create field with trial type
    itemCondition_study_cell = num2cell(stimTab_block.itemCond_study);
    [texs(1:size(texs,1)).tType] = deal(itemCondition_study_cell{:});
    
    % read data from all items, making composite image matrix (RGB + alpha columns)
    [study_images, ~, transperancy_study] = arrayfun(@(x) imread( [pwd, '/stims/expt/whole/object', num2str(x.name), '_noBkgrd'], 'png'), texs, 'UniformOutput', 0);
    study_images_wAlpha = cellfun(@(x, n) cat(3,x(:,:),n(:,:)), study_images, transperancy_study, 'UniformOutput', 0);
    
    % make textures of images
    cellStudy = num2cell(cellfun(@(x) Screen('MakeTexture',window,x), study_images_wAlpha));
    
    % name textures of each stim
    [texs(1:size(texs,1)).tex] = deal(cellStudy{:});
    
    %--------------------------------------------------------------------------
    % Next, make study word textures
    %--------------------------------------------------------------------------
    words = stimNames(stimTab_block.studyOrder,1);
    
else
    % test textures
    
    % grab the names of all test items
    % create study structure
    texs = struct('name', num2cell(stimTab_block.testOrder));
    
    % create field with pairing
    itemPair_test_cell = num2cell(stimTab_block.testPair);
    [texs(1:size(texs,1)).pair] = deal(itemPair_test_cell{:});
    
    % grab all of each apertures
    [test_ap1, ~, alpha1] = arrayfun(@(x) imread( [pwd,...
        '/stims/expt/apertures/object', num2str(x.name), '_paired', num2str(x.pair), '_ap1'], 'png'), ...
        texs, 'UniformOutput', 0);
    test_ap1_wAlpha = cellfun(@(x, n) cat(3,x,x,x,n), test_ap1, alpha1, 'UniformOutput', 0);
    
    
    [test_ap2, ~, alpha2] = arrayfun(@(x) imread( [pwd,...
        '/stims/expt/apertures/object', num2str(x.name), '_paired', num2str(x.pair), '_ap2'], 'png'), ...
        texs, 'UniformOutput', 0);
    testOne = cellfun(@(x, n) cat(3,x,x,x,n), test_ap2, alpha2, 'UniformOutput', 0);
    
    [test_ap3, ~, alpha3] = arrayfun(@(x) imread( [pwd,...
        '/stims/expt/apertures/object', num2str(x.pair), '_paired', num2str(x.name), '_ap3'], 'png'), ...
        texs, 'UniformOutput', 0);
    testTwo = cellfun(@(x, n) cat(3,x,x,x,n), test_ap3, alpha3, 'UniformOutput', 0);
    
    % make textures of images
    cellTestAp1 = num2cell(cellfun(@(x) Screen('MakeTexture',window,x), test_ap1_wAlpha));
    cellTestAp2 = num2cell(cellfun(@(x) Screen('MakeTexture',window,x), testOne));
    cellTestAp3 = num2cell(cellfun(@(x) Screen('MakeTexture',window,x), testTwo));
    
    % name textures of each stim
    [texs(1:size(texs,1)).ap1] = deal(cellTestAp1{:});
    
    % the following get randomly chosen so that each are presented on left and
    % right sides of screen during 2afc (don't want the 1 / 2 pair to always be
    % on the same side)
    [texs(1:size(texs,1)).ap2] = deal(cellTestAp2{:});
    [texs(1:size(texs,1)).ap3] = deal(cellTestAp3{:});
    
    
    %--------------------------------------------------------------------------
    % Next, make study word textures
    %--------------------------------------------------------------------------
    words = stimNames(stimTab_block.testOrder,1);
    
end


end
