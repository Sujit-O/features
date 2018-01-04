clear
clc

originFolder = strcat('D:\GDrive\DT_Data\DAQ_Auto_SegmentedData');
k=160:10:160;

for i=1:length(k)
   totalFolders{i}=strcat('UM3_Corner_Wall_',num2str(k(i)),'p'); 
end
% totalFolders=dir(strcat(originFolder,'\UM3*p'));

parfor i=1:size(totalFolders,2)
%     folderName=totalFolders(i).name;
    DT_Feature_Extraction_from_SegmentedCSV_test1(totalFolders{i});
end