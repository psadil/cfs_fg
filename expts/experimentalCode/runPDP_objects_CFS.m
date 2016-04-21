% 8/17/15 ps - included keys (1-3) for making simple study response


% function [] = runPDP_objects_CFS
clear all;
sca
clear PsychImaging

% set up experiment
prompt = {'Subject Number', 'Session Number', 'Include Practice?', 'Include Study Phase?', 'stereoMode','Right Eye Dominant?'};

%grab a random number and seed the generator (include this as a gui field
%in case want to repeat an exact sequence)

defAns = {'SubNum','1', '1', '1', '1','1'}; %fill in some stock answers to the gui input boxes
box = inputdlg(prompt,'Enter Subject Information...', 1, defAns);
if length(box)==length(defAns)      %simple check for enough input, otherwise bail out
    p.subNum=str2double(box{1});
    p.sessNum=str2double(box{2});
    p.practice=str2double(box{3});
    p.studyPhase=str2double(box{4});
    p.stereoMode=str2double(box{5});
    p.rightEyeDom=str2double(box{6});
    p.rndSeed = round(sum(100*clock));
    rand('state',p.rndSeed);  %actually seed the random number generator
else    %if cancel button or not enough input, then just bail
    return
end


%% initialize CFS needs (squares and such)

% generally, for shutter type CFS, only need to use stereoMode == 1
[p] = initializeScreen(p);


%%
ListenChar(2); %%change back to 2 when running for real !!!!
p.fullScreen = 1; %p.fMRI; %change back to 1 when running for real !!!!
% p.RefreshRate = 120;
p.RefreshRate = 60;

% viewing distance and screen width ---------------------
% (in CM...used to convert degrees visual angle to pixel units for drawing
p.screenWidthCM = 45; %screenWidthCM used in deg2pix.m function
p.vDistCM = 90;

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

p.keys_Escape = zeros(1,256);
if ismac
    p.keys_Escape(41)=1;
else
    p.keys_Escape(27)=1;
end

p.keys_Navigation=p.keys_Escape+p.keys_Enter+p.keys_Space+p.keys_Backspace;

p.keys_Response = zeros(1,256);     % making sure subjects can only respond with certain keys, those keys are...
p.keys_Response(KbName('a'):KbName('z'))=1;     % all of the lower case letters

p.keys_simpleResp = zeros(1,256);
p.keys_simpleResp([KbName('0'):KbName('3'), KbName('0)'):KbName('3#'),KbName('a')])=1;

% other
p.space = KbName('space');
p.return = KbName('return');
if ismac
    p.escape = 41;
else
    p.escape = 27;
end

%%
PsychDefaultSetup(2);

%set luminance range for experiment (less than 0-1 so that we don't induce epilepsy!)
p.lum_range = [0.2 0.8];
% Note the new argument to Openp.window with value 2,

p.windowColor = repmat(p.lum_range(1)*255,[1 3]);
% [p.window, p.windowRect] = Screen(s,'OpenWindow',p.windowColor,[],[],2);
HideCursor;

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
if p.fps==0         % if fps does not register, then set the fps based on ifi
    p.fps=1/p.ifi;
end

% check that the actual refresh rate is what we expect it to be.
if abs(p.fps-p.RefreshRate)>5
    Screen('CloseAll');
    disp('Set the refresh rate to the requested rate')
    ListenChar(0);
    clear all;
    return;
end

% Translate the stim duration parameter into units of refresh rate
%each trial is ~4000 msec long, divided into xx frames lasting xx msec each
%Present [nFrames] 'stills' in every trial
p.frame_dur = p.ifi*1000; %frame duration in ms %~16.67ms;

% font parameters --------------------------------------
p.fontSize = 24;
p.textColor = [255 255 255]; %p.LUT(end,:);  % white

% set up the font
Screen('TextFont',p.window, 'Arial');
Screen('TextSize',p.window, p.fontSize);
Screen('TextStyle', p.window, 0);
Screen('TextColor', p.window, p.textColor);

p.wrapat=80;
p.indent=400;

%% text required for exp
p.text_space = '[Press Space Bar to continue]';
p.text_enter = '[Press Enter to continue]';

% placement of text
p.tCenterSpace = [p.xCenter-RectWidth(Screen('TextBounds', p.window, p.text_space))/2  p.windowRect(4)*.9+40];
p.tCenterEnter = [p.xCenter-RectWidth(Screen('TextBounds', p.window, p.text_enter))/2  p.windowRect(4)*.9+40];

p.ITI_text = repmat(p.lum_range(1)*255,[p.windowRect(4),p.windowRect(3)]); %size of screen
p.texture_ITI = Screen('MakeTexture', p.window, p.ITI_text);
ListenChar(0);

%% create stim sequence
p.root = pwd;

[p, trialsStudy, trialsTest, trialsPracticeStudy, trialsPracticeTest] = createStimSequence(p);

%%  some other parameters we need for break
p.break = 1; %15 sec forced break

blockInEx = mod(p.subNum,2); % For counter balancing of inclusion or exclusion trials first
if  ~blockInEx           % 1 signifies inclusion first, 2 gives exclusion first
    p.blockInEx = [1 2];
else
    p.blockInEx = [2 1];
end


%% begin practice phase
if p.practice
    
    
    % begin practice phase
    practicePhase(p, trialsPracticeStudy, trialsPracticeTest);
    
    
end



%% set up necessary directories

if ~exist([p.root, '\Subject Data\'], 'dir')
    mkdir([p.root, '\Subject Data\']);
end
fName=[p.root, '\Subject Data\', 'Subject', num2str(p.subNum), '_PDP_apertures_StudySession', num2str(p.sessNum), '.mat'];   %MS change filename

if exist(fName,'file')
    query = questdlg('File name already exists. Do you want to overwrite?', 'title', 'No' );
    switch query
        case 'No'
            Screen('CloseAll');
            Listenchar(0);
            return;
        case 'Cancel'
            Screen('CloseAll');
            Listenchar(0);
            return;
        case 'Yes'
            clear query
    end
end


startExp = GetSecs;
%% run experimental phase

p = experimentalPhase(p, trialsStudy, trialsTest);


%% save data
p.dur.exp = GetSecs - startExp;


if ~exist([pwd, '\Subject Data\'], 'dir')
    mkdir([pwd, '\Subject Data\']);
end
fName=[pwd, '\Subject Data\', 'Subject', num2str(p.subNum), 'PDP_CFS_objects', num2str(p.sessNum), '.mat'];

if exist(fName,'file')
    query = questdlg('File name already exists. Do you want to overwrite?', 'title', 'No' );
    switch query
        case 'No'
            sca
            return;
        case 'Cancel'
            sca
            return;
        case 'Yes'
            clear query
    end
end

save(fName, 'p');

sca
