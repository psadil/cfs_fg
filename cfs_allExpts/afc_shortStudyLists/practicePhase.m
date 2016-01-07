function [] = practicePhase(p, trialsPracticeStudy, trialsPracticeTest)

% practicePhase called during runPDP_objects_CFS to give five trials of practice
% to participating subjects.

% practice phase will include four trials. 2 trials of CFS, 2 trials of
% binocularly studied.
% 1 of each of those trials will be seen in each the inclusion and
% exclusion condition.

p.nItems = length(trialsPracticeStudy);

%text to display
text_beginPrac = 'You will first complete a short version of the study as practice. This practice will look exactly like the full experiment, but with fewer items to look at. Feel free to grab the experimenter if you have any questions.';
text_goGetExperimentor = 'Congrats! That''s the end of the practice phase. Please find the experimentor to continue';

%placement of that text
tCenter_BeginPrac = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_beginPrac))/2  p.yCenter];
tCenter_GoGet = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_goGetExperimentor))/2  p.yCenter];

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
if p.studyPhase
    [~] = studyPhase(p, trialsPracticeStudy, trialsPracticeTest);
end
    
% % begin practice test phase
% [~] = testPhase(p, trialsPracticeTest);


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