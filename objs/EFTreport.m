function EFTreport
global g
global d

% RE create report header
    str=['EFT_Surge_PwrLineQ_' g.b9c.t5c.rx1.String ' ' g.b9c.t5c.rx2.String ' ' g.b9c.t5c.rx3.String];
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
       g.rpt.open(fname,'EFT');
               %Section 1 Configuration setup
               % 1.1 table test requpiment
                    T1=readtable('./configuration/EFTconfiguration.xlsx');
                    g.rpt.p1t1=g.rpt.table(T1);
                %1.2 table enviroment condition
                   g.rpt.p1t2=g.rpt.text(['Temperature: ' g.tx4.String  ';   Humidity :' g.tx6.String ]);
               %1.3 table operator and date
                   g.rpt.p1t3=g.rpt.text(['Operator: ' g.tx21.String{g.tx21.Value} ...
                                     ';        Report generated at: ' date ]);
            %Section 2 Product information 
                 %2.1 table

                    T2=readtable('./configuration/EFTreportheader.xlsx');
                    g.rpt.p2t1=g.rpt.table(T2);

             %Section 3 EUT setup
                  %3.1  pLoto
                  g.rpt.loadpic;

            %section 4 result
                 % 4.1 write the test result in table format 4.1. 
                  g.rpt.p4t1=[];
      
                  [filename, pathname] = uigetfile('*.txt', 'Pick a EFT /Surge/Powerline quality  Test log file.','Q:\HTC\PROJECT TEST RECORDS - HTC\_Data from EFT computer\KeyTek\Test Reports');
   
                            if isequal(filename,0) || isequal(pathname,0)
                               disp('User pressed cancel')
                            else
                              fname=fullfile(pathname, filename);
                            end
                str=fileread(fname)   ;     
                str(regexp(str,char(12)))=[];
                
              %str='pass'
                 g.rpt.p4t1=g.rpt.text( str);
   
                         result=isempty(strfind(str, 'failed'))&& isempty(strfind(str, 'Failed'));
                         

                

 if  ~result
              str= 'The unit failed the electrical fast transit, surge and power line quality Test';
                    g.rpt.p5t1=g.rpt.text(str);
                    g.rpt.p5t1.Color='red';
  else
          str= 'The unit passed the electrical fast transit, surge and power line quality Test';
                   g.rpt.p5t1=g.rpt.text(str);
                   g.rpt.p5t1.Color='green';
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

    