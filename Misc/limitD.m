function result =limitD(type,t)

freq=t(1); peak=t(2); qpeak=t(3); avg=t(4);
switch type
    case 'RE'
         ll1=[30e6 50; 220e6 50; 220e6 57; 1e9 57;];
        if freq<220e6
           peakD=peak-50;qpeakD=qpeak-50;avgD=avg-50;
        else
            peakD=peak-57;qpeakD=qpeak-57;avgD=avg-57;
        end
        
            
    case 'CE'
         ll1=[150e3 79; 0.5e6 79; 0.5e6 73; 30e6 73];
         ll2 =[150e3 66; 0.5e6 66; 0.5e6 60; 30e6 60];
     
         if freq<0.5e6
           peakD=peak-79;qpeakD=qpeak-79;avgD=avg-66;
        else
            peakD=peak-73;qpeakD=qpeak-73;avgD=avg-60;
        end
     
         
    case 'OAT'
        ll1=[30e6 50; 220e6 50; 220e6 57; 1e9 57;];
        if freq<220e6
           peakD=peak-40;qpeakD=qpeak-40;avgD=avg-40;
        else
            peakD=peak-47;qpeakD=qpeak-47;avgD=avg-47;
        end
        

end
    result=[peakD qpeakD avgD];

end

