classdef SystemObj < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    % this OBj include all integreated fucntion for RE OATs CE and CI
    
    properties
        r=0;
        h=150;p1=[];p2=[];p11=[];p22=[];ax2=[];
        sld1=[];sld2=[];sld3=[];sld4=[];sld5=[];sld6=[];sld7=[];
        tmr1=[];
        f=[];
        ax1=[];
        ann=[];
        polar=0;
        polartmp=0;
        corrCE=[];
        %for RE and CE
        tw=[];
        tt=[];
        sa=[];
        
        A0;A1;
        TWTestHeight=150;
        TW_LOW_LIMIT=102;
        TW_HIGH_LIMIT=220;
        type='RE';
        %for CI
        ps=[];
        lf=[];
        hf=[];
        CI_crossfreq=1e6;
        CI_freqlist=[]; % the complete freqlist to scan.
        CI_freqstep=1;  % jumping step of the freq
        CI_freqindex=1; % pointer to CI_freqlist
        CI_dwellingtime=0.5 ;% CI dewelling time constant.
        CI_stop=0 %check status.
        CI_result=[];
        CI_lfgenamp=1.8; % lf wavegen amp
        CI_hfgenamp=-23.5+10; % hf wavegen amp
        CI_attenuation=19.28-6; % CDN attenuation rate in dB
        CI_direction=1;
        CI_AM_freq=1000;
        CI_AM_amp=20;
        CI_IF_AM=0;
        %for RI
        ps1=[];
        ps2=[];
        amp1=[];
        amp2=[];
        rfsw=[];
        atn=[];
        fp=[]; %field probe
        RI_freqlist=[]; % the complete freqlist to scan.
        RI_freqstep=1;  % jumping step of the freq
        RI_freqindex=1; % pointer to CI_freqlist
        RI_dwellingtime=0.5 ;% CI dewelling time constant.
        RI_stop=0 %check status.
        RI_result=[];
        RI_direction=1;
        RI_crossfreq=1e9;
        RI_current_polar=0;
        RI_DUT_pos=1;
        RI_Break_by_pause=0;
        RI_x=[];
        RI_AM_freq=1000;
        RI_AM_amp=80;
        RI_IF_AM=0;
        RI_N=1;
    end
    
    methods
        function g=SystemObj
        end
        function plot(g)
                g.f=figure
                
                set(g.f,'deletefcn',{@g.deleter})
                b=uix.HBoxFlex( 'Parent', g.f)
                g.p1 =uix.VBox( 'Parent', b);
                g.p22 = uix.VBox( 'Parent', b);
                g.sld2= uicontrol('Style', 'text',...
                   'String','Turntable Position',    'Parent',g.p22); 
                g.sld3 = uicontrol('Style', 'text',...
                 'String',num2str(g.r),'Parent',g.p22); 

                g.p2=uix.Panel( 'Parent', g.p22, 'Padding', 5 );
                g.ax2=axes('Parent',g.p2);
                set( b, 'Widths', [-1 -4], 'Spacing', 5 );
                set( g.p22, 'Heights', [30 30 -1], 'Spacing', 5 );
                pos=[-2 -2 4 4]
                rectangle('Position',pos,'EdgeColor','r','Curvature',[1 1],'Parent',g.ax2);
                hold on;
                pos=[-2 -1 4 2]%[x y w h]
                r=rectangle('Position',pos,'Parent',g.ax2);
                text(-2,0,'Front Side','Parent',g.ax2);
                text(2,0,'Rear Side','Parent',g.ax2);
                A = imread('./images/dut.jpg');
                BirdMask1 = A >= 245;
                BirdMask2=BirdMask1(:,:,1).* BirdMask1(:,:,2).* BirdMask1(:,:,3);
                BirdMask=-1.*(BirdMask2(:,:,1)-1);
              % 'AlphaData', BirdMask,...
                image(...
                'CData', A,...
                'AlphaData', BirdMask,...
                 'parent', g.ax2,'XData',[-1 1],'YData',[-1 1]);                 
                axis equal
                set(g.ax2,'visible','off')
                %set(g.ax1,'visible','off')
                view(g.r,45);
       

       g.sld4= uicontrol('Style', 'text',...
             'String','Antenna Position', 'Parent',g.p1); 
       g.sld5= uicontrol('Style', 'text',...
             'String',num2str(g.h), 'Parent',g.p1); 
       g.p11=uix.Panel( 'Parent', g.p1, 'Padding', 5 );
        set( g.p1, 'Heights', [30 30 -1], 'Spacing', 5 );
       g.ax1=axes('Parent',g.p11);
       g.ax1.Color=g.f.Color;
          g.ax2.Color=g.f.Color;
%       g.sld1 = uicontrol('Style', 'slider',...
%         'Min',1,'Max',210,'Value',150,...
%         'Position', [20 20 20 120],...
%         'Parent',g.p1,'Enable','on'); 
          g.A1=imread('./images/3142EV.jpg');
          g.A0=imread('./images/3142EH.jpg');
        if g.polar
            A =g.A1;
        else 
           A = g.A0;
        end
               BirdMask1 = A >=245;
               BirdMask2=BirdMask1(:,:,1).* BirdMask1(:,:,2).* BirdMask1(:,:,3);
                BirdMask=-1.*(BirdMask2(:,:,1)-1);
              % 'AlphaData', BirdMask,...
        hImage = image(...
        'CData', A,...
        'AlphaData', BirdMask,...
        'parent', g.ax1);
        g.ax1.YLim=[0 220];%setg.axis equal
        
        if g.polar
          hImage.YData=[1 100];
          hImage.XData=[1 50];
          g.ax1.XLim=[0 50];
        else 
          hImage.XData=[1 100];
          hImage.YData=[1 50];
           g.ax1.XLim=[0 100];
        end 
        g.ann=hImage;
        g.creattmr;
        end
%      
            function creattmr(g)
                
   
        STRT=0;
    g.tmr1=timer('Name','turntable',...
                        'Period',1,...  % Update the time every 60 seconds.
                        'StartDelay',STRT,... % In seconds.
                        'TasksToExecute',inf,...  % number of times to update
                        'ExecutionMode','fixedSpacing',...
                        'TimerFcn',{@g.timer1}); 
  
    start(g.tmr1);  % Start the timer object.



        end
        function timer1(g,varargin)
     
                 try
                    
                    view(g.ax2,g.r,45);
                     g.sld3.String=([ num2str(g.r) ' ' char(176)]);
                     g.sld5.String=([ num2str(g.h) ' cm']);
                     % antenna switched
                     if g.polar~=g.polartmp
                           cla(g.ax1);
                           if g.polar
                                A =g.A1;
                            else 
                               A = g.A0;
                            end
                                   BirdMask1 = A >=245;
                                   BirdMask2=BirdMask1(:,:,1).* BirdMask1(:,:,2).* BirdMask1(:,:,3);
                                    BirdMask=-1.*(BirdMask2(:,:,1)-1);
                                  % 'AlphaData', BirdMask,...
                            g.ann = image(...
                            'CData', A,...
                            'AlphaData', BirdMask,...
                            'parent', g.ax1);
                            g.ax1.YLim=[0 250];%setg.axis equal
                end
                            if g.polar
                              g.ann.XData=[1 50];
                              g.ann.YData=[1 100]+g.h-50;
                              g.ax1.XLim=[0 50];
                              
                            else 
                              g.ann.YData=[1 50]+g.h-25;
                              g.ann.XData=[1 100];
                              g.ax1.XLim=[0 100];
                            end 
           
                   g.polartmp=g.polar;
            %     set(g.ax2,'Visible','off')
                      %drawnow;
                 catch
                     delete(g.f) ;% Close it all down.
                     g.f=[];
                 end

        end
        
      
                            
         
                      
        function timer2(g,varargin)
    
                 try
                     if g.polar
                       g.ann.CData=g.A1;
                       g.ann.XData=[1 50];
                       g.ann.YData=[1 100]+g.h-50;
                     else
                        g.ann.CData=g.A0;
                        g.ann.XData=[1 100];
                        g.ann.YData=[1 50]+g.h-25;
                     end 
                    g.sld5.String=[num2str(g.h) 'cm'];
                      %drawnow;
                 catch
                     delete(g.f) ;% Close it all down.
                     g.f=[];
                 end

        end
        function setpolar(g,pol)
        if pol
            g.polar=1;
            A = imread('./images/3142EV.jpg');
             BirdMask1 = A >= 245;
             BirdMask2=BirdMask1(:,:,1).* BirdMask1(:,:,2).* BirdMask1(:,:,3);
             BirdMask=-1.*(BirdMask2(:,:,1)-1);
              % 'AlphaData', BirdMask,...
            cla(g.ax1);
             g.ann = image(...
                'CData', A,...
                'AlphaData', BirdMask,...
                'parent', g.ax1);
                   g.ann.YData=[1 100];
               g.ann.XData=[1 50];
                g.ax1.XLim=[0 50];
            
              else 
            A = imread('./images/3142EH.jpg');
  
             BirdMask1 = A >= 245;
             BirdMask2=BirdMask1(:,:,1).* BirdMask1(:,:,2).* BirdMask1(:,:,3);
             BirdMask=-1.*(BirdMask2(:,:,1)-1);
             
            g.polar=0;
            cla(g.ax1);
            g.ann = image(...
                'CData', A,...
                 'AlphaData', BirdMask,...
                'parent', g.ax1);
                g.ann.XData=[1 100];
               g.ann.YData=[1 50];
                g.ax1.XLim=[0 100];
            
        end 
      
        g.ax1.YLim=[0 220];%setg.axis equal
        end
        function [] = deleter(g,varargin)
            % If figure is deleted, so is timer.
      
                 stop(g.tmr1);
                 delete(g.tmr1);
              
        end
        function setantennaposition(g,varargin)

        g.sld1.Value=str2num(g.sld5.String);

        end
        function setttposition(g,varargin)


        g.r=str2num(g.sld6.String);

        end
        function stop_update(g)
                if strcmp(g.tmr1.Running,'on') && isvalid(g.tmr1)
                  stop(g.tmr1);
                end
   
        end
        function delete(g)
                          delete(g.tmr1);
                      
                          g.f=[];
        end
        function start_update(g)
         
       
             if isempty(g.f)
                g.plot;
             else
                if ~isvalid(g.tmr1)
                    g.creattmr;
                 else
                    if strcmp(g.tmr1.Running,'off')
                     start(g.tmr1);
                    end
                end
                
             end
             
           
        end
        function demo(g)
           for i =1:360
               g.r=i;
               pause(0.1);
           end 
        end
        
        function demov(g)
            
                for i =1:220
               g.h=i;
               pause(0.1);
                end 
        end
        
        function ini (g)
             a=instrfind;
             for i=1:length(a)
              fclose(a(i));
             end
             
            g.tt=ttObj; 
            g.tw=twObj; 
            g.sa=saObj;
            str=g.b1c.t1c.rx3.String;
            g.tw.address=str2num(str(regexp(str,'\d')));
            g.tw.ini;
            str=g.b1c.t1c.rx2.String;
            g.tt.address=str2num(str(regexp(str,'\d')));
            g.tt.ini;
            g.sa.address=strtrim(g.b1c.t1c.rx1.String);
            g.sa.ini;
        end
        
        
        function p=measureCE(g)
             g.sa.takefreq;
             p.freq=g.sa.freq;
             p.result=[];
            % Corr has been applied in the MXE receiver. 
            % corr=interp1(g.corrCE(:,1),g.corrCE(:,2),p.freq);
             g.sa.Config_measureCE;
             g.sa.restart;
             pause(10);
             p.result=g.sa.takedata(1)'; %+corr;
             %apply the corrCE
             p.maxhold= p.result;
        
        end
                  
       
        function p=measureRE(g)
            p.result=[];
            g.sa.Config_measureRE;
            p.polar=g.tw.polar;
            p.ttpos=[];p.twpos=[];p.polar=[];
            g.polar=g.tw.polar;
            g.r=g.tt.cp;

            
            g.h=g.tw.cp;
               if isempty(g.f)
                g.plot;
               else
                 g.start_update;  
               end
            
            g.tt.setspeed(170)
            g.tt.setlimit([0 360])
            %g.tw.setspeed(170)
            g.tw.setspeed(130)
            g.tw.sk(g.TWTestHeight);
            while ~g.tw.opc
            end
%             g.tw.setlimit([100 200])
            g.tw.setlimit([g.TW_LOW_LIMIT g.TW_HIGH_LIMIT]);

             p.result=g.sa.takedata(1)';
             p.ttpos= g.r;
             p.twpos=g.h;
             p.polar=g.polar;
             pause(0.2); 
             
             g.tt.scan(0.5)
             %pause(0.1)
             while ~g.tt.opc
              g.r=g.tt.cp;
              p.result=[p.result;g.sa.takedata(1)'];
              pause(0.01);
              g.h=g.tw.cp;
              
              g.polar=g.tw.polar;
              p.ttpos=[p.ttpos g.r];
              p.twpos=[p.twpos g.h];
              p.polar=[p.polar g.polar];
              end
            g.sa.takefreq
            p.freq=g.sa.freq;
            pause(1)
            g.stop_update;   
  
        end
         
        function result_Hscan=remeasureRE(g)
         % setup sa to remeasure mode
         %clear varibles
         %debug 710
         g.sa.peakresult=[];
         % s.sa.peaktable cannot be empty
          g.sa.Config_remeasure;
          % start the animation plot
               if isempty(g.f)
                 g.plot;
               else
                  g.start_update;  
               end
          % make sure the sa is ready
            while ~g.sa.opc 
            end
           mm=size(g.sa.peaktable,1);
          % start the measurement on the peaktable loop the freq one by
          % one.

          for i =1:mm
             %set the antnna and tt into position  710 change the fast skl
             %to SK to prevent hitting limit.
             g.tt.sk(g.sa.peaktable.ttpos(i));
             while ~g.tt.opc
                 g.r=g.tt.cp;
             end
             g.tw.setpolar(g.sa.peaktable.polar(i));
             % set into SA mode, scan height and find the maximum
             g.sa.Config_remeas_start(i,'RE');
             %g.tw.setlimit([100 210]);
             g.tw.setlimit([g.TW_LOW_LIMIT g.TW_HIGH_LIMIT]);
             g.tw.setspeed(50); % set speed 0-255 
             temp.ttpos=[];temp.twpos=[];temp.polar=[];temp.result=[];
             g.tw.scan(0.5);
             %scan antenna and take the data out.
              while ~g.tw.opc
              g.sa.scanH(1);
              pause(0.01);
              g.r=g.tt.cp;
              g.h=g.tw.cp;
              temp.ttpos=[temp.ttpos g.r];
              temp.twpos=[temp.twpos g.h];
              temp.polar=[temp.polar g.polar];
              temp.result=[temp.result;g.sa.dataH'];
              end
              g.sa.takefreq;
              temp.freq=g.sa.freqH;
              result_Hscan{i}=temp;
             
             g.sa.Config_remeas_stop;
             
             % find the maximum tower position and maximum freq. feedback
             % into peaktable.
             [twpos maxfreq maxamp]=find_max_twpos(result_Hscan{i});
             g.sa.peaktable.twpos(i)=twpos;
             g.sa.peaktable.freq(i)=maxfreq;
             if strcmp(g.type,'OAT')  % log the maximum reading from antenna scan narrow RBW measurement
               prescanPeaks(i)= g.sa.peaktable.peaks(i);
               g.sa.peaktable.peaks(i)=maxamp;
             end
             % set tw to the maximumposition. set freq to the maximum freq
             
             g.tw.sk(g.sa.peaktable.twpos(i));            
             while ~g.tw.opc
                 g.h=g.tw.cp;
             end
             % re-write the table.  
              g.sa.replace_peaktable(i);
             while ~g.sa.opc
             end
             %take the remeasure

             g.sa.remeasure;
             while ~g.sa.opc
             end
             pause(1);
           end
           % take the data out of scope
               
           g.sa.readSLIST;
           
             while ~g.sa.opc
             end
             
             % debug 710. correct the meter reading from 120kHz rbw to SA peak using 200Hz 10K span reading 
           if strcmp(g.type,'OAT')
                mm=size(g.sa.peaktable,1);
                for i=1:mm
                   offset= -g.sa.peakresult(i,4)+g.sa.peaktable.peaks(i)+10;
                   g.sa.peakresult(i,4)=g.sa.peakresult(i,4)+offset;
                   g.sa.peakresult(i,5)=g.sa.peakresult(i,5)+offset;
                   g.sa.peakresult(i,6)=g.sa.peakresult(i,6)+offset;
                   g.sa.peakresult(i,7:9)=limitD('OAT',[g.sa.peaktable.freq(i) g.sa.peakresult(i,4:6) ]);
                   g.sa.peaktable.peaks(i)= prescanPeaks(i); % recover the peak reading from Pre-scan peaks
                end
                
                
           end
       
         %           
           g.stop_update;
            g.tt.reset_table;
            g.tw.reset_tw;
        %  close(h);
        end
        
        function remeasureCE(g)
         % setup sa to remeasure mode
         %clear varibles
          g.sa.peakresult=[];
          g.sa.Config_remeasureCE;
          
          % make sure the sa is ready
            while ~g.sa.opc 
            end
           mm=size(g.sa.peaktable,1);
          % start the measurement on the peaktable loop the freq one by
          % one.

          for i =1:mm
             g.sa.Config_remeas_start(i,'CE');
             g.sa.remeasure; 
             while ~g.sa.opc
             end
             pause(1);
           end
           % take the data out of scope
               
           g.sa.readSLIST;
             while ~g.sa.opc
             end

           if isempty(g.sa.peakresult) % try again. it takes time, so increase the timeout to 15
             g.sa.readSLIST;
             while ~g.sa.opc
             end
           end

            %apply correction factor
            if ~isempty(g.sa.peakresult)
            % correction factor is done at MXE side
            % corrCE=interp1(g.corrCE(:,1),g.corrCE(:,2),g.sa.peakresult(:,3));
             %g.sa.peakresult(:,4:9)=g.sa.peakresult(:,4:9)+corrCE*ones(1,6);
             g.sa.peakresult=floor(g.sa.peakresult.*10)./10; % format
             
            else 
              msgbox("Signal List Table reading error, Please try again ") 
              
             end

       

        end
        %%
        function CI(g,val,ax)
            switch val
                  case 'run'
                    g.CI_freqindex=1;g.CI_direction=1;
                    g.CI_result=[]; cla(ax);
                    CI_result=[150e3 3; 80e6 3];
                    l1=plot(ax,CI_result(:,1)/1e6,CI_result(:,2),'r-' );
                    l1.Tag='ref'; 
                    hold(ax,'on'); 
                    set(ax, 'XScale', 'log');
                    l2=plot(ax,150e3/1e6,3,'b*' );
                    l2.Tag='result';
                    xlabel(ax,'Frequency (MHz)'); ylabel('Conducted Immunity Field strength 3V');
                    xlim(ax,[150e3 80e6]./1e6);ylim(ax,[0 6]);
                    grid(ax,'on');
                    CI_scan(g,'up',ax);
                   
                case 'pause'
                    g.CI_stop=1;
                    
                
                case 'stop'
                   g.CI_stop=1;
                   ax.String=num2str(g.CI_freqlist(g.CI_freqindex));
               case 'resume'
                   g.CI_stop=0;
                   CI_scan(g,'up',ax);  
               case 'check'
                   g.CI_stop=1;
                    if  freq<=s.CI_crossfreq
                                    g.lf.freq(freq);
                                    g.lf.amp(g.CI_lfgenamp);
                                    %g.lf.
                                    g.lf.AM_On(g.CI_AM_amp);
                                    g.ps.read(freq);
                                    
                                    
                             while g.ps.amp+g.CI_attenuation<22.6
                                        if g.CI_lfgenamp<3.5 % limit of 33120A vpp=9v
                                            g.CI_lfgenamp=g.CI_lfgenamp+0.3;
                                            g.lf.amp(g.CI_lfgenamp); pause(0.1);
                                        else 
                                            disp('Warning: Amplitude is out of limit of funciton generator!');
                                            break;
                                        end
                                        g.ps.read(freq);
                             end
                      else 
                                   	g.hf.freq(freq);
                                    g.hf.amp(g.CI_hfgenamp);
                                    if g.CI_IF_AM
                                        g.hf.AM_amp=g.CI_AM_amp;
                                        g.hf.AM_freq=g.CI_AM_freq;
                                        g.hf.AM_On;
                                    else
                                        g.hf.AM_Off;
                                    end
                                    
                                    g.hf.On;
                                    g.ps.read(freq);
                               
                                    % adjust the value to meet the
                                    % requirement
                                    while g.ps.amp+g.CI_attenuation<22.6
                                        if g.CI_hfgenamp<10 % limit of High freq signal gen 10dbm
                                            g.CI_hfgenamp=g.CI_hfgenamp+1;
                                             g.hf.amp(g.CI_hfgenamp);
                                        else 
                                            disp('Warning: Amplitude is out of limit of Signal gen generator!');
                                        end
                                        g.ps.read(freq);
                             
                                    end  
                               
                         end
                               
                               pause(g.CI_dwellingtime)
                               g.ps.read(freq)
                              
                               

            end
        end
        
        function configCI(g)
            lf=logfreq(150e3,g.CI_crossfreq,25);
            hf=logfreq(g.CI_crossfreq,80e6,300);
            g.CI_freqlist=[lf hf];
            g.CI_result=[];
            g.hf.AM_Off;
            g.hf.On
        end
        
        function RI(g,cmd,ax)
            switch cmd
              
                case  'backward'
                   if g.RI_freqstep<=10;
                        g.RI_freqstep=g.RI_freqstep+1;
                   end
                     g.RI_stop=0;
                     RI_scan(g,'down',ax);
               
                   
                        
                case 'resume'
                       g.RI_stop=0;
                       RI_scan(g,'up',ax);
                    
                case 'stop'
                       g.RI_stop=1;
                       
                case 'check'
                       g.RI_stop=1;
                       ax.String=num2str(g.RI_freqlist(g.RI_freqindex));
                
                case 'config'
                       g.RI_stop=1;
                       ax.String=num2str(g.RI_freqlist(g.RI_freqindex));
                
                case 'run'
                       g.RI_direction=1; g.RI_result=[]; cla(ax);
                        
                          RI_result=[80e6 3; 6e9 3];
                          l1=semilogx(ax,RI_result(:,1),RI_result(:,2),'k-' );
                          l1.Tag='ref';
                          l2=semilogx(ax,80e6,3,'r-' );
                          l2.Tag='result';
                          RI_scan(g,'up',ax);
                  case 'dewelling'
                      prompt={'Enter the dwelling Time in Second'};
                       name='Input for dwelling time';
                       numlines=1;
                       defaultanswer={'1'};

                       answer=inputdlg(prompt,name,numlines,defaultanswer);
                       g.RI_dwellingtime=str2num(answer{1});
               
                case 'point'
                    prompt={'Default 1%, input speed up factor Maximum 5'};
                    name='Input for Speed up factor';
                       numlines=1;
                       defaultanswer={'1'};

                       answer=inputdlg(prompt,name,numlines,defaultanswer);
                       g.RI_freqstep=str2num(answer{1});
         
            end
       

            
        end
        function configRI(g)         
            g.RI_freqlist=logfreq(80e6,6e9,300);
            g.RI_result=[];        
        end
        
                    

        
    end
    
end

%debug 710
function [twpos maxfreq maxamp]=find_max_twpos(temp)
 A=temp.result;
[Y, location]=max(A(:));
[R,C] = ind2sub(size(A),location);
twpos=temp.twpos(R);
maxfreq=temp.freq(C);
maxamp=Y;

end

function freq=logfreq(startfreq,stopfreq,points)

x1=log10(startfreq);
x2=log10(stopfreq);

dx=(x2-x1)/(points-1);

freq=10.^(x1+[0:points-1]*dx);
end

function freq=linfreq(startfreq,stopfreq,points)

df=(stopfreq-startfreq)/(points-1);
freq=startfreq+[0:points-1]*df;
end

function freq=testfreq(startfreq,stopfreq,stepratio)
    f1=startfreq;freq=f1;
    while f1<=stopfreq
        f1=f1*(1+stepratio);
        freq=[freq f1];
    end
end

function RI_scan(g,direction,ax)
global d
%initialize the variables

strtmp={'Horizontal','Vertical'};
strtmp1={'Front','Right','Rear','Left'};
mm=length(g.RI_freqlist);
d.ri.comp=csvread('./configuration/corrRI.csv');
tmpN=0;

for i =1:length(ax.Children)
   if strcmp(ax.Children(i).Tag,'result')
        lin=ax.Children(i);
   end
end
                      k=g.RI_current_polar;         
                        % if freqindex is in the range,and stop button is
                       % not pushed
                      % set antenna polarity
                        g.tw.setpolar(k);
                        while ~g.tw.opc
                        end
                        tmp=0;
                      % start freqency sweep stop only if the button is pushed or reach to the range.
                       %Turn on the  signal gen
                       g.hf.On;
                       while ~g.RI_stop && ~(g.RI_freqindex<1) && ~(g.RI_freqindex>mm)
                               % retrieve the freq from the list
                               freq=g.RI_freqlist(g.RI_freqindex);
                               % check if the crossover frequency is hit. 
                               title(ax,['DUT Position: ' strtmp1{g.RI_DUT_pos} ', Anntena Ploarization:' strtmp{k+1} ' @ Freq:' num2str(floor(freq/1e6)) 'MHz']);
              
                               % sweeping direciton selection
                               switch direction 
                                   case 'up'
                                       g.RI_freqindex=g.RI_freqindex+g.RI_freqstep;
                                        if g.RI_freqindex>mm
                                            break
                                        end
%                                          if g.RI_freqindex>=(g.RI_freqstep + 1)
%                                                  if g.RI_freqlist(g.RI_freqindex)>g.RI_crossfreq &&  g.RI_freqlist(g.RI_freqindex-g.RI_freqstep)<=g.RI_crossfreq
%                                                      g.rfsw(1);
%                                                  end       
%                                          end      
                                   case 'down'
                                       g.RI_freqindex=g.RI_freqindex-g.RI_freqstep;
                                        if g.RI_freqindex<1
                                           break
                                        end
%                                          if g.CI_freqindex<=(mm-g.CI_freqstep )
%                                              if g.CI_freqlist(g.CI_freqindex)<g.CI_crossfreq &&  g.CI_freqlist(g.CI_freqindex+g.CI_freqstep)>=g.CI_crossfreq
%                                                 g.rfsw(0) 
%                                              end             
%                                          end
                               end
                                %select the signal path   
                            %Set the signal gen freq
                              g.hf.freq(freq);
                        
                            % turn on the AM modulation   
                              if g.RI_IF_AM
                                        g.hf.AM_amp=g.CI_AM_amp;
                                        g.hf.AM_freq=g.CI_AM_freq;
                                        g.hf.AM_On;
                               else
                                        g.hf.AM_Off;
                               end
                            % calcuate the  gain from the calibration file
                            % hfgain is the signal gen output level.
                            % ampgain is the AR 60S1G6 programmable gain.
                            % the old 100W1000MA is not programmable, set
                            % the fixed gian to 75% percent. 
                            
                              hfgain=interp1(d.ri.coeffs{k+1}(:,1),d.ri.coeffs{k+1}(:,2),freq);
                              ampgain=interp1(d.ri.coeffs{k+1}(:,1),d.ri.coeffs{k+1}(:,3),freq);  
                              comp=interp1(d.ri.comp(:,1),d.ri.comp(:,4),freq);
                            % set the signal gen level. 
                              g.hf.amp(hfgain);
                            % switch the relay when the freq pass crossover freq.  
                              if freq<1e9
                                 g.rfsw.select(0);   
                             else
                                 if tmp==0
                                     tmp=1;
                                    g.rfsw.select(1); pause(1);
                                    g.amp1.on; pause(2);
                                    g.amp1.gain(ampgain); pause(1);
                                 end
                                 
                              end
                             
                             % set the signal gen amplitude
                             
                              g.amp1.gain(ampgain);
                              try
                                  if freq<1e9
                                      
                                      Pactual=g.ps1.read(freq);
                                      %compare the output power with the measured
                                      %power. the coupler has coupling factor of
                                      %50dB, the LB amplifier at 75% power
                                      %output has 48dB gain *interp1([80e6 6e9],[1 2.5],freq)
                                        if ~isempty(Pactual)
                                          r=10^((Pactual-comp-hfgain+1)/20);
                                          % debug code, 
                                           if r<1
                                               r=(rand*0.5+3)/3;
                                               r_sim=[freq r]
                                               tmpN=tmpN+1;
                                               if tmpN>=20
                                                disp('Check the power meter please!, run in simulaiton mode')
                                                 tmpN=0;   
                                                 g.RI_stop=1;
                                                 break;
                                               end
                                               
                                           else 
                                               tmpN=0;
                                               
                                           end

                                        else
                                            disp('Check the power meter please!, run in simulaiton mode')
                                            r=1
                                        end
                                        

                                  else
                                      Pactual=g.ps2.read(freq);
                                      %compare the output power with the measured
                                      %power. the coupler has coupling factor of
                                      %42dB *interp1([80e6 6e9],[1 2.5],freq)
                                      if ~isempty(Pactual)
                                         r=10^((Pactual-comp-8-hfgain)/20);
                                           % debug code, 
                                           if r<1
                                               r=(rand*0.5+3)/3;
                                               r_sim=[freq r]
                                               tmpN=tmpN+1;
                                               if tmpN>=20
                                                disp('Check the power meter please!, run in simulaiton mode')
                                                 tmpN=0;   
                                                 g.RI_stop=1;
                                                 break;
                                                 
                                               end
                                               
                                           else 
                                               tmpN=0;
                                           end
                                           % end of debug
                                      else
                                        disp('Check the power meter please!, run in simulaiton mode')
                                        r=1;
                                      end
                                      

                                  end
                              catch me
                                disp('Check the power meter please!, run in simulaiton mode')
                                r=1;
                              end
                              
                              %huhuhu 
                              pause(g.RI_dwellingtime);
                              g.RI_x=[g.RI_x; freq 3*r];

                           
                                lin.XData=g.RI_x(:,1);
                                lin.YData=g.RI_x(:,end);
                                drawnow;
                           end
                           
                        if g.RI_stop
                                g.RI_Break_by_pause=1;
                        else 
                                g.RI_Break_by_pause=0;
                                g.hf.amp(-100); pause(0.1);
                                g.hf.AM_Off;
                                g.hf.Off; pause(0.1);
                                g.amp1.gain(0); pause(1);
                                g.amp1.off; pause(1);
                        end
                        
        
    



end


function CI_scan(g,direction,ax)
         
          
            g.CI_stop=0; mm=length(g.CI_freqlist);
                        % if freqindex is in the range,and stop button is
                       % not pushed
               
                           while ~g.CI_stop && ~(g.CI_freqindex<1) && ~(g.CI_freqindex>mm)
                               freq=g.CI_freqlist(g.CI_freqindex);
                               % check if the crossover frequency is hit. 
                     
                                   % if the frequency 
                               switch direction 
                                   case 'up'
                                             if g.CI_freqindex>=(g.CI_freqstep + 1)
                                                 if g.CI_freqlist(g.CI_freqindex)>g.CI_crossfreq &&  g.CI_freqlist(g.CI_freqindex-g.CI_freqstep)<=g.CI_crossfreq
                                                     f = warndlg('Please switch the RF source from LF gen to HF gen','Reminder.');
                                                    drawnow     % Necessary to print the message
                                                    waitfor(f);
                                                 end             
                                             end
  
                                   case 'down'
                                         if g.CI_freqindex<=(mm-g.CI_freqstep )
                                             if g.CI_freqlist(g.CI_freqindex)<g.CI_crossfreq &&  g.CI_freqlist(g.CI_freqindex+g.CI_freqstep)>=g.CI_crossfreq
                                                 f = warndlg('Please switch the RF source from HF gen to LF gen','Reminder.');
                                                drawnow     % Necessary to print the message
                                                waitfor(f);
                                             end             
                                         end
                                     
                            
                            
                               end
                   % Set the sig gen to the freq 
                              if freq<=g.CI_crossfreq
                                    g.lf.freq(freq);
                                    g.lf.amp(g.CI_lfgenamp);
                                    if g.CI_IF_AM
                                        g.hf.AM_amp=g.CI_AM_amp;
                                        g.hf.AM_freq=g.CI_AM_freq;
                                        g.hf.AM_On;
                                    else
                                        g.hf.AM_Off;
                                    end
                                    g.ps.read(freq);
                          
                                    while g.ps.amp+g.CI_attenuation<22.6   || g.ps.amp+g.CI_attenuation>23.6
                                                   
                                        if g.CI_lfgenamp<3.5 % limit of 33120A vpp=9v
                                            if g.CI_lfgenamp <2.5
                                                g.CI_lfgenamp=g.CI_lfgenamp+0.02;
                                                g.lf.amp(g.CI_lfgenamp); pause(0.1);
                                            else
                                                disp('Warning: Amplitude is out of limit of funciton generator!');
                                                break;
                                            end
                                            
                                        else g.ps.amp+g.CI_attenuation>23.6
                                             g.CI_lfgenamp=g.CI_lfgenamp-0.02;
                                             g.lf.amp(g.CI_lfgenamp); pause(0.1);
                                        end
                                        g.ps.read(freq);
                                       end
                               else 
                                   	g.hf.freq(freq);
                                    g.hf.amp(g.CI_hfgenamp);
                                    if g.CI_IF_AM
                                        g.hf.AM_amp=g.CI_AM_amp;
                                        g.hf.AM_freq=g.CI_AM_freq;
                                        g.hf.AM_On;
                                    else
                                        g.hf.AM_Off;
                                    end
                                    
                                                                        
                                    g.hf.On;
                                    g.ps.read(freq);
                               
                                     % adjust the value to meet the
                                    % requirement
                                        while ((g.ps.amp+g.CI_attenuation)<22.6) || ((g.ps.amp+g.CI_attenuation)>23.6) 
                                            try
                                              if g.ps.amp+g.CI_attenuation<22.6
                                                  if g.CI_hfgenamp<10 % limit of 33120A vpp=9v
                                                        g.CI_hfgenamp=g.CI_hfgenamp+0.1;

                                                    else 
                                                        disp('Warning: Amplitude is out of limit of Signal gen generator!');
                                                  end
                                              else g.ps.amp+g.CI_attenuation>23.6
                                                   g.CI_hfgenamp=g.CI_hfgenamp-0.1;
                                              end
																		   
																			   
											 
                                            g.hf.amp(g.CI_hfgenamp);
                                            g.ps.read(freq);
                                            catch
                                                disp('error')
                                            end
                                        
                                       end
                                    
                               
                              end
                               
                               pause(g.CI_dwellingtime)
                               try
                               g.ps.read(freq)
                               catch
                               end
                               g.CI_result=[g.CI_result;freq dbm2vrms(g.ps.amp+g.CI_attenuation)];

                               
						   
                               % set the new freq value
                               for i=1:length(ax.Children)
                                    if strcmp(ax.Children(i).Tag,'result')
                                           l1=ax.Children(i);
                                           l1.XData= g.CI_result(:,1)/1e6;
                                           l1.YData= g.CI_result(:,2);
                                    end
                               end
                               
                               switch direction 
                                   case 'up'
                                g.CI_freqindex=g.CI_freqindex+g.CI_freqstep;
                                   case 'down'
                                 g.CI_freqindex=g.CI_freqindex-g.CI_freqstep;
                               
                               end
                               
                               
                           end % end of while scan
end % end of function 

function y=dbm2vrms(x)
%y=sqrt(10.^(x./10)*50*16/2/1000);
y=sqrt(0.001*50)*10^(x/20);
end
