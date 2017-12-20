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
%           startPct: place to begin in the data as a percentage [0,100]
%           endPct: place to end in the data as a percentage [0,100]
%           firstFigNum: number of figure to use
%
%   OUTPUT: none.
%
%   Written by: Sean Andersson
%=========================================================================
function plotConfocalTrackingData(fileName,params);

% First extract the needed parameters
startPct = params.startPct/100;
endPct = params.endPct/100;
dt = params.dt;
downsampleFactor = params.downsampleFactor;
firstFigNum = params.firstFigNum;

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
%x = x(startIdx:endIdx);
%y = y(startIdx:endIdx);
%z = z(startIdx:endIdx);
t = t(startIdx:endIdx);

display(endIdx)
display(size(x));
display(size(y));
display(size(z));
% Now plot them
% figure(firstFigNum)
% clf
% h(1) = subplot(411);
% plot(t,x,'linewidth',2)
% ylabel('X Position [um]')
% title('Particle Position Components and Intensity versus Time')
% xlim([t(1) t(end)])
% set(gca,'fontsize',10);
% 
% h(2) = subplot(412);
% plot(t,y,'linewidth',2)
% ylabel('Y Position [um]')
% xlim([t(1) t(end)])
% set(gca,'fontsize',10);
% 
% h(3) = subplot(413);
% plot(t,z,'linewidth',2)
% ylabel('Z Position [um]')
% xlim([t(1) t(end)])
% set(gca,'fontsize',10);
% 
% h(4) = subplot(414);
% plot(t,apd,'linewidth',2)
% tix=get(gca,'ytick')';
% set(gca,'yticklabel',num2str(tix,'%.1f'))
% ylabel(['Intensity [cts/' num2str(1000*dt) 'ms]'])
% xlabel('Time [s]')
% xlim([t(1) t(end)])
% linkaxes(h,'x');
% set(gca,'fontsize',10);

figure(firstFigNum+1);
clf;
colorspec = {[0.75294118 0.16078431 0.25882353]; [0.3254902 0.46666667 0.47843137]};

%plot3(x,y,z,'linewidth',2);
 plot3(x(881:1240),y(881:1240),z(881:1240), 'Color', colorspec{1})
 hold on
 plot3(x(1241:1279),y(1241:1279),z(1241:1279), 'Color', colorspec{2})
 hold on
 plot3(x(1280:1640),y(1280:1640),z(1280:1640), 'Color', colorspec{1})
 hold on
 plot3(x(1641:1799),y(1641:1799),z(1641:1799), 'Color', colorspec{2})
 hold on
 plot3(x(1800:2000),y(1800:2000),z(1800:2000), 'Color', colorspec{1})
 hold on
 plot3(x(2001:2119),y(2001:2119),z(2001:2119), 'Color', colorspec{2})
 hold on
 plot3(x(2120:3200),y(2120:3200),z(2120:3200), 'Color', colorspec{1})
 hold on
 plot3(x(3201:3240),y(3201:3240),z(3201:3240), 'Color', colorspec{2})
 hold on
 plot3(x(3241:3560),y(3241:3560),z(3241:3560), 'Color', colorspec{1})
 hold on

 

% plot3(x,y,z,'linewidth',2);
xlabel('X Position [um]');
ylabel('Y Position [um]');
zlabel('Z Position [um]');
title('3D Plot of a Multiple Pores')
set(gca,'fontsize',10);
axis equal
grid on