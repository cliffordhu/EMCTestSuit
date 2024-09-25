classdef ttObj < handle
    
    properties (Access =public)
        address=8;
        status='Closed';
        p;
        tb=[];
        opc_status;
        abs_rotation=0;
        abs_rotation_limit=1080;
        start_cp=0;
        abs_rotation_lower_limit=0;
        abs_rotation_upper_limit=360;
        IDN='MY00153241'
    end
    
    methods
          function s=ttObj
          end
        function setaddress(s,a)
            s.address=a;
        end
        function opc_status=opc(s)
            fprintf(s.tb,'*OPC?');
            opc_status=str2num(strtrim(fscanf(s.tb)));
            s.opc_status=opc_status;
        end
        
        function ini(s)

            s.tb = gpib('agilent',7,s.address);
              % ni means National Instruments
              % 1 is the board number, maybe 0 on other computers
              % 18 is the instrument address

            % open the session object 
            pause(0.1);
            s.tb.InputBufferSize=512;
            %tb.Timeout=60
            try
                 fopen(s.tb);
                 s.start_cp=s.cp; 
            catch me
              msgbox('ERROR: Turn Table is not connected successfully! Please check address and connection!')
             end
            
           
            % Test if it is open
            % Test if it is open
            s.status = get(s.tb, 'Status')

        end
     
        function p1=cp(s)
            fprintf(s.tb,'CP?');
            p=fscanf(s.tb);
            s.p=str2num(strtrim(p));
            p1=s.p;
        end
        function stop(s)
           fprintf(s.tb,'ST');
        end
        function cw(s)
            fprintf(s.tb,'CW');
        end
        function ccw(s)
            fprintf(s.tb,'CC');
        end
        function scan(s,cycle)
             fprintf(s.tb, ['CY ' num2str(cycle)]);
            fprintf(s.tb,'SC');
            start_cp=s.cp;
        end
        
        function setspeed(s,speed)
            
            fprintf(s.tb,['SS1 ' num2str(speed) ]);
            fprintf(s.tb,'S1');
        end
        function sk(s,pos)
            fprintf(s.tb,['SK ' num2str(pos)]);
        end
        function skr(s,pos)
            fprintf(s.tb,['SKR ' num2str(pos)]);
            s.abs_rotation=s.abs_rotation+pos;
                    
        end
        function skn(s,pos)
            fprintf(s.tb,['SKN ' num2str(pos)]);
        end
        function skp(s,pos)
            fprintf(s.tb,['SKP ' num2str(pos)]);
        end
        function reset_table(s)
          
%             s.setlimit([ -1*abs(s.abs_rotation) abs(s.abs_rotation)]) ;
%             s.skr(-1*s.abs_rotation);
%             fprintf(s.tb, ['CP ' num2str(s.start_cp)]); 
%             s.abs_rotation=0;
             s.sk(0);

        end
        function fastsk1(s,pt)
            s.setlimit([s.abs_rotation_lower_limit s.abs_rotation_upper_limit]);
            cp=s.cp;
             % prevent wire wrapping. when the accumlate rotation angle
            % reach maximu. reset. 

            
            if pt>cp
                 if (pt-cp)<180
                     s.skr(pt-cp);
                     
                 else 
                     if -360+pt-cp<=s.abs_rotation_lower_limit
                         s.skr(pt-cp);
                     else
                         s.skr(-360+pt-cp);
                      % re-set current position
                      while ~s.opc
                      end
                      fprintf(s.tb, ['CP ' num2str(pt)]);  
                      
                     end
                     
                 end
                    
            end
             
              if pt<=cp
                  if (cp-pt)<180
                      s.skr(pt-cp);
                      
                    else
                     
                     if 360+pt-cp>=s.abs_rotation_upper_limit
                         s.skr(pt-cp);    
                     else
                         s.skr(360+pt-cp);
                              % re-set current position
                          while ~s.opc
                          end
                          fprintf(s.tb, ['CP ' num2str(pt)]);  
                      
                     
                     end

                  end

    
              end
          s.setlimit([0 360]);
          end
        
        function fastsk(s,pt)
            s.setlimit([-45 720]);
            cp=s.cp;
            % prevent wire wrapping. when the accumlate rotation angle
            % reach maximu. reset. 
            if abs(s.abs_rotation)>s.abs_rotation_limit
                msgbox('Turntable needs to be reset to prevent wire tangling!')
            s.reset_table;
            end
            
                  if pt>cp
                 if (pt-cp)<180
                     s.skr(pt-cp);
                     
                 else 
                     s.skr(-360+pt-cp);
                     while ~s.opc
                     end
                     
                    fprintf(s.tb, ['CP ' num2str(pt)]);  

                 end
             end
              if pt<=cp
                  if (cp-pt)<180
                      s.skr(pt-cp);
                    else
                      s.skr(360+pt-cp);
                      while ~s.opc
                      end
                      fprintf(s.tb, ['CP ' num2str(pt)]);  

                  end
              end
   
        s.setlimit([0 360]);
        end
        
             
        function setlimit(s, lim)
            fprintf(s.tb,['WL ' num2str(lim(2))]);
            fprintf(s.tb,['CL ' num2str(lim(1))]);
            
            
        end
         function calibration(s)
          x=inputdlg('Please input the current turntable position in degree for calibration',...
                      'Turntable Position  Calibration',[1 20]);
                  
          fprintf(s.tb, ['CP ' strtrim(x{:})]);   
                      
         
        end
        
        
    end
    
end

