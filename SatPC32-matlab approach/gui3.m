function varargout = gui3(varargin)
% GUI3 M-file for gui3.fig
%      GUI3, by itself, creates a new GUI3 or raises the existing
%      singleton*.
%
%      H = GUI3 returns the handle to a new GUI3 or the handle to
%      the existing singleton*.
%
%      GUI3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI3.M with the given input arguments.
%
%      GUI3('Property','Value',...) creates a new GUI3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui3

% Last Modified by GUIDE v2.5 05-Aug-2014 16:28:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
  'gui_Singleton',  gui_Singleton, ...
  'gui_OpeningFcn', @gui3_OpeningFcn, ...
  'gui_OutputFcn',  @gui3_OutputFcn, ...
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

% --- Outputs from this function are returned to the command line.
function varargout = gui3_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function startFollowingSatProgram_Callback(hObject, eventdata, handles)
toggleStatus = get(hObject, 'Value');
lastSat = 'initial satellite';
handles.lastAz = getCurrentAzimuth( handles.azimuthCom );
handles.firstAz = handles.lastAz;
if toggleStatus == 1
  set(hObject, 'Enable', 'off'); % Disable button from being pressed again
end

while toggleStatus == 1
  [Az, El, Sat] = getSatelliteCoordinates(handles.chan, handles.satTrackProgram);
  sameAsLastSatellite = strcmp(Sat,lastSat);
  if sameAsLastSatellite
    sendAzimuthTo( Az, handles.azimuthCom );
    set(handles.edit1, 'String', sprintf('%5.2f\t%5.2f',Az,El));
  else
    answer = didWeCrossHalfWay( handles.lastAz, handles.firstAz );
    switch answer
      case 'n' % didn't cross, so we just send to zero
        sendAndWaitForAzimuth( 0, handles.azimuthCom )
      case 'y' % crossed
        % must send in increments smaller than 180
        sendAndWaitForAzimuth( 180, handles.azimuthCom );
        sendAndWaitForAzimuth( handles.firstAz, handles.azimuthCom );
        sendAndWaitForAzimuth( 0, handles.azimuthCom );
      case 'b'
        fprintf(handles.azimuthCom, 'H<'); % stop motion
        break;
    end
    disp(sprintf('Now sending to %g',Az));
    sendAzimuthTo( Az, handles.azimuthCom );
    handles.handles.firstAz = Az; % first Az of this satellite
  end
  set(handles.azimuthDial, 'Value', Az);
  set(handles.elevationDial, 'Value', abs(El));
  set(handles.azimuthValue, 'String', num2str(Az));
  set(handles.elevationValue, 'String', num2str(abs(El)));
  toggleStatus = get(hObject, 'Value');
  lastSat = Sat;
  handles.lastAz = Az;
  guidata(hObject,handles);
  pause(1);
end

guidata(hObject,handles);

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end



function elevationValue_Callback(hObject, eventdata, handles)
% hObject    handle to elevationValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of elevationValue as text
%        str2double(get(hObject,'String')) returns contents of elevationValue as a double
set(handles.elevationDial, 'Value', str2double(get(hObject,'String')));

% --- Executes during object creation, after setting all properties.
function elevationValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to elevationValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end



function azimuthValue_Callback(hObject, eventdata, handles)
% hObject    handle to azimuthValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of azimuthValue as text
%        str2double(get(hObject,'String')) returns contents of azimuthValue as a double

set(handles.azimuthDial, 'Value', str2double(get(hObject,'String')));

% --- Executes during object creation, after setting all properties.
function azimuthValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to azimuthValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.azimuthFlag = 0;
if handles.azimuthFlag == 1
  currentAzimuth = getCurrentAzimuth( handles.azimuthCom );
  % close figure only if the rotor has been returned to 0
  if currentAzimuth < 1 || currentAzimuth > 359
    delete(hObject);
  else
    set(handles.edit1, 'String', 'Need to send azimuth to zero before closing');
  end
else
  delete(hObject);
end


