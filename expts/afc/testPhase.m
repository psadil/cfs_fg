function [p] = testPhase(p, trialsTest)
% testPhase called by runPDP_objects_apertures

% calls testInstructions, recallResp

% eh? not sure what needs closing at this point...
% Screen('Close');

%% stimulus parameters ---------------------------------
p.stimDur = 1000;          % maximum stimulus duration 10000 seconds (and time p.window for responding 1-6)
p.recallRespWin = 20;    % up to 20 (more) seconds to respond with object's name (terminates when response entered)
p.trialDur = p.stimDur+p.recallRespWin;
p.nStills = round(p.stimDur*1000/p.frame_dur); %30

%---------------------------------
% initialize some storage variables
%---------------------------------
p.timing.stimUpTest = zeros(p.nItems,1);
p.timing.stimDownTest = zeros(p.nItems,1);
p.dur.recall = zeros(p.nItems,1);

p.timing.startRecallResp_dur = zeros(1,p.nItems,1);
p.timing.endRecallResp_dur = zeros(1,p.nItems,1);
p.timing.startRecallResp_rt = zeros(1,p.nItems,1);
p.timing.endRecallResp_rt = zeros(1,p.nItems,1);

p.timing.trialStart_test = zeros(1, p.nItems);
p.timing.trialEnd_test = zeros(1, p.nItems);

p.timing.startTestPhase = [0 0];     % which ever comes first (in or ex) will be first element referenced
p.timing.endTestPhase = [0 0];
p.dur.TestPhase = [0 0];

p.rt.recall = zeros(1,p.nItems);
p.responses.recall = char(zeros(p.nItems,20));

p.test_leftRight = zeros(p.nItems,1);


%% Text for both trials
text_begin = 'The test phase of the experiment will begin when you press the space bar.';
text_endHalf = 'You have completed half of the test trials! Press Space to continue to the next half.';

% placement of text
tCenter_Begin = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_begin))/2  p.yCenter];
tCenter_EndHalf = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_endHalf))/2  p.yCenter];


%% Begin testing

p = testInstructions(p);

%------------------------
% bit before beginning test
while 1
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawText', p.window, text_begin, tCenter_Begin(1), tCenter_Begin(2), p.textColor);
    
    % other eye
    Screen('SelectStereoDrawBuffer',p.window,(1));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawText', p.window, text_begin, tCenter_Begin(1), tCenter_Begin(2), p.textColor);
    
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

%% enter the TEST loop
p.timing.startTestPhase(block) = GetSecs;
rTcnt = 1;


for trial = 1:p.nItems
    p.timing.trialStart_test(trial) = GetSecs;
    
    % record the trial onset time
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawingFinished', p.window);
    Screen('Flip', p.window);
    
    %% begin 2afc response
    
    % decide which side to present
    p.test_leftRight(trial) = randi([1,2],1);
    
    if p.test_leftRight(trial) == 1
        p = afcResp(p,trialsTest(trial).p1, trialsTest(trial).p2);
    else
        p = afcResp(p,trialsTest(trial).p2, trialsTest(trial).p1);
    end
    
    
    %% begin recall response
    
    p.timing.startRecallResp_dur(trial) = GetSecs;
    
    p = recallResp(p, trialsTest(trial).ap1, trial);
    
    p.timing.endRecallResp_dur(trial) = GetSecs;
    p.dur.Recall(trial) = p.timing.endRecallResp_dur(trial) - p.timing.startRecallResp_dur(trial);
    
    
    %% short interval between trials
    
    %         Screen('Close',testImageTexture);
    
    waitSomeSecs(.5, p);
    
    
    %cumTime = cumTime + p.trialDur; % tells program to wait until trialDur has expired
    rTcnt = rTcnt+1;
    p.timing.trialEnd_test(trial) = GetSecs;
    p.dur.trial_test(trial) = p.timing.trialEnd_test(trial)-p.timing.trialStart_test(trial);
end %end of loop over all test items

%     if block == 1,  % give congratulations for end of first half
%         while 1
%
%             % one eye
%             Screen('SelectStereoDrawBuffer',p.window,(0));
%             Screen(p.window,'DrawTexture', p.texture_ITI);
%             Screen('DrawText', p.window, text_endHalf, tCenter_EndHalf(1), tCenter_EndHalf(2), p.textColor);
%
%             % other eye
%             Screen('SelectStereoDrawBuffer',p.window,(1));
%             Screen(p.window,'DrawTexture', p.texture_ITI);
%             Screen('DrawText', p.window, text_endHalf, tCenter_EndHalf(1), tCenter_EndHalf(2), p.textColor);
%
%             % present to screen
%             Screen('DrawingFinished', p.window);
%             Screen('Flip', p.window);
%
%             % input
%             [pressed, resp] = KbQueueCheck;
%             if pressed
%                 if resp(p.escape); sca; return; end
%                 if resp(p.space)
%                     break;
%                 end
%             end
%         end
%     end
%

end