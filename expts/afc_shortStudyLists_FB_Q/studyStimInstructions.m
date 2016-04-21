function [ p ] = studyStimInstructions( p, instruction, trial, input)

% present study stimulus instructions for 1.5 seconds
txt = 'While keeping your eyes fixated on the center square,';

Screen('SelectStereoDrawBuffer',p.window,0);
DrawFormattedText(p.window,txt,'center',p.yCenter-80,[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,instruction,'center','center',[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar

Screen('SelectStereoDrawBuffer',p.window,1);
DrawFormattedText(p.window,txt,'center',p.yCenter-80,[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,instruction,'center','center',[],p.wrapat,[],[],1.5);
Screen('DrawText', p.window, p.text_space, p.tCenterSpace(1), p.tCenterSpace(2), p.textColor);  %space bar

vbl = Screen('Flip', p.window);

% wait until participant presses space bar
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

p.dur.studyInstr(trial) = GetSecs - vbl;

end