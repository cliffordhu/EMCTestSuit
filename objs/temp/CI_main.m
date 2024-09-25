function varargout = CI_main(varargin)
% CI_main MATLAB code for CI_main.fig
%      CI_main, by itself, creates a new CI_main or raises the existing
%      singleton*.
%
%      H = CI_main returns the handle to a new CI_main or the handle to
%      the existing singleton*.
%
%      CI_main('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CI_main.M with the given input arguments.
%
%      CI_main('Property','Value',...) creates a new CI_main or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CI_main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CI_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CI_main

% Last Modified by GUIDE v2.5 21-Oct-2014 16:36:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CI_main_OpeningFcn, ...
                   'gui_OutputFcn',  @CI_main_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before CI_main is made visible.
function CI_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CI_main (see VARARGIN)

% Choose default command line output for CI_main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

  
% UIWAIT makes CI_main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CI_main_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function txt_frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_frequency_Callback(hObject, eventdata, handles)
% hObject    handle to txt_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_frequency as text
%        str2double(get(hObject,'String')) returns contents of txt_frequency as a double


% --- Executes during object creation, after setting all properties.
function volume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function volume_Callback(hObject, eventdata, handles)
% hObject    handle to volume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of volume as text
%        str2double(get(hObject,'String')) returns contents of volume as a double


% --- Executes on button press in bt_setup.
function bt_setup_Callback(hObject, eventdata, handles)
% hObject    handle to bt_setup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global h1
global me


set(handles.txt_sweeprate,'string',['Sweep Speed:  x1']);

set(handles.slider1,'sliderstep',[1 1],'max',501,'min',1,'Value',1)
  set(handles.slider1,'Value',1);  
  h1=CI_config;
  
  
% me.header
% --- Executes on button press in bt_report.
function bt_report_Callback(hObject, eventdata, handles)
% hObject    handle to bt_report (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global me
fn_save_ci(me);

% --- Executes when selected object changed in unitgroup.
function unitgroup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in unitgroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the bt_report flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to bt_report the data.




% --- Executes on button press in bt_markcurrentfreqeuncy.
function bt_markcurrentfreqeuncy_Callback(hObject, eventdata, handles)
% hObject    handle to bt_markcurrentfreqeuncy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global me
str=get(handles.txt_markfreq,'string');
str1=get(handles.pop_result,'string');
m=get(handles.pop_result,'value')
str2=get(handles.txt_comments,'string');

if ~isempty(me.table)
        n=size(me.table,1)+1;
else
       n=1;
end
    me.table{n,1}=num2str(n);
    me.table{n,2}=[str 'Mhz'];
    me.table{n,3}= str1{m};
     me.table{n,4}= str2;
    
    


function txt_markfreq_Callback(hObject, eventdata, handles)
% hObject    handle to txt_markfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_markfreq as text
%        str2double(get(hObject,'String')) returns contents of txt_markfreq as a double


% --- Executes during object creation, after setting all properties.
function txt_markfreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_markfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_comments_Callback(hObject, eventdata, handles)
% hObject    handle to txt_comments (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_comments as text
%        str2double(get(hObject,'String')) returns contents of txt_comments as a double


% --- Executes during object creation, after setting all properties.
function txt_comments_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_comments (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_result.
function pop_result_Callback(hObject, eventdata, handles)
% hObject    handle to pop_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_result contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_result


% --- Executes during object creation, after setting all properties.
function pop_result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_amplitude_Callback(hObject, eventdata, handles)
% hObject    handle to txt_amplitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_amplitude as text
%        str2double(get(hObject,'String')) returns contents of txt_amplitude as a double


% --- Executes during object creation, after setting all properties.
function txt_amplitude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_amplitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in bt_min.
function bt_min_Callback(hObject, eventdata, handles)
% hObject    handle to bt_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global me
me.freqindex=1;
        set(handles.txt_amplitude,'string',num2str(0));
        set(handles.txt_frequency,'string',num2str(0.15));

% --- Executes on button press in bt_max.
function bt_max_Callback(hObject, eventdata, handles)
% hObject    handle to bt_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global me
mm=length(me.freqlist);
me.freqindex=mm;
        set(handles.txt_amplitude,'string',num2str(0));
        set(handles.txt_frequency,'string',num2str(80));

% --- Executes on button press in bt_reverse.
function bt_reverse_Callback(hObject, eventdata, handles)
% hObject    handle to bt_reverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global me
if me.freqstep>1
    me.freqstep=me.freqstep-1;
end
set(handles.txt_sweeprate,'String',['Sweep Speed:  x' num2str(me.freqstep) ]);
% --- Executes on button press in bt_forward.
function bt_forward_Callback(hObject, eventdata, handles)
% hObject    handle to bt_forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global me
if me.freqstep<5
    me.freqstep=me.freqstep+1;
end
set(handles.txt_sweeprate,'String',['Sweep Speed:  x' num2str(me.freqstep) ]);

% --- Executes on button press in bt_down.
function bt_down_Callback(hObject, eventdata, handles)
% hObject    handle to bt_down (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global me


me.run=-1;
mm=length(me.freqlist);
  
if me.freqindex>mm-5
     f = warndlg( 'Please connect RF source to HF','Reminder.');
    drawnow     % Necessary to print the message
    waitfor(f);
  end
  

while me.freqindex >=1 
  if me.run~=-1
         fprintf(me.hfgen,':OUTP:STAT OFF');
         fprintf(me.lfgen,'AM:STAT OFF'); 
      break;
  end
  
  if me.freqlist(me.freqindex)>me.crossoverfreq && me.freqlist(me.freqindex-me.freqstep)<me.crossoverfreq
     f = warndlg('Please switch the RF source from HF gen to LF gen','Reminder.');
    drawnow     % Necessary to print the message
    waitfor(f);
  end

if me.freqlist(me.freqindex)<me.crossoverfreq
%     % select 
    fprintf(me.lfgen,['APPL:SIN ' num2str(me.freqlist(me.freqindex)) ' HZ, ' num2str(me.lfgenamp) ' Vpp, 0V'])
    fprintf(me.lfgen,'AM:DEPT 20')
    fprintf(me.lfgen,'AM:STAT ON')
    
            % check power
        fprintf(me.pwrmtr,'INIT')
        fprintf(me.pwrmtr,'FETC?')
        str=str2num(fscanf(me.pwrmtr));
        set(handles.txt_amplitude,'string',num2str(str+me.attenuation));
        set(handles.txt_frequency,'string',num2str(me.freqlist(me.freqindex)/1e6));
        if str+me.attenuation <13
            if me.lfgenamp<9
                me.lfgenamp=me.lfgenamp+0.1;
            end
        end
     pause(0.5);
 
else
    
    fprintf(me.hfgen,['Freq ' num2str(me.freqlist(me.freqindex)) ' HZ'])
    fprintf(me.hfgen,['POW:AMPL ' num2str(me.hfgenamp) ' dBm'])
    fprintf(me.hfgen,'AM:DEPT 20')
    fprintf(me.hfgen,'AM:STAT ON')
    fprintf(me.hfgen,':OUTP:STAT ON')  
    
            % check power
        fprintf(me.pwrmtr,'INIT')
        fprintf(me.pwrmtr,'FETC?')
        str=str2num(fscanf(me.pwrmtr));
        set(handles.txt_amplitude,'string',num2str(str+me.attenuation,'%3.2f'));
        set(handles.txt_frequency,'string',num2str(me.freqlist(me.freqindex)/1e6,'%3.2f'));

        if str+me.attenuation <13
               if me.hfgenamp<-25
                me.hfgenamp=me.hfgenamp+1;
                        end
        end
           pause(0.5);

end
  set(handles.slider1,'Value',me.freqindex);
  me.freqindex=me.freqindex-me.freqstep;    
end



% --- Executes on button press in bt_up.
function bt_up_Callback(hObject, eventdata, handles)
% hObject    handle to bt_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global me
  if me.freqindex<5
     f = warndlg('Please connect RF source to LF','Reminder.');
    drawnow     % Necessary to print the message
    waitfor(f);
  end


me.run=1;
mm=length(me.freqlist);
while me.freqindex <=mm 
  if me.run~=1
         fprintf(me.hfgen,':OUTP:STAT OFF');
         fprintf(me.lfgen,'AM:STAT OFF'); 
      break;
  end
  if me.freqindex<1
    me.freqindex=1;
  end
  
  if me.freqlist(me.freqindex)<me.crossoverfreq && me.freqlist(me.freqindex+me.freqstep)>me.crossoverfreq
     f = warndlg('Please switch the RF source from LF gen to HF gen','Reminder.');
    drawnow     % Necessary to print the message
    waitfor(f);
  end

if me.freqlist(me.freqindex)<me.crossoverfreq
%     % select 
    fprintf(me.lfgen,['APPL:SIN ' num2str(me.freqlist(me.freqindex)) ' HZ, ' num2str(me.lfgenamp) ' Vpp, 0V'])
    fprintf(me.lfgen,'AM:DEPT 20')
    fprintf(me.lfgen,'AM:STAT ON')
          pause(0.1);
            % check power
      try      
       fprintf(me.pwrmtr,'INIT')
            pause(0.5);
        fprintf(me.pwrmtr,'FETC?')
              pause(0.5);
        str=str2num(fscanf(me.pwrmtr));
      catch err
         fprintf(me.pwrmtr,'*RST');
         str=0;
      end
      

        set(handles.txt_amplitude,'string',num2str(str+me.attenuation,'%3.2f'));
        set(handles.txt_frequency,'string',num2str(me.freqlist(me.freqindex)/1e6,'%3.2f'));
        if str+me.attenuation <13
            if me.lfgenamp<9
                me.lfgenamp=me.lfgenamp+0.1;
            end
        end
 
else
    
    fprintf(me.hfgen,['Freq ' num2str(me.freqlist(me.freqindex)) ' HZ'])
    fprintf(me.hfgen,['POW:AMPL ' num2str(me.hfgenamp) ' dBm'])
    fprintf(me.hfgen,'AM:DEPT 20')
    fprintf(me.hfgen,'AM:STAT ON')
    fprintf(me.hfgen,':OUTP:STAT ON')  
       pause(0.1);
            % check power
        try 
        fprintf(me.pwrmtr,'INIT')
        pause(0.5);
        fprintf(me.pwrmtr,'FETC?')
        pause(0.5)
          catch err
         fprintf(me.pwrmtr,'*RST');
      end
        str=str2num(fscanf(me.pwrmtr));
             pause(0.1);
        set(handles.txt_amplitude,'string',num2str(str+me.attenuation));
        set(handles.txt_frequency,'string',num2str(me.freqlist(me.freqindex)/1e6));

        if str+me.attenuation <13
               if me.hfgenamp<-25
                me.hfgenamp=me.hfgenamp+1;
                        end
        end
  

end
  set(handles.slider1,'Value',me.freqindex);
  me.freqindex=me.freqindex+me.freqstep;   
  fprintf(me.hfgen,':OUTP:STAT OFF');
       
end

% --- Executes on button press in bt_stop.
function bt_stop_Callback(hObject, eventdata, handles)
% hObject    handle to bt_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global me
me.run=0;
str=get(handles.txt_frequency,'string');
set(handles.txt_markfreq,'string',str);
set(handles.txt_comments,'string','');

function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
