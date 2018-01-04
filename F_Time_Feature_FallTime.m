function frameFallTime = F_Time_Feature_FallTime(signal, fs )

h = falltime(signal,fs);
if(isempty(h))
    frameFallTime=zeros(1,6);
    return;
end
try 
    
    mval=mode(h); 
catch
    mval=0;
end
try
frameFallTime=[max(h),...
               min(h),...
               mval ,...
               mean(h),...
               std(h),...
               (max(h)-min(h))];
catch
    frameFallTime=zeros(1,6);
end
end
