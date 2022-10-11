function func_wait_for_trigger(win,trigger_key)
% Waits for trigger press before moving on, listents ONLY to the trigger
% key


oldTextSize = Screen('TextSize', win, 50)
DrawFormattedText(win, 'Waiting to start', 'center', 'center', []);
Screen('Flip', win);

% Only check the trigger key
DisableKeysForKbCheck(~strcmp(lower(KbName('KeyNames')),lower(trigger_key))); % Fill in with trigger key

trigger_pressed = 0;
while ~trigger_pressed
[keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
    if keyIsDown
        trigger_pressed = 1;
    end
end
DisableKeysForKbCheck([]); % re-enable all keys

end %ends function