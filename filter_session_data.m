function filt_d = filter_session_data(session)
%Here first filter the channels with more than 20% bad epochs, then from
%the left channels remove the epochs that are bad in more than 25% of
%channels. 

% once the good channels are filtered and saved as the epoch matrix, the bad epochs are marked as NAN in the rawdata.
% the result is saved as good samples in the session.data.filter_samples

for i =1: size(session.data)
    session.data(i).filter_samples = ones(size(session.data(i).raw_data)).*nan;
    session.data(i).good_channs = cell(size(session.data(i).raw_data,3),1);
    for j = 1: size(session.data(i).raw_data,3)
        filt_chans = filter_channels(session.data(i).good_epochs(:,:,j));
        session.data(i).good_channs{j} = filt_chans.good_channs;
        good_epochs_sampled = repelem(filt_chans.good_epochs,session.data(i).sampling_rate,1);
        session.data(i).filter_samples(:,:,j) = session.data(i).raw_data(:,:,j).*good_epochs_sampled;
        clear good_epochs_sampled;
    end
end

filt_d  = session;
end