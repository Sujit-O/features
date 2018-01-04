function frequencyFeatures = G_FeatureExtraction_Frequency(signal, fs, win, step, freqrange,harmonicNumber,numberOfMFCCCoef,param)

%Check if the signal is two channel
if (size(signal,2)>1)
    signal = mean(signal,2);
end

%convert the window and the step to its respective sample numbers
windowLength = round(win * fs);
step = round(step * fs);

%Initialize parameters for Features
% freqrange= [40 120];
subBlocks = floor(5/100*windowLength);
% param = 0.9;
% harmonicNumber =3;
% numberOfMFCCCoef=13;

[featureNames,...
    numberOfFeatures,...
    orderedSpectrumFeatureNumber] = G_FeatureExtraction_Frequency_FeatureNames(harmonicNumber,numberOfMFCCCoef);


currentPosition = 1; % for tracking signal
L = length(signal);

numberOfFrames = floor((L-windowLength)/step) + 1; %total number of frames

frequencyFeatures = zeros(numberOfFeatures, numberOfFrames);
Ham = window(@hamming, windowLength); %Hamming window to cut of the end portions


for i=1:numberOfFrames
    %current frame
    frame  = signal(currentPosition:currentPosition+windowLength-1);
    frame  = frame .* Ham;
    frameFFT = F_Frequency_Feature_getDFT(frame, fs);
    
    if (sum(abs(frame))>eps) %check if there is signal
        
        if (i==1)
            framePrev = frame;
            frameFFTPrev=frameFFT;
        end
        fnum=1;
        frequencyFeatures(fnum,i) = F_Frequency_Feature_Mean(frame, fs);                        fnum=fnum+1;
        frequencyFeatures(fnum,i) = F_Frequency_Feature_Median(frame, fs );                     fnum=fnum+1;
        frequencyFeatures(fnum,i) = F_Frequency_Feature_SNR(frame, fs);                         fnum=fnum+1;
        frequencyFeatures(fnum,i) = F_Frequency_Feature_PowerBandwidth(frame, fs);              fnum=fnum+1;
        frequencyFeatures(fnum,i) = F_Frequency_Feature_BandPower(frame, fs, freqrange);        fnum=fnum+1;
        frequencyFeatures(fnum,i) = F_Frequency_Feature_SpectralCentroid(frame, fs);            fnum=fnum+1;
        frequencyFeatures(fnum,i) = F_Frequency_Feature_SpectralEntropy(frame, subBlocks, fs);  fnum=fnum+1;
        frequencyFeatures(fnum,i) = F_Frequency_Feature_SpectralFlux(frame, framePrev, fs);     fnum=fnum+1;
        frequencyFeatures(fnum,i) = F_Frequency_Feature_SpectralRollOff(frame, param, fs);      fnum=fnum+1;
        frequencyFeatures(fnum,i) = F_Frequency_Feature_TotalHarmonicDistortion(frame, fs);     fnum=fnum+1;
        frequencyFeatures(fnum,i) = F_Frequency_Feature_OccupiedBandwidth(frame, fs);           fnum=fnum+1;
%         frequencyFeatures(fnum:fnum+orderedSpectrumFeatureNumber-1,...
%             i)                    = F_Frequency_Feature_OrderSpectrum(frame, fs, harmonicNumber);    fnum=fnum+orderedSpectrumFeatureNumber;
        frequencyFeatures(fnum:fnum+numberOfMFCCCoef-1,...
            i)                    = F_Frequency_Feature_MFCCs(frame, fs);                       fnum=fnum+numberOfMFCCCoef;
        
    else
        frequencyFeatures(:,i) = zeros(numberOfFeatures, 1);
    end
    
    currentPosition = currentPosition + step;
    framePrev = frame;
    frameFFTPrev = frameFFT;
end
%filter for spurious features
frequencyFeatures(numberOfFeatures, :) = medfilt1(frequencyFeatures(numberOfFeatures, :), 3);
