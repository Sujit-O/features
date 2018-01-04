function frame_ZCR = F_Time_Feature_ZCR(frame)
frame2 = zeros(size(frame));
frame2(2:end) = frame(1:end-1);
frame_ZCR = (1/(2*length(frame))) * sum(abs(sign(frame)-sign(frame2)));
end


