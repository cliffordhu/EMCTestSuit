classdef PwrSensorObj < handle
    % this Obj cover both function generator 33120A when the type is set to
    % 'lf' and the E4420B for high frequency generator when type is set to
    % 'hf'.
    
    properties
      address='USB0::0x0957::0x2D18::MY47400241::0::INSTR';
      status='Closed';
      ps=[];% power sensor object
      amp=[];
    end
    
    methods
        function s=PwrSensorObj
            
        end
        function ini(s)
                        a=instrfind;
             for i=1:length(a)
              fclose(a(i));
             end 
          
             s.ps = visa('agilent',s.address);
              % ni means National Instruments
              % 1 is the board number, maybe 0 on other computers
              % 18 is the instrument address

            % open the session object 
            pause(0.1);
            s.ps.InputBufferSize=512;
            %tb.Timeout=60
            fopen(s.ps);
            s.status = get(s.ps, 'Status')
            fprintf(s.ps,'*RST');fprintf(s.ps,'*CLS');
        end
        function read(s)
             fprintf(s.ps,'FORM ASC');
         fprintf(s.ps,'INIT');
         fprintf(s.ps,'FETC?');
         s.amp=str2num(fscanf(s.ps));
                
        end
      
        
    end
    
end
