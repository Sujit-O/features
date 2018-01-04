function frameRiseTime = F_Time_Feature_RiseTime(signal, fs )

h = risetime(signal,fs);
if(isempty(h))
    frameRiseTime=zeros(1,6);
    return;
end
try 
    
    mval=mode(h); 
catch
    mval=0;
end

try
frameRiseTime=[max(h),...
               min(h),...
               mval ,...
               mean(h),...
               std(h),...
               (max(h)-min(h))];
catch
    frameRiseTime=zeros(1,6);
end
end
