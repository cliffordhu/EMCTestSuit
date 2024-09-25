function [hfgain ampgain delta]=fn_CI_seekAmplitude(s,band)
if band==0 % for freq below 1GHz. just adjust the hf gain. 
    
    ampgain=0;
    x=s.fp.read;
    % check if the gain needs to be adjusted
    hfgain=s.hf.gain-db(x(end)/3);%compare to 3v/m

    % if the gain >0  set hfgain=0; increase the amp gain until it is within 6dB of the condition. 
    if hfgain>-7 % exceeding the limit of the power amplifiler. 
    hfgain=-7;
    end
        s.hf.amp(hfgain);
        pause(0.5)
        x=s.fp.read;
        delta=db(x(end)/3) % compare to 3V/m
        
else 
    
    % set gain 3072 75% to begin with
    ampgain=3072;
    s.amp1.gain(ampgain);      
    x=s.fp.read;
    % check if the gain needs to be adjusted
    hfgain=s.hf.gain-db(x(end)/3);%compare to 3v/m

    % if the gain >0  set hfgain=0; increase the amp gain until it is within 6dB of the condition. 
    if hfgain>3
    hfgain=3;
    s.hf.amp(hfgain);
            ampgain=3072; 
            while ampgain<4096 &&  db(x(end)/3)<-1
               ampgain=ampgain+512;
               s.amp1.gain(ampgain);
               pause(0.3);
               x=s.fp.read;
            end
    end
        s.hf.amp(hfgain);
        s.amp1.gain(ampgain);
        pause(0.5)
        x=s.fp.read;
        delta=db(x(end)/3) % compare to 3V/m
end

  

