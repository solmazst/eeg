function f_filter  = first_filter(session)
%Here only the bad epochs as marked by power diva are set to nan in the raw
%data. 
    for i =1: size(session.data)
        session.data(i).first_filter = ones(size(session.data(i).raw_data)).*nan;
        session.data(i).good_channs = cell(size(session.data(i).raw_data,3),1);
        for j = 1: size(session.data(i).raw_data,3)
            good_epochs_sampled = repelem(session.data(i).good_epochs(:,:,j),ceil(session.data(i).epoch_dur * session.data(i).sampling_rate),1);
            session.data(i).first_filter(:,:,j) = session.data(i).raw_data(:,:,j).*good_epochs_sampled;
            clear good_epochs_sampled;
        end
    end

    f_filter  = session;
end