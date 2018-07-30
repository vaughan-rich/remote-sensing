% COLOUR IMAGE MAKER V2

clear all; close all; clc;

cornerx=1200; 
cornery=300; 
L=2500; 

ocean=double(imread('landmask.gif'));
land=1-ocean;
s=3;
S=ones(s,s);
eroded=zeros(3712,3712);

img=ocean;

for trial=1:1
for i=(s-1):(3712-s+1)
    for j=(s-1):(3712-s+1)
        
        section=img(i-1:i+1,j-1:j+1);

        cond1=isequal(section,S);
        cond2=sum(section(:))>0;

        if cond1 %|| cond2
            
            eroded(i,j)=1;
        end
    end
end
img=eroded;
end

figure
imshow(ocean-eroded)
coast=ocean-eroded;


ocean=ocean(cornery:(cornery+L-1),cornerx:(cornerx+L-1));
land=1-ocean;

coast=coast(cornery:(cornery+L-1),cornerx:(cornerx+L-1),:);


%%

c1=load('vis6cloudfreecomp.mat');
c1=c1.composite;

c2=load('vis8cloudfreecomp.mat');
c2=c2.composite;

c3=load('IR16cloudfreecomp.mat');
c3=c3.composite;


denominator=max([max(c1(:)),max(c2(:)),max(c3(:))]);





%%

w1=1;
w2=0.7556;
w3=0.3778;

block=uint8(cat(3,w1.*c1,w2.*c2,w3.*c3));

figure;

imshow(block);

logicals=logical(ocean);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ow1=1.259;
ow2=5.259;
ow3=10;

c1=block(:,:,1);
c2=block(:,:,2);
c3=block(:,:,3);

c1(logicals)=c1(logicals).*ow1;
c2(logicals)=c2(logicals).*ow2;
c3(logicals)=c3(logicals).*ow3;

figure
subplot(1,3,1)
image(c1)
axis square
colormap gray
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);

subplot(1,3,2)
image(c2)
axis square
colormap gray
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);

subplot(1,3,3)
image(c3)
axis square
colormap gray
set(gca,'YTickLabel',[]);
set(gca,'XTickLabel',[]);

newblock=uint8(cat(3,c1,c2,c3));

figure

imshow(newblock)


logicals=logical(coast);

c1=newblock(:,:,1);
c2=newblock(:,:,2);
c3=newblock(:,:,3);

c1(logicals)=0;
c2(logicals)=0;
c3(logicals)=0;

newnewblock=uint8(cat(3,c1,c2,c3));

figure


imshow(newnewblock)

%%
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

jungle=newnewblock(y1:y2,x1:x2,:);

figure

image(jungle)
