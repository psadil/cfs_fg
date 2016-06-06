function [ p ] = testInstructions( p, input )
%testInsructions provides instructions for both test in PDP with CFS of
%objects

%   called by experimentalPhase


%% set up the parameters

%create text
text_First1 = 'You will now see PARTS of OBJECTS. Some of them were embedded in objects that you may have nocticed behind the rectangles. Others belong to objects that you haven''t seen.';
text_First2 = 'FIRST, you will be asked to decide which of two pairs of parts come from the same object.';
text_First3 = 'SECOND, you will see just one part, and you will be asked to name an object to which that part belongs.';
text_First4 = 'If you don''t know which object the part belonged to you should still GUESS the object that it could belong to.';

text_Second1 = 'For example you may have seen the following object in the study phase:';
text_Second2 = 'a light switch';

text_Third1 = 'Your first task will be to choose between pairs, like what''s shown below';
text_Third2 = 'Use the 1 to indicate LEFT, and 2 to indicate RIGHT. (Answer: 1 (left))';

text_Fourth1 = 'Then, you will see just a PART of an object, like the one below';
text_Fourth2 = 'If you remembered what this is a part of, you would ANSWER: light switch.';
text_Fourth3 = 'If you didn''t remember what this was a part of, or you didn''t study it, you might GUESS electrical outlet.';

text_Fifth1 = 'During the practice phase, you will be informed whether your answer to these qeustions was correct.';
text_Fifth2 = 'During the real experiment, you will be informed only whether you got the first question correct.';

% placement of text
tCenter_First1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_First1))/2  p.yCenter-230];
tCenter_First2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_First2))/2  p.yCenter-90];
tCenter_First3 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_First3))/2  p.yCenter+20];
tCenter_First4 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_First4))/2  p.yCenter+90];

tCenter_Second1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_Second1))/2  p.windowRect(4)*.05]; %show at top, above object
tCenter_Second2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_Second2))/2  p.windowRect(4)*.9-40]; %show below object/part picture

tCenter_Third1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_Third1))/2  p.windowRect(4)*.05]; % show at top, above part
tCenter_Third2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_Third2))/2  p.windowRect(4)*.9-90];

tCenter_Fourth1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_Fourth1))/2  p.windowRect(4)*.05]; % show at top, above part
tCenter_Fourth2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_Fourth2))/2  p.windowRect(4)*.9-90];
tCenter_Fourth3 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_Fourth3))/2  p.windowRect(4)*.9-30];

tCenter_Fifth1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_Fifth1))/2  p.yCenter-230];
tCenter_Fifth2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_Fifth2))/2  p.yCenter-90];
%% begin instructions

vbl=iti(p.window,p.iti);



% one eye
Screen('SelectStereoDrawBuffer',p.window,(0));
DrawFormattedText(p.window,text_First1,'center', tCenter_First1(2),[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, text_First2, tCenter_First2(1), tCenter_First2(2), p.textColor);
DrawFormattedText(p.window,text_First3,'center', tCenter_First3(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_First4,'center', tCenter_First4(2),[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);

% one eye
Screen('SelectStereoDrawBuffer',p.window,(1));
DrawFormattedText(p.window,text_First1,'center', tCenter_First1(2),[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, text_First2, tCenter_First2(1), tCenter_First2(2), p.textColor);
DrawFormattedText(p.window,text_First3,'center', tCenter_First3(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_First4,'center', tCenter_First4(2),[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);

% present to screen
Screen('DrawingFinished', p.window);
Screen('Flip', p.window,vbl + (p.hzRate-.5)*p.ifi);

while 1
    listen(input.debugLevel, 'space');
    
    % input
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
        if resp(p.space)
            break;
        end
    end
end

iti(p.window,p.iti);

%% second
% example of studied whole
filename=strcat(pwd, '\stims\instructions\object212_noBkgrd.png');
[a, ~, ~] = imread(filename, 'background', 'none');
texture = Screen('MakeTexture',p.window, a);




% one eye
Screen('SelectStereoDrawBuffer',p.window,(0));
Screen('FillRect',p.window,1,p.whiteRect);
Screen(p.window,'DrawTexture', texture)
Screen('DrawText', p.window, text_Second1, tCenter_Second1(1), tCenter_Second1(2), p.textColor);
Screen('DrawText', p.window, text_Second2, tCenter_Second2(1), tCenter_Second2(2), p.textColor);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);

% other eye
Screen('SelectStereoDrawBuffer',p.window,(1));
Screen('FillRect',p.window,1,p.whiteRect);
Screen(p.window,'DrawTexture', texture)
Screen('DrawText', p.window, text_Second1, tCenter_Second1(1), tCenter_Second1(2), p.textColor);
Screen('DrawText', p.window, text_Second2, tCenter_Second2(1), tCenter_Second2(2), p.textColor);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);

% present to screen
Screen('DrawingFinished', p.window);
vbl=Screen('Flip', p.window,vbl + (p.hzRate-.5)*p.ifi);

while 1
    listen(input.debugLevel, 'space');
    
    % input
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
        if resp(p.space)
            break;
        end
    end
end




%% third
% example of aperture, and what they need to do now
filename1a=strcat(pwd, '\stims\instructions\object212_paired215_ap1.png');
filename2a=strcat(pwd, '\stims\instructions\object212_paired215_ap2.png');
filename3b=strcat(pwd, '\stims\instructions\object215_paired212_ap3.png');

[a1, ~, transperancy1] = imread(filename1a, 'png');
[a2, ~, transperancy2] = imread(filename2a, 'png');
[b3, ~, transperancy3] = imread(filename3b, 'png');

a1new = cat(3,a1,a1,a1,transperancy1);
a2new = cat(3,a2,a2,a2,transperancy2);
b3new = cat(3,b3,b3,b3,transperancy3);

textureLeft1 = Screen('MakeTexture',p.window, a1new);
textureLeft2 = Screen('MakeTexture',p.window, a2new);
textureRight1 = Screen('MakeTexture',p.window, a1new);
textureRight2 = Screen('MakeTexture',p.window, b3new);

iti(p.window,p.iti);

% one eye
Screen('SelectStereoDrawBuffer',p.window,(0));
Screen('FillRect',p.window,1,p.whiteRect-[350, 0, 350, 0]);
Screen('FillRect',p.window,161/255,p.greyRect-[350, 0, 350, 0]);
Screen(p.window,'DrawTexture', textureLeft1, [], p.imageRect-[350, 0, 350, 0]);
Screen(p.window,'DrawTexture', textureLeft2, [], p.imageRect-[350, 0, 350, 0]);

Screen('FillRect',p.window,1,p.whiteRect+[350, 0, 350, 0]);
Screen('FillRect',p.window,161/255,p.greyRect+[350, 0, 350, 0]);
Screen(p.window,'DrawTexture', textureRight1, [], p.imageRect+[350, 0, 350, 0]);
Screen(p.window,'DrawTexture', textureRight2, [], p.imageRect+[350, 0, 350, 0]);

Screen('DrawText', p.window, text_Third1, tCenter_Third1(1), tCenter_Third1(2), p.textColor);
Screen('DrawText', p.window, text_Third2, tCenter_Third2(1), tCenter_Third2(2), p.textColor);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);

% other eye
Screen('SelectStereoDrawBuffer',p.window,(1));
Screen('FillRect',p.window,1,p.whiteRect-[350, 0, 350, 0]);
Screen('FillRect',p.window,161/255,p.greyRect-[350, 0, 350, 0]);
Screen(p.window,'DrawTexture', textureLeft1, [], p.imageRect-[350, 0, 350, 0]);
Screen(p.window,'DrawTexture', textureLeft2, [], p.imageRect-[350, 0, 350, 0]);

Screen('FillRect',p.window,1,p.whiteRect+[350, 0, 350, 0]);
Screen('FillRect',p.window,161/255,p.greyRect+[350, 0, 350, 0]);
Screen(p.window,'DrawTexture', textureRight1, [], p.imageRect+[350, 0, 350, 0]);
Screen(p.window,'DrawTexture', textureRight2, [], p.imageRect+[350, 0, 350, 0]);

Screen('DrawText', p.window, text_Third1, tCenter_Third1(1), tCenter_Third1(2), p.textColor);
Screen('DrawText', p.window, text_Third2, tCenter_Third2(1), tCenter_Third2(2), p.textColor);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);

% present to screen
Screen('DrawingFinished', p.window);
Screen('Flip', p.window,vbl + (p.hzRate-.5)*p.ifi);

while 1
    listen(input.debugLevel, 'space');
    
    % input
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
        if resp(p.space)
            break;
        end
    end
end

Screen('Close',[textureLeft1,textureLeft2,textureRight1,textureRight2] );

%%
% example of part
filename=strcat(pwd, '\stims\instructions\object212_paired215_ap1.png');
[a, ~, ~] = imread(filename, 'background', 'none');
texture = Screen('MakeTexture',p.window, a);

iti(p.window,p.iti);
%% fourth


% one eye
Screen('SelectStereoDrawBuffer',p.window,(0));
Screen('FillRect',p.window,1,p.whiteRect);
Screen(p.window,'DrawTexture', texture)
Screen('DrawText', p.window, text_Fourth1, tCenter_Fourth1(1), tCenter_Fourth1(2), p.textColor);
Screen('DrawText', p.window, text_Fourth2, tCenter_Fourth2(1), tCenter_Fourth2(2), p.textColor);
Screen('DrawText', p.window, text_Fourth3, tCenter_Fourth3(1), tCenter_Fourth3(2), p.textColor);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);

% other eye
Screen('SelectStereoDrawBuffer',p.window,(1));
Screen('FillRect',p.window,1,p.whiteRect);
Screen(p.window,'DrawTexture', texture)
Screen('DrawText', p.window, text_Fourth1, tCenter_Fourth1(1), tCenter_Fourth1(2), p.textColor);
Screen('DrawText', p.window, text_Fourth2, tCenter_Fourth2(1), tCenter_Fourth2(2), p.textColor);
Screen('DrawText', p.window, text_Fourth3, tCenter_Fourth3(1), tCenter_Fourth3(2), p.textColor);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);

% present to screen
Screen('DrawingFinished', p.window);
Screen('Flip', p.window,vbl + (p.hzRate-.5)*p.ifi);

while 1
    listen(input.debugLevel, 'space');
    
    % input
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
        if resp(p.space)
            break;
        end
    end
end
Screen('Close', texture)

iti(p.window,p.iti);



%% fifth


% one eye
Screen('SelectStereoDrawBuffer',p.window,(0));
Screen('DrawText', p.window, text_Fifth1, tCenter_Fifth1(1), tCenter_Fifth1(2), p.textColor);
Screen('DrawText', p.window, text_Fifth2, tCenter_Fifth2(1), tCenter_Fifth2(2), p.textColor);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);

% other eye
Screen('SelectStereoDrawBuffer',p.window,(1));
Screen('DrawText', p.window, text_Fifth1, tCenter_Fifth1(1), tCenter_Fifth1(2), p.textColor);
Screen('DrawText', p.window, text_Fifth2, tCenter_Fifth2(1), tCenter_Fifth2(2), p.textColor);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);

% present to screen
Screen('DrawingFinished', p.window);
Screen('Flip', p.window,vbl + (p.hzRate-.5)*p.ifi);

while 1
    listen(input.debugLevel, 'space');
    
    % input
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
        if resp(p.space)
            break;
        end
    end
end

iti(p.window,p.iti);
end