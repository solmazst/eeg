clear all
load('I4_SFSweep_11-10-2016.mat')
filt_session = filter_session_data(session);


% 1) for each trial plot the 1/3 cycle waveform for:
%a) each epoch averaged over all channels  ( 10 plots, each for 1 trial)
%b) averge over all epochs and all channels per each trial ( 1 plot with 10 subplots)
%c) plot the easiest condition for each trial for each channel ( 10 plots,
%each # of channels)
subj_date  = session.exp_date(1:strfind(session.exp_date,' '))
subj.name = session.subj_name;
subj.date = subj_date;
subj.stim_params = session.stim_params;
subj.avg_data = repmat(struct('cond', [],'per_trl', [],'sampling_rate',[],'epoch_dur',[], 'per_chan',[],'avg_chan_ep',[],'avg_trl_ep',[]),filt_session.num_cond,1);


for i =1:filt_session.num_cond
%    for j =1: size(filt_session.data(1).filter_samples)
%         subj.avg_data.per_trl= [subj.avg_data.per_trl nanmean(filt_session.data(1).filter_samples(:,filt_session.data(1).good_channs{j},j),2)];
%         
%    end
   subj.avg_data(i).cond = i;
   subj.avg_data(i).sampling_rate = session.data(i).sampling_rate;
   subj.avg_data(i).epoch_dur = session.data(i).epoch_dur;
   subj.avg_data(i).padding = session.data(i).padding_epochs;
   num_epoch = size(filt_session.data(i).good_epochs,1);
   num_trl = size(filt_session.data(i).good_epochs,3);
   num_chan = size(filt_session.data(i).good_epochs,2);
   subj.avg_data(i).per_chan = nanmean(filt_session.data(i).filter_samples,3);
   subj.avg_data(i).avg_chan_ep = reshape(subj.avg_data(i).per_chan,filt_session.data(i).sampling_rate,num_epoch,num_chan);
   
   avg_trl= nanmean(filt_session.data(i).filter_samples,2);
   subj.avg_data(i).per_trl= reshape(avg_trl,[],size(avg_trl,3),1);
   subj.avg_data(i).avg_trl_ep = reshape(subj.avg_data(i).per_trl,filt_session.data(i).sampling_rate,num_epoch,num_trl);
  
   clear avg_trl;
   
end


output_name = strcat(session.subj_name,'_',session.exp_stimulus,'_','avg_',subj_date,'.mat')
save(output_name,'subj');
