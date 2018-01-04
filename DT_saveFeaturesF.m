function [] = DT_saveFeaturesF(featureFileName, features)

dlmwrite(featureFileName,features,'-append','delimiter',',');

end