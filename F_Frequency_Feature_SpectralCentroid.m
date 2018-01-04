function [frameC, frameS] = F_Frequency_Feature_SpectralCentroid(signal, fs)

frameFFT = F_Frequency_Feature_getDFT(signal, fs);
windowLength = length(frameFFT);
range = ((fs/(2*windowLength))*(1:windowLength))';
frameFFT = frameFFT / max(frameFFT);
frameC = sum(range.*frameFFT)/ (sum(frameFFT)+eps);
frameS = sqrt(sum(((range-frameC).^2).*frameFFT)/ (sum(frameFFT)+eps));

frameC = frameC / (fs/2);
frameS = frameS / (fs/2);

end


