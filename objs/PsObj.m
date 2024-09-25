classdef PsObj < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
     address=5;
      gain='';
      status='Closed';
      opc_status;
      ps=[];
    end
    
    methods
        function s=PsObj
            
        end
        function ini(s)
                  
             s.ps = gpib('agilent',7,s.address);
              % ni means National Instruments
              % 1 is the board number, maybe 0 on other computers
              % 18 is the instrument address

            % open the session object 
            pause(0.1);
            s.ps.InputBufferSize=512;
            %tb.Timeout=60
            fopen(s.ps);
            s.status = get(s.ps, 'Status')
         %   fprintf(s.siggen,'*RST');fprintf(s.siggen,'*CLS');
        end
        function volt(s,val)
        fprintf(s.ps,['VOLT ' num2str(val) ]);
        
        end
        function curr(s,val)
        fprintf(s.ps,['CURR ' num2str(val) ]);
        end
        
        function on(s)
%          fprintf(s,['TRIG:SOUR IMM']);
%          fprintf(s,['INIT']);
         fprintf(s.ps,['OUTPut ON']);
            
        end
        function off(s)
         fprintf(s.ps,['OUTPut OFF']);
        end
        
        function voltup(s,step)
            str=['VOLT:STEP ' num2str(step)];
           fprintf(s.ps,str) ;
           str=['VOLT UP'];
           fprintf(s.ps,str) ;
        end
          
         function voltdown(s,step)
            str=['VOLT:STEP ' num2str(step)];
           fprintf(s.ps,str) ;
           str=['VOLT DOWN'];
           fprintf(s.ps,str) ;
         end
          
                
    
    end
end

