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
    
    % during debug, check for responses
%     KbQueueCreate(0,p.keys_simpleResp);
%     KbQueueStart;
%     KbQueueReserve(1, 2, 0)
%     if p.stimTab.itemCond_test(trial) > 1
%         giveAFC(input.debugLevel, p.test_leftRight(trial));
%     else
%         giveAFC(input.debugLevel, randi([1,2],1));
%     end
%     [~, resp] = KbQueueCheck;
%     afc = KbName(resp);
%     
        p.check.testCond(trial) = p.stimTab.itemCond_study(trial);
        p.check.testOrder(trial) = p.stimTab.studyOrder(trial);

    %% solicit afc resp
    if p.stimTab.itemCond_test(trial) > 1
        if p.test_leftRight(trial) == 1
            p = afcResp(p,trialsTest(item).ap1, trialsTest(item).ap2, trialsTest(item).ap3, trial, '1', input, inputHandler);
        else
            p = afcResp(p,trialsTest(item).ap1, trialsTest(item).ap3, trialsTest(item).ap2, trial, '2', input, inputHandler);
        end
    else
%         if p.test_leftRight(trial) == 1
%             p = afcResp(p,trialsTest(item).ap1, trialsTest(item).ap2, trialsTest(item).ap3, trial, '2', input, inputHandler);
%         else
%             p = afcResp(p,trialsTest(item).ap1, trialsTest(item).ap3, trialsTest(item).ap2, trial, '1', input, inputHandler);
%         end
        p = afcResp(p,trialsTest(item).ap1, trialsTest(item).ap2, trialsTest(item).ap3, trial, num2str(randi([1,2],1)), input, inputHandler);
        
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

p.timing.endTestPhase(list) = GetSecs;
p.dur.testPhase(list) = p.timing.endTestPhase(list) - p.timing.startTestPhase(list);

end


function giveAFC(debugLevel, resp)

% 

if debugLevel > 0

    string = num2str(resp);
    rob = java.awt.Robot;
    eval([ 'rob.keyPress(java.awt.event.KeyEvent.VK_', upper(string), ');' ]);
    eval([ 'rob.keyRelease(java.awt.event.KeyEvent.VK_', upper(string), ');' ]);
    
end

end
