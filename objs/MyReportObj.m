classdef MyReportObj <handle  %< mlreportgen.dom.Document
    %MYREPORT defines a customize letter to customers
    %   
    % rpt = MyReport('mydoc','docx','CustomerLetter');
    % rpt.CustomerName = 'Smith';
    % fill(rpt);
    
    properties
       rpt;
       p1t1; p1t2; p1t3;
      p2t1;
      p3f1;p3f2;p3f3;p3f4;p3f5;
      p4t1;p4f1;p4f2;p4f3;p4f4;p4f5;
      p5t1;p5t2;
      p7t1;p7t2;p7t3;p7t4;p7t5;
      templateRE='./configuration/REtemplate.dotx';
      templateCE='./configuration/CEtemplate.dotx';
      templateOAT='./configuration/OATtemplate.dotx';
      templateCI='./configuration/CItemplate.dotx';
      templateRI='./configuration/RItemplate.dotx';
      templateESD='./configuration/ESDtemplate.dotx';
      templateEFT='./configuration/EFTtemplate.dotx';
      type='docx';
      image;
      
    end
    
    methods
        function r = MyReportObj
        end
        function open(r,fname,type)
%             [filename, pathname] = uiputfile('.\UserData\*.docx', 'Pick an MATLAB code file');
%             if isequal(filename,0) || isequal(pathname,0)
%                disp('User pressed cancel')
%             else
%                disp(['User selected ', fullfile(pathname, filename)])
%             end
%             fname=fullfile(pathname, filename);
       try  
          switch type
              case 'RE'
                   r.rpt = mlreportgen.dom.Document(fname,r.type,r.templateRE);
                  open(r.rpt);
              case 'CE'
                       r.rpt = mlreportgen.dom.Document(fname,r.type,r.templateCE);
                  open(r.rpt);
              case 'OAT'
                       r.rpt = mlreportgen.dom.Document(fname,r.type,r.templateOAT);
                  open(r.rpt);
              case 'CI'
                       r.rpt = mlreportgen.dom.Document(fname,r.type,r.templateCI);
                  open(r.rpt);
              case 'ESD'
                    r.rpt = mlreportgen.dom.Document(fname,r.type,r.templateESD);
                  open(r.rpt);
              case 'RI'
                  r.rpt = mlreportgen.dom.Document(fname,r.type,r.templateRI);
                  open(r.rpt);
              case 'EFT'
                  r.rpt = mlreportgen.dom.Document(fname,r.type,r.templateEFT);
                  open(r.rpt);
          end
          
       catch  err
           msgbox('Warning: The file is already open, please close the file or rename to a different file name first!');
       end
        
        end
        function close(r)
            close(r.rpt);
        end
        
        function fill(s)
                   while(~strcmp(s.rpt.CurrentHoleId,'#end#'))
                            switch(s.rpt.CurrentHoleId)
                                     case 'p1t1'
                                     if ~isempty(s.p1t1)    
                                        append(s.rpt,s.p1t1);
                                     end
                                     
                                     case 'p1t2'
                                     if ~isempty(s.p1t2)
                                         append(s.rpt,s.p1t2);
                                     end
                                     case 'p1t3'
                                         if ~isempty(s.p1t3)
                                     append(s.rpt,s.p1t3);
                                     end
                                     case 'p2t1'
                                         if ~isempty(s.p2t1)
                                     append(s.rpt,s.p2t1);
                                     end
                                     case 'p3f1'
                                         if ~isempty(s.p3f1)
                                     append(s.rpt,s.p3f1);
                                     end
                                     case 'p3f2'
                                         if ~isempty(s.p3f2)
                                     append(s.rpt,s.p3f2);
                                         end
                                     case 'p3f3'
                                         if ~isempty(s.p3f3)
                                     append(s.rpt,s.p3f3);
                                        end
                                     case 'p3f4'
                                         if ~isempty(s.p3f4)
                                     append(s.rpt,s.p3f4);
                                        end
                                     case 'p3f5'
                                         if ~isempty(s.p3f5)
                                     append(s.rpt,s.p3f5);
                                         end
                                     case 'p4t1'
                                         if ~isempty(s.p4t1)
                                     append(s.rpt,s.p4t1);
                                     end
                                     case 'p4f1'
                                         if ~isempty(s.p4f1)
                                     append(s.rpt,s.p4f1);
                                     end
                                     case 'p4f2'
                                         if ~isempty(s.p4f2)
                                     append(s.rpt,s.p4f2);
                                     end
                                   
                                     case 'p4f3'
                                         if ~isempty(s.p4f3)
                                     append(s.rpt,s.p4f3);
                                     end
                                     case 'p4f4'
                                         if ~isempty(s.p4f4)
                                     append(s.rpt,s.p4f4);
                                     end
                                     case 'p4f5'
                                         if ~isempty(s.p4f5)
                                     append(s.rpt,s.p4f5);
                                     end
                                     case 'p5t1'
                                         if ~isempty(s.p5t1)
                                     append(s.rpt,s.p5t1);
                                         end                    
                                     case 'p5t2'
                                         if ~isempty(s.p5t2)
                                     append(s.rpt,s.p5t2);
                                         end 
                                     case 'p7t1'
                                         if ~isempty(s.p7t1)
                                     append(s.rpt,s.p7t1);
                                         end 
                                     case 'p7t2'
                                         if ~isempty(s.p7t2)
                                     append(s.rpt,s.p7t2);
                                         end 
                                     case 'p7t3'
                                         if ~isempty(s.p7t3)
                                     append(s.rpt,s.p7t3);
                                         end 
                                     case 'p7t4'
                                         if ~isempty(s.p7t4)
                                     append(s.rpt,s.p7t4);
                                         end 
                                     case 'p7t5'
                                         if ~isempty(s.p7t5)
                                     append(s.rpt,s.p7t5);
                                         end 
                                         
                   
                              end

                            moveToNextHole(s.rpt);
                  end


           end
            
      function table1=table(r,tb1)
          import mlreportgen.dom.*;
          table1=Table(table2array(tb1));
          table1.Border = 'single';
          table1.ColSep = 'single';
          table1.RowSep = 'single';
%           table1.Width = '2in';
%           table1.entry(1,1).Style = {Height('1in'), Width('1in')};
%           table1.entry(1,2).Border = 'solid';

        end
        function image1=Image2(r,f,id)
           import mlreportgen.dom.*;
           saveas(f,['.\images\report_img' num2str(id) '.png']);
           image1= Image(['.\images\report_img' num2str(id) '.png']);
%            image1.Height
%            image1.Width
       
           image1.Style = {Height('5in')};
           %image1.Style={ScaleToFit};
        end
        function loadpic(r)
            import mlreportgen.dom.*;
           if ~isempty(r.image)
               for i=1:length(r.image)
                   fname=r.image{i};
                    if ~isempty(fname)
                 %         image1= Image2(fname);
                 image1= Image(fname);
                       image1.Style={ScaleToFit};
                       eval(['r.p3f' num2str(i) '=image1;']);
                    end
               end

           end
       
        end
        function loadfig(r)
               import mlreportgen.dom.*;
            if ~isempty(r.image)
                 for i=1:length(r.image)
                    try  
                     fname=['./images/ESD_fig' num2str(i) '.png'];
                     h=figure(r.image{i});
                       saveas(h,fname,'png');
                       image1= Image([fname]);
                       image1.Style={ScaleToFit};
                       image1.Style = {Height('7in')};
                       eval(['r.p3f' num2str(i) '=image1;']);
                    catch err
                        
                    end
                       
                 end
            end
        
        end
        
        function t1=text(r,str)
            import mlreportgen.dom.*;
            t1=Text(str);
         %   t1.Bold=true;
%             t1.Color;
%             t1.FontSize
%             t1.Italic
%             t1.Strike
%             t1.Style
            t1.WhiteSpace='preserve';
            
        end
          
        function p1=paragraph(rpt,str)
           import mlreportgen.dom.*;
            p1=Paragraph(str);
          % p1.Bold=true;
            
        end
          
         function view(r)
            rptview(r.rpt.OutputPath)
         end
    
         function doc2pdf(r)
        
            filename=r.rpt.OutputPath;
            % Create COM server
            actx_word = actxserver('Word.Application');
            actx_word.Visible = false;

            
            pdf_filename = fullfile([filename(1:end-5) '.pdf']);

            % Open existing document
            word_handle = invoke(actx_word.Documents,'Open',filename);

            % Save as PDF
            invoke(word_handle,'ExportAsFixedFormat',pdf_filename,'wdExportFormatPDF');            

            % Close the window
            invoke(word_handle,'Close');            
            % Quit Word
            invoke(actx_word,'Quit');            
            % Close Word and terminate ActiveX
            delete(actx_word);       
        end
       
        
    end
    
end