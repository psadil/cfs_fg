function [p] = studyPhase(p, trialsStudy)
% studyPhase: called by buth experimentalPhase and practicePhase
% 
% calls: studyInstructions, presentStudyImage, and studyResp

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

% determines rate at which image slides in
p.opac = [zeros(1,10) , logspace(log10(1),log10(75),20) , 75*ones(1,100)];

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
p.responses.study = char(zeros(p.nItems,20));
p.rt.study = zeros(p.nItems,1);

%--------------------------------------------------------------------------
% text
text_start = 'The study phase of the experiment will begin when you press the space bar. REMEMBER: please keep your eyes focused on the white dot in the center of the screen.';


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
    if p.itemCondition_study(trial) == 0 % if foil
        leftRight = [0,0]; % call CFS with left and right eye as mondrians
    elseif any(p.itemCondition_study(trial) == [1,3]) % if 1 or 3 binoc (binoc or binocCFS)
        leftRight = [1,1]; % call CFS with left/righ eye == image+mondrian,
    elseif any(p.itemCondition_study(trial) == [2,4])% if 2 or 4 CFS (CFS or CFSbinoc)
        if p.rightEyeDom
            leftRight = [1,0]; % call CFS with left eye == image+mondrian, right eye == mondrian
        else
            leftRight = [0,1]; % call CFS with left eye == mondrian, right eye == image+mondrian
        end
    end
    presentStudyImage(p,trial,trialsStudy(trial).tex, leftRight);
         
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