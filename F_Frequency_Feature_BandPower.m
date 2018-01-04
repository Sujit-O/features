function frequencyBandPower = F_Frequency_Feature_BandPower(signal, fs, freqrange )

h = bandpower(signal,fs,freqrange);
if(isempty(h))
    frequencyBandPower=0;
    return;
end
frequencyBandPower=h;
end