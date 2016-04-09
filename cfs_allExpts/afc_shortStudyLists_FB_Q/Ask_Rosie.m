function [reply, rt]=Ask_Rosie(window,message,textColor,bgColor,replyFun,rectAlign1,rectAlign2,fontsize,rosie, string, inputHandler, input)
% reply = Ask(window,message,[textColor],[bgColor],[replyFun],[rectAlign1],[rectAlign2],[fontSize=30])
%
% Draw the message, using textColor, right-justified in the upper right of
% the window, call reply=eval(replyFun), then erase (by drawing text again
% using bgColor) and return. The default "replyFun" is 'GetClicks'. You may
% want to use 'GetChar' or 'GetString'.
%
% "rectAlign1" and "rectAlign2", if present, are applied after the above
% alignment. The values should be selected from: RectLeft, RectRight,
% RectTop, RectBottom. Alternatively you can pass in one of the strings
% 'left','top','right','bottom','center'.
%
% If you want to align the text to a different rectangular box than the
% window, then pass the rectangle defining that box as argument
% 'rectAlign1', and the wanted alignment as argument 'rectAlign2', e.g.,
% if rectAlign1 = [400 300 600 400] and rectAlign2 = 'center', then the
% text 'message' would get centered in the box with left-top corner
% (400,300) and right-bottom corner (600,400).
%
% "fontSize" is the font size you want text typed in; will restore old
% fontsize before returning.
%
% Typical uses:
% reply=Ask(window,'Click when ready.'); % Wait for (multiple) mouse clicks, return number of clicks.
% reply=Ask(window,'What''s your name?',[],[],'GetString'); % Accept keyboard input, but don't show it.
% reply=Ask(window,'Who are you?',[],[],'GetChar',RectLeft,RectTop); % Accept keyboard input, echo it to screen.
%
% See also GetString.

% 3/9/97  dgp	Wrote it, based on dhb's WaitForClick.m
% 3/19/00  dgp	Suggest turning off font smoothing. Default colors.
% 8/14/04  dgp	As suggested by Paul Thiem, added an example (and better argument checking)
%               to make it clear that replyFun must be supplied as a string and rectAlign1 as a value.
% 8/14/04  dgp	Call Screen 'WindowToFront'.
% 1/19/07  asg  Modified to work in OSX (for asg's purposes).
% 6/6/07   mk   remove Screen('WindowToFron') unsupported on PTB-3, other
%               small fixes...
%10/16/14 ps  modified to utilize KbQueueCheck instead of getChar
%11/24/14 ps now, we want to display [press enter to continue], so there
%            is also a rosie.text2. Plus, can handles 'space'
%

if nargin < 2
    error('Ask: Must provide at least the first two arguments.');
end

if ~Screen(window, 'WindowKind')
    error('Invalid window handle provided.')
end

if nargin > 7 && ~isempty(fontsize)
    oldFontSize=Screen('TextSize', window, fontsize);
else
    oldFontSize=Screen('TextSize', window, 30);
end;

if nargin>4
    if isempty(replyFun)
        replyFun='GetClicks';
    end
    
    if isa(replyFun,'double')
        error('Ask: replyFun must be [] or a string, e.g. ''GetClicks''.');
    end
else
    replyFun='GetClicks';
end

% Create the box to hold the text that will be drawn on the screen.
screenRect = Screen('Rect', window);
if ~isempty(message)
    tbx = Screen('TextBounds', window, message);
    width = tbx(3);
    height = tbx(4);
else
    width = 0;
    height = 0;
    message = '';
end

if nargin>5 && ~isempty(rectAlign1) && (length(rectAlign1) == 4) && isnumeric(rectAlign1)
    % rectAlign1 overrides reference box screenRect:
    screenRect = rectAlign1;
end

r=[0 0 width height + Screen('TextSize', window)];
if strcmp(replyFun,'GetChar')
    % In 'GetChar' mode we default to left-alignment of message:
    r=AlignRect(r,screenRect,RectLeft,RectTop); % asg changed to align on Left side of screen
else
    % For other replyFun's we default to good ol' right-alignment:
    r=AlignRect(r,screenRect,RectRight,RectTop);
end

if nargin>6 && ~isempty(rectAlign2)
    r=AlignRect(r,screenRect,rectAlign2);
end

if nargin>5  && ~isempty(rectAlign1) && ((length(rectAlign1) ~= 4) || ischar(rectAlign1))
    r=AlignRect(r,screenRect,rectAlign1);
end

% if nargin<4 || isempty(bgColor)
%     bgColor=WhiteIndex(window);
% end

% if nargin<3 || isempty(textColor)
%     textColor=BlackIndex(window);
% end


%% begin asking for response
KbQueueCreate(0,rosie.keys_Response);
KbQueueStart;

reply = '';
rt = [];
advance = 0;


%% Display text and cue resp
redraw = 0;
now = GetSecs;
now = Screen('Flip', window, now + (rosie.hzRate-.5)*rosie.ifi);
drawNow = 1;
while advance == 0
    
    
    %----------------------------------------------------------------------
    % Check the queue for key presses.
    %----------------------------------------------------------------------
    
    % hangout in this redraw loop until a keypress has been registered
    while redraw == 0 && drawNow == 0
        [reply, rt, advance, redraw] = inputHandler([], reply, rt, string);
        now = GetSecs;
    end
    redraw = 0;
    
    
    %----------------------------------------------------------------------
    % Draw questions
    %----------------------------------------------------------------------
    
    % draw for one eye
    Screen('SelectStereoDrawBuffer',window,(0));
    [oldX, oldY]=Screen(window,'DrawText',message,r(RectLeft),r(RectBottom),textColor);
    DrawFormattedText(window,rosie.text1,'center', rosie.tCenter1(2),[],rosie.wrapat,[],[],1.5);
    if rosie.test == 2
        Screen('FillRect',window,1,rosie.whiteRect);
        Screen('FillRect',window,161/255,rosie.greyRect);
        Screen('DrawTexture',window, rosie.image,[],rosie.imageRect);
    elseif rosie.test == 1
        DrawFormattedText(window,rosie.text2,'center', rosie.tCenter2(2),[],rosie.wrapat,[],[],1.5);
        Screen('FillRect',window,1,rosie.whiteRect-[350, 0, 350, 0]);
        Screen('FillRect',window,161/255,rosie.greyRect-[350, 0, 350, 0]);
        Screen('DrawTexture',window, rosie.imLeft1,[],rosie.imageRect-[350, 0, 350, 0]);
        Screen('DrawTexture',window, rosie.imLeft2,[],rosie.imageRect-[350, 0, 350, 0]);
        
        Screen('FillRect',window,1,rosie.whiteRect+[350, 0, 350, 0]);
        Screen('FillRect',window,161/255,rosie.greyRect+[350, 0, 350, 0]);
        Screen('DrawTexture',window, rosie.imRight1,[],rosie.imageRect+[350, 0, 350, 0]);
        Screen('DrawTexture',window, rosie.imRight2,[],rosie.imageRect+[350, 0, 350, 0]);
        
    elseif rosie.test == 0
        DrawFormattedText(window,rosie.text2,'center', rosie.tCenter2(2),[],rosie.wrapat,[],[],1.5);
        DrawFormattedText(window,rosie.text3,'center', rosie.tCenter3(2),[],rosie.wrapat,[],[],1.5);
        DrawFormattedText(window,rosie.text4,'center', rosie.tCenter4(2),[],rosie.wrapat,[],[],1.5);
        DrawFormattedText(window,rosie.text5,'center', rosie.tCenter5(2),[],rosie.wrapat,[],[],1.5);
        DrawFormattedText(window,rosie.text6,'center', rosie.tCenter6(2),[],rosie.wrapat,[],[],1.5);
        
    end
    Screen('DrawText', window, rosie.text_enter, rosie.tCenterEnter(1), rosie.tCenterEnter(2), textColor);
    Screen(window,'DrawText',reply,oldX,oldY,textColor);
    
    % draw for other eye
    Screen('SelectStereoDrawBuffer',window,(1));
    [oldX, oldY]=Screen(window,'DrawText',message,r(RectLeft),r(RectBottom),textColor);
    DrawFormattedText(window,rosie.text1,'center', rosie.tCenter1(2),[],rosie.wrapat,[],[],1.5);
    if rosie.test == 2
        Screen('FillRect',window,1,rosie.whiteRect);
        Screen('FillRect',window,161/255,rosie.greyRect);
        Screen('DrawTexture',window, rosie.image,[],rosie.imageRect);
    elseif rosie.test == 1
        DrawFormattedText(window,rosie.text2,'center', rosie.tCenter2(2),[],rosie.wrapat,[],[],1.5);
        Screen('FillRect',window,1,rosie.whiteRect-[350, 0, 350, 0]);
        Screen('FillRect',window,161/255,rosie.greyRect-[350, 0, 350, 0]);
        Screen('DrawTexture',window, rosie.imLeft1,[],rosie.imageRect-[350, 0, 350, 0]);
        Screen('DrawTexture',window, rosie.imLeft2,[],rosie.imageRect-[350, 0, 350, 0]);
        
        Screen('FillRect',window,1,rosie.whiteRect+[350, 0, 350, 0]);
        Screen('FillRect',window,161/255,rosie.greyRect+[350, 0, 350, 0]);
        Screen('DrawTexture',window, rosie.imRight1,[],rosie.imageRect+[350, 0, 350, 0]);
        Screen('DrawTexture',window, rosie.imRight2,[],rosie.imageRect+[350, 0, 350, 0]);
        
    elseif rosie.test == 0
        DrawFormattedText(window,rosie.text2,'center', rosie.tCenter2(2),[],rosie.wrapat,[],[],1.5);
        DrawFormattedText(window,rosie.text3,'center', rosie.tCenter3(2),[],rosie.wrapat,[],[],1.5);
        DrawFormattedText(window,rosie.text4,'center', rosie.tCenter4(2),[],rosie.wrapat,[],[],1.5);
        DrawFormattedText(window,rosie.text5,'center', rosie.tCenter5(2),[],rosie.wrapat,[],[],1.5);
        DrawFormattedText(window,rosie.text6,'center', rosie.tCenter6(2),[],rosie.wrapat,[],[],1.5);
        
    end
    Screen('DrawText', window, rosie.text_enter, rosie.tCenterEnter(1), rosie.tCenterEnter(2), textColor);
    Screen(window,'DrawText',reply,oldX,oldY,textColor);
    
    % display image
    Screen('DrawingFinished', window);
    Screen('Flip', window, now + (rosie.hzRate-.5)*rosie.ifi);
    
    % first point at which subjects could see stimulus, or just after they
    % pressed enter
    if drawNow || advance
        rt = [rt, GetSecs]; %#ok<AGROW>
    end
    drawNow = 0;
end


if length(reply)<1
    reply = ' ';
end

% Restore text size:
Screen('TextSize', window ,oldFontSize);


end
