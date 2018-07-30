function [clean2]=cloudremover22(stack, ocean,L, Ly)

land=1-ocean;

dims=size(stack);

N=dims(3);
% L=dims(1);

T=mean(stack,3);

thresh3D=repmat(T,[1,1,N]);

logicals=stack>thresh3D;

num=sum((stack.*logicals),3);

den=sum(logicals,3);

variably_thresholded=num./den;

minimised=max(stack,[],3);

clean2=zeros(Ly,L);
for i=1:Ly
    for j=1:L
    clean2(i,j)=double(land(i,j).*variably_thresholded(i,j))+double(ocean(i,j)*minimised(i,j));
    end
end

end