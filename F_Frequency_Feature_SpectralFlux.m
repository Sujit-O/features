function frameFlux = F_Frequency_Feature_SpectralFlux(signal, signalPrev, fs)

frameFFT = F_Frequency_Feature_getDFT(signal, fs);
frameFFTPrev = F_Frequency_Feature_getDFT(signalPrev, fs);

frameFFT = frameFFT / sum(frameFFT);
frameFFTPrev = frameFFTPrev / sum(frameFFTPrev+eps);

frameFlux = sum((frameFFT - frameFFTPrev ).^2);
end