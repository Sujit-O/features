function [] = saveFeatureandLabelNames(FeatureFileName,FeatureLabelFileName, FeatureNames)

if (exist(FeatureFileName,'file')~=0)
    delete(FeatureFileName);
end

if (exist(FeatureLabelFileName,'file')~=0)
    delete(FeatureLabelFileName);
end

fid = fopen(FeatureFileName, 'w') ;
fprintf(fid, '%s,', FeatureNames{1,1:end-1}) ;
fprintf(fid, '%s\n',FeatureNames{1,end}) ;
fclose(fid) ;

fid = fopen(FeatureLabelFileName, 'w') ;
fprintf(fid, '%s\n','Labels') ;
fclose(fid) ;

end