function frameDutyCycle = F_Time_Feature_DutyCycle(signal, fs )

h = dutycycle(signal,fs);
if(isempty(h))
  frameDutyCycle=zeros(1,6); 
return; 
end

frameDutyCycle=[max(h),...
               min(h),...
               mode(h),...
               mean(h),...
               std(h),...
               (max(h)-min(h))];
end