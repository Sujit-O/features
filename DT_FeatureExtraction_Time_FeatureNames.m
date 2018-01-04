function  [featureNames,...
    numberOfFeatures,...
    envelopFeatureNumber,...
    gradientFeatureNumber,...
    tachoRPMFeatureNumber,...
    slewRateFeatureNumber,...
    riseTimeFeatureNumber,...
    underShootFeatureNumber,...
    dutyCycleFeatureNumber,...
    peakAnalysisFeatureNumber,...
    fallTimeFeatureNumber] = DT_extractTimeFeatures(numLags,orders,bins,peakNumber)


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
    'Time_RMS',...
    'Time_RootSumSquare',...
    'Time_Skewness',...
    'Time_Std',...
    'Time_Variance',...
    'Time_ZeroCrossingRate',...
    'Time_Kurtosis'};

dutyCycleFeatureNames={'Time_DutyCycle_Max',...
    'Time_DutyCycle_Min',...
    'Time_DutyCycle_Mode',...
    'Time_DutyCycle_Mean',...
    'Time_DutyCycle_Std',...
    'Time_DutyCycle_MaxsubMin'
    };

underShootFeatureNames={'Time_UnderShoot_Max',...
    'Time_UnderShoot_Min',...
    'Time_UnderShoot_Mode',...
    'Time_UnderShoot_Mean',...
    'Time_UnderShoot_Std',...
    'Time_UnderShoot_MaxsubMin'
    };

tachoRPMFeatureNames={'Time_TachoRPM_Max',...
    'Time_TachoRPM_Min',...
    'Time_TachoRPM_Mode',...
    'Time_TachoRPM_Mean',...
    'Time_TachoRPM_Std',...
    'Time_TachoRPM_MaxsubMin'
    };

slewRateFeatureNames={'Time_SlewRate_Max',...
    'Time_SlewRate_Min',...
    'Time_SlewRate_Mode',...
    'Time_SlewRate_Mean',...
    'Time_SlewRate_Std',...
    'Time_SlewRate_MaxsubMin',...
    'Time_SlewRate_MeanPks',...
    'Time_SlewRate_MeanDiffLocs',...
    'Time_SlewRate_MeanWidths',...
    'Time_SlewRate_MeanProms'};


riseTimeFeatureNames={'Time_RiseTime_Max',...
    'Time_RiseTime_Min',...
    'Time_RiseTime_Mode',...
    'Time_RiseTime_Mean',...
    'Time_RiseTime_Std',...
    'Time_RiseTime_MaxsubMin'
    };

fallTimeFeatureNames={'Time_FallTime_Max',...
    'Time_FallTime_Min',...
    'Time_FallTime_Mode',...
    'Time_FallTime_Mean',...
    'Time_FallTime_Std',...
    'Time_FallTime_MaxsubMin'
    };

envelopFeatureNames={'Time_Envelop_MeanPks',...
    'Time_Envelop_meanLocsDiff',...
    'Time_Envelop_meanWidths',...
    'Time_Envelop_meanProminance',...
    'Time_Envelop_RMS',...
    'Time_Envelop_Variance',...
    'Time_Envelop_Peak2Peak',...
    'Time_Envelop_Max',...
    'Time_Envelop_Mean',...
    'Time_Envelop_Min',...
    'Time_Envelop_Peak2RMS',...
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
    'Time_Gradient_Peal2Peak',...
    'Time_Gradient_Max',...
    'Time_Gradient_Mean',...
    'Time_Gradient_Min',...
    'Time_Gradient_Peal2RMS',...
    'Time_Gradient_Std',...
    'Time_Gradient_Skewness',...
    'Time_Gradient_Median',...
    'Time_Gradient_Kurtosis'};


dutyCycleFeatureNumber = length(dutyCycleFeatureNames);
underShootFeatureNumber = length(underShootFeatureNames);
tachoRPMFeatureNumber = length(tachoRPMFeatureNames);
slewRateFeatureNumber = length(slewRateFeatureNames);
riseTimeFeatureNumber = length(riseTimeFeatureNames);
fallTimeFeatureNumber = length(fallTimeFeatureNames);
envelopFeatureNumber = length(envelopFeatureNames);
gradientFeatureNumber = length(gradientFeatureNames);

%add DutyCycle features
featureNames=[featureNames ,dutyCycleFeatureNames];

%add Undershoot features
featureNames=[featureNames ,underShootFeatureNames];

%add tachoRPM features
% featureNames=[featureNames ,tachoRPMFeatureNames];

%add RiseTime features
featureNames=[featureNames ,slewRateFeatureNames];

%add RiseTime features
featureNames=[featureNames ,riseTimeFeatureNames];

%add FallTime features
featureNames=[featureNames , fallTimeFeatureNames];

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
fname2=cell(1,peakNumber);
fname3=cell(1,peakNumber+1);
fname4=cell(1,peakNumber+1);


for name_j=1:peakNumber
    fname1{name_j}= strcat('Time_PeakAmp',num2str(name_j));
     fname3{name_j}= strcat('Time_PeakWidth',num2str(name_j));
    fname4{name_j}= strcat('Time_PeakProminance',num2str(name_j));
    if(name_j==peakNumber)
        continue;
    end
    fname2{name_j}= strcat('Time_PeakLocsDiff',num2str(name_j));
   
end

fname1{end}='Time_PeakAmp_Mean';
fname2{end}='Time_PeakLocsDiff_Mean';
fname3{end}='Time_PeakWidth_Mean';
fname4{end}='Time_PeakProminance_Mean';

peakAnalysisFeatureNames=[fname1, fname2, fname3, fname4];
peakAnalysisFeatureNumber = length(peakAnalysisFeatureNames);


%add peakanalysis features
featureNames=[featureNames , peakAnalysisFeatureNames];

%add Envelopanalysis features
featureNames=[featureNames ,envelopFeatureNames];

%add Gradient Analysis features
featureNames=[featureNames , gradientFeatureNames ];

numberOfFeatures = length(featureNames); % total time features

end
