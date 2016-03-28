function vbl = iti(window,dur)

Screen('Flip', window);
WaitSecs(dur);
vbl = Screen('Flip',window);

end