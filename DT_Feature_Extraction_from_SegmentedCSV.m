function []= DT_Feature_Extraction_from_SegmentedCSV(folderName)
%% Specifying the Parent Folder and Initialize variables for Folders
% From the GoogleDrive folder in D-drive
% clear
% clc
% foldeName=strcat('UM3_Corner_Wall_',num2str(10),'p');
% The folder containing all the segmented data
originFolder = strcat('D:\GDrive\DT_Data\DAQ_Auto_SegmentedData');

% Folder to save the features
destinationFolder =strcat('D:\GDrive\DT_Data\DAQ_Auto_Features');

%DaQ sampling rate is 20 kHz
fs=20e3;

%Check for the total channels in the origin folder
totalChannelFolderst=dir(strcat(originFolder,'\',folderName));
%exclude unncessary files
%TODO: Make it automatic later!
totalChannelFolders=totalChannelFolderst(3:27);

%% Initialize Global Variables for Feature Extraction
%Time step used by all the feature extraction functions
universalStep=0.1;
universalOverlap=0.5;

%% Initialization Variables for Time Domain Features
Time_numLags           = 2;     % for autocorrelation
Time_orders            = 4;     % number of orders for moments
Time_bins              = 5;     % bins for historgram
Time_peakNumber        = 5;     % for peak analysis
Time_peakNumberEnvelop = 3;     % peaks for envelop analysis
Time_peakNumberGradient = 5;    % peaks for gradient analysis
Time_Overlap=universalOverlap;  % time overlap windows
Time_step= universalStep;       % time step size
Time_win=Time_step./(1-Time_Overlap); %Determine window based on overlap

%Get the feature names

timeFeatureFileName='timeFeatures.csv';
% timeFeatureLabelFileName='timeLabel.csv';

%% Initialization for Frequency Domain Features
Frequency_Overlap=universalOverlap;
Frequency_step= universalStep;
Frequency_win=Frequency_step./(1-Frequency_Overlap); %Determine window based on overlap
Frequency_freqrange= [40 5000];
Frequency_param = 0.9;
Frequency_harmonicNumber =3;
Frequency_numberOfMFCCCoef=13;

frequencyFeatureFileName='frequencyFeatures.csv';
% frequencyFeatureLabelFileName='frequencyLabel.csv';

%% Initialization for STFT Stastistics Features
STFT_Overlap=universalOverlap;
STFT_step= universalStep;
STFT_win=STFT_step./(1-STFT_Overlap); %Determine window based on overlap
STFT_FFTPeakNumber=10;

frequencySTFTStastisticsFeatureFileName='STFTFeatures.csv';
% frequencySTFTStastisticsFeatureLabelFileName='STFTLabel.csv';

%% Initialization for CWT Stastistics Features
CWT_Overlap=universalOverlap;
CWT_step= universalStep;
CWT_win=CWT_step./(1-CWT_Overlap); %Determine window based on overlap
CWT_FFTPeakNumber=10;

frequencyCWTStastisticsFeatureFileName='CWTFeatures.csv';
% frequencyCWTStastisticsFeatureLabelFileName='CWTFeaturesLabel.csv';
%% Create Folder to Store Feature Data
creatFolder(destinationFolder,folderName);


%% Start Reading and Extracting the Features
fprintf('\n3D Object Folder: %s',folderName);
for channel_i = 1:size(totalChannelFolders,1)
    segmentChannelFolders =dir(strcat(originFolder,...
        '\',folderName,'\',totalChannelFolders(channel_i).name,...
        '\segments*'));
    
    %Create Folder for Channel
    creatFolder(strcat(destinationFolder,...
        '\',folderName),totalChannelFolders(channel_i).name);
    
    fprintf('\nChannel Name: %s',totalChannelFolders(channel_i).name);
    for segmentFolder_i=1:size(segmentChannelFolders,1)
        
        segmentFiles =dir(strcat(originFolder,...
            '\',folderName,'\',totalChannelFolders(channel_i).name,...
            '\',segmentChannelFolders(segmentFolder_i).name,...
            '\segment*.csv'));
        
        %Create Folder for Segment
        creatFolder(strcat(destinationFolder,...
            '\',folderName,'\',totalChannelFolders(channel_i).name),...
            segmentChannelFolders(segmentFolder_i).name);
        
        fprintf('\nSegment Name: %s',...
            segmentChannelFolders(segmentFolder_i).name);
        
        for segment_i=1:size(segmentFiles,1)
            
            fileName=strcat(originFolder,'\',...
                folderName,'\',totalChannelFolders(channel_i).name,...
                '\',segmentChannelFolders(segmentFolder_i).name,...
                '\',segmentFiles(segment_i).name);
            
            
            %Create Folder for Segment
            creatFolder(strcat(destinationFolder,...
                '\',folderName,'\',totalChannelFolders(channel_i).name,'\',...
                segmentChannelFolders(segmentFolder_i).name),...
                segmentFiles(segment_i).name(1:end-4));
            
            fprintf('\nSegment Number: %s',segmentFiles(segment_i).name);
            
            %% Store Time Feature headers in a CSV File
            fileNameFullT=strcat(destinationFolder,...
                '\',folderName,'\',totalChannelFolders(channel_i).name,...
                '\',segmentChannelFolders(segmentFolder_i).name,...
                '\',segmentFiles(segment_i).name(1:end-4),'\',...
                timeFeatureFileName);
            
            featureNames= DT_timeFeatures(Time_numLags,...
                Time_orders,Time_bins,Time_peakNumber);
            
            DT_saveFeaturesI(fileNameFullT, featureNames);
            
            %% Store Frequency Feature headers in a CSV File
            
            fileNameFullF=strcat(destinationFolder,...
                '\',folderName,'\',totalChannelFolders(channel_i).name,...
                '\',segmentChannelFolders(segmentFolder_i).name,...
                '\',segmentFiles(segment_i).name(1:end-4),'\',...
                frequencyFeatureFileName);
            
            featureNames= DT_frequencyFNames(Frequency_harmonicNumber,...
                Frequency_numberOfMFCCCoef);
            DT_saveFeaturesI(fileNameFullF, featureNames);
            
            %% STFT Feature headers in a CSV File
            fileNameFullS=strcat(destinationFolder,...
                '\',folderName,'\',totalChannelFolders(channel_i).name,...
                '\',segmentChannelFolders(segmentFolder_i).name,...
                '\',segmentFiles(segment_i).name(1:end-4),'\',...
                frequencySTFTStastisticsFeatureFileName);
            
            featureNames= DT_STFTNames(STFT_FFTPeakNumber);
            DT_saveFeaturesI(fileNameFullS, featureNames);
            
            %% CWT Feature headers in a CSV File
            fileNameFullC=strcat(destinationFolder,...
                '\',folderName,'\',totalChannelFolders(channel_i).name,...
                '\',segmentChannelFolders(segmentFolder_i).name,...
                '\',segmentFiles(segment_i).name(1:end-4),'\',...
                frequencyCWTStastisticsFeatureFileName);
            
            featureNames= DT_CWTNames(CWT_FFTPeakNumber);
            
            DT_saveFeaturesI(fileNameFullC, featureNames);
            
            %% Read the data and extract features
            %read the signals
            data1=csvread(fileName);
            
            %% Divide data into 5 parts to handle memory issues
            for kk=1:floor(length(data1)/4):(length(data1)-floor(length(data1)/4))
                data=data1(kk:(kk+floor(length(data1)/4)-1));
                %% Time Features Extraction
                features = DT_FeatureExtraction_Time(data, fs,...
                    Time_win, Time_step,Time_numLags,Time_orders,...
                    Time_bins,Time_peakNumber,Time_peakNumberEnvelop,...
                    Time_peakNumberGradient);
                features=features';
                
                dlmwrite(fileNameFullT,features,'-append','delimiter',',');
                
                %% frequency Feature Extraction
                
                features = DT_FeatureExtraction_Frequency(data,...
                    fs, Frequency_win, Frequency_step,...
                    Frequency_freqrange,Frequency_harmonicNumber,...
                    Frequency_numberOfMFCCCoef,Frequency_param);
                features=features';
                
                dlmwrite(fileNameFullF,features,'-append','delimiter',',');
                
                %% STFT Feature Extraction
                features = DT_STFTStatistics(data, fs, STFT_win,...
                    STFT_step, STFT_FFTPeakNumber );
                features=features';
                dlmwrite(fileNameFullS,features,'-append','delimiter',',');
                
                %% CWT Features Extraction
                features = DT_CWTStatistics(data, fs, CWT_win,...
                    CWT_step, CWT_FFTPeakNumber);
                features=features';
                dlmwrite(fileNameFullC,features,'-append','delimiter',',');
            end
            
            
        end
    end
end
end


%% Create Folders for storing the Feature
function []=creatFolder (destination,foldername)
if (exist(fullfile(destination,foldername),'dir')==0)
    mkdir (destination, foldername);
end
end


