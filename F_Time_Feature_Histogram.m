function frame_hist = F_Time_Feature_Histogram(frame,bins)

frame_hist = histcounts(frame,bins,'Normalization', 'probability');


end