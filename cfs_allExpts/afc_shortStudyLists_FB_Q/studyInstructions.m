function [ p ] = studyInstructions( p, input )
%studyInstructions: present instructions for study phase

%p: experimental structure


%% parameters for instructions

% create text for question at start of block
text_first1 = 'While you are studying every object, shifting patterns of colored squares will appear on the screen.';
text_first2 = 'You will see an example of the squares on the next slide.';

text_second1 = 'Some objects will be presented as pictures. Please pay close attention to the details of these objects.';
text_second2 = 'Some objects will be presented as words. Please imagine those objects in detail, presented over the flashing squares.';
text_second3 = 'Occasionally, you will first see only flashing squares, but an object will emerge from those squares.';
text_second4 = 'When that happens, you will be asked to press ''Enter'' when FIRST NOTICE ANYTHING other than the squares -- REGARDLESS of whether you could name the object. You will see an example of this on the next slide, though you may or may not be able to see the object.';

text_third1 = 'However, be careful, because sometimes no object will appear from the squares. Press Enter ONLY when you notice an object appear, and ALWAYS keep your eyes focused on the middle white square.';

text_fourth1 = 'After every object is presented, you will be asked a question about the picture. These questions will have TWO parts.';
text_fourth2 = 'The FIRST part will require a yes or no answer, and will relate to the object itself.';
text_fourth3 = 'If the object was shown as a picture, please answer BASED ON THE PICTURE.';
text_fourth4 = 'If the object was shown as a word, please answer based on your IMAGINED object.';

text_fifth1 = 'These are the first questions you will be asked for the first part:';
text_fifth2 = 'Was the object symmetric across either its horizontal or vertical axis?';
text_fifth3 = 'Did the object fill more than 1/4 of the flashing squares?';
text_fifth4 = 'Was the object reflective?';
text_fifth5 = 'Did the object contain multiple parts?';
text_fifth6 = 'Even if you did not see an object, please still respond to this question.';


text_six1 = 'The SECOND part of the question will be about how well you saw the object (if one was present)';
text_six2 = 'If you CLEARLY SAW something besides the squares, AND COULD NAME IT, answer 3.';
text_six3 = 'If you DEFINITELY saw something, but are unsure what (though you might be able to guess), answer 2';
text_six4 = 'If you only POSSIBLY saw something, but COULDN''T accurately say what it was, answer 1';
text_six5 = 'If you didn''t see anything besides the squares, answer 0';

text_sev1 = 'To indicate your response to these TWO questions, please press the y or n key, followed by the number.';
text_sev2 = 'So, your answer would look like one of the following: y3, y2, y1, y0, n0, n1, n2, OR n3.';
text_sev3 = 'You''ll be reminded what to do during this experiment.';
text_sev4 = 'Another set of instructions will appear when you reach the test phase.';

% placement of text
tCenterFirst1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_first1))/2  p.yCenter-160];
tCenterFirst2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_first2))/2  p.yCenter];

tCenterSecond1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_second1))/2  p.yCenter-250];
tCenterSecond2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_second2))/2  p.yCenter-180];
tCenterSecond3 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_second3))/2  p.yCenter];
tCenterSecond4 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_second4))/2  p.yCenter+100];

tCenterThird1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_third1))/2  p.yCenter-160];

tCenterFourth1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_fourth1))/2  p.yCenter-250];
tCenterFourth2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_fourth2))/2  p.yCenter-90];
tCenterFourth3 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_fourth3))/2  p.yCenter];
tCenterFourth4 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_fourth4))/2  p.yCenter+90];

tCenterFifth1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_fifth1))/2  p.yCenter-160];
tCenterFifth2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_fifth2))/2  p.yCenter-40];
tCenterFifth3 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_fifth3))/2  p.yCenter];
tCenterFifth4 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_fifth4))/2  p.yCenter+40];
tCenterFifth5 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_fifth5))/2  p.yCenter+80];
tCenterFifth6 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_fifth6))/2  p.yCenter+150];

tCenterSix1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_six1))/2  p.yCenter-250];
tCenterSix2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_six2))/2  p.yCenter-90];
tCenterSix3 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_six3))/2  p.yCenter];
tCenterSix4 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_six4))/2  p.yCenter+90];
tCenterSix5 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_six5))/2  p.yCenter+160];

tCenterSev1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_sev1))/2  p.yCenter-250];
tCenterSev2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_sev2))/2  p.yCenter-150];
tCenterSev3 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_sev3))/2  p.yCenter+150];
tCenterSev4 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_sev4))/2  p.yCenter+250];

texAlpha = p.texAlpha;

%% begin instructions
KbQueueCreate(0,p.keys_Navigation);
KbQueueStart;
KbQueueReserve(1, 2, 0)

vbl=iti(p.window,p.iti);

%% opening screen
% switching mechanism so that instructions are presented to both eyes
Screen('SelectStereoDrawBuffer',p.window,(0));
DrawFormattedText(p.window,text_first1,'center', tCenterFirst1(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_first2,'center', tCenterFirst2(2),[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar

% other eye
Screen('SelectStereoDrawBuffer',p.window,(1));
DrawFormattedText(p.window,text_first1,'center', tCenterFirst1(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_first2,'center', tCenterFirst2(2),[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar

% flip
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

% example of mondrians, no image
presentStudyStim(p,1,[],[0,0,0],texAlpha, input)

vbl=iti(p.window,p.iti);

%% second
% instructions to ANSWER: SQUARES

% one eye
Screen('SelectStereoDrawBuffer',p.window,(0));
DrawFormattedText(p.window, text_second1, 'center', tCenterSecond1(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window, text_second2, 'center', tCenterSecond2(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_second3,'center', tCenterSecond3(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_second4,'center', tCenterSecond4(2),[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar

% other eye
Screen('SelectStereoDrawBuffer',p.window,(1));
%     Screen(p.window,'DrawTexture', p.texture_ITI);
DrawFormattedText(p.window, text_second1, 'center', tCenterSecond1(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window, text_second2, 'center', tCenterSecond2(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_second3,'center', tCenterSecond3(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_second4,'center', tCenterSecond4(2),[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar

% put on screen
Screen('DrawingFinished', p.window);
Screen('Flip', p.window,vbl + (p.hzRate-.5)*p.ifi);

while 1
    listen(input.debugLevel, 'space');
    
    % receive input
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
        if resp(p.space)
            break;
        end
    end
end

iti(p.window,p.iti);

% example of whole stimuli
filename_whole=strcat(pwd, '\stims\instructions\object212_noBkgrd.png');
[image_whole, ~, transperancy] = imread(filename_whole, 'background', 'none');
image_whole(:,:,2)=transperancy;
texture_wholeObject = Screen('MakeTexture',p.window, image_whole);

% present image to both eyes
if p.rightEyeDom
    presentStudyStim(p,1,texture_wholeObject,[1,0,0],texAlpha, input)
else
    presentStudyStim(p,1,texture_wholeObject,[0,1,0],texAlpha, input)
end
Screen('Close',texture_wholeObject);

%% Third
vbl=iti(p.window,p.iti);

% one eye
Screen('SelectStereoDrawBuffer',p.window,(0));
DrawFormattedText(p.window,text_third1,'center', tCenterThird1(2),[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar

% one eye
Screen('SelectStereoDrawBuffer',p.window,(1));
DrawFormattedText(p.window,text_third1,'center', tCenterThird1(2),[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar


% put on screen
Screen('DrawingFinished', p.window);
Screen('Flip', p.window,vbl + (p.hzRate-.5)*p.ifi);



while 1
    listen(input.debugLevel, 'space');
    
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
        if resp(p.space)
            break;
        end
    end
    
end

vbl=iti(p.window,p.iti);


%% fourth
% one eye
Screen('SelectStereoDrawBuffer',p.window,(0));
DrawFormattedText(p.window,text_fourth1,'center', tCenterFourth1(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_fourth2,'center', tCenterFourth2(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_fourth3,'center', tCenterFourth3(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_fourth4,'center', tCenterFourth4(2),[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar

% one eye
Screen('SelectStereoDrawBuffer',p.window,(1));
DrawFormattedText(p.window,text_fourth1,'center', tCenterFourth1(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_fourth2,'center', tCenterFourth2(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_fourth3,'center', tCenterFourth3(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_fourth4,'center', tCenterFourth4(2),[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar


% put on screen
Screen('DrawingFinished', p.window);
Screen('Flip', p.window,vbl + (p.hzRate-.5)*p.ifi);

while 1
    listen(input.debugLevel, 'space');
    
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
        if resp(p.space)
            break;
        end
    end
    
end

vbl=iti(p.window,p.iti);

%% fifth

% one eye
Screen('SelectStereoDrawBuffer',p.window,(0));
DrawFormattedText(p.window,text_fifth1,'center', tCenterFifth1(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_fifth2,'center', tCenterFifth2(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_fifth3,'center', tCenterFifth3(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_fifth4,'center', tCenterFifth4(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_fifth5,'center', tCenterFifth5(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_fifth6,'center', tCenterFifth6(2),[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar

% one eye
Screen('SelectStereoDrawBuffer',p.window,(1));
DrawFormattedText(p.window,text_fifth1,'center', tCenterFifth1(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_fifth2,'center', tCenterFifth2(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_fifth3,'center', tCenterFifth3(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_fifth4,'center', tCenterFifth4(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_fifth5,'center', tCenterFifth5(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_fifth6,'center', tCenterFifth6(2),[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar


% put on screen
Screen('DrawingFinished', p.window);
Screen('Flip', p.window,vbl + (p.hzRate-.5)*p.ifi);

while 1
    listen(input.debugLevel, 'space');
    
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
        if resp(p.space)
            break;
        end
    end
    
end

vbl=iti(p.window,p.iti);

%% six

% one eye
Screen('SelectStereoDrawBuffer',p.window,(0));
DrawFormattedText(p.window,text_six1,'center', tCenterSix1(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_six2,'center', tCenterSix2(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_six3,'center', tCenterSix3(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_six4,'center', tCenterSix4(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_six5,'center', tCenterSix5(2),[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar

% one eye
Screen('SelectStereoDrawBuffer',p.window,(1));
DrawFormattedText(p.window,text_six1,'center', tCenterSix1(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_six2,'center', tCenterSix2(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_six3,'center', tCenterSix3(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_six4,'center', tCenterSix4(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_six5,'center', tCenterSix5(2),[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar


% put on screen
Screen('DrawingFinished', p.window);
Screen('Flip', p.window,vbl + (p.hzRate-.5)*p.ifi);

while 1
    listen(input.debugLevel, 'space');
    
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
        if resp(p.space)
            break;
        end
    end
    
end

vbl = iti(p.window,p.iti);


%% sev


% one eye
Screen('SelectStereoDrawBuffer',p.window,(0));
DrawFormattedText(p.window,text_sev1,'center', tCenterSev1(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_sev2,'center', tCenterSev2(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_sev3,'center', tCenterSev3(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_sev4,'center', tCenterSev4(2),[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar

% one eye
Screen('SelectStereoDrawBuffer',p.window,(1));
DrawFormattedText(p.window,text_sev1,'center', tCenterSev1(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_sev2,'center', tCenterSev2(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_sev3,'center', tCenterSev3(2),[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,text_sev4,'center', tCenterSev4(2),[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar


% put on screen
Screen('DrawingFinished', p.window);
Screen('Flip', p.window,vbl + (p.hzRate-.5)*p.ifi);

while 1
    listen(input.debugLevel, 'space');
    
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
