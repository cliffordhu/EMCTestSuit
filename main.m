function main
global g
g.rbw=10e6; % glboal varaible RBW for filter peaks default 10Mhz. 
g.selectedbutton=0 % status control for button 1 tab 4 .
g.pause=0;
g.selectedtrace=0;
g.f=[];
g.fig_polar_scan=[];
import mlreportgen.dom.*;
folderName1='./configuration';
folderName2='./images';
folderName3='./layout';
folderName4='./objs';
folderName5='./test';
folderName6='./UserData';
g.lastfolder=cd;
if ~isdeployed
addpath(folderName1,folderName2,genpath(folderName3),folderName4,folderName5,...
        folderName6);
end

g.rpt = MyReportObj;
    
g.f = figure('OuterPosition',[30 30 1000 900],'Name','COS HTC EMC Test Software Suit','NumberTitle','off');
b=uix.HBoxFlex( 'Parent', g.f);

g.p1 = uix.VBox( 'Parent', b, 'Padding', 5 );
g.p2 = uix.TabPanel( 'Parent', b, 'Padding', 5 );
set( b, 'Widths', [-1 -5], 'Spacing', 5 );
% Create two panels
    % fill in panel 1 part 1 button
        g.b1=uicontrol( 'Parent', g.p1, 'String', 'Radiated Emission','Callback', @fb1 );
        g.b2=uicontrol( 'Parent', g.p1, 'String', 'Conducted Emission','Callback', @fb2 );
        g.b8=uicontrol( 'Parent', g.p1, 'String', 'Radiated Immunity','Callback', @fb8 );
        g.b4=uicontrol( 'Parent', g.p1, 'String', 'Conducted Immunity','Callback', @fb4 );
        g.b9=uicontrol( 'Parent', g.p1, 'String', 'EFT Surge PwrQual','Callback', @fb9 );
        g.b5=uicontrol( 'Parent', g.p1, 'String', 'ESD','Callback', @fb5 );
        g.b3=uicontrol( 'Parent', g.p1, 'String', 'OATs','Callback', @fb3 );
        g.b7=uicontrol( 'Parent', g.p1, 'String', 'Site Calibration','Callback', @fb7 );
        g.b6=uicontrol( 'Parent', g.p1, 'String', 'Exit','Callback', @fb6 );
    % fill in panel 1 part 2 timer
        g.tx11=uicontrol( 'Style','text','Parent', g.p1, 'String', '' );
        g.tx7=uicontrol( 'Style','text','Parent', g.p1, 'String', 'Test Date and Time:' );
        g.tx8=uicontrol( 'Style','text','Parent', g.p1, 'String', datestr(now,'mmm.dd,yyyy') );
        STRT = 0;
        g.tmr = timer('Name','time',...
                    'Period',1,...  % Update the time every 60 seconds.
                    'StartDelay',STRT,... % In seconds.
                    'TasksToExecute',inf,...  % number of times to update
                    'ExecutionMode','fixedSpacing',...
                    'TimerFcn',{@updater}); 
        start(g.tmr);  % Start the timer object.
        set(g.f,'deletefcn',{@deleter})
    
    % fill in panel 1 part 3 enviroment info
        g.tx1=uicontrol( 'Style','text','Parent', g.p1, 'String', 'Operator:' );
        g.tx21=uicontrol( 'Style','pop','Parent', g.p1, 'String', {'Clifford','Timothy','Steve'});
        g.tx2=uicontrol( 'Style','text','Parent', g.p1, 'String', 'Ambient Enviroment' );
        g.tx3=uicontrol( 'Style','text','Parent', g.p1, 'String', 'Temperature:' );
        g.tx4=uicontrol( 'Style','edit','Parent', g.p1, 'String', ['72' char(176) 'F'] );
        g.tx5=uicontrol( 'Style','text','Parent', g.p1, 'String', 'Humidity:' );
        g.tx6=uicontrol( 'Style','edit','Parent', g.p1, 'String', '50 RH' );   

    %format panel 1
        set( g.p1, 'Heights', 30*ones(1,19) );
   
    %% Fil in panel 2 part 1
      g.b1c.t1 = uix.Panel( 'Parent', g.p2, 'Title', 'Please Inti ', 'Padding', 5 );
        %     g.b1c.t2 = uix.Panel( 'Parent', g.p2, 'Title', 'Quick Scan using Peak detector Measurement', 'Padding', 5 );
        %     g.b1c.t3 = uix.Panel( 'Parent', g.p2, 'Title', 'Search peaks and data analysis', 'Padding', 5 );
        %     g.b1c.t4 = uix.Panel( 'Parent', g.p2, 'Title', 'Quasi-peak Measurement', 'Padding', 5 );
        %     g.b1c.t5 = uix.Panel( 'Parent', g.p2, 'Title', 'Report', 'Padding', 5 );
        g.p2.TabTitles = {'Setup' }



end 

function [] = deleter(varargin)
    % If figure is deleted, so is timer.
    global g
    if ~isempty(g)
        if ~isempty(g.tmr)
         stop(g.tmr);
         delete(g.tmr);
        end
    end
    
end
    
function [] = updater(varargin)
global g
    % timerfcn for the timer.  If figure is deleted, so is timer.
         % I use a try-catch here because timers are finicky in my
         % experience.
         try
             set(g.tx8,'string',datestr(now,'mmm.dd,yyyy HH:MM:SS PM'))
       
         catch
             delete(g.f) % Close it all down.
         end
end

    
function fb1(source,callbackdata)
global g
g.fig_polar_scan=[];
%% setup  button 1
 global d
   % initialize dataOBJ
        d=dataObj;
          %create tabs
             g.b1c=[];
             delete(g.p2.Children);
             g.b1c.t1 = uix.Panel( 'Parent', g.p2, 'Title', 'Please Inti ', 'Padding', 5 );
             g.b1c.t2 = uix.Panel( 'Parent', g.p2, 'Title', 'Quick Scan using Peak detector Measurement', 'Padding', 5 );
             g.b1c.t3 = uix.Panel( 'Parent', g.p2, 'Title', 'Data Visualization', 'Padding', 5 );
             g.b1c.t4 = uix.Panel( 'Parent', g.p2, 'Title', 'Search peaks and make Re-Measurement using Quasi-peak detector', 'Padding', 5 );
             g.b1c.t5 = uix.Panel( 'Parent', g.p2, 'Title', 'Report', 'Padding', 5 );
             g.p2.TabTitles = {'Setup ', 'Scan','View','Re-Measure','Report'};
    
g.p2.Selection = 1;

%% setup tab 1 
    % create 1Hbox 2vbox 
    g.b1c.t1c.b = uix.HBoxFlex( 'Parent', g.b1c.t1, 'Padding', 5 );
    g.b1c.t1c.bc.vb1 = uix.VBox( 'Parent', g.b1c.t1c.b, 'Padding', 5 );
    g.b1c.t1c.bc.vb2 = uix.VBox( 'Parent', g.b1c.t1c.b, 'Padding', 5 );
    set( g.b1c.t1c.b, 'Widths', [-1 -2] );
    %load configuration file
    
    T=readtable('./configuration/REconfiguration.xlsx');
    g.T=T;
    [mm nn]=size(T);
    % creat uicontrols inputs
    
    for i=1:mm
        str1=['g.b1c.t1c.tx' num2str(i) '=uicontrol( ''Style'',''text'',''Parent'', g.b1c.t1c.bc.vb1, ''String'', ''' ...
             T.name{i} ''');'];eval(str1);  
        str2=['g.b1c.t1c.rx' num2str(i) '=uicontrol( ''Style'',''edit'',''Parent'', g.b1c.t1c.bc.vb2, ''String'', ''' ...
             T.value{i} ''');'];eval(str2);
    end
    uix.Empty('Parent', g.b1c.t1c.bc.vb2 );
    uix.Empty('Parent', g.b1c.t1c.bc.vb1 );
    
    %creat buttons 
    g.b1c.t1c.bt1=uicontrol( 'Parent', g.b1c.t1c.bc.vb1, 'String', 'Connect', 'Callback',@fconnect,'UserData',[1 1 1]);
    g.b1c.t1c.bt2=uicontrol( 'Parent', g.b1c.t1c.bc.vb1, 'String', 'Save', 'Callback',@fsaveconfig,'UserData',[1 1 2]);
    g.b1c.t1c.bt3=uicontrol( 'Parent', g.b1c.t1c.bc.vb1, 'String', 'Load', 'Callback', @floadconfig,'UserData',[1 1 3]);
    %creat status 
    g.b1c.t1c.txstatus=uicontrol( 'Style','text','Parent', g.b1c.t1c.bc.vb2, 'String', '' );
    %format the layout
    set( g.b1c.t1c.bc.vb1, 'Heights', 30*ones(1,mm+4) );
    set( g.b1c.t1c.bc.vb2, 'Heights', 30*ones(1,mm+2) );
  
%% setup tab2 scan

    g.b1c.t2c.b = uix.VBoxFlex( 'Parent', g.b1c.t2, 'Padding', 5 );
    g.b1c.t2c.bc.p1 = uix.Panel( 'Parent', g.b1c.t2c.b, 'Padding', 5 );
    g.b1c.t2c.bc.p2 = uix.Panel( 'Parent', g.b1c.t2c.b, 'Padding', 5 );
    g.b1c.t2c.bc.p1c.c=uicontainer('Parent',g.b1c.t2c.bc.p1);
    g.b1c.t2c.bc.p2c.c=uicontainer('Parent',g.b1c.t2c.bc.p2);
    
    g.b1c.t2c.bc.ax1=axes( 'Parent', g.b1c.t2c.bc.p1c.c,'UserData',[1 2 0]);
    g.b1c.t2c.bc.ax2=axes( 'Parent', g.b1c.t2c.bc.p2c.c,'UserData',[1 2 1]);

    g.b1c.t2c.bc.bt = uix.HButtonBox( 'Parent', g.b1c.t2c.b, 'Padding', 5 );
    g.b1c.t2c.bc.btc.bt1=uicontrol( 'Style','checkbox','Parent', g.b1c.t2c.bc.bt, 'String', 'Horizontal','Value',1 );
    g.b1c.t2c.bc.btc.bt2=uicontrol('Style','checkbox', 'Parent', g.b1c.t2c.bc.bt, 'String', 'Vertical','Value',1 );
    g.b1c.t2c.bc.btc.bt3=uicontrol( 'Parent', g.b1c.t2c.bc.bt, 'String', 'Measurement' ,'UserData',[1 2 1],'Callback',@Bt_Measure );
    g.b1c.t2c.bc.btc.bt4=uicontrol( 'Parent', g.b1c.t2c.bc.bt, 'String', 'Pause' ,'UserData',[1 2 2],'Callback',@Bt_Pause );
    g.b1c.t2c.bc.btc.bt5=uicontrol( 'Parent', g.b1c.t2c.bc.bt, 'String', 'Save Scan'  ,'UserData',[1 2 3],'Callback',@Bt_Save);
    g.b1c.t2c.bc.btc.bt6=uicontrol( 'Parent', g.b1c.t2c.bc.bt, 'String', 'Load Scan'  ,'UserData',[1 2 4],'Callback',@Bt_Load);
    g.b1c.t2c.bc.btc.bt7=uicontrol( 'Parent', g.b1c.t2c.bc.bt, 'String', 'Resize','UserData',[1 2 6],'Callback',@Bt_Resize );
    g.b1c.t2c.bc.btc.bt8=uicontrol( 'Parent', g.b1c.t2c.bc.bt, 'String', 'Next' ,'UserData',[1 2 5],'Callback',@Bt_Next);
    
set( g.b1c.t2c.b, 'Heights', [-1 -1 35] )
%% setup tab3


    g.b1c.t3c.b = uix.VBox( 'Parent', g.b1c.t3, 'Padding', 5 );
    g.b1c.t3c.bc.c=uicontainer('Parent',g.b1c.t3c.b );
    g.b1c.t3c.bc.ax1=axes( 'Parent', g.b1c.t3c.bc.c);
    
    g.b1c.t3c.bc.bt = uix.HButtonBox( 'Parent', g.b1c.t3c.b, 'Padding', 5 );
    
    g.b1c.t3c.bc.btc.bt0=uicontrol( 'Style','text','Parent', g.b1c.t3c.bc.bt, 'String', 'Data' );
    g.b1c.t3c.bc.btc.bt1=uicontrol( 'Style','radiobutton','Parent', g.b1c.t3c.bc.bt, 'String', 'Hoziontal','Value',1,...
                                     'UserData',[1 3 1], 'Callback',@Bt_1_3_1_selectdata );
    g.b1c.t3c.bc.btc.bt2=uicontrol('Style','radiobutton', 'Parent', g.b1c.t3c.bc.bt, 'String', 'Vertical','Value',0,...
                                    'UserData',[1 3 2], 'Callback',@Bt_1_3_2_selectdata );
  
    
   % g.b1c.t3c.bc.btc.bt3=uicontrol( 'Parent', g.b1c.t3c.bc.bt, 'String', 'Search Peak' );
    uix.Empty('Parent', g.b1c.t3c.bc.bt)
   
    g.b1c.t3c.bc.btc.bt11=uicontrol( 'Parent', g.b1c.t3c.bc.bt, 'String', 'Polar Plot','UserData',[1 3 11],'Callback',@Bt_1_3_11_viewpolar );
    g.b1c.t3c.bc.btc.bt10=uicontrol( 'Parent', g.b1c.t3c.bc.bt, 'String', '3D plot' ,'UserData',[1 3 10],'Callback',@Bt_1_3_10_view3D );
    g.b1c.t3c.bc.btc.bt5=uicontrol( 'Style','text','Parent', g.b1c.t3c.bc.bt, 'String', ' View Angle:' );
    g.b1c.t3c.bc.btc.bt6=uicontrol( 'Style','text','Parent', g.b1c.t3c.bc.bt, 'String', ' R= ' );
    g.b1c.t3c.bc.btc.bt7=uicontrol( 'Style','edit','Parent', g.b1c.t3c.bc.bt, 'String', '45','UserData',[1 3 7],'Callback',@Bt_viewangle);
    g.b1c.t3c.bc.btc.bt8=uicontrol( 'Style','text','Parent', g.b1c.t3c.bc.bt, 'String', 'Theta=' );
    g.b1c.t3c.bc.btc.bt9=uicontrol( 'Style','edit','Parent', g.b1c.t3c.bc.bt, 'String', '45','UserData',[1 3 9],'Callback',@Bt_viewangle);
    g.b1c.t3c.bc.btc.bt4=uicontrol( 'Parent', g.b1c.t3c.bc.bt, 'String', 'Next' ,'UserData',[1 3 5],'Callback',@Bt_Next );

    set( g.b1c.t3c.b, 'Heights', [-1 35] )
%% setup tab4
    g.b1c.t4c.b = uix.VBoxFlex( 'Parent', g.b1c.t4, 'Padding', 5 );
    g.b1c.t4c.bc.c=uicontainer('Parent',g.b1c.t4c.b);
    g.b1c.t4c.bc.ax1=axes( 'Parent', g.b1c.t4c.bc.c);
    g.b1c.t4c.bc.bt = uix.HButtonBox( 'Parent', g.b1c.t4c.b, 'Padding', 5 );
    g.b1c.t4c.bc.tb1=uitable( 'Parent', g.b1c.t4c.b,'Tag','tb1','CellSelectionCallback',@(src,evnt)set(src,'UserData',evnt.Indices));
    g.b1c.t4c.bc.bt2 = uix.HButtonBox( 'Parent', g.b1c.t4c.b, 'Padding', 5 );
   
    g.b1c.t4c.bc.btc.bt1=uicontrol( 'Style','radiobutton','Parent', g.b1c.t4c.bc.bt, 'String', 'Horizontal','Value',0,...
                                   'UserData',[1 4 1], 'Callback',@Bt_1_3_1_selectdata );
    g.b1c.t4c.bc.btc.bt2=uicontrol('Style','radiobutton', 'Parent', g.b1c.t4c.bc.bt, 'String', 'Vertical','Value',1 ,...
                                   'UserData',[1 4 2], 'Callback',@Bt_1_3_2_selectdata );
    g.b1c.t4c.bc.btc.bt3=uicontrol( 'Parent', g.b1c.t4c.bc.bt, 'String', 'Search','UserData',[1 4 3],'Callback',@Bt_1_4_3_searchpeak );
    g.b1c.t4c.bc.btc.bt4=uicontrol( 'Parent', g.b1c.t4c.bc.bt, 'String', 'Filter','UserData',[1 4 4],'Callback',@Bt_1_4_4_searchpeak  );
    g.b1c.t4c.bc.btc.bt7=uicontrol( 'Style','text','Parent', g.b1c.t4c.bc.bt, 'String', 'RBW' );
    g.b1c.t4c.bc.btc.bt8=uicontrol( 'Style','edit','Parent', g.b1c.t4c.bc.bt, 'String', '10','UserData',[1 4 8],'Callback',@Bt_1_4_8_rbw );
    g.b1c.t4c.bc.btc.bt9=uicontrol( 'Style','text','Parent', g.b1c.t4c.bc.bt, 'String', 'MHz' );
    g.b1c.t4c.bc.btc.bt15=uicontrol( 'Parent', g.b1c.t4c.bc.bt, 'String', 'Save List' ,'UserData',[1 4 15],'Callback',@Bt_1_4_15_savelist);
    g.b1c.t4c.bc.btc.bt16=uicontrol( 'Parent', g.b1c.t4c.bc.bt, 'String', 'Load List','UserData',[1 4 16],'Callback',@Bt_1_4_16_loadlist );
    
    uix.Empty('Parent',g.b1c.t4c.bc.bt);
    g.b1c.t4c.bc.btc.bt13=uicontrol( 'Parent', g.b1c.t4c.bc.bt2, 'String', 'Re-Meas' ,'UserData',[1 4 13],'Callback',@Bt_1_4_13_measure);
    g.b1c.t4c.bc.btc.bt11=uicontrol( 'Parent', g.b1c.t4c.bc.bt2, 'String', 'Save Meas' ,'UserData',[1 4 11],'Callback',@Bt_1_4_11_save);
    g.b1c.t4c.bc.btc.bt12=uicontrol( 'Parent', g.b1c.t4c.bc.bt2, 'String', 'Load Meas','UserData',[1 4 12],'Callback',@Bt_1_4_12_load );
    g.b1c.t4c.bc.btc.bt14=uicontrol( 'Parent', g.b1c.t4c.bc.bt2, 'String', 'Next' ,'UserData',[1 4 5],'Callback',@Bt_Next);
    set( g.b1c.t4c.b, 'Heights', [-3 35 -1 35] )

%% setup tab5
    %split layout 1 H 2 V
    g.b1c.t5c.a = uix.VBox( 'Parent', g.b1c.t5, 'Padding', 5 );
    g.b1c.t5c.p1 = uix.Panel( 'Parent', g.b1c.t5c.a, 'Padding', 5 );
    g.b1c.t5c.p2 = uix.Panel( 'Parent', g.b1c.t5c.a, 'Padding', 5 );
    set( g.b1c.t5c.a, 'Heights', [-4 -1] );
    g.b1c.t5c.b = uix.HBoxFlex( 'Parent', g.b1c.t5c.p1, 'Padding', 5 );
    g.b1c.t5c.bc.vb1 = uix.VBox( 'Parent', g.b1c.t5c.b, 'Padding', 5 );
    g.b1c.t5c.bc.vb2 = uix.VBox( 'Parent', g.b1c.t5c.b, 'Padding', 5 );
    set( g.b1c.t5c.b, 'Widths', [-1 -3] );
    % load report header
    T=readtable('./configuration/REreportheader.xlsx');
  
    [mm nn]=size(T);
    %Create inputs
    for i=1:mm
        str1=['g.b1c.t5c.tx' num2str(i) '=uicontrol( ''Style'',''text'',''Parent'', g.b1c.t5c.bc.vb1, ''String'', ''' ...
             T.name{i} ''');'];eval(str1);
        %remove the return replace it with space
        T.value{i} = regexprep(T.value{i},'\n',' ');
        str2=['g.b1c.t5c.rx' num2str(i) '=uicontrol( ''Style'',''edit'',''Parent'', g.b1c.t5c.bc.vb2, ''String'', ''' ...
             T.value{i} ''');'];eval(str2);
    end
    %make the last input multiple line possible
    str1=['g.b1c.t5c.rx' num2str(mm) '.Min=0;']; eval(str1);
    str2=['g.b1c.t5c.rx' num2str(mm) '.Max=2;']; eval(str2);  % This is the key to multiline edits.            
    uix.Empty('Parent', g.b1c.t5c.bc.vb2 );
    uix.Empty('Parent', g.b1c.t5c.bc.vb1 );
    % assign buttons
    g.b1c.t5c.bt1=uicontrol( 'Parent', g.b1c.t5c.bc.vb1, 'String', 'Create Report', 'Callback',@fcreate,'UserData',[1 5 1]);
    g.b1c.t5c.bt2=uicontrol( 'Parent', g.b1c.t5c.bc.vb1, 'String', 'Save', 'Callback',@fsave_as_header,'UserData',[1 5 2]);
    g.b1c.t5c.bt3=uicontrol( 'Parent', g.b1c.t5c.bc.vb1, 'String', 'Load', 'Callback', @floadheader,'UserData',[1 5 3]);
    set( g.b1c.t5c.bc.vb1, 'Heights', 30*ones(1,mm+4) );
    set( g.b1c.t5c.bc.vb2, 'Heights', [30*ones(1,mm-1) 150 30] );
   
     % setup p2
     g.b1c.t5c.bc.bt = uix.HButtonBox( 'Parent', g.b1c.t5c.p2, 'Padding', 5 );
     g.b1c.t5c.bc.chk1=uicontrol( 'Style','checkbox','Parent', g.b1c.t5c.bc.bt, 'String', 'Scan H','Value',1 );
     g.b1c.t5c.bc.chk2=uicontrol( 'Style','checkbox','Parent', g.b1c.t5c.bc.bt, 'String', 'Scan V','Value',1 );
     g.b1c.t5c.bc.chk3=uicontrol( 'Style','checkbox','Parent', g.b1c.t5c.bc.bt, 'String', '3D H','Value',0 );
     g.b1c.t5c.bc.chk4=uicontrol( 'Style','checkbox','Parent', g.b1c.t5c.bc.bt, 'String', '3D V', 'Value',0 );
     g.b1c.t5c.bc.chk5=uicontrol( 'Style','checkbox','Parent', g.b1c.t5c.bc.bt, 'String', 'Image 1','Value',0 ,'Callback',@load_setup_image,'UserData',[1 5 11]);
     g.b1c.t5c.bc.chk6=uicontrol( 'Style','checkbox','Parent', g.b1c.t5c.bc.bt, 'String', 'Image 2','Value',0 ,'Callback',@load_setup_image,'UserData',[1 5 12]);
     g.b1c.t5c.bc.chk7=uicontrol( 'Style','checkbox','Parent', g.b1c.t5c.bc.bt, 'String', 'Image 3','Value',0 ,'Callback',@load_setup_image,'UserData',[1 5 13]);
     g.b1c.t5c.bc.chk8=uicontrol( 'Style','checkbox','Parent', g.b1c.t5c.bc.bt, 'String', 'Image 4','Value',0 ,'Callback',@load_setup_image,'UserData',[1 5 14]);
     g.b1c.t5c.bc.chk9=uicontrol( 'Style','checkbox','Parent', g.b1c.t5c.bc.bt, 'String', 'Image 5','Value',0 ,'Callback',@load_setup_image,'UserData',[1 5 15]);
    
end

function fb2(source,callbackdata)
global g
global d
   % initialize dataOBJ
        d=dataObj;
%% setup  button 2
%% setup  panel 2
     %create tabs
             g.b2c=[];delete(g.p2.Children(:));
             g.b2c.t1 = uix.Panel( 'Parent', g.p2, 'Title', 'Please Inti ', 'Padding', 5 );
             g.b2c.t2 = uix.Panel( 'Parent', g.p2, 'Title', 'Quick Scan using Peak detector Measurement', 'Padding', 5 );
           %  g.b2c.t3 = uix.Panel( 'Parent', g.p2, 'Title', 'Search peaks and data analysis', 'Padding', 5 );
             g.b2c.t4 = uix.Panel( 'Parent', g.p2, 'Title', 'Quasi-peak Measurement', 'Padding', 5 );
             g.b2c.t5 = uix.Panel( 'Parent', g.p2, 'Title', 'Report', 'Padding', 5 );
             g.p2.TabTitles = {'Setup ', 'Scan','Measure','Report'};
g.p2.Selection = 1;

%% setup tab 1 
    % create 1Hbox 2vbox 
    g.b2c.t1c.b = uix.HBoxFlex( 'Parent', g.b2c.t1, 'Padding', 5 );
    g.b2c.t1c.bc.vb1 = uix.VBox( 'Parent', g.b2c.t1c.b, 'Padding', 5 );
    g.b2c.t1c.bc.vb2 = uix.VBox( 'Parent', g.b2c.t1c.b, 'Padding', 5 );
    set( g.b2c.t1c.b, 'Widths', [-1 -2] );
    %load configuration file
    
    T=readtable('./configuration/CEconfiguration.xlsx');
    g.T=T;
    [mm nn]=size(T);
    % creat uicontrols inputs
    
    for i=1:mm
        str1=['g.b2c.t1c.tx' num2str(i) '=uicontrol( ''Style'',''text'',''Parent'', g.b2c.t1c.bc.vb1, ''String'', ''' ...
             T.name{i} ''');'];eval(str1);  
        str2=['g.b2c.t1c.rx' num2str(i) '=uicontrol( ''Style'',''edit'',''Parent'', g.b2c.t1c.bc.vb2, ''String'', ''' ...
             T.value{i} ''');'];eval(str2);
    end
    uix.Empty('Parent', g.b2c.t1c.bc.vb2 );
    uix.Empty('Parent', g.b2c.t1c.bc.vb1 );
    
    %creat buttons 
    g.b2c.t1c.bt1=uicontrol( 'Parent', g.b2c.t1c.bc.vb1, 'String', 'Connect', 'Callback',@fconnect,'UserData',[2 1 1]);
    g.b2c.t1c.bt2=uicontrol( 'Parent', g.b2c.t1c.bc.vb1, 'String', 'Save', 'Callback',@fsaveconfig,'UserData',[2 1 2]);
    g.b2c.t1c.bt3=uicontrol( 'Parent', g.b2c.t1c.bc.vb1, 'String', 'Load', 'Callback', @floadconfig,'UserData',[2 1 3]);
    %creat status 
    g.b2c.t1c.txstatus=uicontrol( 'Style','text','Parent', g.b2c.t1c.bc.vb2, 'String', '' );
    %format the layout
    set( g.b2c.t1c.bc.vb1, 'Heights', 30*ones(1,mm+4) );
    set( g.b2c.t1c.bc.vb2, 'Heights', 30*ones(1,mm+2) );
  
%% setup tab2 scan

    g.b2c.t2c.b = uix.VBoxFlex( 'Parent', g.b2c.t2, 'Padding', 5 );
    g.b2c.t2c.bc.c1 =uicontainer('Parent',g.b2c.t2c.b);
    g.b2c.t2c.bc.c2 =uicontainer('Parent',g.b2c.t2c.b);
    g.b2c.t2c.bc.ax1=axes( 'Parent', g.b2c.t2c.bc.c1,'UserData',[2 2 0]);
    g.b2c.t2c.bc.ax2=axes( 'Parent', g.b2c.t2c.bc.c2,'UserData',[2 2 1]);
    g.b2c.t2c.bc.bt = uix.HButtonBox( 'Parent', g.b2c.t2c.b, 'Padding', 5 );
    g.b2c.t2c.bc.btc.bt1=uicontrol( 'Style','checkbox','Parent', g.b2c.t2c.bc.bt, 'String', 'Line 1','Value',1 );
    g.b2c.t2c.bc.btc.bt2=uicontrol('Style','checkbox', 'Parent', g.b2c.t2c.bc.bt, 'String', 'Neutral','Value',1 );
    g.b2c.t2c.bc.btc.bt3=uicontrol( 'Parent', g.b2c.t2c.bc.bt, 'String', 'Measurement','UserData',[2 2 1],'Callback',@Bt_Measure );
    g.b2c.t2c.bc.btc.bt5=uicontrol( 'Parent', g.b2c.t2c.bc.bt, 'String', 'Save' ,'UserData',[2 2 3],'Callback',@Bt_Save);
    g.b2c.t2c.bc.btc.bt6=uicontrol( 'Parent', g.b2c.t2c.bc.bt, 'String', 'Load' ,'UserData',[2 2 4],'Callback',@Bt_Load);
    g.b2c.t2c.bc.btc.bt8=uicontrol( 'Parent', g.b2c.t2c.bc.bt, 'String', 'Next','UserData',[2 2 5],'Callback',@Bt_Next );

set( g.b2c.t2c.b, 'Heights', [-1 -1 35] )

%% setup tab4
    g.b2c.t4c.b = uix.VBoxFlex( 'Parent', g.b2c.t4, 'Padding', 5 );
    g.b2c.t4c.bc.c=uicontainer('Parent',g.b2c.t4c.b)
    g.b2c.t4c.bc.ax1=axes( 'Parent', g.b2c.t4c.bc.c);
    g.b2c.t4c.bc.bt = uix.HButtonBox( 'Parent', g.b2c.t4c.b, 'Padding', 5 );
    g.b2c.t4c.bc.tb1=uitable( 'Parent', g.b2c.t4c.b,'Tag','tb2','CellSelectionCallback',@(src,evnt)set(src,'UserData',evnt.Indices));
    g.b2c.t4c.bc.bt2 = uix.HButtonBox( 'Parent', g.b2c.t4c.b, 'Padding', 5 );
   
    g.b2c.t4c.bc.btc.bt1=uicontrol( 'Style','radiobutton','Parent', g.b2c.t4c.bc.bt, 'String', 'Line','Value',0,...
                                   'UserData',[2 4 1], 'Callback',@Bt_1_3_1_selectdata );
    g.b2c.t4c.bc.btc.bt2=uicontrol('Style','radiobutton', 'Parent', g.b2c.t4c.bc.bt, 'String', 'Neutral','Value',1 ,...
                                   'UserData',[2 4 2], 'Callback',@Bt_1_3_2_selectdata );
    g.b2c.t4c.bc.btc.bt3=uicontrol( 'Parent', g.b2c.t4c.bc.bt, 'String', 'Search','UserData',[2 4 3],'Callback',@Bt_1_4_3_searchpeak );
    g.b2c.t4c.bc.btc.bt4=uicontrol( 'Parent', g.b2c.t4c.bc.bt, 'String', 'Filter','UserData',[2 4 4],'Callback',@Bt_1_4_4_searchpeak  );
    g.b2c.t4c.bc.btc.bt7=uicontrol( 'Style','text','Parent', g.b2c.t4c.bc.bt, 'String', 'RBW' );
    g.b2c.t4c.bc.btc.bt8=uicontrol( 'Style','edit','Parent', g.b2c.t4c.bc.bt, 'String', '10','UserData',[2 4 8],'Callback',@Bt_1_4_8_rbw );
    g.b2c.t4c.bc.btc.bt9=uicontrol( 'Style','text','Parent', g.b2c.t4c.bc.bt, 'String', 'MHz' );
    g.b2c.t4c.bc.btc.bt15=uicontrol( 'Parent', g.b2c.t4c.bc.bt, 'String', 'Save List' ,'UserData',[2 4 15],'Callback',@Bt_1_4_15_savelist);
    g.b2c.t4c.bc.btc.bt16=uicontrol( 'Parent', g.b2c.t4c.bc.bt, 'String', 'Load List','UserData',[2 4 16],'Callback',@Bt_1_4_16_loadlist );
    
    uix.Empty(g.b2c.t4c.bc.bt);
    g.b2c.t4c.bc.btc.bt13=uicontrol( 'Parent', g.b2c.t4c.bc.bt2, 'String', 'Re-Meas' ,'UserData',[2 4 13],'Callback',@Bt_1_4_13_measure);
    g.b2c.t4c.bc.btc.bt11=uicontrol( 'Parent', g.b2c.t4c.bc.bt2, 'String', 'Save Meas' ,'UserData',[2 4 11],'Callback',@Bt_1_4_11_save);
    g.b2c.t4c.bc.btc.bt12=uicontrol( 'Parent', g.b2c.t4c.bc.bt2, 'String', 'Load Meas','UserData',[2 4 12],'Callback',@Bt_1_4_12_load );
    g.b2c.t4c.bc.btc.bt14=uicontrol( 'Parent', g.b2c.t4c.bc.bt2, 'String', 'Next' ,'UserData',[2 4 5],'Callback',@Bt_Next);
    set( g.b2c.t4c.b, 'Heights', [-3 35 -1 35] )

    
%% setup tab5
   %split layout 1 H 2 V
 
    g.b2c.t5c.a = uix.VBox( 'Parent', g.b2c.t5, 'Padding', 5 );
    g.b2c.t5c.p1 = uix.Panel( 'Parent', g.b2c.t5c.a, 'Padding', 5 );
    g.b2c.t5c.p2 = uix.Panel( 'Parent', g.b2c.t5c.a, 'Padding', 5 );
    set( g.b2c.t5c.a, 'Heights', [-4 -1] );
    g.b2c.t5c.b = uix.HBoxFlex( 'Parent', g.b2c.t5c.p1, 'Padding', 5 );
    g.b2c.t5c.bc.vb1 = uix.VBox( 'Parent', g.b2c.t5c.b, 'Padding', 5 );
    g.b2c.t5c.bc.vb2 = uix.VBox( 'Parent', g.b2c.t5c.b, 'Padding', 5 );
    set( g.b2c.t5c.b, 'Widths', [-1 -3] );
    % load report header
    T=readtable('./configuration/REreportheader.xlsx');
   
    [mm nn]=size(T);
    %Create inputs
    for i=1:mm
        str1=['g.b2c.t5c.tx' num2str(i) '=uicontrol( ''Style'',''text'',''Parent'', g.b2c.t5c.bc.vb1, ''String'', ''' ...
             T.name{i} ''');'];eval(str1);
        %remove the return replace it with space
        T.value{i} = regexprep(T.value{i},'\n',' ');
        str2=['g.b2c.t5c.rx' num2str(i) '=uicontrol( ''Style'',''edit'',''Parent'', g.b2c.t5c.bc.vb2, ''String'', ''' ...
             T.value{i} ''');'];eval(str2);
    end
    %make the last input multiple line possible
    str1=['g.b2c.t5c.rx' num2str(mm) '.Min=0;']; eval(str1);
    str2=['g.b2c.t5c.rx' num2str(mm) '.Max=2;']; eval(str2);  % This is the key to multiline edits.            
    uix.Empty('Parent', g.b2c.t5c.bc.vb2 );
    uix.Empty('Parent', g.b2c.t5c.bc.vb1 );
    % assign buttons
    g.b2c.t5c.bt1=uicontrol( 'Parent', g.b2c.t5c.bc.vb1, 'String', 'Create Report', 'Callback',@fcreate,'UserData',[2 5 1]);
    g.b2c.t5c.bt2=uicontrol( 'Parent', g.b2c.t5c.bc.vb1, 'String', 'Save', 'Callback',@fsave_as_header,'UserData',[2 5 2]);
    g.b2c.t5c.bt3=uicontrol( 'Parent', g.b2c.t5c.bc.vb1, 'String', 'Load', 'Callback', @floadheader,'UserData',[2 5 3]);
    set( g.b2c.t5c.bc.vb1, 'Heights', 30*ones(1,mm+4) );
    set( g.b2c.t5c.bc.vb2, 'Heights', [30*ones(1,mm-1) 150 30] );
   
     % setup p2
     g.b2c.t5c.bc.bt = uix.HButtonBox( 'Parent', g.b2c.t5c.p2, 'Padding', 5 );
     g.b2c.t5c.bc.chk1=uicontrol( 'Style','checkbox','Parent', g.b2c.t5c.bc.bt, 'String', 'Scan H','Value',1 );
     g.b2c.t5c.bc.chk2=uicontrol( 'Style','checkbox','Parent', g.b2c.t5c.bc.bt, 'String', 'Scan V','Value',1 );
     g.b2c.t5c.bc.chk3=uicontrol( 'Style','checkbox','Parent', g.b2c.t5c.bc.bt, 'String', '3D H','Value',0 );
     g.b2c.t5c.bc.chk4=uicontrol( 'Style','checkbox','Parent', g.b2c.t5c.bc.bt, 'String', '3D V', 'Value',0 );
     g.b2c.t5c.bc.chk5=uicontrol( 'Style','checkbox','Parent', g.b2c.t5c.bc.bt, 'String', 'Image 1','Value',0 ,'Callback',@load_setup_image,'UserData',[2 5 11]);
     g.b2c.t5c.bc.chk6=uicontrol( 'Style','checkbox','Parent', g.b2c.t5c.bc.bt, 'String', 'Image 2','Value',0 ,'Callback',@load_setup_image,'UserData',[2 5 12]);
     g.b2c.t5c.bc.chk7=uicontrol( 'Style','checkbox','Parent', g.b2c.t5c.bc.bt, 'String', 'Image 3','Value',0 ,'Callback',@load_setup_image,'UserData',[2 5 13]);
     g.b2c.t5c.bc.chk8=uicontrol( 'Style','checkbox','Parent', g.b2c.t5c.bc.bt, 'String', 'Image 4','Value',0 ,'Callback',@load_setup_image,'UserData',[2 5 14]);
     g.b2c.t5c.bc.chk9=uicontrol( 'Style','checkbox','Parent', g.b2c.t5c.bc.bt, 'String', 'Image 5','Value',0 ,'Callback',@load_setup_image,'UserData',[2 5 15]);
end
function fb3(source,callbackdata)
global g

g.fig_polar_scan=[];
%% setup  button 3
%% setup  panel 2
     %create tabs
             g.b3c=[];delete(g.p2.Children(:));
             g.b3c.t1 = uix.Panel( 'Parent', g.p2, 'Title', 'Please Inti ', 'Padding', 5 );
             g.b3c.t2 = uix.Panel( 'Parent', g.p2, 'Title', 'Quick Scan using Peak detector Measurement', 'Padding', 5 );
             g.b3c.t3 = uix.Panel( 'Parent', g.p2, 'Title', 'Search peaks and data analysis', 'Padding', 5 );
             g.b3c.t4 = uix.Panel( 'Parent', g.p2, 'Title', 'Quasi-peak Measurement', 'Padding', 5 );
             g.b3c.t5 = uix.Panel( 'Parent', g.p2, 'Title', 'Report', 'Padding', 5 );
             g.p2.TabTitles = {'Setup ', 'Scan','Search','Measure','Report'};
g.p2.Selection = 1;

%% setup tab 1 
    % create 1Hbox 2vbox 
    g.b3c.t1c.b = uix.HBoxFlex( 'Parent', g.b3c.t1, 'Padding', 5 );
    g.b3c.t1c.bc.vb1 = uix.VBox( 'Parent', g.b3c.t1c.b, 'Padding', 5 );
    g.b3c.t1c.bc.vb2 = uix.VBox( 'Parent', g.b3c.t1c.b, 'Padding', 5 );
    set( g.b3c.t1c.b, 'Widths', [-1 -2] );
    %load configuration file
    
    T=readtable('./configuration/OATconfiguration.xlsx');
    g.T=T;
    [mm nn]=size(T);
    % creat uicontrols inputs
    
    for i=1:mm
        str1=['g.b3c.t1c.tx' num2str(i) '=uicontrol( ''Style'',''text'',''Parent'', g.b3c.t1c.bc.vb1, ''String'', ''' ...
             T.name{i} ''');'];eval(str1);  
        str2=['g.b3c.t1c.rx' num2str(i) '=uicontrol( ''Style'',''edit'',''Parent'', g.b3c.t1c.bc.vb2, ''String'', ''' ...
             T.value{i} ''');'];eval(str2);
    end
    uix.Empty('Parent', g.b3c.t1c.bc.vb2 );
    uix.Empty('Parent', g.b3c.t1c.bc.vb1 );
    
    %creat buttons 
    g.b3c.t1c.bt1=uicontrol( 'Parent', g.b3c.t1c.bc.vb1, 'String', 'Connect', 'Callback',@fconnect,'UserData',[3 1 1]);
    g.b3c.t1c.bt2=uicontrol( 'Parent', g.b3c.t1c.bc.vb1, 'String', 'Save', 'Callback',@fsaveconfig,'UserData',[3 1 2]);
    g.b3c.t1c.bt3=uicontrol( 'Parent', g.b3c.t1c.bc.vb1, 'String', 'Load', 'Callback', @floadconfig,'UserData',[3 1 3]);
    %creat status 
    g.b3c.t1c.txstatus=uicontrol( 'Style','text','Parent', g.b3c.t1c.bc.vb2, 'String', '' );
    %format the layout
    set( g.b3c.t1c.bc.vb1, 'Heights', 30*ones(1,mm+4) );
    set( g.b3c.t1c.bc.vb2, 'Heights', 30*ones(1,mm+2) );
  
%% setup tab2 scan

    g.b3c.t2c.b = uix.VBoxFlex( 'Parent', g.b3c.t2, 'Padding', 5 );
    g.b3c.t2c.bc.p1 = uix.Panel( 'Parent', g.b3c.t2c.b, 'Padding', 5 );
    g.b3c.t2c.bc.p2 = uix.Panel( 'Parent', g.b3c.t2c.b, 'Padding', 5 );
    g.b3c.t2c.bc.p1c.c=uicontainer('Parent',g.b3c.t2c.bc.p1);
    g.b3c.t2c.bc.p2c.c=uicontainer('Parent',g.b3c.t2c.bc.p2);
    
    %g.b3c.t2c.bc.c=uicontainer('Parent',g.b3c.t2c.b);
    g.b3c.t2c.bc.ax1=axes( 'Parent', g.b3c.t2c.bc.p1c.c,'UserData',[3 2 0]);
    g.b3c.t2c.bc.ax2=axes( 'Parent', g.b3c.t2c.bc.p2c.c,'UserData',[3 2 1]);
    
    g.b3c.t2c.bc.bt = uix.HButtonBox( 'Parent', g.b3c.t2c.b, 'Padding', 5 );
    g.b3c.t2c.bc.btc.bt1=uicontrol( 'Style','checkbox','Parent', g.b3c.t2c.bc.bt, 'String', 'Horizontal','Value',1 );
    g.b3c.t2c.bc.btc.bt1=uicontrol('Style','checkbox', 'Parent', g.b3c.t2c.bc.bt, 'String', 'Vertical','Value',1 );
    g.b3c.t2c.bc.btc.bt1=uicontrol( 'Parent', g.b3c.t2c.bc.bt, 'String', 'Measurement','UserData',[3 2 1] ,'Callback',@Bt_Measure);
    g.b3c.t2c.bc.btc.bt2=uicontrol( 'Parent', g.b3c.t2c.bc.bt, 'String', 'Pause','UserData',[3 2 2] ,'Callback',@Bt_Pause);
    g.b3c.t2c.bc.btc.bt3=uicontrol( 'Parent', g.b3c.t2c.bc.bt, 'String', 'Save','UserData',[3 2 3] ,'Callback',@Bt_Save);
    g.b3c.t2c.bc.btc.bt3=uicontrol( 'Parent', g.b3c.t2c.bc.bt, 'String', 'Load','UserData',[3 2 4],'Callback',@Bt_Load );
     g.b3c.t2c.bc.btc.bt3=uicontrol( 'Parent', g.b3c.t2c.bc.bt, 'String', 'Convert','UserData',[3 2 7],'Callback',@Bt_Convert );
    g.b3c.t2c.bc.btc.bt7=uicontrol( 'Parent', g.b3c.t2c.bc.bt, 'String', 'Resize','UserData',[3 2 6],'Callback',@Bt_Resize );
    g.b3c.t2c.bc.btc.bt4=uicontrol( 'Parent', g.b3c.t2c.bc.bt, 'String', 'Next','UserData',[3 2 5],'Callback',@Bt_Next );

set( g.b3c.t2c.b, 'Heights', [-1 -1 35] )
%% setup tab3



    g.b3c.t3c.b = uix.VBox( 'Parent', g.b3c.t3, 'Padding', 5 );
   g.b3c.t3c.bc.c=uicontainer('Parent',g.b3c.t3c.b);
    g.b3c.t3c.bc.ax1=axes( 'Parent', g.b3c.t3c.bc.c);
    g.b3c.t3c.bc.bt = uix.HButtonBox( 'Parent', g.b3c.t3c.b, 'Padding', 5 );
    
    g.b3c.t3c.bc.btc.bt0=uicontrol( 'Style','text','Parent', g.b3c.t3c.bc.bt, 'String', 'Data' );
    g.b3c.t3c.bc.btc.bt1=uicontrol( 'Style','radiobutton','Parent', g.b3c.t3c.bc.bt, 'String', 'Hoziontal','Value',1,...
                                     'UserData',[3 3 1], 'Callback',@Bt_1_3_1_selectdata );
    g.b3c.t3c.bc.btc.bt2=uicontrol('Style','radiobutton', 'Parent', g.b3c.t3c.bc.bt, 'String', 'Vertical','Value',0,...
                                    'UserData',[3 3 2], 'Callback',@Bt_1_3_2_selectdata );
  
    
   % g.b3c.t3c.bc.btc.bt3=uicontrol( 'Parent', g.b3c.t3c.bc.bt, 'String', 'Search Peak' );
    uix.Empty(g.b3c.t3c.bc.bt)
   
    g.b3c.t3c.bc.btc.bt11=uicontrol( 'Parent', g.b3c.t3c.bc.bt, 'String', 'Polar Plot','UserData',[3 3 11],'Callback',@Bt_1_3_11_viewpolar );
    g.b3c.t3c.bc.btc.bt10=uicontrol( 'Parent', g.b3c.t3c.bc.bt, 'String', '3D plot' ,'UserData',[3 3 10],'Callback',@Bt_1_3_10_view3D );
    g.b3c.t3c.bc.btc.bt5=uicontrol( 'Style','text','Parent', g.b3c.t3c.bc.bt, 'String', ' View Angle:' );
    g.b3c.t3c.bc.btc.bt6=uicontrol( 'Style','text','Parent', g.b3c.t3c.bc.bt, 'String', ' R= ' );
    g.b3c.t3c.bc.btc.bt7=uicontrol( 'Style','edit','Parent', g.b3c.t3c.bc.bt, 'String', '45','UserData',[3 3 7],'Callback',@Bt_viewangle);
    g.b3c.t3c.bc.btc.bt8=uicontrol( 'Style','text','Parent', g.b3c.t3c.bc.bt, 'String', 'Theta=' );
    g.b3c.t3c.bc.btc.bt9=uicontrol( 'Style','edit','Parent', g.b3c.t3c.bc.bt, 'String', '45','UserData',[3 3 9],'Callback',@Bt_viewangle);
    g.b3c.t3c.bc.btc.bt4=uicontrol( 'Parent', g.b3c.t3c.bc.bt, 'String', 'Next' ,'UserData',[3 3 5],'Callback',@Bt_Next );

    set( g.b3c.t3c.b, 'Heights', [-1 35] )
%% setup tab4
    g.b3c.t4c.b = uix.VBoxFlex( 'Parent', g.b3c.t4, 'Padding', 5 );
    g.b3c.t4c.bc.c=uicontainer('Parent',g.b3c.t4c.b);
    g.b3c.t4c.bc.ax1=axes( 'Parent', g.b3c.t4c.bc.c);
    g.b3c.t4c.bc.bt = uix.HButtonBox( 'Parent', g.b3c.t4c.b, 'Padding', 5 );
    g.b3c.t4c.bc.tb1=uitable( 'Parent', g.b3c.t4c.b,'Tag','tb3','CellSelectionCallback',@(src,evnt)set(src,'UserData',evnt.Indices));
    g.b3c.t4c.bc.bt2 = uix.HButtonBox( 'Parent', g.b3c.t4c.b, 'Padding', 5 );
   
    g.b3c.t4c.bc.btc.bt1=uicontrol( 'Style','radiobutton','Parent', g.b3c.t4c.bc.bt, 'String', 'Horizontal','Value',0,...
                                   'UserData',[3 4 1], 'Callback',@Bt_1_3_1_selectdata );
    g.b3c.t4c.bc.btc.bt2=uicontrol('Style','radiobutton', 'Parent', g.b3c.t4c.bc.bt, 'String', 'Vertical','Value',1 ,...
                                   'UserData',[3 4 2], 'Callback',@Bt_1_3_2_selectdata );
    g.b3c.t4c.bc.btc.bt3=uicontrol( 'Parent', g.b3c.t4c.bc.bt, 'String', 'Search','UserData',[3 4 3],'Callback',@Bt_1_4_3_searchpeak );
    g.b3c.t4c.bc.btc.bt4=uicontrol( 'Parent', g.b3c.t4c.bc.bt, 'String', 'Filter','UserData',[3 4 4],'Callback',@Bt_1_4_4_searchpeak  );
    g.b3c.t4c.bc.btc.bt7=uicontrol( 'Style','text','Parent', g.b3c.t4c.bc.bt, 'String', 'RBW' );
    g.b3c.t4c.bc.btc.bt8=uicontrol( 'Style','edit','Parent', g.b3c.t4c.bc.bt, 'String', '10','UserData',[3 4 8],'Callback',@Bt_1_4_8_rbw );
    g.b3c.t4c.bc.btc.bt9=uicontrol( 'Style','text','Parent', g.b3c.t4c.bc.bt, 'String', 'MHz' );
    g.b3c.t4c.bc.btc.bt15=uicontrol( 'Parent', g.b3c.t4c.bc.bt, 'String', 'Save List' ,'UserData',[3 4 15],'Callback',@Bt_1_4_15_savelist);
    g.b3c.t4c.bc.btc.bt16=uicontrol( 'Parent', g.b3c.t4c.bc.bt, 'String', 'Load List','UserData',[3 4 16],'Callback',@Bt_1_4_16_loadlist );
    
    uix.Empty(g.b3c.t4c.bc.bt);
    g.b3c.t4c.bc.btc.bt13=uicontrol( 'Parent', g.b3c.t4c.bc.bt2, 'String', 'Re-Meas' ,'UserData',[3 4 13],'Callback',@Bt_1_4_13_measure);
    g.b3c.t4c.bc.btc.bt11=uicontrol( 'Parent', g.b3c.t4c.bc.bt2, 'String', 'Save Meas' ,'UserData',[3 4 11],'Callback',@Bt_1_4_11_save);
    g.b3c.t4c.bc.btc.bt12=uicontrol( 'Parent', g.b3c.t4c.bc.bt2, 'String', 'Load Meas','UserData',[3 4 12],'Callback',@Bt_1_4_12_load );
    g.b3c.t4c.bc.btc.bt14=uicontrol( 'Parent', g.b3c.t4c.bc.bt2, 'String', 'Next' ,'UserData',[3 4 5],'Callback',@Bt_Next);
    set( g.b3c.t4c.b, 'Heights', [-3 35 -1 35] )

%% setup tab5
     %split layout 1 H 2 V
    g.b3c.t5c.a = uix.VBox( 'Parent', g.b3c.t5, 'Padding', 5 );
    g.b3c.t5c.p1 = uix.Panel( 'Parent', g.b3c.t5c.a, 'Padding', 5 );
    g.b3c.t5c.p2 = uix.Panel( 'Parent', g.b3c.t5c.a, 'Padding', 5 );
    set( g.b3c.t5c.a, 'Heights', [-4 -1] );
    g.b3c.t5c.b = uix.HBoxFlex( 'Parent', g.b3c.t5c.p1, 'Padding', 5 );
    g.b3c.t5c.bc.vb1 = uix.VBox( 'Parent', g.b3c.t5c.b, 'Padding', 5 );
    g.b3c.t5c.bc.vb2 = uix.VBox( 'Parent', g.b3c.t5c.b, 'Padding', 5 );
    set( g.b3c.t5c.b, 'Widths', [-1 -3] );
    % load report header
    T=readtable('./configuration/OATreportheader.xlsx');
    
    [mm nn]=size(T);
    %Create inputs
    for i=1:mm
        str1=['g.b3c.t5c.tx' num2str(i) '=uicontrol( ''Style'',''text'',''Parent'', g.b3c.t5c.bc.vb1, ''String'', ''' ...
             T.name{i} ''');'];eval(str1);
        %remove the return replace it with space
        T.value{i} = regexprep(T.value{i},'\n',' ');
        str2=['g.b3c.t5c.rx' num2str(i) '=uicontrol( ''Style'',''edit'',''Parent'', g.b3c.t5c.bc.vb2, ''String'', ''' ...
             T.value{i} ''');'];eval(str2);
    end
    %make the last input multiple line possible
    str1=['g.b3c.t5c.rx' num2str(mm) '.Min=0;']; eval(str1);
    str2=['g.b3c.t5c.rx' num2str(mm) '.Max=2;']; eval(str2);  % This is the key to multiline edits.            
    uix.Empty('Parent', g.b3c.t5c.bc.vb2 );
    uix.Empty('Parent', g.b3c.t5c.bc.vb1 );
    % assign buttons
    g.b3c.t5c.bt1=uicontrol( 'Parent', g.b3c.t5c.bc.vb1, 'String', 'Create Report', 'Callback',@fcreate,'UserData',[3 5 1]);
    g.b3c.t5c.bt2=uicontrol( 'Parent', g.b3c.t5c.bc.vb1, 'String', 'Save', 'Callback',@fsave_as_header,'UserData',[3 5 2]);
    g.b3c.t5c.bt3=uicontrol( 'Parent', g.b3c.t5c.bc.vb1, 'String', 'Load', 'Callback', @floadheader,'UserData',[3 5 3]);
    set( g.b3c.t5c.bc.vb1, 'Heights', 30*ones(1,mm+4) );
    set( g.b3c.t5c.bc.vb2, 'Heights', [30*ones(1,mm-1) 150 30] );
   
     % setup p2
     g.b3c.t5c.bc.bt = uix.HButtonBox( 'Parent', g.b3c.t5c.p2, 'Padding', 5 );
     g.b3c.t5c.bc.chk1=uicontrol( 'Style','checkbox','Parent', g.b3c.t5c.bc.bt, 'String', 'Scan H','Value',1 );
     g.b3c.t5c.bc.chk2=uicontrol( 'Style','checkbox','Parent', g.b3c.t5c.bc.bt, 'String', 'Scan V','Value',1 );
     g.b3c.t5c.bc.chk3=uicontrol( 'Style','checkbox','Parent', g.b3c.t5c.bc.bt, 'String', '3D H','Value',0 );
     g.b3c.t5c.bc.chk4=uicontrol( 'Style','checkbox','Parent', g.b3c.t5c.bc.bt, 'String', '3D V', 'Value',0 );
     g.b3c.t5c.bc.chk5=uicontrol( 'Style','checkbox','Parent', g.b3c.t5c.bc.bt, 'String', 'Image 1','Value',0 ,'Callback',@load_setup_image,'UserData',[3 5 11]);
     g.b3c.t5c.bc.chk6=uicontrol( 'Style','checkbox','Parent', g.b3c.t5c.bc.bt, 'String', 'Image 2','Value',0 ,'Callback',@load_setup_image,'UserData',[3 5 12]);
     g.b3c.t5c.bc.chk7=uicontrol( 'Style','checkbox','Parent', g.b3c.t5c.bc.bt, 'String', 'Image 3','Value',0 ,'Callback',@load_setup_image,'UserData',[3 5 13]);
     g.b3c.t5c.bc.chk8=uicontrol( 'Style','checkbox','Parent', g.b3c.t5c.bc.bt, 'String', 'Image 4','Value',0 ,'Callback',@load_setup_image,'UserData',[3 5 14]);
     g.b3c.t5c.bc.chk9=uicontrol( 'Style','checkbox','Parent', g.b3c.t5c.bc.bt, 'String', 'Image 5','Value',0 ,'Callback',@load_setup_image,'UserData',[3 5 15]);
    
end

function fb4(source,callbackdata)
global g
global d
   % initialize dataOBJ
        d=dataObj;
%% setup  button 2
%% setup  panel 2
     %create tabs
             g.b4c=[];delete(g.p2.Children(:));
             g.b4c.t1 = uix.Panel( 'Parent', g.p2, 'Title', 'Please Inti ', 'Padding', 5 );
             g.b4c.t2 = uix.Panel( 'Parent', g.p2, 'Title', 'Quick Scan using Peak detector Measurement', 'Padding', 5 );
           %  g.b4c.t3 = uix.Panel( 'Parent', g.p2, 'Title', 'Search peaks and data analysis', 'Padding', 5 );
           %  g.b4c.t4 = uix.Panel( 'Parent', g.p2, 'Title', 'Quasi-peak Measurement', 'Padding', 5 );
             g.b4c.t5 = uix.Panel( 'Parent', g.p2, 'Title', 'Report', 'Padding', 5 );
             g.p2.TabTitles = {'Setup ','Scan','Report'};
g.p2.Selection = 1;

%% setup tab 1 
    % create 1Hbox 2vbox 
    g.b4c.t1c.b = uix.HBoxFlex( 'Parent', g.b4c.t1, 'Padding', 5 );
    g.b4c.t1c.bc.vb1 = uix.VBox( 'Parent', g.b4c.t1c.b, 'Padding', 5 );
    g.b4c.t1c.bc.vb2 = uix.VBox( 'Parent', g.b4c.t1c.b, 'Padding', 5 );
    set( g.b4c.t1c.b, 'Widths', [-1 -2] );
    %load configuration file
    
    T=readtable('./configuration/CIconfiguration.xlsx');
    g.T=T;
    [mm nn]=size(T);
    % creat uicontrols inputs
    
    for i=1:mm
        str1=['g.b4c.t1c.tx' num2str(i) '=uicontrol( ''Style'',''text'',''Parent'', g.b4c.t1c.bc.vb1, ''String'', ''' ...
             T.name{i} ''');'];eval(str1);  
        str2=['g.b4c.t1c.rx' num2str(i) '=uicontrol( ''Style'',''edit'',''Parent'', g.b4c.t1c.bc.vb2, ''String'', ''' ...
             T.value{i} ''');'];eval(str2);
    end
    uix.Empty('Parent', g.b4c.t1c.bc.vb2 );
    uix.Empty('Parent', g.b4c.t1c.bc.vb1 );
    
    %creat buttons 
    g.b4c.t1c.bt1=uicontrol( 'Parent', g.b4c.t1c.bc.vb1, 'String', 'Connect', 'Callback',@fconnect,'UserData',[4 1 1]);
    g.b4c.t1c.bt2=uicontrol( 'Parent', g.b4c.t1c.bc.vb1, 'String', 'Save', 'Callback',@fsaveconfig,'UserData',[4 1 2]);
    g.b4c.t1c.bt3=uicontrol( 'Parent', g.b4c.t1c.bc.vb1, 'String', 'Load', 'Callback', @floadconfig,'UserData',[4 1 3]);
    %creat status 
    g.b4c.t1c.txstatus=uicontrol( 'Style','text','Parent', g.b4c.t1c.bc.vb2, 'String', '' );
    %format the layout
    set( g.b4c.t1c.bc.vb1, 'Heights', 30*ones(1,mm+4) );
    set( g.b4c.t1c.bc.vb2, 'Heights', 30*ones(1,mm+2) );
  
%% setup tab2 scan

    g.b4c.t2c.b = uix.VBoxFlex( 'Parent', g.b4c.t2, 'Padding', 5 );
    g.b4c.t2c.bc.c=uicontainer('Parent',g.b4c.t2c.b );
    g.b4c.t2c.bc.ax1=axes( 'Parent', g.b4c.t2c.bc.c,'UserData',[2 2 0]);
     g.b4c.t2c.bc.btc.tb1=uitable( 'Parent', g.b4c.t2c.b,'Tag','tb4','CellSelectionCallback',@(src,evnt)set(src,'UserData',evnt.Indices));
           g.b4c.t2c.bc.btc.tb1.ColumnName={' Frequency          (Hz) ','.                                                                          Mark                                                                     .'};
           g.b4c.t2c.bc.btc.tb1.Units='normalized';
           g.b4c.t2c.bc.btc.tb1.ColumnWidth={200 'auto'};
%     g.b4c.t2c.bc.bt = uix.HButtonBox( 'Parent', g.b4c.t2c.b, 'Padding', 5 );
%     g.b4c.t2c.bc.btc.bt1=uicontrol( 'Parent', g.b4c.t2c.bc.bt, 'String', 'Min','UserData',[4 2 1],'Callback',@CI_Measure );
%     g.b4c.t2c.bc.btc.bt2=uicontrol( 'Parent', g.b4c.t2c.bc.bt, 'String', '<< Reverse','UserData',[4 2 2],'Callback',@CI_Measure );
%     g.b4c.t2c.bc.btc.bt3=uicontrol( 'Parent', g.b4c.t2c.bc.bt, 'String', '<Down','UserData',[4 2 3],'Callback',@CI_Measure );
%     g.b4c.t2c.bc.btc.bt4=uicontrol( 'Parent', g.b4c.t2c.bc.bt, 'String', 'Pause','UserData',[4 2 4],'Callback',@CI_Measure );
%     g.b4c.t2c.bc.btc.bt41=uicontrol( 'Parent', g.b4c.t2c.bc.bt, 'String', 'Resume','UserData',[4 2 41],'Callback',@CI_Measure );
%     g.b4c.t2c.bc.btc.bt5=uicontrol( 'Parent', g.b4c.t2c.bc.bt, 'String', 'Up >','UserData',[4 2 5],'Callback',@CI_Measure );
%     g.b4c.t2c.bc.btc.bt6=uicontrol( 'Parent', g.b4c.t2c.bc.bt, 'String', 'Forward >>','UserData',[4 2 6],'Callback',@CI_Measure );
%     g.b4c.t2c.bc.btc.bt7=uicontrol( 'Parent', g.b4c.t2c.bc.bt, 'String', 'Max','UserData',[4 2 7],'Callback',@CI_Measure );
    
    g.b4c.t2c.bc.bt = uix.HButtonBox( 'Parent', g.b4c.t2c.b, 'Padding', 5 );
    g.b4c.t2c.bc.btc.bt1=uicontrol( 'Parent', g.b4c.t2c.bc.bt, 'String', 'Run','UserData',[4 2 1],'Callback',@CI_Measure );
    g.b4c.t2c.bc.btc.bt2=uicontrol( 'Parent', g.b4c.t2c.bc.bt, 'String', 'Pause','UserData',[4 2 2],'Callback',@CI_Measure );
    g.b4c.t2c.bc.btc.bt3=uicontrol( 'Parent', g.b4c.t2c.bc.bt, 'String', 'Stop','UserData',[4 2 3],'Callback',@CI_Measure );
    g.b4c.t2c.bc.btc.bt4=uicontrol( 'Parent', g.b4c.t2c.bc.bt, 'String', 'Check','UserData',[4 2 4],'Callback',@CI_Measure );
    g.b4c.t2c.bc.btc.bt5=uicontrol( 'Parent', g.b4c.t2c.bc.bt, 'String', 'Config','UserData',[4 2 5],'Callback',@CI_Measure );
%  
    g.b4c.t2c.bc.bt1 = uix.HButtonBox( 'Parent', g.b4c.t2c.b, 'Padding', 5 );
    g.b4c.t2c.bc.btc.bt8=uicontrol( 'Parent', g.b4c.t2c.bc.bt1, 'String', 'Mark Current Frequency','UserData',[4 2 8],'Callback',@CI_Measure );
    g.b4c.t2c.bc.btc.bt9=uicontrol( 'Parent', g.b4c.t2c.bc.bt1, 'Style','edit','String', 'None','UserData',[4 2 9],'Callback',@CI_Measure );
    g.b4c.t2c.bc.btc.bt10=uicontrol( 'Parent', g.b4c.t2c.bc.bt1, 'Style','text','String', 'MHz','UserData',[4 2 10]);
   
    
     g.b4c.t2c.bc.btc.bt11=uicontrol( 'Parent', g.b4c.t2c.b, 'Style','popupmenu','String', ...
         {'A. Pass -Normal performance within specified limits',...
          'B. Pass -Temporary degradation self recoverable',...
          'C. Pass -Temporary interruption. requires operator intervention',...
          'D. Fail -Not recoverable. Components hardware failure'},'UserData',[4 2 11],'Callback',@CI_Measure );
   %  g.b4c.t2c.bc.btc.bt12=uicontrol( 'Parent', g.b4c.t2c.b, 'Style','text','String', 'Detaled comments on selected frequency','UserData',[4 2 12],'Callback',@CI_Measure );
%     g.b4c.t2c.bc.btc.bt13=uicontrol( 'Parent', g.b4c.t2c.b, 'Style','edit','String', 'None','UserData',[4 2 13],'Callback',@CI_Measure );
 
g.b4c.t2c.bc.btc.bt14=uicontrol( 'Parent', g.b4c.t2c.b,'String', 'Next','UserData',[4 2 14],'Callback',@CI_Measure );
          
set( g.b4c.t2c.b, 'Heights', [-3 -1 35 35 35 35] );

 

%% setup tab5
   %split layout 1 H 2 V
 
    g.b4c.t5c.a = uix.VBox( 'Parent', g.b4c.t5, 'Padding', 5 );
    g.b4c.t5c.p1 = uix.Panel( 'Parent', g.b4c.t5c.a, 'Padding', 5 );
    g.b4c.t5c.p2 = uix.Panel( 'Parent', g.b4c.t5c.a, 'Padding', 5 );
    set( g.b4c.t5c.a, 'Heights', [-4 -1] );
    g.b4c.t5c.b = uix.HBoxFlex( 'Parent', g.b4c.t5c.p1, 'Padding', 5 );
    g.b4c.t5c.bc.vb1 = uix.VBox( 'Parent', g.b4c.t5c.b, 'Padding', 5 );
    g.b4c.t5c.bc.vb2 = uix.VBox( 'Parent', g.b4c.t5c.b, 'Padding', 5 );
    set( g.b4c.t5c.b, 'Widths', [-1 -3] );
    % load report header
    T=readtable('./configuration/CIreportheader.xlsx');
    
    [mm nn]=size(T);
    %Create inputs
    for i=1:mm
        str1=['g.b4c.t5c.tx' num2str(i) '=uicontrol( ''Style'',''text'',''Parent'', g.b4c.t5c.bc.vb1, ''String'', ''' ...
             T.name{i} ''');'];eval(str1);
        %remove the return replace it with space
        T.value{i} = regexprep(T.value{i},'\n',' ');
        str2=['g.b4c.t5c.rx' num2str(i) '=uicontrol( ''Style'',''edit'',''Parent'', g.b4c.t5c.bc.vb2, ''String'', ''' ...
             T.value{i} ''');'];eval(str2);
    end
    %make the last input multiple line possible
    str1=['g.b4c.t5c.rx' num2str(mm) '.Min=0;']; eval(str1);
    str2=['g.b4c.t5c.rx' num2str(mm) '.Max=2;']; eval(str2);  % This is the key to multiline edits.            
    uix.Empty('Parent', g.b4c.t5c.bc.vb2 );
    uix.Empty('Parent', g.b4c.t5c.bc.vb1 );
    % assign buttons
    g.b4c.t5c.bt1=uicontrol( 'Parent', g.b4c.t5c.bc.vb1, 'String', 'Create Report', 'Callback',@fcreate,'UserData',[4 5 1]);
    g.b4c.t5c.bt2=uicontrol( 'Parent', g.b4c.t5c.bc.vb1, 'String', 'Save', 'Callback',@fsave_as_header,'UserData',[4 5 2]);
    g.b4c.t5c.bt3=uicontrol( 'Parent', g.b4c.t5c.bc.vb1, 'String', 'Load', 'Callback', @floadheader,'UserData',[4 5 3]);
    set( g.b4c.t5c.bc.vb1, 'Heights', 30*ones(1,mm+4) );
    set( g.b4c.t5c.bc.vb2, 'Heights', [30*ones(1,mm-1) 150 30] );
   
     % setup p2
     g.b4c.t5c.bc.bt = uix.HButtonBox( 'Parent', g.b4c.t5c.p2, 'Padding', 5 );
%      g.b4c.t5c.bc.chk1=uicontrol( 'Style','checkbox','Parent', g.b4c.t5c.bc.bt, 'String', 'Scan H','Value',1 );
%      g.b4c.t5c.bc.chk2=uicontrol( 'Style','checkbox','Parent', g.b4c.t5c.bc.bt, 'String', 'Scan V','Value',1 );
%      g.b4c.t5c.bc.chk3=uicontrol( 'Style','checkbox','Parent', g.b4c.t5c.bc.bt, 'String', '3D H','Value',0 );
%      g.b4c.t5c.bc.chk4=uicontrol( 'Style','checkbox','Parent', g.b4c.t5c.bc.bt, 'String', '3D V', 'Value',0 );
     g.b4c.t5c.bc.chk5=uicontrol( 'Style','checkbox','Parent', g.b4c.t5c.bc.bt, 'String', 'Image 1','Value',0 ,'Callback',@load_setup_image,'UserData',[2 5 11]);
     g.b4c.t5c.bc.chk6=uicontrol( 'Style','checkbox','Parent', g.b4c.t5c.bc.bt, 'String', 'Image 2','Value',0 ,'Callback',@load_setup_image,'UserData',[2 5 12]);
     g.b4c.t5c.bc.chk7=uicontrol( 'Style','checkbox','Parent', g.b4c.t5c.bc.bt, 'String', 'Image 3','Value',0 ,'Callback',@load_setup_image,'UserData',[2 5 13]);
     g.b4c.t5c.bc.chk8=uicontrol( 'Style','checkbox','Parent', g.b4c.t5c.bc.bt, 'String', 'Image 4','Value',0 ,'Callback',@load_setup_image,'UserData',[2 5 14]);
     g.b4c.t5c.bc.chk9=uicontrol( 'Style','checkbox','Parent', g.b4c.t5c.bc.bt, 'String', 'Image 5','Value',0 ,'Callback',@load_setup_image,'UserData',[2 5 15]);
end

function fb8(source,callbackdata)
global g
global d
   % change the windows size to larger
   tmp=g.f.OuterPosition;
   g.f.OuterPosition=[tmp(1) tmp(2) 1000 1000]
   % initialize dataOBJ
        d=dataObj;
%% setup  button 8
%% setup  panel 2
     %create tabs
             g.b8c=[];delete(g.p2.Children(:));
             g.b8c.t1 = uix.Panel( 'Parent', g.p2, 'Title', 'Please Inti ', 'Padding', 5 );
             g.b8c.t2 = uix.Panel( 'Parent', g.p2, 'Title', 'RI test', 'Padding', 5 );
             g.b8c.t3 = uix.Panel( 'Parent', g.p2, 'Title', 'Field Uniformaty test', 'Padding', 5 );
           %  g.b8c.t4 = uix.Panel( 'Parent', g.p2, 'Title', 'Quasi-peak Measurement', 'Padding', 5 );
             g.b8c.t5 = uix.Panel( 'Parent', g.p2, 'Title', 'Report', 'Padding', 5 );
             g.p2.TabTitles = {'Setup ','Scan','Calibration','Report'};
g.p2.Selection = 1;

%% setup tab 1 
    % create 1Hbox 2vbox 
    g.b8c.t1c.b = uix.HBoxFlex( 'Parent', g.b8c.t1, 'Padding', 5 );
    g.b8c.t1c.bc.vb1 = uix.VBox( 'Parent', g.b8c.t1c.b, 'Padding', 5 );
    g.b8c.t1c.bc.vb2 = uix.VBox( 'Parent', g.b8c.t1c.b, 'Padding', 5 );
    set( g.b8c.t1c.b, 'Widths', [-1 -2] );
    %load configuration file
    
    T=readtable('./configuration/RIconfiguration.xlsx');
    g.T=T;
    [mm nn]=size(T);
    % creat uicontrols inputs
    
    for i=1:mm
        str1=['g.b8c.t1c.tx' num2str(i) '=uicontrol( ''Style'',''text'',''Parent'', g.b8c.t1c.bc.vb1, ''String'', ''' ...
             T.name{i} ''');'];eval(str1);  
        str2=['g.b8c.t1c.rx' num2str(i) '=uicontrol( ''Style'',''edit'',''Parent'', g.b8c.t1c.bc.vb2, ''String'', ''' ...
             T.value{i} ''');'];eval(str2);
    end
    uix.Empty('Parent', g.b8c.t1c.bc.vb2 );
    uix.Empty('Parent', g.b8c.t1c.bc.vb1 );
    
    %creat buttons 
    g.b8c.t1c.bt1=uicontrol( 'Parent', g.b8c.t1c.bc.vb1, 'String', 'Connect', 'Callback',@fconnect,'UserData',[8 1 1]);
    g.b8c.t1c.bt3=uicontrol( 'Parent', g.b8c.t1c.bc.vb1, 'String', 'Load Calibration', 'Callback', @floadconfig,'UserData',[8 1 3]);
    g.b8c.t1c.bt2=uicontrol( 'Parent', g.b8c.t1c.bc.vb1, 'String', 'Save Template', 'Callback',@fsaveconfig,'UserData',[8 1 2]);
    g.b8c.t1c.bt4=uicontrol( 'Parent', g.b8c.t1c.bc.vb1, 'String', 'Next Step', 'Callback', @fnext,'UserData',[8 1 4]);
    %creat status 
    g.b8c.t1c.txstatus=uicontrol( 'Style','text','Parent', g.b8c.t1c.bc.vb2, 'String', '' );
    %format the layout
    set( g.b8c.t1c.bc.vb1, 'Heights', 30*ones(1,mm+5) );
    set( g.b8c.t1c.bc.vb2, 'Heights', 30*ones(1,mm+2) );
  
%% setup tab2 scan

    g.b8c.t2c.b = uix.VBoxFlex( 'Parent', g.b8c.t2, 'Padding', 5 );
    g.b8c.t2c.bc.c=uicontainer('Parent',g.b8c.t2c.b );
    g.b8c.t2c.bc.ax1=axes( 'Parent', g.b8c.t2c.bc.c,'UserData',[2 2 0,'xscale','log']);
     g.b8c.t2c.bc.btc.tb1=uitable( 'Parent', g.b8c.t2c.b,'Tag','tb4','CellSelectionCallback',@(src,evnt)set(src,'UserData',evnt.Indices));
           g.b8c.t2c.bc.btc.tb1.ColumnName={' Frequency (MHz) ','DuT Pos.','Antenna Pos.','.          Mark                              .'};
           g.b8c.t2c.bc.btc.tb1.Units='normalized';
           g.b8c.t2c.bc.btc.tb1.ColumnWidth={100 100 100 500};
    g.b8c.t2c.bc.bt = uix.HButtonBox( 'Parent', g.b8c.t2c.b, 'Padding', 5 );
    g.b8c.t2c.bc.btc.bt1=uicontrol( 'Parent', g.b8c.t2c.bc.bt, 'String', 'Run','UserData',[8 2 1],'Callback',@RI_Measure );
    g.b8c.t2c.bc.btc.bt2=uicontrol( 'Parent', g.b8c.t2c.bc.bt, 'String', 'Pause','UserData',[8 2 2],'Callback',@RI_Measure );
    g.b8c.t2c.bc.btc.bt3=uicontrol( 'Parent', g.b8c.t2c.bc.bt, 'String', 'Stop','UserData',[8 2 3],'Callback',@RI_Measure );
    g.b8c.t2c.bc.btc.bt4=uicontrol( 'Parent', g.b8c.t2c.bc.bt, 'String', 'Check','UserData',[8 2 4],'Callback',@RI_Measure );
    g.b8c.t2c.bc.btc.bt5=uicontrol( 'Parent', g.b8c.t2c.bc.bt, 'String', 'Config','UserData',[8 2 5],'Callback',@RI_Measure );
%     g.b8c.t2c.bc.btc.bt6=uicontrol( 'Parent', g.b8c.t2c.bc.bt, 'String', 'dwelling','UserData',[8 2 6],'Callback',@RI_Measure );
%     g.b8c.t2c.bc.btc.bt7=uicontrol( 'Parent', g.b8c.t2c.bc.bt, 'String', 'dewlling','UserData',[8 2 7],'Callback',@RI_Measure );
%     g.b8c.t2c.bc.btc.bt8=uicontrol( 'Parent', g.b8c.t2c.bc.bt, 'String', 'Point','UserData',[8 2 8],'Callback',@RI_Measure );
%     
    g.b8c.t2c.bc.bt1 = uix.HButtonBox( 'Parent', g.b8c.t2c.b, 'Padding', 5 );
    g.b8c.t2c.bc.btc.bt9=uicontrol( 'Parent', g.b8c.t2c.bc.bt1, 'String', 'Mark Current Frequency','UserData',[8 2 9],'Callback',@RI_Measure );
    g.b8c.t2c.bc.btc.bt10=uicontrol( 'Parent', g.b8c.t2c.bc.bt1, 'Style','edit','String', 'None','UserData',[8 2 10],'Callback',@RI_Measure );
    g.b8c.t2c.bc.btc.bt11=uicontrol( 'Parent', g.b8c.t2c.bc.bt1, 'Style','text','String', 'MHz','UserData',[8 2 11]);
   
    
     g.b8c.t2c.bc.btc.bt12=uicontrol( 'Parent', g.b8c.t2c.b, 'Style','popupmenu','String', ...
         {'A. Pass -Normal performance within specified limits',...
          'B. Pass -Temporary degradation self recoverable',...
          'C. Pass -Temporary interruption. requires operator intervention',...
          'D. Fail -Not recoverable. Components hardware failure'},'UserData',[8 2 12],'Callback',@RI_Measure );
   %  g.b8c.t2c.bc.btc.bt12=uicontrol( 'Parent', g.b8c.t2c.b, 'Style','text','String', 'Detaled comments on selected frequency','UserData',[4 2 12],'Callback',@RI_Measure );
%     g.b8c.t2c.bc.btc.bt13=uicontrol( 'Parent', g.b8c.t2c.b, 'Style','edit','String', 'None','UserData',[4 2 13],'Callback',@RI_Measure );
 
g.b8c.t2c.bc.btc.bt14=uicontrol( 'Parent', g.b8c.t2c.b,'String', 'Next','UserData',[8 2 13],'Callback',@RI_Measure );
          
set( g.b8c.t2c.b, 'Heights', [-3 -1 35 35 35 35] );

 %% setup tab3 Calibration 
    g.b8c.t3c.b = uix.VBoxFlex( 'Parent', g.b8c.t3, 'Padding', 5 );
    g.b8c.t3c.bc.c=uicontainer('Parent',g.b8c.t3c.b );
    g.b8c.t3c.bc.ax1=axes( 'Parent', g.b8c.t3c.bc.c,'UserData',[2 2 0],'xscale','log');
            
    g.b8c.t3c.bc.bt0 = uix.HButtonBox( 'Parent', g.b8c.t3c.b, 'Padding', 5 );
  %  g.b8c.t3c.bc.btc.b0=uicontrol( 'Parent', g.b8c.t3c.bc.bt0, 'Style','text', 'String', 'Antenna Polarization','UserData',[8 3 21],'Callback',@RI_Calibration );
   % g.b8c.t3c.bc.btc.b1=uicontrol( 'Parent', g.b8c.t3c.bc.bt0,  'Style','edit','String', 'Horizontal' ,'UserData',[8 3 22],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.b2=uicontrol( 'Parent', g.b8c.t3c.bc.bt0,  'Style','text','String', 'Antenna Height','UserData',[8 3 23],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.b3=uicontrol( 'Parent', g.b8c.t3c.bc.bt0,  'Style','edit','String', '110','UserData',[8 3 24],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.b4=uicontrol( 'Parent', g.b8c.t3c.bc.bt0,  'Style','text','String', 'Start Freq:','UserData',[8 3 25],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.b5=uicontrol( 'Parent', g.b8c.t3c.bc.bt0,  'Style','edit','String', '80e6','UserData',[8 3 26],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.b6=uicontrol( 'Parent', g.b8c.t3c.bc.bt0,  'Style','text','String', 'Stop Freq:','UserData',[8 3 27],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.b7=uicontrol( 'Parent', g.b8c.t3c.bc.bt0,  'Style','edit','String', '6e9','UserData',[8 3 28],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.b8=uicontrol( 'Parent', g.b8c.t3c.bc.bt0,  'Style','text','String', 'Points','UserData',[8 3 29],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.b9=uicontrol( 'Parent', g.b8c.t3c.bc.bt0,  'Style','edit','String', '50','UserData',[8 3 30],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.b12a=uicontrol( 'Parent', g.b8c.t3c.bc.bt0,'Style','radiobutton', 'String', 'Horizontal','UserData',[8 3 44],'Value',1,'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.b12b=uicontrol( 'Parent', g.b8c.t3c.bc.bt0,'Style','radiobutton', 'String', 'Vertical','UserData',[8 3 45],'Value',0,'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.b12c=uicontrol( 'Parent', g.b8c.t3c.bc.bt0, 'String', '<','UserData',[8 3 46],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.b12d=uicontrol( 'Parent', g.b8c.t3c.bc.bt0, 'String', '>','UserData',[8 3 47],'Callback',@RI_Calibration );
  
    
    g.b8c.t3c.bc.bt6 = uix.HButtonBox( 'Parent', g.b8c.t3c.b, 'Padding', 5 );
    g.b8c.t3c.bc.btc.b10a=uicontrol( 'Parent', g.b8c.t3c.bc.bt6,'Style','text', 'String', 'Coeff:');
    g.b8c.t3c.bc.btc.b10=uicontrol( 'Parent', g.b8c.t3c.bc.bt6, 'String', 'Measure Coeff','UserData',[8 3 41],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.b11=uicontrol( 'Parent', g.b8c.t3c.bc.bt6, 'String', 'Save Coeff','UserData',[8 3 42],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.b12=uicontrol( 'Parent', g.b8c.t3c.bc.bt6, 'String', 'Load Coeff','UserData',[8 3 43],'Callback',@RI_Calibration );
    
    
    
    g.b8c.t3c.bc.bt1 = uix.HButtonBox( 'Parent', g.b8c.t3c.b, 'Padding', 5 );
    g.b8c.t3c.bc.btc.bt1=uicontrol( 'Parent', g.b8c.t3c.bc.bt1, 'String', 'Pos 1','UserData',[8 3 1],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.bt5=uicontrol( 'Parent', g.b8c.t3c.bc.bt1, 'String', 'Pos 5','UserData',[8 3 5],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.bt8=uicontrol( 'Parent', g.b8c.t3c.bc.bt1, 'String', 'Pos 9','UserData',[8 3 9],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.bt13=uicontrol( 'Parent', g.b8c.t3c.bc.bt1, 'String', 'Pos 13','UserData',[8 3 13],'Callback',@RI_Calibration );
    
    g.b8c.t3c.bc.bt2 = uix.HButtonBox( 'Parent', g.b8c.t3c.b, 'Padding', 5 );
    g.b8c.t3c.bc.btc.bt2=uicontrol( 'Parent', g.b8c.t3c.bc.bt2, 'String', 'Pos 2','UserData',[8 3 2],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.bt6=uicontrol( 'Parent', g.b8c.t3c.bc.bt2, 'String', 'Pos 5','UserData',[8 3 6],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.bt10=uicontrol( 'Parent', g.b8c.t3c.bc.bt2, 'String', 'Pos 10','UserData',[8 3 10],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.bt14=uicontrol( 'Parent', g.b8c.t3c.bc.bt2, 'String', 'Pos 14','UserData',[8 3 14],'Callback',@RI_Calibration );
    
    
    g.b8c.t3c.bc.bt3 = uix.HButtonBox( 'Parent', g.b8c.t3c.b, 'Padding', 5 );
    g.b8c.t3c.bc.btc.bt3=uicontrol( 'Parent', g.b8c.t3c.bc.bt3, 'String', 'Pos 3','UserData',[8 3 3],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.bt7=uicontrol( 'Parent', g.b8c.t3c.bc.bt3, 'String', 'Pos 7','UserData',[8 3 7],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.bt11=uicontrol( 'Parent', g.b8c.t3c.bc.bt3, 'String', 'Pos 11','UserData',[8 3 11],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.bt15=uicontrol( 'Parent', g.b8c.t3c.bc.bt3, 'String', 'Pos 15','UserData',[8 3 15],'Callback',@RI_Calibration );
    
    g.b8c.t3c.bc.bt4 = uix.HButtonBox( 'Parent', g.b8c.t3c.b, 'Padding', 5 );
    g.b8c.t3c.bc.btc.bt4=uicontrol( 'Parent', g.b8c.t3c.bc.bt4, 'String', 'Pos 4','UserData',[8 3 4],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.bt8=uicontrol( 'Parent', g.b8c.t3c.bc.bt4, 'String', 'Pos 8','UserData',[8 3 8],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.bt12=uicontrol( 'Parent', g.b8c.t3c.bc.bt4, 'String', 'Pos 12','UserData',[8 3 12],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.bt16=uicontrol( 'Parent', g.b8c.t3c.bc.bt4, 'String', 'Pos 16','UserData',[8 3 16],'Callback',@RI_Calibration );
    
    g.b8c.t3c.bc.bt5 = uix.HButtonBox( 'Parent', g.b8c.t3c.b, 'Padding', 5 );
    g.b8c.t3c.bc.btc.b33a=uicontrol( 'Parent', g.b8c.t3c.bc.bt5,'Style','text', 'String', 'FUA');
    g.b8c.t3c.bc.btc.b33=uicontrol( 'Parent', g.b8c.t3c.bc.bt5, 'String', 'Measure','UserData',[8 3 33],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.b31=uicontrol( 'Parent', g.b8c.t3c.bc.bt5, 'String', 'Save','UserData',[8 3 31],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.b32=uicontrol( 'Parent', g.b8c.t3c.bc.bt5, 'String', 'Load','UserData',[8 3 32],'Callback',@RI_Calibration );
    g.b8c.t3c.bc.btc.b34=uicontrol( 'Parent', g.b8c.t3c.bc.bt5, 'String', 'Verify','UserData',[8 3 34],'Callback',@RI_Calibration );
    
    g.b8c.t3c.bc.btc.b35=uicontrol( 'Parent', g.b8c.t3c.bc.bt5, 'String', 'Next','UserData',[8 3 35],'Callback',@RI_Calibration );
    
    g.ri.mode=1;
  
          
set( g.b8c.t3c.b, 'Heights', [-3 ones(1,7)*35] );


%% setup tab5
   %split layout 1 H 2 V
 
    g.b8c.t5c.a = uix.VBox( 'Parent', g.b8c.t5, 'Padding', 5 );
    g.b8c.t5c.p1 = uix.Panel( 'Parent', g.b8c.t5c.a, 'Padding', 5 );
    g.b8c.t5c.p2 = uix.Panel( 'Parent', g.b8c.t5c.a, 'Padding', 5 );
    set( g.b8c.t5c.a, 'Heights', [-4 -1] );
    g.b8c.t5c.b = uix.HBoxFlex( 'Parent', g.b8c.t5c.p1, 'Padding', 5 );
    g.b8c.t5c.bc.vb1 = uix.VBox( 'Parent', g.b8c.t5c.b, 'Padding', 5 );
    g.b8c.t5c.bc.vb2 = uix.VBox( 'Parent', g.b8c.t5c.b, 'Padding', 5 );
    set( g.b8c.t5c.b, 'Widths', [-1 -3] );
    % load report header
    T=readtable('./configuration/RIreportheader.xlsx');
    [mm nn]=size(T);
    %Create inputs
    for i=1:mm
        str1=['g.b8c.t5c.tx' num2str(i) '=uicontrol( ''Style'',''text'',''Parent'', g.b8c.t5c.bc.vb1, ''String'', ''' ...
             T.name{i} ''');'];eval(str1);
        %remove the return replace it with space
        T.value{i} = regexprep(T.value{i},'\n',' ');
        str2=['g.b8c.t5c.rx' num2str(i) '=uicontrol( ''Style'',''edit'',''Parent'', g.b8c.t5c.bc.vb2, ''String'', ''' ...
             T.value{i} ''');'];eval(str2);
    end
    %make the last input multiple line possible
    str1=['g.b8c.t5c.rx' num2str(mm) '.Min=0;']; eval(str1);
    str2=['g.b8c.t5c.rx' num2str(mm) '.Max=2;']; eval(str2);  % This is the key to multiline edits.            
    uix.Empty('Parent', g.b8c.t5c.bc.vb2 );
    uix.Empty('Parent', g.b8c.t5c.bc.vb1 );
    % assign buttons
    g.b8c.t5c.bt1=uicontrol( 'Parent', g.b8c.t5c.bc.vb1, 'String', 'Create Report', 'Callback',@fcreate,'UserData',[8 5 1]);
    g.b8c.t5c.bt2=uicontrol( 'Parent', g.b8c.t5c.bc.vb1, 'String', 'Save', 'Callback',@fsave_as_header,'UserData',[8 5 2]);
    g.b8c.t5c.bt3=uicontrol( 'Parent', g.b8c.t5c.bc.vb1, 'String', 'Load', 'Callback', @floadheader,'UserData',[8 5 3]);
    set( g.b8c.t5c.bc.vb1, 'Heights', 30*ones(1,mm+4) );
    set( g.b8c.t5c.bc.vb2, 'Heights', [30*ones(1,mm-1) 150 30] );
   
     % setup p2
     g.b8c.t5c.bc.bt = uix.HButtonBox( 'Parent', g.b8c.t5c.p2, 'Padding', 5 );
%      g.b8c.t5c.bc.chk1=uicontrol( 'Style','checkbox','Parent', g.b8c.t5c.bc.bt, 'String', 'Scan H','Value',1 );
%      g.b8c.t5c.bc.chk2=uicontrol( 'Style','checkbox','Parent', g.b8c.t5c.bc.bt, 'String', 'Scan V','Value',1 );
%      g.b8c.t5c.bc.chk3=uicontrol( 'Style','checkbox','Parent', g.b8c.t5c.bc.bt, 'String', '3D H','Value',0 );
%      g.b8c.t5c.bc.chk4=uicontrol( 'Style','checkbox','Parent', g.b8c.t5c.bc.bt, 'String', '3D V', 'Value',0 );
     g.b8c.t5c.bc.chk5=uicontrol( 'Style','checkbox','Parent', g.b8c.t5c.bc.bt, 'String', 'Image 1','Value',0 ,'Callback',@load_setup_image,'UserData',[8 5 11]);
     g.b8c.t5c.bc.chk6=uicontrol( 'Style','checkbox','Parent', g.b8c.t5c.bc.bt, 'String', 'Image 2','Value',0 ,'Callback',@load_setup_image,'UserData',[8 5 12]);
     g.b8c.t5c.bc.chk7=uicontrol( 'Style','checkbox','Parent', g.b8c.t5c.bc.bt, 'String', 'Image 3','Value',0 ,'Callback',@load_setup_image,'UserData',[8 5 13]);
     g.b8c.t5c.bc.chk8=uicontrol( 'Style','checkbox','Parent', g.b8c.t5c.bc.bt, 'String', 'Image 4','Value',0 ,'Callback',@load_setup_image,'UserData',[8 5 14]);
     g.b8c.t5c.bc.chk9=uicontrol( 'Style','checkbox','Parent', g.b8c.t5c.bc.bt, 'String', 'Image 5','Value',0 ,'Callback',@load_setup_image,'UserData',[8 5 15]);
end
function fb9(source,callbackdata)
global g
global d
   % initialize dataOBJ
        d=dataObj;

%% setup  button 9
%% setup  panel 2
     %create tabs
             g.b5c=[];delete(g.p2.Children(:));
              g.b9c.t1 = uix.Panel( 'Parent', g.p2, 'Title', 'Please Inti ', 'Padding', 5 );
             g.b9c.t5 = uix.Panel( 'Parent', g.p2, 'Title', 'Report', 'Padding', 5 );
             g.p2.TabTitles = {'Setup','Report'};
g.p2.Selection = 1;

%% setup tab 1 
   
% create 1Hbox 2vbox 
    g.b9c.t1c.b = uix.HBoxFlex( 'Parent', g.b9c.t1, 'Padding', 5 );
    g.b9c.t1c.bc.vb1 = uix.VBox( 'Parent', g.b9c.t1c.b, 'Padding', 5 );
    g.b9c.t1c.bc.vb2 = uix.VBox( 'Parent', g.b9c.t1c.b, 'Padding', 5 );
    set( g.b9c.t1c.b, 'Widths', [-1 -2] );
    %load configuration file
    
    T=readtable('./configuration/EFTconfiguration.xlsx');
    g.T=T;
    [mm nn]=size(T);
    % creat uicontrols inputs
    
    for i=1:mm
        str1=['g.b9c.t1c.tx' num2str(i) '=uicontrol( ''Style'',''text'',''Parent'', g.b9c.t1c.bc.vb1, ''String'', ''' ...
             T.name{i} ''');'];eval(str1);  
        str2=['g.b9c.t1c.rx' num2str(i) '=uicontrol( ''Style'',''edit'',''Parent'', g.b9c.t1c.bc.vb2, ''String'', ''' ...
             T.value{i} ''');'];eval(str2);
    end
    uix.Empty('Parent', g.b9c.t1c.bc.vb2 );
    uix.Empty('Parent', g.b9c.t1c.bc.vb1 );
     
    % load picture line 1
     g.b9c.t5c.bc.bt = uix.HButtonBox( 'Parent', g.b9c.t1c.bc.vb2, 'Padding', 5 );
     g.b9c.t5c.bc.chk5=uicontrol( 'Style','checkbox','Parent', g.b9c.t5c.bc.bt, 'String', 'Image 1','Value',0 ,'Callback',@load_setup_image,'UserData',[9 1 11]);
     g.b9c.t5c.bc.chk6=uicontrol( 'Style','checkbox','Parent', g.b9c.t5c.bc.bt, 'String', 'Image 2','Value',0 ,'Callback',@load_setup_image,'UserData',[9 1 12]);
     g.b9c.t5c.bc.chk7=uicontrol( 'Style','checkbox','Parent', g.b9c.t5c.bc.bt, 'String', 'Image 3','Value',0 ,'Callback',@load_setup_image,'UserData',[9 1 13]);
     g.b9c.t5c.bc.chk8=uicontrol( 'Style','checkbox','Parent', g.b9c.t5c.bc.bt, 'String', 'Image 4','Value',0 ,'Callback',@load_setup_image,'UserData',[9 1 14]);
     g.b9c.t5c.bc.chk9=uicontrol( 'Style','checkbox','Parent', g.b9c.t5c.bc.bt, 'String', 'Image 5','Value',0 ,'Callback',@load_setup_image,'UserData',[9 1 15]);
 
     
    
    %creat buttons %tmp9
    g.b9c.t1c.bt1=uicontrol( 'Parent', g.b9c.t1c.bc.vb1, 'String', 'Next', 'Callback',@fconnect,'UserData',[9 1 1]);
    g.b9c.t1c.bt2=uicontrol( 'Parent', g.b9c.t1c.bc.vb1, 'String', 'Save', 'Callback',@fsaveconfig,'UserData',[9 1 2]);
    g.b9c.t1c.bt3=uicontrol( 'Parent', g.b9c.t1c.bc.vb1, 'String', 'Load', 'Callback', @floadconfig,'UserData',[9 1 3]);
    %creat status 
    g.b9c.t1c.txstatus=uicontrol( 'Style','text','Parent', g.b9c.t1c.bc.vb2, 'String', '' );
    %format the layout
    set( g.b9c.t1c.bc.vb1, 'Heights', 30*ones(1,mm+4) );
    set( g.b9c.t1c.bc.vb2, 'Heights', 30*ones(1,mm+3) );
    



  
%% setup tab2 removed

%% setup tab5

  %split layout 1 H 2 V
 
    g.b9c.t5c.a = uix.VBox( 'Parent', g.b9c.t5, 'Padding', 5 );
    g.b9c.t5c.p1 = uix.Panel( 'Parent', g.b9c.t5c.a, 'Padding', 5 );
    g.b9c.t5c.p2 = uix.Panel( 'Parent', g.b9c.t5c.a, 'Padding', 5 );
    set( g.b9c.t5c.a, 'Heights', [-4 -1] );
    g.b9c.t5c.b = uix.HBoxFlex( 'Parent', g.b9c.t5c.p1, 'Padding', 5 );
    g.b9c.t5c.bc.vb1 = uix.VBox( 'Parent', g.b9c.t5c.b, 'Padding', 5 );
    g.b9c.t5c.bc.vb2 = uix.VBox( 'Parent', g.b9c.t5c.b, 'Padding', 5 );
    set( g.b9c.t5c.b, 'Widths', [-1 -3] );
    % load report header
    T=readtable('./configuration/EFTreportheader.xlsx');
    [mm nn]=size(T);
    %Create inputs
    for i=1:mm
        str1=['g.b9c.t5c.tx' num2str(i) '=uicontrol( ''Style'',''text'',''Parent'', g.b9c.t5c.bc.vb1, ''String'', ''' ...
             T.name{i} ''');'];eval(str1);
        %remove the return replace it with space
        T.value{i} = regexprep(T.value{i},'\n',' ');
        str2=['g.b9c.t5c.rx' num2str(i) '=uicontrol( ''Style'',''edit'',''Parent'', g.b9c.t5c.bc.vb2, ''String'', ''' ...
             T.value{i} ''');'];eval(str2);
    end
    %make the last input multiple line possible
    str1=['g.b9c.t5c.rx' num2str(mm) '.Min=0;']; eval(str1);
    str2=['g.b9c.t5c.rx' num2str(mm) '.Max=2;']; eval(str2);  % This is the key to multiline edits.            
    uix.Empty('Parent', g.b9c.t5c.bc.vb2 );
    uix.Empty('Parent', g.b9c.t5c.bc.vb1 );
    % assign buttons tmp9
    g.b9c.t5c.bt1=uicontrol( 'Parent', g.b9c.t5c.bc.vb1, 'String', 'Create Report', 'Callback',@fcreate,'UserData',[9 5 1]);
    g.b9c.t5c.bt2=uicontrol( 'Parent', g.b9c.t5c.bc.vb1, 'String', 'Save', 'Callback',@fsave_as_header,'UserData',[9 5 2]);
    g.b9c.t5c.bt3=uicontrol( 'Parent', g.b9c.t5c.bc.vb1, 'String', 'Load', 'Callback', @floadheader,'UserData',[9 5 3]);
    set( g.b9c.t5c.bc.vb1, 'Heights', 30*ones(1,mm+4) );
    set( g.b9c.t5c.bc.vb2, 'Heights', [30*ones(1,mm-1) 150 30] );
   
     % setup p2
     

     
     
end

function fb5(source,callbackdata)
global g
global d
   % initialize dataOBJ
        d=dataObj;
        g.ESD_img=[];
        g.ESD_f=[]; % figure to holde ESD imag
        g.esd.num=0;
%% setup  button 5
%% setup  panel 2
     %create tabs
             g.b5c=[];delete(g.p2.Children(:));
              g.b5c.t1 = uix.Panel( 'Parent', g.p2, 'Title', 'Please Inti ', 'Padding', 5 );
             g.b5c.t2 = uix.Panel( 'Parent', g.p2, 'Title', 'Air Discharge', 'Padding', 5 );
          %   g.b5c.t3 = uix.Panel( 'Parent', g.p2, 'Title', 'Contact discharge', 'Padding', 5 );
           %  g.b5c.t4 = uix.Panel( 'Parent', g.p2, 'Title', 'Quasi-peak Measurement', 'Padding', 5 );
             g.b5c.t5 = uix.Panel( 'Parent', g.p2, 'Title', 'Report', 'Padding', 5 );
             g.p2.TabTitles = {'Setup','Test ','Report'};
g.p2.Selection = 1;

%% setup tab 1 
   
% create 1Hbox 2vbox 
    g.b5c.t1c.b = uix.HBoxFlex( 'Parent', g.b5c.t1, 'Padding', 5 );
    g.b5c.t1c.bc.vb1 = uix.VBox( 'Parent', g.b5c.t1c.b, 'Padding', 5 );
    g.b5c.t1c.bc.vb2 = uix.VBox( 'Parent', g.b5c.t1c.b, 'Padding', 5 );
    set( g.b5c.t1c.b, 'Widths', [-1 -2] );
    %load configuration file
    
    T=readtable('./configuration/ESDconfiguration.xlsx');
    g.T=T;
    [mm nn]=size(T);
    % creat uicontrols inputs
    
    for i=1:mm
        str1=['g.b5c.t1c.tx' num2str(i) '=uicontrol( ''Style'',''text'',''Parent'', g.b5c.t1c.bc.vb1, ''String'', ''' ...
             T.name{i} ''');'];eval(str1);  
        str2=['g.b5c.t1c.rx' num2str(i) '=uicontrol( ''Style'',''edit'',''Parent'', g.b5c.t1c.bc.vb2, ''String'', ''' ...
             T.value{i} ''');'];eval(str2);
    end
    uix.Empty('Parent', g.b5c.t1c.bc.vb2 );
    uix.Empty('Parent', g.b5c.t1c.bc.vb1 );
        g.b5c.t2c.b = uix.VBoxFlex( 'Parent', g.b5c.t2, 'Padding', 5 );
    % load picture line 1
     g.b5c.t5c.bc.bt = uix.HButtonBox( 'Parent', g.b5c.t1c.bc.vb2, 'Padding', 5 );
     g.b5c.t5c.bc.chk5=uicontrol( 'Style','checkbox','Parent', g.b5c.t5c.bc.bt, 'String', 'Image 1','Value',0 ,'Callback',@load_setup_image,'UserData',[5 1 11]);
     g.b5c.t5c.bc.chk6=uicontrol( 'Style','checkbox','Parent', g.b5c.t5c.bc.bt, 'String', 'Image 2','Value',0 ,'Callback',@load_setup_image,'UserData',[5 1 12]);
     g.b5c.t5c.bc.chk7=uicontrol( 'Style','checkbox','Parent', g.b5c.t5c.bc.bt, 'String', 'Image 3','Value',0 ,'Callback',@load_setup_image,'UserData',[5 1 13]);
     g.b5c.t5c.bc.chk8=uicontrol( 'Style','checkbox','Parent', g.b5c.t5c.bc.bt, 'String', 'Image 4','Value',0 ,'Callback',@load_setup_image,'UserData',[5 1 14]);
     g.b5c.t5c.bc.chk9=uicontrol( 'Style','checkbox','Parent', g.b5c.t5c.bc.bt, 'String', 'Image 5','Value',0 ,'Callback',@load_setup_image,'UserData',[5 1 15]);
 
     
    
    %creat buttons 
    g.b5c.t1c.bt1=uicontrol( 'Parent', g.b5c.t1c.bc.vb1, 'String', 'Connect', 'Callback',@fconnect,'UserData',[5 1 1]);
    g.b5c.t1c.bt2=uicontrol( 'Parent', g.b5c.t1c.bc.vb1, 'String', 'Save', 'Callback',@fsaveconfig,'UserData',[5 1 2]);
    g.b5c.t1c.bt3=uicontrol( 'Parent', g.b5c.t1c.bc.vb1, 'String', 'Load', 'Callback', @floadconfig,'UserData',[5 1 3]);
    %creat status 
    g.b5c.t1c.txstatus=uicontrol( 'Style','text','Parent', g.b5c.t1c.bc.vb2, 'String', '' );
    %format the layout
    set( g.b5c.t1c.bc.vb1, 'Heights', 30*ones(1,mm+4) );
    set( g.b5c.t1c.bc.vb2, 'Heights', 30*ones(1,mm+3) );
    



  
%% setup tab2 scan
  % line 1
    g.b5c.t2c.bc.btc.bt12=uicontrol( 'Parent', g.b5c.t2c.b, 'Style','popupmenu','String', ...
         {'No Picture',...
          'Picture 1',...
          'Picture 2',...
          'Picture 3'},'UserData',[5 2 12],'Callback',@ESD_Measure );
      

    % ling 2 picture -1
   % g.b5c.t2c.bc.ax1=axes( 'Parent', g.b5c.t2c.b,'UserData',[5 2 0]);
    % line 3 table -1
     g.b5c.t2c.bc.btc.tb1=uitable( 'Parent', g.b5c.t2c.b,'Tag','tb51','CellSelectionCallback',@(src,evnt)set(src,'UserData',evnt.Indices));
         g.b5c.t2c.bc.btc.tb1.ColumnName={'Discharge','Location','2KV','4KV','6KV','8KV',...
               'Comments: Describe locations anomalies // list reference numbers and use the Additional Comments Table if needed'}    ;
           g.b5c.t2c.bc.btc.tb1.Units='normalized';
           g.b5c.t2c.bc.btc.tb1.ColumnWidth={200 'auto'};
         
             tb1={'Contact Discharge','Horizontal Plane','A','A','A','A','Pass.-Normal performance within specified limits.'};
             tb2={'Contact Discharge','Vertical Plane','A','A','A','A','Pass.-Normal performance within specified limits.'};
           g.b5c.t2c.bc.btc.tb1.Data=[tb1;tb2];
            % line 3 table -1
       g.esd.tb=g.b5c.t2c.bc.btc.tb1;
     g.b5c.t2c.bc.btc.tb2=uitable( 'Parent', g.b5c.t2c.b,'Tag','tb52','CellSelectionCallback',@(src,evnt)set(src,'UserData',evnt.Indices));
           g.b5c.t2c.bc.btc.tb2.ColumnName={'Discharge','Location','2KV','4KV','6KV','8KV','10KV','12KV','15KV',...
               'Comments: Describe locations anomalies // list reference numbers and use the Additional Comments Table if needed'}     ;               
            g.b5c.t2c.bc.btc.tb2.Units='normalized';
           g.b5c.t2c.bc.btc.tb2.ColumnWidth={200 'auto'};
           
    % line 4 h button 35
    g.b5c.t2c.bc.bt = uix.HButtonBox( 'Parent', g.b5c.t2c.b, 'Padding', 5 );
    % line 5 Hbutton 35
    g.b5c.t2c.bc.btc.bt1=uicontrol( 'Style','radiobutton','Parent', g.b5c.t2c.bc.bt, 'String', 'Contact Discharge','Value',1,'UserData',[5 2 1],'Callback',@ESD_Measure );
    g.b5c.t2c.bc.btc.bt2=uicontrol( 'Style','radiobutton','Parent', g.b5c.t2c.bc.bt, 'String', 'Air Discharge','UserData',[5 2 2],'Callback',@ESD_Measure );
     % line 5 Hbutton 35
    g.b5c.t2c.bc.bt1 = uix.HButtonBox( 'Parent', g.b5c.t2c.b, 'Padding', 5 );
  
    g.b5c.t2c.bc.btc.bt8=uicontrol( 'Parent', g.b5c.t2c.bc.bt1, 'String', 'Mark Current Frequency','UserData',[5 2 8],'Callback',@ESD_Measure );
    g.b5c.t2c.bc.btc.bt3=uicontrol( 'Parent', g.b5c.t2c.bc.bt1, 'String', 'Load','UserData',[5 2 3],'Callback',@ESD_Measure );
    g.b5c.t2c.bc.btc.bt4=uicontrol( 'Parent', g.b5c.t2c.bc.bt1, 'String', 'Save','UserData',[5 2 4],'Callback',@ESD_Measure );
    g.b5c.t2c.bc.btc.bt41=uicontrol( 'Parent', g.b5c.t2c.bc.bt1, 'String', 'bk1','UserData',[5 2 41],'Callback',@ESD_Measure );
    g.b5c.t2c.bc.btc.bt5=uicontrol( 'Parent', g.b5c.t2c.bc.bt1, 'String', 'bk2','UserData',[5 2 5],'Callback',@ESD_Measure );
   
     
    
     g.b5c.t2c.bc.btc.bt11=uicontrol( 'Parent', g.b5c.t2c.b, 'Style','popupmenu','String', ...
         {'A. Pass -Normal performance within specified limits',...
          'B. Pass -Temporary degradation self recoverable',...
          'C. Pass -Temporary interruption. requires operator intervention',...
          'D. Fail -Not recoverable. Components hardware failure',...
          'N/A'},'UserData',[5 2 11],'Callback',@ESD_Measure );
   %  g.b5c.t2c.bc.btc.bt12=uicontrol( 'Parent', g.b5c.t2c.b, 'Style','text','String', 'Detaled comments on selected frequency','UserData',[4 2 12],'Callback',@CI_Measure );
%     g.b5c.t2c.bc.btc.bt13=uicontrol( 'Parent', g.b5c.t2c.b, 'Style','edit','String', 'None','UserData',[4 2 13],'Callback',@CI_Measure );
 
g.b5c.t2c.bc.btc.bt14=uicontrol( 'Parent', g.b5c.t2c.b,'String', 'Next','UserData',[5 2 14],'Callback',@ESD_Measure );
          
set( g.b5c.t2c.b, 'Heights', [35 -1 -1 35 35 35 35] );
     

%% setup tab5

  %split layout 1 H 2 V
 
    g.b5c.t5c.a = uix.VBox( 'Parent', g.b5c.t5, 'Padding', 5 );
    g.b5c.t5c.p1 = uix.Panel( 'Parent', g.b5c.t5c.a, 'Padding', 5 );
    g.b5c.t5c.p2 = uix.Panel( 'Parent', g.b5c.t5c.a, 'Padding', 5 );
    set( g.b5c.t5c.a, 'Heights', [-4 -1] );
    g.b5c.t5c.b = uix.HBoxFlex( 'Parent', g.b5c.t5c.p1, 'Padding', 5 );
    g.b5c.t5c.bc.vb1 = uix.VBox( 'Parent', g.b5c.t5c.b, 'Padding', 5 );
    g.b5c.t5c.bc.vb2 = uix.VBox( 'Parent', g.b5c.t5c.b, 'Padding', 5 );
    set( g.b5c.t5c.b, 'Widths', [-1 -3] );
    % load report header
    T=readtable('./configuration/ESDreportheader.xlsx');
    [mm nn]=size(T);
    %Create inputs
    for i=1:mm
        str1=['g.b5c.t5c.tx' num2str(i) '=uicontrol( ''Style'',''text'',''Parent'', g.b5c.t5c.bc.vb1, ''String'', ''' ...
             T.name{i} ''');'];eval(str1);
        %remove the return replace it with space
        T.value{i} = regexprep(T.value{i},'\n',' ');
        str2=['g.b5c.t5c.rx' num2str(i) '=uicontrol( ''Style'',''edit'',''Parent'', g.b5c.t5c.bc.vb2, ''String'', ''' ...
             T.value{i} ''');'];eval(str2);
    end
    %make the last input multiple line possible
    str1=['g.b5c.t5c.rx' num2str(mm) '.Min=0;']; eval(str1);
    str2=['g.b5c.t5c.rx' num2str(mm) '.Max=2;']; eval(str2);  % This is the key to multiline edits.            
    uix.Empty('Parent', g.b5c.t5c.bc.vb2 );
    uix.Empty('Parent', g.b5c.t5c.bc.vb1 );
    % assign buttons
    g.b5c.t5c.bt1=uicontrol( 'Parent', g.b5c.t5c.bc.vb1, 'String', 'Create Report', 'Callback',@fcreate,'UserData',[5 5 1]);
    g.b5c.t5c.bt2=uicontrol( 'Parent', g.b5c.t5c.bc.vb1, 'String', 'Save', 'Callback',@fsave_as_header,'UserData',[5 5 2]);
    g.b5c.t5c.bt3=uicontrol( 'Parent', g.b5c.t5c.bc.vb1, 'String', 'Load', 'Callback', @floadheader,'UserData',[5 5 3]);
    set( g.b5c.t5c.bc.vb1, 'Heights', 30*ones(1,mm+4) );
    set( g.b5c.t5c.bc.vb2, 'Heights', [30*ones(1,mm-1) 150 30] );
   
     % setup p2
     

     
     
end

function fb7(source,callbackdata) % NSA
global g
g.fig_polar_scan=[];
%% setup  button 3
%% setup  panel 2
     %create tabs
             g.b7c=[];delete(g.p2.Children(:));
             g.b7c.t1 = uix.Panel( 'Parent', g.p2, 'Title', 'Please Inti ', 'Padding', 5 );
             g.b7c.t2 = uix.Panel( 'Parent', g.p2, 'Title', 'Quick Scan using Peak detector Measurement', 'Padding', 5 );
             g.b7c.t3 = uix.Panel( 'Parent', g.p2, 'Title', 'Search peaks and data analysis', 'Padding', 5 );
             g.b7c.t4 = uix.Panel( 'Parent', g.p2, 'Title', 'Quasi-peak Measurement', 'Padding', 5 );
             g.b7c.t5 = uix.Panel( 'Parent', g.p2, 'Title', 'Report', 'Padding', 5 );
             g.p2.TabTitles = {'Setup ', 'Scan','Search','Measure','Report'};
g.p2.Selection = 1;

%% setup tab 1 
    % create 1Hbox 2vbox 
    g.b7c.t1c.b = uix.HBoxFlex( 'Parent', g.b7c.t1, 'Padding', 5 );
    g.b7c.t1c.bc.vb1 = uix.VBox( 'Parent', g.b7c.t1c.b, 'Padding', 5 );
    g.b7c.t1c.bc.vb2 = uix.VBox( 'Parent', g.b7c.t1c.b, 'Padding', 5 );
    set( g.b7c.t1c.b, 'Widths', [-1 -2] );
    %load configuration file
    
    T=readtable('./configuration/NSAconfiguration.xlsx');
    g.T=T;
    [mm nn]=size(T);
    % creat uicontrols inputs
    
    for i=1:mm
        str1=['g.b7c.t1c.tx' num2str(i) '=uicontrol( ''Style'',''text'',''Parent'', g.b7c.t1c.bc.vb1, ''String'', ''' ...
             T.name{i} ''');'];eval(str1);  
        str2=['g.b7c.t1c.rx' num2str(i) '=uicontrol( ''Style'',''edit'',''Parent'', g.b7c.t1c.bc.vb2, ''String'', ''' ...
             T.value{i} ''');'];eval(str2);
    end
    uix.Empty('Parent', g.b7c.t1c.bc.vb2 );
    uix.Empty('Parent', g.b7c.t1c.bc.vb1 );
    
    %creat buttons 
    g.b7c.t1c.bt1=uicontrol( 'Parent', g.b7c.t1c.bc.vb1, 'String', 'Connect', 'Callback',@fconnect,'UserData',[7 1 1]);
    g.b7c.t1c.bt2=uicontrol( 'Parent', g.b7c.t1c.bc.vb1, 'String', 'Save', 'Callback',@fsaveconfig,'UserData',[7 1 2]);
    g.b7c.t1c.bt3=uicontrol( 'Parent', g.b7c.t1c.bc.vb1, 'String', 'Load', 'Callback', @floadconfig,'UserData',[7 1 3]);
    %creat status 
    g.b7c.t1c.txstatus=uicontrol( 'Style','text','Parent', g.b7c.t1c.bc.vb2, 'String', '' );
    %format the layout
    set( g.b7c.t1c.bc.vb1, 'Heights', 30*ones(1,mm+4) );
    set( g.b7c.t1c.bc.vb2, 'Heights', 30*ones(1,mm+2) );
  
%% setup tab2 scan

    g.b7c.t2c.b = uix.VBoxFlex( 'Parent', g.b7c.t2, 'Padding', 5 );
    g.b7c.t2c.bc.c=uicontainer('Parent',g.b7c.t2c.b);
    g.b7c.t2c.bc.ax1=axes( 'Parent', g.b7c.t2c.bc.c,'UserData',[7 2 0]);
    %g.b7c.t2c.bc.ax2=axes( 'Parent', g.b7c.t2c.bc.c,'UserData',[7 2 1]);
    %set(g.b7c.t2c.bc.c, 'Heights', [-1 -1] );
    g.b7c.t2c.bc.bt = uix.HButtonBox( 'Parent', g.b7c.t2c.b, 'Padding', 5 );
    g.b7c.t2c.bc.btc.bx1=uicontrol( 'Style','checkbox','Parent', g.b7c.t2c.bc.bt, 'String', 'Horizontal','Value',1 );
    g.b7c.t2c.bc.btc.bx2=uicontrol('Style','checkbox', 'Parent', g.b7c.t2c.bc.bt, 'String', 'Vertical','Value',1 );
    g.b7c.t2c.bc.btc.bt1=uicontrol( 'Parent', g.b7c.t2c.bc.bt, 'String', 'HScan','UserData',[7 2 1] ,'Callback',@Bt_NSA);
    g.b7c.t2c.bc.btc.bt2=uicontrol( 'Parent', g.b7c.t2c.bc.bt, 'String', 'VScan','UserData',[7 2 2] ,'Callback',@Bt_NSA);
    g.b7c.t2c.bc.btc.bt3=uicontrol( 'Parent', g.b7c.t2c.bc.bt, 'String', 'SystemLoss','UserData',[7 2 3] ,'Callback',@Bt_NSA);
    g.b7c.t2c.bc.btc.bt4=uicontrol( 'Parent', g.b7c.t2c.bc.bt, 'String', 'NSACalculation','UserData',[7 2 4],'Callback',@Bt_NSA);
     g.b7c.t2c.bc.btc.bt5=uicontrol( 'Parent', g.b7c.t2c.bc.bt, 'String', 'DataAnalysis','UserData',[7 2 5],'Callback',@Bt_NSA);
    g.b7c.t2c.bc.btc.bt6=uicontrol( 'Parent', g.b7c.t2c.bc.bt, 'String', 'Resize','UserData',[7 2 6],'Callback',@Bt_NSA);
    g.b7c.t2c.bc.btc.bt7=uicontrol( 'Parent', g.b7c.t2c.bc.bt, 'String', 'Next','UserData',[7 2 7],'Callback',@Bt_Next );

set( g.b7c.t2c.b, 'Heights', [-1 35] )
%% setup tab3



    g.b7c.t3c.b = uix.VBox( 'Parent', g.b7c.t3, 'Padding', 5 );
    g.b7c.t3c.bc.c=uicontainer('Parent',g.b7c.t3c.b);
    g.b7c.t3c.bc.ax1=axes( 'Parent', g.b7c.t3c.bc.c);
    g.b7c.t3c.bc.bt = uix.HButtonBox( 'Parent', g.b7c.t3c.b, 'Padding', 5 );
    
    g.b7c.t3c.bc.btc.bt0=uicontrol( 'Style','text','Parent', g.b7c.t3c.bc.bt, 'String', 'Data' );
    g.b7c.t3c.bc.btc.bt1=uicontrol( 'Style','radiobutton','Parent', g.b7c.t3c.bc.bt, 'String', 'Hoziontal','Value',1,...
                                     'UserData',[7 3 1], 'Callback',@Bt_1_3_1_selectdata );
    g.b7c.t3c.bc.btc.bt2=uicontrol('Style','radiobutton', 'Parent', g.b7c.t3c.bc.bt, 'String', 'Vertical','Value',0,...
                                    'UserData',[7 3 2], 'Callback',@Bt_1_3_2_selectdata );
  
    
   % g.b7c.t3c.bc.btc.bt3=uicontrol( 'Parent', g.b7c.t3c.bc.bt, 'String', 'Search Peak' );
    uix.Empty(g.b7c.t3c.bc.bt)
   
    g.b7c.t3c.bc.btc.bt11=uicontrol( 'Parent', g.b7c.t3c.bc.bt, 'String', 'Polar Plot','UserData',[7 3 11],'Callback',@Bt_1_3_11_viewpolar );
    g.b7c.t3c.bc.btc.bt10=uicontrol( 'Parent', g.b7c.t3c.bc.bt, 'String', '3D plot' ,'UserData',[7 3 10],'Callback',@Bt_1_3_10_view3D );
    g.b7c.t3c.bc.btc.bt5=uicontrol( 'Style','text','Parent', g.b7c.t3c.bc.bt, 'String', ' View Angle:' );
    g.b7c.t3c.bc.btc.bt6=uicontrol( 'Style','text','Parent', g.b7c.t3c.bc.bt, 'String', ' R= ' );
    g.b7c.t3c.bc.btc.bt7=uicontrol( 'Style','edit','Parent', g.b7c.t3c.bc.bt, 'String', '45','UserData',[7 3 7],'Callback',@Bt_viewangle);
    g.b7c.t3c.bc.btc.bt8=uicontrol( 'Style','text','Parent', g.b7c.t3c.bc.bt, 'String', 'Theta=' );
    g.b7c.t3c.bc.btc.bt9=uicontrol( 'Style','edit','Parent', g.b7c.t3c.bc.bt, 'String', '45','UserData',[7 3 9],'Callback',@Bt_viewangle);
    g.b7c.t3c.bc.btc.bt4=uicontrol( 'Parent', g.b7c.t3c.bc.bt, 'String', 'Next' ,'UserData',[7 3 5],'Callback',@Bt_Next );

    set( g.b7c.t3c.b, 'Heights', [-1 35] )
%% setup tab4
    g.b7c.t4c.b = uix.VBoxFlex( 'Parent', g.b7c.t4, 'Padding', 5 );
    g.b7c.t4c.bc.c=uicontainer('Parent',g.b7c.t4c.b);
    g.b7c.t4c.bc.ax1=axes( 'Parent', g.b7c.t4c.bc.c);
    g.b7c.t4c.bc.bt = uix.HButtonBox( 'Parent', g.b7c.t4c.b, 'Padding', 5 );
    g.b7c.t4c.bc.tb1=uitable( 'Parent', g.b7c.t4c.b,'Tag','tb3','CellSelectionCallback',@(src,evnt)set(src,'UserData',evnt.Indices));
    g.b7c.t4c.bc.bt2 = uix.HButtonBox( 'Parent', g.b7c.t4c.b, 'Padding', 5 );
   
    g.b7c.t4c.bc.btc.bt1=uicontrol( 'Style','radiobutton','Parent', g.b7c.t4c.bc.bt, 'String', 'Horizontal','Value',0,...
                                   'UserData',[7 4 1], 'Callback',@Bt_1_3_1_selectdata );
    g.b7c.t4c.bc.btc.bt2=uicontrol('Style','radiobutton', 'Parent', g.b7c.t4c.bc.bt, 'String', 'Vertical','Value',1 ,...
                                   'UserData',[7 4 2], 'Callback',@Bt_1_3_2_selectdata );
    g.b7c.t4c.bc.btc.bt3=uicontrol( 'Parent', g.b7c.t4c.bc.bt, 'String', 'Search','UserData',[7 4 3],'Callback',@Bt_1_4_3_searchpeak );
    g.b7c.t4c.bc.btc.bt4=uicontrol( 'Parent', g.b7c.t4c.bc.bt, 'String', 'Filter','UserData',[7 4 4],'Callback',@Bt_1_4_4_searchpeak  );
    g.b7c.t4c.bc.btc.bt7=uicontrol( 'Style','text','Parent', g.b7c.t4c.bc.bt, 'String', 'RBW' );
    g.b7c.t4c.bc.btc.bt8=uicontrol( 'Style','edit','Parent', g.b7c.t4c.bc.bt, 'String', '10','UserData',[7 4 8],'Callback',@Bt_1_4_8_rbw );
    g.b7c.t4c.bc.btc.bt9=uicontrol( 'Style','text','Parent', g.b7c.t4c.bc.bt, 'String', 'MHz' );
    g.b7c.t4c.bc.btc.bt15=uicontrol( 'Parent', g.b7c.t4c.bc.bt, 'String', 'Save List' ,'UserData',[7 4 15],'Callback',@Bt_1_4_15_savelist);
    g.b7c.t4c.bc.btc.bt16=uicontrol( 'Parent', g.b7c.t4c.bc.bt, 'String', 'Load List','UserData',[7 4 16],'Callback',@Bt_1_4_16_loadlist );
    
    uix.Empty(g.b7c.t4c.bc.bt);
    g.b7c.t4c.bc.btc.bt13=uicontrol( 'Parent', g.b7c.t4c.bc.bt2, 'String', 'Re-Meas' ,'UserData',[7 4 13],'Callback',@Bt_1_4_13_measure);
    g.b7c.t4c.bc.btc.bt11=uicontrol( 'Parent', g.b7c.t4c.bc.bt2, 'String', 'Save Meas' ,'UserData',[7 4 11],'Callback',@Bt_1_4_11_save);
    g.b7c.t4c.bc.btc.bt12=uicontrol( 'Parent', g.b7c.t4c.bc.bt2, 'String', 'Load Meas','UserData',[7 4 12],'Callback',@Bt_1_4_12_load );
    g.b7c.t4c.bc.btc.bt14=uicontrol( 'Parent', g.b7c.t4c.bc.bt2, 'String', 'Next' ,'UserData',[7 4 5],'Callback',@Bt_Next);
    set( g.b7c.t4c.b, 'Heights', [-3 35 -1 35] )

%% setup tab5
     %split layout 1 H 2 V
    g.b7c.t5c.a = uix.VBox( 'Parent', g.b7c.t5, 'Padding', 5 );
    g.b7c.t5c.p1 = uix.Panel( 'Parent', g.b7c.t5c.a, 'Padding', 5 );
    g.b7c.t5c.p2 = uix.Panel( 'Parent', g.b7c.t5c.a, 'Padding', 5 );
    set( g.b7c.t5c.a, 'Heights', [-4 -1] );
    g.b7c.t5c.b = uix.HBoxFlex( 'Parent', g.b7c.t5c.p1, 'Padding', 5 );
    g.b7c.t5c.bc.vb1 = uix.VBox( 'Parent', g.b7c.t5c.b, 'Padding', 5 );
    g.b7c.t5c.bc.vb2 = uix.VBox( 'Parent', g.b7c.t5c.b, 'Padding', 5 );
    set( g.b7c.t5c.b, 'Widths', [-1 -3] );
    % load report header
    T=readtable('./configuration/NSAreportheader.xlsx');
    [mm nn]=size(T);
    %Create inputs
    for i=1:mm
        str1=['g.b7c.t5c.tx' num2str(i) '=uicontrol( ''Style'',''text'',''Parent'', g.b7c.t5c.bc.vb1, ''String'', ''' ...
             T.name{i} ''');'];eval(str1);
        %remove the return replace it with space
        T.value{i} = regexprep(T.value{i},'\n',' ');
        str2=['g.b7c.t5c.rx' num2str(i) '=uicontrol( ''Style'',''edit'',''Parent'', g.b7c.t5c.bc.vb2, ''String'', ''' ...
             T.value{i} ''');'];eval(str2);
    end
    %make the last input multiple line possible
    str1=['g.b7c.t5c.rx' num2str(mm) '.Min=0;']; eval(str1);
    str2=['g.b7c.t5c.rx' num2str(mm) '.Max=2;']; eval(str2);  % This is the key to multiline edits.            
    uix.Empty('Parent', g.b7c.t5c.bc.vb2 );
    uix.Empty('Parent', g.b7c.t5c.bc.vb1 );
    % assign buttons
    g.b7c.t5c.bt1=uicontrol( 'Parent', g.b7c.t5c.bc.vb1, 'String', 'Create Report', 'Callback',@fcreate,'UserData',[7 5 1]);
    g.b7c.t5c.bt2=uicontrol( 'Parent', g.b7c.t5c.bc.vb1, 'String', 'Save', 'Callback',@fsave_as_header,'UserData',[7 5 2]);
    g.b7c.t5c.bt3=uicontrol( 'Parent', g.b7c.t5c.bc.vb1, 'String', 'Load', 'Callback', @floadheader,'UserData',[7 5 3]);
    set( g.b7c.t5c.bc.vb1, 'Heights', 30*ones(1,mm+4) );
    set( g.b7c.t5c.bc.vb2, 'Heights', [30*ones(1,mm-1) 150 30] );
   
     % setup p2
     g.b7c.t5c.bc.bt = uix.HButtonBox( 'Parent', g.b7c.t5c.p2, 'Padding', 5 );
     g.b7c.t5c.bc.chk1=uicontrol( 'Style','checkbox','Parent', g.b7c.t5c.bc.bt, 'String', 'Scan H','Value',1 );
     g.b7c.t5c.bc.chk2=uicontrol( 'Style','checkbox','Parent', g.b7c.t5c.bc.bt, 'String', 'Scan V','Value',1 );
     g.b7c.t5c.bc.chk3=uicontrol( 'Style','checkbox','Parent', g.b7c.t5c.bc.bt, 'String', '3D H','Value',0 );
     g.b7c.t5c.bc.chk4=uicontrol( 'Style','checkbox','Parent', g.b7c.t5c.bc.bt, 'String', '3D V', 'Value',0 );
     g.b7c.t5c.bc.chk5=uicontrol( 'Style','checkbox','Parent', g.b7c.t5c.bc.bt, 'String', 'Image 1','Value',0 ,'Callback',@load_setup_image,'UserData',[3 5 11]);
     g.b7c.t5c.bc.chk6=uicontrol( 'Style','checkbox','Parent', g.b7c.t5c.bc.bt, 'String', 'Image 2','Value',0 ,'Callback',@load_setup_image,'UserData',[3 5 12]);
     g.b7c.t5c.bc.chk7=uicontrol( 'Style','checkbox','Parent', g.b7c.t5c.bc.bt, 'String', 'Image 3','Value',0 ,'Callback',@load_setup_image,'UserData',[3 5 13]);
     g.b7c.t5c.bc.chk8=uicontrol( 'Style','checkbox','Parent', g.b7c.t5c.bc.bt, 'String', 'Image 4','Value',0 ,'Callback',@load_setup_image,'UserData',[3 5 14]);
     g.b7c.t5c.bc.chk9=uicontrol( 'Style','checkbox','Parent', g.b7c.t5c.bc.bt, 'String', 'Image 5','Value',0 ,'Callback',@load_setup_image,'UserData',[3 5 15]);
    
end

function fb6(source,callbackdata)

  button = questdlg('Ready to quit?', ...
                            'Exit Dialog','Yes','No','No');
          switch button
            case 'Yes',
              disp('Exiting The program');
               clear all;
                close all;


            case 'No',
              quit cancel;
          end


end


function fconnect(source,callbackdata)
% RE connect
global g % GUI global varibles
global s % System control varibles. all hardware
global d % Data object.

%fcheck_cal_date(source,callbackdata)

ancher=source.UserData
switch ancher(1)
    case 1 %RE
        %create system object
        s=SystemObj; s.type='RE';
            list = {'Antenna 3142E SN:_00156974','Antenna 3142C	SN:_00075975'};
            [indx,tf] = listdlg('ListString',list,'PromptString',{'Select the Antenna used in the test setup',''}, 'SelectionMode','single');
            tmp=strsplit(list{indx});
            s.atn.IDN=strtrim(tmp{end});
            
        % clear exisitng open ports
             a=instrfind;
             for i=1:length(a)
              fclose(a(i));
             end
        try 

             amp.IDN='2443A04192';
             chamber.IDN='EMC0001';
            %initiaize systemOBJ
             s.sa=saObj;       s.sa.address=g.b1c.t1c.rx1.String; 
             s.sa.ini; s.sa.type=s.type;
             
             g.b1c.t1c.rx5.String=['SN:' s.sa.IDN ','];
             g.b1c.t1c.rx6.String=['SN:' amp.IDN ','];
             g.b1c.t1c.rx7.String=[s.atn.IDN ','];
             
             s.tt=ttObj;       str=g.b1c.t1c.rx2.String; s.tt.address=str2num(str(regexp(str,'\d'))); s.tt.ini;
             g.b1c.t1c.rx8.String=['SN:' s.tt.IDN ',']; 
             s.tw=twObj;       str=g.b1c.t1c.rx3.String; s.tw.address=str2num(str(regexp(str,'\d'))); s.tw.ini;
             g.b1c.t1c.rx9.String=['SN:' s.tw.IDN ',']; 
             g.b1c.t1c.rx10.String=['SN:' chamber.IDN ',']; 
             g.b1c.t1c.txstatus.String=[' RE system: SA status:', s.sa.status, ...
                                         '; Turntable status:',s.tt.status, ...
                                         '; Antenna tower status:',s.tw.status];
                                            
             %g.p2.Selection = 2;
             s.sa.configRE;
             while ~s.sa.opc               
             end
             
        catch ME
            
         msgbox('Unsuccessful open sa, tt or tw Please check address, connection, power and Matlab License at http://sam.cos.is.keysight.com/cgi-bin/central_license/elt_lic_status.rb?maxed_only=3&vendor=MLM&features=ALL&site=ALL&server=ALL&portathost=&custom_select=Use+above+selection&mels_rollup=yes&stage=2  and try again!')
        end
         fsaveconfig1(1)  
                
    case 2 %CE
           s=SystemObj; s.type='CE';
        % clear exisitng open ports
             a=instrfind;
             for i=1:length(a)
              fclose(a(i));
             end
             lp.IDN='CO8EI12720';
           
        list = {'EmCO LISN 4825/2 SN:_00130174','Rhode & Schwarz ESH2-Z5 SN:879675/018'};
        [indx,tf] = listdlg('ListString',list,'PromptString',{'Select the LISN used in the test setup',''}, 'SelectionMode','single');
        tmp=strsplit(list{indx});
        lisn.IDN=strtrim(tmp{end});
        
        try     
         s.sa=saObj;       s.sa.address=g.b2c.t1c.rx1.String; s.sa.ini; s.sa.type=s.type;
         g.b2c.t1c.rx3.String=[lisn.IDN ','];
         g.b2c.t1c.rx4.String=['SN:' s.sa.IDN ','];
         g.b2c.t1c.rx5.String=['SN:' lp.IDN ','];
         
         g.b2c.t1c.txstatus.String=[' CE system: SA status:', s.sa.status];
          
         s.sa.configCE;
         %g.p2.Selection = 2;
         while ~s.sa.opc               
         end
         %s.corrCE=csvread('./configuration/corrCE.txt');
        catch ME
            msgbox('Unsuccessful open: Could not open VISA object. Use INSTRHWINFO for a list of available configurations.')
        end
         fsaveconfig1(2)  
    case 3 %OATs
           s=SystemObj; s.type='OAT'
            list = {'Antenna 3142E SN:_00156974','Antenna 3142C	SN:_00075975'};
            [indx,tf] = listdlg('ListString',list,'PromptString',{'Select the Antenna used in the test setup',''}, 'SelectionMode','single');
            tmp=strsplit(list{indx});
            s.atn.IDN=strtrim(tmp{end});
           
        % clear exisitng open ports
             a=instrfind;
             for i=1:length(a)
              fclose(a(i));
             end
         s.TW_HIGH_LIMIT=385
         s.TW_LOW_LIMIT=105
        try  
         s.sa=saObj;       
         s.sa.address=g.b3c.t1c.rx1.String; 
         s.sa.ini;
         s.sa.type=s.type;
         s.tt=ttObj;       str=g.b3c.t1c.rx2.String; s.tt.address=str2num(str(regexp(str,'\d+')));s.tt.ini;
         s.tw=twObj;       str=g.b3c.t1c.rx3.String; s.tw.address=str2num(str(regexp(str,'\d+'))); s.tw.ini;
         amp.IDN='2944A09231';
         s.tt.IDN='MY00920250';
         s.tw.IDN='MY00150237';
         chamber.IDN='MY_OATS001';
         g.b3c.t1c.rx5.String=['SN:' s.sa.IDN ','];
         g.b3c.t1c.rx6.String=['SN:' amp.IDN ','];
         g.b3c.t1c.rx7.String=[s.atn.IDN ','];
         g.b3c.t1c.rx8.String=['SN:' s.tt.IDN ',']; 
         g.b3c.t1c.rx9.String=['SN:' s.tw.IDN ',']; 
         g.b3c.t1c.rx10.String=['SN:' chamber.IDN ',']; 
         g.b3c.t1c.rx13.String=['Colorado Springs TOF Hardware Test Center 10 Meter OATS chamber']; 
         
         g.b3c.t1c.txstatus.String=[' RE system: SA status:', s.sa.status, ...
                                     '; Turntable status:',s.tt.status, ...
                                     '; Antenna tower status:',s.tw.status];
         s.sa.configOATs;
         while ~s.sa.opc               
         end
    catch ME
            
         msgbox('Unsuccessful open sa, tt or tw Please check address, connection and power and try again!')
    end
        
         fsaveconfig1(3);
         
    case 4 %CI
          %create system object
        s=SystemObj;
        % clear exisitng open ports
             a=instrfind;
             for i=1:length(a)
              fclose(a(i));
             end
          try
        
        list = {'FCC FCC-801-M3-16, SN:48','Schaffner M316B, SN:13396'};
        [indx,tf] = listdlg('ListString',list,'PromptString',{'Select the CDN used in the test setup',''}, 'SelectionMode','single');
        tmp=strsplit(list{indx},',');
        cdn.IDN=strtrim(tmp{end});
        g.b4c.t1c.rx8.String=[cdn.IDN ','];
        cdn1.IDN='15169'; cdn2.IDN='57637';cdn3.IDN='RI0001';
        g.b4c.t1c.rx9.String=['SN:' cdn1.IDN ','];
        g.b4c.t1c.rx10.String=['SN:' cdn2.IDN ','];
        g.b4c.t1c.rx11.String=['SN:' cdn3.IDN ','];
        %initiaize systemOBJ
         s.lf=SiggenObj;    s.lf.type='lf';    str1=g.b4c.t1c.rx2.String; s.lf.address=str1;
         s.lf.ini;  pause(0.5);
         s.lf.AM_On;
         g.b4c.t1c.rx6.String=['SN:' s.lf.IDN ','];
         s.hf=SiggenObj;    s.hf.type='hf';   str1=g.b4c.t1c.rx3.String; s.hf.address=str1; 
         s.hf.ini;  pause(0.5);
         s.hf.AM_On;
         g.b4c.t1c.rx7.String=['SN:' s.hf.IDN ','];
         
         s.ps=PwrSensorObj;      s.ps.address=g.b4c.t1c.rx1.String; 
         s.ps.ini;      pause(0.5);
         g.b4c.t1c.rx5.String=['SN:' s.ps.IDN ','];
        % setup CI 
         s.configCI;
         g.b4c.t1c.txstatus.String=[' Conducted Emission system: Power Meter status:', s.ps.status, ...
                                     '; Low freq generator status:',s.lf.status, ...
                                     '; High freq generator status:',s.hf.status];
        % plot the base line
          CI_result=[150e3 3; 80e6 3];
          l1=plot(g.b4c.t2c.bc.ax1,CI_result(:,1)/1e6,CI_result(:,2),'r-' );
          l1.Tag='ref';
          hold on;
          l2=plot(g.b4c.t2c.bc.ax1,150e3/1e6,3,'b*' );
          l2.Tag='result';
          xlabel('Frequency (MHz)'); ylabel('Conducted Immunity Field strength 3V');
          xlim([150e3 80e6]./1e6);ylim([0 5]);
          grid on;
         % g.p2.Selection = 2;
           c=uicontextmenu(g.f);
           g.b4c.t2c.bc.btc.tb1.UIContextMenu=c;
           m1=uimenu(c,'Label','Delete the selected frequency','Callback',@CI_deletetableitem);
          catch ME
            msgbox('Unsuccessful open: Could not open VISA object. Use INSTRHWINFO for a list of available configurations.')
        end
            fsaveconfig1(4)  
    case 5 % ESD
        
        id=1;
            if ~isempty(g.ESD_f) 
                   for i=1:length(g.ESD_f)
                   set(g.ESD_f(i),'Visible','off');
                   end
             set( g.ESD_f(id),'Visible','on');
            end
          list = {'Keytek MZ-15/EC, SN:_0005295','Keytek MZ-15/EC, SN:_0102267'};
        [indx,tf] = listdlg('ListString',list,'PromptString',{'Select the ESD Gun used in the test setup',''}, 'SelectionMode','single');
        tmp=strsplit(list{indx},',');
        esd.IDN=strtrim(tmp{end});
        g.b5c.t1c.rx2.String=[esd.IDN ','];
        fsaveconfig1(5)  
           
         %g.p2.Selection = 2;
    case 7 %NSA
           s=SystemObj;
        % clear exisitng open ports
             a=instrfind;
             for i=1:length(a)
              fclose(a(i));
             end
             
         s.sa=saObj;       s.sa.address=g.b7c.t1c.rx1.String; s.sa.ini;
         s.tt=ttObj;       str=g.b7c.t1c.rx2.String; s.tt.address=str2num(str(regexp(str,'\d')));s.tt.ini;
         s.tw=twObj;       str=g.b7c.t1c.rx3.String; s.tw.address=str2num(str(regexp(str,'\d'))); s.tw.ini;
         s.hf=SiggenObj;   s.hf.type='hf';      str=g.b7c.t1c.rx4.String; s.hf.address=g.b7c.t1c.rx4.String;; s.hf.ini;
         g.b7c.t1c.txstatus.String=[' NSA system: SA status:', s.sa.status, ...
                                     '; Turntable status:',s.tt.status, ...
                                     '; Antenna tower status:',s.tw.status,...
                                     '; Signal Generator status:',s.hf.status];
         s.sa.configNSA;
         while ~s.sa.opc               
         end
      
    case 8 % RI
             %create system object
        s=SystemObj;
        tmp=g.b8c.t1c.rx15.String
        list = {'Antenna 3142E SN:_00156974','Antenna 3142C	SN:_00075975'};
        [indx,tf] = listdlg('ListString',list,'PromptString',{'Select the Antenna used in the test setup',''}, 'SelectionMode','single');
        tmp=strsplit(list{indx});
        s.atn.IDN=strtrim(tmp{end});
        % clear exisitng open ports
             a=instrfind;
             for i=1:length(a)
              fclose(a(i));
             end
       
         s.rfsw=RS232Obj; s.rfsw.address=g.b8c.t1c.rx4.String;        s.rfsw.ini;   pause(0.5);
          if ~strcmp(s.rfsw.status,'open')
           msgbox('RF switch is not ready, Please check the connection')
          end
         
         s.amp1=AmplifierObj;str=g.b8c.t1c.rx5.String;s.amp1.address=str2num(str(regexp(str,'\d')));  s.amp1.ini;   pause(0.5);
          if ~strcmp(s.amp1.status,'open')
           msgbox('Amplifier High band is not ready, Please check the connection')
          end
          
        
         s.ps1=PwrSensorObj;      s.ps1.address=g.b8c.t1c.rx1.String;    s.ps1.ini;    
         g.b8c.t1c.rx10.String=['SN:' s.ps1.IDN ',']; 
         
         s.ps2=PwrSensorObj;      s.ps2.address=g.b8c.t1c.rx2.String;    s.ps2.ini;    
         g.b8c.t1c.rx11.String=['SN:' s.ps2.IDN ',']; 
         
         g.b8c.t1c.rx12.String=['SN:1531,']; 
         g.b8c.t1c.rx13.String=['SN:131376,']; 
         
         s.hf=SiggenObj;    s.hf.type='hf';   str=g.b8c.t1c.rx3.String; s.hf.address=str;
         s.hf.ini;       
         g.b8c.t1c.rx14.String=['SN:' s.hf.IDN ','];  
         g.b8c.t1c.rx15.String=[s.atn.IDN ','];
         s.tt=ttObj;       str=g.b8c.t1c.rx6.String; s.tt.address=str2num(str(regexp(str,'\d'))); s.tt.ini;
         g.b8c.t1c.rx16.String=['SN:' s.tt.IDN ',']; 
         
         s.tw=twObj;       str=g.b8c.t1c.rx7.String; s.tw.address=str2num(str(regexp(str,'\d'))); s.tw.ini;
         g.b8c.t1c.rx17.String=['SN:' s.tw.IDN ','];
                  
         
         
      

       
         try
          s.fp=HI6005; s.fp.address=g.b8c.t1c.rx8.String;        s.fp.ini;   pause(0.5);
          if ~strcmp(s.fp.status,'open')
           msgbox('RF switch is not ready, Please check the connection')
          end
         catch err1
             disp('Warning: Filed Probe is not attached.')
             % no use if not in calibration process.
         end
         
        % setup RI 
         s.configRI;
         g.b8c.t1c.txstatus.String=[' Radiated Immunity Test system Status: Power Meter (low band) status:', s.ps1.status, ...
                                     '; Power Meter (high band) status:',s.ps2.status, ...
                                     '; signal generator status :',s.hf.status,...
                                     '; RF Switch status :',s.rfsw.status,...
                                     '; Power Amplifier status :',s.amp1.status];
        % plot the base line
          RI_result=[80e6 3; 6e9 3];
          l1=semilogx(g.b8c.t2c.bc.ax1,RI_result(:,1),RI_result(:,2),'r-' );
          l1.Tag='ref';
          hold(g.b8c.t2c.bc.ax1,'on'); 
          grid(g.b8c.t2c.bc.ax1,'on');
          xlabel(g.b8c.t2c.bc.ax1,'Frequency (Hz)'); ylabel(g.b8c.t2c.bc.ax1,'Radiated Immunity Field strength 3V/m');
          l2=semilogx(g.b8c.t2c.bc.ax1,80e6,3,'b*');
          l2.Tag='result';
         
          xlim(g.b8c.t2c.bc.ax1,[80e6 6e9]);ylim(g.b8c.t2c.bc.ax1,[0 5]);
         

           try
           fname=g.b8c.t1c.rx21.String;
           load(fname);
           d.ri.coeffs=coeffs;
           catch err
            msgbox('Invalid Calibration data! Please check the file path and name and reload again.')
           end
           
           s.RI_stop=0;
                             s.amp1.gain(-100); pause(1);                                 
                             s.amp1.off; pause(1);
                             s.hf.amp(-100);s.hf.On;
                             s.tw.sk(110);
             fsaveconfig1(8)  
    case 9
        g.p2.Selection = 2;
end

end
function fnext(source,callbackdata)
global g
           g.p2.Selection = 2;
           c=uicontextmenu(g.f);
           g.b8c.t2c.bc.btc.tb1.UIContextMenu=c;
           m1=uimenu(c,'Label','Delete the selected frequency','Callback',@RI_deletetableitem);
           
end




function fsaveconfig(source,callbackdata)
%  save config UserData [{RE|CE|OATs} {Tab1|2|3|4\|5} {button 1|2|3..}]
global g
    ancher=source.UserData;
    k=ancher(1);

    n=fieldnames(eval(['g.b' num2str(k) 'c.t1c']));
    mm=(length(n)-6)/2;
    % take the data from uicontrol
    for i=1:mm
        str1=['name{' num2str(i) '}=g.b' num2str(k) 'c.t1c.tx' num2str(i) '.String;'];eval(str1);
        str2=['value{' num2str(i) '}=g.b' num2str(k) 'c.t1c.rx' num2str(i) '.String;'];eval(str2);
    end
    %save to table
    T=table(name',value');
    T.Properties.VariableNames={'name','value'};
    %choose where to save
    switch k
        case 1
             fname='.\configuration\REconfiguration.xlsx';
        case 2
             fname='.\configuration\CEconfiguration.xlsx';
        case 3
             fname='.\configuration\OATconfiguration.xlsx';
        case 4
             fname='.\configuration\CIconfiguration.xlsx';
        case 5
             fname='.\configuration\ESDconfiguration.xlsx';
             
        case 7
             fname='.\configuration\NSAconfiguration.xlsx';
        case 8
            fname='.\configuration\RIconfiguration.xlsx';
        case 9
            fname='.\configuration\EFTconfiguration.xlsx';
             
    end
    %save the file into default
    writetable(T,fname);
    msgbox(['Configuration is succesfully saved into' fname]);
end
function fsaveconfig1(k)
%  save config UserData [{RE|CE|OATs} {Tab1|2|3|4\|5} {button 1|2|3..}]
global g
  
    n=fieldnames(eval(['g.b' num2str(k) 'c.t1c']));
    mm=(length(n)-6)/2;
    % take the data from uicontrol
    for i=1:mm
        str1=['name{' num2str(i) '}=g.b' num2str(k) 'c.t1c.tx' num2str(i) '.String;'];eval(str1);
        str2=['value{' num2str(i) '}=g.b' num2str(k) 'c.t1c.rx' num2str(i) '.String;'];eval(str2);
    end
    %save to table
    T=table(name',value');
    T.Properties.VariableNames={'name','value'};
    %choose where to save
    switch k
        case 1
             fname='.\configuration\REconfiguration.xlsx';
        case 2
             fname='.\configuration\CEconfiguration.xlsx';
        case 3
             fname='.\configuration\OATconfiguration.xlsx';
        case 4
             fname='.\configuration\CIconfiguration.xlsx';
        case 5
             fname='.\configuration\ESDconfiguration.xlsx';
             
        case 7
             fname='.\configuration\NSAconfiguration.xlsx';
        case 8
            fname='.\configuration\RIconfiguration.xlsx';
        case 9
            fname='.\configuration\EFTconfiguration.xlsx';
             
    end
    %save the file into default
    writetable(T,fname);
   % msgbox(['Configuration is succesfully saved into' fname]);
end

function fcheck_cal_date(source,callbackdata)
 %load the new config file
     ancher=source.UserData;
     k=ancher(1);
      switch k
        case 1
             fname='.\configuration\REconfiguration.xlsx';
        case 2
             fname='.\configuration\CEconfiguration.xlsx';
        case 3
             fname='.\configuration\OATconfiguration.xlsx';
        case 4
             fname='.\configuration\CIconfiguration.xlsx';
        case 5
             fname='.\configuration\ESDconfiguration.xlsx';
        case 8
            fname='.\configuration\RIconfiguration.xlsx';  
        case 9
            fname='.\configuration\RIconfiguration.xlsx';  
      end
      
     T1=readtable(fname); % read the configuration table into T1
     [mm1 nn1]=size(T1);
     for i =1:mm1
       Model=strtrim(char(extractBetween(T1.value(i),'Model:',',')));
       if ~isempty(Model)
           expiration_date=datenum(strtrim(char(extractAfter(T1.value(i),'Expiration.:'))));
           days= expiration_date-datenum(date)
                                   if days<0
                                       str=[ 'Error: The Test Equipment: ' Model ': Calilbration is expried for' num2str(-days) 'days! Do not use!' ];
                                       msgbox(str);
                                   elseif days<30
                                       str=[ 'Warning: The Test Equipment: ' Model  ': Calilbration is expring soon less ' num2str(days) 'days!' ];
                                       msgbox(str);
                                   end
       end % end if
     
     end % end for
      
end

function floadconfig(source,callbackdata)
% load config UserData [{RE|CE|OATs} {Tab1|2|3|4\|5} {button 1|2|3..}]
global g
    %choose file 
    if g.lastfolder==0
        g.lastfolder='c:\';
    end
    
    [filename, pathname] = uigetfile(['Q:\HTC\Equipment_Calibrations\Calibration Database\*.xlsm'], 'Pick an Excel configuration file to lao');

        if isequal(filename,0) || isequal(pathname,0)
           disp('User pressed cancel')
           return;
        else
            str=fullfile(pathname, filename);
            disp(['User selected ', ]);   
            g.lastfolder=pathname;
        end
    %read into table
     T=readtable(str,'Sheet','Cal Database');
    %load the new config file
     ancher=source.UserData;
     k=ancher(1);
      switch k
        case 1
             fname='.\configuration\REconfiguration.xlsx';
        case 2
             fname='.\configuration\CEconfiguration.xlsx';
        case 3
             fname='.\configuration\OATconfiguration.xlsx';
        case 4
             fname='.\configuration\CIconfiguration.xlsx';
        case 5
             fname='.\configuration\ESDconfiguration.xlsx';
        case 8
            fname='.\configuration\RIconfiguration.xlsx';
        case 9
            fname='.\configuration\EFTconfiguration.xlsx';
             
      end
    
     T1=readtable(fname); % read the configuration table into T1
     
     
    [mm nn]=size(T);
    [mm1 nn1]=size(T1);
    isok=1;
    for i =1:mm1
       SN=strtrim(char(extractBetween(T1.value(i),'SN:',',')));
       Model=strtrim(char(extractBetween(T1.value(i),'Model:',',')));
       if ~isempty(SN)   % if str contain SN
         try
         for j=1:mm      % search the database with matched SN
             
              if strcmp(strtrim(char(T.SerialNumber(j))),SN) % if found the meached SN
                   if strcmp(strtrim(char(T.ProductQualificationTesting__Y_N_(1))),'Y') % Check if the equipment is for product qualitication use 
                            str=[ 'Error: The Test Equipment: ' strtrim(char(T.ModelNumber(j))) 'with SN: ' strtrim(char(T.SerialNumber(j)))  ', is not qualified for Compliance Test! Do not use!' ]
                            msgbox(str);
                            isok=0;
                            T1.value(i)={str};
                            break;
                   end
                   
                    % compare if the SN expiration date is
                    % out of date.  if it does, through out
                    % the warning message.

                    expiration_date=datenum(strtrim(char(T.DueDate(j))));
                    days= expiration_date-datenum(date)
                    if days<0
                                             str=[ 'Error: The Test Equipment: ' strtrim(char(T.ModelNumber(j))) 'with SN: ' strtrim(char(T.SerialNumber(j)))  ': Calilbration is expried for' num2str(-days) 'days! Do not use!' ];
                                           msgbox(str);
                                           isok=0;
                    elseif days<30
                                           str=[ 'Warning: The Test Equipment: ' strtrim(char(T.ModelNumber(j))) 'with SN: ' strtrim(char(T.SerialNumber(j)))  ': Calilbration is expring soon less ' num2str(days) 'days!' ];
                                           msgbox(str);
                                           str=['Model:' strtrim(char(T.ModelNumber(j))) ', SN:' strtrim(char(T.SerialNumber(j))) ', Calibration Exp.:' strtrim(char(T.DueDate(j)))];
                    else
                                           str=['Model:' strtrim(char(T.ModelNumber(j))) ', SN:' strtrim(char(T.SerialNumber(j))) ', Calibration Exp.:' strtrim(char(T.DueDate(j)))];
                    end

                    T1.value(i)={str};
                     break;
                                           
             end % end if
             
          end     % end for end of search the database
          
          catch ME
                msgbox(['Is the equipment out for calibration? Please check the Model:' Model ' with SN: ' SN 'in the database for more information!']);
                isok=0;
          end  %end try
             
          if j==mm % indicate the DUT was not found in the whole database. 
                str=['Warning: Model:' Model ', SN:' SN ', is not in the Cal Database'];
                msgbox(str)
                isok=0;
          end
          
              
       end 
         
    end
    g.T=T1;
     % set the info in table into exisiting uicontrol. 
        ancher=source.UserData;
        for i=1:mm1
            str2=['g.b' num2str(ancher(1)) 'c.t1c.rx' num2str(i) '.String=''' T1.value{i} ''';'];
            eval(str2);
        end
     if isok 
        msgbox('All test equipment have valid calibration and ready to use.')
    
     end
         fsaveconfig1(k)  
end

function fcreate(source,callbackdata)
global g
global d
% save the current report header into file
fsaveheader(source,callbackdata);

switch source.UserData(1)
    case 1
        REreport;
    case 2
        CEreport;
    case 3
        OATreport;
    case 4
        CIreport;
    case 5
        ESDreport;
    case 8
        RIreport;
    case 9
        EFTreport;
end

end

    
function fsave_as_header(source,callbackdata)
% save report header
    global g
    
    
    % extract the header informtion from UIcontrol
    k=source.UserData(1);
    n=fieldnames(eval(['g.b' num2str(k) 'c.t5c']));
    mm=(length(n)-8)/2;
    for i=1:mm
    str1=['name{' num2str(i) '}=g.b' num2str(k) 'c.t5c.tx' num2str(i) '.String;'];eval(str1);
    str2=['value{' num2str(i) '}=g.b' num2str(k) 'c.t5c.rx' num2str(i) '.String;'];eval(str2);
    end
    % fix the mutliple line problem in last edit uicontrol
        str1=[]; str=value{mm};
        nn=size(str,1)
        for i=1:nn
         str1=[str1 char(10) str(i,:)]
        end
        value{mm}=str1;
    % save the extract info to table
    T=table(name',value');
    T.Properties.VariableNames={'name','value'};
    switch k
        case 1
             fname='\REreportheader.xlsx';
        case 2
             fname='\CEreportheader.xlsx';
        case 3
             fname='\OATreportheader.xlsx';
        case 4
             fname='\CIreportheader.xlsx';
        case 5
            fname='\ESDreportheader.xlsx';
        case 8
            fname='\RIreportheader.xlsx';
        case 9
            fname='\EFTreportheader.xlsx';
    end
    

  [filename, pathname] = uiputfile([g.lastfolder fname], 'Pick a report header file name to save');
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
      fname=fullfile(pathname, filename);
    end
     %save the table into file default
    writetable(T,fname);
    if source.UserData(3)==2
    msgbox(['Report Header is succesfully saved into' fname]);
    end
end

    
    
function fsaveheader(source,callbackdata)
% save report header
    global g
    
    
    % extract the header informtion from UIcontrol
    k=source.UserData(1);
    n=fieldnames(eval(['g.b' num2str(k) 'c.t5c']));
    mm=(length(n)-8)/2;
    for i=1:mm
    str1=['name{' num2str(i) '}=g.b' num2str(k) 'c.t5c.tx' num2str(i) '.String;'];eval(str1);
    str2=['value{' num2str(i) '}=g.b' num2str(k) 'c.t5c.rx' num2str(i) '.String;'];eval(str2);
    end
    % fix the mutliple line problem in last edit uicontrol
        str1=[]; str=value{mm};
        nn=size(str,1)
        for i=1:nn
         str1=[str1 char(10) str(i,:)]
        end
        value{mm}=str1;
    % save the extract info to table
    T=table(name',value');
    T.Properties.VariableNames={'name','value'};
    switch k
        case 1
             fname='.\configuration\REreportheader.xlsx';
        case 2
             fname='.\configuration\CEreportheader.xlsx';
        case 3
             fname='.\configuration\OATreportheader.xlsx';
        case 4
             fname='.\configuration\CIreportheader.xlsx';
        case 5
            fname='.\configuration\ESDreportheader.xlsx';
        case 8
            fname='.\configuration\RIreportheader.xlsx';
        case 9
            fname='.\configuration\EFTreportheader.xlsx';
    end
    
    
    %save the table into file default
    writetable(T,fname);
    if source.UserData(3)==2
    msgbox(['Report Header is succesfully saved into' fname]);
    end
    
end

function floadheader(source,callbackdata)
%% load file header
global g
        % select filel to load
        if g.lastfolder==0
           g.lastfolder='c:\';
         end
        [filename, pathname] = uigetfile([g.lastfolder '\*.xlsx'], 'Pick an Excel report header file to load',g.lastfolder);
            if isequal(filename,0) || isequal(pathname,0)
               disp('User pressed cancel')
               return;
            else
                str=fullfile(pathname, filename);
                disp(['User selected ', ]);
                 g.lastfolder=pathname;
            end
        % load xlsx file into table
         T=readtable(str);
        [mm nn]=size(T);
        % create uicontrol from table 
        k=source.UserData(1);
        % find match from g.T and T.
        for i=1:mm
            %  remove the return character in the input
            T.value{i}=  regexprep(T.value{i},'\n',' ');
            str2=['g.b' num2str(k) 'c.t5c.rx' num2str(i) '.String=''' T.value{i} ''';'];
            eval(str2);
        end

end

function Bt_Resize(source,callbackdata)
global g
eval(['set( g.b' num2str(source.UserData(1)) 'c.t2c.b, ''Heights'', [-1 -1 35] )']);
end
function Bt_Measure(source,callbackdata)
global g
global s
global d
k=source.UserData(1);
switch k
    case 1
        d.lim=0;
        d.ph=[];d.pv=[];d.p=[];
        %check if Horizontal is enabled
        if g.b1c.t2c.bc.btc.bt1.Value
            % set the antenna to horizontal position
            s.tw.setpolar(0);
            % make pre-scan
            d.p=s.measureRE;
            % take maxiumhold
            d.mmaxhold;
            % find the peaks using defualt RBW. 
             % Save these peaks into the peak list. 
            d.findpeak(d.DefaultRBW_FindPeak);
            d.view2D(g.b1c.t2c.bc.ax1);
            d.overlaypeaks(g.b1c.t2c.bc.ax1,g.b1c.t4c.bc.tb1);
            d.addmenu(g.f,g.b1c.t2c.bc.ax1);
            d.p.type='RE';
            d.ph=d.p;
        end
        
        if g.b1c.t2c.bc.btc.bt2.Value
            s.tw.setpolar(1);
            d.p=s.measureRE;
            d.mmaxhold;
            d.findpeak(d.DefaultRBW_FindPeak);
            d.view2D(g.b1c.t2c.bc.ax2);
            d.overlaypeaks(g.b1c.t2c.bc.ax2,g.b1c.t4c.bc.tb1);
            d.addmenu(g.f,g.b1c.t2c.bc.ax2);
            d.p.type='RE';
            d.pv=d.p;
        end
        
    case 2
        % measure the CE
          %check if Line 1 is enabled
          d.lim=1;
           d.ph=[];d.pv=[];d.p=[];
        if g.b2c.t2c.bc.btc.bt1.Value
            waitfor(msgbox('Please connect the probing port to Line 1') );
           
            d.p=s.measureCE;
            d.findpeak(d.DefaultRBW_FindPeak);
            d.view2D(g.b2c.t2c.bc.ax1);
            d.overlaypeaks(g.b2c.t2c.bc.ax1,g.b2c.t4c.bc.tb1);
            d.addmenu(g.f,g.b2c.t2c.bc.ax1);
             d.p.type='CE';
            d.pL=d.p;
        end
        
        if g.b2c.t2c.bc.btc.bt2.Value
           waitfor( msgbox('Please connect the probing port to Neutral') );
           
            d.p=s.measureCE;
            d.findpeak(d.DefaultRBW_FindPeak);
            d.view2D(g.b2c.t2c.bc.ax2);
            d.overlaypeaks(g.b2c.t2c.bc.ax2,g.b2c.t4c.bc.tb1);
            d.addmenu(g.f,g.b2c.t2c.bc.ax2);
            d.p.type='CE';
            d.pN=d.p;
        end
        
    case 3
        %measure the 10 meter OATs
          %check if Horizontal is enabled
          d.lim=2;
        if g.b3c.t2c.bc.btc.bt1.Value
            
            s.tw.setpolar(0);
            d.p=s.measureOAT;
            d.mmaxhold;
            d.findpeak(d.DefaultRBW_FindPeak);
            d.view2D(g.b3c.t2c.bc.ax1);
            d.overlaypeaks(g.b3c.t2c.bc.ax1,g.b3c.t4c.bc.tb1);
            d.addmenu(g.f,g.b3c.t2c.bc.ax1);
             d.p.type='OAT';
            d.ph10=d.p;
        end
        
        if g.b3c.t2c.bc.btc.bt2.Value
            s.tw.setpolar(1);
            d.p=s.measureOAT;
            d.mmaxhold;
            d.findpeak(d.DefaultRBW_FindPeak);
            d.view2D(g.b3c.t2c.bc.ax2);
            d.overlaypeaks(g.b3c.t2c.bc.ax2,g.b3c.t4c.bc.tb1);
            d.addmenu(g.f,g.b3c.t2c.bc.ax2);
             d.p.type='OAT';
            d.pv10=d.p;
        end
    case 7 %NSA
        % set the signal generator amplitude
        s.hf.amp(-25)
        s.hf.AM_Off
        s.hf.freq(30e6)
        s.hf.On
        freq=logfreq(30e6,1e9,50);
        result={};
        s.tw.setlimit([s.TW_LOW_LIMIT s.TW_HIGH_LIMIT]);
        s.tw.setspeed(100);
        cla(g.b7c.t2c.bc.ax1);
        peakvalue=[];freq1=[];
        semilogx(g.b7c.t2c.bc.ax1,30e6,0);
        for i =1:length(freq)
          s.hf.freq(freq(i));
          s.sa.setcenterfreq(freq(i));
          s.sa.setSpan(freq(i)*0.01);
          s.tw.scan(0.5);
          temp.ttpos=[];temp.twpos=[];temp.polar=[];temp.result=[];
          while ~s.tw.opc
               s.sa.peak;
               s.r=1;
               s.h=s.tw.cp;
               temp.ttpos=[temp.ttpos s.r];
               temp.twpos=[temp.twpos s.h];
               temp.polar=[temp.polar s.polar];
               temp.result=[temp.result;s.sa.peak];
               temp.freq=freq(i);
          end
          result{i}=temp;
          peakvalue=[peakvalue; max(temp.result)];
          freq1=[freq1;freq(i)];
          g.b7c.t2c.bc.ax1.Children(1).XData=freq1;
          g.b7c.t2c.bc.ax1.Children(1).YData=peakvalue;
          drawnow;
        end
         result1=[g.b7c.t2c.bc.ax1.Children(1).XData; g.b7c.t2c.bc.ax1.Children(1).YData];
          save('NSALocation1V.mat','result','result1');
          
          figure
         plot(result{3}.twpos,result{3}.result)
end

end
function Bt_NSA(source,callbackdata)
global g
global s
k=source.UserData(3);
switch k
    case 1,2 % scan H
        
 % set the signal generator amplitude
        s.hf.amp(-25)
        s.hf.AM_Off
        s.hf.freq(30e6)
        s.hf.On
        freq=logfreq(30e6,1e9,50);
        result={};
        s.tw.setlimit([s.TW_LOW_LIMIT s.TW_HIGH_LIMIT]);
        s.tw.setspeed(100);
        cla(g.b7c.t2c.bc.ax1);
        peakvalue=[];freq1=[];
        semilogx(g.b7c.t2c.bc.ax1,30e6,0);
        for i =1:length(freq)
          s.hf.freq(freq(i));
          s.sa.setcenterfreq(freq(i));
          s.sa.setSpan(freq(i)*0.01);
          s.tw.scan(0.5);
          temp.ttpos=[];temp.twpos=[];temp.polar=[];temp.result=[];
          while ~s.tw.opc
               s.sa.peak;
               s.r=1;
               s.h=s.tw.cp;
               temp.ttpos=[temp.ttpos s.r];
               temp.twpos=[temp.twpos s.h];
               temp.polar=[temp.polar s.polar];
               temp.result=[temp.result;s.sa.peak];
               temp.freq=freq(i);
          end
          result{i}=temp;
          peakvalue=[peakvalue; max(temp.result)];
          freq1=[freq1;freq(i)];
          g.b7c.t2c.bc.ax1.Children(1).XData=freq1;
          g.b7c.t2c.bc.ax1.Children(1).YData=peakvalue;
          drawnow;
        end
         result1=[g.b7c.t2c.bc.ax1.Children(1).XData; g.b7c.t2c.bc.ax1.Children(1).YData];
         beep;
          prompt={'Enter the location of the TX antenna','Enter the antenna Polarization'};
          name='Input for Location information';
          numlines=1;
          defaultanswer={'Center','Hori'};
          answer=inputdlg(prompt,name,numlines,defaultanswer);
          fname=['NSALocation1',answer{1},answer{2}]
          save([fname,'.mat'],'result','result1');
          b=result1';
          a=[30e3:1e6:1e9]';
          c=interp1(b(:,1),b(:,2),a);
          csvwrite([fname,'.csv'],[a c]);
          figure
         plot(result{3}.twpos,result{3}.result)
    case 3 % cable loss  
               
 % set the signal generator amplitude
        s.hf.amp(-50)
        s.hf.AM_Off
        s.hf.freq(30e6)
        s.hf.On
        freq=logfreq(30e6,1e9,100);
        result={};
        cla(g.b7c.t2c.bc.ax1);
        peakvalue=[];freq1=[];
        semilogx(g.b7c.t2c.bc.ax1,30e6,0);
        for i =1:length(freq)
          s.hf.freq(freq(i));
          s.sa.setcenterfreq(freq(i));
          s.sa.setSpan(freq(i)*0.01);
          pause(0.1)
          peakvalue=[peakvalue; s.sa.peak+50];
          pause(0.1);
          freq1=[freq1;freq(i)];
          g.b7c.t2c.bc.ax1.Children(1).XData=freq1;
          g.b7c.t2c.bc.ax1.Children(1).YData=peakvalue;
        end
          result1=[g.b7c.t2c.bc.ax1.Children(1).XData; g.b7c.t2c.bc.ax1.Children(1).YData];
          fname=['NSACableLoss'];
          save([fname,'.mat'],'result1');
          b=result1';
          a=[30e3:1e6:1e9]';
          c=interp1(b(:,1),b(:,2),a);
          csvwrite([fname,'.csv'],[a c])
         
    case 4
        
    case 5

   end
end


function Bt_Pause(source,callbackdata)
global g
k=source.UserData(1);
switch k
    case 1  
        g.pause=1;
    case 2
    case 3
        
end

end
function Bt_Save(source,callbackdata)
global g
global d
k=source.UserData(1);

switch k
    case 1
        str1=[g.b1c.t5c.rx1.String ' ' g.b1c.t5c.rx2.String ' ' g.b1c.t5c.rx3.String];
        str=[ '.\UserData\*' str1 '.mat'];
           
    case 2
        str1=[g.b2c.t5c.rx1.String ' ' g.b2c.t5c.rx2.String ' ' g.b2c.t5c.rx3.String];
        str=[ '.\UserData\CE_RAWDATA_' str1 '.mat'];
        
    case 3
        str1=[g.b3c.t5c.rx1.String ' ' g.b3c.t5c.rx2.String ' ' g.b3c.t5c.rx3.String];
        str=[ '.\UserData\*' str1 '.mat'];
end

         [filename, pathname] = uiputfile(str, 'Pick an MATLAB Raw Data file to save',g.lastfolder);
            if isequal(filename,0) || isequal(pathname,0)
               disp('User pressed cancel')
            else
               disp(['User selected ', fullfile(pathname, filename)])
            end
             fname=fullfile(pathname, filename);
             g.lastfolder=pathname;
           save(fname, 'd');
end
function Bt_Load(source,callbackdata)
global g
global d
k=source.UserData(1);
switch k
    case 1       
           [filename, pathname] = uigetfile('*.mat', 'Pick a MATLAB rawdata to load',g.lastfolder);
            if isequal(filename,0) || isequal(pathname,0)
               disp('User pressed cancel')
            else
               disp(['User selected ', fullfile(pathname, filename)])
            end
            fname=fullfile(pathname, filename);
            g.lastfolder=pathname;
            load(fname, 'd'); 
            if ~isempty(d.ph.ttpos)
                d.p=d.ph;
                d.view2D(g.b1c.t2c.bc.ax1);
                d.overlaypeaks(g.b1c.t2c.bc.ax1,g.b1c.t4c.bc.tb1);
                d.addmenu(g.f,g.b1c.t2c.bc.ax1);
            end
            if ~isempty(d.pv.ttpos)
                d.p=d.pv;
                d.view2D(g.b1c.t2c.bc.ax2);
                 d.overlaypeaks(g.b1c.t2c.bc.ax2,g.b1c.t4c.bc.tb1);
                d.addmenu(g.f,g.b1c.t2c.bc.ax2);
            end
            
    case 2
        [filename, pathname] = uigetfile('CE_RAWDATA_*.mat', 'Pick a MATLAB rawdata to load',g.lastfolder);
            if isequal(filename,0) || isequal(pathname,0)
               disp('User pressed cancel')
            else
               disp(['User selected ', fullfile(pathname, filename)])
            end
            g.lastfolder=pathname;
            fname=fullfile(pathname, filename);
            load(fname, 'd'); 
            if ~isempty(d.pL.result)
                d.p=d.pL;
                d.view2D(g.b2c.t2c.bc.ax1);
                d.overlaypeaks(g.b2c.t2c.bc.ax1,g.b2c.t4c.bc.tb1);
                d.addmenu(g.f,g.b2c.t2c.bc.ax1);
            end
            if ~isempty(d.pN.result)
                d.p=d.pN;
                d.view2D(g.b2c.t2c.bc.ax2);
                 d.overlaypeaks(g.b2c.t2c.bc.ax2,g.b2c.t4c.bc.tb1);
                d.addmenu(g.f,g.b2c.t2c.bc.ax2);
            end
            
    case 3
           [filename, pathname] = uigetfile('*.mat', 'Pick a MATLAB rawdata to load',g.lastfolder);
            if isequal(filename,0) || isequal(pathname,0)
               disp('User pressed cancel')
            else
               disp(['User selected ', fullfile(pathname, filename)])
            end
            fname=fullfile(pathname, filename);
            g.lastfolder=pathname;
            load(fname, 'd'); 
            msgbox('3 Meter Precan result is modified by 10dB to simulate the baseline of 10 Meter OATs')
                     % Load the data from 3 meter chaber, Now change it from 3 meter to the
                     % 10 meter chamber mode d.lim change from 0 to 2. 
                     d.lim=2;
                     d.ph.result=d.ph.result-ones(size(d.ph.result))*10;
                     d.ph.maxhold=d.ph.maxhold-10;
                     d.ph.peak(:,2)=d.ph.peak(:,2)-10;
                     d.ph.peaktable.peaks=d.ph.peaktable.peaks-10;
                     d.ph.peakresult(4:6)=d.ph.peakresult(4:6)-10;
                     d.ph.peaktable2.Amplitude_dBuV=d.ph.peaktable2.Amplitude_dBuV-10;
                     d.ph.peaktable2.Peak_dBuV=d.ph.peaktable2.Peak_dBuV-10;
                     d.ph.peaktable2.QuasiPeak_dBuV=d.ph.peaktable2.QuasiPeak_dBuV-10;
                     d.ph.peaktable2.Average_dBuV=d.ph.peaktable2.Average_dBuV-10;
                     d.ph.peakrbw
                     d.ph.type='OAT'
                     d.pv.result=d.pv.result-ones(size(d.pv.result))*10
                     d.pv.maxhold=d.pv.maxhold-10;
                     d.pv.peak(:,2)=d.pv.peak(:,2)-10;
                     d.pv.peaktable.peaks=d.pv.peaktable.peaks-10;
                     d.pv.peakresult(4:6)=d.pv.peakresult(4:6)-10;
                     d.pv.peaktable2.Amplitude_dBuV=d.pv.peaktable2.Amplitude_dBuV-10;
                     d.pv.peaktable2.Peak_dBuV=d.pv.peaktable2.Peak_dBuV-10;
                     d.pv.peaktable2.QuasiPeak_dBuV=d.pv.peaktable2.QuasiPeak_dBuV-10;
                     d.pv.peaktable2.Average_dBuV=d.pv.peaktable2.Average_dBuV-10;
                     
                     d.pv.type='OAT'
                     
                     
                    if ~isempty(d.ph)
                        d.p=d.ph;
                        d.view2D(g.b3c.t2c.bc.ax1);
                        d.overlaypeaks(g.b3c.t2c.bc.ax1,g.b3c.t4c.bc.tb1);
                        d.addmenu(g.f,g.b3c.t2c.bc.ax1);
                    end
                    if ~isempty(d.pv)
                        d.p=d.pv;
                        d.view2D(g.b3c.t2c.bc.ax2);
                        d.overlaypeaks(g.b3c.t2c.bc.ax2,g.b3c.t4c.bc.tb1);
                        d.addmenu(g.f,g.b3c.t2c.bc.ax2);
                    end
                
            
end

end

function Bt_Convert(source,callbackdata)
global d
global g
if d.lim==0
    d.lim=2; % convert to 10 meter chamber.
    d.ph.result=d.ph.result-10;
    d.p=d.ph;
             d.mmaxhold;
             d.findpeak(d.DefaultRBW_FindPeak);
             d.view2D(g.b3c.t2c.bc.ax1);
            
                d.overlaypeaks(g.b3c.t2c.bc.ax1,g.b3c.t4c.bc.tb1);
                d.addmenu(g.f,g.b3c.t2c.bc.ax1);
    d.pv.result=d.pv.result-10;
    d.p=d.pv;
             d.mmaxhold;
             d.findpeak(d.DefaultRBW_FindPeak);
             d.view2D(g.b3c.t2c.bc.ax2);
                d.overlaypeaks(g.b3c.t2c.bc.ax2,g.b3c.t4c.bc.tb1);
                d.addmenu(g.f,g.b3c.t2c.bc.ax2);
else
    msgbox('Warning: The loaded data is not measured from 3Meter Chamber, No conversion from 3Meter chamber to OAts is done!')
    return;
end


end

function Bt_Next(source,callbackdata)
global g
         if source.UserData(1)==2&&source.UserData(2)==4
             g.p2.Selection = 4;
         else 
            g.p2.Selection = source.UserData(2)+1;
         end
         
end

function Bt_1_3_10_view3D(source, callbackdata)
global d
global g
switch source.UserData(1)
    case 1
        d.view3D( g.b1c.t3c.bc.ax1,g.selectedtrace);

    case 3
      d.view3D( g.b3c.t3c.bc.ax1,g.selectedtrace);

end

end


function Bt_1_3_11_viewpolar(source, callbackdata)
global d
global g
       switch g.selectedtrace
                case 0
                    d.p=d.ph;
                case 1
                    d.p=d.pv;
          end
            
        
switch source.UserData(1)
    case 1
    g.fig_polar_scan=figure('Position',[100 100 1000 400],'DeleteFcn',@deletefig);
           ax1=gca;
           d.view2D(ax1);
           
           dcm_obj = datacursormode(g.fig_polar_scan);
           datacursormode on
           set(dcm_obj,'UpdateFcn',{@myupdatefcn,g.b1c.t3c.bc.ax1});
           cla(g.b1c.t3c.bc.ax1);
           view(g.b1c.t3c.bc.ax1,0,90)
           
           if isempty(g.b1c.t3c.bc.ax1.Children)
            d.polar_freq=500e6;
           d.viewpolar(g.f, g.b1c.t3c.bc.ax1);
           end
           
    case 3
            
           g.fig_polar_scan=figure('Position',[100 100 1000 400],'DeleteFcn',@deletefig);
           ax1=gca;
           d.view2D(ax1);
           
           dcm_obj = datacursormode(g.fig_polar_scan);
           datacursormode on
           set(dcm_obj,'UpdateFcn',{@myupdatefcn,g.b3c.t3c.bc.ax1});
           cla(g.b3c.t3c.bc.ax1);
           view(g.b3c.t3c.bc.ax1,0,90)
           if isempty(g.b3c.t3c.bc.ax1.Children)
           d.polar_freq=500e6;
           d.viewpolar(g.f, g.b3c.t3c.bc.ax1);
           end
           
 
end

end
function deletefig(src,~)
global g
g.fig_polar_scan=[];
end
function Bt_viewangle(source, callbackdata)
global d
global g
t=str2num(g.b1c.t3c.bc.btc.bt9.String);
r=str2num(g.b1c.t3c.bc.btc.bt7.String);
d.viewangle(g.b1c.t3c.bc.ax1, [r t]);

end

function Bt_1_3_1_selectdata(source, callbackdata)
global g
global d
global s
switch source.UserData(1)
    case 1  % RE : select peak frequencies from CE result for remeasurement
                k=source.UserData(2);
                     if eval(['g.b1c.t' , num2str(k),'c.bc.btc.bt1.Value'])
                         eval(['g.b1c.t', num2str(k), 'c.bc.btc.bt2.Value=0;']);
                         g.selectedtrace=0;
                     else
                         eval(['g.b1c.t', num2str(k) ,'c.bc.btc.bt2.Value=1;']);
                         g.selectedtrace=1;
                     end
                 if k==4
                                d.p=d.ph;
                                g.selectedtrace=0;

                     switch g.selectedbutton %hu01
                            case 0 % button frp, search and filter do nothing.
                            d.overlaypeaks(g.b1c.t4c.bc.ax1,g.b1c.t4c.bc.tb1);
                            d.addmenut(g.f,g.b1c.t4c.bc.tb1,s);

                            case 1 % from load list button
                            d.overlayselectedpeaks(g.b1c.t4c.bc.ax1,g.b1c.t4c.bc.tb1);
                            d.addmenut(g.f,g.b1c.t4c.bc.tb1,s);

                            case 2 % from load remeasure button 
                            if isfield(d.p,'peaktable2')
                             d.overlay_peaktable2(g.b1c.t4c.bc.ax1,g.b1c.t4c.bc.tb1);
                            else
                             d.overlayselectedpeaks(g.b1c.t4c.bc.ax1,g.b1c.t4c.bc.tb1);

                            end

                            d.addmenut(g.f,g.b1c.t4c.bc.tb1,s);

                        end

                 end
    case 2  % CE : select peak frequencies from CE result for remeasurement
                 k=source.UserData(2);  
                   if eval(['g.b2c.t' , num2str(k),'c.bc.btc.bt1.Value'])
                         eval(['g.b2c.t', num2str(k), 'c.bc.btc.bt2.Value=0;']);
                         g.selectedtrace=0;
                     else
                         eval(['g.b2c.t', num2str(k) ,'c.bc.btc.bt2.Value=1;']);
                         g.selectedtrace=1;
                   end
                   if k==4
                        d.p=d.pL;                            
                        switch g.selectedbutton %hu01
                            case 0 % button frp, search and filter do nothing.
                             

                            d.overlaypeaks(g.b2c.t4c.bc.ax1,g.b2c.t4c.bc.tb1);
                            d.addmenut(g.f,g.b2c.t4c.bc.tb1,s);

                            case 1 % from load list button
                             
                            d.overlayselectedpeaks(g.b2c.t4c.bc.ax1,g.b2c.t4c.bc.tb1);
                            d.addmenut(g.f,g.b2c.t4c.bc.tb1,s);

                            case 2 % from load remeasure button 
                             if isfield(d.p,'peaktable2')
                             d.overlay_peaktable2(g.b2c.t4c.bc.ax1,g.b2c.t4c.bc.tb1);
                            else
                             d.overlayselectedpeaks(g.b2c.t4c.bc.ax1,g.b2c.t4c.bc.tb1);

                            end

                            d.addmenut(g.f,g.b2c.t4c.bc.tb1,s);

                        end
                   end

             
                 
    case 3
             switch source.UserData(2)
                 case 4
                         if g.b3c.t4c.bc.btc.bt1.Value
                                    g.b3c.t4c.bc.btc.bt2.Value=0;
                                     g.selectedtrace=0;
                                      d.p=d.ph;
                                 else
                                     g.b3c.t4c.bc.btc.bt2.Value=1;
                                     g.selectedtrace=1;
                                     d.p=d.pv;
                            end


                                    switch g.selectedbutton %hu01
                                        case 0 % button frp, search and filter do nothing.


                                        d.overlaypeaks(g.b3c.t4c.bc.ax1,g.b3c.t4c.bc.tb1);
                                        d.addmenut(g.f,g.b3c.t4c.bc.tb1,s);

                                        case 1 % from load list button
                                        d.overlayselectedpeaks(g.b3c.t4c.bc.ax1,g.b3c.t4c.bc.tb1);
                                        d.addmenut(g.f,g.b3c.t4c.bc.tb1,s);

                                        case 2 % from load remeasure button 
                                        if isfield(d.p,'peaktable2')
                                         d.overlay_peaktable2(g.b3c.t4c.bc.ax1,g.b3c.t4c.bc.tb1);
                                        else
                                         d.overlayselectedpeaks(g.b3c.t4c.bc.ax1,g.b3c.t4c.bc.tb1);

                                        end

                                        d.addmenut(g.f,g.b3c.t4c.bc.tb1,s);

                                    end
                 case 3
                        if g.b3c.t3c.bc.btc.bt1.Value
                                    g.b3c.t3c.bc.btc.bt2.Value=0;
                                     g.selectedtrace=0;
                                      d.p=d.ph;
                                 else
                                     g.b3c.t3c.bc.btc.bt2.Value=1;
                                     g.selectedtrace=1;
                                     d.p=d.pv;
                            end

             end
             
end

         
end

function Bt_1_3_2_selectdata(source, callbackdata)
global g
global d
global s
switch source.UserData(1)
    case 1 
                     k=source.UserData(2);
                     if eval(['g.b1c.t' , num2str(k),'c.bc.btc.bt2.Value'])
                         eval(['g.b1c.t', num2str(k), 'c.bc.btc.bt1.Value=0;']);
                         g.selectedtrace=1;
                     else
                         eval(['g.b1c.t', num2str(k) ,'c.bc.btc.bt1.Value=1;']);
                         g.selectedtrace=0;
                     end

                      if k==4
                        switch g.selectedbutton %hu01
                            case 0 % button frp, search and filter do nothing.
                                          d.p=d.pv;

                            d.overlaypeaks(g.b1c.t4c.bc.ax1,g.b1c.t4c.bc.tb1);
                            d.addmenut(g.f,g.b1c.t4c.bc.tb1,s);

                            case 1 % from load list button
                              d.p=d.pv;

                            d.overlayselectedpeaks(g.b1c.t4c.bc.ax1,g.b1c.t4c.bc.tb1);
                            d.addmenut(g.f,g.b1c.t4c.bc.tb1,s);


                            case 2 % from load remeasure button 
                               d.p=d.pv;

                            if isfield(d.p,'peaktable2')
                             d.overlay_peaktable2(g.b1c.t4c.bc.ax1,g.b1c.t4c.bc.tb1);
                            else
                             d.overlayselectedpeaks(g.b1c.t4c.bc.ax1,g.b1c.t4c.bc.tb1);
                            end
                            d.addmenut(g.f,g.b1c.t4c.bc.tb1,s);

                        end

                      end
    case 2
            
                   k=source.UserData(2);
                   % if Netural is selected
                     if eval(['g.b2c.t' , num2str(k),'c.bc.btc.bt2.Value'])
                         eval(['g.b2c.t', num2str(k), 'c.bc.btc.bt1.Value=0;']);
                         g.selectedtrace=1;
                   % set the Netural =1 Line=0 
                     else
                         eval(['g.b2c.t', num2str(k) ,'c.bc.btc.bt1.Value=1;']);
                         g.selectedtrace=0;
                     end
                      if k==4  
                     switch g.selectedbutton %hu01
                            case 0 % button from, search and filter do nothing.
                               d.p=d.pN;
                               d.overlaypeaks(g.b2c.t4c.bc.ax1,g.b2c.t4c.bc.tb1);
                            d.addmenut(g.f,g.b2c.t4c.bc.tb1,s);

                            case 1 % from load list button
                                d.p=d.pN;
                            d.overlayselectedpeaks(g.b2c.t4c.bc.ax1,g.b2c.t4c.bc.tb1);
                            d.addmenut(g.f,g.b2c.t4c.bc.tb1,s);

                            case 2 % from load remeasure button 
                                d.p=d.pN;
                            if isfield(d.p,'peaktable2')
                             d.overlay_peaktable2(g.b2c.t4c.bc.ax1,g.b2c.t4c.bc.tb1);
                            else
                             d.overlayselectedpeaks(g.b2c.t4c.bc.ax1,g.b2c.t4c.bc.tb1);

                            end

                            d.addmenut(g.f,g.b2c.t4c.bc.tb1,s);

                           end
                      end

    case 3
        k=source.UserData(2);
       
                     if eval(['g.b3c.t' , num2str(k),'c.bc.btc.bt2.Value'])
                         eval(['g.b3c.t', num2str(k), 'c.bc.btc.bt1.Value=0;']);
                         g.selectedtrace=1;
                     else
                         eval(['g.b3c.t', num2str(k) ,'c.bc.btc.bt1.Value=1;']);
                         g.selectedtrace=0;
                     end

                      if k==4
                        switch g.selectedbutton %hu01
                            case 0 % button frp, search and filter do nothing.
                                          d.p=d.pv;

                            d.overlaypeaks(g.b3c.t4c.bc.ax1,g.b3c.t4c.bc.tb1);
                            d.addmenut(g.f,g.b3c.t4c.bc.tb1,s);

                            case 1 % from load list button
                              d.p=d.pv;

                            d.overlayselectedpeaks(g.b3c.t4c.bc.ax1,g.b3c.t4c.bc.tb1);
                            d.addmenut(g.f,g.b3c.t4c.bc.tb1,s);


                            case 2 % from load remeasure button 
                               d.p=d.pv;

                            if isfield(d.p,'peaktable2')
                             d.overlay_peaktable2(g.b3c.t4c.bc.ax1,g.b3c.t4c.bc.tb1);
                            else
                             d.overlayselectedpeaks(g.b3c.t4c.bc.ax1,g.b3c.t4c.bc.tb1);
                            end
                            d.addmenut(g.f,g.b3c.t4c.bc.tb1,s);

                        end

                      end
end


      
end
function Bt_1_4_3_searchpeak(source, callbackdata) 
global g
global d
global s
k=source.UserData(1);
switch k
    case 1 %RE
                if ~g.selectedtrace
                    d.p=d.ph;
                else
                    d.p=d.pv;
                end
                % find the peaks first create peak table
                d.findpeak(d.DefaultRBW_FindPeak);
                % overlay entire peaktable.
                d.overlaypeaks(g.b1c.t4c.bc.ax1,g.b1c.t4c.bc.tb1);
                d.addmenut(g.f,g.b1c.t4c.bc.tb1,s);
                g.selectedbutton=0;
       
                        if ~g.selectedtrace
                            d.ph=d.p;
                        else
                            d.pv=d.p;
                        end
          
                
    case 2 %CE
                if ~g.selectedtrace
                    d.p=d.pL;
                else
                    d.p=d.pN;
                end
                % find the peaks first create peak table
                d.findpeak(d.DefaultRBW_FindPeak);
                % overlay entire peaktable.
                d.overlaypeaks(g.b2c.t4c.bc.ax1,g.b2c.t4c.bc.tb1);
                d.addmenut(g.f,g.b2c.t4c.bc.tb1,s);
                g.selectedbutton=0;
    
                    if ~g.selectedtrace
                        d.pL=d.p;
                    else
                        d.pN=d.p;
                    end
            
                
    case 3
               if ~g.selectedtrace
                    d.p=d.ph;
                else
                    d.p=d.pv;
                end
                % find the peaks first create peak table
                d.mmaxhold;
                d.findpeak(d.DefaultRBW_FindPeak);
                % overlay entire peaktable.
                d.overlaypeaks(g.b3c.t4c.bc.ax1,g.b3c.t4c.bc.tb1);
                d.addmenut(g.f,g.b3c.t4c.bc.tb1,s);
                g.selectedbutton=0;
              
                        if ~g.selectedtrace
                            d.ph=d.p
                        else
                            d.pv=d.p;
                        end
              
                
end


end
function Bt_1_4_4_searchpeak(source, callbackdata) 
global g
global d
global s
switch source.UserData(1)
    case 1
        
            if ~g.selectedtrace
                d.p=d.ph
            else
                d.p=d.pv
            end
            d.findpeak(g.rbw);
            d.overlayfilteredpeaks(g.b1c.t4c.bc.ax1,g.b1c.t4c.bc.tb1);
            d.addmenut(g.f,g.b1c.t4c.bc.tb1,s);
            g.selectedbutton=1;
            %
            if ~g.selectedtrace
                d.ph=d.p;
            else
                d.pv=d.p;
            end
    case 2
           if ~g.selectedtrace
                d.p=d.pL;
            else
                d.p=d.pN;
            end
            d.findpeak(g.rbw);
            d.overlayfilteredpeaks(g.b2c.t4c.bc.ax1,g.b2c.t4c.bc.tb1);
            d.addmenut(g.f,g.b2c.t4c.bc.tb1,s);
            g.selectedbutton=1;
            %
            if ~g.selectedtrace
                d.pL=d.p;
            else
                d.pN=d.p;
            end
            
    case 3
           if ~g.selectedtrace
                d.p=d.ph
            else
                d.p=d.pv
            end
            d.findpeak(g.rbw);
            d.overlayfilteredpeaks(g.b3c.t4c.bc.ax1,g.b3c.t4c.bc.tb1);
            d.addmenut(g.f,g.b3c.t4c.bc.tb1,s);
            g.selectedbutton=1;
            %
            if ~g.selectedtrace
                d.ph=d.p;
            else
                d.pv=d.p;
            end

end
end

function Bt_1_4_8_rbw(source,callbackdata)
global g
g.rbw=str2num(source.String)*1e6;

end

function Bt_1_4_15_savelist(source,callbackdata)
global d
global g
switch source.UserData(1)
    case {1,3}
          if ~g.selectedtrace
              str=['.\UserData\HorizontalPeakList.txt'];
          else
              str=['.\UserData\VeriticalPeakList.txt'];
          end
    case 2
                 if ~g.selectedtrace
              str=['.\UserData\CE_Line_PeakList.txt'];
          else
              str=['.\UserData\CE_Neutral_PeakList.txt'];
          end
end

  [filename, pathname] = uiputfile(str, 'Save into Excel Peak list file',g.lastfolder);
        if isequal(filename,0) || isequal(pathname,0)
           disp('User pressed cancel')
           return;
        else
            fname=fullfile(pathname, filename);
            disp(['User selected ',fname ]);   
        end
        g.lastfolder=pathname;
        writetable(d.p.peaktable,fname);
         g.selectedbutton=1; 
end
function Bt_1_4_16_loadlist(source,callbackdata)
global g
global d
global s

switch source.UserData(1)
    case 2
           if ~g.selectedtrace
              str=['.\UserData\CE_Line_PeakList.txt'];
              d.p=d.pL;
         else
              d.p=d.pN;
              str=['.\UserData\CE_Neutral_PeakList.txt'];
           end
    case {1,3}
         if ~g.selectedtrace
              str=['.\UserData\HorizontalPeakList.txt'];
              d.p=d.ph;
         else
              d.p=d.pv;
              str=['.\UserData\VeriticalPeakList.txt'];
          end
           
  end

   [filename, pathname] = uigetfile(str, 'Pick an peak list file to load',g.lastfolder);
        if isequal(filename,0) || isequal(pathname,0)
           disp('User pressed cancel')
           return;
        else
           fname=fullfile(pathname, filename);
            disp(['User selected ', fname]);   
        end
g.lastfolder=pathname;
d.p.peaktable=readtable(fname);
        
switch source.UserData(1)
    case 1
                switch g.selectedtrace
                case 0
                    d.ph.peaktable=d.p.peaktable;
                case 1
                    d.pv.peaktable=d.p.peaktable;
                end
            d.overlayselectedpeaks(g.b1c.t4c.bc.ax1,g.b1c.t4c.bc.tb1);
            d.addmenut(g.f,g.b1c.t4c.bc.tb1,s);
            g.selectedbutton=1; 
            
    case 2
           switch g.selectedtrace
                case 0
                    d.pL.peaktable=d.p.peaktable;
                case 1
                    d.pN.peaktable=d.p.peaktable;
             end
            d.overlayselectedpeaks(g.b2c.t4c.bc.ax1,g.b2c.t4c.bc.tb1);
            d.addmenut(g.f,g.b2c.t4c.bc.tb1,s);
            g.selectedbutton=1; 
            
    case 3
            switch g.selectedtrace
                case 0
                    d.ph.peaktable=d.p.peaktable;
                case 1
                    d.pv.peaktable=d.p.peaktable;
                end
            d.overlayselectedpeaks(g.b3c.t4c.bc.ax1,g.b3c.t4c.bc.tb1);
            d.addmenut(g.f,g.b3c.t4c.bc.tb1,s);
            g.selectedbutton=1; 
   end 

end

function load_setup_image(source,callbackdata)
global g
if source.Value
 if g.lastfolder==0   
     g.lastfolder='c:/'
 end
[filename, pathname] = uigetfile('*.jpg', 'Pick a image file for the test setup',g.lastfolder);
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
        fname=fullfile(pathname, filename);
       disp(['User selected ', fname]);
    end
    g.lastfolder=pathname;
     switch source.UserData(1)
         case 5
              switch source.UserData(3)
                    case 11
                        g.ESD_img.Data{1}=imresize(imread(fname),[500 NaN]);
                         g.ESD_img.Name{1}=filename;
                                
                              g.ESD_f(1)=figure('Visible','off');
                         h=imshow(g.ESD_img.Data{1});
                       set(h,'ButtonDownFcn',@esd_location); 
                        g.rpt.image{1}=g.ESD_f(1);
                       
                    case 12
                        g.ESD_img.Data{2}=imresize(imread(fname),[500 NaN]);
                         g.ESD_img.Name{2}=filename;
                                
                              g.ESD_f(2)=figure('Visible','off');
                         h=imshow(g.ESD_img.Data{2});
                       set(h,'ButtonDownFcn',@esd_location); 
                        g.rpt.image{2}=g.ESD_f(2);
                    case 13
                      g.ESD_img.Data{3}=imresize(imread(fname),[500 NaN]);
                         g.ESD_img.Name{3}=filename;
                                
                              g.ESD_f(3)=figure('Visible','off');
                         h=imshow(g.ESD_img.Data{3});
                       set(h,'ButtonDownFcn',@esd_location); 
                        g.rpt.image{3}=g.ESD_f(3);
                     case 14
                       g.ESD_img.Data{4}=imresize(imread(fname),[500 NaN]);
                         g.ESD_img.Name{4}=filename;
                           g.ESD_f(4)=figure('Visible','off');
                         h=imshow(g.ESD_img.Data{4});
                       set(h,'ButtonDownFcn',@esd_location); 
                        g.rpt.image{4}=g.ESD_f(4);
                     case 15
                        g.ESD_img.Data{5}=imresize(imread(fname),[500 NaN]);
                         g.ESD_img.Name{5}=filename;
                                
                         g.ESD_f(5)=figure('Visible','off');
                         h=imshow(g.ESD_img.Data{5});
                        set(h,'ButtonDownFcn',@esd_location);
                        g.rpt.image{5}=g.ESD_f(5);
              end
              if ~isempty(g.ESD_img.Name)
                    for i=1:length(g.ESD_img.Name)
                          tmp{i}=['Image: ' g.ESD_img.Name{i} ];
                    end
                     g.b5c.t2c.bc.btc.bt12.String=tmp;
              end
              
                
         otherwise
                 
                switch source.UserData(3)
                    case 11
                        g.rpt.image{1}=fname;
                    case 12
                        g.rpt.image{2}=fname;
                    case 13
                        g.rpt.image{3}=fname;
                     case 14
                        g.rpt.image{4}=fname;
                        case 15
                        g.rpt.image{5}=fname;
                end
     end
     
msgbox('setup image is loaded');
else 
    switch source.UserData(3)
    case 11
        g.rpt.image{1}=[];
    case 12
        g.rptimage{2}=[];
    case 13
        g.rpt.image{3}=[];
    case 14
       g.rpt.image{4}=[];
    case 15
       g.rpt.image{5}=[];
end
    
end
end



function Bt_1_4_11_save(source,callbackdata)
global d
d.save;
end

function Bt_1_4_12_load(source,callbackdata) %721
global d
global g
global s

d.load
switch source.UserData(1)
    case 1 % RE
            switch g.selectedtrace
                case 0
                    d.p=d.ph;
                case 1
                    d.p=d.pv;

            end
            if ~isempty(d.p)
             d.overlay_peaktable2(g.b1c.t4c.bc.ax1,g.b1c.t4c.bc.tb1);
             d.addmenut(g.f,g.b1c.t4c.bc.tb1,s);
            end
             g.selectedbutton=2;      
    case 2
                    switch g.selectedtrace
                case 0
                    d.p=d.pL;
                case 1
                    d.p=d.pN;

            end
             d.overlay_peaktable2(g.b2c.t4c.bc.ax1,g.b2c.t4c.bc.tb1);
            d.addmenut(g.f,g.b2c.t4c.bc.tb1,s);

             g.selectedbutton=2; 
    case 3  %OATs
        
           msgbox('3 Meter Precan result is modified by 10dB to simulate the baseline of 10 Meter OATs')
                     % Load the data from 3 meter chaber, Now change it from 3 meter to the
                     % 10 meter chamber mode d.lim change from 0 to 2. 
                     d.lim=2;
                     d.ph.result=d.ph.result-ones(size(d.ph.result))*10;
                     d.ph.maxhold=d.ph.maxhold-10;
                     d.ph.peak(:,2)=d.ph.peak(:,2)-10;
                     d.ph.peaktable.peaks=d.ph.peaktable.peaks-10;
                     d.ph.peakresult(4:6)=d.ph.peakresult(4:6)-10;
                     d.ph.peaktable2.Amplitude_dBuV=d.ph.peaktable2.Amplitude_dBuV-10;
                     d.ph.peaktable2.Peak_dBuV=d.ph.peaktable2.Peak_dBuV-10;
                     d.ph.peaktable2.QuasiPeak_dBuV=d.ph.peaktable2.QuasiPeak_dBuV-10;
                     d.ph.peaktable2.Average_dBuV=d.ph.peaktable2.Average_dBuV-10;
                     d.ph.peakrbw
                     d.ph.type='OAT'
                     d.pv.result=d.pv.result-ones(size(d.pv.result))*10
                     d.pv.maxhold=d.pv.maxhold-10;
                     d.pv.peak(:,2)=d.pv.peak(:,2)-10;
                     d.pv.peaktable.peaks=d.pv.peaktable.peaks-10;
                     d.pv.peakresult(4:6)=d.pv.peakresult(4:6)-10;
                     d.pv.peaktable2.Amplitude_dBuV=d.pv.peaktable2.Amplitude_dBuV-10;
                     d.pv.peaktable2.Peak_dBuV=d.pv.peaktable2.Peak_dBuV-10;
                     d.pv.peaktable2.QuasiPeak_dBuV=d.pv.peaktable2.QuasiPeak_dBuV-10;
                     d.pv.peaktable2.Average_dBuV=d.pv.peaktable2.Average_dBuV-10;
                     
                     d.pv.type='OAT'
                     
                     
            switch g.selectedtrace
                case 0
                    d.p=d.ph;
                case 1
                    d.p=d.pv;

            end
            d.overlay_peaktable2(g.b3c.t4c.bc.ax1,g.b3c.t4c.bc.tb1);
            d.addmenut(g.f,g.b3c.t4c.bc.tb1,s);

             g.selectedbutton=2; 
             
           
             
             
             
             
end

end
function Bt_1_4_13_measure(source,callbackdata)
global d
global g
global s
switch source.UserData(1)
    case {1} % RE
            switch g.selectedtrace
                case 0
                    d.p=d.ph;
                case 1
                    d.p=d.pv;
            end

            s.sa.peaktable=d.p.peaktable;

            %load the peaktabel into emi receiver. 

            %complete the remeasure
                d.p.resultHscan=s.remeasureRE();
                d.p.peakresult=s.sa.peakresult;
                d.p.peaktable=s.sa.peaktable;
             % Create the result table. 
                d.creat_peaktable2('RE');



            switch g.selectedtrace
                case 0
                    d.ph=d.p;
                case 1
                    d.pv=d.p;

            end
                     d.overlay_peaktable2(g.b1c.t4c.bc.ax1,g.b1c.t4c.bc.tb1);
                  % enable the uimenu on table
                       d.addmenut(g.f,g.b1c.t4c.bc.tb1,s);
                    g.selectedbutton=2;  
    case 2 % CE
              switch g.selectedtrace
                case 0
                    d.p=d.pL;
                case 1
                    d.p=d.pN;
            end

            s.sa.peaktable=d.p.peaktable;

            %load the peaktabel into emi receiver. 

            %complete the remeasure
                 s.remeasureCE;
                d.p.peakresult=s.sa.peakresult;
                d.p.peaktable=s.sa.peaktable;
             % Create the result table. 
                d.creat_peaktable2('CE');
            switch g.selectedtrace
                case 0
                    d.pL=d.p;
                case 1
                    d.pN=d.p;

            end
                     d.overlay_peaktable2(g.b2c.t4c.bc.ax1,g.b2c.t4c.bc.tb1);
                  % enable the uimenu on table
                    d.addmenut(g.f,g.b2c.t4c.bc.tb1,s);
                    g.selectedbutton=2; 
                    
    case 3
              switch g.selectedtrace
                case 0
                    d.p=d.ph;
                case 1
                    d.p=d.pv;
              end
              

            s.sa.peaktable=d.p.peaktable;

            %load the peaktabel into emi receiver. 

            %complete the remeasure
                d.p.resultHscan=s.remeasureRE();
                d.p.peakresult=s.sa.peakresult;
                d.p.peaktable=s.sa.peaktable;
             % Create the result table. 
                d.creat_peaktable2('OAT');



            switch g.selectedtrace
                case 0
                    d.ph=d.p;
                case 1
                    d.pv=d.p;

            end
                     d.overlay_peaktable2(g.b3c.t4c.bc.ax1,g.b3c.t4c.bc.tb1);
                  % enable the uimenu on table
                       d.addmenut(g.f,g.b3c.t4c.bc.tb1,s);
                    g.selectedbutton=2; 
                    delete(g.b3c.t4c.bc.ax1.Children(5));
                    set(g.b3c.t4c.bc.ax1,'XScale','lin');
                    
        
end

    
           
end
 
 

function T3=formattableforprint(T)
                        T1=table2cell(T);
                        Name= {'Frequency    (Hz)','Amplitude (dBuV)','TurnTable (degree)',...
                       'Tower (cm)','Polar','QuasiPeak (dBuV)','Peak (dBuV)',...
                       'Avg (dBuV)','DeltQ (dB)','DeltP (dB)','DeltA (dB)'};
            
                        T11={};
                        [mm nn]=size(T1);
                        for i=1:mm
                            for j=1:nn
                           T11{i,j}=num2str(T1{i,j},'%10.1f');
                            end
                        end
                        for i=1:mm
                            if T1{i,5}
                                T11{i,5}='V';
                            else 
                                T11{i,5}='H';
                            end
                        end
                        
                        T2=[Name;T11];T3=cell2table(T2);     
                        T3.Properties.VariableNames={'Freq_Hz','Amplitude_dBuV','TurnTable_degree',...
                       'Tower_cm','Polar','QuasiPeak_dBuV','Peak_dBuV',...
                       'Average_dBuV','DeltQ_dB','DeltP_dB','DeltA_dB'};
                       
end

function CI_deletetableitem (source, data)
global g
tb=g.b4c.t2c.bc.btc.tb1;
    id=unique(tb.UserData(:,1))';
    
if isempty(id)
    msgbox('please select the frequncy to delete')
else
    temp=tb.Data;
    temp(id,:)=[];
    g.b4c.t2c.bc.btc.tb1.Data=temp;
end


end
function RI_deletetableitem (source, data)
global g
tb=g.b8c.t2c.bc.btc.tb1;
    id=unique(tb.UserData(:,1))';
    
if isempty(id)
    msgbox('please select the frequncy to delete')
else
    temp=tb.Data;
    temp(id,:)=[];
    g.b8c.t2c.bc.btc.tb1.Data=temp;
end


end

function ESD_Measure(source,data)
global g
global s
switch source.UserData(3)
    case 14
     g.p2.Selection = 3;
    case 12 %pop up menu for picture selection
           id=source.Value;
            if ~isempty(g.ESD_f) 
                   for i=1:length(g.ESD_f)
                   set(g.ESD_f(i),'Visible','off');
                   end
             set( g.ESD_f(id),'Visible','on');
            end
         
    case 1 %select contact discharge
         g.b5c.t2c.bc.btc.bt1.Value=1;
         g.b5c.t2c.bc.btc.bt2.Value=0;
         g.esd.tb=g.b5c.t2c.bc.btc.tb1;
         
    case 2 %select air discharge. 
           g.b5c.t2c.bc.btc.bt1.Value=0;
         g.b5c.t2c.bc.btc.bt2.Value=1;
          g.esd.tb=g.b5c.t2c.bc.btc.tb2;
    case {8,11} % mark the frequecny
  %      colergen = @(color,text) ['<html><table border=0 width=400 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </tabletable border=0 width=400 bgcolor=',color,'><TR><TD>',text,'</TD></TR> </table></html>'];
         colergen = @(color,text) ['<html><font color=',color,'>',text,'</font></html>'];
   
       tb=g.esd.tb.Data;
        xy=g.esd.tb.UserData;
        for i=1:size(xy,1)
         switch g.b5c.t2c.bc.btc.bt11.Value
             case 1
                 tb{xy(i,1),xy(i,2)}= 'A';
                 %colergen('#00FF00','Green');
%                  data = {  2.7183        , colergen('#FF0000','Red')
%                     'dummy text'   , colergen('#00FF00','Green')
%                    3.1416         , colergen('#0000FF','Blue')
%                         }
              case 2
                 tb{xy(i,1),xy(i,2)}='B';
             case 3
                 tb{xy(i,1),xy(i,2)}=colergen('#0000FF','C');
             case 4
                 tb{xy(i,1),xy(i,2)}=colergen('#FF0000','D');
             case 5
                 tb{xy(i,1),xy(i,2)}= 'N/A';
         end
        end
         g.esd.tb.Data=tb;
                 
end


end

function esd_location(h,eventdata)
global g
switch  eventdata.Button
    case 1
            g.esd.num=g.esd.num+1;
            ax=gca;
            ax.Units='pixels';
            xa=xlim;
            ya=ylim;
            b=ax.Position;
            rx=b(3)/(xa(2)-xa(1));
            ry=b(4)/(ya(2)-ya(1));
            
            if  g.b5c.t2c.bc.btc.bt1.Value
            g.esd.mtextbox(g.esd.num)=uicontrol('style','text',...
                 'BackgroundColor','r','ForegroundColor','w','ButtonDownFcn',@deleteself,'Units','pixels');
            else
                      g.esd.mtextbox(g.esd.num)=uicontrol('style','text',...
                 'BackgroundColor','w','ForegroundColor','r','ButtonDownFcn',@deleteself,'Units','pixels');
            end
            
            g.esd.mtextbox(g.esd.num).String=num2str(g.esd.num);
            %x=ax.CurrentPoint(1,1)+ax.Position(1)-15;
            x=ax.CurrentPoint(1,1)*rx+ax.Position(1)-10; %esdesd
            y=b(4)-ax.CurrentPoint(1,2)*ry+b(2)-15*ry
            g.esd.mtextbox(g.esd.num).Units='pixels';
            %g.esd.mtextbox(g.esd.num).Units='normalized';
            g.esd.mtextbox(g.esd.num).Position=[ x y 20 15];
            tb=g.esd.tb.Data;
            if  g.b5c.t2c.bc.btc.bt1.Value
                   tb1={'Contact Discharge',g.esd.num,'A','A','A','A','Pass.-Normal Performance within specified limits.'};
             else
                   tb1={'Air Discharge',g.esd.num,'A','A','A','A','A','A','A','Pass.-Normal Performance within specified limits.'};
             end
                
            if isempty(tb)
            tb2=tb1;
            else
            tb2=[tb;tb1];
            end
            
            g.esd.tb.Data=tb2;
            
end
            
end

function deleteself(h,eventdata)
global g
tb1=g.b5c.t2c.bc.btc.tb1.Data;
tb2=g.b5c.t2c.bc.btc.tb2.Data;

switch eventdata.Source.Parent.SelectionType
    case 'alt'
    id=str2num(h.String);
        delete(h);
    
end

for i=3:size(tb1,1)
  if tb1{i,2}==id
     tb1(i,:)=[];
     g.b5c.t2c.bc.btc.tb1.Data=tb1;
     return;
  end
end
 
 
for i=1:size(tb2,1)
  if tb2{i,2}==id
     tb2(i,:)=[];
      g.b5c.t2c.bc.btc.tb2.Data=tb2;
     return;
  end
end
   
  


end

function deleteESD_f(h, eventdata)

global g
delete(h);
g.ESD_f=[];
 g.rpt.image=[];
end



