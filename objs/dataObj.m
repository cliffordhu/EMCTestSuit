classdef dataObj <handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ph; % data holder current measrued H
        pv; %data holder currently measrued V
        pL; %data holder for current CE Line
        pN; %data holder for current CE Netrual
       
        uh; % data holder for user loaded H
        uv; % data holder for user loaded V
        p; % plot the data
        polar_freq;
        fig_3d;
        fig_2d;
        fig_polar;
        lim=0; %0: 3m, 1: CE 2: OATs 
        resultHscan;
        DefaultRBW_FindPeak=0.1e6;
        plotline=[];
        ri;

    end
    
    methods
        %% Create Object
        function s=viewdata
        end
        %% Visualize the data 
        function view3D(s,ax,dataset)
            switch dataset
                case 0
                    s.p=s.ph;
                case 1
                    s.p=s.pv;
                case 2
                    s.p=s.uh;
                case 3
                    s.p=s.uv
            end
            
              cla(ax);
                mesh(ax,s.p.ttpos,s.p.freq,s.p.result')
                hold on

                xlabel('Rotation Angle (Degree)' );
                ylabel('Frequency (MHz)');
                zlabel('Amplitude dBuV')
   
            if s.p.polar(1) ==0
            title('Horizontal');
            else
            title('Vertical');
            end
            view(ax,45,45)
        end
        function view2D(s,ax)
%             switch dataset
%                 case 0
%                     s.p=s.ph;
%                 case 1
%                     s.p=s.pv;
%                 case 2
%                     s.p=s.uh;
%                 case 3
%                     s.p=s.uv;
%             end
%             
              if ax==0
                s.fig_2d=figure;
                ax=axes;
              end
              
             
            % Userdata is refreshed after semilog command need to be
            % repalced
            temp=ax.UserData;
            cla(ax);
           
            switch s.lim
                case 0 % RE
                    ll1=[30e6 50; 220e6 50; 220e6 57; 1e9 57;];
                    ll2=ll1;ll2(:,2)=ll1(:,2)-6;
                    semilogx(ax,ll1(:,1),ll1(:,2),'r',...
                    ll2(:,1),ll2(:,2),'k--');
                    hold on ; grid on;
                    plotline=semilogx(ax,s.p.freq,s.p.maxhold);hold(ax, 'on');
                    xlim(ax,[s.p.freq(1) s.p.freq(end)]);
                    xlabel(ax,'Frequency Hz');ylabel(ax,'Emission level dBuV/m');
                   legend(ax,'CISPER 11 GRP 1 Class A Limit (3 Meter Chamber)','6dB buffer','Emission level','Location','NorthWest')
                
            
                case 1 %CE
                    
                    ll1=[150e3 79; 0.5e6 79; 0.5e6 73; 30e6 73];
                    ll2 =[150e3 66; 0.5e6 66; 0.5e6 60; 30e6 60];
                    ll3=[150e3 60; 0.5e6 60; 0.5e6 54; 30e6 54];
                    semilogx(ax,ll1(:,1),ll1(:,2),'r',...
                    ll2(:,1),ll2(:,2),'m',...
                    ll3(:,1),ll3(:,2),'k--');
                    
                    hold on ; grid on;
                    plotline=semilogx(ax,s.p.freq,s.p.maxhold);hold(ax, 'on');
                    %tmpline=semilogx(ax,ll1(1,1),ll1(1,2),'r^','Visible','off') % dummy point for legends
                    set(ax,'defaultLegendAutoUpdate','off'); 
                    xlim(ax,[s.p.freq(1) s.p.freq(end)]);
                    xlabel(ax,'Frequency Hz');ylabel(ax,'Emission level dBuV');
                    legend(ax,'GRP 1 Class A Peak Limit','GRP 1 Class A Average Limit','-6dB buffer to Average limit',...
                          'Conducted Emission','Location','SouthWest');
            
                    set(ax, 'XScale', 'log');
                    
                case 2 %OATS
                    ll1=[30e6 40; 220e6 40; 220e6 47;1e9 47];
                    ll2=ll1; ll2(:,2)=ll1(:,2)-6;
                    semilogx(ax,ll1(:,1),ll1(:,2),'r',...
                    ll2(:,1),ll2(:,2),'k--');
                     hold on ; grid on;
                    plotline=semilogx(ax,s.p.freq,s.p.maxhold);hold(ax, 'on');
                    xlim(ax,[s.p.freq(1) s.p.freq(end)]);
                    if isfield(s.p, {'peaktable2'})
                        
                        if max(s.p.peaktable2.Peak_dBuV)<50
                            ylim([0, 60]);
                        else
                            ylim([0, 20+max(s.p.peaktable2.Peak_dBuV)]);
                        end
                     end
                
                        xlabel(ax,'Frequency Hz');ylabel(ax,'Emission level dBuV/m');
                       legend(ax,'CISPER 11 GRP 1 Class A Limit (10 Meter OATs)','6dB buffer','Emission level','Location','NorthWest')
                       set(ax, 'XScale', 'log')
               
            end
                    
               
            ax.UserData=temp;
           
        end
        function viewangle(s,ax,r)
        view(ax,r(1),r(2));
        end
        
        function viewpolar(s,f,ax)
             view(ax,0,90);
             
             [Y index]=max(s.p.maxhold);
             s.polar_freq = s.p.freq(index); 

           if isempty(index)
                    msgbox('The  selected frequency is out of range! Please check your input!');
                    return
            end


              s.plotline=polar(ax,s.p.ttpos./180*pi,s.p.result(:,index)')
             

                xlabel(ax,'Rotation Angle (Degree)' );
                ylabel(ax,'Amplitude dBuV/m');

            title(ax,['Polar Plot for ' num2str(s.polar_freq/1e6) ' MHz']);
           
        end
        function viewpolar1(s,f,ax)
           view(ax,0,90);
            index=find(s.p.freq>=s.polar_freq);
            freq_index=index(1);
            plotline=ax.Children(1);
            [plotline.XData ,plotline.YData]=pol2cart(s.p.ttpos./180*pi,s.p.result(:,freq_index)');
          %  [x,y]=pol2cart(s.p.ttpos./180*pi,s.p.result(:,freq_index)');
            drawnow;

        end
        
        function overlaypeaks(s,ax,uitb)
        cla(ax);   
        s.view2D(ax);
        hold(ax,'on');
        if ~isempty(s.p.peak)
          tmp1=semilogx(ax,s.p.peak(:,1),s.p.peak(:,2),'r^') ;
          tmp1.Annotation.LegendInformation.IconDisplayStyle = 'off';
          
        else 
               msgbox('No peaks are found!');
           % return;
        end
        
        if uitb~=-1
            if ~isempty(s.p.peaktable)
                uitb.Data=table2array(s.p.peaktable);
                uitb.ColumnName=s.p.peaktable.Properties.VariableNames;
            else
                 uitb.Data=[];
          
            end
        end 
        % list the table in uitable. 
        end
        
        function overlayselectedpeaks(s,ax,uitb)
        cla(ax);   
        s.view2D(ax);
        hold(ax,'on');
        if ~isempty(s.p.peaktable)
          semilogx(ax,s.p.peaktable.freq,s.p.peaktable.peaks,'r^') ;
        else 
             msgbox('No peaks are found!');
            return;
        end
        
        if uitb~=-1
          if ~isempty(s.p.peaktable)
                uitb.Data=table2array(s.p.peaktable);
                uitb.ColumnName=s.p.peaktable.Properties.VariableNames;
          else
                uitb.Data=[];
               %
          end
        end 
        % list the table in uitable. 
        
        end
        
        function overlayfilteredpeaks(s,ax,uitb)
       
        cla(ax);        
        s.view2D(ax);
        hold(ax,'on');
        if ~isempty(s.p.peakrbw)
            semilogx(ax,s.p.peakrbw(:,1),s.p.peakrbw(:,2),'r^');
        else 
            msgbox('No peaks are found!');
         %   return;
        end
        
        if uitb~=-1 
            if ~isempty(s.p.peaktable) 
                uitb.Data=table2array(s.p.peaktable);
                uitb.ColumnName=s.p.peaktable.Properties.VariableNames;
            else
                uitb.Data=[];
            end
        end
    end
        
        function overlay_peaktable2(s,ax,uitb)
        if ~isfield(s.p,'peaktable2')
            return 
        end
        cla(ax);       
        s.view2D(ax);
        hold(ax,'on');
        semilogx(ax,s.p.peaktable2.Freq_Hz(:),s.p.peaktable2.Amplitude_dBuV(:),'b^',...
                 s.p.peaktable2.Freq_Hz(:),s.p.peaktable2.Peak_dBuV(:),'bd',...
                 s.p.peaktable2.Freq_Hz(:),s.p.peaktable2.QuasiPeak_dBuV(:),'r*',...
                 s.p.peaktable2.Freq_Hz(:),s.p.peaktable2.Average_dBuV(:),'m+'); 
        switch s.lim
                                    case {0,2} % RE 3 meter or OATs
              legend(ax,'QPeak Limit','6dB buffer','Pre-Scan','PreScan Peak','Peak ','QuasiPeak','Average Peak','Location','NorthEast');
                             otherwise   %{CE}
              legend(ax,'QPeak Limit','AvgPeak Limit','6dB Buffer','MaxHold Scan','Prescan Peak','Peak','QuasiPeak','Average Peak','Location','NorthEast');
        end
              
             
        if uitb~=-1
            if ~isempty(s.p.peaktable) 
            uitb.Data=table2array(s.p.peaktable2);
                            switch s.lim
                                    case {0,2} % RE 3 meter or OATs
                                uitb.ColumnName={'Freq(Hz)','Amplitude(dBuV/m)','TurnTable(degree)',...
                                       'Tower(cm)','Polar','Peak(dBuV/m)','QuasiPeak(dBuV/m)',...
                                       'Average(dBuV/m)','DeltP(dB)','DeltQ(dB)','DeltA(dB)'};
                                otherwise   %{CE}
                                 uitb.ColumnName={'Freq(Hz)','Amplitude(dBuV)','Peak(dBuV)','QuasiPeak(dBuV)',...
                                       'Average(dBuV)','DeltP(dB)','DeltQ(dB)','DeltA(dB)'};    
                            end
                
                
            else
                uitb.Data=[];
            end
        end 
       
        
        end
        function creat_peaktable2(s,type)         
          % update the table. Join the result with the peaktable
          switch type
              case {'RE','OAT'}
          s.p.peaktable2=[];
           B=array2table(s.p.peakresult(:,4:end));
           B.Properties.VariableNames={'Peak','QuasiPeak','Average','DeltP','DeltQ','DeltA'};
           temp=size(B,1)
           s.p.peaktable2=[s.p.peaktable(1:temp,:),B];
           s.p.peaktable2.Properties.VariableNames={'Freq_Hz','Amplitude_dBuV','TurnTable_degree',...
                       'Tower_cm','Polar','Peak_dBuV','QuasiPeak_dBuV',...
                       'Average_dBuV','DeltP_dB','DeltQ_dB','DeltA_dB'};
          % s.p.peaktable2.Properties.ColumnName=  {'Freq(Hz)','Amplitude(dBuV/m)','TurnTable(degree)',...
           %                            'Tower(cm)','Polar','Peak(dBuV/m)','QuasiPeak(dBuV/m)',...
           %                            'Average(dBuV/m)','DeltP(dB)','DeltQ(dB)','DeltA(dB)'}; 
                   
                 
              case 'CE'
                          s.p.peaktable2=[];
           B=array2table(s.p.peakresult(:,4:end));
           B.Properties.VariableNames={'Peak','QuasiPeak','Average','DeltP','DeltQ','DeltA'};
           temp=size(B,1)
           s.p.peaktable2=[s.p.peaktable(1:temp,:),B];
       %   s.p.peaktable2=floor(s.p.peaktable2.*10)./10; % format
           s.p.peaktable2.Properties.VariableNames={'Freq_Hz','Amplitude_dBuV',...
                      'Peak_dBuV','QuasiPeak_dBuV', 'Average_dBuV',...
                      'DeltP_dB','DeltQ_dB','DeltA_dB'};
        %   s.p.peaktable2.Properties.ColumnName=  {'Freq(Hz)','Amplitude(dBuV)','Peak(dBuV)','QuasiPeak(dBuV)',...
         %              'Average(dBuV)','DeltP(dB)','DeltQ(dB)','DeltA(dB)'};    
                   
        end
        end
        
        
        function overlay_peaktable(s,f,uitb)
            % create the table for measurement
           % uitb.Data=table2array(s.p.peaktable);
            %uitb.ColumnName=s.p.peaktable.Properties.VariableNames;
           
           uitb.Data=table2array(s.p.peaktable);
           uitb.ColumnName=s.p.peaktable.Properties.VariableNames;
        % plot s.peaktable 
        % list the table in uitable. 
        
        end
      
%% Program GUI viualizaiton advanced
        function addmenu(s,f,ax) 
             c=uicontextmenu(f);
            ax.Children(1).UIContextMenu=c;
            m1=uimenu(c,'Label','Plot in new window','Callback',@plot_in_new_window);
        end
    
         function addmenup(s,f,ax) 
             c=uicontextmenu(f);
            ax.Children(1).UIContextMenu=c;
            m1=uimenu(c,'Label','Plot in new window','Callback',{@plot_in_new_windowp,ax});
         end
         function addmenut(s,f,tb,s1)
                 
         switch tb.Tag
         case 'tb1'
                    c = uicontextmenu(f);
                    uimenu(c,'label','Delete Current Signal','Callback',{@delete_slist,tb,s1});
                    uimenu(c,'label','Add Signal into the list','Callback',{@add_slist,tb,s1});
                    uimenu(c,'label','Goto the maximum radiation position','Callback',{@goto_maximum_position,tb,s1});
                    uimenu(c,'label','Update SA with current remeasurement result','Callback',{@writeSLIST,tb,s1}); 
                    uimenu(c,'label','remeasure those frequencies','Callback',{@remeasureSLIST,tb,s1});
                    uimenu(c,'label','Download the remeasurement result from SA','Callback',{@updateSLIST,tb,s1}); 
                    uimenu(c,'label','SA Mode','Callback',{@Set_SA_Mode,tb,s1});
                    uimenu(c,'label','EMI Mode','Callback',{@Set_EMI_Mode,tb,s1});
                    uimenu(c,'label','Plot the Height Scan result in 2D','Callback',{@plot_height_scan2D,tb});
                    uimenu(c,'label','Plot the Frequency Scan Remeasure result in 2D','Callback',{@plot_freq_scan2D,tb});
                    uimenu(c,'label','Plot the Height Scan result in 3D','Callback',{@plot_height_scan3D,tb});
                    uimenu(c,'label','Plot the Polar result in 2D','Callback',{@plot_tt_scan2D,tb});
                    tb.UIContextMenu=c;
             case 'tb2'
                       c = uicontextmenu(f);
                        uimenu(c,'label','Delete Current Signal','Callback',{@delete_slist,tb,s1});
                        uimenu(c,'label','Add Signal into the list','Callback',{@add_slist,tb,s1});
                        tb.UIContextMenu=c;
                 
             case 'tb3'
                   c = uicontextmenu(f);
                    uimenu(c,'label','Delete Current Signal','Callback',{@delete_slist,tb,s1});
                    uimenu(c,'label','Add Signal into the list','Callback',{@add_slist,tb,s1});
                    uimenu(c,'label','Goto the maximum radiation position','Callback',{@goto_maximum_position,tb,s1});
                    uimenu(c,'label','Update SA with current remeasurement result','Callback',{@writeSLIST,tb,s1}); 
                    uimenu(c,'label','remeasure those frequencies','Callback',{@remeasureSLIST,tb,s1});
                    uimenu(c,'label','Download the remeasurement result from SA','Callback',{@updateSLIST,tb,s1}); 
                    uimenu(c,'label','SA Mode','Callback',{@Set_SA_Mode,tb,s1});
                    uimenu(c,'label','EMI Mode','Callback',{@Set_EMI_Mode,tb,s1});
                    uimenu(c,'label','Plot the Height Scan result in 2D','Callback',{@plot_height_scan2D,tb});
                    uimenu(c,'label','Plot the Frequency Scan Remeasure result in 2D','Callback',{@plot_freq_scan2D,tb});
                    uimenu(c,'label','Plot the Height Scan result in 3D','Callback',{@plot_height_scan3D,tb});
                    uimenu(c,'label','Plot the Polar result in 2D','Callback',{@plot_tt_scan2D,tb});
                    tb.UIContextMenu=c;
                    
         end
         
         end
         

%% Data file operation 
        function save(s)
             d=s;
               %choose where to save%choose file  
          [filename, pathname] = uiputfile('.\UserData\*.mat', 'Save into matlab file');
        if isequal(filename,0) || isequal(pathname,0)
           disp('User pressed cancel')
           return;
        else
            fname=fullfile(pathname, filename);
            disp(['User selected ', fname]);   
        end
        
        save(fname,'d');
        end
        
        function load(s)
            %choose file  
       [filename, pathname] = uigetfile('.\UserData\*.mat', 'Pick a Matlab data file');
        if isequal(filename,0) || isequal(pathname,0)
           disp('User pressed cancel')
           return;
        else
            fname=fullfile(pathname, filename);
            disp(['User selected ', ]);   
        end
        
          load(fname,'d');
          pause(5);
          s.ph=d.ph;
          s.pv=d.pv;
          s.pN=d.pN;
          s.pL=d.pL;
          s.p=d.p;
          s.lim=d.lim;
          s.resultHscan=d.resultHscan;
         
  
            
        end
        %% Data analysis
        
        function mmaxhold(s,dataset)
            
          s.p.maxhold=max(s.p.result,[],1);
        
        end
        
        function findpeak(s,rbw)
            switch s.lim
                case 0 %RE
                    s.p.peak=[];s.p.peaktable=[];s.p.peakrbw=[];
                    index=find(s.p.freq>=220e6);
                    ancher=index(1);
                    % ask the buffer limit to qualify peaks seaching
                        prompt={'Enter the Margin Level (dB)'};
                        name='Input for Margin Level in dB';
                        numlines=1;
                        defaultanswer={'6'};
                        answer=inputdlg(prompt,name,numlines,defaultanswer);
                        margin=str2num(answer{1});

                    index1=find(s.p.maxhold(1:ancher)>(50-margin));
                    index2=find(s.p.maxhold(ancher+1:end)>(57-margin));
%                     % for ILC only 
%                     index1=find(s.p.maxhold(1:ancher)>(50-16));
%                     index2=find(s.p.maxhold(ancher+1:end)>(57-6));
                    
                    index=[index1 index2+ancher];
                    s.p.peak=[s.p.freq(index)' s.p.maxhold(index)'];
                    if~isempty(s.p.peak)
                            s.p.peakrbw=peakrbw(s.p.peak,rbw);
                            mm=size(s.p.peakrbw,1);
                            index=[];
                            for i=1:mm
                            temp=find(s.p.freq==s.p.peakrbw(i,1));
                            index=[index temp];
                            end 
                            freq=s.p.freq(index)';
                            peaks=s.p.maxhold(index)';

                            % find the position index 
                            [Y ind]=max(s.p.result(:,index),[],1);
                            ttpos=s.p.ttpos(ind)';
                            twpos=s.p.twpos(ind)';
                            polar=s.p.polar(ind)';
                            s.p.peaktable=table(freq,peaks,ttpos,twpos,polar);
                    end
                   
                case 1 %CE
                    
                    s.p.peak=[];s.p.peaktable=[];s.p.peakrbw=[];
                    index=find(s.p.freq>=0.5e6);
                    ancher=index(1);
                    % ask the buffer limit to qualify peaks seaching
                        prompt={'Enter the Margin Level (dB)'};
                        name='Input for Margin Level in dB';
                        numlines=1;
                        defaultanswer={'6'};
                        answer=inputdlg(prompt,name,numlines,defaultanswer);
                        margin=str2num(answer{1});


                    index1=find(s.p.maxhold(1:ancher)>(66-margin));
                    index2=find(s.p.maxhold(ancher+1:end)>(60-margin));
                    % Please change back to 66 60 , this is for ILC lower
                    % the limit to show the peaks. 
                    %index1=find(s.p.maxhold(1:ancher)>(56-6));
                    %index2=find(s.p.maxhold(ancher+1:end)>(50-6));
                    
                    index=[index1 index2+ancher];
                    s.p.peak=[s.p.freq(index)' s.p.maxhold(index)'];
                    if~isempty(s.p.peak)
                            s.p.peakrbw=peakrbw(s.p.peak,rbw);
                            mm=size(s.p.peakrbw,1);
                               index=[];
                            for i=1:mm
                            temp=find(s.p.freq==s.p.peakrbw(i,1));
                            index=[index temp];
                            end 
                            freq=s.p.freq(index)';
                            peaks=s.p.maxhold(index)';
                            s.p.peaktable=table(freq,peaks);
                    end
                    
                case 2
                   s.p.peak=[];s.p.peaktable=[];s.p.peakrbw=[];
                    index=find(s.p.freq>=220e6);
                    ancher=index(1);
                    index1=find(s.p.maxhold(1:ancher)>(40-6));
                    index2=find(s.p.maxhold(ancher+1:end)>(47-6));
                    index=[index1 index2+ancher];
                    s.p.peak=[s.p.freq(index)' s.p.maxhold(index)'];
                    if~isempty(s.p.peak)
                            s.p.peakrbw=peakrbw(s.p.peak,rbw);
                            mm=size(s.p.peakrbw,1);
                               index=[];
                            for i=1:mm
                            temp=find(s.p.freq==s.p.peakrbw(i,1));
                            index=[index temp];
                            end 
                            freq=s.p.freq(index)';
                            peaks=s.p.maxhold(index)';
                            s.p.peaktable=table(freq,peaks);
                    end
            end
            
             
            
         end
             
    end
    
end

function plot_in_new_window(source,var)
global d

    ax=gca;
    if ax.UserData(3)
        d.p=d.pv;
        title('Vertical');
    else
        d.p=d.ph;
        title('Horizontal');
    end
    d.mmaxhold;
    d.fig_2d=figure;
    ax1=axes;
    d.findpeak(d.DefaultRBW_FindPeak);
    d.view2D(ax1);
    d.overlaypeaks(ax1,-1);
    
    legend('CISPER 11 GRP 1 Class A Limit','6dB Margin','Emission level','Location','NorthWest')
    
end

function plot_in_new_windowp(source,evnt,ax)
global d
   
     d.fig_polar=figure;
     ax1=axes;clf;
    % ax=findobj(f,'type','Axes')
    copyobj(ax,d.fig_polar);
    set(gca,'ActivePositionProperty','outerposition');
    set(gca,'Units','normalized');
    set(gca,'OuterPosition',[0 0 1 1]);
    set(gca,'position',[0.1300 0.1100 0.7750 0.8150]);

end

function selectedpeak=peakrbw(PeakTable,Span)
% Span is half RWB  
 Span=Span/2;
%Check the closness 
    temp=diff(PeakTable(:,1));
    temp1=find(temp<=Span);
while ~isempty(temp1)
  temp2=[];
  % go through each picked frequecy and compare it with the adjacent peak,
  % select the bigger numer to save, smaller number to delete.
  for i =1 : length(temp1)
      if PeakTable(temp1(i),2)>PeakTable(temp1(i)+1,2)
        temp2=[temp2;temp1(i)+1];
      else 
        temp2=[temp2;temp1(i)];  
      end
  end
  % remove picked frequency saved in temp2

      PeakTable(temp2,:)=[];

  % reorder the index of peak list
      %[mm nn]=size(PeakTable);
     % PeakTable(:,1)=[1:mm];
  %check the proximity again by diff
      temp=diff(PeakTable(:,1));
      temp1=find(temp<=Span);
end
selectedpeak=PeakTable;
end
  function  plot_height_scan2D(source,evnt,tb)
  global d
    if isempty(tb.UserData)
      msgbox('Please select the signal first!');
      return
    end
      id=unique(tb.UserData(:,1));
              mm=size(id,1); nn=size(d.p.resultHscan,2);
      for i=1:mm
     
               if id(i)>nn
                msgbox('Data is not availble to display');
                   return;
               end
           
               
   f=figure
   ax=axes;
   [Y1 I1]= max(d.p.resultHscan{id(i)}.result,[],2);
   A=d.p.resultHscan{id(i)}.result;
   [Y, location]=max(A(:));
   [R,C] = ind2sub(size(A),location);
   
   result=[d.p.resultHscan{id(i)}.twpos' Y1];
   plot(ax,result(:,2),smooth(result(:,1),10));
   xlabel('Amplitude');ylabel('Antenna Height'); grid on
   title(['Antenna scan maximum hold for freqency ' num2str(d.p.resultHscan{id(i)}.freq(C)/1e6) 'MHz'] );
   legend(['At the turntable position of '  num2str(d.p.resultHscan{id(i)}.ttpos(1)) ' degree']);
       % s.p
      end
      
        end
 function plot_freq_scan2D(source,evnt,tb)
 global d
   if isempty(tb.UserData)
      msgbox('Please select the signal first!');
      return
    end
      id=unique(tb.UserData(:,1));
              mm=size(id,1); nn=size(d.p.resultHscan,2);
      for i=1:mm
     
               if id(i)>nn
                msgbox('Data is not availble to display');
                   return;
               end
           
               
   f=figure
   ax=axes;
   A=d.p.resultHscan{id(i)}.result;
   [Y, location]=max(A(:));
   [R,C] = ind2sub(size(A),location);
    result=d.p.resultHscan{id(i)}.result(R,:);
   plot(ax,d.p.resultHscan{id(i)}.freq,result);
   hold on;
   text(d.p.resultHscan{id(i)}.freq(C),Y,['Peak at freq=' num2str(d.p.resultHscan{id(i)}.freq(C)) ' Hz; Amplitude= ' ...
        num2str(Y) 'dBuV.']);
   xlabel('Frequency Hz');ylabel('Amplitude dBuV'); grid on
   title(['Zoom in view for freqency ' num2str(d.p.resultHscan{id(i)}.freq(C)/1e6) 'MHz'] );
   legend(['At the turntable position of '  num2str(d.p.resultHscan{id(i)}.ttpos(1)) ' degree; Antenna Position at ',...
        num2str(d.p.resultHscan{id(i)}.twpos(R)) 'cm' ]);
   
   
      end
      
 end
        
  function  plot_height_scan3D(source,evnt,tb)
        global d
        
              id=unique(tb.UserData(:,1));
              mm=size(id,1); nn=size(d.p.resultHscan,2);
      for i=1:mm
     
               if id(i)>nn
                msgbox('Data is not availble to display');
                   return;
               end
              f=figure
              ax=axes;
               mesh(ax,d.p.resultHscan{id(i)}.twpos,d.p.resultHscan{id(i)}.freq/1e6,d.p.resultHscan{id(i)}.result')
                hold on

                xlabel('Antenna Height(cm)' );
                ylabel('Frequency (MHz)');
                zlabel('Amplitude dBuV/m')
   
            if d.p.resultHscan{id(i)}.polar(1) ==0
            title('Horizontal');
            else
            title('Vertical');
            end
            view(ax,45,45)
      end
      
  end

 function plot_tt_scan2D(source,evnt,tb)
   global d
    if isempty(tb.UserData)
      msgbox('Please select the signal first!');
      return
    end
      id=unique(tb.UserData(:,1));
              mm=size(id,1); nn=size(d.p.resultHscan,2);
      for i=1:mm
     
               if id(i)>nn
                msgbox('Data is not availble to display');
                   return;
               end
           
               
            f=figure
            ax=axes;
           
            index=find(d.p.freq>=tb.Data(id(i),1));
            freq_index=index(1);
            polar(ax,d.p.ttpos./180*pi,d.p.result(:,freq_index)')
            

                xlabel(ax,'Rotation Angle (Degree)' );
                ylabel(ax,'Amplitude dBuV');

            title(ax,['Polar Plot for ' num2str(d.p.freq(freq_index)/1e6) ' MHz']);
            
            % s.p
      end
      
 end
 
 
        
 function goto_maximum_position(source,evnt,tb,s)
 if isempty(tb.UserData)
      msgbox('Please select the signal first!');
      return
  end
  id=tb.UserData(1);
    s.tt.fastsk(tb.Data(id,3));
    s.tw.sk(tb.Data(id,4));
    s.tw.setpolar(tb.Data(id,5));
    s.sa.setcenterfreq(tb.Data(id,1));
    s.sa.setsweep(1);
 end
  
 function Set_SA_Mode (source,evnt,tb,s)
 global d
  if isempty(tb.UserData)
      msgbox('Please select the signal first!');
      return
  end
   id=tb.UserData(1);
   s.sa.setSAMode;
   s.sa.setcenterfreq(tb.Data(id,1));
   s.sa.setsweep(1);
   
 end

 function Set_EMI_Mode(source,evnt,tb,s)
 global d 
  if isempty(tb.UserData)
      msgbox('Please select the signal first!');
      return
  end
 id=tb.UserData(1);
   s.sa.configRE;
   s.sa.setweep1(1);
 end
 function delete_slist(source,evnt,tb,s,dataset)
 global d
 global g
  if isempty(tb.UserData)
      msgbox('Please select the signal first!');
      return
  end
    id=unique(tb.UserData(:,1))';

    d.p.peaktable(id,:)=[];
    switch tb.Tag
        case {'tb1'}
                  d.p.peaktable=sortrows(d.p.peaktable,{'freq'});
                tb.Data=table2array(d.p.peaktable);
                d.overlayselectedpeaks(g.b1c.t4c.bc.ax1,-1); 
            if ~g.selectedtrace
                d.ph.peaktable=d.p.peaktable;
            else
              d.pv.peaktable=d.p.peaktable;    
            end
          
        case 'tb2'
                 d.p.peaktable=sortrows(d.p.peaktable,{'freq'});
                tb.Data=table2array(d.p.peaktable);
                d.overlayselectedpeaks(g.b2c.t4c.bc.ax1,-1); 
                
            if ~g.selectedtrace
              d.pL.peaktable=d.p.peaktable;
            else
              d.pN.peaktable=d.p.peaktable;    
                     end
           
                
        case 'tb3'
                  d.p.peaktable=sortrows(d.p.peaktable,{'freq'});
                tb.Data=table2array(d.p.peaktable);
                d.overlayselectedpeaks(g.b3c.t4c.bc.ax1,-1); 
                        if ~g.selectedtrace
                d.ph.peaktable=d.p.peaktable;
            else
              d.pv.peaktable=d.p.peaktable;    
            end
            
    end
    
            
  

 end
 function add_slist(source,evnt,tb,s)
 global d
 global g
      if isempty(tb.UserData)
          msgbox('Please select the signal first!');
          id=0;
      else
            id=unique(tb.UserData(:,1))';
             id=tb.UserData(1); 
             
      end
      
      switch tb.Tag
          case {'tb1','tb3'}
              if id~=0
                   
          
             x = inputdlg({'Freq','Peaks','Turn Table Position','Antenna Height Position','Polarization (0 Horizontal 1 Vertical)'},...
                     'Select the row to delete', [1 50],{num2str(tb.Data(id,1)),...
                      num2str(tb.Data(id,2)),...
                      num2str(tb.Data(id,3)),...
                      num2str(tb.Data(id,4)),...
                      num2str(tb.Data(id,5))});
              else
                           x = inputdlg({'Freq','Peaks','Turn Table Position','Antenna Height Position','Polarization (0 Horizontal 1 Vertical)'},...
                     'Select the row to delete', [1 50],{num2str(0),...
                      num2str(0),...
                      num2str(0),...
                      num2str(0),...
                      num2str(0)});
                  
              end
              
                  T=array2table([str2num(x{1}) str2num(x{2}) str2num(x{3}) str2num(x{4}) str2num(x{5})]);
                  T.Properties.VariableNames=d.p.peaktable.Properties.VariableNames;
            d.p.peaktable=[d.p.peaktable; T];
            d.p.peaktable=sortrows(d.p.peaktable,{'freq'});
            tb.Data=table2array(d.p.peaktable);
            d.overlayselectedpeaks(g.b1c.t4c.bc.ax1,-1);
          case 'tb2'
             if id~=0
            
             
              x = inputdlg({'Freq','Peaks'}, 'Add a signal into the re-measure list',...
                     [1 50],{num2str(tb.Data(id,1)),...
                     num2str(tb.Data(id,2))});
             else
                    x = inputdlg({'Freq','Peaks'}, 'Add a signal into the re-measure list',...
                     [1 50],{num2str(0),...
                     num2str(0)});
             end
             d.p.peak=[str2num(x{1}) str2num(x{2})];
                  T=array2table([str2num(x{1}) str2num(x{2})]);
                  T.Properties.VariableNames={'freq','peaks'};
            d.p.peaktable=[d.p.peaktable; T];
            d.p.peaktable.Properties.VariableNames={'freq','peaks'};
            d.p.peaktable=sortrows(d.p.peaktable,{'freq'});
            tb.Data=table2array(d.p.peaktable);
            d.overlayselectedpeaks(g.b2c.t4c.bc.ax1,-1);
           if ~g.selectedtrace
            d.pL=d.p;
          else
            d.pN=d.p;
   end
            
                     
                 
      end
      

 end
 function remeasureSLIST(source,evnt,tb,s)
 global g
global d
if g.selectedtrace
            d.p=d.pv;
        else
            d.p=d.ph;
   end
        
        
    if isempty(tb.UserData)
      msgbox('Please select the signal first!');
      return
    end
      id=unique(tb.UserData(:,1));
              mm=size(id,1);
      for i=1:mm
     

     
                 %set the antnna and tt into position  
             s.tt.fastsk(s.sa.peaktable.ttpos(id(i)));
            
             s.tw.sk(s.sa.peaktable.twpos(id(i))); 
             s.tw.setpolar(s.sa.peaktable.polar(id(i)));
             %make measurement
             while ~s.tt.opc 
             end
             while ~s.tw.opc 
             end
             
             s.sa.replace_peaktable(id(i));
             s.sa.remeasure(id(i));      
               
      end
 end
 function writeSLIST(source,evnt,tb,s)
 global d
 global g
              % write the peaktable
             s.sa.peaktable=d.p.peaktable;
             s.sa.writeSLIST
 end
 
 function updateSLIST(source,evnt,tb,s)
 global d
 global g
 
         s.sa.readSLIST;
         
         d.p.peakresult=s.sa.peakresult;
        if g.selectedtrace
            d.pv=d.p;
        else
            d.ph=d.p;
        end
        d.creat_peaktable2;
        d.overlay_peaktable2(g.b1c.t4c.bc.ax1,g.b1c.t4c.bc.tb1);
        
            
 end
 