function SNR_plt = plot_sig_noise(subj,cond,plt_cond,elec_list)

  switch plt_cond
         
         case 'trial'
             figure;
               plt_titl = sprintf('%s,Average of channels and epochs in each trials, %s, %s\n', subj.name,subj.stim_params.cond{cond},subj.date);
               suptitle(plt_titl);  
               my_ylim = [];
               tmp_ep = subj.avg_data(cond).avg_trl_ep;
               tmp_ep(:,subj.avg_data(cond).padding,:)=[];
               mean_trl = nanmean(tmp_ep,2);
               tot_trl = size(subj.avg_data(cond).avg_trl_ep,3);
               num_row = ceil(tot_trl/3);
               num_col = ceil(tot_trl/num_row);
               for i =1:tot_trl
                   mean_tmp =  mean(reshape(mean_trl(:,1,i),size(mean_trl(:,1,i),1)/3,3),2);
                   ax_sub(i) = subplot(num_row,num_col,i);
                   plot(mean_tmp);
                   my_ylim = [my_ylim; ax_sub(i).YLim];
                   set(gca,'xtick',[0:subj.avg_data(cond).sampling_rate/9:subj.avg_data(cond).sampling_rate/3]);
                   set(gca,'xticklabel',[0:floor(1000/9):floor(1000/3)])
                   chn_tit = sprintf('trial%d',i);
                   title(chn_tit);
                   clear mean_tmp
               end
                
                ax_sub(1).YLim =  [min(min(my_ylim)) max(max(my_ylim))];
                linkaxes(ax_sub,'xy');
                clear ax_sub;
                clear my_ylim;
                h = axes('Position',[0 0 1 1],'Visible','off'); %add an axes on the left side of your subplots
            set(gcf,'CurrentAxes',h);
            text(.1,.45,'Micro Volt',...
            'VerticalAlignment','bottom',...
            'HorizontalAlignment','left', 'Rotation', 90, 'FontSize',18);

            text(.45,.05,'Mili Seconds',...
            'VerticalAlignment','bottom',...
            'HorizontalAlignment','left', 'Rotation', 0, 'FontSize',18);

         case 'chan'
                 figure;
                 plt_titl = sprintf('%s, %s, %s\n,SNR \n ', subj.name,subj.stim_params.cond{cond},subj.date);
                 suptitle(plt_titl);  
                 my_ylim = [];
                 tmp_ep =subj.avg_data(cond).avg_chan_ep;
                 tmp_ep(:,subj.avg_data(cond).padding,:)=[];
                 if nargin < 4 || isempty(elec_list)
                   good_chans = find(~isnan(sum(sum(tmp_ep,2),1)));
                 else
                     good_chans = elec_list;
                 end
                 
                 tot_chan = length(good_chans);
                 num_epoch = size(tmp_ep,2);
                 num_row = ceil(tot_chan/3);
                 num_col = ceil(tot_chan/num_row);
                 sig_ep = zeros(2,num_epoch);
                 noise_ep = zeros(2,num_epoch);
                 for k =1:tot_chan
                     for e = 1: num_epoch
                           i = good_chans(k);
                           p_spc = power_spect(tmp_ep(:,e,i),subj.avg_data(cond).sampling_rate);
                            fr = p_spc(:,1);
                            amp_c = p_spc(:,2);
                            sig_ep(1,e) = amp_c(fr==3);
                            sig_ep(2,e) = amp_c(fr==6);
                            noise_ep(1,e)=  (amp_c(find(fr==3)+1)+amp_c(find(fr==3)-1))/2;
                            noise_ep(2,e)=  (amp_c(find(fr==6)+1)+amp_c(find(fr==6)-1))/2;
                     end
                        ax_sub(k) =  subplot(num_row,num_col,k);
                        plot(subj.stim_params.val{cond},sig_ep(1,:)./mean(noise_ep(1,:)),'LineWidth',2,'Marker','o','Color','k')
                         hold on
                         plot(subj.stim_params.val{cond},sig_ep(2,:)./mean(noise_ep(2,:)),'LineWidth',2,'Marker','o','Color','r')
                         my_ylim = [my_ylim; ax_sub(i).YLim];
                         set(gca, 'xlim', [min(subj.stim_params.val{cond})-0.5,max(subj.stim_params.val{cond})+0.5]);
                         set(gca, 'xscale', 'log');  
                         xlab = sprintf('%s',subj.stim_params.var{cond});
                         xlabel(xlab);
                         ylabel('SNR');
                        chn_tit = sprintf('chan%d',i);
                        title(chn_tit);
                        clear mean_tmp
                        clear amp_c
                        clear fr
                        j = k;
                 end
                legend('3 HZ', '6 HZ');
                %linkaxes(ax_sub,'xy');
                ax_sub(j).YLim =  [min(min(my_ylim)) max(max(my_ylim))];
                linkaxes(ax_sub,'xy');
                clear ax_sub;
                clear my_ylim;
                
         case 'all'
             figure;
             plt_titl = sprintf('%s, %s, %s\n Signal per epoch\n', subj.name,subj.stim_params.cond{cond},subj.date);
             suptitle(plt_titl);  
             if nargin < 4 || isempty(elec_list)
               tmp_ep = subj.avg_data(cond).avg_chan_ep;
             else
                 tmp_ep = subj.avg_data(cond).avg_chan_ep(:,:,elec_list);
             end
             
             tmp_ep(:,subj.avg_data(cond).padding,:)=[];
             avg_per_ep = nanmean(tmp_ep,3);
             num_epoch = size(tmp_ep,2);
             sig_ep = zeros(2,num_epoch);
             noise_ep = zeros(2,num_epoch);
            
             my_ylim = [];
             num_row = ceil(num_epoch/3);
             num_col = ceil(num_epoch/num_row);
             for i=1:num_epoch
                p_spc = power_spect(avg_per_ep(:,i),subj.avg_data(cond).sampling_rate);
                fr = p_spc(:,1);
                amp_c = p_spc(:,2);
                sig_ep(1,i) = amp_c(fr==3);
                sig_ep(2,i) = amp_c(fr==6);
                noise_ep(1,i)=  (amp_c(find(fr==3)+1)+amp_c(find(fr==3)-1))/2;
                noise_ep(2,i)=  (amp_c(find(fr==6)+1)+amp_c(find(fr==6)-1))/2;
                
               ax_sub(i) =  subplot(num_row,num_col,i);
               plot(fr(find(fr==1):find(fr==10)),amp_c(fr(find(fr==1):find(fr==10))));
               my_ylim = [my_ylim; ax_sub(i).YLim];
               subplot(num_row,num_col,i),line([3 3],ylim,'LineWidth',1,'color','r');
               subplot(num_row,num_col,i),line([6 6],ylim,'LineWidth',1, 'color','r');
               ep_tit = sprintf('%s = %.2f',subj.stim_params.var{cond},subj.stim_params.val{cond}(i));
               title(ep_tit);
               clear amp_c
               clear fr
               clear p_spc
             end
             ax_sub(1).YLim =  [min(min(my_ylim)) max(max(my_ylim))];
             linkaxes(ax_sub,'xy');
             clear ax_sub;
             clear my_ylim;
             %plt_delta = abs(subj.stim_params.val{cond}(2)-subj.stim_params.val{cond}(1));
             figure;
             plot(subj.stim_params.val{cond},sig_ep(1,:)./noise_ep(1,:),'LineWidth',2,'Marker','o','Color','k')
             hold on
             plot(subj.stim_params.val{cond},sig_ep(2,:)./noise_ep(2,:),'LineWidth',2,'Marker','o','Color','r')
             legend('3 HZ', '6 HZ');
             set(gca, 'xlim', [min(subj.stim_params.val{cond})-0.5,max(subj.stim_params.val{cond})+0.5])
             set(gca, 'xscale', 'log')
             xlabel('SF (cyc/deg)')
             ylabel('SNR')
             plt_titl = sprintf('%s,%s, %s\nSNR, adjacent fr \n', subj.name,subj.stim_params.cond{cond},subj.date);
             title(plt_titl)
             
             
             figure;
             plot(subj.stim_params.val{cond},sig_ep(1,:)./mean(noise_ep(1,:)),'LineWidth',2,'Marker','o','Color','k')
             hold on
             plot(subj.stim_params.val{cond},sig_ep(2,:)./mean(noise_ep(2,:)),'LineWidth',2,'Marker','o','Color','r')
             legend('3 HZ', '6 HZ');
             set(gca, 'xlim', [min(subj.stim_params.val{cond})-0.5,max(subj.stim_params.val{cond})+0.5])
             set(gca, 'xscale', 'log')
             xlab = sprintf('%s',subj.stim_params.var{cond});
             xlabel(xlab);
             ylabel('SNR');
             plt_titl = sprintf('%s,%s, %s\nSNR, all fr \n', subj.name,subj.stim_params.cond{cond},subj.date);
             title(plt_titl)
             
             end

 end

