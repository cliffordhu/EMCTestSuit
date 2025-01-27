global s
load BCIClampF_120_9BS21.mat
figure;
clamp1=[a(:,1) abs(a(:,2))/0.02];
plot(clamp1(:,1), clamp1(:,2));
xlabel('Freq (Hz)');ylabel('Transdunce V/A')
grid on
ylim([0, 22 ])
title('FCC F 120 9B Injection Clamp')
load BCIClampF_33_1.mat
clamp2=[c(:,1),0.02./abs(c(:,2))];
figure;
plot(clamp2(:,1),clamp2(:,2))
xlabel('Freq (Hz)');ylabel('Transdunce A/V')
grid on;
title('FCC F 33 1 Monitoring Clamp')
freqlist=logfreq(150e5,80e6,100)

psv=-20
s.hf.freq(freq)
s.hf.amp(psv)
psvalue=s.ps.read(freq)
pin1=[]
Iout1=[]
pout1=[]

     


for i=1 :50
freq=freqlist(i);
s.hf.freq(freq)

psv=interp1(clamp1(:,1),clamp1(:,2),freq)
V=0.02*psv;
pin=10*log10(V*V/50/0.001)-40;
s.hf.amp(pin)



    while Iout<0.02

        pout=s.ps.read(freq)
        pause(0.5)
        % convert dbm to v
        pdbm=(pout+21)
        vout=10^((pdbm-10)/20)/sqrt(2)
        psv=interp1(clamp2(:,1),clamp2(:,2),freq)
        Iout=psv*vout
        pin=pin+2
        if pin>=0
            break;
        end
        s.hf.amp(pin)

    end
 pout1=[pout1;pout+21];
 pin1=[pin1;pin];
 Iout1=[Iout1;Iout];
 
 end





    
