function [clean1]=cloudremover11(stack, ocean,L, Ly)

land=1-ocean;

dims=size(stack);

N=dims(3);
% L=dims(1);

T=mean(stack,3);

thresh3D=repmat(T,[1,1,N]);

logicals=stack<thresh3D;

num=sum((stack.*logicals),3);

den=sum(logicals,3);

variably_thresholded=num./den;

minimised=min(stack,[],3);

clean1=zeros(Ly,L);
for i=1:Ly
    for j=1:L
    clean1(i,j)=double(land(i,j).*variably_thresholded(i,j))+double(ocean(i,j)*minimised(i,j));
    end
end

end