function [ p ] = experimentalPhase(p, trialsStudy, trialsTest)
%experimentalPhase calls study and practice phases, for real this time
%   Detailed explanation goes here

% text
text_endStudy1 = 'Congratulations! The study phase of the experiment is over.';
text_endStudy2 = 'The test phase of the experiment will begin in a few seconds.';

text_end = 'The experiment is now over. Thank you for your participation.';

% placement of text
tCenterEndStudy1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_endStudy1))/2  p.yCenter-120];
tCenterEndStudy2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_endStudy2))/2  p.yCenter];
tCenterEnd = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_end))/2  p.yCenter];

%%
%---------------------------------
% initialize some storage variables
%---------------------------------

%% Study

% timing variables
p.timing.upStudy_whole = zeros(p.nItems_studyList,1);
p.timing.downStudy_whole = zeros(p.nItems_total,1);

p.dur.study_whole = zeros(p.nItems_total,1);
p.dur.trial_study = zeros(p.nItems_total,1);

p.timing.trialStart_study = zeros(1, p.nItems_total);
p.timing.trialEnd_study = zeros(1, p.nItems_total);

p.timing.startStudyResp_dur = zeros(1,p.nItems_total);
p.timing.endStudyResp_dur = zeros(1,p.nItems_total);
p.timing.startStudyResp_rt = zeros(1,p.nItems_total);
p.timing.endStudyResp_rt = zeros(1,p.nItems_total);

% item name variables
p.responses.study = zeros(p.nItems_total,1);
p.rt.study = zeros(p.nItems_total,1);
% p.responses.study_name = char(zeros(p.nItems,20));

p.wordTrial = zeros(p.nItems_total,1);

%% Test

p.timing.stimUpTest = zeros(p.nItems_total,1);
p.timing.stimDownTest = zeros(p.nItems_total,1);
p.dur.recall = zeros(p.nItems_total,1);

p.timing.startRecallResp_dur = zeros(1,p.nItems_total,1);
p.timing.endRecallResp_dur = zeros(1,p.nItems_total,1);
p.timing.startRecallResp_rt = zeros(1,p.nItems_total,1);
p.timing.endRecallResp_rt = zeros(1,p.nItems_total,1);

p.timing.trialStart_test = zeros(1, p.nItems_total);
p.timing.trialEnd_test = zeros(1, p.nItems_total);

p.timing.startTestPhase = [0 0];     % which ever comes first (in or ex) will be first element referenced
p.timing.endTestPhase = [0 0];
p.dur.TestPhase = [0 0];

p.rt.recall = zeros(1,p.nItems_total);
p.responses.recall = char(zeros(p.nItems_total,20));

p.test_leftRight = zeros(p.nItems_total,1);

%%

% begin study phase text
text_start_study = 'A study phase will begin when you press the space bar. DO NOT lean towards the monitor. REMEMBER: please keep your eyes relaxed and focused on the white square in the center of the screen.';

% define placement of text
tCenterStartStudy = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_start_study))/2  p.yCenter];

% begin test phase text
text_start_test = 'A test phase will begin when you press the space bar.';

% define placement of text
tCenterStartTest = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_start_test))/2  p.yCenter];


%% run study/test cycles as per number of study lists

for list = 1:p.nStudyLists
    %% study phase
    
    
    %-----------------------------------------------
    % brief 'get prepared for a study list'
    %-----------------------------------------------
    
    while 1
        
        % one eye
        Screen('SelectStereoDrawBuffer',p.window,(0));
        Screen('DrawTexture', p.window, p.texture_ITI);
        DrawFormattedText(p.window,text_start_study,'center', tCenterStartStudy(2),[],p.wrapat,[],[],1.5);
        
        % other eye
        Screen('SelectStereoDrawBuffer',p.window,(1));
        Screen('DrawTexture', p.window, p.texture_ITI);
        DrawFormattedText(p.window,text_start_study,'center', tCenterStartStudy(2),[],p.wrapat,[],[],1.5);
        
        % present to screen
        Screen('DrawingFinished', p.window);
        Screen('Flip', p.window);
        
        % receive input
        [pressed, resp] = KbQueueCheck;
        if pressed
            if resp(p.escape); sca; return; end
            if resp(p.space)
                break;
            end
        end
    end
    
    
    %-----------------------------------------------
    % enter study phase trials
    %-----------------------------------------------
    
    if p.studyPhase
        try
            [p] = studyPhase(p, trialsStudy, list);
        catch err
            sca
            throw(err)
        end
    end
    
    %-----------------------------------------------
    % brief break
    %-----------------------------------------------
    
    KbQueueCreate(0,p.keys_Navigation);
    now = GetSecs;
    KbQueueStart;
    while GetSecs <= now + p.break
        
        % one eye
        Screen('SelectStereoDrawBuffer',p.window,(0));
        Screen('DrawTexture', p.window, p.texture_ITI);
        Screen('DrawText', p.window, text_endStudy1, tCenterEndStudy1(1), tCenterEndStudy1(2), p.textColor);
        Screen('DrawText', p.window, text_endStudy2, tCenterEndStudy2(1), tCenterEndStudy2(2), p.textColor);
        
        % other eye
        Screen('SelectStereoDrawBuffer',p.window,(1));
        Screen('DrawTexture', p.window, p.texture_ITI);
        Screen('DrawText', p.window, text_endStudy1, tCenterEndStudy1(1), tCenterEndStudy1(2), p.textColor);
        Screen('DrawText', p.window, text_endStudy2, tCenterEndStudy2(1), tCenterEndStudy2(2), p.textColor);
        
        % present to screen
        Screen('DrawingFinished', p.window);
        Screen('Flip', p.window);
        
        % wait for input
        [pressed, resp] = KbQueueCheck;
        if pressed
            if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
        end
    end
    
    
    %%  test phase
    
    %-----------------------------------------------
    % brief 'get prepared for testing'
    %-----------------------------------------------

    while 1
        
        % one eye
        Screen('SelectStereoDrawBuffer',p.window,(0));
        Screen(p.window,'DrawTexture', p.texture_ITI);
        Screen('DrawText', p.window, text_start_test, tCenterStartTest(1), tCenterStartTest(2), p.textColor);
        
        % other eye
        Screen('SelectStereoDrawBuffer',p.window,(1));
        Screen(p.window,'DrawTexture', p.texture_ITI);
        Screen('DrawText', p.window, text_start_test, tCenterStartTest(1), tCenterStartTest(2), p.textColor);
        
        % present to screen
        Screen('DrawingFinished', p.window);
        Screen('Flip', p.window);
        
        % input
        [pressed, resp] = KbQueueCheck;
        if pressed
            if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
            if resp(p.space)
                break;
            end
        end
    end
    
    
    try
        [p] = testPhase(p, trialsTest, list);
    catch err
        sca
        throw(err)
    end
    
    
end


%% closing remarks

KbQueueCreate(0,p.keys_Navigation);
KbQueueStart;

now = GetSecs;
while GetSecs<=now+1 % ITI for 1 seconds
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('Flip', p.window);
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
    end
end

while GetSecs <= now + 4
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawText', p.window, text_end, tCenterEnd(1), tCenterEnd(2), p.textColor);
    
    % other eye
    Screen('SelectStereoDrawBuffer',p.window,(1));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawText', p.window, text_end, tCenterEnd(1), tCenterEnd(2), p.textColor);
    
    % present to screen
    Screen('DrawingFinished', p.window);
    Screen('Flip', p.window);
    
    % input
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
    end
end


end

