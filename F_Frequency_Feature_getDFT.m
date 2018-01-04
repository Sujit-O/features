function [frameFFT, frameFreq] = F_Frequency_Feature_getDFT(signal, Fs)

N = length(signal);
signal = F_TimeFrequency_SignalProcessing(signal, Fs);
gx=gpuArray(signal);
gfft=fft(gx);
signal1=abs(gfft) / N;
% signal1=gather(gfft);
frameFFT = gather(signal1);
% frameFFT = abs(fft(signal)) / N;
frameFFT = frameFFT(1:ceil(N/2));
frameFreq = (Fs/2) * (1:ceil(N/2)) / ceil(N/2); 

end
