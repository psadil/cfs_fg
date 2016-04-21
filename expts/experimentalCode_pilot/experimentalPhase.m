function [ p ] = experimentalPhase(p, trialsStudy)
%experimentalPhase calls study and practice phases, for real this time
%   Detailed explanation goes here

p.nItems = length(trialsStudy);

% text
text_endStudy1 = 'Congratulations! The study phase of the experiment is over.';
text_endStudy2 = 'The test phase of the experiment will begin in a few seconds.';

text_end = 'The experiment is now over. Thank you for your participation.';

% placement of text
tCenterEndStudy1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_endStudy1))/2  p.yCenter-120];
tCenterEndStudy2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_endStudy2))/2  p.yCenter];
tCenterEnd = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_end))/2  p.yCenter];



%% study phase!!!!

% [p] = studyPhase(p);
if p.studyPhase
    try
        [p] = studyPhase(p, trialsStudy);
    catch err
        sca
        throw(err)
    end
end

% %---------------------------------
% % forced break for a bit
% KbQueueCreate(0,p.keys_Navigation);
% now = GetSecs;
% KbQueueStart;
% while GetSecs <= now + p.break
%     
%     % one eye
%     Screen('SelectStereoDrawBuffer',p.window,(0)); 
%     Screen('DrawTexture', p.window, p.texture_ITI);
%     Screen('DrawText', p.window, text_endStudy1, tCenterEndStudy1(1), tCenterEndStudy1(2), p.textColor);
%     Screen('DrawText', p.window, text_endStudy2, tCenterEndStudy2(1), tCenterEndStudy2(2), p.textColor);
%     
%     % other eye
%     Screen('SelectStereoDrawBuffer',p.window,(1)); 
%     Screen('DrawTexture', p.window, p.texture_ITI);
%     Screen('DrawText', p.window, text_endStudy1, tCenterEndStudy1(1), tCenterEndStudy1(2), p.textColor);
%     Screen('DrawText', p.window, text_endStudy2, tCenterEndStudy2(1), tCenterEndStudy2(2), p.textColor);
%     
%     % present to screen
%     Screen('DrawingFinished', p.window);
%     Screen('Flip', p.window);
%     
%     % input
%     [pressed, resp] = KbQueueCheck;
%     if pressed
%         if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
%     end
% end


% %%  Begin test phase
% try
%     [p] = testPhase(p, trialsTest);
% catch err
%     sca
%     throw(err)
% end
% 
% 
% %% end test phase


KbQueueCreate(0,p.keys_Navigation);
KbQueueStart;

now = GetSecs;
while GetSecs<=now+1 % ITI for 1 seconds
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('Flip', p.window);
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
    end
end

while GetSecs <= now + 4
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0)); 
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawText', p.window, text_end, tCenterEnd(1), tCenterEnd(2), p.textColor);
    
    % other eye
    Screen('SelectStereoDrawBuffer',p.window,(1)); 
    Screen(p.window,'DrawTexture', p.texture_ITI);
    Screen('DrawText', p.window, text_end, tCenterEnd(1), tCenterEnd(2), p.textColor);
   
    % present to screen
    Screen('DrawingFinished', p.window);
    Screen('Flip', p.window);

    % input
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); ListenChar(0); Screen('CloseAll'); return; end
    end
end


end

