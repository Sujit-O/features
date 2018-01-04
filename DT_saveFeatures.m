function [] = DT_saveFeatures(featureFileName, featureNames, features)

if (exist(featureFileName,'file')~=0)
    delete(featureFileName);
end


%%

header_string = featureNames{1};
for i = 2:length(featureNames)
    header_string = [header_string,',',featureNames{i}];
end


fid = fopen(featureFileName,'w');
fprintf(fid,'%s\r\n',header_string);
fclose(fid);

dlmwrite(featureFileName,features,'-append','delimiter',',');

end