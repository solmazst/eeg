function power_spect = power_spect(data,sampling_rate,num_freq)
Fs = sampling_rate;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = length(data);             % Length of signal
t = (0:L-1)*T;        % Time vector

if nargin < 3 || isempty(num_freq)
    warning('warning: Frequncy domain would be same length as the input domain.')
    %Y = fft(data/nansum(data));
    Y = fft(data);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
else
    n = num_freq;   % n is the number of frequencies you would like to see the amplitude at within each second
   % Y = fft(data/nansum(data),n);
    Y = fft(data,n);
    P2 = abs(Y/n);
    P1 = P2(1:n/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(n/2))/n;
end
size(f');
size(P1);
if iscolumn(P1)
    power_spect = [f' P1];
else
    power_spect = [f' P1'];
end
% figure;  
% plot(f,P1(1:length(f))) 
% title('Single-Sided Amplitude Spectrum of data')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')
