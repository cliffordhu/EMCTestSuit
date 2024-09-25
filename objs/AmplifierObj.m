classdef AmplifierObj < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
     address=2;
     amp
     status='Closed';
     opc_status;
     sw=[];
    end
    
    methods
        function s=AmplifierObj
            
        end
        function ini(s)
            s.amp = gpib('agilent',7,s.address);
            s.amp.InputBufferSize=512;
            fopen(s.amp);
            s.status=get(s.amp,'Status');
          
        end
        function close(s)
         fclose(s.amp);
         s.status=get(s.amp,'Status');
        end
        function on(s)
            fprintf(s.amp,'P1');
        end
        function off(s)
            fprintf(s.amp,'P0');
        end
        function gain(s,x)

            if x<0
                x=0;
            end
            if x>4095
                x=4085;
            end
            str=sprintf('%04d',x);
            fprintf(s.amp,['G' str]);
            
        end
        function IDN(s)
        
        end
        
    end
end

          