%=========================================================================
% volumeOfPore.m
%   Loads a tracking file with user set parameters and calculates the
%   volume of a set pore. Given the start and end indices, the function
%   utilizes principal component analysis to best approximate the volume of
%   an ellipsoid shaped pore.
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
function volumeOfPore(fileName, params)

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

%Combine x,y,z vectors into one matrix for PCA
combine = horzcat(x(startIdx:endIdx), y(startIdx:endIdx), z(startIdx:endIdx));

%PCA and extract new coordinates of data following PCA
[coeff, score, latent] = pca(combine);

%Create 3 new zero vectors to store new coordinates
adjX = zeros(1, (endIdx-startIdx+1));
adjY = zeros(1, (endIdx-startIdx+1));
adjZ = zeros(1, (endIdx-startIdx+1));

%Fill vectors
for i = 1:(endIdx-startIdx+1)
    adjX(i) = score(i, 1);
    adjY(i) = score(i, 2);
    adjZ(i) = score(i, 3);
end

display(latent)
%Calculates the max and min of the x,y,z vectors to find lengths of axis
maxX = max(adjX);
maxY = max(adjY);
maxZ = max(adjZ);
minX = min(adjX);
minY = min(adjY);
minZ = min(adjZ);

%Finds the length of the 3 orthogonal vectors for volume calculation
a = ((maxX-minX)/2);
b = ((maxY-minY)/2);
c = ((maxZ-minZ)/2);

%Volume of ellipsoid formula
volume = (4/3)*pi*a*b*c;

%Display semi-principal axis
fprintf('a is %f um^3 \n' , a)
fprintf('b is %f um^3 \n' , b)
fprintf('c is %f um^3 \n' , c)

%Display volume
fprintf('The volume is %f um^3 \n' , volume);

%Create biplot of data
vbls = {'x-axis','y-axis','z-axis'};
clf
biplot(coeff, 'scores', score, 'varlabels', vbls, 'color', [0.75294118 0.16078431 0.25882353], 'markers', 8);
hold on

end