import mlreportgen.dom.*;
folderName1='./configuration';
folderName2='./images';
folderName3='./layout';
folderName4='./objs';
folderName5='./test';
folderName6='./UserData';
addpath(folderName1,folderName2,genpath(folderName3),folderName4,folderName5,...
        folderName6)
    

             
    
s=SystemObj;
d=viewdata;
s.ini;
d.p=s.measureRE;
d.view3D;
d.view2D;
d.viewpolar;