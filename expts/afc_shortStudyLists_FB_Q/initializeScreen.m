function [p] = initializeScreen(p, input)
% initializeScreen creates parameters necessary for CFS

% generally, for shutter type CFS, p.stereoMode will always == 1

PsychDefaultSetup(2);
ListenChar(-1);
HideCursor;



%% VARIABLES

% screen vars
p.RefreshRate = 120;

% viewing distance and screen width ---------------------
p.screenWidthCM = 45;
p.vDistCM = 90;


% mondrian vars
totalFrame = 450; % Frame length of the total frame (size of Mondrians)
imageFrame = 300; % width and height of image frame
whiteRectBorder = 150; % added buffer of white rectangle
maxL = 40; % Maximum and minimum length of suppressor rects
minL = 15;
p.nSuppressors = 1000;
p.hzRate = 10;
p.mondrians = [];
p.colors = [];

if input.debugLevel < 1
    p.studyDur = 4;
    p.studyStimInstrDur = 2;
    p.iti = .5;
    p.break = 5;
    p.judgeDur = 1;
    p.fixationStart = 1;
elseif input.debugLevel >= 1
    p.studyDur = 1/p.RefreshRate;
    p.studyStimInstrDur = 0;
    p.iti = 0;
    p.break = 0;
    p.judgeDur = 0;
    p.fixationStart = 0;
end


p.nSlides = ceil(p.studyDur) * p.hzRate;

rampUp = 0:8:96;
rampDown = 96:-8:0;

p.texAlpha = [rampUp, repelem(100,abs(ceil((p.RefreshRate/p.hzRate)*p.studyDur - (length([rampUp,rampDown]))))), rampDown ];


%% determine screen number
scrnNum = max(Screen('Screens')); % Get the list of Screens and choose the one with the highest number (usually what we want)


%% Initialize the screen
%set luminance range for experiment (less than 0-1 so that we don't induce epilepsy!)
p.lum_range = [0.2 0.8];
% p.windowColor = repmat(p.lum_range(1)*255,[1 3]);
p.windowColor = repmat(p.lum_range(1),[1 3]);
% reduceCrossTalkGain = .2;



PsychImaging('PrepareConfiguration');
% PsychImaging('AddTask', 'LeftView', 'StereoCrosstalkReduction', 'SubtractOther', reduceCrossTalkGain);
% PsychImaging('AddTask', 'RightView', 'StereoCrosstalkReduction', 'SubtractOther', reduceCrossTalkGain);
% bgColor = GrayIndex(scrnNum);

[p.window , p.windowRect] = PsychImaging('OpenWindow', scrnNum, p.windowColor, [], [], [], p.stereoMode);
% [p.window , p.windowRect] = PsychImaging('OpenWindow', scrnNum, bgColor, [], [], [], p.stereoMode);
Screen(p.window,'BlendFunction','GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');


Priority(MaxPriority(p.window));


%%
% compute and store the center of the screen: p.windowRect contains the upper
% left coordinates (x,y) and the lower right coordinates (x,y)
p.xCenter = (p.windowRect(3) - p.windowRect(1))/2;
p.yCenter = (p.windowRect(4) - p.windowRect(2))/2;
p.center = [(p.windowRect(3) - p.windowRect(1))/2, (p.windowRect(4) - p.windowRect(2))/2];

% test the refresh properties of the display
p.fps=Screen('FrameRate',p.window);          % frames per second
p.ifi=Screen('GetFlipInterval', p.window);   % inter-frame-interval
p.waitframes = 1;
p.waitduration = p.waitframes * p.ifi;


% check that the actual refresh rate is what we expect it to be.
if abs(p.fps-p.RefreshRate)>5
    sca;
    disp('Set the refresh rate to the requested rate')
    ListenChar(0);
    return;
end


%% Generate rectangles, etc.



p.colors = permute(hsv2rgb(permute(cat(2,randi(6,p.nSuppressors,1,p.nSlides)*(1/6),randi(6,p.nSuppressors,1,p.nSlides)*(1/6),randi(6,p.nSuppressors,1,p.nSlides)*(1/6)),...
    [1 3 2])),[3 1 2]);
% p.colors = permute(hsv2rgb(permute(cat(2,randi(1,p.nSuppressors,1,p.nSlides),randi(1,p.nSuppressors,1,p.nSlides),randi(1,p.nSuppressors,1,p.nSlides)),[1 3 2])),[3 1 2]);


p.leftRect = CenterRect([0 0 totalFrame-maxL totalFrame-maxL],Screen('Rect',p.window));
p.rightRect = p.leftRect;
p.imageRect = CenterRect([0 0 imageFrame imageFrame],Screen('Rect',p.window));
p.whiteRect = CenterRect([0 0 totalFrame+whiteRectBorder totalFrame+whiteRectBorder],Screen('Rect',p.window));
% p.whiteTex = Screen('MakeTexture',p.window,1);
p.greyRect = CenterRect([0 0 totalFrame totalFrame],Screen('Rect',p.window));
% p.greyTex = Screen('MakeTexture',p.window,161/255);

% Generate suppressor rectangles, images, and other variables
p.mondrians(1,:,:) = randi([-maxL,totalFrame],[1, p.nSuppressors, p.nSlides]);
p.mondrians(2,:,:) = randi([-maxL,totalFrame],[1, p.nSuppressors, p.nSlides]);
p.mondrians(3,:,:) = min(p.mondrians(1,:,:) + repmat(minL,[1,p.nSuppressors,p.nSlides]) + randi(maxL-minL,[1,p.nSuppressors,p.nSlides]),totalFrame);
p.mondrians(4,:,:) = min(p.mondrians(2,:,:) + repmat(minL,[1,p.nSuppressors,p.nSlides]) + randi(maxL-minL,[1,p.nSuppressors,p.nSlides]),totalFrame);


%% Response keys

% for QUEUE routines
p.keys_Space = zeros(1,256);
p.keys_Space(KbName('space'))=1;

p.keys_Enter = zeros(1,256);
p.keys_Enter(KbName('return'))=1;

p.keys_Backspace = zeros(1,256);
p.keys_Backspace(KbName('backspace'))=1;

p.keys_beginExp = zeros(1,256);
p.keys_beginExp(KbName('p')) = 1;

p.keys_yn = zeros(1,256);
p.keys_yn(KbName('y')) = 1;
p.keys_yn(KbName('n')) = 1;

p.keys_Escape = zeros(1,256);
p.keys_Escape(KbName('escape'))=1;


p.keys_Navigation=p.keys_Escape+p.keys_Enter+p.keys_Space+p.keys_Backspace;

p.keys_Response = zeros(1,256);     
p.keys_Response(KbName('a'):KbName('z'))=1; % all of the lower case letters

p.keys_simpleResp = zeros(1,256);
p.keys_simpleResp([KbName('0'):KbName('3'), KbName('0)'):KbName('3#')])=1;

% other
p.space = KbName('space');
p.return = KbName('return');
p.escape = KbName('escape');


%% font parameters
p.fontSize = 24;
p.textColor = 1; % white
p.wordStimFont = 48;

% set up the font
Screen('TextFont',p.window, 'Arial');
Screen('TextSize',p.window, p.fontSize);
Screen('TextStyle', p.window, 0);
Screen('TextColor', p.window, p.textColor);

p.wrapat=80;
p.indent=400;


end