function myTrials = func_GetMyTrials_loc2

% load in excel and convert to table
%stimuli = table2struct( readtable('/Users/emilyschwartz/Desktop/Projects/DynFaces_fMRI/DynFaces-Localizer-1-fMRI/Stimuli/Localizer1_stimuli.xlsx') );
%stimuli = table2struct( readtable('./Stimuli/Localizer1_stimuli.xlsx') );
% ^ had absolute paths
stimuli = table2struct( readtable('./Stimuli/Localizer2_stimuli.csv') ); % relative paths
stimuli_T = struct2table(stimuli);


% shuffle stimuli
[NumRow,NumCol] = size(stimuli_T);
index = randperm(NumRow);
stimuli_shuf = stimuli(index,:);


list_of_random_dyn = []; %1
list_of_bio_dyn = []; %2
list_of_images = []; %3

 
for row = 1:length(stimuli_shuf)
    cat_name = stimuli_shuf(row).CategoryNumber;
    if cat_name == 1
        stim_index = stimuli_shuf(row).StimuliIndex;
        list_of_random_dyn = [list_of_random_dyn, stim_index];
    elseif cat_name == 2
        stim_index = stimuli_shuf(row).StimuliIndex;
        list_of_bio_dyn = [list_of_bio_dyn, stim_index];
    else
        stim_index = stimuli_shuf(row).StimuliIndex;
        list_of_images = [list_of_images, stim_index];  
    end
end

%block_choices = randi([1 24],1,24);
%block_choices = Shuffle(1:15);
block_choices = Shuffle(1:9);

random_dyn5 = reshape(list_of_random_dyn,size(list_of_random_dyn,1),9,[]);

bio_dyn5 = reshape(list_of_bio_dyn,size(list_of_bio_dyn,1),9,[]);

images5 = reshape(list_of_images,size(list_of_images,1),9,[]);

%myTrials(q*10+1:(q+1)*10).stimIndex = stim_in_block;
all_stim = [];
all_blocks = [];
j = 0;
for i = 1:3 %5
    grp = random_dyn5(1,:,i);
    r = randi([1 9],1,1);
    stim_in_block = [grp(1:r-1) grp(r) grp(r:end)];
    j = j + 1;
    block = block_choices(j);
    blocks = repelem(block, 10);
    all_stim = [all_stim; stim_in_block'];
    all_blocks = [all_blocks; blocks'];   
end

for i = 1:3 %5
    grp = bio_dyn5(1,:,i);
    r = randi([1 9],1,1);
    stim_in_block = [grp(1:r-1) grp(r) grp(r:end)];
    j = j + 1;
    block = block_choices(j);
    blocks = repelem(block, 10);
    all_stim = [all_stim; stim_in_block'];
    all_blocks = [all_blocks; blocks'];
end


for i = 1:3 %5
    grp = images5(1,:,i);
    r = randi([1 9],1,1);
    stim_in_block = [grp(1:r-1) grp(r) grp(r:end)];
    j = j + 1;
    block = block_choices(j);
    blocks = repelem(block, 10);
    all_stim = [all_stim; stim_in_block'];
    all_blocks = [all_blocks; blocks'];
end

myTrials = struct;

for trial = 1:90 %150
    myTrials(trial).StimIndex = all_stim(trial);
    myTrials(trial).Block = all_blocks(trial);
end
    
%myTrials.StimIndex = all_stim;
%myTrials.Block = all_blocks;
    
all_filepaths = cell(90,1); %150
stim_to_find = cell2mat(reshape({stimuli_shuf.StimuliIndex},[81,1]));    
%for c = 1:length(myTrials.StimIndex)
for c = 1:90 %150
    stim1 = myTrials(c).StimIndex;
    idx = find(stim_to_find == stim1);
    filePath = stimuli_shuf(idx).FileName;
    all_filepaths{c,1} = filePath;
end

for trial = 1:90 %240, 150
    myTrials(trial).FilePath = all_filepaths(trial);
end


[~,index] = sortrows([myTrials.Block].'); myTrials = myTrials(index); clear index
% ^ Sort by block

end
    
    
    
    
    
        
     
        