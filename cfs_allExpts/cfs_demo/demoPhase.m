function [p] = demoPhase(p, demoTrials)
% studyPhase: called by buth experimentalPhase and practicePhase

% calls: presentStudyImage

%% study parameters

% stimulus parameters
p.studyDur = 2;   % stimulus duration in seconds [objects scenes]
p.respWin = 20;          % up to 20 sec to respond (not currently used)

p.nStills = round(p.studyDur*1000/p.frame_dur); %30

%-------------------------------------------------------------------------
% for mondrians
%-------------------------------------------------------------------------

% p.totalFrame = 600; % Frame length of the total frame, including 50px border
% p.maxL = 80; % Maximum and minimum length of suppressor rects
% p.minL = 30;
% p.numSuppressors = 1000;
% p.numSlides = 30;
% p.rects = [];




%% enter the trial loop ------------------
for trial = 1:p.nTrials
    
    
    %----------------------------------
    % determine item type
    %----------------------------------
    
    
    if p.condition(item) == 0 % CFS
        leftRight = [1,0]; % non-dom eye (left) receives image+white square (while dom (right) receives image+mondrian)
    elseif p.condition(item) == 1 %  binoc
        leftRight = [1,1];
    end
    
    
    %----------------------------------
    % present Study Item
    %----------------------------------
    
    p = presentStudyImage(p,trial,demoTrials(item).tex, leftRight, p.texAlpha);
    
end


end