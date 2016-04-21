function [ ] = waitSomeSecs( waitingTime, p )
% waitSomeSecs flahses up an ITI_texture for some short time (waitingTime).


%   might need to initiate with KbQueueCreate...If so, could just not
%   include the option to escape during these moments

now = GetSecs;
while GetSecs <= now + waitingTime
    Screen('DrawTexture', p.window, p.texture_ITI);
    Screen('Flip', p.window);
    [pressed, resp] = KbQueueCheck;
    if pressed
        if resp(p.escape); sca; return; end
    end
end



end

