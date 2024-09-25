

classdef  HI6005 < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        address='COM7';
        status='close';
        probe=[];
        bt=0;
        x=0;y=0;z=0;c=0;
        avgFactor=8;
    end
    
    methods
        function obj=HI6005


        end
        function obj=ini(obj)
                obj.probe = serial(obj.address);
                set(obj.probe,'BaudRate',9600)
                set(obj.probe,'StopBits',1)
                set(obj.probe,'Parity','odd')
                set(obj.probe,'DataBits',7)
                set(obj.probe,'Terminator','CR')
                fopen(obj.probe);
                obj.status=get(obj.probe,'Status');

        end 
        function close(obj)
        fclose(obj.probe);
        obj.status=get(obj.probe,'Status');
        
        end
        function result=battery(obj)
            fprintf(obj.probe,'BP')
            a=fscanf(obj.probe);
            b=str2num(a(4:end));
            result=(b-4)/0.8*100;
            obj.bt=result;
        end
        
        function result=read(obj)
            fprintf(obj.probe,'D5');
            a=fscanf(obj.probe);
            
                    if a(23)=='N'
                        x1=[];y1=[];z1=[];c1=[];
                        for i=1:obj.avgFactor
                            fprintf(obj.probe,'D5');
                            a=fscanf(obj.probe);
                            x1=[x1;str2num(a(3:7))];
                            y1=[y1;str2num(a(8:12))];
                            z1=[z1;str2num(a(13:17))];
                            c1=[c1;str2num(a(18:22))];
                            
                        end
                        x=mean(x1);y=mean(y1);z=mean(z1);c=mean(c1);
                        
                    else
                        x=0;y=0;z=0;c=0;
                    end
             result=[x y z c];
            obj.x=x;obj.y=y;obj.z=z;obj.c=c;
            
        end
        function plot(obj)
               
                tic;
                h=figure
                 x=[toc obj.read];
                lin=plot(x(:,1),x(:,end));
                 
                grid on;hold on;
                xlabel('Time (S)');
                ylabel('Voltage (Volts/meter) ');
     
                DlgH = figure;
                H = uicontrol('Style', 'PushButton', ...
                    'String', 'Break', ...
                    'Callback', 'delete(gcbf)');
                while (ishandle(H))
                  x=[x ;toc obj.read];
                  lin.XData=x(:,1);
                  lin.YData=x(:,end);
                  drawnow
                    
                end
                
          end
       
        
    end
end
