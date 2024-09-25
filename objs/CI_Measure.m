function CI_Measure (source, eventdata)
global g
global s
switch source.UserData(3)
    case 1 %run
        
           s.CI('run',g.b4c.t2c.bc.ax1);
    case 2 %pause
        if strcmp(g.b4c.t2c.bc.btc.bt2.String,'Pause')
          g.b4c.t2c.bc.btc.bt2.String='Resume';
           s.CI('pause',g.b4c.t2c.bc.ax1);
        else 
          g.b4c.t2c.bc.btc.bt2.String='Pause';
           s.CI('resume',g.b4c.t2c.bc.ax1);
        end
        
        
    case 3 %stop
        s.CI_stop=1;
    case 4 %check
             try 
             rowID=g.b4c.t2c.bc.btc.tb1.UserData(1);
             data=g.b4c.t2c.bc.btc.tb1.Data;
               prompt={'Test Frequency(Hz)'};
               name='Input test parameters';
               numlines=1;
               defaultanswer={num2str(data{rowID,1})};
               answer=inputdlg(prompt,name,numlines,defaultanswer);
            catch err
             msgbox('Please select a freq on the table to check!')
             return
            end
            freq=str2num(answer{1});
              if freq<s.CI_crossfreq
                  
                 s.lf.freq(freq);
                 s.lf.amp(s.CI_lfgenamp);
                   if s.CI_IF_AM
                                            s.hf.AM_amp=s.CI_AM_amp;
                                            s.hf.AM_freq=s.CI_AM_freq;
                                            s.hf.AM_On;
                   else
                                            s.hf.AM_Off;
                   end
                                    s.ps.read(freq);
                  while s.ps.amp+s.CI_attenuation<13.5 % 13.5dbm =3vpp. -20dB attenuation.  2.55 as buffer
                                        if s.CI_lfgenamp<3.5 % limit of 33120A vpp=9v
                                            s.CI_lfgenamp=s.CI_lfgenamp+0.3;
                                            s.lf.amp(s.CI_lfgenamp); pause(0.1);
                                        else 
                                            disp('Warning: Amplitude is out of limit of funciton generator!');
                                            break;
                                        end
                                        s.ps.read(freq);
                  end        
                                    
              else 
                                   	s.hf.freq(freq);
                                    s.hf.amp(s.CI_hfgenamp);
                                    if s.CI_IF_AM
                                        s.hf.AM_amp=s.CI_AM_amp;
                                        s.hf.AM_freq=s.CI_AM_freq;
                                        s.hf.AM_On;
                                    else
                                        s.hf.AM_Off;
                                    end
                                    
                                                                        
                                    s.hf.On;
                                    s.ps.read(freq);
                                    
                                    
                                    
              
                                         
                 uiwait(msgbox('Checking is in progress, Click OK to finish'))
                                 s.lf.amp(0);
                                 s.hf.amp(-100);
                                 s.hf.Off;
                      g.CI_result=[g.CI_result;freq dbm2vpp(g.ps.amp+20)];
                               % set the new freq value
                      plot(ax, freq/1e6, 3,'r*');
              end           
                                 
    case 5 %config
         prompt={'Dwelling time(s)','Test Steps:','Enable AM modulation?','AM Amplitude','AM Freq'};
               name='Input test parameters';
               numlines=1;
               defaultanswer={num2str(s.CI_dwellingtime),num2str(s.CI_freqstep),num2str(s.CI_IF_AM),num2str(s.CI_AM_amp),num2str(s.CI_AM_freq)};
               answer=inputdlg(prompt,name,numlines,defaultanswer);
               s.CI_dwellingtime=str2num(answer{1});
               s.CI_freqstep=str2num(answer{2});
               s.CI_IF_AM=str2num(answer{3});
               s.CI_AM_amp=str2num(answer{4});
               s.CI_AM_freq=str2num(answer{5});
               
    case 5 %up
          s.CI('up',g.b4c.t2c.bc.ax1);
    case 6 %forward
          s.CI('forward',g.b4c.t2c.bc.ax1);
    case 7 %max
          s.CI('max');
    case 8 %mark freq
        
         
        
        if s.CI_freqindex<1 || s.CI_freqindex > length(s.CI_freqlist)
           return
        end
        g.b4c.t2c.bc.btc.bt9.String=num2str(s.CI_freqlist(s.CI_freqindex)/1e6,6);
        temp=[s.CI_freqlist(s.CI_freqindex) 0;s.CI_freqlist(s.CI_freqindex) 3];
        l1=plot(g.b4c.t2c.bc.ax1,temp(:,1)/1e6,temp(:,2));
                 
         switch g.b4c.t2c.bc.btc.bt11.Value
             case 1 
                l1.Color='g';
                
             case 2
                l1.Color='m';
             case 3
                l1.Color='y';
             case 4
                l1.Color='r';
         end
         Mark=g.b4c.t2c.bc.btc.bt11.String(g.b4c.t2c.bc.btc.bt11.Value);
         Freq=s.CI_freqlist(s.CI_freqindex);
         T={Freq,char(Mark)};
         if isempty(g.b4c.t2c.bc.btc.tb1.Data)
           % create the table first. 
           g.b4c.t2c.bc.btc.tb1.Data=T;
         else
            % add another row to the table
          
         g.b4c.t2c.bc.btc.tb1.Data=[g.b4c.t2c.bc.btc.tb1.Data;T];
         end
         
         
    case 9 %text freq
    case 10 %labelMhz
    case 11 %popup menu
    case 12 %label
    case 13 %textcomment
    case 14 %next button.
      g.p2.Selection = 3;
end

        
end
