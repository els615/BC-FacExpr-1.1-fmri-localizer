function localizer1(subID,runID)
    % function to run localizer 1 fMRI task
    % 6 catergories of stimulus types 
    % For each stimulus type, 4 blocks of 20 seconds with 6 second fixation
    % between blocks
    % Within block, each stimulus is shown for 2 seconds
    % 10% of trials will repeat for 1-back task

    %myTrials = funct_get_myTrials(subID,runID);
    myTrials = table2struct( readtable('Users/emilyschwartz/Desktop/Projects/test_video_trials.xlsx') );

    % Set up the window
    PsychDefaultSetup(2);
    Screen('Preference', 'SkipSyncTests', 2)
    screenid = max(Screen('Screens'));
    [win, windowRect] = Screen(screenid, 'openwindow',[128 128 128],[]);
    [width, height]= Screen('DisplaySize', screenid);
    p.fixCrossTime = 6; % time fixation cross between blocks 
    ptb.fixCrossSize = 60;

    % Wait for scanner trigger
    % TODO change tigger key once known
    func_wait_for_trigger(win,'space')

    expStart = GetSecs; % Get time0
    %%% Experiment loop

    numBlocks = length(myTrials)/max([myTrials.BlockInd]); 
    present_idx = 0; % to keep track of the trial order
 
    for block = 1:numBlocks
        blockTrials = find([myTrials.BlockInd]'==block);
        for trial = 1:length(blockTrials)
            present_idx = present_idx + 1;
            filePath = myTrials(present_idx).FilePath;
            if contains(filePath, '.mp4')
                [pressedKey,pressedTimes,t_video_on,t_video_off] = func_playmovie_with_response(filePath,win);
            else
                [pressedKey,pressedTimes,t_video_on,t_video_off] = func_playimage_with_response(filePath,win);
            end

            % Record responses and times
            myTrials(present_idx).response = pressedKey; % save pressed keys during the video
            myTrials(present_idx).RT = pressedTimes; % save RTs relative to video onset      
            myTrials(present_idx).t_on = t_video_on-expStart; % time video was shown relative to experiment start
            myTrials(present_idx).t_off = t_video_off-expStart; % time video ended relative to experiment start   
        end

        % fixation cross between blocks 
        Screen('TextSize', win,ptb.fixCrossSize); % Instruction Size;
        DrawFormattedText(win, '+','center','center',[1 1 1]);
        Screen('flip',win);  
        fixCrossStart = GetSecs; % take the time 
        while GetSecs < fixCrossStart + p.fixCrossTime % while less than 6 seconds?
        end
    end %ends experiment loop
    
    % after the experiment, save variables
    save(fullfile('Data',sprintf('myTrials_S%02d-run-%02d.mat',subID,runID)),'myTrials');
    save(fullfile('Data',sprintf('workspace_S%02d-run-%02d.mat',subID,runID))); 
    
    DrawFormattedText(win, sprintf('End of run %d/6',runID), 'center', 'center', []);
    Screen('Flip', win);
    pause(5)
    sca; % close PTB
        
end %ends function


    
       
    
    
    


    
    