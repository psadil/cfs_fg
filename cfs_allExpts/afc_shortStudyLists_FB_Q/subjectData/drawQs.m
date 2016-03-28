function reply=drawQs(window, reply, resp)


% Create the box to hold the text that will be drawn on the screen.
tbx = Screen('TextBounds', window, resp(1).answer);
width = tbx(3);
height = tbx(4);

screenRect = resp(1).answerBox;

r=[0 0 width height + Screen('TextSize', window)];
r=AlignRect(r,screenRect,RectLeft,RectTop); % asg changed to align on Left side of screen

r=AlignRect(r,screenRect,'center');

r=AlignRect(r,screenRect,resp(1).answerBox);


%% begin asking for response

while advance == 0
    
    
    
    %----------------------------------------------------------------------
    % Draw questions
    %----------------------------------------------------------------------
    
    % draw for one eye
    Screen('SelectStereoDrawBuffer',window,(0));
    [oldX, oldY]=Screen(window,'DrawText',message,r(RectLeft),r(RectBottom),textColor);
    DrawFormattedText(window,resp.text1,'center', resp.tCenter1(2),[],resp.wrapat,[],[],1.5);
    if resp.test == 2
        Screen('DrawTexture',window,resp.whiteTex,[],resp.whiteRect);
        Screen('DrawTexture',window,resp.greyTex,[],resp.greyRect);
        Screen('DrawTexture',window, resp.image,[],resp.imageRect);
    elseif resp.test == 1
        DrawFormattedText(window,resp.text2,'center', resp.tCenter2(2),[],resp.wrapat,[],[],1.5);
        
        Screen('DrawTexture',window,resp.whiteTex,[],resp.whiteRect-[350, 0, 350, 0]);
        Screen('DrawTexture',window,resp.greyTex,[],resp.greyRect-[350, 0, 350, 0]);
        Screen('DrawTexture',window, resp.imLeft1,[],resp.imageRect-[350, 0, 350, 0]);
        Screen('DrawTexture',window, resp.imLeft2,[],resp.imageRect-[350, 0, 350, 0]);
        
        Screen('DrawTexture',window,resp.whiteTex,[],resp.whiteRect+[350, 0, 350, 0]);
        Screen('DrawTexture',window,resp.greyTex,[],resp.greyRect+[350, 0, 350, 0]);
        Screen('DrawTexture',window, resp.imRight1,[],resp.imageRect+[350, 0, 350, 0]);
        Screen('DrawTexture',window, resp.imRight2,[],resp.imageRect+[350, 0, 350, 0]);
        
    elseif resp.test == 0
        DrawFormattedText(window,resp.text2,'center', resp.tCenter2(2),[],resp.wrapat,[],[],1.5);
        DrawFormattedText(window,resp.text3,'center', resp.tCenter3(2),[],resp.wrapat,[],[],1.5);
        DrawFormattedText(window,resp.text4,'center', resp.tCenter4(2),[],resp.wrapat,[],[],1.5);
        DrawFormattedText(window,resp.text5,'center', resp.tCenter5(2),[],resp.wrapat,[],[],1.5);
        DrawFormattedText(window,resp.text6,'center', resp.tCenter6(2),[],resp.wrapat,[],[],1.5);
        
    end
    Screen('DrawText', window, resp.text_enter, resp.tCenterEnter(1), resp.tCenterEnter(2), textColor);
    Screen(window,'DrawText',reply,oldX,oldY,textColor);
    
    % draw for other eye
    Screen('SelectStereoDrawBuffer',window,(1));
    [oldX, oldY]=Screen(window,'DrawText',message,r(RectLeft),r(RectBottom),textColor);
    DrawFormattedText(window,resp.text1,'center', resp.tCenter1(2),[],resp.wrapat,[],[],1.5);
    if resp.test == 2
        Screen('DrawTexture',window,resp.whiteTex,[],resp.whiteRect);
        Screen('DrawTexture',window,resp.greyTex,[],resp.greyRect);
        Screen('DrawTexture',window, resp.image,[],resp.imageRect);
    elseif resp.test == 1
        DrawFormattedText(window,resp.text2,'center', resp.tCenter2(2),[],resp.wrapat,[],[],1.5);
        
        Screen('DrawTexture',window,resp.whiteTex,[],resp.whiteRect-[350, 0, 350, 0]);
        Screen('DrawTexture',window,resp.greyTex,[],resp.greyRect-[350, 0, 350, 0]);
        Screen('DrawTexture',window, resp.imLeft1,[],resp.imageRect-[350, 0, 350, 0]);
        Screen('DrawTexture',window, resp.imLeft2,[],resp.imageRect-[350, 0, 350, 0]);
        
        Screen('DrawTexture',window,resp.whiteTex,[],resp.whiteRect+[350, 0, 350, 0]);
        Screen('DrawTexture',window,resp.greyTex,[],resp.greyRect+[350, 0, 350, 0]);
        Screen('DrawTexture',window, resp.imRight1,[],resp.imageRect+[350, 0, 350, 0]);
        Screen('DrawTexture',window, resp.imRight2,[],resp.imageRect+[350, 0, 350, 0]);
        
    elseif resp.test == 0
        DrawFormattedText(window,resp.text2,'center', resp.tCenter2(2),[],resp.wrapat,[],[],1.5);
        DrawFormattedText(window,resp.text3,'center', resp.tCenter3(2),[],resp.wrapat,[],[],1.5);
        DrawFormattedText(window,resp.text4,'center', resp.tCenter4(2),[],resp.wrapat,[],[],1.5);
        DrawFormattedText(window,resp.text5,'center', resp.tCenter5(2),[],resp.wrapat,[],[],1.5);
        DrawFormattedText(window,resp.text6,'center', resp.tCenter6(2),[],resp.wrapat,[],[],1.5);
        
    end
    Screen('DrawText', window, resp.text_enter, resp.tCenterEnter(1), resp.tCenterEnter(2), textColor);
    Screen(window,'DrawText',reply,oldX,oldY,textColor);
    
    % display image
    Screen('DrawingFinished', window);
    Screen('Flip', window);
    
    
end


if length(reply)<1
    reply = ' ';
end

% Restore text size:
Screen('TextSize', window ,oldFontSize);

end
