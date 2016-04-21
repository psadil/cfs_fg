function reply=Ask_Rosie(window,message,textColor,bgColor,replyFun,rectAlign1,rectAlign2,fontsize,rosie)
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

if nargin<4 || isempty(bgColor)
    bgColor=WhiteIndex(window);
end

if nargin<3 || isempty(textColor)
    textColor=BlackIndex(window);
end



% [oldX, oldY]=Screen(window,'DrawText',message,r(RectLeft),r(RectBottom),textColor);
% Screen('Flip', window);      % asg added

%% begin asking for response
KbQueueCreate(0,rosie.keys_Response);
KbQueueStart;

reply = '';

i=0;
while 1
    
    %----------------------------------------------------------------------
    % Draw questions
    %----------------------------------------------------------------------
    
    % draw for one eye
    Screen('SelectStereoDrawBuffer',window,(0));
    Screen(window,'DrawTexture', rosie.texture_ITI);
    [oldX, oldY]=Screen(window,'DrawText',message,r(RectLeft),r(RectBottom),textColor);
    DrawFormattedText(window,rosie.text1,'center', rosie.tCenter1(2),[],rosie.wrapat,[],[],1.5);
    if rosie.test == 1
        Screen('DrawTexture',window,rosie.whiteTex,[],rosie.whiteRect);
        Screen('DrawTexture',window, rosie.image,[],rosie.imageRect);
    else
        DrawFormattedText(window,rosie.text2,'center', rosie.tCenter2(2),[],rosie.wrapat,[],[],1.5);
        DrawFormattedText(window,rosie.text3,'center', rosie.tCenter3(2),[],rosie.wrapat,[],[],1.5);
        DrawFormattedText(window,rosie.text4,'center', rosie.tCenter4(2),[],rosie.wrapat,[],[],1.5);
    end
    Screen('DrawText', window, rosie.text_enter, rosie.tCenterEnter(1), rosie.tCenterEnter(2), textColor);
    Screen(window,'DrawText',reply(1:i),oldX,oldY,textColor);
    
    % draw for other eye
    Screen('SelectStereoDrawBuffer',window,(1));
    Screen(window,'DrawTexture', rosie.texture_ITI);
    [oldX, oldY]=Screen(window,'DrawText',message,r(RectLeft),r(RectBottom),textColor);
    DrawFormattedText(window,rosie.text1,'center', rosie.tCenter1(2),[],rosie.wrapat,[],[],1.5);
    if rosie.test == 1
        Screen('DrawTexture',window,rosie.whiteTex,[],rosie.whiteRect);
        Screen('DrawTexture',window, rosie.image,[],rosie.imageRect);
    else
        DrawFormattedText(window,rosie.text2,'center', rosie.tCenter2(2),[],rosie.wrapat,[],[],1.5);
        DrawFormattedText(window,rosie.text3,'center', rosie.tCenter3(2),[],rosie.wrapat,[],[],1.5);
        DrawFormattedText(window,rosie.text4,'center', rosie.tCenter4(2),[],rosie.wrapat,[],[],1.5);
    end
    Screen('DrawText', window, rosie.text_enter, rosie.tCenterEnter(1), rosie.tCenterEnter(2), textColor);
    Screen(window,'DrawText',reply(1:i),oldX,oldY,textColor);
    
    % display image
    Screen('DrawingFinished', window);
    Screen('Flip', window);
    
    %----------------------------------------------------------------------
    % Check the queue for key presses.
    %----------------------------------------------------------------------
    
    [ pressed, resp]=KbQueueCheck;
    
    if pressed     %Once it's been pressed...
        replyCode=find(resp);        %Find the ascii code corresponding to the response
        
        if replyCode == KbName('return'),     % If 'return', accept reply and move on to next stimulus
            break;
        elseif replyCode == KbName('escape'); sca; return;   %If esc, exit program
        elseif replyCode == KbName('backspace')   %If backspace...
            if i < 1            %If there aren't any other letters to delete, ignore
                continue;
            else            % Otherwise, delete the last letter of reply
                i=i-1;
                reply = reply(1:i);
            end
        elseif replyCode == KbName('space')
            i=i+1;
            %                 space = ' ';
            reply(i) = ' ';
        else
            if length(KbName(replyCode))>1
                continue;
            else
                i=i+1;
                reply(i) = KbName(replyCode);
            end
        end
    end
end


if length(reply)<1
    reply = ' ';
end

% Restore text size:
Screen('TextSize', window ,oldFontSize);

return;
