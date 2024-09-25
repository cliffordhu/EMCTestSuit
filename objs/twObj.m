classdef twObj < handle
    
    properties (Access =public)
        address=9;
        Default_Height=150;
        status='Closed';
        tw=[];
        p=[];
        polar=[];
        opc_status;
        IDN='MY00153245';      
    end
    
    methods
          function s=twObj
          end
        function setaddress(s,a)
            s.address=a;
        end
        function ini(s)
            s.tw = gpib('agilent',7,s.address);
            s.tw.Timeout=20;
            
              % ni means National Instruments
              % 1 is the board number, maybe 0 on other computers
              % 18 is the instrument address

            % open the session object 
            pause(0.1);
            s.tw.InputBufferSize=512;
            %tb.Timeout=60
            try
                fopen(s.tw);
                fprintf(s.tw,'P?');
                s.polar=-1*(str2num(fscanf(s.tw))-1);
            catch me
              msgbox('ERROR: Antenna Tower is not connected successfully! Please check address and connection!')
            end
            
            % Test if it is open
            % Test if it is open
            s.status = get(s.tw, 'Status')

            
           
        end
            function opc_status=opc(s)
            fprintf(s.tw,'*OPC?');
            opc_status=str2num(strtrim(fscanf(s.tw)));
            s.opc_status=opc_status;
            end
        
        function p1=cp(s)
            fprintf(s.tw,'CP?');
            p=fscanf(s.tw);
            s.p=str2num(strtrim(p));
            p1=s.p;
        end
        function stop(s)
           fprintf(s.tw,'ST');
        end
        function up(s)
            fprintf(s.tw,'UP');
        end
        function down(s)
            fprintf(s.tw,'DN');
        end
        function scan(s,cycle)
             fprintf(s.tw, ['CY ' num2str(cycle)]);
            fprintf(s.tw,'SC');
        end
        
        function setspeed(s,speed)
            
            fprintf(s.tw,['SS1 ' num2str(speed) ]);
            fprintf(s.tw,'S1');
        end
        function sk(s,pos)
            fprintf(s.tw,['SK ' num2str(pos)]);
        end
        function skr(s,pos)
            fprintf(s.tw,['SKR ' num2str(pos)]);
        end
        function skn(s,pos)
            fprintf(s.tw,['SKN ' num2str(pos)]);
        end
        function skp(s,pos)
            fprintf(s.tw,['SKP ' num2str(pos)]);
        end
        
        function setlimit(s, lim)
            fprintf(s.tw,['LH ' num2str(lim(1))]);
            fprintf(s.tw,['LV ' num2str(lim(1))]);
            fprintf(s.tw,['LL ' num2str(lim(1))]);
            
            fprintf(s.tw,['UH ' num2str(lim(2))]);
            fprintf(s.tw,['UV ' num2str(lim(2))]);
            fprintf(s.tw,['UL ' num2str(lim(2))]);   
        end
        
        function calibration(s)
          x=inputdlg('Please input the Anntenna Height for calibration in cm',...
                      'Antenna Height Calibration',[1 20]);
                  
          fprintf(s.tw,['CP ' strtrim(x{:})]);   
        
        end
        function reset_tw(s)
            pos=s.Default_Height;
           fprintf(s.tw,['SK ' num2str(pos)]);
        end
        
        function setpolar(s,dir)
            if dir
               fprintf(s.tw,'PV');
               s.polar=1;
            else 
               fprintf(s.tw,'PH');   
               s.polar=0;
            end
        end
        
    end
    
end

