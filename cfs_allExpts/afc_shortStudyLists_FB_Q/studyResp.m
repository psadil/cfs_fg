function [ p ] = studyResp( p, trial, string, inputHandler, input, text_Q, text_As )
%studyResp solicit and collect (with Ask_RosieNorm_QUEUE) study resp
% p: experimental structure
% trial: trial number

% 8/17/15 ps - instructions reflect simple response only


%% parameters
Screen('TextSize',p.window, p.fontSize);
% text
% rosie.text1 = 'If you saw only squares, press 0. If you clearly saw an image besides, the squres, press 2. If you saw something besides the squares, but are unsure what it was, press 1';
rosie.text1 = 'no image detected - 0';
rosie.text2 = 'possibly saw, couldn''t name - 1';
rosie.text3 = 'definitely saw, but unsure what it was (could possibly guess) - 2';
rosie.text4 = 'saw something very clearly, could name - 3';
rosie.text5 = text_Q;
rosie.text6 = text_As;
text_answer = 'Answer:  ';
rosie.text_enter = p.text_enter;

% parameters
rosie.tCenter1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, rosie.text1))/2  p.yCenter-450];
rosie.tCenter2 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, rosie.text2))/2  p.yCenter-410];
rosie.tCenter3 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, rosie.text3))/2  p.yCenter-370];
rosie.tCenter4 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, rosie.text4))/2  p.yCenter-330];

rosie.tCenter5 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, rosie.text5))/2  p.yCenter-100];
rosie.tCenter6 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, rosie.text6))/2  p.yCenter-60];

answerBox = [p.xCenter-300 p.yCenter+150 p.xCenter+100 p.yCenter+550];
rosie.tCenterEnter = p.tCenterEnter;

% response keys
rosie.keys_Response = p.keys_simpleResp+p.keys_Navigation + p.keys_yn;

% formatting text bit
rosie.wrapat = p.wrapat;

% screen timing
rosie.ifi = p.ifi;
rosie.hzRate = p.hzRate;


%% solicit response
rosie.test = 0;
p.timing.startStudyResp_rt(trial) = GetSecs;

% Accept keyboard input, echo it to screen.
[reply, rt] = Ask_Rosie(p.window,text_answer,p.textColor,p.windowColor,'GetChar',answerBox,'center',p.fontSize, rosie, string, inputHandler, input);

p.responses.study(trial,1:length(reply)) = reply;
p.timing.endStudyResp_rt(trial) = GetSecs;
% p.rt.study(trial) = p.timing.endStudyResp_rt(trial)-p.timing.startStudyResp_rt(trial);
p.rt.study(trial, 1:length(rt)) = rt;

end

% function cleanedReply = cleanReply(reply)
% 
% if numel(reply) > 2
%     cleanedReply = reply(1:2);
%     
% elseif numel(reply) < 2
%     if numel(reply) < 1
%         reply = ' ';
%     end
%     cleanedReply = [reply, reply];
% elseif numel(reply) == 2
%     cleanedReply = reply;
%     
% end
% 
% end