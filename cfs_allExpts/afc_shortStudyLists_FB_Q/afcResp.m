function [ p ] = afcResp( p, ap1, ap_left, ap_right, trial, string, input, inputHandler )
%studyResp solicit and collect (with Ask_RosieNorm_QUEUE) study resp
% p: experimental structure
% trial: trial number

% 8/17/15 ps - instructions reflect simple response only

%% parameters
Screen('TextSize',p.window, p.fontSize);
% text
rosie.text1 = 'Left - 1';
rosie.text2 = 'Right - 2';
text_answer = 'Answer:  ';
rosie.text_enter = p.text_enter;

% parameters
rosie.tCenter1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, rosie.text1))/2  p.yCenter-450];
rosie.tCenter2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, rosie.text2))/2  p.yCenter-410];


answerBox = [p.xCenter-300 p.yCenter+150 p.xCenter+100 p.yCenter+550];
rosie.tCenterEnter = p.tCenterEnter;

% response keys
rosie.keys_Response = p.keys_simpleResp+p.keys_Navigation;

% textures
rosie.imLeft1 = ap1;
rosie.imLeft2 = ap_left;
rosie.imRight1 = ap1;
rosie.imRight2 = ap_right;

% rosie.whiteTex = p.whiteTex;
rosie.whiteRect = p.whiteRect;
rosie.imageRect = p.imageRect;
rosie.greyRect = p.greyRect;
% rosie.greyTex = p.greyTex;


% formatting text bit
rosie.wrapat = p.wrapat;

rosie.test = 1;

% screen info
rosie.ifi = p.ifi;
rosie.hzRate = p.hzRate;

%% solicit response
% getResp = 1;
% p.timing.startTestResp_rt(trial) = GetSecs;
% while getResp
% DrawFormattedText(p.window,rosie.text1,'center', rosie.tCenter1(2),[],p.wrapat,[],[],1.5);
% Screen('DrawText', p.window, p.text_enter, p.tCenterEnter(1), p.tCenterEnter(2), []);

reply = Ask_Rosie(p.window,text_answer,p.textColor,p.windowColor,'GetChar',answerBox,'center',p.fontSize, rosie, string, inputHandler, input); % Accept keyboard input, echo it to screen.

p.responses.afc(trial) = str2double(reply(1));

Screen('Close', [ap_left, ap_right]);
end

