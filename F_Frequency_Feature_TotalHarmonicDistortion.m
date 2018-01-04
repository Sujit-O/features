function frequencyTHD = F_Frequency_Feature_TotalHarmonicDistortion(signal, fs )

frequencyTHD = thd(signal,fs,3);

end