function frequencyFeatures = DT_STFTStatistics(signal, fs, win, step, FFTPeakNumber )

windowLength = round(win * fs);
step = round(step * fs);
% FFTPeakNumber=10;
curPos = 1;
L = length(signal);

[featureNames,...
    numberOfFeatures,...
    numberofFFTPeakFeatures] = DT_STFTNames(FFTPeakNumber);

% compute the total number of frames:
Ham = window(@hamming, windowLength);
numOfFrames = floor((L-windowLength)/step) + 1;
frequencyFeatures = zeros(numberOfFeatures, numOfFrames);
for i=1:numOfFrames
    frame  = signal(curPos:curPos+windowLength-1);
    frame  = frame .* Ham;
    frameFFT  = F_Frequency_Feature_getDFT(frame , fs);
    
    if (sum(abs(frame))>eps)
        if (i==1)
            frameFFTPrev = frameFFT;
        end
        fnum=1;
        frequencyFeatures(fnum,i)  =  max(frameFFT);                                fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  min(frameFFT);                                fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  mean(frameFFT);                               fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  median(frameFFT);                             fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  mode(frameFFT);                               fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  std(frameFFT);                                fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  var(frameFFT);                                fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  max(frameFFT)- min(frameFFT);                 fnum=fnum+1;
        frequencyFeatures(fnum,i)  =  skewness(frameFFT,1);                         fnum=fnum+1;
        frequencyFeatures(fnum,i)  = kurtosis(frameFFT,1);                          fnum=fnum+1;
        frequencyFeatures(fnum,i)  = moment(frameFFT,3);                            fnum=fnum+1;
        frequencyFeatures(fnum,i)  = F_Time_Feature_Energy_Entropy(frameFFT, 10);   fnum=fnum+1;
        frequencyFeatures(fnum,i)  = peak2peak(frameFFT);                           fnum=fnum+1;
        frequencyFeatures(fnum,i)  = peak2rms(frameFFT);                            fnum=fnum+1;
        
        frameFFTFlux = frameFFT / sum(frameFFT);
        frameFFTPrevFlux = frameFFTPrev / sum(frameFFTPrev+eps);
        
        frequencyFeatures(fnum,i)  = sum((frameFFTFlux - frameFFTPrevFlux ).^2);      fnum=fnum+1;
        
%         [pks,locs,widths,proms] = findpeaks(frameFFT,...
%             'SortStr','descend','NPeaks',numberofPeak);
         frequencyFeatures(fnum:fnum+numberofFFTPeakFeatures-1,...
             i)                    = F_Time_Feature_PeakAnalysis(frameFFT,FFTPeakNumber);
         fnum=fnum+numberofFFTPeakFeatures;
%         frequencyFeatures(fnum:fnum+numberofPeak-1,i)=pks;                          fnum=fnum+numberofPeak;
%         frequencyFeatures(fnum:fnum+numberofPeak-2,i)=diff(locs);                   fnum=fnum+numberofPeak-1;
%         frequencyFeatures(fnum:fnum+numberofPeak-1,i)=widths;                       fnum=fnum+numberofPeak;
%         frequencyFeatures(fnum:fnum+numberofPeak-1,i)=proms;                        fnum=fnum+numberofPeak;
        
        
        
    else
        frequencyFeatures(:,i) = zeros(numberOfFeatures, 1);
    end
    curPos = curPos + step;
    frameFFTPrev = frameFFT;
end
frequencyFeatures(numberOfFeatures, :) = medfilt1(frequencyFeatures(numberOfFeatures, :), 3);
end