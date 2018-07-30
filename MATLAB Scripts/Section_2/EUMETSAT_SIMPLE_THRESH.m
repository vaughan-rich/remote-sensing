% EUMETSAT SIMPLE THRESHOLDING TOOL

clear all;
close all;
clc;

% Load in an image to look at
name = uigetfile('*.jpg;*.png');
img1 = imread(name);

%% Create UI

% Maximise the figure
scrsz = get(groot,'ScreenSize');
figure('name','Simple Thresholding Tool','Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
set(gcf,'units','normalized','outerposition',[0 0 1 1]);

% Create Off button
onoff = uicontrol('Style', 'pushbutton', 'String', 'Power Off',...
    'Position', [30 35 80 80],...
    'Callback', 'off=1');

% Greylevel Slider:
greylevel_slider = uicontrol('Style','slider','Position',[20 140 150 20],...
    'SliderStep',[1/255 2/255],'Max',255,'Min',0,'Value',35);
uicontrol('Style','text','Position',[15 165 160 20],'String','Greylevel Threshold:','FontSize',13);


%% Perform Thresholding

off = 0;
threshold1 = 35;
thresh_hw = 10;

while off == 0
    
    greylevel = round(greylevel_slider.Value);
    uicontrol('Style','text','Position',[15 165 160 20],'String',['Greylevel Threshold = ',num2str(greylevel)],'FontSize',13);
    
    threshold1 = greylevel_slider.Value;
    
    logicals = img1 > threshold1;
    
    newimg = zeros(3712,3712);
    newimg(logicals) = 1;
    
    subplot(1,3,1)
    histogram(img1(img1>0));
    % Filenaming convention means title only displays properly for WV/IR
    title(['Greylevel Histogram for ',name(7:8),name(10:12)]);
    hold on;
    plot([threshold1,threshold1],[0,5*10^5],'LineWidth',2);
    hold off
    subplot(1,3,2)
    imshow(newimg);
    title('Thresholded Image');
    subplot(1,3,3)
    imshow(img1);
    title('Original Image');
    
    
    drawnow;
end

close all;
disp('Program Ended');

figure;
histogram(img1(img1>0));
hold on;
plot([threshold1,threshold1],[0,5*10^5],'LineWidth',2);
figure
subplot(1,2,1);
imshow(img1);
subplot(1,2,2);
imshow(newimg);

