function FileSpec=fn_save_ci(me)
% -------------------------------------------------------------------
% File: WriteToWordFromMatlab
% Descr:  This is an example of how to control MS-Word from Matlab.
%         With the subfunctions below it is simple to automatically
%         let Matlab create reports in MS-Word.
%         This example copies two Matlab figures into MS-Word, writes
%         some text and inserts a table.
%         Works with MS-Word 2003 at least.
% Created: 2005-11-22 Andreas Karlsson
% History:
% 051122  AK  Modification of 'save2word' in Mathworks File Exchange   
% 060204  AK  Updated with WordSymbol, WordCreateTable and "Flying Start" section 
% 060214  AK  Pagenumber, font color and TOC added
% -------------------------------------------------------------------

% [WordFileName,CurDir] = uigetfile('*.*','Enter data file');
% if (WordFileName ~= 0)
% FileSpec = fullfile(CurDir,WordFileName);
% else
%    return
%     
% end
WordFileName='CItemplate1.dot';
Tempstr=pwd;
CurDir=[Tempstr '\Users'];
FileSpec = fullfile(CurDir,WordFileName);
Style='Normal';
	%FileSpec = fullfile(CurDir,WordFileName);
	[ActXWord,WordHandle]=StartWord(FileSpec);
    
    %fprintf('Document will be saved in %s\n',FileSpec);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%Section 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% s = struct('Discription','',...
%             'Model','',...
%             'NameStr','',...
%             'NameNum',1,...
%             'Number','',...
%             'StandardsStr','',...
%             'StandardsNum',1,...
%             'BandSelections',[1 1 1 1 1],...
%             'Polarization',0); %0 horizotal,1 vertical
%    ActXWord.Selection.GoTo(-1,0,0,'Test_Equipment');
    
%     % load header file
%      fid=fopen([pwd '\CALData\Report_header_CE.txt']);
 %     tl='';
%      while 1
%      tline = fgetl(fid);
%      if ~ischar(tline),break, end
%      tl=[tl tline char(13)];
%      end
%      %s.Report_header=tl;
     
%      
%     TextString=tl;
%     WordText(ActXWord,TextString,Style,[0,1]);%enter after text %header
%     

%         TextString='Colorado Springs HTC 3  Meter Chamber';
%     
%     WordText(ActXWord,TextString,Style,[0,1]);%enter after text  test site
%     

    ActXWord.Selection.GoTo(-1,0,0,'model');
    TextString=me.model;
    WordText(ActXWord,TextString,Style,[0,1]);%enter after text
    
    
    ActXWord.Selection.GoTo(-1,0,0,'serial');
    TextString=me.sn;
    WordText(ActXWord,TextString,Style,[0,1]);%enter after text
    
    ActXWord.Selection.GoTo(-1,0,0,'operator');
    TextString=me.operator;
    WordText(ActXWord,TextString,Style,[0,1]);%enter after text
    
    
    ActXWord.Selection.GoTo(-1,0,0,'date');
    TextString=me.date;
     WordText(ActXWord,TextString,Style,[0,1]);%enter after text
    
    ActXWord.Selection.GoTo(-1,0,0,'description');
    TextString=me.description;
    WordText(ActXWord,TextString,Style,[0,1]);%enter after text
     
   ActXWord.Selection.GoTo(-1,0,0,'result');
      if ~isempty(me.table)
         [NoRows NoCols]=size(me.table);
        for i=NoRows:-1:1
            for j=1:NoCols
                Table{i+1,j}=me.table{i,j};
            end
        end
           % peaktable=[1indexnum 2freq 3Peak 4QPeak 5AvgPeak  6QPeak_Limit 7AvgPeak_Limit 8QPeak_Margin 9AvgPeak_Margin 10Remark];
         
        Table{1,1}='Index';
        Table{1,2}='Frequency (MHz)';
        Table{1,3}='Description';
        Table{1,4}='Notes';
       
% No. freq, maxium measuremed value at fix height, table angle. limit delt,
% antenna height, maximum value at scanned height

         me.conclusion='Please check result section for detailed observation.';
                   
    else
        Table{1,1}='Index';
        Table{1,2}='Frequency (MHz)';
        Table{1,3}='Description';
        Table{1,4}='Comments';
        
        Table{2,1}='1';
        Table{2,2}='150KHz to 80MHz';
        Table{2,3}='A. Pass - Normal performacne within specificed limits';
        Table{2,4}='Passed';
              me.conclusion='Pass, Performance level A'
               
      end
        WordCreateTable(ActXWord,NoRows+1,4,Table,1);%enter before table
        
    
        if isempty(me.table)
      
        else
          
        end
        
    ActXWord.Selection.GoTo(-1,0,0,'conclusion');
    TextString=me.conclusion;
    WordText(ActXWord,TextString,Style,[0,1]);%enter after text
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%Section 2    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   


    %create table with data from Table
  


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%Section 3   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
%     %create table with data from PolarityH_Table
%     if ~isempty(PolarityV_Figure)
%         
%     ActXWord.Selection.GoTo(-1,0,0,'PolarityV_Table')
%     [NoRows NoCols]=size(PolarityV_Table);
%     WordCreateTable(ActXWord,NoRows,NoCols,PolarityV_Table,1);%enter before table
%     
%     %create figure with data from PolarityH_Figure
%     ActXWord.Selection.GoTo(-1,0,0,'PolarityV_Figure')
% axsource=PolarityV_Figure; 
% hgsave(axsource,'PolarityV_Figure.fig'); 
% h=figure(2)
% set(h,'Visible','off'); 
% clf
% h=hgload('PolarityV_Figure.fig'); 
%     print -f2 -dmeta
% FigureIntoWord(ActXWord); 
%     end
%     


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
  %  ActXWord.Selection.InsertBreak; %pagebreak
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%Section 4    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    [WordFileName,CurDir] = uiputfile([CurDir '\CI' me.sn '.doc'],'Save File as');
    
    FileSpec = fullfile(CurDir,WordFileName);
    
     if ~exist(FileSpec,'file')
         % Save file as new:
         invoke(WordHandle,'SaveAs',FileSpec,1);
     else
             % Save existing file:
     
         [WordFileName,CurDir] = uiputfile([CurDir '\CI_' me.sn '.doc'],'File is open, Change another name!');

     end
% invoke(word_handle_p,'SaveAs',word_file_p,1);
 
   %  Close the word window:
    %invoke(WordHandle,'Close');            
    % Quit MS Word
%    invoke(WordHandle,'Quit');            
    % Close Word and terminate ActiveX:
    delete(WordHandle);           
    

return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SUB-FUNCTIONS
% Creator Andreas Karlsson; andreas_k_se@yahoo.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [actx_word,word_handle]=StartWord(word_file_p)
    % Start an ActiveX session with Word:
    actx_word = actxserver('Word.Application');
    actx_word.Visible = true;
    trace(actx_word.Visible);  
    if ~exist(word_file_p,'file');
        % Create new document:
        word_handle = invoke(actx_word.Documents,'Add');
    else
        % Open existing document:
        word_handle = invoke(actx_word.Documents,'Open',word_file_p);
    end           
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function WordGoTo(actx_word_p,what_p,which_p,count_p,name_p,delete_p)
    %Selection.GoTo(What,Which,Count,Name)
    actx_word_p.Selection.GoTo(what_p,which_p,count_p,name_p);
    if(delete_p)
        actx_word_p.Selection.Delete;
    end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function WordCreateTOC(actx_word_p,upper_heading_p,lower_heading_p)
%      With ActiveDocument
%         .TablesOfContents.Add Range:=Selection.Range, RightAlignPageNumbers:= _
%             True, UseHeadingStyles:=True, UpperHeadingLevel:=1, _
%             LowerHeadingLevel:=3, IncludePageNumbers:=True, AddedStyles:="", _
%             UseHyperlinks:=True, HidePageNumbersInWeb:=True, UseOutlineLevels:= _
%             True
%         .TablesOfContents(1).TabLeader = wdTabLeaderDots
%         .TablesOfContents.Format = wdIndexIndent
%     End With
    actx_word_p.ActiveDocument.TablesOfContents.Add(actx_word_p.Selection.Range,1,...
        upper_heading_p,lower_heading_p);
    
    actx_word_p.Selection.TypeParagraph; %enter  
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function WordText(actx_word_p,text_p,style_p,enters_p,color_p)
	%VB Macro
	%Selection.TypeText Text:="Test!"
	%in Matlab
	%set(word.Selection,'Text','test');
	%this also works
	%word.Selection.TypeText('This is a test');    
    if(enters_p(1))
        actx_word_p.Selection.TypeParagraph; %enter
    end
	actx_word_p.Selection.Style = style_p;
    if(nargin == 5)%check to see if color_p is defined
        actx_word_p.Selection.Font.Color=color_p;     
    end
    
	actx_word_p.Selection.TypeText(text_p);
%    actx_word_p.Selection.Font.Color='wdColorAutomatic';%set back to default color
    for k=1:enters_p(2)    
        actx_word_p.Selection.TypeParagraph; %enter
    end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function WordSymbol(actx_word_p,symbol_int_p)
    % symbol_int_p holds an integer representing a symbol, 
    % the integer can be found in MSWord's insert->symbol window    
    % 176 = degree symbol
    actx_word_p.Selection.InsertSymbol(symbol_int_p);
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function WordCreateTable(actx_word_p,nr_rows_p,nr_cols_p,data_cell_p,enter_p) 
    %Add a table which auto fits cell's size to contents
    if(enter_p(1))
        actx_word_p.Selection.TypeParagraph; %enter
    end
    %create the table
    %Add = handle Add(handle, handle, int32, int32, Variant(Optional))
    actx_word_p.ActiveDocument.Tables.Add(actx_word_p.Selection.Range,nr_rows_p,nr_cols_p,1,1);
    %Hard-coded optionals                     
    %first 1 same as DefaultTableBehavior:=wdWord9TableBehavior
    %last  1 same as AutoFitBehavior:= wdAutoFitContent
     
    %write the data into the table
    for r=1:nr_rows_p
        for c=1:nr_cols_p
            %write data into current cell
            WordText(actx_word_p,num2str(data_cell_p{r,c}),'Normal',[0,0]);
            
            if(r*c==nr_rows_p*nr_cols_p)
                %we are done, leave the table
                actx_word_p.Selection.MoveDown;
            else%move on to next cell 
                actx_word_p.Selection.MoveRight;
            end            
        end
    end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function WordPageNumbers(actx_word_p,align_p)
    %make sure the window isn't split
    if (~strcmp(actx_word_p.ActiveWindow.View.SplitSpecial,'wdPaneNone')) 
        actx_word_p.Panes(2).Close;
    end
    %make sure we are in printview
    if (strcmp(actx_word_p.ActiveWindow.ActivePane.View.Type,'wdNormalView') | ...
        strcmp(actx_word_p.ActiveWindow.ActivePane.View.Type,'wdOutlineView'))
        actx_word_p.ActiveWindow.ActivePane.View.Type ='wdPrintView';
    end
    %view the headers-footers
    actx_word_p.ActiveWindow.ActivePane.View.SeekView='wdSeekCurrentPageHeader';
    if actx_word_p.Selection.HeaderFooter.IsHeader
        actx_word_p.ActiveWindow.ActivePane.View.SeekView='wdSeekCurrentPageFooter';
    else
        actx_word_p.ActiveWindow.ActivePane.View.SeekView='wdSeekCurrentPageHeader';
    end
    %now add the pagenumbers 0->don't display any pagenumber on first page
     actx_word_p.Selection.HeaderFooter.PageNumbers.Add(align_p,0);
     actx_word_p.ActiveWindow.ActivePane.View.SeekView='wdSeekMainDocument';
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PrintMethods(actx_word_p,category_p)
    style='Heading 3';
    text=strcat(category_p,'-methods');
    WordText(actx_word_p,text,style,[1,1]);           
    
    style='Normal';    
    text=strcat('Methods called from Matlab as: ActXWord.',category_p,'.MethodName(xxx)');
    WordText(actx_word_p,text,style,[0,0]);           
    text='Ignore the first parameter "handle". ';
    WordText(actx_word_p,text,style,[1,3]);           
    
    MethodsStruct=eval(['invoke(actx_word_p.' category_p ')']);
    MethodsCell=struct2cell(MethodsStruct);
    NrOfFcns=length(MethodsCell);
    for i=1:NrOfFcns
        MethodString=MethodsCell{i};
        WordText(actx_word_p,MethodString,style,[0,1]);           
    end
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FigureIntoWord(actx_word_p)
	% Capture current figure/model into clipboard:
	%print -dmeta
   
	% Find end of document and make it the insertion point:
	%end_of_doc = get(actx_word_p.activedocument.content,'end');
	%set(actx_word_p.application.selection,'Start',end_of_doc);
	%set(actx_word_p.application.selection,'End',end_of_doc);
	% Paste the contents of the Clipboard:
    %also works Paste(ActXWord.Selection)

	invoke(actx_word_p.Selection,'Paste');
    actx_word_p.Selection.TypeParagraph; %enter    
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CloseWord(actx_word_p,word_handle_p,word_file_p)
     if ~exist(word_file_p,'file')
         % Save file as new:
         invoke(word_handle_p,'SaveAs',word_file_p,1);
     else
         % Save existing file:
         invoke(word_handle_p,'Save');
     end
% invoke(word_handle_p,'SaveAs',word_file_p,1);
 
   %  Close the word window:
    invoke(word_handle_p,'Close');            
    % Quit MS Word
    invoke(actx_word_p,'Quit');            
    % Close Word and terminate ActiveX:
    delete(actx_word_p);            
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
