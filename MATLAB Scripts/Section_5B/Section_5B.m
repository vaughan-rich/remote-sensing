%FRIDAY
clear all; close all; clc;


blacklist={'110302';'110621';'110118'; ...
    '111220';'110228';'110303';'110419'};

% SQUARE SELECTION
L=500;
x1=850;
x2=x1+L-1;

y1=920;
y2=y1+L-1;

zoomy=3;
middle=round((y1+y2)/2);
step=round(L/zoomy);
y1=middle-step;
y2=middle+step-1;

Ly=2*step;

%%


cornerx=1200;
cornery=300;

% LOADING STUFF IN

load('cmapMASK.mat');

ocean=double(imread('africa.bmp'));
ocean=ocean(cornery:(cornery+2500-1),cornerx:(cornerx+2500-1));
ocean=ocean(y1:y2,x1:x2);
land=1-ocean;

brown=0.9729;
green=1.0907;

%%%%%%%%%% READING IN FILES %%%%%%%%%%%%%

% Define black list of non-existant/crappy images

directory=dir;


%%
% N=((length(directory)-8)/2)-length(blacklist); % calculate number of valid days
numfiles=2;
direcN=length(directory)-2-numfiles;

% date_array=cell(N,1); % Initialise array to hold each date

daymon=[0, 0, 31, 30, 31, 14]; % Number of days in each month
startdaymon=[0, 0, 10, 1, 1, 1]; % Start date for each month

N=325-length(blacklist);

% Initialise stack of image - Z-axis represents time
stack1=zeros(Ly,L,N);
stack2=zeros(Ly,L,N);
figure
% For each day, extract the relevant image and crop the important area
ircount=1;
viscount=1;
% time=zeros(1,N);

for direcnum=3:(direcN)
    
    
    name=directory(direcnum).name;
    
    testname=name(14:19);
    
    allowed=1;
    for n=1:length(blacklist)
        if num2str(blacklist{n})==testname
            allowed=0;
            
        end
    end
    
    % Add date to the cell array
    if allowed==1
        
        if name(7)=='V'
            img=imread(name);
            chunk=img(cornery:(cornery+2500-1),cornerx:(cornerx+2500-1));
            chunk=chunk(y1:y2,x1:x2);
            stack1(:,:,viscount)=chunk;
            date{viscount}=testname;
            viscount=viscount+1;
        else
            
            img=imread(name);
            chunk=img(cornery:(cornery+2500-1),cornerx:(cornerx+2500-1));
            chunk=chunk(y1:y2,x1:x2);
            stack2(:,:,ircount)=chunk;
            
            month{direcnum}=str2num(name(16:17));
            day{direcnum}=str2num(name(18:19));
            %     name(18:19)
            
            daymon=[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
            
            
            if month{direcnum}==1
                time(ircount)=day{direcnum}/365;
            else
                time(ircount)=(sum(daymon(1:(month{direcnum}-1)))+day{direcnum})/365;
            end
            ircount=ircount+1;
        end
        
        
        
%             imagesc(chunk)
%             drawnow
%             pause(0.2)
    end
    
    
    
    progress=100*direcnum/(direcN)
end

% CREATE 'PERFECT' CLOUD FREE IMAGE
%%
[ref1]=cloudremover11(stack1, ocean,L, Ly);
[ref2]=cloudremover22(stack2, ocean, L, Ly);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%%
figure

movie=cell(N,1);
% blank1=ones(L,L);
% blank2=ones(L,L);
% blank3=ones(L,L);

for daynum=1:N
    
    img1=stack1(:,:,daynum);
    img2=stack2(:,:,daynum);
    
    clouds1=(img1-ref1);
    clouds2=(img2-ref2);
    
    %     logical1 = clouds1<(mean(clouds1(:)));%%%%% ROOT OF ALL EVIL
    %     logical2 = clouds2>(mean(clouds2(:)));
    
    logical1 = clouds1<10; %( mean(clouds1(:))  -std(clouds1(:))  );%%%%% ROOT OF ALL EVIL COPIED
    logical2 = clouds2>-60; %( mean(clouds2(:))  +std(clouds2(:))  );
    
    combined = logical1 + logical2;
    
    poc=combined>=1;
    %     imagesc(poc)
    %     drawnow
    
    %     pause(0.25)
    
    nir_pic=stack2(:,:,daynum);
    vis_pic=stack1(:,:,daynum);
    
    %%% GET RID OF THE CLOUDS!!!
    
    %%%%
    
    [NDVI]=func3(nir_pic,vis_pic,ocean);
    
    NDVI(poc~=1)=nan;
    
    bottom(daynum)=min(NDVI(:));
    top(daynum)=max(NDVI(:));
    
    
    %     disp(['BOTTOM: ',num2str(bottom),' TOP:',num2str(top)])
    
    %     NDVI(NDVI>1.917)=1.917;%%%%%%%%%%%
    %     NDVI(NDVI<0.3)=0.3;
    %
    %     imagesc(NDVI)
    %     drawnow
    %     histogram(NDVI)
    % %     xlim([0.3 1.95])
    %     ylim([0 30000])
    %     drawnow
    %     colormap(cmapMASK)
    bollock1 = NDVI<0.3;
    bollock2 = NDVI>1.917;
    
    bollocks=bollock1+bollock2;
    
    bollocks=bollocks>=1;
    
    %     subplot(1,2,1)
    %     imagesc(poc)
    %     axis equal
    %     subplot(1,2,2)
    %     imagesc(bollocks)
    %     axis equal
    %     drawnow
    
%     brownlogic=NDVI<brown;
%     greenlogic=NDVI>brown;
    brownlogic=NDVI<1;
    greenlogic=NDVI>1;    


    binarised=0.7*ones(Ly,L);
    binarised(greenlogic)=1.2;
%         subplot(1,2,1)
%         imagesc(vis_pic)
%         axis equal
%         colormap gray
    
%         subplot(1,2,2)
%         imagesc(binarised)
%         drawnow
%         pause(0.5)
%         colormap(cmapMASK)
    % %
    ratio(daynum)=sum(sum(greenlogic.*poc))/sum(poc(:));
    
    greenery=logical(greenlogic.*poc);
    brownery=logical(brownlogic.*poc);
    
%     pic=ones(L,L);
%     pic(greenery)=0.5;
%     pic(brownery)=0;
    pic=255.*ones(Ly,L,3);
    pic(:,:,1)=139*ones(Ly,L).*brownery;
    pic(:,:,2)=69*ones(Ly,L).*brownery;
    pic(:,:,3)=19*ones(Ly,L).*brownery;
    
%     pic(:,:,1)=pic(:,:,1)-1.*greenery;
    pic(:,:,2)=pic(:,:,2)+255.*greenery;
%     pic(:,:,3)=pic(:,:,2)-1.*greenery;
    
    
    
%     imshow(uint8(pic))
    movie{daynum}=pic;
%     title(['Fraction through the year = ',num2str(time(daynum))])
%     drawnow
    
    error(daynum)=(L*Ly)-sum(poc(:));
    
    %     progress=100*daynum/N
    
end

figure
subplot(2,1,1)
plot(time,ratio,'k-')
title('ratio')
ylim([0 1])
drawnow
hold on
subplot(2,1,2)
plot(time,error/(Ly*L),'k-')
ylim([0 1])
title('Cloud Cover')

figure
subplot(1,2,1)
histogram(bottom,100)
subplot(1,2,2)
histogram(top,100)

off_the_bottom=sum(bottom<0.3)/N
off_the_top=sum(top>1.917)/N

 
%%
x=time(1:(end-2));
y=ratio(1:(end-2)); %-mean(ratio);

[fitresult, gof] = createFit2(x, y)
xlabel('Time (Years)')
ylabel('F')

%%
figure

    sld = uicontrol('Style', 'slider',...
        'Min',1,'Max',N-2,'Value',41,...
        'Position', [200 20 600 20]); 
    
    days(1)=62;
    days(2)=147;
    days(3)=210;
    days(4)=288;

% while 1==1
% 
%     n=round(sld.Value);
%     pic=movie{n};
%     image(uint8(pic))
%     title(date{n})
%     drawnow
% %     axis square
%     pbaspect([1 1 1])
% end
%%
    figure
for el=1:4
    pic=movie{days(el)};
    subplot(2,2,el)
    image(uint8(pic))
    set(gca,'YTick',[])
    set(gca,'XTick',[])
    pbaspect([L Ly 1])
%     imwrite(uint8(pic),['jungle_divide_',num2str(days(el)),'.jpg']);
    ratio(days(el))
end
disp('Done')