clear
clc
disp('\n*****Starting!*****');
%% Specifying the Parent Folder and Initialize variables
% From the GoogleDrive folder in D-drive
TDMSFolder = strcat('D:\GDrive\DT_Data\DAQ_Auto');
CSVFolder = strcat('D:\GDrive\DT_Data\DAQ_Auto_TDMStoCSV');
featureFolder =strcat('D:\GDrive\DT_Data\DAQ_Auto_Features');
% totalTDMSFolders=dir(strcat(fullfile(originTDMSFolder,tdmsFolderName),'\*.tdms'));

%%
totalCSVFolders=dir(strcat(CSVFolder,'\UM3*p'));
for i=1:size(totalCSVFolders,1)
    folderName=totalCSVFolders(i);
    totalsegmentedFolders=dir(strcat(CSVFolder,'\',folderName));
    
end


%%  Initialize the variables
daqSamplingRate=1.3889e+04; % daqSamplingRate Sampling Rate of the NI:DAQ
fs=daqSamplingRate;
% Sensors have their own sampling Rate
sensorSamplingRate_Vibration=5000; %~700 Hz for vibration, downsample to 5Khz, around 8 times the original sampling rate
sensorSamplingRate_Magnetic=1000; %~120 Hz for magnetic downsample to 1kHz
% calculate the p,q values for resampling
[pV,qV]=rat(sensorSamplingRate_Vibration/daqSamplingRate);
[pM,qM]=rat(sensorSamplingRate_Magnetic/daqSamplingRate);
%define the data size to read in parallel and extract the features


dataChunkNumber=75; %original 75
C1=0; %CSV has only one column
C2=0; %CSV has only one column
M=0; %MAgnetic Channel?

% Time step used by all the feature extraction functions
universalStep=0.05;
universalOverlap=0.5;

%Variables to track the layer and the sequence number
%% Initialization for Time Domain Features
Time_numLags           = 2; % for autocorrelation
Time_orders            = 4; % number of orders for moments
Time_bins              = 5; % bins for historgram
Time_peakNumber        = 5; % for peak analysis
Time_peakNumberEnvelop = 3; % peaks for envelop analysis
Time_peakNumberGradient = 5;

% Time_win =0.2;
Time_Overlap=universalOverlap;
Time_step= universalStep;
Time_win=Time_step./(1-Time_Overlap); %Determine window based on overlap
% Time_step=Time_win-Time_Overlap*Time_win; %Determine step based on overlap

timeFeatureNames= G_FeatureExtraction_Time_FeatureNames(Time_numLags,Time_orders,Time_bins,Time_peakNumber);
timeFeatureFileNameO='timeFeatures.csv';
timeFeatureLabelFileNameO='timeFeaturesLabel.csv';
%% Initialization for Frequency Domain Features
Frequency_Overlap=universalOverlap;
Frequency_step= universalStep;
Frequency_win=Frequency_step./(1-Frequency_Overlap); %Determine window based on overlap
% Frequency_Overlap=0.8;
% Frequency_win =0.2;
% Frequency_step=Frequency_win-Frequency_Overlap*Frequency_win; %Determine step based on overlap
Frequency_freqrange= [40 120];
Frequency_param = 0.9;
Frequency_harmonicNumber =3;
Frequency_numberOfMFCCCoef=13;

frequencyFeatureNames= G_FeatureExtraction_Frequency_FeatureNames(Frequency_harmonicNumber,Frequency_numberOfMFCCCoef);
frequencyFeatureFileNameO='frequencyFeatures.csv';
frequencyFeatureLabelFileNameO='frequencyFeaturesLabel.csv';
%% Initialization for STFT Stastistics Features
Frequency_STFT_Overlap=universalOverlap;
Frequency_STFT_step= universalStep;
Frequency_STFT_win=Frequency_STFT_step./(1-Frequency_STFT_Overlap); %Determine window based on overlap
% Frequency_STFT_Overlap=0.8;
% Frequency_STFT_win =0.2;
% Frequency_STFT_step=Frequency_STFT_win-Frequency_STFT_Overlap*Frequency_STFT_win; %Determine step based on overlap
Frequency_STFT_FFTPeakNumber=10;

frequencySTFTStastisticsFeatureNames= G_FeatureExtraction_Frequency_STFTStastistics_FeatureNames(Frequency_STFT_FFTPeakNumber);
frequencySTFTStastisticsFeatureFileNameO='frequencySTFTStastisticsFeatures.csv';
frequencySTFTStastisticsFeatureLabelFileNameO='frequencySTFTStastisticsFeaturesLabel.csv';
%% Initialization for CWT Stastistics Features
Frequency_CWT_Overlap=universalOverlap;
Frequency_CWT_step= universalStep;
Frequency_CWT_win=Frequency_CWT_step./(1-Frequency_CWT_Overlap); %Determine window based on overlap
% Frequency_CWT_Overlap=0.8;
% Frequency_CWT_win =0.2;
% Frequency_CWT_step=Frequency_CWT_win-Frequency_CWT_Overlap*Frequency_CWT_win; %Determine step based on overlap
Frequency_CWT_FFTPeakNumber=10;

frequencyCWTStastisticsFeatureNames= G_FeatureExtraction_Frequency_CWTStastistics_FeatureNames(Frequency_CWT_FFTPeakNumber);
frequencyCWTStastisticsFeatureFileNameO='frequencyCWTStastisticsFeatures.csv';
frequencyCWTStastisticsFeatureLabelFileNameO='frequencyCWTStastisticsFeaturesLabel.csv';
%%
% totalFeatures=frequencyCWTStastisticsNumberOfFeatures+...
%     frequencySTFTStastisticsNumberOfFeatures+frequencyNumberOfFeatures+timeNumberOfFeatures;

%% Start the loop For all the runs
for runs=runValue:runValue%floor(length(dir(strcat(file_path_parent,'\Run*')))/3)
    fprintf('\nRun-->%d',runs);
    if(runs>4)
        angleValue=0;
    end
    for angle=angleValue:angleValue %three orientation for each run
        
        if(runs>4)
            folder_name=strcat('Run',num2str(runs),'\daqData');
        else
            fprintf('\n\nAngle-->%d',angle*30);
            folder_name=strcat('Run',num2str(runs),'_',num2str(angle*30),'\daqData');
        end
        % File name
        file_path=strcat(file_path_parent,'\',folder_name);
        file_name_csv=dir(strcat(file_path,'\Channel*.csv'));
        channels=length(file_name_csv);%11:11;%[1,3,9,11,15,16];%length(file_name_csv);
        %% Running the Loop for all the Channels
        
        
        
        
        
        for channelRun=1:length(channels)
            %check if the file exists!
            filesegmentname=strcat('Run_',num2str(runs),'.csv');
            segmentData=csvread(fullfile(file_path_parent_feature_csv_segmentPoints,filesegmentname));
            
            
            channel=channels(channelRun);
            if (exist(fullfile(file_path,file_name_csv(channel).name),'file')==0)
                continue;
            end
            fprintf('\nFound File--> %s',file_name_csv(channel).name);
            
            dataPath=fullfile(file_path,file_name_csv(channel).name);
            
            if(runs>4)
                feature_folder_name=strcat('Run',num2str(runs),'\',file_name_csv(channel).name(1:end-4));
            else
                feature_folder_name=strcat('Run',num2str(runs),'_',num2str(angle*30),'\',file_name_csv(channel).name(1:end-4));
            end
            
            
            if (exist(fullfile(file_path_parent_feature_csv,feature_folder_name),'dir')==0)
                mkdir (file_path_parent_feature_csv, feature_folder_name);
            end
            
            featureFolder_parent_path=strcat(file_path_parent_feature_csv,'\', feature_folder_name);
            
            % Store the features names of all the features
            %             timeFeatureFileName=strcat(featureFolder_parent_path,'\',timeFeatureFileNameO);
            %             timeFeatureLabelFileName=strcat(featureFolder_parent_path,'\',timeFeatureLabelFileNameO);
            
            %             frequencyFeatureFileName=strcat(featureFolder_parent_path,'\',frequencyFeatureFileNameO);
            %             frequencyFeatureLabelFileName=strcat(featureFolder_parent_path,'\',frequencyFeatureLabelFileNameO);
            %
            %             frequencySTFTStastisticsFeatureFileName=strcat(featureFolder_parent_path,...
            %                 '\',frequencySTFTStastisticsFeatureFileNameO);
            %             frequencySTFTStastisticsFeatureLabelFileName=strcat(featureFolder_parent_path,...
            %                 '\',frequencySTFTStastisticsFeatureLabelFileNameO);
            
            frequencyCWTStastisticsFeatureFileName=strcat(featureFolder_parent_path,...
                '\',frequencyCWTStastisticsFeatureFileNameO);
            frequencyCWTStastisticsFeatureLabelFileName=strcat(featureFolder_parent_path,...
                '\',frequencyCWTStastisticsFeatureLabelFileNameO);
            
            %             saveFeatureandLabelNames(timeFeatureFileName,timeFeatureLabelFileName, timeFeatureNames);
            %             saveFeatureandLabelNames(frequencyFeatureFileName,frequencyFeatureLabelFileName,...
            %                 frequencyFeatureNames);
            %             saveFeatureandLabelNames(frequencySTFTStastisticsFeatureFileName,...
            %                 frequencySTFTStastisticsFeatureLabelFileName, frequencySTFTStastisticsFeatureNames);
            saveFeatureandLabelNames(frequencyCWTStastisticsFeatureFileName,...
                frequencyCWTStastisticsFeatureLabelFileName, frequencyCWTStastisticsFeatureNames);
            %
            
            %% Read the metada
            % TODO: Read the metadata without reading the whole file!!
            
            fh = fopen(dataPath, 'r');
            chunksize = 1e6; % read chunk of one mega Bytes at a time
            dataLength = 0;
            while ~feof(fh)
                ch = fread(fh, chunksize, '*uchar');
                if isempty(ch)
                    break
                end
                dataLength = dataLength + sum(ch == newline);
            end
            fclose(fh);
            
            %% Read and Extract the features from the DATA
            % Read chunk of data in parallel and extract the features
            dataChunkSize=floor(dataLength/dataChunkNumber);
            fprintf('\nChunk Time:%f',dataChunkSize/daqSamplingRate);
            
            
            previousDataChunkRemainingSamples=[];
            for i=0:(dataChunkNumber-45) %parallelize this section
                fprintf('\nChunk Number:%d',i+1);
                sequenceValues=segmentData(i+1,:);
                R1=i*dataChunkSize+1;
                R2=(i+1)*dataChunkSize;
                if(R2>dataLength)
                    R2=dataLength; %at the end make sure R2 doesn't exceed the length of the csv data
                end
                dataCSV= csvread(dataPath,R1,C1,[R1 C1 R2 C2]);
                
                %%Remove the extra signal from head
                if(i==0)
                    file_name_save=strcat(file_path_parent,'\',folder_name,'\Initial_CutOff.csv');
                    dataInitialCutOff=csvread(file_name_save);
                    fprintf('\nInitial Cut Off:%f',dataInitialCutOff);
                    startPoint=floor(dataInitialCutOff*fs);
                    dataCSV(1:uint32(startPoint))=[];
                end
                
                %%Downsample the data according to the sensor sampling Rate
                if (strfind(file_name_csv(channel).name,'M')~=0)
                    
                    dataCSV_downSampled=filter(lowFilterM,dataCSV);
                    dataCSV_downSampled = resample(dataCSV_downSampled,pM,qM);
                    fs=sensorSamplingRate_Magnetic;
                    
                    
                elseif(strfind(file_name_csv(channel).name,'V')~=0)
                    
                    dataCSV_downSampled=filter(lowFilterV,dataCSV);
                    dataCSV_downSampled = resample(dataCSV_downSampled,pV,qV);
                    fs=sensorSamplingRate_Vibration                    ;
                    
                    
                else
                    fprintf('\nFile not Found-->%s  ',file_name_csv(channel).name);
                end
                
                
                dataCSV_downSampled=[previousDataChunkRemainingSamples;dataCSV_downSampled];
                
                mm=sequenceValues(find(sequenceValues>0));
                kk= diff(mm);
                
                previousDataChunkRemainingSamples=dataCSV_downSampled(floor(mm(end)*fs-350):end);
                
                dataCSV_downSampled(floor(mm(end)*fs+1):end)=[];
                
                
                parfor ll=1:length(mm)-1
                    
                    if((mm(ll+1)-mm(ll))>12 || (mm(ll+1)-mm(ll))<11)
                        continue;
                    end
                    
                    startPoint=floor(mm(ll)*fs)-350;
                    if(startPoint<1)
                        startPoint=1;
                    end
                    
                    endPoint=ceil(mm(ll+1)*fs);
                    if(endPoint>length(dataCSV_downSampled))
                        endPoint=length(dataCSV_downSampled);
                    end
                    data= dataCSV_downSampled(startPoint:endPoint-1);
                    plot(data);
                    dd=[1.696721682343538;13.762298090119810;26.355743465736282;39.326238104095765;51.844273627163650;63.608210624745490;75.070508212132960;87.663953587749420];
                    
                    zz=data(1:floor(dd(1)/100*length(data)));
                    x= data(floor(dd(1)/100*length(data)):floor(dd(2)/100*length(data)));
                    xy= data(floor(dd(2)/100*length(data)):floor(dd(3)/100*length(data)));
                    y= data(floor(dd(3)/100*length(data)):floor(dd(4)/100*length(data)));
                    xy= [xy;data(floor(dd(4)/100*length(data)):floor(dd(6)/100*length(data)))];
                    y= [y;data(floor(dd(6)/100*length(data)):floor(dd(7)/100*length(data)))];
                    xy= [xy;data(floor(dd(7)/100*length(data)): floor(dd(8)*length(data)))];
                    x= [x;data(floor(dd(8)/100*length(data)):end-100)];
                    
                    
                    %  CWT Stastistics
                    features_CWTStastistics = F_Frequency_Feature_CWTStatistics(zz,...
                        fs, Frequency_CWT_win, Frequency_CWT_step, Frequency_CWT_FFTPeakNumber);
                    features_CWTStastistics=features_CWTStastistics';
                    
                    dlmwrite(frequencyCWTStastisticsFeatureFileName,features_CWTStastistics,'-append');
                    dlmwrite(frequencyCWTStastisticsFeatureLabelFileName,...
                        repmat('Z',[size(features_CWTStastistics,1), 1]),'-append','delimiter','');
                    
                    features_CWTStastistics = F_Frequency_Feature_CWTStatistics(x,...
                        fs, Frequency_CWT_win, Frequency_CWT_step, Frequency_CWT_FFTPeakNumber);
                    features_CWTStastistics=features_CWTStastistics';
                    
                    dlmwrite(frequencyCWTStastisticsFeatureFileName,features_CWTStastistics,'-append');
                    dlmwrite(frequencyCWTStastisticsFeatureLabelFileName,...
                        repmat('X',[size(features_CWTStastistics,1), 1]),'-append','delimiter','');
                    
                    features_CWTStastistics = F_Frequency_Feature_CWTStatistics(xy,...
                        fs, Frequency_CWT_win, Frequency_CWT_step, Frequency_CWT_FFTPeakNumber);
                    features_CWTStastistics=features_CWTStastistics';
                    
                    dlmwrite(frequencyCWTStastisticsFeatureFileName,features_CWTStastistics,'-append');
                    dlmwrite(frequencyCWTStastisticsFeatureLabelFileName,...
                        repmat('XY',[size(features_CWTStastistics,1), 1]),'-append','delimiter','');
                    
                    features_CWTStastistics = F_Frequency_Feature_CWTStatistics(y,...
                        fs, Frequency_CWT_win, Frequency_CWT_step, Frequency_CWT_FFTPeakNumber);
                    features_CWTStastistics=features_CWTStastistics';
                    
                    dlmwrite(frequencyCWTStastisticsFeatureFileName,features_CWTStastistics,'-append');
                    dlmwrite(frequencyCWTStastisticsFeatureLabelFileName,...
                        repmat('Y',[size(features_CWTStastistics,1), 1]),'-append','delimiter','');
                    
                    
                end
                
              
                
                
            end
            
            
        end
        
    end
end
% var=ginput(8);
% varr=var(:,1)/length(data)*100
fprintf('\n*****Done!*****\n');
% end

% parfor i=1:size(totalTDMSFolders,1)
%     % tdmsFolderName = 'UM3_Corner_Wall_100p';
%     tdms2csv(originTDMSFolder, destinationCSVFolder, totalTDMSFolders(i).name);
% end
