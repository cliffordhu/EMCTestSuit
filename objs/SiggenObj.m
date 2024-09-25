classdef SiggenObj < handle
    % this Obj cover both function generator 33120A when the type is set to
    % 'lf' and the E4420B for high frequency generator when type is set to
    % 'hf'.
    
    properties
      address='GPIB0::10::INSTR'
      gain=0;
      status='Closed';
      siggen=[]
      type='lf';
      opc_status;
      AM_freq=1000;
      AM_amp=80;
      IDN=''
       
    end
    
    methods
        function s=SiggenObj
            
        end
        function ini(s)
             s.siggen = visa('agilent',s.address);
              
              % ni means National Instruments
              % 1 is the board number, maybe 0 on other computers
              % 18 is the instrument address

            % open the session object 
            pause(0.1);
            s.siggen.InputBufferSize=512;
            %tb.Timeout=60
            try
                fopen(s.siggen);
                fprintf(s.siggen,'*IDN?');
                IDN=fscanf(s.siggen);
                tmp=strsplit(IDN,',');
                s.IDN=strtrim(tmp{3});
                if strcmp(s.IDN,'0')   
                   IDN=query(s.siggen,'CAL:STR?');
                   tmp=strsplit(IDN,',');
                   s.IDN=strtrim(tmp{3});
                
                end
                
            catch me
               msgbox('Error: Signal Generator is not connected successfully! Please Check Power, Address and Connection!')
            end
                
                s.status = get(s.siggen, 'Status')
         %   fprintf(s.siggen,'*RST');fprintf(s.siggen,'*CLS');
        end
        function freq(s,val)
            switch s.type
                case 'lf'
                fprintf(s.siggen,[':FUNCtion:SHAPe SIN']);
                 fprintf(s.siggen,[':FREQ ' num2str(val) ' HZ']);
                case 'hf'
                fprintf(s.siggen,['Freq ' num2str(val) ' HZ']);
            end
                
        end
        function amp(s,val) % for hf sig gen. use dbm. for lf sig gen, use dbm.
            switch s.type
                case 'lf'
                    fprintf(s.siggen,':VOLT:UNIT VRMS');
                    fprintf(s.siggen,[':VOLT ' num2str(val)]);
                case 'hf'
                    s.gain=val;
                    fprintf(s.siggen,['POW:AMPL ' num2str(val) ' dBm']);
            end
            
        end
        function AM_On(s) % val is am modulation precentage e.g. 20% would be 20.
            %fprintf(s.lfgen,['AM:DEPT 20']);
            fprintf(s.siggen,['AM:INTernal1:FREQuency ' num2str(s.AM_freq)]);
            fprintf(s.siggen,['AM:DEPT ' num2str(s.AM_amp)]);
            fprintf(s.siggen,['AM:STAT ON']);
            
        end
        function AM_Off(s) % val is am modulation precentage e.g. 20% would be 20.
            %fprintf(s.lfgen,['AM:DEPT 20']);
            
            %fprintf(s.lfgen,['AM:DEPT ' num2str(s)]);
            fprintf(s.siggen,['AM:STAT OFF']);
        end
        function On(s)
           fprintf(s.siggen,[':OUTPut ON']);
        end
        function Off(s)
           fprintf(s.siggen,[':OUTPut OFF']);
        end
       function opc_status=opc(s)
            fprintf(s.siggen,'*OPC?');
            opc_status=str2num(strtrim(fscanf(s.siggen)));
            s.opc_status=opc_status;
      end
    end
    
end
