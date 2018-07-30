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

% LAND MASK IMPLEMENTING

cornerx=1600; % 1200;
cornery=200; % 300;
L=750; % 1000;

NDVIalps = NDVI(157:337,372:644);
figure;
imagesc(NDVIalps);
axis equal;
%title('NDVI, zoomed in on alps');
colormap gray;

alpsLogical = NDVIalps >= -0.9889;
count = sum(alpsLogical(:));

%314070km squared is size of alps + dolomites.
perc = (100*count*9)/314070;

disp([num2str(count),' pixels (roughly 9189km squared of mountain) are covered with snow (from avg image between march and june). This is about ',num2str(perc),' percent of the size of the alps and dolomites.']);
