classdef SwObj < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
     address=9;
      gain='';
      status='Closed';
      opc_status;
      sw=[];
      data;
    end
    
    methods
        function s=SwObj
            
        end
        function ini(s)
                  
             s.sw = gpib('agilent',7,s.address);
              % ni means National Instruments
              % 1 is the board number, maybe 0 on other computers
              % 18 is the instrument address

            % open the session object 
            pause(0.1);
            s.sw.InputBufferSize=51200;
            %tb.Timeout=60
            fopen(s.sw);
            s.status = get(s.sw, 'Status')
         %   fprintf(s.siggen,'*RST');fprintf(s.siggen,'*CLS');
        end
        function voltDC(s,ch)
            str=regexprep(num2str(ch), '\s\s',',');
          fprintf(s.sw,['CONF:VOLT:DC (@' str ')']);
        end
        function voltAC(s,ch)
            str=regexprep(num2str(ch), '\s\s',',');
          fprintf(s.sw,['CONF:VOLT:AC (@' str ')']);
        end
        
        function res(s,ch)
            str=regexprep(num2str(ch), '\s\s',',');
          fprintf(s.sw,['CONF:RES (@' str ')']);
        end
        
        function currDC(s,ch)
            str=regexprep(num2str(ch), '\s\s',',');
            fprintf(s.sw,['CONF:CURR:DC (@' str ')']);
        end
        function currAC(s,ch)
            str=regexprep(num2str(ch), '\s\s',',');
            fprintf(s.sw,['CONF:CURR:DC (@' str ')']);
        end
        function temp(s,ch)
            str=regexprep(num2str(ch), '\s\s',',');
            fprintf(s.sw, ['CONF:TEMP TC,J,(@' str ')']);
        end
        
         function freq(s,ch)
            str=regexprep(num2str(ch), '\s\s',',');
            fprintf(s.sw, ['CONF:FREQ (@' str ')']);
        end
        function period(s,ch)
            str=regexprep(num2str(ch), '\s\s',',');
            fprintf(s.sw, ['CONF:PER (@' str ')']);
        end
        
        function monitor(s,ch)
            str=num2str(ch);
            fprintf(s.sw, ['ROUT:MON:CHAN (@' str ')']);
            fprintf(s.sw, ['ROUT:MON:STAT ON']);
            fprintf(s.sw, ['ROUT:SCAN (@' str ')']);

        end
                function val=monitordata(s)
            fprintf(s.sw, ['ROUT:MON:DATA?']);
            val=fscanf(s.sw);
                end
        
        function scale(s,ch,gain,offset,unit)
            str=num2str(ch);
            gain1=num2str(gain);
            offset1=num2str(offset);
             s.monitor(ch);
            fprintf(s.sw, ['CALC:SCALe:STATe ON,(@' str ')']);
            fprintf(s.sw, ['CALC:SCAL:GAIN ', gain1 ,',(@' str ')']);
            fprintf(s.sw, ['CALC:SCAL:OFFSet ', offset1 ,',(@' str ')']);
            fprintf(s.sw, ['CALC:SCALe:UNIT "',unit,'",(@' str ')']);
             
        end
           function scaleoff(s,ch)
            str=regexprep(num2str(ch), '\s\s',',');
             
            s.monitor(ch(1));
            fprintf(s.sw, ['CALC:SCALe:STATe OFF,(@' str ')']);
         
        end

        
        function data=scan(s,ch,trig)
          str=regexprep(num2str(ch), '\s\s',',');
          fprintf(s.sw, ['ROUT:SCAN (@', str,')']);
             fprintf(s.sw, ['TRIG:SOUR IMM' ]);
          if trig==0
              fprintf(s.sw, ['TRIG:COUN INF' ]);
          else
              fprintf(s.sw, ['TRIG:COUN ' num2str(trig)]);
          end
           fprintf(s.sw, 'INIT');
          while ~s.opc
          end
          %fprintf(s.sw,'FORMat:DATA INT,32\n') ;
           %    fprintf(s.sw,'FORMat:BORDer SWAPped');
               fprintf(s.sw,['FETC?']);
        %       [data, count] = binblockread(s.sw, 'int32');
                data1=str2num(fscanf(s.sw));
                n=length(ch);m=floor(length(data1)/n);
                data=reshape(data1,m,n)
               s.data=data;
               
        end
        function status=opc(s)
            status=1;
            fprintf(s.sw, '*OPC?');
            status=num2str(fscanf(s.sw));
        end
        
        function close(s)
          fprintf(s.sw,'ROUT:SCAN (@)');
          fclose(s.sw);
        end
        
    
    end
end

