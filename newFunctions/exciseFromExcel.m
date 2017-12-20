function exciseFromExcel(fileName)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
data = xlsread(fileName);
%data = [xlsread(filename, 'A:A'); xlsread(filename, 'B:B'); xlsread(filename, 'C:C')];

for I = 2:size(data, 1)
        exciseTrackingData(data(I,1), data(I,2), data(I,3));
end

