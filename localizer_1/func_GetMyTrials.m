function myTrials = func_GetMyTrials

% load in excel and convert to table
%stimuli = table2struct( readtable('/Users/emilyschwartz/Desktop/Projects/DynFaces_fMRI/DynFaces-Localizer-1-fMRI/Stimuli/Localizer1_stimuli.xlsx') );
%stimuli = table2struct( readtable('./Stimuli/Localizer1_stimuli.xlsx') );
% ^ had absolute paths
stimuli = table2struct( readtable('./Stimuli/Localizer1_stimuli.csv') ); % relative paths
stimuli_T = struct2table(stimuli);


% shuffle stimuli
[NumRow,NumCol] = size(stimuli_T);
index = randperm(NumRow);
stimuli_shuf = stimuli(index,:);


list_of_bodies_dyn = []; %1
list_of_bodies = []; %2
list_of_faces_dyn = []; %3
list_of_faces = []; %4
list_of_objects = []; %5
list_of_scenes = []; %6
 
for row = 1:length(stimuli_shuf)
    cat_name = stimuli_shuf(row).CategoryNumber;
    if cat_name == 1
        stim_index = stimuli_shuf(row).StimuliIndex;
        list_of_bodies_dyn = [list_of_bodies_dyn, stim_index];
    elseif cat_name == 2
        stim_index = stimuli_shuf(row).StimuliIndex;
        list_of_bodies = [list_of_bodies, stim_index];
    elseif cat_name == 3
        stim_index = stimuli_shuf(row).StimuliIndex;
        list_of_faces_dyn = [list_of_faces_dyn, stim_index];
    elseif cat_name == 4
        stim_index = stimuli_shuf(row).StimuliIndex;
        list_of_faces = [list_of_faces, stim_index];
    elseif cat_name == 5
        stim_index = stimuli_shuf(row).StimuliIndex;
        list_of_objects = [list_of_objects, stim_index];
    else
        stim_index = stimuli_shuf(row).StimuliIndex;
        list_of_scenes = [list_of_scenes, stim_index];  
    end
end

%block_choices = randi([1 24],1,24);
block_choices = Shuffle(1:24);

bodies_dyn4 = reshape(list_of_bodies_dyn,size(list_of_bodies_dyn,1),9,[]);

bodies4 = reshape(list_of_bodies,size(list_of_bodies,1),9,[]);

faces_dyn4 = reshape(list_of_faces_dyn,size(list_of_faces_dyn,1),9,[]);

faces4 = reshape(list_of_faces,size(list_of_faces,1),9,[]);

objects4 = reshape(list_of_objects,size(list_of_objects,1),9,[]);

scenes4 = reshape(list_of_scenes,size(list_of_scenes,1),9,[]);


%myTrials(q*10+1:(q+1)*10).stimIndex = stim_in_block;
all_stim = [];
all_blocks = [];
j = 0;
for i = 1:4
    grp = bodies_dyn4(1,:,i);
    r = randi([1 9],1,1);
    stim_in_block = [grp(1:r-1) grp(r) grp(r:end)];
    j = j + 1;
    block = block_choices(j);
    blocks = repelem(block, 10);
    all_stim = [all_stim; stim_in_block'];
    all_blocks = [all_blocks; blocks'];   
end

for i = 1:4
    grp = bodies4(1,:,i);
    r = randi([1 9],1,1);
    stim_in_block = [grp(1:r-1) grp(r) grp(r:end)];
    j = j + 1;
    block = block_choices(j);
    blocks = repelem(block, 10);
    all_stim = [all_stim; stim_in_block'];
    all_blocks = [all_blocks; blocks'];
end

for i = 1:4
    grp = faces_dyn4(1,:,i);
    r = randi([1 9],1,1);
    stim_in_block = [grp(1:r-1) grp(r) grp(r:end)];
    j = j + 1;
    block = block_choices(j);
    blocks = repelem(block, 10);
    all_stim = [all_stim; stim_in_block'];
    all_blocks = [all_blocks; blocks'];    
end

for i = 1:4
    grp = faces4(1,:,i);
    r = randi([1 9],1,1);
    stim_in_block = [grp(1:r-1) grp(r) grp(r:end)];
    j = j + 1;
    block = block_choices(j);
    blocks = repelem(block, 10);
    all_stim = [all_stim; stim_in_block'];
    all_blocks = [all_blocks; blocks'];
end

for i = 1:4
    grp = objects4(1,:,i);
    r = randi([1 9],1,1);
    stim_in_block = [grp(1:r-1) grp(r) grp(r:end)];
    j = j + 1;
    block = block_choices(j);
    blocks = repelem(block, 10);
    all_stim = [all_stim; stim_in_block'];
    all_blocks = [all_blocks; blocks'];
end

for i = 1:4
    grp = scenes4(1,:,i);
    r = randi([1 9],1,1);
    stim_in_block = [grp(1:r-1) grp(r) grp(r:end)];
    j = j + 1;
    block = block_choices(j);
    blocks = repelem(block, 10);
    all_stim = [all_stim; stim_in_block'];
    all_blocks = [all_blocks; blocks'];
end

myTrials = struct;

for trial = 1:240
    myTrials(trial).StimIndex = all_stim(trial);
    myTrials(trial).Block = all_blocks(trial);
end
    
%myTrials.StimIndex = all_stim;
%myTrials.Block = all_blocks;
    
all_filepaths = cell(240,1);
stim_to_find = cell2mat(reshape({stimuli_shuf.StimuliIndex},[216,1]));    
%for c = 1:length(myTrials.StimIndex)
for c = 1:240
    stim1 = myTrials(c).StimIndex;
    idx = find(stim_to_find == stim1);
    filePath = stimuli_shuf(idx).FileName;
    all_filepaths{c,1} = filePath;
end

for trial = 1:240
    myTrials(trial).FilePath = all_filepaths(trial);
end


[~,index] = sortrows([myTrials.Block].'); myTrials = myTrials(index); clear index
% ^ Sort by block

end
    
    
    
    
    
        
     
        