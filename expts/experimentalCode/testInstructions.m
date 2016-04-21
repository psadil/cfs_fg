function [ p ] = testInstructions( p, inclusion )
%testInsructions provides instructions for both test in PDP with CFS of
%objects

%   called by experimentalPhase


%% set up the parameters

%create text
if inclusion % set instructions for inclusion trials
    
    text_First1 = 'You will now see PARTS of OBJECTS. Some of them were embedded in objects that you may have nocticed behind the rectangles. Others belong to objects that you haven''t seen.';
    text_First2 = 'If you recall studying the object to which the part belongs, you will be asked to name THAT OBJECT.';
    text_First3 = 'If you can''t remember which object the part belonged to (or if you think that you have never seen the part) you should still GUESS the object that it could belong to.';
    
    text_Second1 = 'For example you may have been asked to study and name the following object:';
    text_Second2 = 'Answer: street light';
    
    text_Third1 = 'Now, you will see just a PART of an object, like the one below';
    text_Third2 = 'If you remember that this is a part of a street light, ANSWER: street light.';
    text_Third3 = 'If you didn''t remember what this was a part of, or you didn''t study it, you might GUESS robot OR hat.';
    
else % set instructions for exclusion block
    
    text_First1 = 'You will now see PARTS of OBJECTS. Some of them were embedded in objects that you may have nocticed behind the rectangles. Others belong to objects that you haven''t seen.';
    text_First2 = 'If you studied the object to which the part belongs, you will be asked to name a DIFFERENT object.';
    text_First3 = 'If you can''t remember studying an object that contained the part, you should GUESS the object that the part could belong to. Feel free to use the names of other objects that you studied.';
    
    text_Second1 = 'For example you may have been asked to study and name the following object:';
    text_Second2 = 'Answer: street light';
    
    text_Third1 = 'Now, you will see just a PART of an object, like the one below.';
    text_Third2 = 'If you remember studying the street light, a correct answer COULD BE robot or hat.';
    text_Third3 = 'If you DON''T remember studying this part, feel free to GUESS street light.';
    
end

% placement of text
tCenter_First1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_First1))/2  p.yCenter-230];
tCenter_First2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_First2))/2  p.yCenter-90];
tCenter_First3 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_First3))/2  p.yCenter+20];

tCenter_Second1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_Second1))/2  p.windowRect(4)*.05]; %show at top, above object
tCenter_Second2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_Second2))/2  p.windowRect(4)*.9-40]; %show below object/part picture

tCenter_Third1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_Third1))/2  p.windowRect(4)*.05]; % show at top, above part
tCenter_Third2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_Third2))/2  p.windowRect(4)*.9-90];
tCenter_Third3 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_Third3))/2  p.windowRect(4)*.9-30];


%% begin instructions

waitSomeSecs(1,p);

while 1
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0));   
    Screen(p.window,'DrawTexture', p.texture_ITI);
    DrawFormattedText(p.window,text_First1,'center', tCenter_First1(2),[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, text_First2, tCenter_First2(1), tCenter_First2(2), p.textColor);
    DrawFormattedText(p.window,text_First3,'center', tCenter_First3(2),[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(1));   
    Screen(p.window,'DrawTexture', p.texture_ITI);
    DrawFormattedText(p.window,text_First1,'center', tCenter_First1(2),[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, text_First2, tCenter_First2(1), tCenter_First2(2), p.textColor);
    DrawFormattedText(p.window,text_First3,'center', tCenter_First3(2),[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);
    
    % present to screen
    Screen('DrawingFinished', p.window);
    Screen('Flip', p.window);
    
    % input
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
        if resp(p.space)
            break;
        end
    end
end

waitSomeSecs(1,p);


% example of studied whole
filename=strcat(pwd, '\stims\object122_whole_noBackground.png');
[a, mapCol, transperancy] = imread(filename, 'background', 'none');
a(:,:,4)=transperancy;
texture = Screen('MakeTexture',p.window, a);


while 1 
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0));   
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawTexture',p.window,p.whiteTex,[],p.whiteRect);
    Screen(p.window,'DrawTexture', texture)
    Screen('DrawText', p.window, text_Second1, tCenter_Second1(1), tCenter_Second1(2), p.textColor);
    Screen('DrawText', p.window, text_Second2, tCenter_Second2(1), tCenter_Second2(2), p.textColor);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);
    
    % other eye
    Screen('SelectStereoDrawBuffer',p.window,(1));   
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawTexture',p.window,p.whiteTex,[],p.whiteRect);
    Screen(p.window,'DrawTexture', texture)
    Screen('DrawText', p.window, text_Second1, tCenter_Second1(1), tCenter_Second1(2), p.textColor);
    Screen('DrawText', p.window, text_Second2, tCenter_Second2(1), tCenter_Second2(2), p.textColor);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);
    
    % present to screen
    Screen('DrawingFinished', p.window);
    Screen('Flip',p.window);
    
    % input
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
        if resp(p.space)
            break;
        end
    end
end

waitSomeSecs(1,p);



% example of aperture, and what they need to do now
filename=strcat(pwd, '\stims\object122_aperture_noBackground.png'); %telephone similar
[a, mapCol, transperancy] = imread(filename, 'background', 'none');
a(:,:,4)=transperancy;
texture = Screen('MakeTexture',p.window, a);

while 1,  
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawTexture',p.window,p.whiteTex,[],p.whiteRect);
    Screen(p.window,'DrawTexture', texture)
    Screen('DrawText', p.window, text_Third1, tCenter_Third1(1), tCenter_Third1(2), p.textColor);
    Screen('DrawText', p.window, text_Third2, tCenter_Third2(1), tCenter_Third2(2), p.textColor);
%     DrawFormattedText(p.window,text_Third2,'center', tCenter_Third2(2),[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);
    Screen('DrawText', p.window, text_Third3, tCenter_Third3(1), tCenter_Third3(2), p.textColor);
    
    % other eye
    Screen('SelectStereoDrawBuffer',p.window,(1));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawTexture',p.window,p.whiteTex,[],p.whiteRect);
    Screen(p.window,'DrawTexture', texture)
    Screen('DrawText', p.window, text_Third1, tCenter_Third1(1), tCenter_Third1(2), p.textColor);
    Screen('DrawText', p.window, text_Third2, tCenter_Third2(1), tCenter_Third2(2), p.textColor);
%     DrawFormattedText(p.window,text_Third2,'center', tCenter_Third2(2),[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);
    Screen('DrawText', p.window, text_Third3, tCenter_Third3(1), tCenter_Third3(2), p.textColor);
    
    % present to screen
    Screen('DrawingFinished', p.window);
    Screen('Flip',p.window);
    
    % input
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
        if resp(p.space)
            break;
        end
    end
end

waitSomeSecs(1,p);

Screen('Close', texture)
end

