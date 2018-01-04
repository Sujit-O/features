function peakFeatures = F_Time_Feature_PeakAnalysis(frame,peakNumber)

%detrend the data
% [p,s,mu] = polyfit((1:numel(frame))',frame,6);
% f_y = polyval(p,(1:numel(frame))',[],mu);
% detrendedFrame = frame - f_y;       

[pks,locs,widths,proms] = findpeaks(frame,'SortStr','descend','NPeaks',peakNumber);


if(length(pks)==peakNumber)
    peakFeatures= [pks',diff(locs)',widths',proms', mean(pks), mean(diff(locs)), mean(widths),mean(proms)];
else
    pks=[pks; zeros(peakNumber-length(pks),1)];
    locs=[locs; zeros(peakNumber-length(locs),1)];
    widths=[widths; zeros(peakNumber-length(widths),1)];
    proms=[proms; zeros(peakNumber-length(proms),1)];
    
    peakFeatures= [pks',diff(locs)',widths',proms', mean(pks), mean(diff(locs)), mean(widths),mean(proms)];
end

% peakFeatures= [pks',diff(locs)',widths',proms', mean(pks), mean(diff(locs)), mean(widths),mean(proms)];

% detrendedFrame=-detrendedFrame;
% [pks,locs,widths,proms] = findpeaks(detrendedFrame,'SortStr','descend','NPeaks',peakNumber);
% meanIntervalI = mean(diff(locs));
% meanPksI=mean(pks);
% meanWidthsI=mean(widths);
% meanProminanceI=mean(proms);

end