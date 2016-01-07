function [p] = initializeScreen(p)
% initializeScreen creates parameters necessary for CFS

% generally, for shutter type CFS, p.stereoMode will always == 1

%% VARIABLES
totalFrame = 450; % Frame length of the total frame (size of Mondrians)
imageFrame = 300; % width and height of image frame
whiteRectBorder = 150; % added buffer of white rectangle
maxL = 40; % Maximum and minimum length of suppressor rects
minL = 15;
p.numSuppressors = 1000;
p.numSlides = 30;
p.hzRate = 10;
p.mondrians = [];
p.colors = [];
gray = 0;


%% determine screen number
scrnNum = max(Screen('Screens')); % Get the list of Screens and choose the one with the highest number (usually what we want)

if IsWin && (p.stereoMode==4)
    scrnNum = 0; % Windows-Hack: If mode 4 or 5 is requested, we select screen zeroas target screen
end

if p.stereoMode == 10
    if length(Screen('Screens')) < 2 % Are there two separate displays for both views?
        error('For dual display stereo you must have at least two displays (non-mirrored)');
    end
    scrnNum = +IsWin; % Assign left-eye view (the master window) to main display:
end

%% Initialize the screen

%set luminance range for experiment (less than 0-1 so that we don't induce epilepsy!)
p.lum_range = [0.2 0.8];
p.windowColor = repmat(p.lum_range(1)*255,[1 3]);

PsychImaging('PrepareConfiguration');
[p.window , p.windowRect] = PsychImaging('OpenWindow', scrnNum, p.windowColor, [], [], [], p.stereoMode);
Screen(p.window,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
% Screen('Preference', 'ConserveVRAM', 4096)


if p.stereoMode == 10
    slaveScreen = IsWin() + 1;
    win2 = Screen('OpenWindow', slaveScreen, BlackIndex(slaveScreen), [], [], [], p.stereoMode);
end

Priority(MaxPriority(p.window))

%% Set color gains
% This depends on the anaglyph mode selected. The values set here
% need to be tuned for each display, glasses type, and subject.
switch p.stereoMode
    case 6
        SetAnaglyphStereoParameters('LeftGains', p.window,  [1.0 0.0 0.0]);
        SetAnaglyphStereoParameters('RightGains', p.window, [0.0 0.6 0.0]);
    case 8
        SetAnaglyphStereoParameters('LeftGains', p.window, [0.6 0.0 0.0]);
        SetAnaglyphStereoParameters('RightGains', p.window, [0.0 0.2 0.7]);
end


%% Generate rectangles, etc.

switch p.stereoMode
    case 1
        if ~gray
            p.colors = permute(hsv2rgb(permute(cat(2,randi(6,p.numSuppressors,1,p.numSlides)*(1/6),randi(6,p.numSuppressors,1,p.numSlides)*(1/6),randi(6,p.numSuppressors,1,p.numSlides)*(255/6)),[1 3 2])),[3 1 2]);
        else
            p.colors = permute(hsv2rgb(permute(cat(2,randi(p.numSuppressors,1,p.numSlides),zeros(p.numSuppressors,1,p.numSlides),randi(6,p.numSuppressors,1,p.numSlides)*(255/6)),[1 3 2])),[3 1 2]);
        end
        
        p.leftRect = CenterRect([0 0 totalFrame-maxL totalFrame-maxL],Screen('Rect',p.window));
        p.rightRect = p.leftRect;
        p.imageRect = CenterRect([0 0 imageFrame imageFrame],Screen('Rect',p.window));
        p.whiteRect = CenterRect([0 0 totalFrame+whiteRectBorder totalFrame+whiteRectBorder],Screen('Rect',p.window));
        p.whiteTex = Screen('MakeTexture',p.window,255);
        p.greyRect = CenterRect([0 0 totalFrame totalFrame],Screen('Rect',p.window));
        p.greyTex = Screen('MakeTexture',p.window,161);
        
    case {6,8}
        p.leftRect = CenterRect([0 0 totalFrame totalFrame],Screen('Rect',p.window));
        p.rightRect = p.leftRect;
        p.colors = permute(hsv2rgb(permute(cat(2,randi(6,p.numSuppressors,1,p.numSlides)*(1/6),zeros(p.numSuppressors,1,p.numSlides),randi(6,p.numSuppressors,1,p.numSlides)*(255/6)),[1 3 2])),[3 1 2]);
    case 4
        p.leftRect = CenterRect([0 0 totalFrame totalFrame],p.windowRect);
        p.rightRect = CenterRect([0 0 totalFrame totalFrame],p.windowRect);
        p.colors = permute(hsv2rgb(permute(cat(2,randi(6,p.numSuppressors,1,p.numSlides)*(1/6),ones(p.numSuppressors,1,p.numSlides),255*ones(p.numSuppressors,1,p.numSlides)),[1 3 2])),[3 1 2]);
    case 10
        p.leftRect = CenterRect([0 0 totalFrame totalFrame],Screen('Rect',p.window));
        p.rightRect = CenterRect([0 0 totalFrame totalFrame],Screen('Rect',win2));
        p.colors = permute(hsv2rgb(permute(cat(2,randi(6,p.numSuppressors,1,p.numSlides)*(1/6),ones(p.numSuppressors,1,p.numSlides),255*ones(p.numSuppressors,1,p.numSlides)),[1 3 2])),[3 1 2]);
end

% Generate suppressor rectangles, images, and other variables
p.mondrians(1,:,:) = randi([-maxL,totalFrame],[1, p.numSuppressors, p.numSlides]);
p.mondrians(2,:,:) = randi([-maxL,totalFrame],[1, p.numSuppressors, p.numSlides]);
p.mondrians(3,:,:) = min(p.mondrians(1,:,:) + repmat(minL,[1,p.numSuppressors,p.numSlides]) + randi(maxL-minL,[1,p.numSuppressors,p.numSlides]),totalFrame);
p.mondrians(4,:,:) = min(p.mondrians(2,:,:) + repmat(minL,[1,p.numSuppressors,p.numSlides]) + randi(maxL-minL,[1,p.numSuppressors,p.numSlides]),totalFrame);

if ismember(p.stereoMode,[4 10])
    [p.leftRect, p.rightRect] = adjustVergence(p.window,p.leftRect,p.rightRect);
end

% p.texAlpha = [logspace(log10(1),log10(80),p.hzRate) 80*ones(1,p.hzRate*4) , zeros(1,p.hzRate)];
% p.texAlpha = [zeros(1,p.hzRate*2) , logspace(log10(1),log10(100),p.hzRate*3) , 100*ones(1,p.hzRate*3) , logspace(log10(100),log10(1),p.hzRate) , zeros(1,p.hzRate)];
% p.texAlpha = [zeros(1,p.hzRate) , logspace(log10(1),log10(100),p.hzRate) , 100*ones(1,p.hzRate) , logspace(log10(100),log10(1),p.hzRate) , zeros(1,p.hzRate)];

% old one that was used
p.texAlpha = table([0, 50, 100, 50, 0], ...
    [0:30:90, ones(1,3)*100, 60:-30:0], ...
    [0:20:80, ones(1,5)*100, 80:-20:0], ...
    [0:20:80, ones(1,10)*100, 80:-20:0]);
    
% p.texAlpha = table([logspace(log10(1),log10(80),5), ones(1,5)*100, logspace(log10(80),log10(1),5)], ...
%     [logspace(log10(1),log10(80),5), ones(1,10)*100, logspace(log10(80),log10(1),5)], ...
%     [logspace(log10(1),log10(80),5), ones(1,15)*100, logspace(log10(80),log10(1),5)], ...
%     [logspace(log10(1),log10(80),5), ones(1,20)*100, logspace(log10(8),log10(1),5)]);

p.texAlpha.Properties.VariableNames{'Var1'} = 'secs_p_five';
p.texAlpha.Properties.VariableNames{'Var2'} = 'secs_one';
p.texAlpha.Properties.VariableNames{'Var3'} = 'secs_1p_five';
p.texAlpha.Properties.VariableNames{'Var4'} = 'secs_two';



% p.texAlpha = [0:10:80 ones(1,2)*90 80:-10:0];
%% I don't understand what this function does or why it would be needed...
% Luckily, we're working with a stereoMode that doesn't appear to need it's
% vergence adjusted!
    function [p] = adjustVergence(p)
        
        flipper = Screen('Flip',p.window);
        
        for tick=1:10000
            Screen('SelectStereoDrawBuffer',p,window,0);
            Screen('FillRect',p.window,p.colors(:,:,mod(tick,30)+1),p.mondrians(:,:,mod(tick,30)+1)+repmat([p.leftRect(1:2)';p.leftRect(1:2)'],[1,p.numSuppressors,1]));
            Screen('FrameRect',p.window,255,p.leftRect,50);
            Screen('SelectStereoDrawBuffer',p.window,1);
            Screen('FrameRect',p.window,255,p.rightRect,50);
            flipper = Screen(p.window,'Flip', flipper+1/p.hzRate);
            [keyPressed, ~, keyCode] = KbCheck(-1);
            if keyPressed
                switch find(keyCode,1)
                    case KbName('Space')
                        break;
                    case KbName('LeftArrow')
                        p.leftRect = p.leftRect+[-1 0 -1 0];
                        p.rightRect = p.rightRect+[1 0 1 0];
                    case KbName('RightArrow')
                        p.leftRect = p.leftRect+[1 0 1 0];
                        p.rightRect = p.rightRect+[-1 0 -1 0];
                    case KbName('UpArrow')
                        p.leftRect = p.leftRect+[0 1 0 1];
                        p.rightRect = p.rightRect+[0 -1 0 -1];
                    case KbName('DownArrow')
                        p.leftRect = p.leftRect+[0 -1 0 -1];
                        p.rightRect = p.rightRect+[0 1 0 1];
                end
            end
        end
        
    end

end