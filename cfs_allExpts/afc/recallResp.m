function [p] = recallResp( p, texture, trial )
%recallResp Summary of this function goes here
%   request and record recall responses during test phase
% p: experimental structure
% texture: image for test trial
% trial: trial number
% inclusion: boolean, whether in an inclusion trial

%% set up for the trial

% text
    rosie.text1 = 'Please name an object that this could be part of; feel free to use your memory from the study phase if it helps.';

text_answer = 'Answer:  ';
rosie.text_enter = p.text_enter;

%text placement
rosie.tCenter1 = [p.xCenter-RectWidth(Screen('TextBounds', p.window, rosie.text1))/2  p.yCenter-450];
rosie.tCenterEnter = p.tCenterEnter;
answerBox = [p.xCenter-300 p.yCenter+450 p.xCenter+100 p.yCenter+250];

% image
rosie.image = texture;
rosie.texture_ITI = p.texture_ITI;

% white rectangle (texture and size) for behind image
rosie.whiteTex = p.whiteTex;
rosie.whiteRect = p.whiteRect;
rosie.imageRect = p.imageRect;
rosie.greyRect = p.greyRect;
rosie.greyTex = p.greyTex;

% size of image to be put up (needs to be same as studied)
rosie.imageRect = p.imageRect;

%response keys
rosie.keys_Response = p.keys_Response+p.keys_Navigation;

% formatting text bit
rosie.wrapat = p.wrapat;

%% begin recall
KbQueueCreate(0,p.keys_Escape);
KbQueueStart;
KbQueueReserve(1, 2, 0)

%% begin recall response
p.timing.startRecallResp_rt(trial) = GetSecs;


% this might not be necessary, but it'll draw the texture until Ask_Rosie
% is called. Might prevent brief flicker.
% Screen(p.window,'DrawTexture', p.texture_ITI);
% DrawFormattedText(p.window,rosie.text1,'center', rosie.tCenter1(2),[],rosie.wrapat,[],[],1.5);
% Screen('DrawText', p.window, rosie.text_enter, rosie.tCenterEnter(1), rosie.tCenterEnter(2), p.textColor);
% Screen('DrawTexture',window, rosie.image);
% Screen('DrawingFinished', window);
% Screen('Flip', window);

%--------------------------------------------------------------------------
% call Ask_Rosie (with Rosie.test == 1) to receive input. Ask_Rosie will
% display full image (stim part) and instructions for answering either
% inclusion or exclusion recall question
rosie.test = 2;
reply=Ask_Rosie(p.window,text_answer,p.textColor,p.windowColor,'GetChar',answerBox,'center',p.fontSize, rosie); % Accept keyboard input, echo it to screen.

%--------------------------------------------------------------------------
% NOTE: Ask_Rosie will only exit after a response has been given
p.timing.endRecallResp_rt(trial) = GetSecs;
p.rt.recall(trial) = p.timing.endRecallResp_rt(trial) - p.timing.startRecallResp_rt(trial);
p.responses.recall(trial,1:length(reply)) = reply;

Screen('Close',texture);

end