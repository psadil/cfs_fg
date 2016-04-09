function [p] = recallResp( p, texture, trial, text, string, inputHandler, input )
%recallResp -- request and record recall responses during test phase


% p: experimental structure
% texture: image for test trial
% trial: trial number
% inclusion: boolean, whether in an inclusion trial

%% set up for the trial

% text
rosie.text1 = text;

text_answer = 'Answer:  ';
rosie.text_enter = p.text_enter;

%text placement
rosie.tCenter1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, rosie.text1))/2  p.yCenter-450];
rosie.tCenterEnter = p.tCenterEnter;
answerBox = [p.xCenter-300 p.yCenter+450 p.xCenter+100 p.yCenter+250];

% image
rosie.image = texture;

% white rectangle (texture and size) for behind image
% rosie.whiteTex = p.whiteTex;
rosie.whiteRect = p.whiteRect;
rosie.imageRect = p.imageRect;
rosie.greyRect = p.greyRect;
% rosie.greyTex = p.greyTex;

% size of image to be put up (needs to be same as studied)
rosie.imageRect = p.imageRect;

%response keys
rosie.keys_Response = p.keys_Response+p.keys_Navigation;

% formatting text bit
rosie.wrapat = p.wrapat;

% screen info
rosie.ifi = p.ifi;
rosie.hzRate = p.hzRate;


%% begin recall response
p.timing.startRecallResp_rt(trial) = GetSecs;


%--------------------------------------------------------------------------
% call Ask_Rosie (with Rosie.test == 1) to receive input. Ask_Rosie will
% display full image (stim part) and instructions for answering either
% inclusion or exclusion recall question
rosie.test = 2;
[reply, rt] = Ask_Rosie(p.window,text_answer,p.textColor,p.windowColor,'GetChar',answerBox,'center',p.fontSize, rosie, string, inputHandler, input); % Accept keyboard input, echo it to screen.

%--------------------------------------------------------------------------
% NOTE: Ask_Rosie will only exit after a response has been given
p.timing.endRecallResp_rt(trial) = GetSecs;
p.responses.recall(trial,1:length(reply)) = reply;
p.rt.recall(trial, 1:length(rt)) = rt;


end