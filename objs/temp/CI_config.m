function varargout = CI_config(varargin)
% CI_config MATLAB code for CI_config.fig
%      CI_config, by itself, creates a new CI_config or raises the existing
%      singleton*.
%
%      H = CI_config returns the handle to a new CI_config or the handle to
%      the existing singleton*.
%
%      CI_config('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CI_config.M with the given input arguments.
%
%      CI_config('Property','Value',...) creates a new CI_config or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CI_config_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CI_config_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CI_config

% Last Modified by GUIDE v2.5 21-Oct-2014 16:25:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CI_config_OpeningFcn, ...
                   'gui_OutputFcn',  @CI_config_OutputFcn, ...
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

% --- Executes just before CI_config is made visible.
function CI_config_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CI_config (see VARARGIN)

% Choose default command line output for CI_config
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes CI_config wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CI_config_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function txt_header_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_header (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_header_Callback(hObject, eventdata, handles)
% hObject    handle to txt_header (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_header as text
%        str2double(get(hObject,'String')) returns contents of txt_header as a double


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


% --- Executes on button press in bt_setup.
function bt_setup_Callback(hObject, eventdata, handles)
% hObject    handle to bt_setup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in bt_done.
function bt_done_Callback(hObject, eventdata, handles)
% hObject    handle to bt_done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global me
global h1
me=CI_obj;

me.header=get(handles.txt_header,'string');
me.configuration=get(handles.txt_configuration,'string');
me.operator=get(handles.txt_operator,'string');
me.model=get(handles.txt_model,'string');
me.sn=get(handles.txt_sn,'string');
me.stage=get(handles.txt_stage,'string');
me.date=datestr(now,'mm/dd/yyyy');
me.lfgenaddress=str2num(get(handles.txt_lfgenaddress,'string'));
me.hfgenaddress=str2num(get(handles.txt_hfgenaddress,'string'));
me.crossoverfreq=str2num(get(handles.txt_crossoverfreq,'string'))*1e6;
me.pwrmtraddress=(get(handles.txt_pwrmtraddress,'string'));
me.lfgain=str2num(get(handles.txt_lfgain,'string'));
me.hfgain=str2num(get(handles.txt_hfgain,'string'));
me.attenuation=str2num(get(handles.txt_attenuation,'string'));
df=(80e6-150e3)/500;
me.freqlist=[0 :500]*df+150e3;
 me.freqindex=1;
 me.freqstep=1;
  me.lfgenamp=5.6;
   me.hfgenamp=-27;
   me.table='';
   me.run=0;   
   try
          [me.lfgen me.hfgen me.pwrmtr]=me.init;
   catch err
     disp('Instrumental initialization is not complete. Please check connection!')
     return; 
   end
   
fprintf(me.lfgen,'*RST');fprintf(me.lfgen,'*CLS');
fprintf(me.hfgen,'*RST');fprintf(me.hfgen,'*CLS');
%fprintf(me.pwrmtr,'*RST');fprintf(me.pwrmtr,'*CLS');

close(gcf)
msgbox('Instruments are ready for testing');



% --- Executes when selected object changed in unitgroup.
function unitgroup_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in unitgroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the bt_done flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to bt_done the data.





% --- Executes on button press in bt_markcurrentfreqeuncy.
function bt_markcurrentfreqeuncy_Callback(hObject, eventdata, handles)
% hObject    handle to bt_markcurrentfreqeuncy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function txt_lfgenaddress_Callback(hObject, eventdata, handles)
% hObject    handle to txt_lfgenaddress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_lfgenaddress as text
%        str2double(get(hObject,'String')) returns contents of txt_lfgenaddress as a double


% --- Executes during object creation, after setting all properties.
function txt_lfgenaddress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_lfgenaddress (see GCBO)
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


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
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


% --- Executes on button press in bt_max.
function bt_max_Callback(hObject, eventdata, handles)
% hObject    handle to bt_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in bt_reverse.
function bt_reverse_Callback(hObject, eventdata, handles)
% hObject    handle to bt_reverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in bt_forward.
function bt_forward_Callback(hObject, eventdata, handles)
% hObject    handle to bt_forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in bt_stop.
function bt_stop_Callback(hObject, eventdata, handles)
% hObject    handle to bt_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function txt_configuration_Callback(hObject, eventdata, handles)
% hObject    handle to txt_configuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_configuration as text
%        str2double(get(hObject,'String')) returns contents of txt_configuration as a double


% --- Executes during object creation, after setting all properties.
function txt_configuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_configuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_hfgenaddress_Callback(hObject, eventdata, handles)
% hObject    handle to txt_hfgenaddress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_hfgenaddress as text
%        str2double(get(hObject,'String')) returns contents of txt_hfgenaddress as a double


% --- Executes during object creation, after setting all properties.
function txt_hfgenaddress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_hfgenaddress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_pwrmtraddress_Callback(hObject, eventdata, handles)
% hObject    handle to txt_pwrmtraddress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_pwrmtraddress as text
%        str2double(get(hObject,'String')) returns contents of txt_pwrmtraddress as a double


% --- Executes during object creation, after setting all properties.
function txt_pwrmtraddress_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_pwrmtraddress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_operator_Callback(hObject, eventdata, handles)
% hObject    handle to txt_operator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_operator as text
%        str2double(get(hObject,'String')) returns contents of txt_operator as a double


% --- Executes during object creation, after setting all properties.
function txt_operator_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_operator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_model_Callback(hObject, eventdata, handles)
% hObject    handle to txt_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_model as text
%        str2double(get(hObject,'String')) returns contents of txt_model as a double


% --- Executes during object creation, after setting all properties.
function txt_model_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_model (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_sn_Callback(hObject, eventdata, handles)
% hObject    handle to txt_sn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_sn as text
%        str2double(get(hObject,'String')) returns contents of txt_sn as a double


% --- Executes during object creation, after setting all properties.
function txt_sn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_sn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_stage_Callback(hObject, eventdata, handles)
% hObject    handle to txt_stage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_stage as text
%        str2double(get(hObject,'String')) returns contents of txt_stage as a double


% --- Executes during object creation, after setting all properties.
function txt_stage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_stage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_crossoverfreq_Callback(hObject, eventdata, handles)
% hObject    handle to txt_crossoverfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_crossoverfreq as text
%        str2double(get(hObject,'String')) returns contents of txt_crossoverfreq as a double


% --- Executes during object creation, after setting all properties.
function txt_crossoverfreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_crossoverfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_lfgain_Callback(hObject, eventdata, handles)
% hObject    handle to txt_lfgain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_lfgain as text
%        str2double(get(hObject,'String')) returns contents of txt_lfgain as a double


% --- Executes during object creation, after setting all properties.
function txt_lfgain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_lfgain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_hfgain_Callback(hObject, eventdata, handles)
% hObject    handle to txt_hfgain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_hfgain as text
%        str2double(get(hObject,'String')) returns contents of txt_hfgain as a double


% --- Executes during object creation, after setting all properties.
function txt_hfgain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_hfgain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_attenuation_Callback(hObject, eventdata, handles)
% hObject    handle to txt_attenuation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_attenuation as text
%        str2double(get(hObject,'String')) returns contents of txt_attenuation as a double


% --- Executes during object creation, after setting all properties.
function txt_attenuation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_attenuation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to txt_configuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_configuration as text
%        str2double(get(hObject,'String')) returns contents of txt_configuration as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_configuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to txt_header (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_header as text
%        str2double(get(hObject,'String')) returns contents of txt_header as a double


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_header (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
