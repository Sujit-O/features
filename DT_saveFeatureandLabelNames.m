function [] = DT_saveFeatureAndLabels(featureFileName,featureLabelFileName, featureNames, features)

if (exist(featureFileName,'file')~=0)
    delete(featureFileName);
end

if (exist(featureLabelFileName,'file')~=0)
    delete(featureLabelFileName);
end

csvwrite(featureFileName, featureNames, features);

end