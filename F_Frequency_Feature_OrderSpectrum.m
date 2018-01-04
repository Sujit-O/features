function frameorderspectrum = F_Frequency_Feature_OrderSpectrum(signal, fs, harmonics)

%harmonics : Number of harmonics signals to be analyzed

rpm=F_Time_Feature_TachoRPM(signal, fs );
frameorderspectrum = orderspectrum(signal,fs,rpm);

[pks,locs,widths,proms]=findpeaks(frameorderspectrum,'SortStr','descend','NPeaks',harmonics);
frameorderspectrum=[pks', diff(locs)', widths', proms'];
end
