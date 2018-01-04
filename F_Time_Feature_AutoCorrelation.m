function frameAutoCorrelation = F_Time_Feature_AutoCorrelation(frame,numLags)

temp = autocorr(frame,numLags);

frameAutoCorrelation=temp(2:end);

end