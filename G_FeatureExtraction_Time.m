function timeFeatures = G_FeatureExtraction_Time(signal, fs,...
    win, step,numLags,orders,bins,peakNumber,peakNumberEnvelop,peakNumberGradient)

%Check if the signal is two channel
if (size(signal,2)>1)
    signal = mean(signal,2);
end

%convert the window and the step to its respective sample numbers
windowLength = round(win * fs);
step = round(step * fs);

%Initialize parameters for Features
subFrames = floor(5/100*windowLength); % 5 percent of the window
% numLags           = 2; % for autocorrelation
% orders            = 4; % number of orders for moments
% bins              = 5; % bins for historgram
% peakNumber        = 5; % for peak analysis
% peakNumberEnvelop = 3; % peaks for envelop analysis
% peakNumberGradient = 5;



[featureNames,...
    numberOfFeatures,...
    envelopFeatureNumber,...
    gradientFeatureNumber,...
    tachoRPMFeatureNumber,...
    slewRateFeatureNumber,...
    riseTimeFeatureNumber,...
    underShootFeatureNumber,...
    dutyCycleFeatureNumber,...
    peakAnalysisFeatureNumber,...
    fallTimeFeatureNumber] = G_FeatureExtraction_Time_FeatureNames(numLags,orders,bins,peakNumber);


currentPosition = 1; % for tracking signal
L = length(signal);

numberOfFrames = floor((L-windowLength)/step) + 1; %total number of frames

timeFeatures = zeros(numberOfFeatures, numberOfFrames);
Ham = window(@hamming, windowLength); %Hamming window to cut of the end portions


for i=1:numberOfFrames
    %current frame
    frame  = signal(currentPosition:currentPosition+windowLength-1);
    frame  = frame .* Ham;
    
    if (sum(abs(frame))>eps) %check if there is signal
        
        if (i==1)
            framePrev = frame;
        end
        fnum=1;
        timeFeatures(fnum,i) = F_Time_Feature_Energy(frame);                            fnum=fnum+1;
        timeFeatures(fnum,i) = F_Time_Feature_Energy_Entropy(frame, subFrames);         fnum=fnum+1;
        timeFeatures(fnum,i) = F_Time_Feature_Mean(frame);                              fnum=fnum+1;
        timeFeatures(fnum,i) = F_Time_Feature_Max(frame);                               fnum=fnum+1;
        timeFeatures(fnum,i) = F_Time_Feature_Min(frame);                               fnum=fnum+1;
        timeFeatures(fnum,i) = F_Time_Feature_Median(frame);                            fnum=fnum+1;
        timeFeatures(fnum,i) = F_Time_Feature_Mode(frame);                              fnum=fnum+1;
        timeFeatures(fnum,i) = F_Time_Feature_Peak2Peak(frame);                         fnum=fnum+1;
        timeFeatures(fnum,i) = F_Time_Feature_Peak2RMS(frame);                          fnum=fnum+1;
        timeFeatures(fnum,i) = F_Time_Feature_RMS(frame);                               fnum=fnum+1;
        timeFeatures(fnum,i) = F_Time_Feature_RootSumOfSquares(frame);                  fnum=fnum+1;
        timeFeatures(fnum,i) = F_Time_Feature_Skewness(frame);                          fnum=fnum+1;
        timeFeatures(fnum,i) = F_Time_Feature_Std(frame);                               fnum=fnum+1;
        timeFeatures(fnum,i) = F_Time_Feature_Variance(frame);                          fnum=fnum+1;
        timeFeatures(fnum,i) = F_Time_Feature_ZCR(frame);                               fnum=fnum+1;
        timeFeatures(fnum,i) = F_Time_Feature_Kurtosis(frame);                          fnum=fnum+1;
        
        timeFeatures(fnum:fnum+dutyCycleFeatureNumber-1,...
            i)               = F_Time_Feature_DutyCycle(frame, fs );                   fnum=fnum+dutyCycleFeatureNumber;
        
        timeFeatures(fnum:fnum+underShootFeatureNumber -1,...
            i)               = F_Time_Feature_UnderShoot(frame, fs );                  fnum=fnum+underShootFeatureNumber;
%         timeFeatures(fnum:fnum+tachoRPMFeatureNumber -1,...
%             i)               = F_Time_Feature_TachoRPM(frame, fs);                     fnum=fnum+tachoRPMFeatureNumber;
        
        timeFeatures(fnum:fnum+slewRateFeatureNumber-1,...
            i) = F_Time_Feature_SlewRate(frame, fs);                                   fnum=fnum+slewRateFeatureNumber;
        timeFeatures(fnum:fnum+riseTimeFeatureNumber-1,...
            i)               = F_Time_Feature_RiseTime(frame, fs);                     fnum=fnum+riseTimeFeatureNumber;
        timeFeatures(fnum:fnum+fallTimeFeatureNumber-1,...
            i)               = F_Time_Feature_FallTime(frame, fs );                    fnum=fnum+fallTimeFeatureNumber;
        timeFeatures(fnum:fnum+numLags-1,...
            i)               = F_Time_Feature_AutoCorrelation(frame,numLags);           fnum=fnum+numLags;
        timeFeatures(fnum:fnum+orders-1,...
            i)               = F_Time_Feature_CentralMoment(frame,orders);              fnum=fnum+orders;
        timeFeatures(fnum:fnum+bins-1,...
            i)               = F_Time_Feature_Histogram(frame,bins);                    fnum=fnum+bins;
        timeFeatures(fnum:fnum+peakAnalysisFeatureNumber-1,...
            i)               = F_Time_Feature_PeakAnalysis(frame,peakNumber);           fnum=fnum+peakAnalysisFeatureNumber;
%         timeFeatures(fnum:fnum+envelopFeatureNumber-1,...
%             i)               = F_Time_Feature_EnvelopAnalysis(frame,peakNumberEnvelop); fnum=fnum+envelopFeatureNumber;
%         timeFeatures(fnum:fnum+gradientFeatureNumber-1,...
%             i)               = F_Time_Feature_GradientAnalysis(frame,peakNumberGradient);
        
        
    else
        timeFeatures(:,i) = zeros(numberOfFeatures, 1);
    end
    
    currentPosition = currentPosition + step;
    framePrev = frame;
end
%filter for spurious features
timeFeatures(numberOfFeatures, :) = medfilt1(timeFeatures(numberOfFeatures, :), 3);
