s=HI6005
s.ini;
z=s.read;

tic

figure
t=toc;y=z(:,4);
ts=plot(t,y);

for i=1:30
pause(1)
t=[t;toc];
z=s.read;
y=[y,z(:,4)];
ts.XData=t;
ts.YData=y;
end

s.close