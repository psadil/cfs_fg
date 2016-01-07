% Clear the workspace
close all;
clear all;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(1);

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
% Screen('ColorRange', window, 1, [], 1);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

% Make a base Rect of 200 by 200 pixels
dim = 10;
baseRect = [0 0 dim dim];

% Make the coordinates for our grid of squares
[xPos, yPos] = meshgrid(-30:1:30, -30:1:30);

% Calculate the number of squares and reshape the matrices of coordinates
% into a vector
[s1, s2] = size(xPos);
numSquares = s1 * s2;
xPos = reshape(xPos, 1, numSquares);
yPos = reshape(yPos, 1, numSquares);

% Scale the grid spacing to the size of our squares and centre
xPosCenter = xPos .* dim + xCenter;
yPosCenter = yPos .* dim + yCenter;

% Set the colors of each of our squares
tic
bwColors = randi(0:1, 1, numSquares);
bwColors = [bwColors; bwColors; bwColors];
bwColors(bwColors==1) = 255;

% Make our rectangle coordinates
allRectsRight = nan(4, numSquares);
for i = 1:numSquares
    allRectsRight(:, i) = CenterRectOnPointd(baseRect,...
        xPosCenter(i), yPosCenter(i));
end


% Draw the rect to the screen
Screen('FillRect', window, bwColors,...
    allRectsRight);

% Flip to the screen
Screen('Flip', window);

toc

% Wait for a key press
KbStrokeWait;

% Clear the screen
sca;