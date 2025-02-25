function [pressedKey,pressedTimes,t_video_on,t_video_off] = func_playimage_with_response(image, win, buttons)

    % open image file
    StimName = image;
    imdata=imread(char(StimName));
    
   
%    [ysize,xsize]=size(imdata);
%     
%     x0 = windowRect(3)/2; % screen center
%     y0 = windowRect(4)/2;
%     x = 0;
%     y = 0;
%     s = 0.5;
%     destrect = [x0-s*xsize/2+x, y0-s*ysize/2+y, x0+s*xsize/2+x, y0+s*ysize/2+y];

    pressedKey = [];
    pressedTimes = [];
    DisableKeysForKbCheck([]); % list which keys are disabled

    t_video_on = GetSecs;
    
    tex=Screen('MakeTexture', win, imdata);
    % tex=Screen('MakeTexture', win, imdata, destrect);
    
    % Draw the new texture immediately to screen:
    Screen('DrawTexture', win, tex);
    % Update display:
    Screen('Flip', win);

    while GetSecs <= (t_video_on + 2)
        %isPressed = 0;
        %[keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
        RestrictKeysForKbCheck(KbName({buttons.left,buttons.right,buttons.escape}));
        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck(-3); % KbCheck(-3) scans all devices
        if keyIsDown
            %isPressed = 1;
            if strcmp(KbName(keyCode),buttons.escape); close all;sca;error('Escape Key Pressed'); end
            
            pressedKey = [pressedKey ',' KbName(keyCode)];
            pressedTimes = [pressedTimes secs-t_video_on];
            DisableKeysForKbCheck(keyCode==1); % is this to reset if they press more than 1 key in video?
        end     
    end
    
    t_video_off = GetSecs;
    
    % blank screen  
    % DrawFormattedText(win,' ','center','center',[1 1 1]);
    % Screen('flip',win);
    
    % Release texture:
    Screen('Close', tex);
    
end

    



        
        

