function [p] = testPhase(p, trialsTest, list)
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


%% Text for both trials
text_begin = 'A test phase will begin when you press the space bar.';

% placement of text
tCenter_Begin = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_begin))/2  p.yCenter];



%% enter the TEST loop
p.timing.startTestPhase(list) = GetSecs;
rTcnt = 1;

currentListInd = p.ind.testList(list):(p.ind.testList(list) + p.nItems.studyList-1);

for testItem = 1:p.nItems.studyList
    
    trial = currentListInd(testItem);
    item = p.ind.test(trial);
    
    p.timing.trialStart_test(trial) = GetSecs;
    
    % record the trial onset time
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawingFinished', p.window);
    Screen('Flip', p.window);
    
    %% begin 2afc response
    
    % decide which side to present
    p.test_leftRight(trial) = randi([1,2],1);
    
    if p.test_leftRight(trial) == 1
        p = afcResp(p,trialsTest(item).p1, trialsTest(item).p2,trial);
    else
        p = afcResp(p,trialsTest(item).p2, trialsTest(item).p1,trial);
    end
    
    
    %% begin recall response
    
    p.timing.startRecallResp_dur(trial) = GetSecs;
    
    p = recallResp(p, trialsTest(item).ap1, trial);
    
    p.timing.endRecallResp_dur(trial) = GetSecs;
    p.dur.Recall(trial) = p.timing.endRecallResp_dur(trial) - p.timing.startRecallResp_dur(trial);
    
    
    %% short interval between trials
    
    waitSomeSecs(.5, p);
    
    
    %cumTime = cumTime + p.trialDur; % tells program to wait until trialDur has expired
    rTcnt = rTcnt+1;
    p.timing.trialEnd_test(trial) = GetSecs;
    p.dur.trial_test(trial) = p.timing.trialEnd_test(trial)-p.timing.trialStart_test(trial);
end %end of loop over all test items

end