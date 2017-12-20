%=========================================================================
% plotConfocalTrackingData.m
%   M file to load and plot data acquired from a confocal tracking run.
%   Will look for a mat file by the given name or, failing to find that, a
%   tdms file that will be converted.
%
%   INPUTS:
%       fileName: name of the file to work with
%       params: a structure of parameters to use that has the entries
%           dt: sampling rate of the data set (in sec)
%           downsampleFactor: how much to reduce the data by in plotting
%                   (default = 1 (plot all))
%           startPct: place to begin in the data as a percentage [0,100]
%                   (default = 0)
%           endPct: place to end in the data as a percentage [0,100]
%                   (default = 100)
%           firstFigNum: number of figure to use
%                   (default = 1);
%
%   OUTPUT: none.
%
%   Written by: Sean Andersson
%=========================================================================
function plotConfocalTrackingData(fileName,params);

% First extract the needed parameters
if sum(strcmp(fieldnames(params), 'startPct')) == 1
    startPct = params.startPct/100;
else
    startPct = 0;
end
if sum(strcmp(fieldnames(params), 'endPct')) == 1
    endPct = params.endPct/100;
else
    endPct = 1;
end
if sum(strcmp(fieldnames(params), 'downsampleFactor')) == 1
    downsampleFactor = params.downsampleFactor;
else
    downsampleFactor = 1;
end
if sum(strcmp(fieldnames(params), 'firstFigNum')) == 1
    firstFigNum = params.firstFigNum;
else
    firstFigNum = 1;
end
dt = params.dt;

% Conversion factors since position data is in volts
xScaleFactor = 5; % um / V
yScaleFactor = 5; % um / V
zScaleFactor = 2.5; % um / V

% Now load up the data
if(exist([fileName '.mat'],'file')==2)
    load([fileName '.mat'])
else
    convertTDMS(1,[fileName '.tdms']);
    load([fileName '.mat'])
end

% Scale, Translate, and Downsample data
apd = downsample(ConvertedData.Data.MeasuredData(3).Data,downsampleFactor);
x = xScaleFactor*downsample(ConvertedData.Data.MeasuredData(4).Data,downsampleFactor);
y = yScaleFactor*downsample(ConvertedData.Data.MeasuredData(5).Data,downsampleFactor);
z = zScaleFactor*downsample(ConvertedData.Data.MeasuredData(6).Data,downsampleFactor);
t = (0:length(x)-1)*dt;
x = x - mean(x);
y = y - mean(y);
z = z - mean(z);

startIdx = max(round(startPct*length(x)),1);
endIdx = round(endPct*length(x));
apd = apd(startIdx:endIdx);
x = x(startIdx:endIdx);
y = y(startIdx:endIdx);
z = z(startIdx:endIdx);
t = t(startIdx:endIdx);

% Now plot them
figure(firstFigNum)
clf
h(1) = subplot(411);
plot(t,x,'linewidth',2)
ylabel('X Position [um]')
xlim([t(1) t(end)])
set(gca,'fontsize',16);

h(2) = subplot(412);
plot(t,y,'linewidth',2)
ylabel('Y Position [um]')
xlim([t(1) t(end)])
set(gca,'fontsize',16);

h(3) = subplot(413);
plot(t,z,'linewidth',2)
ylabel('Z Position [um]')
xlim([t(1) t(end)])
set(gca,'fontsize',16);

h(4) = subplot(414);
plot(t,apd,'linewidth',2)
ylabel(['Intensity [cts / ' num2str(1000*dt) ' ms]'])
xlabel('Time [s]')
xlim([t(1) t(end)])
linkaxes(h,'x');
set(gca,'fontsize',16);

figure(firstFigNum+1);
clf;
plot3(x,y,z,'linewidth',2);
xlabel('X Position [um]');
ylabel('Y Position [um]');
zlabel('Z Position [um]');
set(gca,'fontsize',16);
axis equal
grid on