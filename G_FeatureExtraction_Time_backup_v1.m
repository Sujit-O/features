function [timeFeatures, featureNames] = G_FeatureExtraction_Time(signal, fs, win, step)

%Check if the signal is two channel
if (size(signal,2)>1)
    signal = mean(signal,2);
end

%convert the window and the step to its respective sample numbers
windowLength = round(win * fs);
step = round(step * fs);

%Initialize parameters for Features
subFrames = floor(5/100*windowLength); % 5 percent of the window
numLags           = 2; % for autocorrelation
orders            = 4; % number of orders for moments
bins              = 5; % bins for historgram
peakNumber        = 5; % for peak analysis
peakNumberEnvelop = 3; % peaks for envelop analysis
peakNumberGradient = 5;


%name of all the time domain features extracted
featureNames={'Time_Energy',... %TODO: explain about each features
    'Time_EnergyEntropy',...
    'Time_Mean',...
    'Time_Max',...
    'Time_Min',...
    'Time_Median',...
    'Time_Mode',...
    'Time_Peak2Peak',...
    'Time_Peak2RMS',...
    'Time_RiseTime',...
    'Time_RMS',...
    'Time_RootSumSquare',...
    'Time_Skewness',...
    'Time_SlewRate',...
    'Time_Std',...
    'Time_TachoRPM',...
    'Time_UnderShoot',...
    'Time_Variance',...
    'Time_ZeroCrossingRate',...
    'Time_DutyCycle',...
    'Time_FallTime',...
    'Time_Kurtosis'};

envelopFeatureNames={'Time_Envelop_MeanPks',...
    'Time_Envelop_meanLocsDiff',...
    'Time_Envelop_meanWidths',...
    'Time_Envelop_meanProminance',...
    'Time_Envelop_RMS',...
    'Time_Envelop_Variance',...
    'Time_Envelop_ZCR',...
    'Time_Envelop_Max',...
    'Time_Envelop_Mean',...
    'Time_Envelop_Min',...
    'Time_Envelop_Std',...
    'Time_Envelop_Skewness',...
    'Time_Envelop_Median',...
    'Time_Envelop_Kurtosis'};

gradientFeatureNames={'Time_Gradient_MeanPks',...
    'Time_Gradient_meanLocsDiff',...
    'Time_Gradient_meanWidths',...
    'Time_Gradient_meanProminance',...
    'Time_Gradient_RMS',...
    'Time_Gradient_Variance',...
    'Time_Gradient_ZCR',...
    'Time_Gradient_Max',...
    'Time_Gradient_Mean',...
    'Time_Gradient_Min',...
    'Time_Gradient_Std',...
    'Time_Gradient_Skewness',...
    'Time_Gradient_Median',...
    'Time_Gradient_Kurtosis'};


% these parameters are used in synchronizing the features
peakAnalysisFeatures = peakNumberEnvelop*4+4;
envelopAnalysisFeatures = length(envelopFeatureNames);
gradientAnalysisFeatures = length(gradientFeatureNames);


fname=cell(1,numLags);
for name_i=1:numLags
    fname{name_i}= strcat('Time_ACF_Lag',num2str(name_i));
end
%add ACF features
featureNames=[featureNames ,fname];

fname=cell(1,orders);
for name_i=1:orders
    fname{name_i}= strcat('Time_CentramMoment_Order',num2str(name_i));
end
%add central moment features
featureNames=[featureNames ,fname];


fname=cell(1,bins );
for name_i=1:bins
    fname{name_i}= strcat('Time_Hist_Bin',num2str(name_i));
end
%add histogram features
featureNames=[featureNames ,fname];

fname1=cell(1,peakNumber+1);
fname2=cell(1,peakNumber+1);
fname3=cell(1,peakNumber+1);
fname4=cell(1,peakNumber+1);


for name_j=1:peakNumber
    fname1{name_j}= strcat('Time_PeakAmp',num2str(name_j));
    fname2{name_j}= strcat('Time_PeakLocsDiff',num2str(name_j));
    fname3{name_j}= strcat('Time_PeakWidth',num2str(name_j));
    fname4{name_j}= strcat('Time_PeakProminance',num2str(name_j));
end

fname1{end}='Time_PeakAmp_Mean';
fname2{end}='Time_PeakLocsDiff_Mean';
fname3{end}='Time_PeakWidth_Mean';
fname4{end}='Time_PeakProminance_Mean';

%add peakanalysis features
featureNames=[featureNames ,fname1, fname2, fname3, fname4];

%add Envelopanalysis features
featureNames=[featureNames ,envelopFeatureNames];

%add Gradient Analysis features
featureNames=[featureNames , gradientFeatureNames ];


numberOfFeatures = length(featureNames); % total time features

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
        
        timeFeatures(1,i)  = F_Time_Feature_Energy(frame);
        timeFeatures(2,i)  = F_Time_Feature_Energy_Entropy(frame, subFrames);
        timeFeatures(3,i)  = F_Time_Feature_Mean(frame);
        timeFeatures(4,i)  = F_Time_Feature_Max(frame);
        timeFeatures(5,i)  = F_Time_Feature_Min(frame);
        timeFeatures(6,i)  = F_Time_Feature_Median(frame);
        timeFeatures(7,i)  = F_Time_Feature_Mode(frame);
        timeFeatures(8,i)  = F_Time_Feature_Peak2Peak(frame);
        timeFeatures(9,i)  = F_Time_Feature_Peak2RMS(frame);
        timeFeatures(10,i) = F_Time_Feature_RiseTime(signal, fs);
        timeFeatures(11,i) = F_Time_Feature_RMS(frame);
        timeFeatures(12,i) = F_Time_Feature_RootSumOfSquares(frame);
        timeFeatures(13,i) = F_Time_Feature_Skewness(frame);
        timeFeatures(14,i) = F_Time_Feature_SlewRate(signal, fs );
        timeFeatures(15,i) = F_Time_Feature_Std(frame);
        timeFeatures(16,i) = F_Time_Feature_TachoRPM(signal, fs);
        timeFeatures(17,i) = F_Time_Feature_UnderShoot(signal, fs );
        timeFeatures(18,i) = F_Time_Feature_Variance(frame);
        timeFeatures(19,i) = F_Time_Feature_ZCR(frame);
        timeFeatures(20,i) = F_Time_Feature_DutyCycle(signal, fs );
        timeFeatures(21,i) = F_Time_Feature_FallTime(signal, fs );
        timeFeatures(22,i) = F_Time_Feature_Kurtosis(frame);
        
        timeFeatures(22+numLags,...
            i)             = F_Time_Feature_AutoCorrelation(frame,numLags);
        
        timeFeatures(22+numLags+orders,...
            i)             = F_Time_Feature_CentralMoment(frame,orders);
        
        timeFeatures(22+numLags+orders+bins,...
            i)             = F_Time_Feature_Histogram(frame,bins);
        
        timeFeatures(22+numLags+orders+bins+peakAnalysisFeatures,...
            i)             = F_Time_Feature_PeakAnalysis(frame,peakNumber);
        
        timeFeatures(22+...
            numLags+orders+bins+peakAnalysisFeatures+...
            envelopAnalysisFeatures,...
            i)             = F_Time_Feature_EnvelopAnalysis(frame,peakNumberEnvelop);
        
        timeFeatures(22+...
            numLags+orders+bins+peakAnalysisFeatures+...
            envelopAnalysisFeatures+gradientAnalysisFeatures,...
            i)             =F_Time_Feature_GradientAnalysis(frame,peakNumberGradient);
        
        
    else
        timeFeatures(:,i) = zeros(numberOfFeatures, 1);
    end
    
    currentPosition = currentPosition + step;
    framePrev = frame;
end
%filter for spurious features
timeFeatures(35, :) = medfilt1(timeFeatures(numberOfFeatures, :), 3);
