clear
clc
CSVFolder = strcat('D:\GDrive\DT_Data\DAQ_Auto_TDMStoCSV');
% totalCSVFolders=dir(strcat(CSVFolder,'\UM3*p'));
folders = [160];
totalCSVFolders={};
for j=1: size(folders,2)
    totalCSVFolders{j}.name=strcat('UM3_Corner_Wall_',num2str(folders(j)),'p');
end
%TODO: Remaining Folders [10,15,20,30,70,210,220,230]
%Run tdms2csv(tdmsFolderName) in python
%Run DT_getTimingBasedonSegments(tdmsFolderNames) in python
for i=1:size(totalCSVFolders,2)
    DT_rawSignals2SegmentGroups(CSVFolder, totalCSVFolders{i});
end