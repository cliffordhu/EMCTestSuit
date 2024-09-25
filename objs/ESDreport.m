function ESDreport
global g
global d

% RE create report header
    str=['ESD_' g.b5c.t5c.rx1.String ' ' g.b5c.t5c.rx2.String ' ' g.b5c.t5c.rx3.String];
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
    g.rpt.open(fname,'ESD');
               %Section 1 Configuration setup
               % 1.1 table test requpiment
                    T1=readtable('./configuration/ESDconfiguration.xlsx');
                    g.rpt.p1t1=g.rpt.table(T1);
                %1.2 table enviroment condition
                   g.rpt.p1t2=g.rpt.text(['Temperature: ' g.tx4.String  ';   Humidity :' g.tx6.String ]);
               %1.3 table operator and date
                   g.rpt.p1t3=g.rpt.text(['Operator: ' g.tx21.String{g.tx21.Value} ...
                                     ';        Report generated on: ' date ]);
            %Section 2 Product information 
                 %2.1 table

                    T2=readtable('./configuration/ESDreportheader.xlsx');
                    g.rpt.p2t1=g.rpt.table(T2);

             %Section 3 EUT setup
                  %3.1  pLoto

                  g.rpt.loadfig;

            %section 4 result
                 % 4.1 write the test result in table format 4.1. 
                  g.rpt.p4t1=[];g.rpt.p4f1=[];g.rpt.p4f2=[];g.rpt.p4f3=[];g.rpt.p4f4=[];g.rpt.p4f5=[];
                          tb1=g.b5c.t2c.bc.btc.tb1.Data;
                        [T51 flg]=formattableforprint(tb1,1);
                        g.rpt.p4t1=g.rpt.table(T51);
                             tb2=g.b5c.t2c.bc.btc.tb2.Data ;           
                        [T52 flg1]=formattableforprint(tb2,2);
                        g.rpt.p4f1=g.rpt.table(T52);
                 
                    
            %Section 5 Summary 
            if flg || flg1
                   str= 'The unit FAILED the ESD test!';
                   g.rpt.p5t1=g.rpt.text(str);
                   g.rpt.p5t1.Color='red';
            else 
                  str= 'The unit Passed the ESD test!';
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
function [T3 flg]=formattableforprint(T,type)
switch type 
    case 1
    tb1={'Discharge Type','Location','2KV','4KV','6KV','8KV',...
               'Comments: '} ;   
         case 2
     tb1={'Discharge Type','Location','2KV','4KV','6KV','8KV','10KV','12KV','15KV'...
               'Comments: '} ; 
end
           flg=0;
             
                            T11={};
                        [mm nn]=size(T);
                        for i=1:mm
                            for j=3:nn-1
                                tmp=regexp(T{i,j},'[ABCDN]');
                               switch T{i,j}(tmp(1))
                                   case 'A'
                                       T{i,j}='A';
   
                                   case 'B'
                                       T{i,j}='B';
                                   case 'C'
                                       T{i,j}='C';
                                   case 'D'
                                      T{i,j}='D';
                                   case 'N'
                                      T{i,j}='N/A';
                                      
                               end
                            end
                        end
                   
                        
                        T2=[tb1;T];T3=cell2table(T2);     
%                         T3.Properties.VariableNames={'Freq_Hz','Amplitude_dBuV','QuasiPeak_dBuV','Peak_dBuV',...
%                        'Average_dBuV','DeltQ_dB','DeltP_dB','DeltA_dB'};
                       
end

    