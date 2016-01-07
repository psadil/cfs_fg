function [p] = studyPhase(p, trialsStudy,list)
% studyPhase: called by buth experimentalPhase and practicePhase
%
% calls: studyInstructions, presentStudyImage, and studyResp

% 8/17/15 ps - updated to no longer make reference to now nonexistant
% binoc+CFS condition

p.startStudyPhase = GetSecs;

%% study parameters
p.nItems = length(trialsStudy);

% stimulus parameters
p.studyDur = 2;   % stimulus duration in seconds [objects scenes]
p.respWin = 20;          % up to 20 sec to respond (not currently used)

p.nStills = round(p.studyDur*1000/p.frame_dur); %30

%-------------------------------------------------------------------------
% for mondrians
%-------------------------------------------------------------------------

p.totalFrame = 600; % Frame length of the total frame, including 50px border
p.maxL = 80; % Maximum and minimum length of suppressor rects
p.minL = 30;
p.numSuppressors = 1000;
p.numSlides = 30;
p.rects = [];

% % determines rate at which image slides in
% p.opac = [zeros(1,10) , logspace(log10(1),log10(75),20) , 75*ones(1,100)];


%% which items in this study list

currentListInd = p.ind.studyList(list):(p.ind.list(list) + p.nItems.list_total-1);


%% enter the trial loop ------------------
for studyItem = 1:p.nItems.list_total
    
    trial = currentListInd(studyItem);
    item = p.ind.study(trial);
    
    p.timing.trialStart_study(trial) = GetSecs;
    
    % present image
    if p.stimTab.itemCond_study(item) == 1 % if foil
        p.wordTrial(trial) = 0;
        p.responses.study(trial) = 99999;
        continue

    elseif p.stimTab.itemCond_study(item) == 2 % if 2: word
        Screen('TextSize',p.window, p.wordStimFont);
        p.wordTrial(trial) = 1;
        stimWord = p.words{trial};
        
        %         leftRight = [1,1]; % call CFS with left/righ eye == image+mondrian,
        %             if p.rightEyeDom
        leftRight = [1,1]; % non-dom eye (left) receives image+white square (while dom (right) receives image+mondrian)
        %             else
        %                 leftRight = [2,1]; % non-dom eye (right) receives image+white square (while dom (left) receives image+mondrian)
        %             end
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
    
    
    %----------------------------------
    % decide presentation length
    %----------------------------------
%     texAlpha = p.texAlpha.secs_p_five;
    
    if ~p.wordTrial(trial)
        p = presentStudyImage(p,trial,trialsStudy(item).tex, leftRight, p.texAlpha);
    else
        p = presentStudyWord(p,trial, stimWord, leftRight, p.texAlpha);
    end
    % solicit and collect their name for the object
    p.timing.startStudyResp_dur(trial) = GetSecs;
    
    % call function
    p = studyResp(p, trial);
    
    p.timing.endStudyResp_dur(trial) = GetSecs;
    p.dur.studyResp(trial) = p.timing.endStudyResp_dur(trial) - p.timing.startStudyResp_dur(trial);
        
    p.timing.trialEnd_study(trial) = GetSecs;
    p.dur.trial_study(trial) = p.timing.trialEnd_study(trial)-p.timing.trialStart_study(trial);
    
end


p.endStudyPhase = GetSecs;
p.dur.StudyPhase = p.endStudyPhase - p.startStudyPhase;

