function [ p ] = presentStudyImage( p, trial, texture, leftRightEye,whiteSquare)
% test so that something is different

%presentStudyImage displays sterioscopic stimuli for study

%   called by studyPhase during each trial

% 8/17/15 ps - updated to no longer make reference to now nonexistant
% binoc+CFS condition
% NOTE: didn't change anything but a couple of comments

%------------
% Variables:
% p: experimental structure
% trial: trial number
% leftEyeImage: boolean, whether an image is presented to the left eye
% RightEyeImage: boolean, whether an image is presented to the right eye
% NOTE: mondrians are always presented
%----------------------------
% reminder of condition keys
% 0 = no study (foils, seen as just mondrians)
% 1 = binocular study (whole object)
% 2 = CFS study (masked)
%----------------------------

% begin listening for responses
KbQueueCreate(0,p.keys_Navigation);

% record the trial onset time
p.trialStart(trial) = GetSecs;
% Screen(p.window,'DrawTexture', p.texture_ITI);
% Screen('DrawingFinished', p.window);
% Screen('Flip', p.window);

%% present stimulus
useCFS = 1;

% Need to know exactly when stim goes on and off, and check trial length is p.trialDur
p.timing.upStudy_whole(trial) = GetSecs;
KbQueueStart;

flipper = .5+Screen('Flip',p.window);
for tick=1:length(p.texAlpha)
    
    %----------------------------------------------------------------------
    % Suppression (left eye)
    %----------------------------------------------------------------------
    
    Screen('SelectStereoDrawBuffer',p.window,0);
    
    
    %% draw white square for background of mondrians/image
    Screen('DrawTexture',p.window,p.whiteTex,[],p.whiteRect); % ,[],[],p.texAlpha(tick)/100
    
    % draw Mondrians
    Screen('FillRect',p.window,(127.5+1.5*(p.colors(:,:,mod(tick,p.numSlides)+1)-127.5))/(1+(1-useCFS)*8),p.mondrians(:,:,mod(tick,p.numSlides)+1)+repmat([p.leftRect(1:2)';p.leftRect(1:2)'],[1,p.numSuppressors,1]));
    
    %     % white frame around image
    %     Screen('FrameRect',p.window,255,p.rightRect,50);
    
    % draw image (given condition)
    if leftRightEye(1)==1 % if presenting to left eye
%         Screen('DrawTexture',p.window,p.whiteTex,[],p.whiteRect,[],[],p.texAlpha(tick)/100);
        Screen('DrawTexture',p.window,texture,[],p.imageRect,[],[],p.texAlpha(tick)/100);
    elseif leftRightEye(1)==2
        Screen('DrawTexture',p.window,texture,[],p.imageRect,[],[],p.texAlpha(tick)/100);
    elseif leftRightEye(1)==3 % foil condition, just put white square
        Screen('DrawTexture',p.window,p.whiteTex,[],p.imageRect,[],[],p.texAlpha(tick)/100);
    end
    
    
    % center fixation square
    Screen('FillRect',p.window,255,CenterRect([0 0 8 8],p.rightRect));
    
    %----------------------------------------------------------------------
    % Image (right eye)
    %----------------------------------------------------------------------
    
    Screen('SelectStereoDrawBuffer',p.window,1);
    
    %% draw white square for background of mondrians/image
    Screen('DrawTexture',p.window,p.whiteTex,[],p.whiteRect); % ,[],[],p.texAlpha(tick)/100
    
    % draw Mondrians
    Screen('FillRect',p.window,(127.5+1.5*(p.colors(:,:,mod(tick,p.numSlides)+1)-127.5))/(1+(1-useCFS)*8),p.mondrians(:,:,mod(tick,p.numSlides)+1)+repmat([p.leftRect(1:2)';p.leftRect(1:2)'],[1,p.numSuppressors,1]));
    
    % draw image (given condition)
    if leftRightEye(2)==1 % if presenting to right eye
%         Screen('DrawTexture',p.window,p.whiteTex,[],p.whiteRect,[],[],p.texAlpha(tick)/100);
        Screen('DrawTexture',p.window,texture,[],p.imageRect,[],[],p.texAlpha(tick)/100);
    elseif leftRightEye(2)==2
        Screen('DrawTexture',p.window,texture,[],p.imageRect,[],[],p.texAlpha(tick)/100);
    elseif leftRightEye(2)==3 % foil condition, just put white square
        Screen('DrawTexture',p.window,p.whiteTex,[],p.imageRect,[],[],p.texAlpha(tick)/100);
    end
    
    
    % center fixation square
    Screen('FillRect',p.window,255,CenterRect([0 0 8 8],p.rightRect));
    
    % incriment flipper counter
    Screen('DrawingFinished', p.window);
    
    % this extra flipping parameter makes sure that the flip happens in
    % line with the next needed flip
    flipper(tick+1) = Screen(p.window,'Flip', flipper(tick)+1/p.hzRate);
    
    %----------------------------------------------------------------------
    % allow for escape during stim presentation
    %----------------------------------------------------------------------
    
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); sca; return; end
    end
    
end

% Screen('Close', p.whiteTex);
Screen('Close', texture);
% asd

p.timing.downStudy_whole(trial) = GetSecs;
p.dur.study_whole(trial) = p.timing.downStudy_whole(trial)-p.timing.upStudy_whole(trial);

end

