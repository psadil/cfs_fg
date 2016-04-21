function [] = run_CFS_afc_FB_Q(varargin)

Screen('Preference', 'ConserveVRAM', 4096);


ip = inputParser;
addParameter(ip,'subNum', 0, @isnumeric);
addParameter(ip,'stereoMode', 1, @isnumeric);
addParameter(ip,'debugLevel',0, @isnumeric);
addParameter(ip,'studyPhase',1, @isnumeric);
addParameter(ip,'practice',1, @isnumeric);
parse(ip,varargin{:});
input = ip.Results;
% defaults = ip.UsingDefaults;


if input.debugLevel >= 1
    inputHandler = makeInputHandlerFcn('Robot');
elseif input.debugLevel == 0
    inputHandler = makeInputHandlerFcn('KbQueue');
end

%% set up necessary directories
if ~exist([pwd, '\subjectData\'], 'dir')
    mkdir([pwd, '\subjectData\']);
end


%%
% set up experiment
if input.debugLevel > 0
    prompt = {'Subject Number', 'Include Practice?', 'Include Study Phase?', 'stereoMode','Right Eye Dominant?'};
    
    defAns = {'SubNum','1','1','1','1'}; %fill in some stock answers to the gui input boxes
    box = inputdlg(prompt,'Enter Subject Information...', 1, defAns);
    if length(box)==length(defAns)      %simple check for enough input, otherwise bail out
        p.subNum=str2double(box{1});
        p.practice=str2double(box{2});
        p.studyPhase=str2double(box{3});
        p.stereoMode=str2double(box{4});
        p.rightEyeDom=str2double(box{5});
    else    %if cancel button or not enough input, then just bail
        return
    end
    
else
    prompt = {'Subject  Number', 'Right Eye Dominant?'};
    
    defAns = {'SubNum','1'}; %fill in some stock answers to the gui input boxes
    box = inputdlg(prompt,'Enter Subject Information...', 1, defAns);
    if length(box)==length(defAns)      %simple check for enough input, otherwise bail out
        p.subNum=str2double(box{1});
        p.rightEyeDom=str2double(box{2});
    else    %if cancel button or not enough input, then just bail
        return
    end
    p.practice=input.practice;
    p.studyPhase=input.studyPhase;
    p.stereoMode=input.stereoMode;
end
p.rndSeed = round(sum(100*clock));
rng(p.rndSeed);




%% test for data file

subDir = [pwd, '\subjectData\', 'Subject', num2str(p.subNum)];

if exist(subDir,'dir')
    query = questdlg('Subject number already used. Do you want to overwrite?', 'title', 'No' );
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
else
    mkdir(subDir);
end

% try
%% Demographics

Demographics(subDir)

%% load stim table

p = loadStimTable(p);


%% initialize CFS needs (squares and such)

p = initializeScreen(p, input);


%% text required for exp
p.text_space = '[Press Space Bar to continue]';
p.text_enter = '[Press Enter to continue]';

% placement of text
p.tCenterSpace = [p.xCenter-RectWidth(Screen('TextBounds', p.window, p.text_space))/2  p.windowRect(4)*.9+40];
p.tCenterEnter = [p.xCenter-RectWidth(Screen('TextBounds', p.window, p.text_enter))/2  p.windowRect(4)*.9+40];


%%  some other parameter

% about 1/4 foils are shown as such, these serve as catch trials for CFS
% condition
p.catchRatio = .3;

%% begin practice phase
startPrac = GetSecs;
if p.practice
    %begin practice phase
    experimentalPhase(p, p.practice, input, inputHandler, subDir);
end
p.dur.prac = GetSecs - startPrac;


%% run experimental phase
startExp = GetSecs;
p = experimentalPhase(p, 0, input, inputHandler, subDir);
p.dur.exp = GetSecs - startExp;

% save data

save([subDir, '\final.mat'], 'p', 'input');


% Shutdown realtime scheduling:
Priority(0);

% reset color to regular range
Screen('ColorRange', p.window, 255);

ListenChar(0);
sca;




% catch
%     % This "catch" section executes in case of an error in the "try" section
%     % above. Importantly, it closes the onscreen window if its open and
%     % shuts down realtime-scheduling of Matlab:
%
%     % reset color to regular range
%     Screen('ColorRange', p.window, 255);
%
%     % accept keyboard input
%     ListenChar(0);
%
%     % Disable realtime-priority in case of errors.
%     Priority(0);
%
%     % close screens
%     sca;
%
%     psychrethrow(psychlasterror);
%
%
% end

end
