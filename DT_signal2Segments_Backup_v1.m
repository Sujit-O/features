clear
clc
disp('\n*****Starting!*****');
%% Specifying the Parent Folder and Initialize variables
% From the GoogleDrive folder in D-drive
TDMSFolder = strcat('D:\GDrive\DT_Data\DAQ_Auto');
CSVFolder = strcat('D:\GDrive\DT_Data\DAQ_Auto_TDMStoCSV');
destinationFolder =strcat('D:\GDrive\DT_Data\DAQ_Auto_SegmentedData');

daqmetadataCheckFile='\segments_Floor\segment_0.csv';

%These are the names of the segment files where  timing information about
%the segments are stored
segmentFolderNames={'segments_Floor';'segments_Wall';...
    'segments_LengthFloor';'segments_BreadthFloor';...
    'segments_LengthWall';'segments_BreadthWall'};
segmentsFolderPath=cell(6);

%Names of the channels in
channelNames={'Channel_1_Mic_1';'Channel_2_Mic_2';'Channel_3_Mic_3';...
    'Channel_4_Mic_4';'Channel_5_Current';'Channel_6_Vib_x2';...
    'Channel_7_Vib_y2';'Channel_8_Vib_z2';'Channel_9_Vib_x1';...
    'Channel_10_Vib_y1';'Channel_11_Vib_z1';...
    'Channel_12_Vib_x0';...
    'Channel_13_Vib_y0';'Channel_14_Vib_z0';...
    'Channel_15_Temperature';'Channel_16_Humidity';...
    'Channel_17_Mag_x0';'Channel_18_Mag_y0';...
    'Channel_19_Mag_z0';'Channel_20_Mag_x1';...
    'Channel_21_Mag_y1';'Channel_22_Mag_z1';...
    'Channel_23_Mag_x2';'Channel_24_Mag_y2';...
    'Channel_25_Mag_z2' };


%DaQ sampling rate is 20 kHz
daqSamplingRate=20e3;
%%
totalCSVFolders=dir(strcat(CSVFolder,'\UM3*100p'));

for objects_i=1:size(totalCSVFolders,1)
    %%
    folderName=totalCSVFolders(objects_i);
    fprintf('\nFolder Name: %s',folderName.name);
    
    %pathToSegmentFolders
    for segments_i=1:size(segmentFolderNames,1)
        segmentsFolderPath{segments_i}=strcat(CSVFolder,'\',...
            folderName.name,'\',...
            segmentFolderNames{...
            segments_i});
        %         fprintf('\nSegment Folder Name: %s',segmentsFolderPath{...
        %                 segments_i});
        
        segTime(segments_i).name=segmentFolderNames{...
            segments_i};
        totalSegments=dir(strcat(segmentsFolderPath{segments_i},...
            '\segment*.csv'));
        %         fprintf('\nTotal Segments: %d',size(totalSegments,1));
        segTime(segments_i).subSegmentsNumber=size(totalSegments,1);
        for subsegments_i=1:size(totalSegments,1)
            
            temp1.segmentName=...
                totalSegments(subsegments_i).name;
            timeValues=csvread(strcat(segmentsFolderPath{segments_i},'\',...
                totalSegments(subsegments_i).name),1,0);
            temp1.startTime=timeValues(:,1)*60*60+ timeValues(:,2)*60 + timeValues(:,3)+timeValues(:,4)*1e-6;
            temp1.stopTime=timeValues(:,5)*60*60+ timeValues(:,6)*60 + timeValues(:,7)+timeValues(:,8)*1e-6;
            temp2(subsegments_i)=temp1;
        end
        segTime(segments_i).subSegments=temp2;
        
    end
    
    %%
    
    %count the total number of data folders segmented in DaQ
    totalCSVDataFolders=dir(strcat(CSVFolder,'\',...
        folderName.name,'\data*'));
    
    synchFileName=strcat(CSVFolder,'\',folderName.name,daqmetadataCheckFile);
    synchDaQFileName=strcat(CSVFolder,'\',folderName.name,'\data_1\timingMetaData.csv');
    synchFileRealTime=csvread(synchFileName,1,0,[1,0,1,0]);
    synchFileDaQTime=csvread(synchDaQFileName,1,0,[1,0,1,0]);
    hourOffset=synchFileRealTime-synchFileDaQTime;
    
    %%
    %for each data Folder read the corresponding Channels
    for dataFolder_i=1:1%size(totalCSVDataFolders,1)
        dataFolderName=totalCSVDataFolders(dataFolder_i);
        dataFolderPath=strcat(CSVFolder,'\',folderName.name,...
            '\',dataFolderName.name);
        fprintf('\nData Folder Name: %s',dataFolderName.name);
        
        %%
        %Read the timingMetaData.csv for each of the data file
        
        metaDataFileName=strcat(CSVFolder,'\',folderName.name,...
            '\',dataFolderName.name,...
            '\timingMetaData.csv');
        %         fprintf('\nTiming MetaData: %s',metaDataFileName);
        
        
        
        %%
        
        daqStartTime= csvread(metaDataFileName,1,0,[1,0,1,3]);
        daqStartTime(1)=daqStartTime(1)+hourOffset;
        if (daqStartTime(1)>23)
            daqStartTime(1)=mod(daqStartTime(1),24);
            
        end
        
        if (daqStartTime(1)<0)
            daqStartTime(1)=daqStartTime(1)+24;
            
        end
        %         fprintf('\nChanged DaQ: %d',daqStartTime(1))
        
        %%
        %Read the corresponding channelFiles and start extracting features
        %from them!
        
        for channel_i=1:size(channelNames,1)
            channelFileName= strcat(CSVFolder,'\',...
                folderName.name,'\',...
                dataFolderName.name,'\',...
                channelNames{channel_i},'.csv');
            fprintf('\nChannel Name: %s',channelNames{channel_i});
            data=csvread(channelFileName);
            timeTracker=zeros(size(data,1),1);
            
            parfor data_i=1:size(data,1)
                
                timeTracker(data_i)=daqStartTime(1)*60*60+daqStartTime(2)*60+daqStartTime(3)+daqStartTime(4)*1e-6 +(data_i-1)*1/daqSamplingRate;
            end
            
            %seTime Data Structure Inormation
            %segTime(i).name
            %segTime(i).subSegmentsNumber
            %segTime(i).subSegments(i).segmentName
            %segTime(i).subSegments(i).startTime(i)
            %segTime(i).subSegments(i).stopTime(i)
            %values are startime hour
            %minute second and microsecond and stoptime hour minute second and
            %microsecond
            
            for seg_i=1:size(segTime,2)
                fprintf('\nSegment Name: %s',segTime(seg_i).name);
                for segNumber_i=1:segTime(seg_i).subSegmentsNumber
                    fprintf('\nSegment Number: %d',segNumber_i);
                    index=[];
                    for times_i=1:size(segTime(seg_i).subSegments(segNumber_i).startTime,1)
                        startTime= segTime(seg_i).subSegments(segNumber_i).startTime(times_i);
                        stopTime =segTime(seg_i).subSegments(segNumber_i).stopTime(times_i);
                        indexTemp=find(timeTracker>= startTime & timeTracker<= stopTime);
                        index=[index; indexTemp];
                    end
                    dataTemp=data(index);
                     
                    if isempty(dataTemp)
                        continue;
                    end
                    
                    if (exist(destinationFolder,'dir')==0)
                        mkdir (destinationFolder);
                    end
                    
                    if (exist(strcat(destinationFolder,'\',folderName.name),'dir')==0)
                        mkdir (strcat(destinationFolder,'\',folderName.name));
                    end
                    
                    if (exist(strcat(destinationFolder,'\',folderName.name,'\',channelNames{channel_i}),'dir')==0)
                        mkdir (strcat(destinationFolder,'\',folderName.name,'\',channelNames{channel_i}));
                    end
                    
                    if (exist(strcat(destinationFolder,'\',folderName.name,'\',channelNames{channel_i},'\',segTime(seg_i).name),'dir')==0)
                        mkdir (strcat(destinationFolder,'\',folderName.name,'\',channelNames{channel_i},'\',segTime(seg_i).name));
                    end
                    
                    filenameCSV=strcat(destinationFolder,'\',folderName.name,'\',channelNames{channel_i},'\',segTime(seg_i).name,'\',segTime(seg_i).subSegments(segNumber_i).segmentName);
                    dlmwrite(filenameCSV,dataTemp,'-append','delimiter','');
                end
                
            end
            
       end
        
    end
    
    
end

