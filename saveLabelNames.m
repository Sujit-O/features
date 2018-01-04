function [] = saveLabelNames(FeatureLabelFileName)


if (exist(FeatureLabelFileName,'file')~=0)
    delete(FeatureLabelFileName);
end


fid = fopen(FeatureLabelFileName, 'w') ;
fprintf(fid, '%s\n','Labels') ;
fclose(fid) ;

end