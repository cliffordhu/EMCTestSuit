global g
import mlreportgen.dom.*;
rpt = MyReportOBJ(['test'],'docx','.\configuration\REtemplate');


rpt.fillp1(g);
rpt.fillp2(g);
rpt.fillp3(g);
rpt.fillp4(g);

rpt.view
fill(rpt);
pause(1);
close(rp);
rptview(rpt.OutputPath)
Undefined variable "T1" or class "T1.name".



import mlreportgen.dom.*;
folderName1='./configuration';
folderName2='./images';
folderName3='./layout';
folderName4='./objs';
folderName5='./test';
folderName6='./UserData';
addpath(folderName1,folderName2,genpath(folderName3),folderName4,folderName5,...
        folderName6)
    
load p
d=dataObj;
d.ph=p;
figure
axes
d.view2D(gca,0);
d.findpeak

s=SystemObj
s.ini
% manual selected peak push into scope
s.sa.peaktable=d.p.peaktable(1:2,:);
%load the peaktabel into emi receiver. 

%complete the remeasure
d.p.resultHscan=s.remeasureRE;
d.p.peakresult=s.sa.peakresult;
d.p.peaktable=s.sa.peaktable;
        
%%

clear all; close all;
import mlreportgen.dom.*;
folderName1='./configuration';
folderName2='./images';
folderName3='./layout';
folderName4='./objs';
folderName5='./test';
folderName6='./UserData';
addpath(folderName1,folderName2,genpath(folderName3),folderName4,folderName5,...
        folderName6)

 rpt = MyReportObj;

rpt.open

%Section 1 Configuration setup
    % 1.1 table test requpiment
        T1=readtable('./configuration/REconfiguration.xlsx');
        rpt.p1t1=rpt.table(T1);
    %1.2 table enviroment condition
       rpt.p1t2=rpt.text(['Temperature: ' 'Humidity :' ]);
   %1.3 table operator and date
       rpt.p1t3=rpt.text(['Operator: ' 'Report generated at: ' ]);
%Section 2 Product information 
     %2.1 table
     
        T2=readtable('./configuration/REreportheader.xlsx');
        rpt.p2t1=rpt.table(T2);
   
 %Section 3 EUT setup
      %3.1  photo
      rpt.loadpic;
      
%section 4 result
     % 4.1 write the test result in table format 4.1. 
        load d

        T=d.p.peaktable;
        T1=table2cell(T)
        Name= T.Properties.VariableNames
        T2=[Name;T1]
        T3=cell2table(T2);
        T3.Properties.VariableNames=Name
        
        rpt.p4t1=rpt.table(T3);
     %4.2 insert the plot into 4f1 to 4 f5
        f1=figure
        %d.p=d.ph;
        d.view2D(gca);
        f2=figure
        %d.p=d.pv;
        d.view2D(gca);
     
        rpt.p4f1=rpt.image(f1,1);
        rpt.p4f2=rpt.image(f2,2);
        close(f1);close(f2)
%Section 5 Summary 
rpt.p5t1=rpt.text('The unit passed the Radiated Emission Test');


rpt.fill;

rpt.close
rpt.view

rpt.doc2pdf


