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
universalStep=0.05;
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
timeFeatureLabelFileName='timeLabel.csv';

%% Initialization for Frequency Domain Features
Frequency_Overlap=universalOverlap;
Frequency_step= universalStep;
Frequency_win=Frequency_step./(1-Frequency_Overlap); %Determine window based on overlap
Frequency_freqrange= [40 5000];
Frequency_param = 0.9;
Frequency_harmonicNumber =3;
Frequency_numberOfMFCCCoef=13;

frequencyFeatureFileName='frequencyFeatures.csv';
frequencyFeatureLabelFileName='frequencyLabel.csv';

%% Initialization for STFT Stastistics Features
STFT_Overlap=universalOverlap;
STFT_step= universalStep;
STFT_win=STFT_step./(1-STFT_Overlap); %Determine window based on overlap
STFT_FFTPeakNumber=10;

frequencySTFTStastisticsFeatureFileName='STFTFeatures.csv';
frequencySTFTStastisticsFeatureLabelFileName='STFTLabel.csv';

%% Initialization for CWT Stastistics Features
CWT_Overlap=universalOverlap;
CWT_step= universalStep;
CWT_win=CWT_step./(1-CWT_Overlap); %Determine window based on overlap
CWT_FFTPeakNumber=10;

frequencyCWTStastisticsFeatureFileName='CWTFeatures.csv';
frequencyCWTStastisticsFeatureLabelFileName='CWTFeaturesLabel.csv';
%% Create Folder to Store Feature Data
creatFolder(destinationFolder,folderName);


%% Start Reading and Extracting the Features
fprintf('\n3D Object Folder: %s',folderName);
for channel_i = 1:1%size(totalChannelFolders,1)
    segmentChannelFolders =dir(strcat(originFolder,...
        '\',folderName,'\',totalChannelFolders(channel_i).name,...
        '\segments*'));
    
    %Create Folder for Channel
    creatFolder(strcat(destinationFolder,...
        '\',folderName),totalChannelFolders(channel_i).name);
    
    fprintf('\nChannel Name: %s',totalChannelFolders(channel_i).name);
    for segmentFolder_i=2:2%1:size(segmentChannelFolders,1)
        
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
        
        for segment_i=1:1%size(segmentFiles,1)
            
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
            
            %read the signals
            data=csvread(fileName);
            
            %% Extract and store Features
            %timeFeatures
            fileNameFull=strcat(destinationFolder,...
                '\',folderName,'\',totalChannelFolders(channel_i).name,...
                '\',segmentChannelFolders(segmentFolder_i).name,...
                '\',segmentFiles(segment_i).name(1:end-4),'\',...
                timeFeatureFileName);
            
            labelNameFull=strcat(destinationFolder,...
                '\',folderName,'\',totalChannelFolders(channel_i).name,...
                '\',segmentChannelFolders(segmentFolder_i).name,...
                '\',segmentFiles(segment_i).name(1:end-4),'\',...
                timeFeatureLabelFileName);
            
            extractFeatures_Time (fileNameFull,labelNameFull, ...
                data,fs,Time_win, Time_step,Time_numLags,...
                Time_orders,Time_bins,Time_peakNumber,...
                Time_peakNumberEnvelop,Time_peakNumberGradient);
            
            
            %frequency Features
            fileNameFull=strcat(destinationFolder,...
                '\',folderName,'\',totalChannelFolders(channel_i).name,...
                '\',segmentChannelFolders(segmentFolder_i).name,...
                '\',segmentFiles(segment_i).name(1:end-4),'\',...
                frequencyFeatureFileName);
            
            labelNameFull=strcat(destinationFolder,...
                '\',folderName,'\',totalChannelFolders(channel_i).name,...
                '\',segmentChannelFolders(segmentFolder_i).name,...
                '\',segmentFiles(segment_i).name(1:end-4),'\',...
                frequencyFeatureLabelFileName);
            
            extractFeatures_frequency (fileNameFull,labelNameFull, ...
                data, fs, Frequency_win,...
                Frequency_step, Frequency_freqrange,...
                Frequency_harmonicNumber,Frequency_numberOfMFCCCoef,...
                Frequency_param);
            
            
            %STFT Features
            fileNameFull=strcat(destinationFolder,...
                '\',folderName,'\',totalChannelFolders(channel_i).name,...
                '\',segmentChannelFolders(segmentFolder_i).name,...
                '\',segmentFiles(segment_i).name(1:end-4),'\',...
                frequencySTFTStastisticsFeatureFileName);
            
            labelNameFull=strcat(destinationFolder,...
                '\',folderName,'\',totalChannelFolders(channel_i).name,...
                '\',segmentChannelFolders(segmentFolder_i).name,...
                '\',segmentFiles(segment_i).name(1:end-4),'\',...
                frequencySTFTStastisticsFeatureLabelFileName);
            
            extractFeatures_STFT (fileNameFull,labelNameFull, ...
                data, fs, STFT_win, STFT_step, STFT_FFTPeakNumber);
            
            
            %CWT Features
            fileNameFull=strcat(destinationFolder,...
                '\',folderName,'\',totalChannelFolders(channel_i).name,...
                '\',segmentChannelFolders(segmentFolder_i).name,...
                '\',segmentFiles(segment_i).name(1:end-4),'\',...
                frequencyCWTStastisticsFeatureFileName);
            
            labelNameFull=strcat(destinationFolder,...
                '\',folderName,'\',totalChannelFolders(channel_i).name,...
                '\',segmentChannelFolders(segmentFolder_i).name,...
                '\',segmentFiles(segment_i).name(1:end-4),'\',...
                frequencyCWTStastisticsFeatureLabelFileName);
            
            extractFeatures_CWT(fileNameFull,labelNameFull, ...
                data, fs, CWT_win, CWT_step, CWT_FFTPeakNumber);
            
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


function []=extractFeatures_Time (fileNameFull,labelNameFull, data,...
    fs,Time_win, Time_step,Time_numLags,Time_orders,...
    Time_bins,Time_peakNumber,Time_peakNumberEnvelop,...
    Time_peakNumberGradient)


featureNames= DT_timeFeatures(Time_numLags,...
    Time_orders,Time_bins,Time_peakNumber);

%TODO: Extract all the features for this csv file
features = DT_FeatureExtraction_Time(data, fs,...
    Time_win, Time_step,Time_numLags,Time_orders,...
    Time_bins,Time_peakNumber,Time_peakNumberEnvelop,...
    Time_peakNumberGradient);


features=features';
% labels=1:8;
% labels=labels';

% Save the time features and labels
% DT_saveFeatureAndLabels(fileNameFull,...
%     labelNameFull, featureNames, features,labels);
DT_saveFeatures(fileNameFull,featureNames, features);

end


function []=extractFeatures_frequency (fileNameFull,labelNameFull, ...
    data, fs, win,...
    step, freqrange,...
    harmonicNumber,numberOfMFCCCoef,param)

featureNames= DT_frequencyFNames(harmonicNumber,numberOfMFCCCoef);
%TODO: Extract all the features for this csv file
features = DT_FeatureExtraction_Frequency(data,...
    fs, win, step, freqrange,harmonicNumber,numberOfMFCCCoef,param);
features=features';
DT_saveFeatures(fileNameFull,featureNames, features);

end

function []=extractFeatures_STFT (fileNameFull,labelNameFull, ...
    data, fs, win, step, FFTPeakNumber)

featureNames= DT_STFTNames(FFTPeakNumber);
%TODO: Extract all the features for this csv file
features = DT_STFTStatistics(data, fs, win, step, FFTPeakNumber );
features=features';
DT_saveFeatures(fileNameFull,featureNames, features);

end

function []=extractFeatures_CWT(fileNameFull,labelNameFull, ...
    data, fs, win, step, FFTPeakNumber)

featureNames= DT_CWTNames(FFTPeakNumber);
%TODO: Extract all the features for this csv file
features = DT_CWTStatistics(data, fs, win, step, FFTPeakNumber);
features=features';
DT_saveFeatures(fileNameFull,featureNames, features);

end
