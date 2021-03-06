close all
clear all

num = 10000;

A = [ -8/3 0 0; 0 -10 10; 0 28 -1 ];

y = zeros(3,num+1);
y(:,1) = [35 -10 -7]';

h = 0.01;
p = plot3(y(1),y(2),y(3),'.', ...
    'EraseMode','none','MarkerSize',5); % Set EraseMode to none
axis([0 50 -25 25 -25 25])
hold on
for i=1:num
    A(1,3) = y(2,i);
    A(3,1) = -y(2,i);
    ydot = A*y(:,i);
    y(:,i+1) = y(:,i) + h*ydot;
    % Change coordinates
 %   set(p,'XData',y(1,i),'YData',y(2,i),'ZData',y(3,i)) 
 %   drawnow 
%     i=i+1;
end

figure,plot(y(1,:))
figure,plot(y(2,:))
figure,plot(y(3,:))

lorenz2 = y(1,:);
save lorenz.mat lorenz2

%%
figure
p = plot3(y(1),y(2),y(3),'.', ...
    'EraseMode','none','MarkerSize',5); % Set EraseMode to none
axis([0 50 -25 25 -25 25])
hold on
for i=1:2000
   % Change coordinates
   set(p,'XData',y(1,i),'YData',y(2,i),'ZData',y(3,i)) 
   drawnow 
end