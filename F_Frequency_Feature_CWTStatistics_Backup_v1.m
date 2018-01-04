function frequencyFeatures = F_Frequency_Feature_CWTStatistics(signal, fs, win, step )

windowLength = round(win * fs);
step = round(step * fs);
numberofPeak=10;
curPos = 1;
L = length(signal);
numOfFeatures=14+4*numberofPeak+1;
[w f]=cwt(signal,'bump',fs);
w=abs(w).^2;
w=w';


numOfFrames = floor((L-windowLength)/step) + 1;
frequencyFeatures = zeros(numOfFeatures, numOfFrames);
for i=1:numOfFrames
    frame  = w(curPos:curPos+windowLength-1,:);
    frame =  mean (frame,1);   
    
    
    if (sum(abs(frame))>eps)
        if (i==1)
            framePrev = frame;
        end
        frequencyFeatures(1,i)  =  max(frame);
        frequencyFeatures(2,i)  =  min(frame);
        frequencyFeatures(3,i)  =  mean(frame);
        frequencyFeatures(4,i)  =  median(frame);
        frequencyFeatures(5,i)  =  mode(frame);
        frequencyFeatures(6,i)  =  std(frame);
        frequencyFeatures(7,i)  =  var(frame);
        frequencyFeatures(8,i)  =  max(frame)- min(frame);
        frequencyFeatures(9,i)  = skewness(frame,1);
        frequencyFeatures(10,i)  = kurtosis(frame,1);
        frequencyFeatures(11,i)  = moment(frame,3);
        frequencyFeatures(12,i)  = F_Time_Feature_Energy_Entropy(frame, 10);
        frequencyFeatures(13,i)  =  peak2peak(frame);
        frequencyFeatures(14,i)  =  peak2rms(frame);
        
        [pks,locs,widths,proms] = findpeaks(frame,'SortStr','descend','NPeaks',numberofPeak);
        frequencyFeatures(15:14+numberofPeak,i)=pks;
        frequencyFeatures(14+numberofPeak+1:14+2*numberofPeak,i)=diff(locs);
        frequencyFeatures(14+2*numberofPeak+1:14+3*numberofPeak,i)=widths;
        frequencyFeatures(14+3*numberofPeak+1:14+4*numberofPeak,i)=proms;
        frameFlux = frame / sum(frame);
        framePrevFlux = framePrev / sum(framePrev+eps);
        frequencyFeatures(14+4*numberofPeak+1,i)= sum((frameFlux - framePrevFlux ).^2);
     
    else
        frequencyFeatures(:,i) = zeros(numOfFeatures, 1);
    end
    curPos = curPos + step;
    framePrev = frame;
end
frequencyFeatures(numOfFeatures, :) = medfilt1(frequencyFeatures(numOfFeatures, :), 3);
end