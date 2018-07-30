%% NOW IMPLEMENT NDVI - JUST RUN THIS SECTION FOR TESTING

%CLEARING/CLOSING JUST FOR PURPOSES OF TESTING:
clear all;
close all;

%nir_pic = imread(uigetfile('*.jpg;*.png'));
%vis_pic = imread(uigetfile('*.jpg;*.png'));

%LOAD IN TWO CLOUD FREE IMAGES FOR NIR AND VIS
load('750x750alpsIR120.mat');
nir_pic = composite;
load('750x750alpsVIS6.mat');
vis_pic = composite;

figure
imagesc(nir_pic);
title('Cloud Free IR120 Image');
colormap gray;
axis square;
figure
imagesc(vis_pic);
title('Cloud Free VIS06 Image');
colormap gray;
axis square;

% Calibration values from JPG values


% FOR IR120
Cal_Offset120=-11.337868
Cal_Slope120=0.222311
% FOR IR97
Cal_Offset97=-5.302006;
Cal_Slope97=0.103961;
% FOR IR87
Cal_Offset87=-6.463960;
Cal_Slope87=0.126744;
% FOR VIS06
Cal_Offset06=-1.041374;
Cal_Slope06=0.020419;

calOffsetNir = Cal_Offset120;
calSlopeNir = Cal_Slope120;
calOffsetVis = Cal_Offset06;
calSlopeVis = Cal_Slope06;

% Calculate Rs and NDVI
RNir = calOffsetNir + (calSlopeNir * nir_pic);
RVis = calOffsetVis + (calSlopeVis * vis_pic);

NDVI_top = (RVis - RNir);
NDVI_bot = (RNir + RVis);

NDVI = NDVI_top./NDVI_bot;

figure;
histogram(NDVI);
title('Histogram of NDVI values');

% LAND MASK IMPLEMENTING

cornerx=1600; % 1200;
cornery=200; % 300;
L=750; % 1000;

ocean=double(imread('landmask.gif'));
ocean=ocean(cornery:(cornery+L-1),cornerx:(cornerx+L-1));

NDVImask = NDVI;

logicals=logical(ocean);
NDVImask(logicals)=0;

figure;
imagesc(NDVI);
axis square;
colormap gray;
title('standard NDSI');

load('cmapsnowindex.mat');

figure
imagesc(NDVImask);
axis square;
colormap(cmapsnowindex);
title('NDSI with mask');

% BARE IN MIND - ALPS APPEAR AS THEY ARE HIGHEST (THEY HAVE SNOW ALL YEAR -
% GLACIAL AND WELL ABOVE 3000m+ - THE PYRENEES A LITTLE BIT LOWER (BARELY
% SHOW) AND THE APENNINES NOT AT ALL. MAYBE THEYD SHOW MORE IF THE AVERAGE
% IMAGE WAS TAKEN DURING WINTER (THIS IS BETWEEN MARCH+JUNE 2012).

 %set(gca,'XTickLabel',[]);set(gca,'YTickLabel',[]);

