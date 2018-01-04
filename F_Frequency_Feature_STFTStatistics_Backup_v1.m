function frequencyFeatures = F_Frequency_Feature_STFTStatistics(signal, fs, win, step )

windowLength = round(win * fs);
step = round(step * fs);
numberofPeak=10;
curPos = 1;
L = length(signal);
numOfFeatures=14+4*numberofPeak+1;

% compute the total number of frames:
Ham = window(@hamming, windowLength);
numOfFrames = floor((L-windowLength)/step) + 1;
frequencyFeatures = zeros(numOfFeatures, numOfFrames);
for i=1:numOfFrames
    frame  = signal(curPos:curPos+windowLength-1);
    frame  = frame .* Ham;
    frameFFT  = F_Frequency_Feature_getDFT(frame , fs);
    
    if (sum(abs(frame))>eps)
        if (i==1)
            frameFFTPrev = frameFFT;
        end
        frequencyFeatures(1,i)  =  max(frameFFT);
        frequencyFeatures(2,i)  =  min(frameFFT);
        frequencyFeatures(3,i)  =  mean(frameFFT);
        frequencyFeatures(4,i)  =  median(frameFFT);
        frequencyFeatures(5,i)  =  mode(frameFFT);
        frequencyFeatures(6,i)  =  std(frameFFT);
        frequencyFeatures(7,i)  =  var(frameFFT);
        frequencyFeatures(8,i)  =  max(frameFFT)- min(frameFFT);
        frequencyFeatures(9,i)  =  skewness(frameFFT,1);
        frequencyFeatures(10,i)  = kurtosis(frameFFT,1);
        frequencyFeatures(11,i)  = moment(frameFFT,3);
        frequencyFeatures(12,i)  = F_Time_Feature_Energy_Entropy(frameFFT, 10);
        frequencyFeatures(13,i)  = peak2peak(frameFFT);
        frequencyFeatures(14,i)  = peak2rms(frameFFT);
        
        [pks,locs,widths,proms] = findpeaks(frameFFT,'SortStr','descend','NPeaks',numberofPeak);
        frequencyFeatures(15:14+numberofPeak,i)=pks;
        frequencyFeatures(14+numberofPeak+1:14+2*numberofPeak,i)=diff(locs);
        frequencyFeatures(14+2*numberofPeak+1:14+3*numberofPeak,i)=widths;
        frequencyFeatures(14+3*numberofPeak+1:14+4*numberofPeak,i)=proms;
        frameFFTFlux = frameFFT / sum(frameFFT);
        frameFFTPrevFlux = frameFFTPrev / sum(frameFFTPrev+eps);
        frequencyFeatures(14+4*numberofPeak+1,i)= sum((frameFFTFlux - frameFFTPrevFlux ).^2);
        
    else
        frequencyFeatures(:,i) = zeros(numOfFeatures, 1);
    end
    curPos = curPos + step;
    frameFFTPrev = frameFFT;
end
frequencyFeatures(numOfFeatures, :) = medfilt1(frequencyFeatures(numOfFeatures, :), 3);
end