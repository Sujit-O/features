function frame_Energy = F_Time_Feature_Energy(frame)

frame_Energy = (1/(length(frame))) * sum(abs(frame.^2));

end