function localizer1_test(subID,runID)
    % function to run localizer 1 fMRI task
    % 6 catergories of stimulus types 
    % For each stimulus type, 4 blocks of 20 seconds with 6 second fixation
    % between blocks
    % Within block, each stimulus is shown for 2 seconds
    % 10% of trials will repeat for 1-back task

    %myTrials = funct_get_myTrials(subID,runID);
    myTrials = func_GetMyTrials;
    %myTrials = table2struct( readtable('Users/emilyschwartz/Desktop/Projects/test_video_trials.xlsx') );

    % Set up the window
    PsychDefaultSetup(2);
    Screen('Preference', 'SkipSyncTests', 2)
    screenid = max(Screen('Screens'));
    [win, windowRect] = Screen(screenid, 'openwindow',[1 1 1],[]);
    [width, height]= Screen('DisplaySize', screenid);
    p.fixCrossTime = 6; % time fixation cross between blocks 
    ptb.fixCrossSize = 60;
    ptb.backgroundColor = [125 125 125];

    %windowPtr=Screen('Windows');
    % Wait for scanner trigger
    % TODO change tigger key once known
    func_wait_for_trigger(win,'space')

    expStart = GetSecs; % Get time0, check this shouldn't be after instructions

    %% Instructions 
    % Show instructions...
tsize=30;
Screen('TextSize', win, tsize);
[x, y]=Screen('DrawText', win, 'You will view a collection of images and videos.',40, 100, [255 255 255]); %#ok<*ASGLU>
[x, y]=Screen('DrawText', win, 'Press the Key1 if the image or video you see is the same as the previous image or video and Key2 if it is not.', 40, y + 10 + tsize, [255 255 255]);
Screen('DrawText', win, 'Press any key to start the experiment...', 40, y + 10 + tsize, [255 255 255]);

% Flip to show the grey screen:
Screen('Flip',win);

% Wait for keypress + release...
KbStrokeWait;

% Show cleared screen...
Screen('Flip',win);

% Wait a second...
WaitSecs(1)
    
    %%
    %%% Experiment loop

    %numBlocks = length(myTrials.Block)/max([myTrials.Block]); 
    numBlocks = 24; 
    present_idx = 0; % to keep track of the trial order
 
    for block = 1:numBlocks
        blockTrials = find([myTrials.Block]'== block);
        for trial = 1:length(blockTrials)
            present_idx = present_idx + 1;
            %filePath = myTrials(present_idx).FilePath;
            index = blockTrials(trial);
            %filePath = myTrials.FilePath{index};
            filePath = myTrials(index).FilePath;
            filePath = filePath{1};
            if contains(filePath, '.mov')
                [pressedKey,pressedTimes,t_video_on,t_video_off] = func_playmovie_with_response(filePath,win);
                % Show cleared screen...
                Screen('Flip',win);
                %WaitSecs(1)
                %DrawFormattedText(win, '.','center','center',[1 1 1]);
                %Screen('Flip',win);
                t_hold = GetSecs;
                if trial ~= 10
                    while GetSecs <= (t_hold + 0.4)
                    %WaitSecs(1)
                    Screen('TextSize', win, 80)
                    DrawFormattedText(win, '.','center','center',[255 255 255]);
                    Screen('Flip',win);
                    end
                end
            else
                [pressedKey,pressedTimes,t_video_on,t_video_off] = func_playimage_with_response(filePath,win);
                % Show cleared screen...
                Screen('Flip',win)
                t_hold = GetSecs;
                if trial ~= 10
                    while GetSecs <= (t_hold + 0.5)
                    %WaitSecs(1)
                    Screen('TextSize', win, 80)
                    DrawFormattedText(win, '.','center','center',[255 255 255]);
                    Screen('Flip',win);
                    end   
                end
            end

            % Record responses and times
            myTrials(index).response = pressedKey; % save pressed keys during the video
            myTrials(index).RT = pressedTimes; % save RTs relative to video onset      
            myTrials(index).t_on = t_video_on-expStart; % time video was shown relative to experiment start
            myTrials(index).t_off = t_video_off-expStart; % time video ended relative to experiment start  
            myTrials(index).order = present_idx; % trial number (order stimulus was seen)
        end
        save(fullfile('Data',sprintf('myTrials_S%02d-run-%02d.mat',subID,runID)),'myTrials');
        save(fullfile('Data',sprintf('workspace_S%02d-run-%02d.mat',subID,runID))); 
        % fixation cross between blocks 
        Screen('TextSize', win,ptb.fixCrossSize); % Instruction Size;
        DrawFormattedText(win, '+','center','center',[255 255 255]);
        Screen('flip',win);  
        fixCrossStart = GetSecs; % take the time 
        while GetSecs < fixCrossStart + p.fixCrossTime % while less than 6 seconds?
        end
    end %ends experiment loop
    
    % after the experiment, save variables
    %save(fullfile('Data',sprintf('myTrials_S%02d-run-%02d.mat',subID,runID)),'myTrials');
    %save(fullfile('Data',sprintf('workspace_S%02d-run-%02d.mat',subID,runID))); 
    
    DrawFormattedText(win, sprintf('End of run %d/6',runID), 'center', 'center', []);
    Screen('Flip', win);
    pause(5)
    sca; % close PTB
        
end %ends function