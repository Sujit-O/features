function [] = DT_saveFeatureAndLabels(featureFileName,featureLabelFileName, featureNames, features,labels)

if (exist(featureFileName,'file')~=0)
    delete(featureFileName);
end

if (exist(featureLabelFileName,'file')~=0)
    delete(featureLabelFileName);
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


fid = fopen(featureLabelFileName,'w');
fprintf(fid,'%s\n','yValues');
fclose(fid);

dlmwrite(featureLabelFileName,labels,'-append','delimiter',',');

end