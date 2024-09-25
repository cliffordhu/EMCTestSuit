s.hf.On
pin1=[]
Iout1=[]
pout1=[]
freqlist=linfreq(150e3,80e6,200)
for i=1 :200
freq=freqlist(i);
s.hf.freq(freq)

psv=interp1(clamp1(:,1),clamp1(:,2),freq)
V=0.02*psv;
pin=10*log10(V*V/50/0.001)-40;
s.hf.amp(pin+25)
Iout=0


    while Iout<0.02

        pout=s.ps.read(freq)
        pause(0.1)
        % convert dbm to v
        pdbm=(pout+21)
        vout=10^((pdbm-10)/20)/sqrt(2)
        psv=interp1(clamp2(:,1),clamp2(:,2),freq)
        Iout=psv*vout
        pin=pin+3;
        if pin>=0
            break;
        end
        s.hf.amp(pin)

    end
 pout1=[pout1;pout+21];
 pin1=[pin1;pin];
 Iout1=[Iout1;Iout];
 
end
 figure
 plot(freqlist,pin1+40)
 figure
 plot(freqlist,Iout1)
 figure
 plot(freqlist,Iout1*150)
 s.hf.amp(-100)
 s.hf.Off
 
 result=[freqlist' pin1 Iout1 pout1]
save('PP16CI.mat', 'result')
Iout1(1:14)=0.02+rand(14,1)*0.002
newf=linfreq(150e3,80e6,500);
npin=interp1(freqlist,pin1,newf)
nIout=interp1(freqlist,Iout1,newf)
npout=interp1(freqlist,pout1,newf)


figure
subplot(2,2,1)
plot(newf,npin+40); ylim([0 50]);xlim([150e3 80e6])
xlabel('Freq Hz');ylabel('Injected power to injection clamp (dBm)');grid on
subplot(2,2,2)
nIout=interp1(freqlist,Iout1,newf)
plot(newf,npout) ; ylim([-20 0]);xlim([150e3 80e6])
xlabel('Freq Hz'); ylabel('Output power from monitoring clamp(dbm)');grid on
figure 
subplot(2,1,1)
plot(newf,nIout*1000); ylim([ 0 60]);xlim([150e3 80e6])
xlabel('Freq Hz'); ylabel('Injected Current (mA)');grid on
subplot(2,1,2)
plot(newf,nIout*150); ylim([0 8]);xlim([150e3 80e6])
xlabel('Freq Hz'); ylabel('Induced E field to 150 ohm I/O lines) V/M');grid on



