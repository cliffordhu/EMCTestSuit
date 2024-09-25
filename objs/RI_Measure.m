function RI_Measure(source, callbackdata)

global g
global d
global s
    kk=source.UserData(3);
    str1={'Front','Left','Rear','Right'};
    str2={'Horizontal','Vertical'};
    switch kk
        case 1 % Run
               % reset the turntable 
                 s.tt.sk(0);
                  ii=1;
                 while ~s.tt.opc
                    ii=ii+1;pause(0.1);
                    if ii>100
                        break;
                    end
                        
                 end
                 % create the RI figure to display the progress
                 g.ri.f=waitbar(0,'Please wait...');
                        ax=g.b8c.t2c.bc.ax1;
                        xlim(ax,[80e6 6e9]);
                        ylim(ax,[0 5]);
                        xlabel(ax,'Frequency');
                        ylabel(ax,'Radiated Immunity Field Intensity V/m');
                        grid(ax,'on');hold(ax,'on');
                        set(ax,'xscale','log');
                g.b8c.t2c.bc.btc.bt2.String='Pause';
                s.RI_stop=0;
                %for i=1:4
                % quick check for debugging
                for i=1:s.RI_N
                   
                    
                    ta=[0 90 180 270];
                    g.ri.current_ta=ta(i);
                    s.tt.sk(ta(i));
                       ii=1;
                        while ~s.tt.opc
                             ii=ii+1;pause(0.1);
                                if ii>100
                                    break;
                                end
                         end
                    waitbar(0.2*i,g.ri.f,['Tesing DUT' str1{i}]);
                    title(g.b8c.t2c.bc.ax1,['DUT Position:' str1{i}]);
                    
                    s.RI_freqindex=1; s.RI_x=[];
                    g.ri.current_polar=0;
                    s.RI_current_polar=0;
                    s.RI_DUT_pos=i;

                        
                    s.RI('run',g.b8c.t2c.bc.ax1);   
                    if s.RI_Break_by_pause
                           break;
                    end
                    
                    
                    s.RI_freqindex=1; s.RI_x=[];
                    g.ri.current_polar=1;
                    s.RI_current_polar=1;
                    s.RI('run',g.b8c.t2c.bc.ax1);
                    if s.RI_Break_by_pause
                            break;
                    end
                    
                end
                     if s.RI_Break_by_pause
                        s.RI_Break_by_pause=0;
                        msgbox('Test is paused');
                     else
                            s.tt.sk(0);
                            ii=1; 
                            while ~s.tt.opc
                                  ii=ii+1;pause(0.1);
                                    if ii>100
                                        break;
                                    end
                             end
                            close(g.ri.f);
                            msgbox('Test completed!');
                     end
                
       case 2 % Pause
           if strcmp(g.b8c.t2c.bc.btc.bt2.String,'Pause')
               g.b8c.t2c.bc.btc.bt2.String='Resume';
               s.RI_stop=1;
           else
               g.b8c.t2c.bc.btc.bt2.String='Pause';
               s.RI_stop=0;
               for i=1:4 
                    ta=[0 90 180 270];
                    if g.ri.current_ta<=ta(i)
                        g.ri.current_ta=ta(i);
                        s.RI_DUT_pos=i;
                        s.tt.sk(ta(i));
                         ii=1;
                         while ~s.tt.opc
                            ii=ii+1;pause(0.1);
                            if ii>100
                                break;
                            end
                         end
                     if  g.ri.current_polar==0
                         
                        s.RI_current_polar=0;
                        s.RI('resume',g.b8c.t2c.bc.ax1); 
                         if s.RI_Break_by_pause
                            break;
                            s.RI_current_polar=0;
                            g.ri.current_polar=0;
                         else
                             s.RI_current_polar=1;
                             g.ri.current_polar=1;
                             s.RI_freqindex=1;
                             s.RI_x=[];
                         end
                     end

                        
                        s.RI('resume',g.b8c.t2c.bc.ax1); 
                         if s.RI_Break_by_pause
                            break;
                        g.ri.current_polar=1;
                        s.RI_current_polar=1;
                        
                         else
                        g.ri.current_polar=0;
                        s.RI_current_polar=0;
                        s.RI_freqindex=1;
                        s.RI_x=[];

                         end
                          
                    end
               end
              if s.RI_Break_by_pause
                   s.RI_Break_by_pause=0;           
              else
                s.tt.sk(0);
                close(g.ri.f);
              end
              
           end
        case 3 %Stop
              s.RI_stop=1;
              g.hf.amp(-100); pause(0.1);
              
        case 4 %check
            try 
            rowID=g.b8c.t2c.bc.btc.tb1.UserData(1);
             data=g.b8c.t2c.bc.btc.tb1.Data;
               prompt={'Dut Position','Antenna Polarization','Frequency(MHz)'};
               name='Input test parameters';
               numlines=1;
               defaultanswer={data{rowID,2},data{rowID,3},num2str(data{rowID,1})};
               answer=inputdlg(prompt,name,numlines,defaultanswer);
            catch err
             msgbox('Please select a freq on the table to check!')
             return
            end
               switch answer{1}
                   case 'Front'
                     s.tt.sk(0);
                   case 'Left'
                       s.tt.sk(90);
                   case 'Rear'
                       s.tt.sk(180);
                   case 'Right'
                       s.tt.sk(270);
               end
                       ii=1;
                         while ~s.tt.opc
                            ii=ii+1;pause(0.1);
                            if ii>100
                                break;
                            end
                         end
                  
              switch answer{2}
                   case 'Horizontal'
                    k=0;
                   case 'Vertical'
                     k=1;
              end
               s.tw.setpolar(k);
                freq=str2num(answer{3})*1e6;
                s.hf.freq(freq); s.hf.On;
                              hfgain=interp1(d.ri.coeffs{k+1}(:,1),d.ri.coeffs{k+1}(:,2),freq);
                              ampgain=interp1(d.ri.coeffs{k+1}(:,1),d.ri.coeffs{k+1}(:,3),freq);  
                              s.hf.amp(hfgain);
                               if s.RI_IF_AM
                                        s.hf.AM_amp=s.RI_AM_amp;
                                        s.hf.AM_freq=s.RI_AM_freq;
                                        s.hf.AM_On;
                                    else
                                        s.hf.AM_Off;
                               end
                                    
                              if freq<1e9
                                 s.rfsw.select(0);   
                              else
                                 s.rfsw.select(1); pause(1);
                                 s.amp1.on; pause(0.5);
                                 s.amp1.gain(ampgain); pause(0.5);
                              end
                      uiwait(msgbox('Checking is in progress, Click OK to finish'))
                                 s.amp1.gain(0); pause(0.5);
                                 s.amp1.off; pause(0.5);
                                 s.hf.amp(-100);
                                 s.hf.Off;
                                 
                                 
           
                           
                           
            

        case 5 %Configuration
           
               prompt={'Dwelling time(s)','Test Steps:','Enable AM modulation?','AM Amplitude','AM Freq','Num of side to check'};
               name='Input test parameters';
               numlines=1;
               defaultanswer={num2str(s.RI_dwellingtime),num2str(s.RI_freqstep),num2str(s.RI_IF_AM),num2str(s.RI_AM_amp),num2str(s.RI_AM_freq),num2str(s.RI_N)};
               answer=inputdlg(prompt,name,numlines,defaultanswer);
               s.RI_dwellingtime=str2num(answer{1});
               s.RI_freqstep=str2num(answer{2});
               s.RI_IF_AM=str2num(answer{3});
               s.RI_AM_freq=str2num(answer{5});
               s.RI_AM_amp=str2num(answer{4});
               s.RI_N=str2num(answer{6});
               
        case 6 %dewlling
              s.RI('dewelling',g.b8c.t2c.bc.ax1);
        case 7 %point
              s.RI('point',g.b8c.t2c.bc.ax1);
        case 8 %max
              s.RI('max');


        case 9 %Mark
            if s.RI_freqindex<1 || s.RI_freqindex > length(s.RI_freqlist)
               return
            end
             g.b8c.t2c.bc.btc.bt10.String=num2str(ceil(s.RI_freqlist(s.RI_freqindex-1)/1e6));
             temp=[s.RI_freqlist(s.RI_freqindex) 0;s.RI_freqlist(s.RI_freqindex) 3];
             l1=plot(g.b8c.t2c.bc.ax1,temp(:,1),temp(:,2));

             switch g.b8c.t2c.bc.btc.bt12.Value
                 case 1 
                    l1.Color='g';                 case 2
                    l1.Color='m';
                 case 3
                    l1.Color='y';
                 case 4
                    l1.Color='r';
             end
             
               strtmp=g.b8c.t2c.bc.btc.bt12.String(g.b8c.t2c.bc.btc.bt12.Value);
               prompt={'Comments:'};
               name='Insert Comments';
               numlines=1;
               defaultanswer={char(strtmp)};
               answer=inputdlg(prompt,name,numlines,defaultanswer);
              Mark=answer{1};
   
             try
               Freq=s.RI_freqlist(s.RI_freqindex-s.RI_freqstep);
             catch err
               Freq=s.RI_freqlist(s.RI_freqindex);
             
             end
              
               T={ceil(Freq/1e6),str1{s.RI_DUT_pos},str2{s.RI_current_polar+1},Mark};
             if isempty(g.b8c.t2c.bc.btc.tb1.Data)
               % create the table first. 
               g.b8c.t2c.bc.btc.tb1.Data=T;
             else
                % add another row to the table

             g.b8c.t2c.bc.btc.tb1.Data=[g.b8c.t2c.bc.btc.tb1.Data;T];
             end
         
        case 10
        case 11
        case 12
        case 13
             g.p2.Selection = 3;
    end

        