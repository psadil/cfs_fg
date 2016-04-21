function cfsbasic
sca
clear PsychImaging

scrnNum = max(Screen('Screens')); % Get the list of Screens and choose the one with the highest number (usually what we want)
totalFrame = 600; % Frame length of the total frame, including 50px border
maxL = 80; % Maximum and minimum length of suppressor rects
minL = 30;
numSuppressors = 1000;
numSlides = 30;
rects = [];
hzRate = 10;

%% Initialize the screen
PsychImaging('PrepareConfiguration');
[win , winRect] = PsychImaging('OpenWindow', scrnNum, [161 161 161], [], [], [], 1);
Screen(win,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

%% Set color gains
% This depends on the anaglyph mode selected. The values set here
% need to be tuned for each display, glasses type, and subject.
% SetAnaglyphStereoParameters('LeftGains', win, [0.8 0.0 0.0]);
% SetAnaglyphStereoParameters('RightGains', win, [0.0 0.3 0.7]);
% colors = permute(hsv2rgb(permute(cat(2,randi(6,numSuppressors,1,numSlides)*(1/6),zeros(numSuppressors,1,numSlides),randi(6,numSuppressors,1,numSlides)*(255/6)),[1 3 2])),[3 1 2]);
colors = permute(hsv2rgb(permute(cat(2,randi(6,numSuppressors,1,numSlides)*(1/6),ones(numSuppressors,1,numSlides),randi(6,numSuppressors,1,numSlides)*(255/6)),[1 3 2])),[3 1 2]);
leftRect = CenterRect([0 0 totalFrame totalFrame],Screen('Rect',win));
rightRect = leftRect;
% Generate suppressor rectangles, images, and other variables
rects(1,:,:) = randi(totalFrame-50,[1, numSuppressors, numSlides]);
rects(2,:,:) = randi(totalFrame-50,[1, numSuppressors, numSlides]);
rects(3,:,:) = min(rects(1,:,:) + repmat(minL,[1,numSuppressors,numSlides]) + randi(maxL-minL,[1,numSuppressors,numSlides]),totalFrame);
rects(4,:,:) = min(rects(2,:,:) + repmat(minL,[1,numSuppressors,numSlides]) + randi(maxL-minL,[1,numSuppressors,numSlides]),totalFrame);

imgtoshow = Screen('MakeTexture',win,imread('stuart.jpg')); % YOUR IMAGE HERE
tick = 1;
% Suppression
opac = [zeros(1,10) , logspace(log10(1),log10(75),20) , 75*ones(1,100)];

% while tick<length(opac)
%     tick = tick+1;
%     Screen('SelectStereoDrawBuffer',win,0);
%     Screen('FillRect',win,127.5+1.5*(colors(:,:,mod(tick,30)+1)-127.5),rects(:,:,mod(tick,30)+1)+repmat([leftRect(1:2)';leftRect(1:2)'],[1,numSuppressors,1]));
%     Screen('FrameRect',win,255,leftRect,50);
%     Screen('FillRect',win,255,CenterRect([0 0 8 8],leftRect));
%     % Image
%     Screen('SelectStereoDrawBuffer',win,1);
%     Screen('DrawTexture',win,imgtoshow,[],rightRect,[],[],opac(tick)/255);
%     Screen('FrameRect',win,255,rightRect,50);
%     Screen('FillRect',win,255,CenterRect([0 0 8 8],rightRect));
%     Screen(win,'Flip');
%     WaitSecs(.09);
% end


%% Trial by trial code
useCFS = 1;
% This is where the alpha is determined
texAlpha = [zeros(1,hzRate*2) , logspace(log10(1),log10(100),hzRate*3) , 100*ones(1,hzRate*3) , logspace(log10(100),log10(1),hzRate) , zeros(1,hzRate)];
% texAlpha = [logspace(log10(1),log10(80),hzRate) 80*ones(1,hzRate*4) , zeros(1,hzRate)];

flipper = .5+Screen('Flip',win);

% This is where everything is drawn on screen
for tick=1:length(texAlpha)
    % Suppression
    Screen('SelectStereoDrawBuffer',win,0);
    Screen('FillRect',win,(127.5+1.5*(colors(:,:,mod(tick,30)+1)-127.5))/(1+(1-useCFS)*8),rects(:,:,mod(tick,30)+1)+repmat([leftRect(1:2)';leftRect(1:2)'],[1,numSuppressors,1]));
    Screen('FrameRect',win,255,leftRect,50);
    Screen('FillRect',win,255,CenterRect([0 0 8 8],leftRect));
    % Image
    Screen('SelectStereoDrawBuffer',win,1);
    Screen('DrawTexture',win,imgtoshow,[],rightRect,[],[],texAlpha(tick)/255);
    Screen('FrameRect',win,255,rightRect,50);
    Screen('FillRect',win,255,CenterRect([0 0 8 8],rightRect));
    flipper(tick+1) = Screen(win,'Flip', flipper(tick)+1/hzRate);
    
end

sca

end

