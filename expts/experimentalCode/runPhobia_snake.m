function runPhobia_snake(varargin)

%CFSAROUSAL Summary of this function goes here
%   Detailed explanation goes here

if nargin
    subVars = varargin{1};
else
    subVars.id = 9001;
end

sca;

%% VARIABLES
totalFrame = 600; % Frame length of the total frame, including 50px border
maxL = 80; % Maximum and minimum length of suppressor rects
minL = 30;
numSuppressors = 1000;
numSlides = 30;
hzRate = 10;
rects = [];
colors = [];

%% TIMESTAMP GSR

disp('Press any key to timestamp the GSR.')
while 1
    [keydown expCPUTimestamp] = KbCheck(-1);
    if keydown
        break;
    end
end



%% INITIALIZATIONS
if ~exist('data','dir'), mkdir('data'); end % Make the /data directory, if it doesn't exist
[win winRect leftRect rightRect] = initializeScreen(8); % Create screen
[practiceTrials trials] = loadStimuli(); % Load images, create trial matrix


%% RUN PRACTICE TRIALS
textPrompt('You will now see two practice trials. You will be asked what image you saw (snake or flower). You may not always see an image, but you will always be asked to guess what you saw. Press any key to continue',1);
try
    doTrial(practiceTrials(randi(length(practiceTrials))).tex, 1, 1);
catch err
    sca
    throw(err)
end
doTrial(practiceTrials(randi(length(practiceTrials))).tex, 0, 1);

textPrompt('The main experiment will now begin. You will probably not see many images, but you will still be asked to guess what image you saw. Ask the experimenter if you have any more questions. Press any key to start.',1);

%% RUN EXPERIMENTAL TRIALS
try
    for trial=1:length(trials)
        
        if trial==1+length(trials)/4
            textPrompt('You may take a short break. Press 0 to continue.',1, [KbName('0') KbName('0)')]);
        end
        
        if trial==1+length(trials)/2
            textPrompt('You are halfway done, and may take a short break. From now on you should see every image. Press 0 to continue.',1, [KbName('0') KbName('0)')]);
        end
        
        results(trial).name = trials(trial).name;
        [results(trial).confidence ,results(trial).guessedPhobia, results(trial).timeStamp] = doTrial(trials(trial).tex, trials(trial).useCFS, trial);
        
    end
catch err
    save( fullfile('data' , [num2str(subVars.id) '_snake-INCOMPLETE.mat']))
    sca
    throw(err)
end


%% SAVE AND QUIT
save( fullfile('data' , [num2str(subVars.id) '_snake.mat']))
sca





%% FUNCTIONS

    function keyPressed = textPrompt(stringIn,waitForPress,keysAccepted)
        
        if nargin < 3 || isempty(keysAccepted)
            keysAccepted = 1:256;
        end
        
        Screen('TextSize', win , 24);
        Screen('SelectStereoDrawBuffer',win,0);
        DrawFormattedText(win,stringIn,'center','center',[255 255 255],50);
        Screen('SelectStereoDrawBuffer',win,1);
        DrawFormattedText(win,stringIn,'center','center',[255 255 255],50);
        Screen('Flip',win);
        
        while waitForPress
            [~, keyCode] = KbWait(-1,3);
            keyPressed = find( keyCode , 1);
            if any(ismember( keyPressed , keysAccepted ))
                break;
            end
        end
        
    end

    function [confidence , guessedPhobia, timeStamp] = doTrial(texIn, useCFS, ~)
        %% Trial by trial code
        
        % This is where the alpha is determined
        %texAlpha = [zeros(1,hzRate*2) , logspace(log10(1),log10(100),hzRate*3) , 100*ones(1,hzRate*3) , logspace(log10(100),log10(1),hzRate) , zeros(1,hzRate)];
        texAlpha = [logspace(log10(1),log10(80),hzRate) 80*ones(1,hzRate*4) , zeros(1,hzRate)];
        
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
            Screen('DrawTexture',win,texIn,[],rightRect,[],[],texAlpha(tick)/255);
            Screen('FrameRect',win,255,rightRect,50);
            Screen('FillRect',win,255,CenterRect([0 0 8 8],rightRect));
            flipper(tick+1) = Screen(win,'Flip', flipper(tick)+1/hzRate);
           
        end
        timeStamp = flipper(hzRate+1)-expCPUTimestamp;
        
        % This is where the quesiton screen code is
        
        keyPressed = textPrompt('Did you see a (1) snake or a (2) flower?',1,[KbName('1!') KbName('2@') KbName('1') KbName('2')]);
        switch keyPressed
            case {KbName('1!') , KbName('1')}
                guessedPhobia = 1;
            case {KbName('2@') , KbName('2')}
                guessedPhobia = 0;
        end
        keyPressed2 = textPrompt('Are you (1) Guessing, (2) Somewhat confident, or (3) Very Confident',1,[KbName('1!') KbName('2@') KbName('3#') KbName('1') KbName('2') KbName('3')]);

        switch keyPressed2
            case {KbName('1!') , KbName('1')}
                confidence = 1;
            case {KbName('2@') , KbName('2')}
                confidence = 2;
            case {KbName('3#') , KbName('3')}
                confidence = 3;
        end
        
        textPrompt('The next trial will begin shortly. Please sit as still and relaxed as possible.',0);
        WaitSecs(5);
        
        
    end

    function [win , winRect , leftRect , rightRect] = initializeScreen(stereoMode)
        
        scrnNum = max(Screen('Screens')); % Get the list of Screens and choose the one with the highest number (usually what we want)
        
        if IsWin && (stereoMode==4)
            scrnNum = 0; % Windows-Hack: If mode 4 or 5 is requested, we select screen zeroas target screen
        end
        
        if stereoMode == 10
            if length(Screen('Screens')) < 2 % Are there two separate displays for both views?
                error('For dual display stereo you must have at least two displays (non-mirrored)');
            end
            scrnNum = +IsWin; % Assign left-eye view (the master window) to main display:
        end
        
        %% Initialize the screen
        PsychImaging('PrepareConfiguration');
        [win , winRect] = PsychImaging('OpenWindow', scrnNum, 128, [], [], [], stereoMode);
        Screen(win,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
        
        if stereoMode == 10
            slaveScreen = IsWin() + 1;
            win2 = Screen('OpenWindow', slaveScreen, BlackIndex(slaveScreen), [], [], [], stereoMode);
        end
        
        %% Set color gains
        % This depends on the anaglyph mode selected. The values set here
        % need to be tuned for each display, glasses type, and subject.
        switch stereoMode
            case 6
                SetAnaglyphStereoParameters('LeftGains', win,  [1.0 0.0 0.0]);
                SetAnaglyphStereoParameters('RightGains', win, [0.0 0.6 0.0]);
            case 8
                SetAnaglyphStereoParameters('LeftGains', win, [0.6 0.0 0.0]);
                SetAnaglyphStereoParameters('RightGains', win, [0.0 0.2 0.7]);
        end
        
        
        %% Generate rectangles, etc.
        
        switch stereoMode
            case {6,8}
                leftRect = CenterRect([0 0 totalFrame totalFrame],Screen('Rect',win));
                rightRect = leftRect;
                colors = permute(hsv2rgb(permute(cat(2,randi(6,numSuppressors,1,numSlides)*(1/6),zeros(numSuppressors,1,numSlides),randi(6,numSuppressors,1,numSlides)*(255/6)),[1 3 2])),[3 1 2]);
            case 4
                leftRect = CenterRect([0 0 totalFrame totalFrame],winRect);
                rightRect = CenterRect([0 0 totalFrame totalFrame],winRect);
                colors = permute(hsv2rgb(permute(cat(2,randi(6,numSuppressors,1,numSlides)*(1/6),ones(numSuppressors,1,numSlides),255*ones(numSuppressors,1,numSlides)),[1 3 2])),[3 1 2]);
            case 10
                leftRect = CenterRect([0 0 totalFrame totalFrame],Screen('Rect',win));
                rightRect = CenterRect([0 0 totalFrame totalFrame],Screen('Rect',win2));
                colors = permute(hsv2rgb(permute(cat(2,randi(6,numSuppressors,1,numSlides)*(1/6),ones(numSuppressors,1,numSlides),255*ones(numSuppressors,1,numSlides)),[1 3 2])),[3 1 2]);
        end
        
        % Generate suppressor rectangles, images, and other variables
        rects(1,:,:) = randi(totalFrame-50,[1, numSuppressors, numSlides]);
        rects(2,:,:) = randi(totalFrame-50,[1, numSuppressors, numSlides]);
        rects(3,:,:) = min(rects(1,:,:) + repmat(minL,[1,numSuppressors,numSlides]) + randi(maxL-minL,[1,numSuppressors,numSlides]),totalFrame);
        rects(4,:,:) = min(rects(2,:,:) + repmat(minL,[1,numSuppressors,numSlides]) + randi(maxL-minL,[1,numSuppressors,numSlides]),totalFrame);
        
        if ismember(stereoMode,[4 10])
            [leftRect rightRect] = adjustVergence(win,leftRect,rightRect);
        end
        
        
    end

    function [leftRect,rightRect] = adjustVergence(win,leftRect,rightRect)
        
        flipper = Screen('Flip',win);
        
        for tick=1:10000
            Screen('SelectStereoDrawBuffer',win,0);
            Screen('FillRect',win,colors(:,:,mod(tick,30)+1),rects(:,:,mod(tick,30)+1)+repmat([leftRect(1:2)';leftRect(1:2)'],[1,numSuppressors,1]));
            Screen('FrameRect',win,255,leftRect,50);
            Screen('SelectStereoDrawBuffer',win,1);
            Screen('FrameRect',win,255,rightRect,50);
            flipper = Screen(win,'Flip', flipper+1/hzRate);
            [keyPressed, ~, keyCode] = KbCheck(-1);
            if keyPressed
                switch find(keyCode,1)
                    case KbName('Space')
                        break;
                    case KbName('LeftArrow')
                        leftRect = leftRect+[-1 0 -1 0];
                        rightRect = rightRect+[1 0 1 0];
                    case KbName('RightArrow')
                        leftRect = leftRect+[1 0 1 0];
                        rightRect = rightRect+[-1 0 -1 0];
                    case KbName('UpArrow')
                        leftRect = leftRect+[0 1 0 1];
                        rightRect = rightRect+[0 -1 0 -1];
                    case KbName('DownArrow')
                        leftRect = leftRect+[0 -1 0 -1];
                        rightRect = rightRect+[0 1 0 1];
                end
            end
        end
        
    end


    function [practiceTrials , trials] = loadStimuli
        
        cellPracTest = num2cell(arrayfun(@(x) Screen('MakeTexture',win,imread(['img/practice/' x.name],'jpg')),dir('img/practice/*.jpg')));
        [practiceTrials(1:length(cellPracTest)).tex] = deal(cellPracTest{:});
        testNames = dir('img/exp/snakes/*.jpg');
        cellTest = num2cell(arrayfun(@(x) Screen('MakeTexture',win,imread(['img/exp/snakes/' x.name],'jpg')),testNames));
        [trials(1:length(cellTest)).tex] = deal(cellTest{:});
        [trials(1:length(cellTest)).name] = deal(testNames.name);
        [trials(1:9).imgPhobic] = deal(0); [trials(10:18).imgPhobic] = deal(1);
        trials = trials(randperm(length(trials)));
        withSuppression = trials; [withSuppression(1:length(cellTest)).useCFS] = deal(1);
        withoutSuppression = trials; [withoutSuppression(1:length(cellTest)).useCFS] = deal(0);
        trials = [withSuppression withoutSuppression];
    end

end


