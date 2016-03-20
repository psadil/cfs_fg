function [] = run_CFS_afc_FB_Q(~)
% run_CFS_afc_FB_Q -- cfs, short study lists, 2afc, feedback, with
% questions to help participants study



%%
if ~exist([pwd, '\Subject Data\'], 'dir')
    mkdir([pwd, '\Subject Data\']);
end


% set up experiment
prompt = {'Subject Number', 'Session Number', 'Include Practice?', 'Include Study Phase?', 'stereoMode','Right Eye Dominant?'};

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
    rng(p.rndSeed);  %actually seed the random number generator
else    %if cancel button or not enough input, then just bail
    return
end
%% set up necessary directories

p.root = pwd;
if ~exist([p.root, '\subjectData\'], 'dir')
    mkdir([p.root, '\subjectData\']);
end

%% test for data file

fName = [pwd, '\Subject Data\', 'Subject', num2str(p.subNum), 'CFS_afc_wFB_ques', num2str(p.sessNum), '.mat'];

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


%% Demographics

Demographics(p.subNum)

%% load stim table

p = loadStimTable(p);


%% initialize CFS needs (squares and such)

p = initializeScreen(p);


%%

ListenChar(-1);
p.RefreshRate = 120;

% viewing distance and screen width ---------------------
p.screenWidthCM = 45;
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

% this command makes the number keys unusable (but keeps numpad functional)
PsychDefaultSetup(2);

% set luminance range for experiment (less than 0-1 so that we don't induce epilepsy!)
p.lum_range = [0.2 0.8];
% Note the new argument to Openp.window with value 2,

% p.windowColor = repmat(p.lum_range(1)*255,[1 3]);
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
    sca;
    disp('Set the refresh rate to the requested rate')
    ListenChar(0);
    return;
end

% font parameters --------------------------------------
p.fontSize = 24;
p.textColor = [255 255 255]; %p.LUT(end,:);  % white
p.wordStimFont = 48;

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

% p.ITI_text = repmat(p.lum_range(1)*255,[p.windowRect(4),p.windowRect(3)]); %size of screen
p.texture_ITI = Screen('MakeTexture', p.window, repmat(p.lum_range(1)*255,[p.windowRect(4),p.windowRect(3)]));


%%  some other parameters we need for break
p.break = 5; %secs of forced break


%% begin practice phase
if p.practice    
    
    %begin practice phase
    experimentalPhase(p, p.practice);
end


startExp = GetSecs;
%% run experimental phase

p = experimentalPhase(p, 0);


%% save data
p.dur.exp = GetSecs - startExp;

save(fName, 'p');

ListenChar(0);
sca

end
