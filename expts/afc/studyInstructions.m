function [ p ] = studyInstructions( p )
%studyInstructions: present instructions for study phase

%p: experimental structure


%% parameters for instructions

% create text for question at start of block
text_first1 = 'During this study phase, shifting patterns of colored squares will appear on the screen.';
text_first2 = 'On some of the trials, you will also notice an image or word behind the colored squares.';
text_first3 = 'You will see an example of the squares on the next slide.';

text_second1 = 'After every trial, you will be asked whether you saw anything besides the squares. On most trials, you will only see squares.';
text_second2 = 'If you don''t see anything besides the pattern, press 0';
text_second3 = 'You will see another example of the squares on the next slide.';

text_third1 = 'On some trials, you will might notice something displayed behind the squares';
text_third2 = 'If you could CLEARLY SEE something besides the squares, AND NAME IT (like a ''skate board''), please press 3.';
text_third3 = 'If you DEFINITELY saw something, but are unsure what (though you might be able to guess), press 2';
text_third4 = 'If you only POSSIBLY saw something, but COULDN''T accurately say what it was, press 1';

text_fourth1 = 'You will then see a part of an object.';
text_fourth2 = 'You will then see a part of an object.';


% placement of text
tCenterFirst1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_first1))/2  p.yCenter-160];
tCenterFirst2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_first2))/2  p.yCenter-90];
tCenterFirst3 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_first3))/2  p.yCenter];

tCenterSecond1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_second1))/2  p.yCenter-200];
tCenterSecond2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_second2))/2  p.yCenter-90];
tCenterSecond3 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_second3))/2  p.yCenter];

tCenterThird1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_third1))/2  p.yCenter-160];
tCenterThird2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_third2))/2  p.yCenter-90];
tCenterThird3 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_third3))/2  p.yCenter];
tCenterThird4 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_third4))/2  p.yCenter+90];

texAlpha = p.texAlpha.secs_1p_five;

%% begin instructions
KbQueueCreate(0,p.keys_Navigation);
KbQueueStart;
KbQueueReserve(1, 2, 0)

% opening screen
while 1
    % switching mechanism so that instructions are presented to both eyes
    Screen('SelectStereoDrawBuffer',p.window,(0));   
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawText', p.window, text_first1, tCenterFirst1(1), tCenterFirst1(2), p.textColor);
    DrawFormattedText(p.window,text_first2,'center', tCenterFirst2(2),[],p.wrapat,[],[],1.5);
    DrawFormattedText(p.window,text_first3,'center', tCenterFirst3(2),[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar
    
    % other eye
    Screen('SelectStereoDrawBuffer',p.window,(1));   
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawText', p.window, text_first1, tCenterFirst1(1), tCenterFirst1(2), p.textColor);
    DrawFormattedText(p.window,text_first2,'center', tCenterFirst2(2),[],p.wrapat,[],[],1.5);
    DrawFormattedText(p.window,text_first3,'center', tCenterFirst3(2),[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar
    
    % flip
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

waitSomeSecs(.5,p);

% example of mondrians, no image
presentStudyImage(p,1,p.texture_ITI,[0,0],texAlpha)

waitSomeSecs(.5,p);

% instructions to ANSWER: SQUARES
while 1
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    DrawFormattedText(p.window, text_second1, 'center', tCenterSecond1(2),[],p.wrapat,[],[],1.5);
    DrawFormattedText(p.window,text_second2,'center', tCenterSecond2(2),[],p.wrapat,[],[],1.5);
    DrawFormattedText(p.window,text_second3,'center', tCenterSecond3(2),[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar
    
    % other eye
    Screen('SelectStereoDrawBuffer',p.window,(1));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    DrawFormattedText(p.window, text_second1, 'center', tCenterSecond1(2),[],p.wrapat,[],[],1.5);
    DrawFormattedText(p.window,text_second2,'center', tCenterSecond2(2),[],p.wrapat,[],[],1.5);
    DrawFormattedText(p.window,text_second3,'center', tCenterSecond3(2),[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar
    
    % put on screen
    Screen('DrawingFinished', p.window);
    Screen('Flip', p.window);
    
    % receive input
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
        if resp(p.space)
            break;
        end
    end
end

waitSomeSecs(.5,p);

% example of whole stimuli
filename_whole=strcat(pwd, '\stims\whole\object221_noBkgrd.png'); %Grab the tree
[image_whole, mapCol, transperancy] = imread(filename_whole, 'background', 'none');
image_whole(:,:,2)=transperancy;
texture_wholeObject = Screen('MakeTexture',p.window, image_whole);

% present tree image to both eyes
if p.rightEyeDom
    presentStudyImage(p,1,texture_wholeObject,[1,2],texAlpha)
else
    presentStudyImage(p,1,texture_wholeObject,[2,1],texAlpha)
end

% instructions to ANSWER: SOMETHING/TREE
while 1
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawText', p.window, text_third1, tCenterThird1(1), tCenterThird1(2), p.textColor);
    DrawFormattedText(p.window,text_third2,'center', tCenterThird2(2),[],p.wrapat,[],[],1.5);
    DrawFormattedText(p.window,text_third3,'center', tCenterThird3(2),[],p.wrapat,[],[],1.5);
    DrawFormattedText(p.window,text_third4,'center', tCenterThird4(2),[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(1));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawText', p.window, text_third1, tCenterThird1(1), tCenterThird1(2), p.textColor);
    DrawFormattedText(p.window,text_third2,'center', tCenterThird2(2),[],p.wrapat,[],[],1.5);
    DrawFormattedText(p.window,text_third3,'center', tCenterThird3(2),[],p.wrapat,[],[],1.5);
    DrawFormattedText(p.window,text_third4,'center', tCenterThird4(2),[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar
    
    % put on screen
    Screen('DrawingFinished', p.window);
    Screen('Flip', p.window);
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
        if resp(p.space)
            break;
        end
    end

end

waitSomeSecs(.5,p);

end