clear
clc

originFolder = strcat('D:\GDrive\DT_Data\DAQ_Auto_SegmentedData');
totalFolders=dir(strcat(originFolder,'\UM3*p'));

parfor i=1:size(totalFolders,1)
    folderName=totalFolders(i).name;
    DT_Feature_Extraction_from_SegmentedCSV(folderName);
end