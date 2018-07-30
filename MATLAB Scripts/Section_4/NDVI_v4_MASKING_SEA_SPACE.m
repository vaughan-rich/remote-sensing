%% NOW IMPLEMENT NDVI - JUST RUN THIS SECTION FOR TESTING

%CLEARING/CLOSING JUST FOR PURPOSES OF TESTING:
clear all;
close all;

%nir_pic = imread(uigetfile('*.jpg;*.png'));
%vis_pic = imread(uigetfile('*.jpg;*.png'));

%LOAD IN TWO CLOUD FREE imagescS FOR NIR AND VIS
load('IR87cloudfreecomp.mat');
nir_pic = composite;
load('vis6cloudfreecomp.mat');
vis_pic = composite;

figure
imagesc(nir_pic);
title('Cloud Free IR087 imagesc');
colormap gray;
axis square;
figure
imagesc(vis_pic);
title('Cloud Free VIS06 imagesc');
colormap gray;
axis square;

% Calibration values from JPG values

% FOR IR97
Cal_Offset97=-5.302006;
Cal_Slope97=0.103961;
% FOR IR87
Cal_Offset87=-6.463960;
Cal_Slope87=0.126744;
% FOR VIS06
Cal_Offset06=-1.041374;
Cal_Slope06=0.020419;

calOffsetNir = Cal_Offset87;
calSlopeNir = Cal_Slope87;
calOffsetVis = Cal_Offset06;
calSlopeVis = Cal_Slope06;

% Calculate Rs and NDVI
RNir = calOffsetNir + (calSlopeNir * nir_pic);
RVis = calOffsetVis + (calSlopeVis * vis_pic);

NDVI_top = (RNir - RVis);
NDVI_bot = (RNir + RVis);

NDVI = NDVI_top./NDVI_bot;

figure;
histogram(NDVI);
title('Histogram of NDVI values');
figure
imagesc(NDVI);
axis square;
colormap gray;


% Looking for values beneath 1 - can be changed based on histogram
NDVI2 = (NDVI < 1);

figure
imshow(NDVI2);
title('NDVI with all values less than 1 forced to white (picking up barren terrain + the alps?)');
colormap gray;
axis square;

load('colormapsv1.mat');
load('cmapcompro2.mat');
load('cmapMASK.mat');

figure
ax1 = subplot(1,5,1);
imagesc(NDVI);
axis square;
colormap(ax1,cmapharsh);
ax2 = subplot(1,5,2);
imagesc(NDVI);
axis square;
colormap(ax2,cmapwide);
ax3 = subplot(1,5,3);
imagesc(NDVI);
axis square;
colormap(ax3,cmapreflectances);
ax4 = subplot(1,5,4);
imagesc(NDVI);
axis square;
colormap(ax4,cmapcompro);
ax5 = subplot(1,5,5);
imagesc(NDVI);
axis square;
colormap(ax5,cmapcompro2);

% LAND MASK IMPLEMENTING

cornerx=1200; % 1200;
cornery=300; % 300;
L=2500; % 1000;

ocean=double(imread('landmask.gif'));
ocean=ocean(cornery:(cornery+L-1),cornerx:(cornerx+L-1));

NDVImask = NDVI;

logicals=logical(ocean);
NDVImask(logicals)=0.3;

figure
imagesc(NDVImask);
axis square;
colormap(cmapMASK);

figure;
imagesc(NDVI);
axis square;
colormap(cmapcompro2)

