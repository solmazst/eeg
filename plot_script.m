clear all

load('I4_SFSweep_avg_11-10-2016.mat')

%plot trial data per condition, avg over channels and epochs

%plot_waveform (subj,2,'all');
elec_list = sort([19,20,21,22,25,26,27,14,15,16,12,5:8]);
cond = 3;
%plot_sig_noise(subj,1,'trial',elec_list);
plot_sig_noise_111616(subj,1,'trial',elec_list);

%plot_waveform(subj,1,'chan');

%%
load('I4_SFSweep_11-10-2016.mat')
elec_list = sort([19,20,21,22,25,26,27,14,15,16,12,5:8]);
cond = 1;
%just filter the bad epochs:
filt_session = first_filter(session);

avg_per_ec = nanmean(filt_session.data(1).first_filter(:,elec_list,:),3);
avg_all = nanmean(avg_per_ec,2);

num_epoch = size(filt_session.data(1).good_epochs,1);
avg_ep = reshape(avg_all,ceil(filt_session.data(1).epoch_dur.*filt_session.data(1).sampling_rate),num_epoch);
avg_ep(:,filt_session.data(1).padding_epochs)= [];
num_epoch  = size(avg_ep,2);
figure;
plt_titl = sprintf('%s, %s, %s\n Signal per epoch\n\n',filt_session.subj_name,filt_session.stim_params.cond{cond},filt_session.exp_date);
suptitle(plt_titl);  
sig_ep = zeros(2,num_epoch);
noise_ep = zeros(2,num_epoch);



my_ylim = [];
num_row = ceil(num_epoch/3);
num_col = ceil(num_epoch/num_row);
for i=1:num_epoch
    p_spc = power_spect(avg_ep(:,i),filt_session.data(1).sampling_rate);
    fr = p_spc(:,1);
    amp_c = p_spc(:,2);
    sig_ep(1,i) = amp_c(fr==3);
    sig_ep(2,i) = amp_c(fr==6);
    noise_ep(1,i)=  (amp_c(find(fr==3)+1)+amp_c(find(fr==3)-1))/2;
    noise_ep(2,i)=  (amp_c(find(fr==6)+1)+amp_c(find(fr==6)-1))/2;

   ax_sub(i) =  subplot(num_row,num_col,i);
   plot(fr(find(fr==1):find(fr==10)),amp_c(find(fr==1):find(fr==10)));
   my_ylim = [my_ylim; ax_sub(i).YLim];
   subplot(num_row,num_col,i),line([3 3],ylim,'LineWidth',1,'color','r');
   subplot(num_row,num_col,i),line([6 6],ylim,'LineWidth',1, 'color','r');
   ep_tit = sprintf('%s = %.2f',filt_session.stim_params.var{cond},filt_session.stim_params.val{cond}(i));
   title(ep_tit);
   clear amp_c
   clear fr
   clear p_spc
 end
 ax_sub(1).YLim =  [min(min(my_ylim)) max(max(my_ylim))];
 linkaxes(ax_sub,'xy');
 clear ax_sub;
 clear my_ylim;
 
 figure;
 snr_3 = sig_ep(1,:)./noise_ep(1,:);
 snr_3(find(isnan(snr_3))) = 0;
 snr_6 = sig_ep(2,:)./noise_ep(2,:);
 snr_6(find(isnan(snr_6)))= 0;
 plot(filt_session.stim_params.val{cond},sig_ep(1,:)./noise_ep(1,:),'LineWidth',2,'Marker','o','Color','k')
 hold on
 plot(filt_session.stim_params.val{cond},sig_ep(2,:)./noise_ep(2,:),'LineWidth',2,'Marker','o','Color','r')
 legend('3 HZ', '6 HZ');
 set(gca, 'xlim', [min(filt_session.stim_params.val{cond})-0.5,max(filt_session.stim_params.val{cond})+0.5])
 set(gca, 'xscale', 'log')
 xlabel('SF (cyc/deg)')
 ylabel('SNR')
 plt_titl = sprintf('%s,%s, %s\nSNR, adjacent fr \n', filt_session.subj_name,filt_session.stim_params.cond{cond},filt_session.exp_date);
 title(plt_titl)


 figure;
 plot(filt_session.stim_params.val{cond},sig_ep(1,:)./mean(noise_ep(1,:)),'LineWidth',2,'Marker','o','Color','k')
 hold on
 plot(filt_session.stim_params.val{cond},sig_ep(2,:)./mean(noise_ep(2,:)),'LineWidth',2,'Marker','o','Color','r')
 legend('3 HZ', '6 HZ');
 set(gca, 'xlim', [min(filt_session.stim_params.val{cond})-0.5,max(filt_session.stim_params.val{cond})+0.5])
 set(gca, 'xscale', 'log')
 xlabel('SF (cyc/deg)')
 ylabel('SNR')
 plt_titl = sprintf('%s,%s, %s\nSNR, all fr \n', filt_session.subj_name,filt_session.stim_params.cond{cond},filt_session.exp_date);
 title(plt_titl)

 
%%
%texture:
load('I4_text38_blk1_10-10-2016.mat')
cond = 1;
elec_list = sort([19,20,21,22,25,26,27,14,15,16,12,5:8]);

filt_session  = first_filter(session);
avg_per_ec = nanmean(filt_session.data(1).first_filter(:,elec_list,:),3);
avg_all = nanmean(avg_per_ec,2);
num_epoch = size(filt_session.data(1).good_epochs,1);
avg_ep = reshape(avg_all,ceil(filt_session.data(1).epoch_dur.*filt_session.data(1).sampling_rate),num_epoch);
avg_ep(:,filt_session.data(1).padding_epochs)= [];
num_epoch  = size(avg_ep,2);

figure;
plt_titl = sprintf('%s, %s, %s\n Signal per epoch\n\n',filt_session.subj_name,filt_session.stim_params.cond{cond},filt_session.exp_date);
suptitle(plt_titl);  
sig_ep = zeros(2,num_epoch);
noise_ep = zeros(2,num_epoch);



my_ylim = [];
num_row = ceil(num_epoch/3);
num_col = ceil(num_epoch/num_row);
for i=1:num_epoch
    %p_spc = power_spect(avg_ep(:,i),ceil(filt_session.data(1).epoch_dur.*filt_session.data(1).sampling_rate));
    p_spc = power_spect(avg_ep(:,i),ceil(filt_session.data(1).sampling_rate));
    fr = p_spc(:,1);
    amp_c = p_spc(:,2);
    sig_ep(1,i) = amp_c(fr==3);
    sig_ep(2,i) = amp_c(fr==6);
    noise_ep(1,i)=  (amp_c(find(fr==3)+1)+amp_c(find(fr==3)-1))/2;
    noise_ep(2,i)=  (amp_c(find(fr==6)+1)+amp_c(find(fr==6)-1))/2;

   ax_sub(i) =  subplot(num_row,num_col,i);
   plot(fr(find(fr==0.5):find(fr==10)),amp_c(find(fr==0.5):find(fr==10)));
   my_ylim = [my_ylim; ax_sub(i).YLim];
   subplot(num_row,num_col,i),line([3 3],ylim,'LineWidth',1,'color','r');
   subplot(num_row,num_col,i),line([6 6],ylim,'LineWidth',1, 'color','r');
   ep_tit = sprintf('%s = %.2f',filt_session.stim_params.var,filt_session.stim_params.val{cond}(i));
   title(ep_tit);
   clear amp_c
   clear fr
   clear p_spc
end
  ax_sub(1).YLim =  [min(min(my_ylim)) max(max(my_ylim))];
 linkaxes(ax_sub,'xy');
 clear ax_sub;
 clear my_ylim;
 
 
 
 figure;
 snr_3 = sig_ep(1,:)./noise_ep(1,:);
 snr_3(find(isnan(snr_3))) = 0;
 snr_6 = sig_ep(2,:)./noise_ep(2,:);
 snr_6(find(isnan(snr_6)))= 0;
 plot(filt_session.stim_params.val{cond},sig_ep(1,:)./noise_ep(1,:),'LineWidth',2,'Marker','o','Color','k')
 hold on
 plot(filt_session.stim_params.val{cond},sig_ep(2,:)./noise_ep(2,:),'LineWidth',2,'Marker','o','Color','r')
 legend('3 HZ', '6 HZ');
 set(gca, 'xlim', [min(filt_session.stim_params.val{cond})-0.5,max(filt_session.stim_params.val{cond})+0.5])
 set(gca, 'xscale', 'log')
 xlabel('SF (cyc/deg)')
 ylabel('SNR')
 plt_titl = sprintf('%s,%s, %s\nSNR, adjacent fr \n', filt_session.subj_name,filt_session.stim_params.cond{cond},filt_session.exp_date);
 title(plt_titl)


 figure;
 plot(filt_session.stim_params.val{cond},sig_ep(1,:)./mean(noise_ep(1,:)),'LineWidth',2,'Marker','o','Color','k')
 hold on
 plot(filt_session.stim_params.val{cond},sig_ep(2,:)./mean(noise_ep(2,:)),'LineWidth',2,'Marker','o','Color','r')
 legend('3 HZ', '6 HZ');
 set(gca, 'xlim', [min(filt_session.stim_params.val{cond})-0.5,max(filt_session.stim_params.val{cond})+0.5])
 set(gca, 'xscale', 'log')
 xlabel('SF (cyc/deg)')
 ylabel('SNR')
 plt_titl = sprintf('%s,%s, %s\nSNR, all fr \n', filt_session.subj_name,filt_session.stim_params.cond{cond},filt_session.exp_date);
 title(plt_titl)
 