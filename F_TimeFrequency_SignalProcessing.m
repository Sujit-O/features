function frame = F_TimeFrequency_SignalProcessing(signal, Fs)
windowLength=length(signal);
Ham = window(@hamming, windowLength);
frame  = signal.* Ham;
end
