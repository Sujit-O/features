function frameEntropy = F_Frequency_Feature_SpectralEntropy(signal, subBlocks, Fs)

frameFFT = F_Frequency_Feature_getDFT(signal, Fs);
fftLength = length(frameFFT);
totalEnergy = sum(frameFFT.^2);
subWinLength = floor(fftLength / subBlocks);

if length(frameFFT)~=subWinLength* subBlocks
    frameFFT = frameFFT(1:subWinLength* subBlocks);
end

subWindows = reshape(frameFFT, subWinLength, subBlocks);
s = sum(subWindows.^2) / (totalEnergy+eps);
frameEntropy = -sum(s.*log2(s+eps));
end
