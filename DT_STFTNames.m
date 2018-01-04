function  [featureNames,...
    numberOfFeatures,numberofFFTPeakFeatures] = DT_STFTNames(FFTPeakNumber)


%name of all the Frequency domain features extracted
featureNames={'Frequency_STFT_Max',... %TODO: explain about each features
    'Frequency_STFT_Min',...
    'Frequency_STFT_Mean',...
    'Frequency_STFT_Median',...
    'Frequency_STFT_Mode',...
    'Frequency_STFT_Std',...
    'Frequency_STFT_Var',...
    'Frequency_STFT_MaxdiffMin',...
    'Frequency_STFT_Skewness',...
    'Frequency_STFT_Kurtosis',...
    'Frequency_STFT_Moment',...
    'Frequency_STFT_Entropy',...
    'Frequency_STFT_Peak2Peak',...
    'Frequency_STFT_Peak2RMS',...
    'Frequency_STFT_SpectralFlux'
     };



fname1=cell(1,FFTPeakNumber+1);
fname2=cell(1,FFTPeakNumber);
fname3=cell(1,FFTPeakNumber+1);
fname4=cell(1,FFTPeakNumber+1);

for name_j=1:FFTPeakNumber
    fname1{name_j}= strcat('Frequency_STFT_Peak',num2str(name_j));
    fname3{name_j}= strcat('Frequency_STFT_PeakWidth',num2str(name_j));
    fname4{name_j}= strcat('Frequency_STFT_PeakProminance',num2str(name_j));
    if(name_j==FFTPeakNumber)
        continue;
    end
    fname2{name_j}= strcat('Frequency_STFT_PeakLocsDiff',num2str(name_j));
    
end

fname1{end}='Frequency_STFT_Peak_Mean';
fname2{end}='Frequency_STFT_PeakLocsDiff_Mean';
fname3{end}='Frequency_STFT_PeakWidth_Mean';
fname4{end}='Frequency_STFT_PeakProminance_Mean';

frequencySTFTPeakFeatureNames=[fname1, fname2, fname3, fname4];
numberofFFTPeakFeatures = length(frequencySTFTPeakFeatureNames);


%add STFT Peak Analysis features
featureNames=[featureNames , frequencySTFTPeakFeatureNames];

numberOfFeatures = length(featureNames); % total time features

end
