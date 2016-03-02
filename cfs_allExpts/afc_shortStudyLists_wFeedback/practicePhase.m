function [] = practicePhase(p, trialsPractice_study, trialsPractice_test)

% practicePhase called during runPDP_objects_CFS short practice
% to participating subjects.

% practice phase will include 8 trials. 1 pair from each condition
% 1 of each of those trials will be seen in each the inclusion and
% exclusion condition.

% 8jan2016
% ps
% updated for shortStudyLists version of experiment

practice = 1;

%text to display
text_beginPrac = 'You will first complete one study/test cycle as practice. This cycle will look exactly like what you will encounter in the full experiment. Feel free to grab the experimenter if you have any questions.';
text_goGetExperimentor = 'Congrats! That''s the end of the practice phase. Please find the experimentor to continue';

%placement of that text
tCenter_BeginPrac = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_beginPrac))/2  p.yCenter];
tCenter_GoGet = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_goGetExperimentor))/2  p.yCenter];



% text
text_endStudy1 = 'Congratulations! The study phase of the experiment is over.';
text_endStudy2 = 'The test phase of the experiment will begin in a few seconds.';

% text_end = 'The experiment is now over. Thank you for your participation.';

% placement of text
tCenterEndStudy1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_endStudy1))/2  p.yCenter-120];
tCenterEndStudy2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_endStudy2))/2  p.yCenter];
% tCenterEnd = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_end))/2  p.yCenter];



% begin study phase text
text_start_study = 'A study phase will begin when you press the space bar. DO NOT lean towards the monitor. REMEMBER: please keep your eyes relaxed and focused on the white square in the center of the screen.';

% define placement of text
tCenterStartStudy = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_start_study))/2  p.yCenter];

% begin test phase text
text_start_test = 'A test phase will begin when you press the space bar.';

% define placement of text
tCenterStartTest = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_start_test))/2  p.yCenter];




%% preliminary text to introduce practice

KbQueueCreate(0,p.keys_Navigation);
KbQueueStart;
KbQueueReserve(1, 2, 0)

while 1
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    DrawFormattedText(p.window,text_beginPrac,'center', tCenter_BeginPrac(2),[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar
    
    % other eye
    Screen('SelectStereoDrawBuffer',p.window,(1));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    DrawFormattedText(p.window,text_beginPrac,'center', tCenter_BeginPrac(2),[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar
    
    % flip
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


%% begin practice study phase
list=1;



if p.studyPhase
    
    [ ~ ] = studyInstructions(p);
    
  
    %-----------------------------------------------
    % brief 'get prepared for a study list'
    %-----------------------------------------------
    
    while 1
        
        % one eye
        Screen('SelectStereoDrawBuffer',p.window,(0));
        Screen('DrawTexture', p.window, p.texture_ITI);
        DrawFormattedText(p.window,text_start_study,'center', tCenterStartStudy(2),[],p.wrapat,[],[],1.5);
        
        % other eye
        Screen('SelectStereoDrawBuffer',p.window,(1));
        Screen('DrawTexture', p.window, p.texture_ITI);
        DrawFormattedText(p.window,text_start_study,'center', tCenterStartStudy(2),[],p.wrapat,[],[],1.5);
        
        % present to screen
        Screen('DrawingFinished', p.window);
        Screen('Flip', p.window);
        
        % receive input
        [pressed, resp] = KbQueueCheck;
        if pressed
            if resp(p.escape); sca; return; end
            if resp(p.space)
                break;
            end
        end
    end
    
    
    
    [~] = studyPhase(p, trialsPractice_study,list);
end


%-----------------------------------------------
% brief break
%-----------------------------------------------

KbQueueCreate(0,p.keys_Navigation);
now = GetSecs;
KbQueueStart;
while GetSecs <= now + p.break
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0));
    Screen('DrawTexture', p.window, p.texture_ITI);
    Screen('DrawText', p.window, text_endStudy1, tCenterEndStudy1(1), tCenterEndStudy1(2), p.textColor);
    Screen('DrawText', p.window, text_endStudy2, tCenterEndStudy2(1), tCenterEndStudy2(2), p.textColor);
    
    % other eye
    Screen('SelectStereoDrawBuffer',p.window,(1));
    Screen('DrawTexture', p.window, p.texture_ITI);
    Screen('DrawText', p.window, text_endStudy1, tCenterEndStudy1(1), tCenterEndStudy1(2), p.textColor);
    Screen('DrawText', p.window, text_endStudy2, tCenterEndStudy2(1), tCenterEndStudy2(2), p.textColor);
    
    % present to screen
    Screen('DrawingFinished', p.window);
    Screen('Flip', p.window);
    
    % wait for input
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
    end
end




[ ~ ] = testInstructions(p);




%-----------------------------------------------
% brief 'get prepared for testing'
%-----------------------------------------------

while 1
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawText', p.window, text_start_test, tCenterStartTest(1), tCenterStartTest(2), p.textColor);
    
    % other eye
    Screen('SelectStereoDrawBuffer',p.window,(1));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawText', p.window, text_start_test, tCenterStartTest(1), tCenterStartTest(2), p.textColor);
    
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





% begin practice test phase
[~] = testPhase(p, trialsPractice_test,list,practice);


% force them to go get the experimentor before moving on. Allows a chance
% to ask questions.
KbQueueCreate(0,p.keys_beginExp);
KbQueueStart;

while 1
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawText', p.window, text_goGetExperimentor, tCenter_GoGet(1), tCenter_GoGet(2), p.textColor);
    
    % other eye
    Screen('SelectStereoDrawBuffer',p.window,(1));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawText', p.window, text_goGetExperimentor, tCenter_GoGet(1), tCenter_GoGet(2), p.textColor);
    
    % present to screen
    Screen('DrawingFinished', p.window);
    Screen('Flip', p.window);
    
    % input
    [pressed] = KbQueueCheck;
    if pressed
        break;
    end
end


end