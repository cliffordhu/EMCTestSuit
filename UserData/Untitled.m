global s

% set channel 2
s.rfsw.select(0)

% set freq and amplitude
freq=1000e6
s.hf.amp(-30)
s.hf.freq(freq)
s.hf.On

s.amp1.gain(1024)
s.amp1.on

s.amp1.gain(1024)
s.hf.amp(-40)
s.ps2.read(freq)
s.amp1.off


s.tw.sk(110)
s.tw.setpolar(0)

% raw data collection
s.rfsw.select(0)
freq=logfreq(1e9,6e9,10);

x=[];
s.hf.amp(-10);
s.hf.On
s.amp1.gain(3072)
s.amp1.on;
pause(0.5)
for i=1:length(freq)
s.hf.freq(freq(i));
pause(0.5)
tmp=s.fp.read;
x=[x; freq(i) s.ps2.read(freq(i)) tmp ];
pause(0.2)
end

s.hf.amp(-100);
s.hf.Off
s.amp1.gain(0)
s.amp1.off

figure
semilogx(x(:,1),x(:,3),x(:,1),x(:,4),x(:,1),x(:,5),x(:,1),x(:,6))
%%

% Calibrated. 
s.rfsw.select(0)

freq=logfreq(1e9,6e9,25);
x=[];
s.hf.amp(-10);
s.hf.On
s.amp1.gain(3072)
s.amp1.on;
pause(0.5)
figure
lin=plot(1,1);
coeff=[];
for i=1:length(freq)
s.hf.freq(freq(i));
[hfgain ampgain delta]=fn_CI_seekAmplitude(s);
coeff=[coeff; freq(i) hfgain ampgain delta];
s.hf.amp(hfgain);
s.amp1.gain(ampgain);
pause(0.5)
tmp=s.fp.read;
x=[x; freq(i) s.ps2.read(freq(i)) tmp ];
pause(0.2)
lin.XData=x(:,1);
lin.YData=x(:,end);
drawnow;

end

s.hf.amp(-100);
s.hf.Off
s.amp1.gain(0)
s.amp1.off

% Point N
N=16

x=[];
s.hf.amp(-10);
s.hf.On
s.amp1.gain(3072)
s.amp1.on;
figure
lin=plot(1,1);
for i=1:length(freq)
s.hf.freq(freq(i));
hfgain=coeff(i,2);
ampgain=coeff(i,3);
s.hf.amp(hfgain);
s.amp1.gain(ampgain);
pause(0.5)
tmp=s.fp.read;
x=[x; freq(i) s.ps2.read(freq(i)) tmp ];
pause(0.2)
lin.XData=x(:,1);
lin.YData=x(:,end);
drawnow;
end
save(['RH110Point' num2str(N) '.mat'],'x' );
s.hf.amp(-100);
s.hf.Off
s.amp1.gain(0)
s.amp1.off


%% check the probe respoonse
h=figure
for i=1:length(freq)
s.hf.freq(freq(i));
pause(0.5)
tmp=s.fp.read;
(tmp(end)/3);
x=[x; freq(i) s.ps2.read(freq(i)) tmp ];
pause(0.2)
end

%% check the reuslt
figure
plot(1,1);hold on

    y={};
    for i=1:16
        x=load(['RH110Point' num2str(i) '.mat'] );
        tmp=x.x;
        y(i)={tmp};
       %semilogx(x.x(:,1),db(x.x(:,end)/3));
    end

result=[];
for j=1:length(freq)
      f=[freq(j)];
  for i=1:16
      f=[f;db(y{i}(j,end)/3)]
  end
  result=[result f];
end
re=sort(result,1,'descend') ;

csvwrite('fielduniformitysorted.csv',re)

csvwrite('coefficients.csv',coeff)






