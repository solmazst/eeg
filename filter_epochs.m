function filteretd_epochs = filter_epochs(good_epochs)
    % you can choose to filter your epochs considering all channels, or just
    % the channels you care about. i.e. if you consider all channels, here any
    % epoch that was marked bad in IsEpochOK in more than 40% of channels, will
    % be set to nan in all channels! But if you call this function with
    % selected channels (e.g. 7 occ channels) an epoch that is marked bad in
    % more than 40% of all the OCC channels will  be excluded from all channels. So in the
    % analysis to filter data, only the occ channels will be taken into
    % account.
    %first exclude epochs that are marked as bad in more than chann_lim * num_channels channels :
    chan_lim = 0.25;

    %then exclude channels where more than ep_lim*num_epochs are marked bad in
    %each channel: (more than 20% of epochs being bad in a channel, channel
    %will be excluded)
    ep_lim = 0.2;

    filtered_chans = good_epochs;
    num_ep = size(good_epochs,1);
    num_chans = size(good_epochs,2);
%     if nargin < 2 || isempty(selected_chans)
%         warning('warning: No channels was selected.')
%         num_chans = size(good_epochs,2);
%     else
%         num_chans = length(selected_chans);
%     end

    %first see what epochs are bad in more than 40% of channels, and set them
    %to nan in all channels. 
    filtered_chans (find((sum(isnan(filtered_chans),2)>= ceil(chan_lim*num_chans))==1),:)=nan;
    filteretd_epochs =  filtered_chans;
    %once you exclude the bad epochs from all channels, then look at it each
    %channel and exclude channels where more than 20% of epochs are bad.
    filteretd_epochs(:,find(sum(isnan(filteretd_epochs),1)>= ceil(ep_lim*num_ep)))=nan;
end