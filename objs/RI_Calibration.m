function RI_Calibration(source, callbackdata)
global g
global d
global s
    kk=source.UserData(3);
    switch kk
        case {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}
            switch g.ri.mode % view mode
                case 1 % measurement mode/Coefficient view mode
                    source.BackgroundColor='green';
                    result=fieldpoint;
                    d.ri.field(kk)={result};
                    %save the data into file.
                    fname=['FieldPoint' num2str(kk) '.mat'];
                    save(fname,'result');
                case 2 % field view mode
                    g.ri.k=kk;
                    plot_fp(g.ri.k,g.ri.polarity,g.ri.index);
            end
            
        case 22 % change the polarity
            if strcmp(source.String,'Vertical')
                s.tw.setpolar(1);
            else
                s.tw.setpolar(0);
            end
                g.b8c.t3c.bc.btc.bt1.Enable='on';
                g.b8c.t3c.bc.btc.bt2.Enable='on';
                g.b8c.t3c.bc.btc.bt3.Enable='on';
                g.b8c.t3c.bc.btc.bt4.Enable='on';
                g.b8c.t3c.bc.btc.bt5.Enable='on';
                g.b8c.t3c.bc.btc.bt6.Enable='on';
                g.b8c.t3c.bc.btc.bt7.Enable='on';
                g.b8c.t3c.bc.btc.bt8.Enable='on';
                g.b8c.t3c.bc.btc.bt9.Enable='on';
                g.b8c.t3c.bc.btc.bt10.Enable='on';
                g.b8c.t3c.bc.btc.bt11.Enable='on';
                g.b8c.t3c.bc.btc.bt12.Enable='on';
                g.b8c.t3c.bc.btc.bt13.Enable='on';
                g.b8c.t3c.bc.btc.bt14.Enable='on';
                g.b8c.t3c.bc.btc.bt15.Enable='on';
                g.b8c.t3c.bc.btc.bt16.Enable='on';
    
        case 31 % save
                [filename, pathname] = uiputfile('*.mat', 'Pick an MATLAB code file');
                if isequal(filename,0) || isequal(pathname,0)
                   disp('User pressed cancel')
                else
                    fname= fullfile(pathname, filename);
                end
                fields=d.ri.field;
                save (fname, 'fields');
                
        case 32  % load
               [filename, pathname] = uigetfile('*.mat', 'Pick a MATLAB code file');
                if isequal(filename,0) || isequal(pathname,0)
                   disp('User pressed cancel')
                else
                   fname=fullfile(pathname, filename);
                end
                load (fname);
                d.ri.field=fields;
                g.ri.mode=2;
                g.ri.k=1;
                g.ri.polarity=1;
                 g.b8c.t3c.bc.btc.b12a.Value=1;
                 g.b8c.t3c.bc.btc.b12b.Value=0;
                 
                g.ri.index=6;
                plot_fp(g.ri.k,g.ri.polarity,g.ri.index);
        case 33 % new button 
                g.b8c.t3c.bc.btc.bt1.Enable='on';
                g.b8c.t3c.bc.btc.bt2.Enable='on';
                g.b8c.t3c.bc.btc.bt3.Enable='on';
                g.b8c.t3c.bc.btc.bt4.Enable='on';
                g.b8c.t3c.bc.btc.bt5.Enable='on';
                g.b8c.t3c.bc.btc.bt6.Enable='on';
                g.b8c.t3c.bc.btc.bt7.Enable='on';
                g.b8c.t3c.bc.btc.bt8.Enable='on';
                g.b8c.t3c.bc.btc.bt9.Enable='on';
                g.b8c.t3c.bc.btc.bt10.Enable='on';
                g.b8c.t3c.bc.btc.bt11.Enable='on';
                g.b8c.t3c.bc.btc.bt12.Enable='on';
                g.b8c.t3c.bc.btc.bt13.Enable='on';
                g.b8c.t3c.bc.btc.bt14.Enable='on';
                g.b8c.t3c.bc.btc.bt15.Enable='on';
                g.b8c.t3c.bc.btc.bt16.Enable='on';
                g.ri.mode=1;
        case 34 % display all Verify
              % select the pority mess
              freq=d.ri.field{1}{1}(:,1);
              N=length(freq);
              result=[]; y3=[];y4=[];
              for i=1:N % freq
                    
                    x1=[];
                    for k=1:16
                      x1=[x1 db(d.ri.field{k}{1}(i,6)/3)];
                    end
                     y1=checkUF(x1);
                     y3=[y3; freq(i) y1 x1];
                
                    x2=[];
                    for k=1:16
                      x2=[x2 db(d.ri.field{k}{2}(i,6)/3)];
                    end
                     y2=checkUF(x2);
                     y4=[y4;freq(i) y2 x2];
                    
              end
              
              
              d.ri.FU(1)={y3};
              d.ri.FU(2)={y4};
              %plot field uniformity
               if g.b8c.t3c.bc.btc.b12a.Value
                     plot_fu(1);
               else
                     plot_fu(2);
               
               end
               
                 
              %
        case 35
            g.p2.Selection=4;
        case 41 % measure the coefficents
            
            ax=g.b8c.t3c.bc.ax1;
            cla(ax);
            lin=semilogx(ax,80e6,3,'*');
          
            xlim(ax,[80e6 6e9]);
            ylim(ax,[0 5]);
            xlabel(ax,'Frequency');
            ylabel(ax,'Field Strength V/m');
            grid(ax,'on');hold(ax,'on');
            
            start=str2num(g.b8c.t3c.bc.btc.b5.String);
            stop=str2num(g.b8c.t3c.bc.btc.b7.String);
            number=str2num(g.b8c.t3c.bc.btc.b9.String);
            d.ri.freq=logfreq(start,stop,number);
            freq=d.ri.freq;
            for k=0:1
                s.tw.setpolar(k);
                pause(5);
                x=[];
                s.hf.amp(-10);
                s.hf.Off
                s.amp1.gain(3072); pause(0.5);
                s.amp1.off;
                pause(0.5);
                coeff=[]; swdelay=0;               
                for i=1:length(freq)
                    s.hf.freq(freq(i));s.hf.On;
                    if freq(i)<1e9
                      s.rfsw.select(0);
                      s.amp1.off;
                      [hfgain ampgain delta]=fn_CI_seekAmplitude(s,0); % for lower band
                    
                    else
                      s.rfsw.select(1);  
                      if swdelay==0
                             s.rfsw.select(1);
                             swdelay=1;
                             s.amp1.gain(3072);
                             pause(0.5);
                             s.amp1.on;
                             pause(3);

                      end
                      
                      s.amp1.on;
                      [hfgain ampgain delta]=fn_CI_seekAmplitude(s,1); % for higher band
                    end
                    coeff=[coeff; freq(i) hfgain ampgain delta];
                    
                    s.hf.amp(hfgain);
                    s.amp1.gain(ampgain);
                    pause(0.2)
                    tmp=s.fp.read;
                    if freq(i)<1e9
                          psValue=s.ps1.read(freq(i));
                    else
                          psValue=s.ps2.read(freq(i));
                    end
                    x=[x; freq(i) psValue tmp ];
                    pause(0.2)
                    lin.XData=x(:,1);
                    lin.YData=x(:,end);
                    drawnow;
                end
                d.ri.coeffs(k+1)={[coeff x(:,2:end)]}; % coeffs{0} is coeffect for H and coeffes {1} is for V [siggen_amp amp_gain PowersensorRead Measured_fieldstrength]
            end
            s.hf.amp(-100); pause(0.1);
            s.hf.Off
            s.amp1.gain(0);pause(0.5);
            s.amp1.off; pause(0.5);

            
        case 42 % save the coefficents
            try
            coeffs=d.ri.coeffs;    
            catch me
                msgbox('the coefficents is not ready to save. Please take measurement first!')
                return
            end
            
            [filename, pathname] = uiputfile('*.mat', 'Pick an Coefficients file name to save');
                if isequal(filename,0) || isequal(pathname,0)
                   disp('User pressed cancel')
                else
                    fname= fullfile(pathname, filename);
                end
                save (fname, 'coeffs');
    
        case 43 % load teh coefficients
            
                [filename, pathname] = uigetfile('*.mat', 'Pick a Coefficents file for RI test');
                if isequal(filename,0) || isequal(pathname,0)
                   disp('User pressed cancel')
                else
                  fname= fullfile(pathname, filename);
                end
                load (fname);
                d.ri.coeffs=coeffs;
                g.b8c.t3c.bc.btc.b12a.Value=1;
                g.b8c.t3c.bc.btc.b12b.Value=0;
                g.ri.polarity=1;
                g.ri.index=6;
                g.ri.mode=3;
                plot_coeff(g.ri.polarity,g.ri.index) ;
               
        case 44
            if g.b8c.t3c.bc.btc.b12a.Value
                g.b8c.t3c.bc.btc.b12b.Value=0;
                 g.ri.polarity=1;
            else
                g.b8c.t3c.bc.btc.b12b.Value=1;
                 g.ri.polarity=2;
            end
            switch g.ri.mode
                case 3 % coefficent mode
                    plot_coeff(g.ri.polarity,g.ri.index);
                case 2
                    plot_fp(g.ri.k,g.ri.polarity,g.ri.index);
            end
            
        case 45
            if g.b8c.t3c.bc.btc.b12b.Value
                g.b8c.t3c.bc.btc.b12a.Value=0;
                g.ri.polarity=2;
            else
                g.b8c.t3c.bc.btc.b12a.Value=1;
                 g.ri.polarity=1;
            end
             switch g.ri.mode
                case 3 % coefficent mode
                plot_coeff(g.ri.polarity,g.ri.index);
                 case 2
                plot_fp(g.ri.k,g.ri.polarity,g.ri.index);
             end
             
            
        case 46
             g.ri.index=g.ri.index-1;
             switch g.ri.mode
                 case 3
                     if g.ri.index<2
                      g.ri.index=9;
                    end
                     plot_coeff(g.ri.polarity,g.ri.index);
                 case 2
                     if g.ri.index<2
                      g.ri.index=6;
                    end
                      plot_fp(g.ri.k,g.ri.polarity,g.ri.index);
             
             
             end
             

        case 47
             g.ri.index=g.ri.index+1;
              switch g.ri.mode
                 case 3
                     if g.ri.index>9
                      g.ri.index=2;
                    end

                     plot_coeff(g.ri.polarity,g.ri.index)
                  case 2
                     if g.ri.index>6
                      g.ri.index=2;
                    end
                      plot_fp(g.ri.k,g.ri.polarity,g.ri.index);
              end
              
            
                
        case 24
            
            s.tw.sk(str2num(source.String));
        case {26,28,30}
            start=str2num(g.b8c.t3c.bc.btc.b5.String);
            stop=str2num(g.b8c.t3c.bc.btc.b7.String);
            number=str2num(g.b8c.t3c.bc.btc.b9.String);
            d.ri.freq=logfreq(start,stop,number);
            
            
    end
end

function result=fieldpoint

    % Calibrated. 
    global s
    global g
    global d

    
    
    % HF pass
    % turn on signal gen, set the amplitude to -10dBm
    s.hf.amp(-10);
    s.hf.Off
    % set the gain to 75% on amplifer
    s.amp1.gain(3072)
    s.amp1.off;
    % initilize the display 
    ax=g.b8c.t3c.bc.ax1;
    cla(ax);
    lin=semilogx(ax,80e6,3,'*');
          
            xlim(ax,[80e6 6e9]);
            ylim(ax,[0 5]);
            xlabel(ax,'Frequency');
            ylabel(ax,'Field Strength V/m');
            grid(ax,'on');hold(ax,'on');
            title(ax, 'Field Uniformity Test In Progress')
    % Start the constant power sweep for each frequency 
    start=str2num(g.b8c.t3c.bc.btc.b5.String);
    stop=str2num(g.b8c.t3c.bc.btc.b7.String);
    number=str2num(g.b8c.t3c.bc.btc.b9.String);
    d.ri.freq=logfreq(start,stop,number);
    freq=d.ri.freq; 
    for k=0:1
        s.tw.setpolar(k);
        pause(5);
            % field uniformity temproary collector
        x=[]; swdelay=0;
        for i=1:length(freq)
              %set the freq on signal gen, adjust the amplitude according to the
              %coefficeint matrix. 
              s.hf.freq(freq(i));
              hfgain=interp1(d.ri.coeffs{k+1}(:,1),d.ri.coeffs{k+1}(:,2),freq(i));
              ampgain=interp1(d.ri.coeffs{k+1}(:,1),d.ri.coeffs{k+1}(:,3),freq(i));           
              s.hf.amp(hfgain);      
              s.hf.On 
               %select the signal path   
             if freq(i)<1e9
                 s.rfsw.select(0);   
                 s.amp1.gain(-100);
                 s.amp1.off;
             else
                 s.rfsw.select(1);
                 if swdelay==0    
                     swdelay=1;
                     s.amp1.gain(3072);
                     s.amp1.on;
                      tmp=s.fp.read; tmp1=0;
                     while tmp(end)<0.5 && tmp1<100
                         s.amp1.on;
                         tmp=s.fp.read;
                         pause(1);
                         tmp1=tmp1+1;
                     end
                     
                     
                 end
                     
                 s.amp1.gain(ampgain);
                 s.amp1.on;
             end

            pause(0.5)
            %read the field strength
            tmp=s.fp.read;
            if freq(i)<1e9
                  psValue=s.ps1.read(freq(i));
            else
                  psValue=s.ps2.read(freq(i));
            end
            x=[x; freq(i) psValue tmp ];
            pause(0.2);
            lin.XData=x(:,1);
            lin.YData=x(:,end);
            drawnow;
        end
        result(k+1)={x};
    end
    
            s.hf.amp(-100);
            s.hf.Off;
            s.amp1.gain(0); pause(1);
            s.amp1.off;
            pause(1);
       msgbox('Test is done!');
    
end
function plot_coeff(polarity,index)
global g
global d
  ax=g.b8c.t3c.bc.ax1;
    cla(ax);
    xlim(ax,[80e6 6e9]);
    ylim(ax,'auto');
    xlabel(ax,'Frequency');
    ylabel(ax,'Field Strength V/m');
    grid(ax,'on');hold(ax,'on');
    set(ax,'xscale','log');
    % field strength
    if index>9
      index=2;
    end
    if index<2
      index=9;
    end
    
    lin=semilogx(ax,d.ri.coeffs{polarity}(:,1),d.ri.coeffs{polarity}(:,index),'*');
    switch (index)
        case 2
           ylabel(ax,'Signal Gen Amplitude dBm');
        case 3
           ylabel(ax,'Amplifier Gain');
        case 4
           ylabel(ax,'Delta (dB)');
        case 5
           ylabel(ax,'Power Sensor Target(dBm)');
        case 6
           ylabel(ax,'Ex');ylim(ax,[0 5]);
        case 7
           ylabel(ax,'Ey');ylim(ax,[0 5]);
        case 8
           ylabel(ax,'Ez'); ylim(ax,[0 5]);
        case 9
           ylabel(ax,'Total Field');ylim(ax,[0 5]);
         
    end
    
    
end

function    plot_fp(k,polarity,index)

global g
global d
  ax=g.b8c.t3c.bc.ax1;
    cla(ax);
    xlim(ax,[80e6 6e9]);
    ylim(ax,'auto');
    xlabel(ax,'Frequency');
    ylabel(ax,'Field Strength V/m');
    grid(ax,'on');hold(ax,'on');
    set(ax,'xscale','log');
    % field strength
   str1={'Horizontal','Vertical'};
    lin=semilogx(ax,d.ri.field{k}{polarity}(:,1),d.ri.field{k}{polarity}(:,index),'*');
    title(ax,['Field point: ' num2str(k) ' ; Polarity:' str1{polarity}]);
    switch (index)
        case 2
           ylabel(ax,'Power Sensor Target(dBm)');
        case 3
           ylabel(ax,'Ex V/m');ylim(ax,[0 5]);
        case 4
           ylabel(ax,'Ey V/m');ylim(ax,[0 5]);
        case 5
           ylabel(ax,'Ez V/m'); ylim(ax,[0 5]);
        case 6
           ylabel(ax,'Total Field V/m');ylim(ax,[0 5]);
         
    end
    
    
end

function y=checkUF(x1)
x1=sort(x1);
 m=1;
while m<=5
    delta=x1(m+11)-x1(m);
  if delta<=6
          y=[1 delta mean(x1(m:m+11))];
          break;
  else
      m=m+1;
  end
   if m==6 
    y=[0 delta mean(x1(5:16))];
   break;
  end
end

end

function plot_fu(polarity)
global g
global d
  ax=g.b8c.t3c.bc.ax1;
    cla(ax);
    xlim(ax,[80e6 6e9]);
    ylim(ax,[0 10]);
    xlabel(ax,'Frequency');
    ylabel(ax,'Field Variation');
    grid(ax,'on');hold(ax,'on');
    set(ax,'xscale','log');
    % field strength
   str1={'Horizontal','Vertical'};
    limt=semilogx(ax,[80e6 6e9],[6 6],'Color','r');
    lin=semilogx(ax,d.ri.FU{polarity}(:,1),d.ri.FU{polarity}(:,3),'*','Color','b');
    
    title(ax,['Field Uniformity variation from 14 out of 16 points ; Polarity:' str1{polarity}]);
 
    
end

