function avg_plt = plot_waveform(subj,cond,plt_cond)
   
     switch plt_cond
         
         case 'trial'
             figure;
               plt_titl = sprintf('%s,waveform, Average of channels in each trials, %s, %s\n', subj.name,subj.stim_params.cond{cond},subj.date);
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
                 plt_titl = sprintf('%s,waveform, Average of trials per each channel, %s, %s\n', subj.name,subj.stim_params.cond{cond},subj.date);
                 suptitle(plt_titl);  
                 my_ylim = [];
                 tmp_ep =subj.avg_data(cond).avg_chan_ep;
                 tmp_ep(:,subj.avg_data(cond).padding,:)=[];
                 mean_trl = nanmean(tmp_ep,2);
                 %tot_chan = size(subj.avg_data(cond).avg_chan_ep,3);
                 good_chans = find(~isnan(sum(sum(tmp_ep,2),1)));
                 tot_chan = length(good_chans);
                 num_row = ceil(tot_chan/3);
                 num_col = ceil(tot_chan/num_row);
                 for k =1:tot_chan
                           i = good_chans(k);
                           mean_tmp =  mean(reshape(mean_trl(:,1,i),size(mean_trl(:,1,i),1)/3,3),2);
                           ax_sub(k) =  subplot(num_row,num_col,k);
                           plot(mean_tmp);
                           my_ylim = [my_ylim; ax_sub(k).YLim];
                           set(gca,'xtick',[0:subj.avg_data(cond).sampling_rate/9:subj.avg_data(cond).sampling_rate/3]);
                           set(gca,'xticklabel',[0:floor(1000/9):floor(1000/3)])
                           chn_tit = sprintf('chan%d',i);
                           title(chn_tit);
                           clear mean_tmp
                           j = k;
                      
                 end
                
                linkaxes(ax_sub,'xy');
                ax_sub(j).YLim =  [min(min(my_ylim)) max(max(my_ylim))];
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
                
         case 'all'
             figure;
             tmp_ep = subj.avg_data(cond).avg_trl_ep;
             tmp_ep(:,subj.avg_data(cond).padding,:)=[];
             avg_per_ep = nanmean(tmp_ep,3);
             num_epoch = size(tmp_ep,2);
             avg_allep = nanmean(avg_per_ep ,2);
             mean_tmp =  mean(reshape(avg_allep,size(avg_allep,1)/3,3),2);
             plot(mean_tmp);
             set(gca,'xtick',[0:subj.avg_data(cond).sampling_rate/9:subj.avg_data(cond).sampling_rate/3]);
             set(gca,'xticklabel',[0:floor(1000/9):floor(1000/3)]);
             avg_title = sprintf('%s,waveform, Average of all channels and trials and epochs, %s, %s\n', subj.name,subj.stim_params.cond{cond},subj.date);
             title(avg_title);
             h = axes('Position',[0 0 1 1],'Visible','off'); %add an axes on the left side of your subplots
            set(gcf,'CurrentAxes',h);
            text(.1,.45,'Micro Volt',...
            'VerticalAlignment','bottom',...
            'HorizontalAlignment','left', 'Rotation', 90, 'FontSize',18);

            text(.45,.05,'Mili Seconds',...
            'VerticalAlignment','bottom',...
            'HorizontalAlignment','left', 'Rotation', 0, 'FontSize',18);
            
            figure;
             plt_titl = sprintf('%s,waveform, Average all trials/channels per epoch, %s, %s\n', subj.name,subj.stim_params.cond{cond},subj.date);
             suptitle(plt_titl);  
             my_ylim = [];
             num_row = ceil(num_epoch/3);
             num_col = ceil(num_epoch/num_row);
             for i =1:num_epoch
                   mean_tmp =  mean(reshape(avg_per_ep(:,i),size(avg_per_ep,1)/3,3),2);
                   ax_sub(i) =  subplot(num_row,num_col,i);
                   plot(mean_tmp);
                   my_ylim = [my_ylim; ax_sub(i).YLim];
                   set(gca,'xtick',[0:subj.avg_data(cond).sampling_rate/9:subj.avg_data(cond).sampling_rate/3]);
                   set(gca,'xticklabel',[0:floor(1000/9):floor(1000/3)])
                   chn_tit = sprintf('%s = %.2f',subj.stim_params.var{cond},subj.stim_params.val{cond}(i));
                   title(chn_tit);
                   clear mean_tmp;
             end
            
             ax_sub(1).YLim =  [min(min(my_ylim)) max(max(my_ylim))];
             linkaxes(ax_sub,'xy');
             clear ax_sub;
             clear my_ylim;
             clear avg_all
             clear avg_per_ep
             h = axes('Position',[0 0 1 1],'Visible','off'); %add an axes on the left side of your subplots
            set(gcf,'CurrentAxes',h);
            text(.1,.45,'Micro Volt',...
            'VerticalAlignment','bottom',...
            'HorizontalAlignment','left', 'Rotation', 90, 'FontSize',18);

            text(.45,.05,'Mili Seconds',...
            'VerticalAlignment','bottom',...
            'HorizontalAlignment','left', 'Rotation', 0, 'FontSize',18);
     end

 end

