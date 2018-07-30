%% NOW IMPLEMENT NDVI - JUST RUN THIS SECTION FOR TESTING

%CLEARING/CLOSING JUST FOR PURPOSES OF TESTING:
clear all;
close all;

%nir_pic = imread(uigetfile('*.jpg;*.png'));
%vis_pic = imread(uigetfile('*.jpg;*.png'));

%LOAD IN TWO CLOUD FREE IMAGES FOR NIR AND VIS
load('IR87cloudfreecomp.mat');
nir_pic = composite;
load('vis6cloudfreecomp.mat');
vis_pic = composite;

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

load('cmapMASK.mat');

% LAND MASK IMPLEMENTING

cornerx=1200; % 1200;
cornery=300; % 300;
L=2500; % 1000;

ocean=double(1-imread('africa.bmp'));
ocean=ocean(cornery:(cornery+L-1),cornerx:(cornerx+L-1));

NDVImask = NDVI;

logicals=logical(ocean);
NDVImask(logicals)=0.3;

figure
imagesc(NDVImask);
axis square;
colormap(cmapMASK);

% figure;
% imagesc(NDVI);
% axis square;
% colormap(cmapcompro2)

%% MEASURING SIZE OF SAHARA DESERT (Back of the envelope calculation)

load('cmapsahara.mat');

figure;
justSahara = NDVImask(325:1200,1:1900);
imagesc(justSahara);
colormap(cmapsahara);
axis equal;

SaharaLogicals = justSahara < .9720; %threshold by eye (from colormap)

count=sum(SaharaLogicals(:));

% 1 pixel is 9 square km
disp([num2str(count),' pixels are below the rough desert threshold. If one pixel is roughly 9km squared, then the Sahara desert is calculated as around ',num2str(count*9/1000000),' million km squared, vs. googled value of 9 million km squared.'])

