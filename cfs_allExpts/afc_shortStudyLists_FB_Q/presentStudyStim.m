function [ p ] = presentStudyStim( p, trial, stim, leftRightEye, texAlpha, input)
% test so that something is different

%presentStudyImage displays sterioscopic stimuli for study

%   called by studyPhase during each trial




%------------
% Variables:
% p: experimental structure
% trial: trial number
% leftEyeImage: boolean, whether an image is presented to the left eye
% RightEyeImage: boolean, whether an image is presented to the right eye
% NOTE: mondrians are always presented
%----------------------------
% reminder of condition keys
% 1 = no study (foils, seen as just mondrians)
% 2 = word
% 3 = CFS study (masked)
% 4 = binocular study (whole object)
%----------------------------


%% leave them with square (1 second)
now = GetSecs;

Screen('SelectStereoDrawBuffer',p.window,0);

% center fixation square
Screen('FillRect',p.window,255,CenterRect([0 0 8 8],p.rightRect));

Screen('SelectStereoDrawBuffer',p.window,1);

% center fixation square
Screen('FillRect',p.window,255,CenterRect([0 0 8 8],p.rightRect));

Screen('DrawingFinished',p.window);
Screen('Flip', p.window, now + (p.hzRate-.5)*p.ifi);
WaitSecs(p.fixationStart);


%% begin listening for responses


% record the trial onset time
p.trialStart(trial) = GetSecs;

%% present stimulus

% Need to know exactly when stim goes on and off, and check trial length is p.trialDur
KbQueueCreate(0,p.keys_Navigation);
KbQueueStart;

found = 0;
now = GetSecs;
vbl = Screen('Flip',p.window, now + (p.hzRate-.5)*p.ifi);
for tick=1:length(texAlpha)
    
    %----------------------------------------------------------------------
    % Suppression (left eye)
    %----------------------------------------------------------------------
    
    Screen('SelectStereoDrawBuffer',p.window,0);
    
    
    %% draw white square for background of mondrians/image
    %     Screen('DrawTexture',p.window,p.whiteTex,[],p.whiteRect);
    Screen('FillRect',p.window,1,p.whiteRect);
    
    % draw Mondrians
    %     Screen('FillRect',p.window,(127.5+1.5*(p.colors(:,:,mod(tick,p.nSlides)+1)-127.5)),p.mondrians(:,:,mod(tick,p.nSlides)+1)+repmat([p.leftRect(1:2)';p.leftRect(1:2)'],[1,p.nSuppressors,1]));
    Screen('FillRect',p.window,...
        .5+1.5*(p.colors(:,:,mod(tick,p.nSlides)+1)-.5),...
        p.mondrians(:,:,mod(tick,p.nSlides)+1)+repmat([p.leftRect(1:2)';p.leftRect(1:2)'],[1,p.nSuppressors,1]));
    
    % draw image (given condition)
    if leftRightEye(1)==1 % if presenting to left eye
        if p.wordTrial(trial)
            % draw word
            DrawFormattedText(p.window,stim,'center','center',[0,0,0]);
        else
            Screen('DrawTexture',p.window,stim,[],p.imageRect,[],[],texAlpha(tick)/100);
        end
    end
    
    
    % center fixation square
    Screen('FillRect',p.window,1,CenterRect([0 0 8 8],p.rightRect));
    
    %----------------------------------------------------------------------
    % Image (right eye)
    %----------------------------------------------------------------------
    
    Screen('SelectStereoDrawBuffer',p.window,1);
    
    %% draw white square for background of mondrians/image
    %     Screen('DrawTexture',p.window,p.whiteTex,[],p.whiteRect);
    Screen('FillRect',p.window,1,p.whiteRect);
    
    % draw Mondrians
    %     Screen('FillRect',p.window,(127.5+1.5*(p.colors(:,:,mod(tick,p.nSlides)+1)-127.5)),p.mondrians(:,:,mod(tick,p.nSlides)+1)+repmat([p.leftRect(1:2)';p.leftRect(1:2)'],[1,p.nSuppressors,1]));
    Screen('FillRect',p.window,...
        .5+1.5*(p.colors(:,:,mod(tick,p.nSlides)+1)-.5),...
        p.mondrians(:,:,mod(tick,p.nSlides)+1)+repmat([p.leftRect(1:2)';p.leftRect(1:2)'],[1,p.nSuppressors,1]));
    
    % draw image (given condition)
    if leftRightEye(2)==1 % if presenting to right eye
        if p.wordTrial(trial)
            % draw word
            DrawFormattedText(p.window,stim,'center','center',[0,0,0]);
        else
            Screen('DrawTexture',p.window,stim,[],p.imageRect,[],[],texAlpha(tick)/100);
        end
    end
    
    % center fixation square
    Screen('FillRect',p.window,1,CenterRect([0 0 8 8],p.rightRect));
    
    % incriment flipper counter while flipping
    Screen('DrawingFinished',p.window);
    vbl = Screen('Flip', p.window, vbl + (p.hzRate-.5)*p.ifi);
    
    if tick == 1
        p.timing.upStudy_whole(trial) = vbl;
    end
    
    
    listen(input.debugLevel, 'enter');
    
    %----------------------------------------------------------------------
    % allow for escape during stim presentation
    %----------------------------------------------------------------------
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); sca;
            return;
        elseif resp(p.return) && ((any(leftRightEye == 0) && numel(leftRightEye) < 3)  || input.debugLevel >= 1);
            found = 1;
            break;
        end
    end
    
end

p.timing.downStudy_whole(trial) = GetSecs;
p.dur.study_whole(trial) = p.timing.downStudy_whole(trial)-p.timing.upStudy_whole(trial);
vbl = Screen('Flip',p.window, p.timing.downStudy_whole(trial)+ (p.hzRate-.5)*p.ifi);


% wait out full duration of study
if input.debugLevel < 1
    WaitSecs(p.studyDur - p.dur.study_whole(trial));
end

if any(leftRightEye == 0) && numel(leftRightEye) < 3 % && input.debugLevel > 0
    
    if all(leftRightEye == 0) && found
        text_judge = 'CAREFUL! No object appeared.';
        text_rt = ' ';
    elseif found
        text_judge = 'Yes! An object appeared.';
        text_rt = [' You found it in:', num2str(p.dur.study_whole(trial)), ' seconds!'];
    elseif found == 0 % item appeared, not found
        text_judge = ' ';
        text_rt = '  ';
    end
    
    
    Screen('SelectStereoDrawBuffer',p.window,0);
    DrawFormattedText(p.window,text_judge,'center','center',[],p.wrapat,[],[],1.5);
    DrawFormattedText(p.window,text_rt,'center',p.yCenter+40,[],p.wrapat,[],[],1.5);
    
    Screen('SelectStereoDrawBuffer',p.window,1);
    DrawFormattedText(p.window,text_judge,'center','center',[],p.wrapat,[],[],1.5);
    DrawFormattedText(p.window,text_rt,'center',p.yCenter+40,[],p.wrapat,[],[],1.5);
    
    Screen('DrawingFinished',p.window);
    Screen('Flip', p.window,vbl + (p.hzRate-.5)*p.ifi);
    
    WaitSecs(p.judgeDur);
    
    
end



end
