function framceps = F_Frequency_Feature_MFCCs_Test1(signal, fs)

windowLength = length(signal);
mfccParams =  F_Frequency_Feature_MFCSS_init(windowLength, fs);

frameFFT= F_Frequency_Feature_getDFT_noGPU(signal, fs);

earMag = log10(mfccParams.mfccFilterWeights * frameFFT+eps);
framceps = mfccParams.mfccDCTMatrix * earMag;

end

