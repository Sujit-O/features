function  [featureNames,...
    numberOfFeatures,...
    orderedSpectrumFeatureNumber] = DT_frequencyFNames(harmonicNumber,numberOfMFCCCoef)


%name of all the Frequency domain features extracted
featureNames={'Frequency_Mean',... %TODO: explain about each features
    'Frequency_Median',...
    'Frequency_SNR',...
    'Frequency_PowerBW',...
    'Frequency_BandPower',...
    'Frequency_SpectralCentroid',...
    'Frequency_SpectralEntropy',...
    'Frequency_SpectralFlux',...
    'Frequency_SpectralRollOff',...
    'Frequency_THD',...
    'Frequency_OccupiedBW'};



fname1=cell(1,harmonicNumber);
fname2=cell(1,harmonicNumber-1);
fname3=cell(1,harmonicNumber);
fname4=cell(1,harmonicNumber);

for name_j=1:harmonicNumber
    fname1{name_j}= strcat('Frequency_OrderedSpecPeakAmpHarmonic',num2str(name_j));
    fname3{name_j}= strcat('Frequency_OrderedSpecPeakWidthHarmonic',num2str(name_j));
    fname4{name_j}= strcat('Frequency_OrderedSpecPeakProminanceHarmonic',num2str(name_j));
    if(name_j==harmonicNumber)
        continue;
    end
    fname2{name_j}= strcat('Frequency_OrderedSpecPeakLocsDiffHarmonic',num2str(name_j));
    
end

orderedSpectrumFeatureNames=[fname1, fname2, fname3, fname4];
orderedSpectrumFeatureNumber = length(orderedSpectrumFeatureNames);


%add ordered harmonics features
% featureNames=[featureNames , orderedSpectrumFeatureNames];

fname=cell(1,numberOfMFCCCoef);
for name_i=1:numberOfMFCCCoef
    fname{name_i}= strcat('Frequency_MFCC_Coeff',num2str(name_i));
end
%add ACF features
featureNames=[featureNames ,fname];

% dutyCycleFeatureNames={'Frequency_DutyCycle_Max',...
%     'Frequency_DutyCycle_Min',...
%     'Frequency_DutyCycle_Mode',...
%     'Frequency_DutyCycle_Mean',...
%     'Frequency_DutyCycle_Std',...
%     'Frequency_DutyCycle_MaxsubMin'
%     };
%
%
% dutyCycleFeatureNumber = length(dutyCycleFeatureNames);
%
%
%
%
% %add DutyCycle features
% featureNames=[featureNames ,dutyCycleFeatureNames];



% fname=cell(1,numLags);
% for name_i=1:numLags
%     fname{name_i}= strcat('Frequency_ACF_Lag',num2str(name_i));
% end
% %add ACF features
% featureNames=[featureNames ,fname];
%
%




numberOfFeatures = length(featureNames); % total time features

end
