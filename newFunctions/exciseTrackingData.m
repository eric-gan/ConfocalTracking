%=========================================================================
% exciseTrackingData.m
%   Loads a tracking file and returns the tracking file with the adjusted
%   variables for indices of snippet area. Will look for a .mat file with
%   given name; however, if fails, will look for a .tdms file to convert
%   Assumes dt of 0.001 and downsampleFactor of 1.
%
%   INPUTS:
%       fileName: name of the file to work with
%       startPct: index to begin excise of data as a percentage [0,100]
%       endPct: index to end excise of data as a percentage [0,100]
%
%   OUTPUT: none
%
%   Written by: Eric Gan, Sean Andersson
%=========================================================================
function exciseTrackingData(fileName, startPct, endPct)

%Constant Parameters
downsampleFactor = 1;
dt = 0.001;

% Load the file needed to extract
if(exist([fileName '.mat'],'file')==2)
    load([fileName '.mat'])
else
    convertTDMS(1,[fileName '.tdms']);
    load([fileName '.mat'])
end

% Conversion factors since position data is in volts
xScaleFactor = 5; % um / V
yScaleFactor = 5; % um / V
zScaleFactor = 2.5; % um / V

% Scale, Translate, and Downsample data
apd = downsample(ConvertedData.Data.MeasuredData(3).Data,downsampleFactor);
x = xScaleFactor*downsample(ConvertedData.Data.MeasuredData(4).Data,downsampleFactor);
y = yScaleFactor*downsample(ConvertedData.Data.MeasuredData(5).Data,downsampleFactor);
z = zScaleFactor*downsample(ConvertedData.Data.MeasuredData(6).Data,downsampleFactor);
t = (0:length(x)-1)*dt;
x = x - mean(x);
y = y - mean(y);
z = z - mean(z);

%Find start and end indices of extracted plot
startIdx = max(round((startPct/100 * (length(x)-1))), 1);
endIdx = round((endPct/100 * (length(x)-1)));

%Adjust variables for new indices
newapd = apd(startIdx:endIdx);
newX = x(startIdx:endIdx);
newY = y(startIdx:endIdx);
newZ = z(startIdx:endIdx);
newT = t(startIdx:endIdx);

%Store data along with new variables
newFileName = strcat('new', fileName, '.mat');
save(newFileName);

end