function [ p ] = studyResp( p, trial )
%studyResp solicit and collect (with Ask_RosieNorm_QUEUE) study resp
% p: experimental structure
% trial: trial number

%% parameters

% text
rosie.text1 = 'Enter the most appropriate name for the object you just saw. If you''re not certain what you saw, feel free to write UNSURE. If there was no other image, write SQUARES';
text_answer = 'Answer:  ';
rosie.text_enter = p.text_enter;

% parameters
rosie.tCenter1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, rosie.text1))/2  p.yCenter-180];
answerBox = [p.xCenter-300 p.yCenter-200 p.xCenter+100 p.yCenter+200];
rosie.tCenterEnter = p.tCenterEnter;

% response keys
rosie.keys_Response = p.keys_Response+p.keys_Navigation;

% textures
rosie.texture_ITI = p.texture_ITI;

% formatting text bit
rosie.wrapat = p.wrapat;

%% solicit response
rosie.test = 0;
getResp = 1;
p.timing.startStudyResp_rt(trial) = GetSecs;
while getResp
    Screen(p.window,'DrawTexture', p.texture_ITI);
    DrawFormattedText(p.window,rosie.text1,'center', rosie.tCenter1(2),[],p.wrapat,[],[],1.5);
    Screen('DrawText', p.window, p.text_enter, p.tCenterEnter(1), p.tCenterEnter(2), []);
    %     KbQueueRelease;
    
    reply=Ask_Rosie(p.window,text_answer,p.textColor,p.windowColor,'GetChar',answerBox,'center',p.fontSize, rosie); % Accept keyboard input, echo it to screen.
    
    p.responses.study(trial,1:length(reply)) = reply;
    p.timing.endStudyResp_rt(trial) = GetSecs;
    p.rt.study(trial) = p.timing.endStudyResp_rt(trial)-p.timing.startStudyResp_rt(trial);
    getResp = 0;
end



end

