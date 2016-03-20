function [ p ] = feedback_recall( p, trial )
%feedback_recall states what the correct recall response would have been.
%Shown only during the practice trials


text_correct_named = ['The correct answer was:  ', p.words_test{trial}];
tCenter_namedFB = [p.xCenter-RectWidth(Screen('TextBounds', p.window, text_correct_named))/2  p.yCenter];



while 1
    
    % one eye
    Screen('SelectStereoDrawBuffer',p.window,(0));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    DrawFormattedText(p.window,text_correct_named,'center', tCenter_namedFB(2),[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar
    
    % other eye
    Screen('SelectStereoDrawBuffer',p.window,(1));
    Screen(p.window,'DrawTexture', p.texture_ITI);
    DrawFormattedText(p.window,text_correct_named,'center', tCenter_namedFB(2),[],p.wrapat,[],[],1.5);
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

