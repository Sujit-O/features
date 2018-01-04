function framceps = F_Frequency_Feature_MFCCs(signal, fs)

windowLength = length(signal);
mfccParams =  F_Frequency_Feature_MFCSS_init(windowLength, fs);

frameFFT= F_Frequency_Feature_getDFT(signal, fs);

earMag = log10(mfccParams.mfccFilterWeights * frameFFT+eps);
framceps = mfccParams.mfccDCTMatrix * earMag;

end

