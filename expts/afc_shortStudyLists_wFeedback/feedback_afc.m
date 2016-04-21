function [ p ] = feedback_afc( p, trial )
%feedback_afc informs participant whether their afc response was correct


if  str2double(p.responses.afc(trial)) == p.test_leftRight(trial)
    feedback_afc = 'Correct!';
else
    feedback_afc = 'Incorrect!';
end
tCenter_afcFB = [p.xCenter-RectWidth(Screen('TextBounds', p.window, feedback_afc))/2  p.yCenter];

while 1
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    DrawFormattedText(p.window,feedback_afc,'center', tCenter_afcFB(2),[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar
    
    % other eye
    Screen('SelectStereoDrawBuffer',p.window,(1));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    DrawFormattedText(p.window,feedback_afc,'center', tCenter_afcFB(2),[],p.wrapat,[],[],1.5);
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


end

