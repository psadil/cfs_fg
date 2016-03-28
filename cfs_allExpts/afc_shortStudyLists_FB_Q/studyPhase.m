function [p] = studyPhase(p, studyTrials, list, studyWords, inputHandler, input)
% studyPhase


% called by: experimentalPhase
% calls: studyInstructions, presentStudyImage, and studyResp



%% preliminary
p.startStudyPhase = GetSecs;



%% question text
[text_Qs, text_As, studyInstr] = defineQs;

%% which items in this study list

currentListInd = p.ind.studyList(list):(p.ind.studyList(list) + p.nItems.list_total-1);


%% enter the trial loop ------------------
for studyItem = 1:p.nItems.list_total
    
    trial = currentListInd(studyItem);
    
    % item on list to be grabbed, p.ind.study acts sort of like a call to
    % mod
    item = p.ind.study(trial);
    
    p.timing.trialStart_study(trial) = GetSecs;
    
    % present image
    if p.stimTab.itemCond_study(item) == 1 % if foil
        p.wordTrial(trial) = 0;
        catchTrialTest = rand(1);
        
        if catchTrialTest > p.catchRatio
            p.foilPresent(trial) = 0;
            txt = 'FOIL, NOT PRESENTED';
            p.responses.study(trial,1:length(txt)) = txt;
            continue
        else
            p.foilPresent(trial) = 1;
            leftRight = [0,0]; % neither eye gets image
            txt = 'FOIL, PRESENTED';
            p.responses.study(trial,1:length(txt)) = txt;
        end
        
    elseif p.stimTab.itemCond_study(item) == 2 % if 2: word
        p.wordTrial(trial) = 1;
        stimWord = studyWords{item};
        
        leftRight = [1,1]; % non-dom eye (left) receives image+white square (while dom (right) receives image+mondrian)
    elseif p.stimTab.itemCond_study(item) == 3% if 3: CFS
        p.wordTrial(trial) = 0;
        if p.rightEyeDom
            leftRight = [1,0]; % call CFS with left eye == image+mondrian, right eye == mondrian
        else
            leftRight = [0,1]; % call CFS with left eye == mondrian, right eye == image+mondrian
        end
    elseif p.stimTab.itemCond_study(item) == 4% if 4: binoc
        p.wordTrial(trial) = 0;
        leftRight = [1,1];
    end
    
    
    %----------------------------------------------------------------------
    % present Study Item
    %----------------------------------------------------------------------
    
    % grab appropriate study instructions
    studyStimInstructions(p, studyInstr{p.stimTab.itemCond_study(item)});
    
    if ~p.wordTrial(trial)
        stim = studyTrials(item).tex;
    else
        stim = stimWord;
        Screen('TextSize',p.window, p.wordStimFont);
    end
    

    p = presentStudyStim(p, trial, stim, leftRight, p.texAlpha, input);

    
    p.timing.startStudyResp_dur(trial) = GetSecs;
    
    %----------------------------------------------------------------------
    % solicit and collect PAS response
    %----------------------------------------------------------------------
    
    if all(leftRight == 0)
        p.testQ(trial) = 0; % don't ask question on catch trial
    else
        % decide on which question to ask
        p.testQ(trial) = randi([1,4],1);
        p = studyResp(p, trial, 'y1', inputHandler, input, text_Qs{p.testQ(trial)}, text_As);
    end
    
    
    p.timing.endStudyResp_dur(trial) = GetSecs;
    p.dur.studyResp(trial) = p.timing.endStudyResp_dur(trial) - p.timing.startStudyResp_dur(trial);
    
    p.timing.trialEnd_study(trial) = GetSecs;
    p.dur.trial_study(trial) = p.timing.trialEnd_study(trial)-p.timing.trialStart_study(trial);
    
    iti(p.window,p.iti);
    
end


p.endStudyPhase = GetSecs;
p.dur.StudyPhase = p.endStudyPhase - p.startStudyPhase;

Screen('Close',[studyTrials.tex]);

end