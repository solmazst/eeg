
% data in this matrix is in micro volt
clear all

input_dir = uigetdir('/Users/solmazstorbaghan/Documents/EEG/data/PD_hostData','select the directory where your .mat files from PD host are located')
cd(input_dir)
load('RTSeg_s001.mat')
cond_list = [TimeLine.cndNmb];
conds = max(cond_list);
subj_info = SegmentInfo.lastName;
h_ind = strfind(subj_info,'_');
subj_name = subj_info(1:h_ind-1);
exp_stimulus = subj_info(h_ind+1:end)
x= SegmentInfo.dateTime;
x_spc = strfind(x,' ');
exp_date = x(1:x_spc);

% all the mat files within the specified directory will be loaded and the
% information will be saved in a structure called session data. This
% structure is an array of all conditions, within each condition all the
% data in micro volt over all trials will be saved in a matrix by
% dimensions: #samples * #channels * #trials  , in the variable data
% if an epoch within one trial is bad or good is marked as 0 or 1 in a
% matrix with the dimensions: #epochs * #channels * #trials

% all the values are in double. later you can use this structure to filter
% data on a trial basis, average over conditions, trials or channels,....

% you can set the output dir here, the default is the current directory
output_dir = uigetdir('/Users/solmazstorbaghan/Documents/EEG/data/analyzed_data','Select a directory to save the output data');

output_name = strcat(subj_name,'_',exp_stimulus,'_',exp_date,'.mat');

session.subj_name = subj_name;
session.exp_stimulus = exp_stimulus;
session.exp_date = SegmentInfo.dateTime;

if strfind(exp_stimulus,'text')
    session.data = repmat(struct('cond', [],'sampling_rate',[],'epoch_dur',[],'padding_epochs',[], 'raw_data', [],'good_epochs',[]), 1, 1);

    session.num_cond =1;
else
    session.num_cond = conds;
    session.data = repmat(struct('cond', [],'sampling_rate',[],'epoch_dur',[],'padding_epochs',[], 'raw_data', [],'good_epochs',[]), conds, 1);
end
% define stimuli:
if strfind(exp_stimulus,'SF')
       stim_params.name = 'SFSweep';
        stim_params.cond_num = [1 2 3];
        stim_params.cond= {'SF Sweep', 'CT Sweep, SF =3.0', 'CT Sweep, SF = 1.0'};
        stim_params.val{1} =  [ 0.5    0.7011    0.9830    1.3782    1.9324    2.7095    3.7991    5.3267    7.4687   10.4720];
        stim_params.val{2} = [80   50.1595   31.4497   19.7187   12.3635    7.7518    4.8604    3.0474    1.9107    1.1980];
        stim_params.val{3} = [80  50.1595   31.4497   19.7187   12.3635    7.7518    4.8604    3.0474    1.9107    1.1980];
        stim_params.var = {'SF','CT','CT'};

elseif strfind(exp_stimulus,'text')

    stim_params.name = 'texture';
    stim_params.cond_num = 1;
    stim_params.cond = {'Coherency Sweep'};
    stim_params.val{1} =  fliplr(logspace(log10(.019),log10(1),7));
    stim_params.var = 'Coherency'
    
elseif strfind(exp_stimulus,'contour')

    stim_params.name = 'contour';
    stim_params.cond_num = 3;
    stim_params.cond = {'Delta Sweep (high to low)', 'No noise','Delta Sweep (low to high)'};
    stim_params.val{1} = [];
    stim_params.val{2} = [];
    stim_params.val{3} = [];
    stim_params.var ={'Delta','none','Delta'};

elseif strfind(exp_stimulus,'flash')   
        stim_params.name = 'flash';
        stim_params.cond_num = 1;
        stim_params.cond = {'Constant @ 3Hz'};
        stim_params.val{1} = [];
        stim_params.var = 'none';
else
        error ('please define the stimulus in the code')
end

session.stim_params = stim_params;
% go through all conditions and fillin the structure array
if strfind(exp_stimulus,'text')
    session.data(1).epoch_dur = CndTiming(1).stepDurSec;
    session.data(1).cond = [session.data(1).cond; CndTiming(1).pdmSignature]; % the name of condition as it is in PD 
    for i =1:conds
       j = 1
        fname= sprintf('Raw_c%03d_t%03d',i,j);
        load(fname);
        [num_epoch,num_chan]=size(IsEpochOK);
        if CndTiming(i).preludeDurSec ==0 || isempty(CndTiming(i).preludeDurSec)
                padding_ep = [];
                warning('Warning: there is no prelude/postlude in stimulus setup for cond %d, trial%d ',i,j);
        elseif CndTiming(i).preludeDurSec/ CndTiming(i).stepDurSec ==1 &&  CndTiming(i).postludeDurSec/ CndTiming(i).stepDurSec ==1
                    if ~isempty(strfind(CndTiming(i).pdmSignature,'TIM')) && num_epoch==11
                        padding_ep = [1,2,10,11];
                        warning('Warning: 4 epochs are paddings (2 preludes, 2postludes)')
                    else
                        padding_ep = [1, num_epoch];
                    end
                    session.data(1).padding_epochs = padding_ep; 
                    clear padding_ep  
        end
        eeg_volt = ones(size(RawTrial)).*nan;
        for k = 1:num_chan
            eeg_volt(:,k) = Ampl(k).*(double(RawTrial(:,k))+Shift(k)).*10^6;
        end
        session.data(1).raw_data = cat(3,session.data(1).raw_data,eeg_volt); % double in micro volt, not filtered
        good_epochs = double(IsEpochOK);
        good_epochs(good_epochs==0)=nan;
        session.data(1).good_epochs = cat(3,session.data(1).good_epochs,good_epochs); % this matrix keeps the IsEpochOK matrix for each trial and condition in double

    end
    session.data(1).sampling_rate = floor(FreqHz);
    
else
for i =1:conds
    session.data(i).epoch_dur = CndTiming(i).stepDurSec;
    session.data(i).cond = [session.data(i).cond; CndTiming(i).pdmSignature]; % the name of condition as it is in PD 
    for j = 1: sum(cond_list==i)
        fname= sprintf('Raw_c%03d_t%03d',i,j);
        load(fname);
        [num_epoch,num_chan]=size(IsEpochOK);
        if j ==1
            session.data(i).sampling_rate = floor(FreqHz);
            %  here assign the epochs that are padding 
            if CndTiming(i).preludeDurSec ==0 || isempty(CndTiming(i).preludeDurSec)
                padding_ep = [];
                warning('Warning: there is no prelude/postlude in stimulus setup for cond %d, trial%d ',i,j);
            elseif CndTiming(i).preludeDurSec/ CndTiming(i).stepDurSec ==1 &&  CndTiming(i).postludeDurSec/ CndTiming(i).stepDurSec ==1
                    if ~isempty(strfind(CndTiming(i).pdmSignature,'TIM')) && num_epoch==11
                        padding_ep = [1,2,10,11];
                        warning('Warning: 4 epochs are paddings (2 preludes, 2postludes)')
                    else
                        padding_ep = [1, num_epoch];
                    end
           session.data(i).padding_epochs = padding_ep; 
           clear padding_ep         
            end
        else if session.data(i).sampling_rate ~= floor(FreqHz)
            error('Error: condition %d trial %d has different sampling rate value.', i,j);
            end
        end
        eeg_volt = ones(size(RawTrial)).*nan;
        for k = 1:num_chan
            eeg_volt(:,k) = Ampl(k).*(double(RawTrial(:,k))+Shift(k)).*10^6;
        end
        session.data(i).raw_data = cat(3,session.data(i).raw_data,eeg_volt); % double in micro volt, not filtered
        good_epochs = double(IsEpochOK);
        good_epochs(good_epochs==0)=nan;
        session.data(i).good_epochs = cat(3,session.data(i).good_epochs,good_epochs); % this matrix keeps the IsEpochOK matrix for each trial and condition in double
    end
    
end
end


if strfind(exp_stimulus,'text')

end

output = strcat (output_dir,'/',output_name);

save(output,'session')
