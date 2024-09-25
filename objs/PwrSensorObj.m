classdef PwrSensorObj < handle
    % this Obj cover both function generator 33120A when the type is set to
    % 'lf' and the E4420B for high frequency generator when type is set to
    % 'hf'.
    
    properties
      address='USB0::0x0957::0x2D18::MY48400223::0::INSTR';
      status='closed';
      ps=[];% power sensor object
      amp=[];
      opc_status;
      IDN='';
      
    end
    
    methods
        function s=PwrSensorObj
            
            
        end
        function ini(s)
          
             s.ps = visa('agilent',s.address);
              % ni means National Instruments
              % 1 is the board number, maybe 0 on other computers
              % 18 is the instrument address

            % open the session object 
            pause(0.1);
            s.ps.InputBufferSize=51200;
            s.ps.Timeout=30;
            try
                fopen(s.ps);
                fprintf(s.ps,'*RST');fprintf(s.ps,'*CLS');
                fprintf(s.ps,'SYST:PRES DEF');
                fprintf(s.ps,'FORM ASC');
                fprintf(s.ps,'INIT:CONT ON');
                fprintf(s.ps,'*IDN?');
                IDN=fscanf(s.ps) ;
                tmp=strsplit(IDN,',');
                s.IDN=strtrim(tmp{3});
            catch me
               msgbox('Error: PowerSensor is not connected successfully! Please Check Address and Connection!')
            end
            s.status = get(s.ps, 'Status');
            
        end
        function x=read(s,freq)
         %fprintf(s.ps,'SYST:PRES BURST'); pause(0.1)
         try
             fprintf(s.ps,['FREQ ' num2str(freq)]); pause(0.1);
             fprintf(s.ps,'INIT:CONT ON'); pause(0.1);
             x1=[];
             for i=1:5
                 fprintf(s.ps,'FETC?');
                 %fprintf(s.ps,'MEAS?');
                 x2=str2num(fscanf(s.ps));
                 x1=[x1 x2];
                 while ~s.opc
                 end
             end
             x=mean(x1);
              s.amp=x;
         catch err
             s.amp=[];
         end
         
        end
       function opc_status=opc(s)
            fprintf(s.ps,'*OPC?');
            opc_status=str2num(strtrim(fscanf(s.ps)));
            s.opc_status=opc_status;
      end
        
    end
    
end
