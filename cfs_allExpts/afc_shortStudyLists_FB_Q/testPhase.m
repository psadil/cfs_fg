function [p] = testPhase(p, trialsTest, list, practice, testWords, input, inputHandler)
% testPhase called by runPDP_objects_apertures

% calls testInstructions, recallResp


%% question/recall specific text
text_recall = 'Please name an object that this could be part of; feel free to use your memory from the study phase if it helps.';



%% enter the TEST loop
p.timing.startTestPhase(list) = GetSecs;
rTcnt = 1;

currentListInd = p.ind.testList(list):(p.ind.testList(list) + p.nItems.studyList-1);

for testItem = 1:p.nItems.studyList
    
    trial = currentListInd(testItem);
    item = p.ind.test(trial);
    
    p.timing.trialStart_test(trial) = GetSecs;
    

    %% begin 2afc response
    
    % decide which side to present
    p.test_leftRight(trial) = randi([1,2],1);
    
    if p.test_leftRight(trial) == 1
        p = afcResp(p,trialsTest(item).ap1, trialsTest(item).ap2, trialsTest(item).ap3, trial, '1', input, inputHandler);
    else
        p = afcResp(p,trialsTest(item).ap1, trialsTest(item).ap3, trialsTest(item).ap2, trial, '2', input, inputHandler);
    end
    
    %% provide feedback
    p = feedback_afc(p, trial, input);
    
    
    
    %% begin recall response
    
    p.timing.startRecallResp_dur(trial) = GetSecs;
    
    p = recallResp(p, trialsTest(item).ap1, trial, text_recall, testWords{item}, inputHandler, input);
    
    p.timing.endRecallResp_dur(trial) = GetSecs;
    p.dur.Recall(trial) = p.timing.endRecallResp_dur(trial) - p.timing.startRecallResp_dur(trial);
    
    
    %% provide recall feedback, if practice phase
    if practice
        p = feedback_recall(p, testWords{trial}, input);
    end
    
    %% short interval between trials
    
    iti(p.window,p.iti);
    
    
    %cumTime = cumTime + p.trialDur; % tells program to wait until trialDur has expired
    rTcnt = rTcnt+1;
    p.timing.trialEnd_test(trial) = GetSecs;
    p.dur.trial_test(trial) = p.timing.trialEnd_test(trial)-p.timing.trialStart_test(trial);
end %end of loop over all test items

end