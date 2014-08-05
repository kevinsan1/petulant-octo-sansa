function varargout = gui23(varargin)
% GUI23 MATLAB code for gui23.fig
%      GUI23, by itself, creates a new GUI23 or raises the existing
%      singleton*.
%
%      H = GUI23 returns the handle to a new GUI23 or the handle to
%      the existing singleton*.
%
%      GUI23('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI23.M with the given input arguments.
%
%      GUI23('Property','Value',...) creates a new GUI23 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui23_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui23_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui23

% Last Modified by GUIDE v2.5 29-Jul-2014 19:35:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
  'gui_Singleton',  gui_Singleton, ...
  'gui_OpeningFcn', @gui23_OpeningFcn, ...
  'gui_OutputFcn',  @gui23_OutputFcn, ...
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


% --- Executes just before gui23 is made visible.
function gui23_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui23 (see VARARGIN)

% Choose default command line output for gui23
handles.output = hObject;
handles.comsAvailable = getAvailableComPort;
set(handles.arduinoPort, 'String', 'COM3');
set(handles.azimuthPort, 'String', 'COM4');

% set(handles.arduinoPort, 'String', handles.comsAvailable);
% set(handles.azimuthPort, 'String', handles.comsAvailable);
handles.satelliteTrackProgramList = get(handles.satelliteTrackingProgram,'String');
[handles.chan, handles.flagSatPC] = satpc32_com(handles.satelliteTrackProgramList{1});
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui23 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui23_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in connectToInstruments.
function connectToInstruments_Callback(hObject, eventdata, handles)
% hObject    handle to connectToInstruments (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = cellstr(get(handles.arduinoPort,'String'));
handles.satelliteTrackProgramList = get(handles.satelliteTrackingProgram,'String');
handles.chosenSatTrackProgram = handles.satelliteTrackProgramList{get(handles.satelliteTrackingProgram,'Value')};
arduinoPortName = contents{get(handles.arduinoPort,'Value')};
azimuthPortName = contents{get(handles.azimuthPort,'Value')};
try % try connecting to azimuth only if not connected already
  if handles.azimuthFlag == 1
    %     disp('Azimuth Connected'); % Don't try to connect again
  else
    [handles.azimuthCom, handles.azimuthFlag] = initializeAzimuthRotor(azimuthPortName);
  end
catch
  [handles.azimuthCom, handles.azimuthFlag] = initializeAzimuthRotor(azimuthPortName);
end

try % try connecting to arduino only if its not connected already
  if handles.arduinoFlag == 1
  else
    [handles.azimuthCom, handles.azimuthFlag] = initializeAzimuthRotor(azimuthPortName);
  end
catch
  [handles.arduinoCom, handles.arduinoFlag] = initializeArduino(arduinoPortName);
end
% Connect to Satellite Tracking Program
[handles.chan, handles.flagSatPC] = satpc32_com(handles.chosenSatTrackProgram);
% handles.arduinoFlag = 1 if we are connected to the arduino
% rotor and 2 if we are not.
switch (handles.arduinoFlag)
  case 1
    set(handles.myDisplay, 'String', strvcat('Connected to Arduino', get(handles.myDisplay,'String')));
    assignin('base', 'arduinoSerialPort', handles.arduinoCom);
  case 0
    set(handles.myDisplay, 'String', strvcat('Not Connected to Arduino', get(handles.myDisplay,'String')));
end
% handles.azimuthFlag = 1 if we are connected to the azimuth
% rotor and 2 if we are not.
switch (handles.azimuthFlag)
  case 1
    set(handles.myDisplay, 'String', strvcat('Connected to Azimuth', get(handles.myDisplay,'String')));
    assignin('base', 'azimuthSerialPort', handles.azimuthCom);
    %     fprintf(handles.azimuthCom, 'FT1<');
    %     testString = selfTestAzimuth( handles.azimuthCom );
    %     set(handles.myDisplay, 'String', strvcat(testString, get(handles.myDisplay,'String')));
    set(handles.myDisplay, 'String', strvcat('Coordinates may now be sent', get(handles.myDisplay,'String')));
    %     fgets(handles.azimuthCom);
  case 0
    set(handles.myDisplay, 'String', strvcat('Not connected to Azimuth', get(handles.myDisplay,'String')));
end
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in clearInstruments.
function clearInstruments_Callback(hObject, eventdata, handles)
% hObject    handle to clearInstruments (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(instrfind); clc;
evalin('base','clear all; delete(instrfind);clc;');
set(handles.myDisplay, 'String', '');
handles.comsAvailable = getAvailableComPort;
set(handles.arduinoPort, 'String', handles.comsAvailable);
set(handles.azimuthPort, 'String', handles.comsAvailable);
set(handles.myDisplay, 'String', 'Instruments cleared');
% Update handles structure
guidata(hObject, handles);

% --- Executes on selection change in arduinoPort.
function arduinoPort_Callback(hObject, eventdata, handles)
% hObject    handle to arduinoPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns arduinoPort contents as cell array
%        contents{get(hObject,'Value')} returns selected item from arduinoPort


% --- Executes during object creation, after setting all properties.
function arduinoPort_CreateFcn(hObject, eventdata, handles)
% hObject    handle to arduinoPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in azimuthPort.
function azimuthPort_Callback(hObject, eventdata, handles)
% hObject    handle to azimuthPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns azimuthPort contents as cell array
%        contents{get(hObject,'Value')} returns selected item from azimuthPort


% --- Executes during object creation, after setting all properties.
function azimuthPort_CreateFcn(hObject, eventdata, handles)
% hObject    handle to azimuthPort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end



function myDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to myDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of myDisplay as text
%        str2double(get(hObject,'String')) returns contents of myDisplay as a double


% --- Executes during object creation, after setting all properties.
function myDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to myDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in startSatPC32.
function startSatPC32_Callback(hObject, eventdata, handles)
% hObject    handle to startSatPC32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
toggleStartSatPC = get(hObject,'Value');
stopButton = get(handles.stopButton,'Value');
% if arduino, azimuth rotor, and satpc are connected

if handles.arduinoFlag && handles.azimuthFlag && handles.flagSatPC && toggleStartSatPC
  [Az, El, Sat] = satpc32( handles.chan); % Get coordinates from SatPC32
  lastSat = 'firstSat';
  lastAz = 0;
  set(handles.myDisplay, 'String', {sprintf('%5.2f\t%5.2f',Az, El)});
  while toggleStartSatPC == 1 && not(stopButton) % while button is pressed run
    [Az, El, Sat] = satpc32(handles.chan);
    lastString = get(handles.myDisplay, 'String');
    lastString = [sprintf(['%5.2f\t%5.2f\t' Sat],Az, El); lastString];
    set(handles.myDisplay, 'String', lastString);
    stringAz = convertNumberToFormat(Az);
    stringEl = convertNumberToFormat(abs(El));
    if not(strcmp(lastSat,Sat)) % if satellite has changed, wait for rotor to get in position
      clearArduinoBuffer(handles.arduinoCom);
      clearAzimuthOutput(handles.azimuthCom);
      sendAzimuthTo(Az, handles.azimuthCom);
      set(handles.myDisplay, 'String', {sprintf('Az: %5.2f\tEl:%5.2f\nSetting Azimuth and Elevation to Initial Position Az: %5.2f\tEl:%5.2f',Az, El)});
      fprintf(handles.arduinoCom, ['e' stringEl]);
      pause(0.5);
      timeToDelay = waitForArduinoElevation(handles.arduinoCom, abs(El));
      pause(0.5);
      sprintf('Delay: %g', timeToDelay)
      pause(timeToDelay);
      waitForLockMessage(handles.azimuthCom);
      disp('Both Axes set');
    else % if satellite hasn't changed, send elevation and azimuth without waiting for them to get into position
      fprintf(handles.arduinoCom, ['e' stringEl]);
      sendAzimuthTo(Az, handles.azimuthCom);
    end
    pause(0.2);
    fprintf(handles.arduinoCom, ['a' stringAz]);
    pause(1);
    toggleStartSatPC = get(hObject,'Value');
    stopButton = get(handles.stopButton,'Value');
    lastSat = Sat;
    lastAz = Az;
  end
  % when button isn't pressed, stop both rotors
  fprintf(handles.azimuthCom, 'H<'); % tell azimuth rotor to stop
  pause(0.5);
  clearAzimuthOutput(handles.azimuthCom);
  clearArduinoBuffer(handles.arduinoCom);
  fprintf(handles.arduinoCom, 's');
  fprintf(handles.azimuthCom, 'H<');
end

% Hint: get(hObject,'Value') returns toggle state of startSatPC32


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
command = get(handles.edit3, 'String');
switch command(1)
  case 'r'
    El = getCurrentElevation(handles.arduinoCom);
    set(handles.text6, 'String', sprintf('%5.2f',El));
  case 'o'
    fprintf(handles.arduinoCom, 'o'); % tell arduino to analogread
    pause(0.01);
    bitElevation = fgets(handles.arduinoCom); % read in elevation
    set(handles.text6, 'String', str2num(bitElevation));
  case 'g' % returns degrees off before arduino moves
    fprintf(handles.arduinoCom, command(1));
    pause(0.01);
    degreesOff = fgets(handles.arduinoCom);
    set(handles.text6, 'String', str2num(degreesOff));
  otherwise
    fprintf(handles.arduinoCom, command(1));
end


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
% hObject    handle to stopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.startSatPC32, 'Value', 0);
% set(handles.elevationDown, 'Value' , 0);
% set(handles.elevationUp, 'Value', 0);
fprintf(handles.arduinoCom, 's');
% Hint: get(hObject,'Value') returns toggle state of stopButton


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
choice = questdlg('Close?', ...
  'Close all connections', ...
  'Yes','No','Yes');
% Handle response
switch choice
  case 'Yes'
    try
      stopButton_Callback(hObject, eventdata, handles);
      delete(hObject);
      delete(instrfind);
      evalin('base','clear all; delete(instrfind);clc;');
      clear all;
      clc;
    catch
      disp(['Error closing' lasterr]);
      close all force;
      evalin('base','clear all; close all force; delete(instrfind);clc;');
    end
  otherwise
end


% --- Executes on button press in clearArduinoBuffer.
function clearArduinoBuffer_Callback(hObject, eventdata, handles)
% hObject    handle to clearArduinoBuffer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clearArduinoBuffer( handles.arduinoCom);
set(handles.myDisplay, 'String', 'Arduino cleared');



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in satelliteTrackingProgram.
function satelliteTrackingProgram_Callback(hObject, eventdata, handles)
% hObject    handle to satelliteTrackingProgram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns satelliteTrackingProgram contents as cell array
%        contents{get(hObject,'Value')} returns selected item from satelliteTrackingProgram


% --- Executes during object creation, after setting all properties.
function satelliteTrackingProgram_CreateFcn(hObject, eventdata, handles)
% hObject    handle to satelliteTrackingProgram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'SatPC32', 'Orbitron','NFW32'});



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end


