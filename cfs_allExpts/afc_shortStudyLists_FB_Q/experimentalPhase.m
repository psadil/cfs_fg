function [ p ] = experimentalPhase(p, practice)
%experimentalPhase calls study and practice phases, for real this time
%   Detailed explanation goes here



%% Define text and placement

if practice
    
    %text to display
    text_beginPrac = 'You will first complete one study/test cycle as practice. This cycle will look exactly like what you will encounter in the full experiment. Feel free to grab the experimenter if you have any questions.';
    text_end = 'Congrats! That''s the end of the practice phase. Please find the experimentor to continue';
    
    %placement of that text
    tCenter_BeginPrac = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_beginPrac))/2  p.yCenter];
    
else
    text_end = 'The experiment is now over. Please wait for a moment while the Demographics questionnaire loads. There is nothing more to do after the questionnaire is complete.';
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

p.dur.study_whole = zeros(p.nTrials,1);
p.dur.trial_study = zeros(p.nTrials,1);

p.timing.trialStart_study = zeros(1, p.nTrials);
p.timing.trialEnd_study = zeros(1, p.nTrials);

p.timing.startStudyResp_dur = zeros(1,p.nTrials);
p.timing.endStudyResp_dur = zeros(1,p.nTrials);
p.timing.startStudyResp_rt = zeros(1,p.nTrials);
p.timing.endStudyResp_rt = zeros(1,p.nTrials);

% item name variables
p.responses.study = zeros(p.nTrials,1);
p.rt.study = zeros(p.nTrials,1);
% p.responses.study_name = char(zeros(p.nItems,20));

p.wordTrial = zeros(p.nTrials,1);

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

p.timing.startTestPhase = zeros(1,p.nStudyLists);     % which ever comes first (in or ex) will be first element referenced
p.timing.endTestPhase = zeros(1,p.nStudyLists);
p.dur.TestPhase = zeros(1,p.nStudyLists);

p.rt.recall = zeros(1,p.nItems.unique);
p.responses.recall = char(zeros(p.nItems.unique,20));

p.test_leftRight = zeros(p.nItems.unique,1);



if practice
    %% preliminary text to introduce practice
    
    KbQueueCreate(0,p.keys_Navigation);
    KbQueueStart;
    KbQueueReserve(1, 2, 0)
    
    while 1
        
        % one eye
        Screen('SelectStereoDrawBuffer',p.window,(0));
        Screen(p.window,'DrawTexture', p.texture_ITI);
        DrawFormattedText(p.window,text_beginPrac,'center', tCenter_BeginPrac(2),[],p.wrapat,[],[],1.5);
        Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar
        
        % other eye
        Screen('SelectStereoDrawBuffer',p.window,(1));
        Screen(p.window,'DrawTexture', p.texture_ITI);
        DrawFormattedText(p.window,text_beginPrac,'center', tCenter_BeginPrac(2),[],p.wrapat,[],[],1.5);
        Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar
        
        % flip
        Screen('DrawingFinished', p.window);
        Screen('Flip', p.window);
        
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
    
    %----------------------------------------------------------------------
    % study phase
    %----------------------------------------------------------------------
    
    if list == 1
        [ ~ ] = studyInstructions(p);
    end
    
    if practice
        [ texs_study, texs_test, studyWords ] = genBlockTexs(p.stimTab_prac, list, p.window);
    else
        [ texs_study, texs_test, studyWords ] = genBlockTexs(p.stimTab, list, p.window);
    end
    
    %----------------------------------------------------------------------
    % brief 'get prepared for a study list'
    %----------------------------------------------------------------------
    
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
        
        [p] = studyPhase(p, texs_study, list, studyWords);
        
    end
    
    %----------------------------------------------------------------------
    % brief break
    %----------------------------------------------------------------------
    
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
            if resp(p.escape); ListenChar(0); sca; return; end
        end
    end
    
    %----------------------------------------------------------------------
    %  test phase
    %----------------------------------------------------------------------
    
    if list == 1
        [ ~ ] = testInstructions(p);
    end
    
    
    %----------------------------------------------------------------------
    % brief 'get prepared for testing'
    %----------------------------------------------------------------------
    
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
    
    
    [p] = testPhase(p, texs_test, list, practice);
    
    
end


%% closing remarks

waitSomeSecs(.5,p);

KbQueueCreate(0,p.keys_Navigation);
KbQueueStart;

now = GetSecs;
while GetSecs <= now + 10
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    DrawFormattedText(p.window,text_end,'center', tCenterEnd(2),[],p.wrapat,[],[],1.5);
    
    
    % other eye
    Screen('SelectStereoDrawBuffer',p.window,(1));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    DrawFormattedText(p.window,text_end,'center', tCenterEnd(2),[],p.wrapat,[],[],1.5);
    
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