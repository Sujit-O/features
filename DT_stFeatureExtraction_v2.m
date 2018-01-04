function Features = DT_stFeatureExtraction_v2(signal, fs, win, step,M)


[w f]=cwt(signal,fs);
 w=abs(w).^2;
       w = 10*log(w);
windowLength = round(win * fs);
step = round(step * fs);
w=w';
curPos = 1;
L = length(signal);

% compute the total number of frames:
numOfFrames = floor((L-windowLength)/step) + 1;
Features = zeros(length(f), numOfFrames);
for i=1:numOfFrames 
    frame  = signal(curPos:curPos+windowLength-1);
    frame  = frame .* Ham;
    frameFFT = getDFT(frame, fs);
    
end
 Features(length(f), :) = medfilt1(Features(length(f), :), 3);