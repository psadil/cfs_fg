function [ p ] = studyResp( p, trial, texture )
%studyResp solicit and collect (with Ask_RosieNorm_QUEUE) study resp
% p: experimental structure
% trial: trial number

% 8/17/15 ps - instructions reflect simple response only


%% parameters

% text
% rosie.text1 = 'If you saw only squares, press 0. If you clearly saw an image besides, the squres, press 2. If you saw something besides the squares, but are unsure what it was, press 1';
rosie.text1 = 'no image detected - 0';
rosie.text2 = 'possibly saw, couldn''t name - 1';
rosie.text3 = 'definitely saw, but unsure what it was (could possibly guess) - 2';
rosie.text4 = 'saw something very clearly, could name - 3';
text_answer = 'Answer:  ';
rosie.text_enter = p.text_enter;

% parameters
rosie.tCenter1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, rosie.text1))/2  p.yCenter-180];
rosie.tCenter2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, rosie.text2))/2  p.yCenter-140];
rosie.tCenter3 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, rosie.text3))/2  p.yCenter-100];
rosie.tCenter4 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, rosie.text4))/2  p.yCenter-60];

answerBox = [p.xCenter-300 p.yCenter-200 p.xCenter+100 p.yCenter+200];
rosie.tCenterEnter = p.tCenterEnter;

% response keys
rosie.keys_Response = p.keys_simpleResp+p.keys_Navigation;

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
    
    p.responses.study(trial) = str2double(reply(1));
    p.timing.endStudyResp_rt(trial) = GetSecs;
    p.rt.study(trial) = p.timing.endStudyResp_rt(trial)-p.timing.startStudyResp_rt(trial);
    getResp = 0;
end


rosie.test = 1;
rosie.text1 = 'Please name an object that might have been present.';
rosie.keys_Response = p.keys_Response+p.keys_Navigation;
rosie.image = texture;
rosie.whiteTex = p.whiteTex;
rosie.whiteRect = p.whiteRect;
rosie.imageRect = p.imageRect;

reply_name=Ask_Rosie(p.window,text_answer,p.textColor,p.windowColor,'GetChar',answerBox,'center',p.fontSize, rosie); % Accept keyboard input, echo it to screen.

p.responses.study_name(trial,1:length(reply_name)) = reply_name;




end

