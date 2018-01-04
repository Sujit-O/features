function frameEntropy = F_Time_Feature_Energy_Entropy(frame, subFrames)

totalFrameEnergy = sum(frame.^2);
winLength = length(frame);
subWinLength = floor(winLength / subFrames);

if length(frame)~=subWinLength* subFrames
    frame = frame(1:subWinLength* subFrames);
end

subWindows = reshape(frame, subWinLength, subFrames);
s = sum(subWindows.^2) / (totalFrameEnergy+eps);
frameEntropy = -sum(s.*log2(s+eps));
end