classdef RS232Obj < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
     address='COM6';
     rs232
      status='Closed';
      opc_status;
      sw=[];
    end
    
    methods
        function s=RS232Obj
            
        end
        function ini(s)
          s.rs232=serial(s.address);
          s.rs232.Timeout=20;
          try
              fopen(s.rs232);
              s.rs232.DataTerminalReady='off';
          catch me
              msgbox('Error: RS232 Switch is not connected successfully! Please Reset the USB-RS232 Converter!')
          end          
          s.status=get(s.rs232,'Status');
            s.select(0);
            pause(0.5);
            s.select(1);
            pause(0.5);
            s.select(0);
            pause(0.5);
            
            
        end
        function close(s)
         fclose(s.rs232);
        end
        function select(s,ch)
            if ch
                s.rs232.DataTerminalReady='on';
            else 
                s.rs232.DataTerminalReady='off';
            end
        end
    end
end

          