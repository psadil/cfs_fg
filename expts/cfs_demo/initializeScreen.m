function [p] = initializeScreen(p)
% initializeScreen creates parameters necessary for CFS

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


%% determine screen number
scrnNum = max(Screen('Screens')); % Get the list of Screens and choose the one with the highest number (usually what we want)


%% Initialize the screen

%set luminance range for experiment (less than 0-1 so that we don't induce epilepsy!)
p.lum_range = [0.2 0.8];
p.windowColor = repmat(p.lum_range(1)*255,[1 3]);

PsychImaging('PrepareConfiguration');
[p.window , p.windowRect] = PsychImaging('OpenWindow', scrnNum, p.windowColor, [], [], [], p.stereoMode);
Screen(p.window,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
% Screen('Preference', 'ConserveVRAM', 4096)

Priority(MaxPriority(p.window))


%% Generate rectangles, etc.


% if ~gray
p.colors = permute(hsv2rgb(permute(cat(2,randi(6,p.numSuppressors,1,p.numSlides)*(1/6),randi(6,p.numSuppressors,1,p.numSlides)*(1/6),randi(6,p.numSuppressors,1,p.numSlides)*(255/6)),[1 3 2])),[3 1 2]);
% else
%     p.colors = permute(hsv2rgb(permute(cat(2,randi(p.numSuppressors,1,p.numSlides),zeros(p.numSuppressors,1,p.numSlides),randi(6,p.numSuppressors,1,p.numSlides)*(255/6)),[1 3 2])),[3 1 2]);
% end

p.leftRect = CenterRect([0 0 totalFrame-maxL totalFrame-maxL],Screen('Rect',p.window));
p.rightRect = p.leftRect;
p.imageRect = CenterRect([0 0 imageFrame imageFrame],Screen('Rect',p.window));
p.whiteRect = CenterRect([0 0 totalFrame+whiteRectBorder totalFrame+whiteRectBorder],Screen('Rect',p.window));
p.whiteTex = Screen('MakeTexture',p.window,255);
p.greyRect = CenterRect([0 0 totalFrame totalFrame],Screen('Rect',p.window));
p.greyTex = Screen('MakeTexture',p.window,161);

% Generate suppressor rectangles, images, and other variables
p.mondrians(1,:,:) = randi([-maxL,totalFrame],[1, p.numSuppressors, p.numSlides]);
p.mondrians(2,:,:) = randi([-maxL,totalFrame],[1, p.numSuppressors, p.numSlides]);
p.mondrians(3,:,:) = min(p.mondrians(1,:,:) + repmat(minL,[1,p.numSuppressors,p.numSlides]) + randi(maxL-minL,[1,p.numSuppressors,p.numSlides]),totalFrame);
p.mondrians(4,:,:) = min(p.mondrians(2,:,:) + repmat(minL,[1,p.numSuppressors,p.numSlides]) + randi(maxL-minL,[1,p.numSuppressors,p.numSlides]),totalFrame);


p.texAlpha = [0:10:90, replem(100,5), 90:-10:10];

end