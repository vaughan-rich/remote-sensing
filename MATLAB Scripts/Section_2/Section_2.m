% Cloud Removal Figure Creation V1

% PLAN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% FIG 1
% Typical reference images: 2x2 grid of random images

% FIG 2
% Mean image
% CFI./NCF (including nan holes)
% Minimisation
% Standard deviation (+1 sigma)

% FIG 3
% Histograms corresponding to FIG 2

% FIG 4
% FIXED AVERAGING: Variable thresholding, Threshold_array=mean(stack)

% FIG 5
% Histogram of FIG 4 data

% FIG 6

% Variable-thresholded image vs minimisation image vs composite image

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc;

sc=0; % IMAGESC VS IMAGE

% Define section of the image

cornerx=1200; % 1200;
cornery=300; % 300;
L=2000; % 1000;

%%%%%%%%%% READING IN FILES %%%%%%%%%%%%%

% Define black list of non-existant/crappy images
blacklist1=[120510:120513];
blacklist2=[120515:120516];
blacklist3=[120518, 120526, 120319,120417, 120317];

blacklist=[blacklist1,blacklist2,blacklist3];

N=97-length(blacklist); % calculate number of valid days

date_array=cell(N,1); % Initialise array to hold each date

daymon=[0, 0, 31, 30, 31, 14]; % Number of days in each month
startdaymon=[0, 0, 10, 1, 1, 1]; % Start date for each month

el=1;

for mon=3:6 % Cycle through each month
    
    for day=startdaymon(mon):daymon(mon) % Cycle through the days of that month
        
        % Create date string
        if day<10
            date=['120',num2str(mon),'0',num2str(day)];
        else
            date=['120',num2str(mon),num2str(day)];
        end
        
        % Check if date is on the blacklist
        allowed=1;
        for n=1:length(blacklist)
            if num2str(blacklist(n))==date
                allowed=0;
                
            end
        end
        
        % Add date to the cell array
        if allowed==1
            date_array{el}=date;
            el=el+1;
        end
    end
end

% SELECT APPROPRIATE CHANNEL NAME

% spect_array=cell(12,1);
% spect_array{1}='HMSG2_HRV_';
spect_name='HMSG2_VIS006_';
% spect_array{3}='HMSG2_IR_039_';
% spect_array{4}='HMSG2_IR_087_';
% spect_array{5}='HMSG2_IR_097_';
% spect_array{6}='HMSG2_IR_108_';
% spect_array{7}='HMSG2_IR_120_';
% spect_array{8}='HMSG2_IR_134_';
% spect_array{9}='HMSG2_VIS006_';
% spect_array{10}='HMSG2_VIS008_';
% spect_array{11}='HMSG2_WV_062_';
% spect_array{12}='HMSG2_WV_073_';

% Initialise stack of image - Z-axis represents time
stack=zeros(L,L,N);

% For each day, extract the relevant image and crop the important area
for daynum=1:N
    
    name=[spect_name,date_array{daynum},'_1200.jpg'];
    
    img=imread(name);
    
    chunk=img(cornery:(cornery+L-1),cornerx:(cornerx+L-1));
    
    stack(:,:,daynum)=chunk;
    
    progress=100*daynum/N
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Reference Images - Randomly Selected Un-processed Images

figure
for plotnum=1:4
    subplot(2,2,plotnum)
    reference=stack(:,:,randi(N));
    if sc==1
        imagesc(reference)
    else
        image(reference)
    end
    colormap gray
    axis square
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);
end
drawnow
% title('Reference Image')


%% 4way fig including: mean image, golbal thresholded, minimised, +1 sigma

% MEAN IMAGE = IMG1
img1=mean(stack,3);

% GLOBALLY THRESHOLDED IMAGE = IMG2

NCF=zeros(L,L);
CFI=zeros(L,L);

for daynum=1:N
    
    data=stack(:,:,daynum);
    logicals=data<88;
    NCF=NCF+(logicals);
    newdata=data.*(logicals);
    CFI=CFI+newdata;
end

img2=CFI./NCF;

% MINIMISED IMAGE = IMG3

img3=min(stack,[],3);

% SIGMA IMAGE = IMG4

sigma=1;

bar=img1+sigma*std(stack,0,3);

thresh3D=repmat(bar,[1,1,N]);

logicals=stack<thresh3D;

num=sum((stack.*logicals),3);

den=sum(logicals,3);

img4=num./den;

%% Plotting

figure

if sc==0
    
    subplot(2,2,1)
    image(img1)
    axis square
    colormap gray
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);

    
    
    subplot(2,2,2)
    image(img2)
    axis square
    colormap gray
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);
    
    subplot(2,2,3)
    image(img3)
    axis square
    colormap gray
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);
    
    subplot(2,2,4)
    image(img4)
    axis square
    colormap gray
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);
    
else
    
    subplot(2,2,1)
    imagesc(img1)
    axis square
    colormap gray
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);
    
    
    subplot(2,2,2)
    imagesc(img2)
    axis square
    colormap gray
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);
    
    
    subplot(2,2,3)
    imagesc(img3)
    axis square
    colormap gray
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);
    
    subplot(2,2,4)
    imagesc(img4)
    axis square
    colormap gray
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);
    
end

figure

    subplot(2,2,1)
    histogram(img1)
    xlim([0 255])
    xlabel('Pixel Range')
    ylabel('Frequency')
    
    subplot(2,2,2)
    histogram(img2)
xlim([0 255])
    xlabel('Pixel Range')
    ylabel('Frequency')
    
    subplot(2,2,3)
    histogram(img3)
xlim([0 255])
    xlabel('Pixel Range')
    ylabel('Frequency')
    
    subplot(2,2,4)
    histogram(img4)
xlim([0 255])
    xlabel('Pixel Range')
    ylabel('Frequency')
%% Variable thresholding 

T=mean(stack,3);

thresh3D=repmat(T,[1,1,N]);

logicals=stack<thresh3D;

num=sum((stack.*logicals),3);

den=sum(logicals,3);

img5=num./den;

figure

if sc==0
    
    image(img5)
    axis square
    colormap gray
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);
    
else
    
%     surf(img5,'EdgeColor','none')
    imagesc(img5)
    axis square
    colormap gray
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);
    
end

figure
histogram(img5)
xlim([0 255])
    xlabel('Pixel Range')
    ylabel('Frequency')

%% Composite Image

ocean=double(imread('landmask.gif'));
ocean=ocean(cornery:(cornery+L-1),cornerx:(cornerx+L-1));
land=1-ocean;
composite=zeros(L,L);
for i=1:L
    for j=1:L
    composite(i,j)=double(land(i,j).*img3(i,j))+double(ocean(i,j)*img3(i,j));
    end
end

figure

if sc==1
subplot(1,3,1)
imagesc(img5)
colormap gray
axis square
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);

subplot(1,3,2)
imagesc(img3)
colormap gray
axis square
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);
    
subplot(1,3,3)
imagesc(composite)
colormap gray
axis square
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);
    
else
    
    subplot(1,3,1)
image(img5)
colormap gray
axis square
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);

subplot(1,3,2)
image(img3)
colormap gray
axis square
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);
    
subplot(1,3,3)
image(composite)
colormap gray
axis square
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);
    
end

%%
figure
if sc==1
imagesc(composite)
else
    image(composite)
end
colormap gray
axis square
    set(gca,'YTickLabel',[]);
    set(gca,'XTickLabel',[]);


