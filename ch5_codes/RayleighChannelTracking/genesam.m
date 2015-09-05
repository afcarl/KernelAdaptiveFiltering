function X=genesam(x,F,Q) %generate new samples
[xn,D]=size(x); % x is xn*D sample column vector
v=zeros(xn,D);
for i=1:D
    v(:,i)= normrnd(0,sqrt(Q(i))*ones(xn,1));
end
X=x*F+v;  % new samples generated by system fk(.,.)
