function frequencyFeatures = F_Frequency_Feature_CWTStatistics(signal, fs, win, step, FFTPeakNumber )

windowLength = round(win * fs);
step = round(step * fs);


[w f]=cwt(signal,'bump',fs);
w=abs(w).^2;
w=w';


% FFTPeakNumber=10;
curPos = 1;
L = length(signal);

[featureNames,...
    numberOfFeatures,...
    numberofFFTPeakFeatures] = G_FeatureExtraction_Frequency_CWTStastistics_FeatureNames(FFTPeakNumber);

% compute the total number of frames:
Ham = window(@hamming, windowLength);
numOfFrames = floor((L-windowLength)/step) + 1;
frequencyFeatures = zeros(numberOfFeatures, numOfFrames);

for i=1:numOfFrames
    frame  = w(curPos:curPos+windowLength-1,:);
    frame  = frame.* Ham;
    frame =  mean(frame,1);
  
   
    if (sum(abs(frame))>eps)
        if (i==1)
            framePrev = frame;
        end
        fnum=1;
        frequencyFeatures(fnum,i)  =  max(frame);                                     fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  min(frame);                                     fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  mean(frame);                                    fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  median(frame);                                  fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  mode(frame);                                    fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  std(frame);                                     fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  var(frame);                                     fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  max(frame)- min(frame);                         fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  skewness(frame,1);                              fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  kurtosis(frame,1);                              fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  moment(frame,3);                                fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  F_Time_Feature_Energy_Entropy(frame, 10);       fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  peak2peak(frame);                               fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  peak2rms(frame);                                fnum=fnum+1;
        
                
        frameFFTFlux = frame / sum(frame);
        frameFFTPrevFlux = framePrev / sum(framePrev+eps);
        
        frequencyFeatures(fnum,i)  = sum((frameFFTFlux - frameFFTPrevFlux ).^2);       fnum=fnum+1;
        frequencyFeatures(fnum:fnum+numberofFFTPeakFeatures-1,...
            i)                    = F_Frequency_Feature_PeakAnalysis(frame,FFTPeakNumber);
        
    else
        frequencyFeatures(:,i) = zeros(numberOfFeatures, 1);
    end
    curPos = curPos + step;
    framePrev = frame;
end
frequencyFeatures(numberOfFeatures, :) = medfilt1(frequencyFeatures(numberOfFeatures, :), 3);
end