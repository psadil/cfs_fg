function [ p ] = studyStimInstructions( p, instruction)

% present study stimulus instructions for 1.5 seconds
txt = 'While keeping your eyes fixated on the center square,';

Screen('SelectStereoDrawBuffer',p.window,0);
DrawFormattedText(p.window,txt,'center',p.yCenter-80,[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,instruction,'center','center',[],p.wrapat,[],[],1.5);

Screen('SelectStereoDrawBuffer',p.window,1);
DrawFormattedText(p.window,txt,'center',p.yCenter-80,[],p.wrapat,[],[],1.5);
DrawFormattedText(p.window,instruction,'center','center',[],p.wrapat,[],[],1.5);

Screen('Flip', p.window);

WaitSecs(p.studyStimInstrDur);

end