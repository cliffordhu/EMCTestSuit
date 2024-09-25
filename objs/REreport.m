function REreport
global g
global d

% RE create report header

    str=['RE 3M Chamber _' g.b1c.t5c.rx1.String ' ' g.b1c.t5c.rx2.String ' ' g.b1c.t5c.rx3.String];
 
    %choose where to save%choose file  
    [filename, pathname] = uiputfile([g.lastfolder str '.docx'], 'Save into Word file');
        if isequal(filename,0) || isequal(pathname,0)
           disp('User pressed cancel')
           return;
        else
            fname=fullfile(pathname, filename);
            disp(['User selected ', ]);   
        end
        g.lastfolder=pathname;
       save([fname(1:end-4) 'mat'],'d');
    g.rpt.open(fname,'RE');
               %Section 1 Configuration setup
               % 1.1 table test requpiment
                    T1=readtable('./configuration/REconfiguration.xlsx');
                    g.rpt.p1t1=g.rpt.table(T1);
                %1.2 table enviroment condition
                   g.rpt.p1t2=g.rpt.text(['Temperature: ' g.tx4.String  ';   Humidity :' g.tx6.String ]);
               %1.3 table operator and date
                   g.rpt.p1t3=g.rpt.text(['Operator: ' g.tx21.String{g.tx21.Value} ...
                                     ';        Report generated at: ' date ]);
            %Section 2 Product information 
                 %2.1 table

                    T2=readtable('./configuration/REreportheader.xlsx');
                    g.rpt.p2t1=g.rpt.table(T2);

             %Section 3 EUT setup
                  %3.1  photo
                  g.rpt.loadpic;

            %section 4 result
                 % 4.1 write the test result in table format 4.1. 
                  g.rpt.p4t1=[];g.rpt.p4f1=[];g.rpt.p4f2=[];g.rpt.p4f3=[];g.rpt.p4f4=[];g.rpt.p4f5=[];
                    if g.b1c.t5c.bc.chk1.Value
                        if isfield(d.ph,'peaktable2')
                          T3=formattableforprint(d.ph.peaktable2);
                          g.rpt.p4t1=g.rpt.table(T3);
                        end 
                         %4.2 insert the plot into 4f1 to 4 f5
                        f1=figure;f1.Position=[130 220 900 550];
                        d.p=d.ph;
                        d.view2D(gca);
                       if isfield(d.ph,'peaktable2')
                         d.overlay_peaktable2(gca,-1);
                         l=legend('Limit 3M Grp1-A',...
                             '6 dB Margin','Horizontal Scan','Pre-scan Peak','Re-measured Peak','QuasiPeak','Average');
                         l.Location='Southeast'; 
                       else
                         l=legend('Limit 3M Grp1-A',...
                             '6 dB Margin','Horizontal Scan');
                         l.Location='Southeast'; 
                           
                       end
                       g.rpt.p4f1=g.rpt.Image2(f1,1);
                        close(f1);  
                    end
                           
                    if g.b1c.t5c.bc.chk2.Value
                      if isfield(d.pv,'peaktable2')
                        T3=formattableforprint(d.pv.peaktable2);
                        g.rpt.p4f2=g.rpt.table(T3);
                      end
                      f2=figure;f2.Position=[130 220 900 550];
                        d.p=d.pv;
                        d.view2D(gca);
                      
                      if isfield(d.pv,'peaktable2')
                        d.overlay_peaktable2(gca,-1);
                          l=legend('Limit 3M Grp1-A',...
                             '6 dB Margin','Vertical Scan','Pre-Scan Peak','Re-measured Peak','QuasiPeak','Average');
                         l.Location='Southeast'; 
                      else
                          l=legend('Limit 3M Grp1-A',...
                             '6 dB Margin','Vertical Scan');
                         l.Location='Southeast'; 
                          
                      end
                      
                        g.rpt.p4f3=g.rpt.Image2(f2,2);
                        close(f2)
                    end
                     if g.b1c.t5c.bc.chk3.Value
                         f3=figure;f3.Position=[130 220 800 600];
                        %d.p=d.pv;
                        d.view3D(gca,0);
                        title('Horizontal Scan 3D view');
                         g.rpt.p4f4=g.rpt.Image2(f3,3);
                        close(f3)
                        
                     end
                     
                      if g.b1c.t5c.bc.chk4.Value
                        f3=figure;f3.Position=[130 220 800 600];
                        %d.p=d.pv;
                        d.view3D(gca,1);
                        title('Vertical Scan 3D view');
                         g.rpt.p4f5=g.rpt.Image2(f3,4);
                        close(f3)
                     end
                     
                 
                 
                    
            %Section 5 Summary 
            if isfield(d.ph,'peakresult')
                if max(max(d.ph.peakresult(:,7:9)))>0
                  str= 'The unit failed the Radiated Emission Test in the horizontal polarization!';
                   g.rpt.p5t1=g.rpt.text(str);
                   g.rpt.p5t1.Color='red';
                else 
                  str= 'The Device Under Test (DUT) passed the Radiated Emission Test in the horizontal polarization.';
                  g.rpt.p5t1=g.rpt.text(str);
                 % g.rpt.p5t1.Color='green';
                end
            else
                  str= 'The Device Under Test (DUT) passed the Radiated Emission Test in the horizontal polarization.';           
                  g.rpt.p5t1=g.rpt.text(str);
                 %g.rpt.p5t1.Color='green';
            end
            
            if isfield(d.pv,'peakresult')
                if max(max(d.pv.peakresult(:,7:9)))>0
                  str1= 'The Device Under Test (DUT) Faied the Radiated Emission Test in the vertical polarization.';
                  g.rpt.p5t2=g.rpt.text(str1);
                  g.rpt.p5t2.Color='red';
                else 
                  str1= 'The Device Under Test (DUT) passed the Radiated Emission Test in the vertical polarization.';
                  g.rpt.p5t2=g.rpt.text(str1);
                %  g.rpt.p5t2.Color='green';
                end
            else
                  str1='The Device Under Test (DUT) passed the Radiated Emission Test in the vertical polarization.';            
                  g.rpt.p5t2=g.rpt.text(str1);
                % g.rpt.p5t2.Color='green';
            end
            
                    % generate random white space to create unique header for each
        % report so that at the time of integration, the auto numbering
        % function would work correctly. It will counting the page number
        % using this unique (header+random (white space)) 
            str=[]
            n=randi(20,1,1);
             for i=1:n
                 str=[str ' '];
             end
            g.rpt.p7t1=g.rpt.text(str);
            g.rpt.p7t2=g.rpt.text(str);
            g.rpt.p7t3=g.rpt.text(str);
            g.rpt.p7t4=g.rpt.text(str);
            g.rpt.p7t5=g.rpt.text(str);
            

            g.rpt.fill;

            g.rpt.close
            g.rpt.view

        
    %save the file into default
   % writetable(T,fname);
    msgbox(['Test Report is succesfully saved into' fname]);
end
function T3=formattableforprint(T)
                        T1=table2cell(T);
                        Name= {'Freq (Hz)','Prescan (dBuV/m)','TurnTable (degree°)',...
                                       'Tower (cm)','Polarization','Peak (dBuV/m)','QuasiP (dBuV/m)',...
                                       'Avg. (dBuV/m)','▲Peak (dB)','▲QuasiP (dB)','▲Avg. (dB)'};
            
                        T11={};
                        [mm nn]=size(T1);
                        for i=1:mm
                            for j=1:nn
                           T11{i,j}=num2str(T1{i,j},'%10.1f');
                            end
                        end
                        for i=1:mm
                            if T1{i,5}
                                T11{i,5}='Vertical';
                            else 
                                T11{i,5}='Horizontal';
                            end
                        end
                        
                        T2=[Name;T11];T3=cell2table(T2);     
                        T3.Properties.VariableNames={'Freq_Hz','Amplitude_dBuV','TT_pos','TW_pos','Polarization','Peak_dBuV','QuasiPeak_dBuV',...
                       'Average_dBuV','DeltP_dB','DeltQ_dB','DeltA_dB'};
                       
end

    