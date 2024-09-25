load('NSALocation1Center1mHori.mat')
freq=[];h=[];
for i =1:50
    freq=[freq; result{i}.freq];
    [Y,k]= max(result{i}.result);
     h=[h;result{i}.twpos(k)];
end
figure
subplot(2,1,1)
plot(freq,h)
grid on
xlabel('freq Hz');ylabel('Antenna Position @ Maximum reading Horizontal, Tx Annt @1m ');

load('NSALocation1Center1mVertical.mat')
freq=[];h=[];
for i =1:50
    freq=[freq; result{i}.freq];
    [Y,k]= max(result{i}.result);
     h=[h;result{i}.twpos(k)];
end
subplot(2,1,2)
plot(freq,h)
grid on
xlabel('freq Hz');ylabel('Antenna Position @ Maximum reading Vertical, Tx Annt @1m ');
