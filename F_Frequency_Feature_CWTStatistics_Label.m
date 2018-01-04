function numOfFrames  = F_Frequency_Feature_CWTStatistics_Label(signal, fs, win, step)

windowLength = round(win * fs);
step = round(step * fs);


L = length(signal);

numOfFrames = floor((L-windowLength)/step) + 1;

end