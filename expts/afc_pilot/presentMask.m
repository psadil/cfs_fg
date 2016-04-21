% Clear the workspace
close all;
clear all;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Make a base Rect of 600 by 600 pixels
dim = 150;
baseRect = [0 0 dim dim];

% Make the coordinates for our grid of squares
[xPos, yPos] = meshgrid(-2:.1:2, -2:.1:2);

% Calculate the number of squares and reshape the matrices of coordinates
% into a vector
[s1, s2] = size(xPos);
numSquares = s1 * s2;
xPos = reshape(xPos, 1, numSquares);
yPos = reshape(yPos, 1, numSquares);

% Scale the grid spacing to the size of our squares and centre
xPosLeft = xPos .* dim + xCenter;
yPosLeft = yPos .* dim + yCenter;

% Set the colors of each of our squares
bwColors = randi(0:1, s1, s1);
bwColors = reshape(bwColors, 1, numSquares);
bwColors = repmat(bwColors, 3, 1);

% Make our rectangle coordinates
allRects = nan(4, s1);
for i = 1:numSquares
    allRects(:, i) = CenterRectOnPointd(baseRect,...
        xPosLeft(i), yPosLeft(i));
end

% Draw the rect to the screen
Screen('FillRect', window, bwColors,...
    allRects);

% Flip to the screen
Screen('Flip', window);

% Wait for a key press
KbStrokeWait;

% Clear the screen
sca;