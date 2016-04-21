function [p] = studyPhase(p, trialsStudy)
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

%---------------------------------
% initialize some storage variables
%---------------------------------
% timing variables
p.timing.upStudy_whole = zeros(p.nItems,1);
p.timing.downStudy_whole = zeros(p.nItems,1);

p.dur.study_whole = zeros(p.nItems,1);
p.dur.trial_study = zeros(p.nItems,1);

p.timing.trialStart_study = zeros(1, p.nItems);
p.timing.trialEnd_study = zeros(1, p.nItems);

p.timing.startStudyResp_dur = zeros(1,p.nItems);
p.timing.endStudyResp_dur = zeros(1,p.nItems);
p.timing.startStudyResp_rt = zeros(1,p.nItems);
p.timing.endStudyResp_rt = zeros(1,p.nItems);

% item name variables
p.responses.study = zeros(p.nItems,1);
p.rt.study = zeros(p.nItems,1);
% p.responses.study_name = char(zeros(p.nItems,20));

p.wordTrial = zeros(p.nItems,1);

%--------------------------------------------------------------------------
% text
text_start = 'The study phase of the experiment will begin when you press the space bar. REMEMBER: please keep your eyes relaxed and focused on the white square in the center of the screen. Also, DO NOT lean towards the monitor.';


% define placement of text
tCenterStart = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_start))/2  p.yCenter];


%% begin instructions

p = studyInstructions(p);

% after all initialization is done, sit and wait for space bar to begin
% study phase
while 1
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0));
    Screen('DrawTexture', p.window, p.texture_ITI);
    DrawFormattedText(p.window,text_start,'center', tCenterStart(2),[],p.wrapat,[],[],1.5);
    
    % other eye
    Screen('SelectStereoDrawBuffer',p.window,(1));
    Screen('DrawTexture', p.window, p.texture_ITI);
    DrawFormattedText(p.window,text_start,'center', tCenterStart(2),[],p.wrapat,[],[],1.5);
    
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


%% enter the trial loop ------------------

for trial = 1:p.nItems
    p.timing.trialStart_study(trial) = GetSecs;
    
    % present image
    if p.itemCondition_study(trial) == 1 % if foil
        p.wordTrial(trial) = 0;
        p.responses.study(trial) = 99999;
        continue
        %     %         leftRight = [0,0]; % call CFS with left and right eye as mondrians
        %             if p.rightEyeDom
        %                leftRight = [3,0]; % non-dom eye (left) -> white square, dom eye (right) -> mondrians
        %             else
        %                 leftRight = [0,3]; % non-dom eye (right) -> white square, dom eye (left) -> mondrians
        %             end
    elseif p.itemCondition_study(trial) == 2 % if 2: word
        Screen('TextSize',p.window, 48);
        p.wordTrial(trial) = 1;
        stimWord = p.words{trial};
        
        %         leftRight = [1,1]; % call CFS with left/righ eye == image+mondrian,
        %             if p.rightEyeDom
        leftRight = [1,1]; % non-dom eye (left) receives image+white square (while dom (right) receives image+mondrian)
        %             else
        %                 leftRight = [2,1]; % non-dom eye (right) receives image+white square (while dom (left) receives image+mondrian)
        %             end
    elseif p.itemCondition_study(trial) == 3% if 3: CFS
        p.wordTrial(trial) = 0;
        if p.rightEyeDom
            leftRight = [1,0]; % call CFS with left eye == image+mondrian, right eye == mondrian
        else
            leftRight = [0,1]; % call CFS with left eye == mondrian, right eye == image+mondrian
        end
    elseif p.itemCondition_study(trial) == 4% if 4: binoc
        p.wordTrial(trial) = 0;
        leftRight = [1,1];
        
    end
    
    %     if p.rightEyeDom
    %         leftRight = [1,0]; % non-dom eye (left) -> image, dom eye (right) -> mondrians
    %     else
    %         leftRight = [0,1]; % non-dom eye (right) -> image, dom eye (left) -> mondrians
    %     end
    
    %----------------------------------
    % decide presentation length
    %----------------------------------
    %     if p.itemCondition_study(trial) == 1 % 5 seconds
    texAlpha = p.texAlpha.secs_p_five;
    %     elseif p.itemCondition_study(trial) == 2 % 1 seconds
    %         texAlpha = p.texAlpha.secs_one;
    %     elseif p.itemCondition_study(trial) == 3 % 1.5 seconds
    %         texAlpha = p.texAlpha.secs_1p_five;
    %     elseif p.itemCondition_study(trial) == 4 % 2 seconds
    %         texAlpha = p.texAlpha.secs_two;
    %     end
    
    if ~p.wordTrial(trial)
        p = presentStudyImage(p,trial,trialsStudy(trial).tex, leftRight, texAlpha);
    else
        p = presentStudyWord(p,trial,stimWord, leftRight, texAlpha);
    end
    % solicit and collect their name for the object
    p.timing.startStudyResp_dur(trial) = GetSecs;
    
    % call function
    p = studyResp(p, trial);
    
    p.timing.endStudyResp_dur(trial) = GetSecs;
    p.dur.studyResp(trial) = p.timing.endStudyResp_dur(trial) - p.timing.startStudyResp_dur(trial);
    
    %     Screen('Close',texture_objectWhole);
    
    p.timing.trialEnd_study(trial) = GetSecs;
    p.dur.trial_study(trial) = p.timing.trialEnd_study(trial)-p.timing.trialStart_study(trial);
    
end %end of loop over all trials

% Screen('Close',p.texture_ITI);
% clear p.texture_ITI;

p.endStudyPhase = GetSecs;
p.dur.StudyPhase = p.endStudyPhase - p.startStudyPhase;

% data = p;
% save(fName, 'p');