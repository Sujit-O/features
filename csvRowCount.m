clear
clc
tic
fh = fopen('D:\GDrive\DT_Data\Sensor Positioning Data\Data_in_CSV_Format\Run1_0\Channel_10_V x2.csv', 'r');
chunksize = 1e6; % read chuncks of 1MB at a time
numlines = 0;
while ~feof(fh)
    ch = fread(fh, chunksize, '*uchar');
    if isempty(ch)
        break
    end
    numlines = numlines + sum(ch == sprintf('\n'));
end
fclose(fh);
toc