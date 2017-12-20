%=========================================================================
% fitToSphere.m
%   Loads a tracking file with user set parameters and calculates the
%   volume of a set pore by fitting the data to a sphere. Given the start
%   and end indices, the function uses midpoint analysis to approximate the
%   volume of the pore.
%
%   INPUTS:
%       fileName: name of the file to work with
%       startPct: index referencing start of pore as a percentage [0,100]
%       endPct: index referencing end of pore as a percentage [0,100]
%       downsampleFactor: how much to reduce the data
%
%   OUTPUT: none
%
%   Written by: Eric Gan
%=========================================================================
function fitToSphere(fileName, params)

%Set parameters
startPct = params.startPct/100;
endPct = params.endPct/100;
downsampleFactor = params.downsampleFactor;

%Conversion factor since position data is in volts
xScaleFactor = 5; % um / V
yScaleFactor = 5; % um / V
zScaleFactor = 2.5; % um / V

%Load the data
if(exist([fileName '.mat'],'file')==2)
    load([fileName '.mat'])
else
    convertTDMS(1,[fileName '.tdms']);
    load([fileName '.mat'])
end

% Scale, Translate, and Downsample data
x = xScaleFactor*downsample(ConvertedData.Data.MeasuredData(4).Data,downsampleFactor);
y = yScaleFactor*downsample(ConvertedData.Data.MeasuredData(5).Data,downsampleFactor);
z = zScaleFactor*downsample(ConvertedData.Data.MeasuredData(6).Data,downsampleFactor);
x = x - mean(x);
y = y - mean(y);
z = z - mean(z);

%Find start and end indices of extracted plot
startIdx = ceil((startPct *(length(x)))+0.001);
endIdx = round((endPct *(length(x))));

%Finds the max and min values of x,y,z vectors within restricted parameters
maxX = max(x(startIdx:endIdx));
maxY = max(y(startIdx:endIdx));
maxZ = max(z(startIdx:endIdx));
minX = min(x(startIdx:endIdx));
minY = min(y(startIdx:endIdx));
minZ = min(z(startIdx:endIdx));

%Finds the midpoint of x,y,z to approximate the center of sphere
midX = ((maxX+minX)/2);
midY = ((maxY+minY)/2);
midZ = ((maxZ+minZ)/2);

%Creates a zero vector to store distances
distance = zeros(1, (endIdx-startIdx+1));

%Calculates distance from each point to approximated center
for i = (1: endIdx-startIdx+1)
    distance(i) = sqrt(((x(i + startIdx - 1)-midX)^2)+((y(i + startIdx - 1)-midY)^2)+((z(i + startIdx - 1)-midZ)^2));
end

%Finds radius to encompass all points
radius = max(distance);

%Volume of sphere formula
volume = (4/3)*pi*(radius^3);

%Display volume
fprintf('The volume is %f um^3 \n' , volume);

end