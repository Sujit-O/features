function frameRollOff = F_Frequency_Feature_SpectralRollOff(signal, param, Fs)
frameFFT = F_Frequency_Feature_getDFT(signal, Fs);
totalEnergy = sum(frameFFT.^2);
curEnergy = 0.0;
countFFT = 1;
fftLength = length(frameFFT);

while ((curEnergy<=param*totalEnergy) && (countFFT<=fftLength))
    curEnergy = curEnergy + frameFFT(countFFT).^2;
    countFFT = countFFT + 1;
end
countFFT = countFFT - 1;

frameRollOff = ((countFFT-1))/(fftLength);
end