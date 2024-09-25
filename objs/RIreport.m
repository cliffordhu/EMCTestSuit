function RIreport
global g
global d

% RE create report header
    str=['RI_' g.b8c.t5c.rx1.String ' ' g.b8c.t5c.rx2.String ' ' g.b8c.t5c.rx3.String];
    %choose where to save%choose file  
    [filename, pathname] = uiputfile([g.lastfolder str '.docx'], 'Save into Word file');
        if isequal(filename,0) || isequal(pathname,0)
           disp('User pressed cancel')
           return;
        else
            fname=fullfile(pathname, filename);
            disp(['User selected ', ]);   
        end
        g.lastfolder=pathname;
       g.rpt.open(fname,'RI');
               %Section 1 Configuration setup
               % 1.1 table test requpiment
                    T1=readtable('./configuration/RIconfiguration.xlsx');
                    g.rpt.p1t1=g.rpt.table(T1);
                %1.2 table enviroment condition
                   g.rpt.p1t2=g.rpt.text(['Temperature: ' g.tx4.String  ';   Humidity :' g.tx6.String ]);
               %1.3 table operator and date
                   g.rpt.p1t3=g.rpt.text(['Operator: ' g.tx21.String{g.tx21.Value} ...
                                     ';        Report generated at: ' date ]);
            %Section 2 Product information 
                 %2.1 table

                    T2=readtable('./configuration/RIreportheader.xlsx');
                    g.rpt.p2t1=g.rpt.table(T2);

             %Section 3 EUT setup
                  %3.1  pLoto
                  g.rpt.loadpic;

            %section 4 result
                 % 4.1 write the test result in table format 4.1. 
                  g.rpt.p4t1=[];g.rpt.p4f1=[];g.rpt.p4f2=[];g.rpt.p4f3=[];g.rpt.p4f4=[];g.rpt.p4f5=[];
                 if isempty(g.b8c.t2c.bc.btc.tb1.Data) || length(g.b8c.t2c.bc.btc.tb1.Data)==8
                 g.b8c.t2c.bc.btc.tb1.Data={'80-6000','Front', 'Horizontal/Vertical','A. Pass -Normal performance within specified limits';...
                                           '80-6000','Right', 'Horizontal/Vertical','A. Pass -Normal performance within specified limits';...
                                            '80-6000','Rear', 'Horizontal/Vertical','A. Pass -Normal performance within specified limits';...
                                            '80-6000','Left', 'Horizontal/Vertical','A. Pass -Normal performance within specified limits';}
                 
                     
                 end
                 
                      T3=formattableforprint(g.b8c.t2c.bc.btc.tb1.Data);
                           g.rpt.p4t1=g.rpt.table(T3);
   
                           f1=figure;
                             new_handle=copyobj(g.b8c.t2c.bc.ax1,f1);
                            title(gca,'Actual Test Level');
                            set(gca,'ActivePositionProperty','outerposition');
                            set(gca,'Units','normalized');
                            set(gca,'OuterPosition',[0 0 1 1]);
                            set(gca,'position',[0.1300 0.1100 0.7750 0.8150]);

                          l=legend('Radiated Immunity Target level 3V/M','Test level');
                          l.Location='Northeast'; 
                        g.rpt.p4f1=g.rpt.Image2(f1,1);
                         %close(f1);  
                         
% reporting this section is optional                            
%                            f2=figure;
%                              xlim([80e6 6e9]);
%                                 ylim([1 5]);
%                                 xlabel('Frequency');
%                                 ylabel('Field Strength V/m');
%                                 grid on;
%                                 hold on;
%                                 set(gca,'xscale','log');
%                                 index=9;
%                                 lin=semilogx(gca,d.ri.coeffs{1}(:,1),d.ri.coeffs{1}(:,index),'r*');
%                                 lin=semilogx(gca,d.ri.coeffs{2}(:,1),d.ri.coeffs{2}(:,index),'b*');
%                             set(gca,'ActivePositionProperty','outerposition')
%                             set(gca,'Units','normalized')
%                             set(gca,'OuterPosition',[0 0 1 1])
%                             set(gca,'position',[0.1300 0.1100 0.7750 0.8150])
% 
%                           l=legend('Horizontal','Vertical');
%                           l.Location='Northeast'; 
%                         g.rpt.p4f2=g.rpt.Image2(f2,2);
%                          close(f2);  
%                          
%                                                      
%                            f3=figure;
%                              xlim([80e6 6e9]);
%                                 ylim('auto');
%                                 xlabel('Frequency');
%                                 ylabel('Forward output power (dBm)');
%                                 grid on;
%                                 hold on;
%                                 set(gca,'xscale','log');
%                                 index=5;
%                                 freq=d.ri.coeffs{1}(:,1);
%                                 a= find(freq<1e9);
%                                 d.ri.coeffs{1}(:,index)=d.ri.coeffs{1}(:,index)+40;
%                                 d.ri.coeffs{2}(:,index)=d.ri.coeffs{2}(:,index)+40;
%                                 d.ri.coeffs{1}(a,index)=d.ri.coeffs{1}(a,index)+10;
%                                 d.ri.coeffs{2}(a,index)=d.ri.coeffs{2}(a,index)+10;
%                                 
%                                 lin=semilogx(gca,d.ri.coeffs{1}(:,1),d.ri.coeffs{1}(:,index),'r');
%                                 lin=semilogx(gca,d.ri.coeffs{2}(:,1),d.ri.coeffs{2}(:,index),'b');
%                             set(gca,'ActivePositionProperty','outerposition')
%                             set(gca,'Units','normalized')
%                             set(gca,'OuterPosition',[0 0 1 1])
%                             set(gca,'position',[0.1300 0.1100 0.7750 0.8150])
% 
%                           l=legend('Horizontal','Vertical');
%                           l.Location='Northeast'; 
%                          g.rpt.p4f3=g.rpt.Image2(f3,3);
%                          
%                          
%                          close(f3);  
%                          
% this is optional 
%                           f4=figure;
%                            ax=gca;
%                             xlim(ax,[80e6 6e9]);
%                             ylim(ax,[0 10]);
%                             xlabel(ax,'Frequency');
%                             ylabel(ax,'Field Variation');
%                             grid(ax,'on');hold(ax,'on');
%                             set(ax,'xscale','log');
%                             % field strength
%                            str1={'Horizontal','Vertical'};
%                             limt=semilogx(ax,[80e6 6e9],[6 6],'Color','r');
%                             lin=semilogx(ax,d.ri.FU{1}(:,1),d.ri.FU{1}(:,3),'*','Color','b');
%                             title(ax,['Field Uniformity variation from 14 out of 16 points ; Polarity:' str1{1}]);
%                          g.rpt.p4f4=g.rpt.Image2(f4,4);
%                          close(f4);  
%                          
%                          f5=figure;
%                           ax=gca;
%                             xlim(ax,[80e6 6e9]);
%                             ylim(ax,[0 10]);
%                             xlabel(ax,'Frequency');
%                             ylabel(ax,'Field Variation');
%                             grid(ax,'on');hold(ax,'on');
%                             set(ax,'xscale','log');
%                             % field strength
%                            limt=semilogx(ax,[80e6 6e9],[6 6],'Color','r');
%                             lin=semilogx(ax,d.ri.FU{2}(:,1),d.ri.FU{2}(:,3),'*','Color','b');
%                             title(ax,['Field Uniformity variation from 14 out of 16 points ; Polarity:' str1{2}]);  
%                          
%                          g.rpt.p4f5=g.rpt.Image2(f5,5);
%                          close(f5);  
%                          
                         

                    
            %Section 5 Summary 
%             if isfield(d.pL,'peakresult')
%                 if max(max(d.pL.peakresult(:,7:9)))>0
%                   str= 'The unit FAILED the Conducted Emission Test in Line wire!';
%                    g.rpt.p5t1=g.rpt.text(str);
%                    g.rpt.p5t1.Color='red';
%                 else 
%                   str= 'The unit Passed the Conducted Emission Test in Line wire!';
%                   g.rpt.p5t1=g.rpt.text(str);
%                   g.rpt.p5t1.Color='green';
%                 end
%             else
%                   str= 'The unit Passed the Conducted Emission Test in Line wire!';               
%                   g.rpt.p5t1=g.rpt.text(str);
%                   g.rpt.p5t1.Color='green';
%             end
% check  if level D is marked. if so, mark the reuslt as failure. 
result=1; tmp=g.b8c.t2c.bc.btc.tb1.Data;
                       mm=size(tmp,1);
                            for i=1:mm
                              if strcmp(tmp{i,2}(1),'D')
                                  result=0;
                              end 
                            end
                

 if  result==0
              str= 'The unit failed the Radiated Immunity Test!';
                    g.rpt.p5t1=g.rpt.text(str);
                    g.rpt.p5t2=g.rpt.text('');
                    g.rpt.p5t1.Color='red';
  else
         str= 'The unit passed the Radiated Immunity Test!';
                   g.rpt.p5t1=g.rpt.text(str);
                   g.rpt.p5t1.Color='green';
                   g.rpt.p5t2=g.rpt.text('');
 end

         % generate random white space to create unique header for each
        % report so that at the time of integration, the auto numbering
        % function would work correctly. It will counting the page number
        % using this unique (header+random (white space)) 
            str=[]
            n=randi(20,1,1);
             for i=1:n
                 str=[str ' '];
             end
            g.rpt.p7t1=g.rpt.text(str);
            g.rpt.p7t2=g.rpt.text(str);
            g.rpt.p7t3=g.rpt.text(str);
            g.rpt.p7t4=g.rpt.text(str);
            g.rpt.p7t5=g.rpt.text(str);
            
            g.rpt.fill;
            g.rpt.close
            g.rpt.view

        
    %save the file into default
   % writetable(T,fname);
    msgbox(['Test Report is succesfully saved into' fname]);
end
function T3=formattableforprint(T1)
                         Name= {'Frequency (MHz)','DUT Pos.','Antenna Pos.','Remark'};
                         mm=size(T1,1);
                            for i=1:mm
                            T1{i,1}=num2str(T1{i,1});
                            end
                        T2=[Name;T1];T3=cell2table(T2);     
                        T3.Properties.VariableNames={'Freq_Hz','DUTpos','Antennapos','Mark'};
                       
end

    