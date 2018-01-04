function  [featureNames,...
    numberOfFeatures,numberofFFTPeakFeatures] = G_FeatureExtraction_Frequency_CWTStastistics_FeatureNames(FFTPeakNumber)


%name of all the Frequency domain features extracted
featureNames={'Frequency_CWT_Max',... %TODO: explain about each features
    'Frequency_CWT_Min',...
    'Frequency_CWT_Mean',...
    'Frequency_CWT_Median',...
    'Frequency_CWT_Mode',...
    'Frequency_CWT_Std',...
    'Frequency_CWT_Var',...
    'Frequency_CWT_MaxdiffMin',...
    'Frequency_CWT_Skewness',...
    'Frequency_CWT_Kurtosis',...
    'Frequency_CWT_Moment',...
    'Frequency_CWT_Entropy',...
    'Frequency_CWT_Peak2Peak',...
    'Frequency_CWT_Peak2RMS',...
    'Frequency_CWT_SpectralFlux'
     };

fname1=cell(1,FFTPeakNumber+1);
fname2=cell(1,FFTPeakNumber);
fname3=cell(1,FFTPeakNumber+1);
fname4=cell(1,FFTPeakNumber+1);

for name_j=1:FFTPeakNumber
    fname1{name_j}= strcat('Frequency_CWT_Peak',num2str(name_j));
    fname3{name_j}= strcat('Frequency_CWT_PeakWidth',num2str(name_j));
    fname4{name_j}= strcat('Frequency_CWT_PeakProminance',num2str(name_j));
    if(name_j==FFTPeakNumber)
        continue;
    end
    fname2{name_j}= strcat('Frequency_CWT_PeakLocsDiff',num2str(name_j));
    
end

fname1{end}='Frequency_CWT_Peak_Mean';
fname2{end}='Frequency_CWT_PeakLocsDiff_Mean';
fname3{end}='Frequency_CWT_PeakWidth_Mean';
fname4{end}='Frequency_CWT_PeakProminance_Mean';

frequencyCWTPeakFeatureNames=[fname1, fname2, fname3, fname4];
numberofFFTPeakFeatures = length(frequencyCWTPeakFeatureNames);


%add CWT Peak Analysis features
featureNames=[featureNames , frequencyCWTPeakFeatureNames];

numberOfFeatures = length(featureNames); % total time features

end
