function filter_chans_ep = filter_channels(good_epochs)
%     filter_chans.good_channs = [];
%     filter_chans.good_epochs = [];
    %first exclude channels where more than ep_lim*num_epochs are marked bad in
    %each channel: (more than 20% of epochs being bad in a channel, channel
    %will be excluded)
    ep_lim = 0.2;
    
    %then from the good channels, exclude epochs that are bad in more than
    %25% of the ramaining channels.
    chan_lim = 0.25;
    num_ep = size(good_epochs,1);
    
    bad_channs = find(sum(isnan(good_epochs))>=ceil(ep_lim*num_ep)==1);
    good_channs = find(sum(isnan(good_epochs))>=ceil(ep_lim*num_ep)==0);
    filter_chans = good_epochs;
    
    filter_chans(:,bad_channs)=nan;
    temp_good = filter_chans(:,good_channs);
    num_chans = size(temp_good,2);
    
    temp_good(find((sum(isnan(temp_good),2)>= ceil(chan_lim*num_chans))==1),:)=nan;
    filter_chans(:,good_channs) = temp_good;
    filter_chans_ep.good_channs = good_channs;
    filter_chans_ep.good_epochs = filter_chans;
end
