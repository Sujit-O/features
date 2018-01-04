clear
clc
originTDMSFolder = strcat('D:\GDrive\DT_Data\DAQ_Auto');
destinationCSVFolder = strcat('D:\GDrive\DT_Data\DAQ_Auto_TDMStoCSV');

% totalTDMSFolders=dir(strcat(fullfile(originTDMSFolder,tdmsFolderName),'\*.tdms'));
totalTDMSFolders=dir(strcat(originTDMSFolder,'\UM3*p'));

%%


parfor i=1:size(totalTDMSFolders,1)
    % tdmsFolderName = 'UM3_Corner_Wall_100p';
    tdms2csv(originTDMSFolder, destinationCSVFolder, totalTDMSFolders(i).name);
end
