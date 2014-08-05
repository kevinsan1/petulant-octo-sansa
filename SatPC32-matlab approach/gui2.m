function varargout = gui2(varargin)
% GUI2 MATLAB code for gui2.fig
%      GUI2, by itself, creates a new GUI2 or raises the existing
%      singleton*.
%
%      H = GUI2 returns the handle to a new GUI2 or the handle to
%      the existing singleton*.
%
%      GUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2.M with the given input arguments.
%
%      GUI2('Property','Value',...) creates a new GUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui2

% Last Modified by GUIDE v2.5 01-Aug-2014 14:24:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
  'gui_Singleton',  gui_Singleton, ...
  'gui_OpeningFcn', @gui2_OpeningFcn, ...
  'gui_OutputFcn',  @gui2_OutputFcn, ...
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


% --- Executes just before gui2 is made visible.
function gui2_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
handles.azimuthFlag = 0;
handles.arduinoFlag = 0;
handles.comsAvailable = getAvailableComPort;
set(handles.arduinoPort, 'String', handles.comsAvailable);
set(handles.azimuthPort, 'String', handles.comsAvailable);
handles.satelliteTrackProgramList = get(handles.satelliteTrackingProgram,'String');
[handles.chan, handles.flagSatPC] = satpc32_com(handles.satelliteTrackProgramList{1});
% Make azimuth dial
thisPos = get(handles.azimuthAxes,'position');
delete(handles.azimuthAxes);
handles.azimuthDial = dial('refVal',0,...
  'refOrientation',90*pi/180,...
  'valRangePerRotation',360, ...
  'Min',0,...
  'Max',359,...
  'doWrap',1,...
  'Value',0,...
  'Position',thisPos,...
  'VerticalAlignment','bottom',...
  'Tag','wrapDial',...
  'titleStr','Azimuth',...
  'titlePos','top',...
  'tickVals', [0 90 180 270],...
  'tickStrs',{'N'  'E'  'S'  'W'});
% Make elevation dial
thisPos = get(handles.elevationAxes,'position');
delete(handles.elevationAxes);
handles.elevationDial = dial('refVal',0,...
  'refOrientation',pi,...
  'valRangePerRotation',360, ...
  'Min',0,...
  'Max',359,...
  'doWrap',1,...
  'Value',0,...
  'Position',thisPos,...
  'VerticalAlignment','bottom',...
  'Tag','wrapDial',...
  'titleStr','Elevation',...
  'titlePos','top',...
  'tickVals', [0 90 180 270],...
  'tickStrs',{'0' '90' '180'  ''});
faceColour = [0.600000000000000,0.600000000000000,0.600000000000000];
set(handles.elevationValue,'BackgroundColor',faceColour,'ForegroundColor','r');
set(handles.azimuthValue,'BackgroundColor',faceColour,'ForegroundColor','r');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = gui2_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes on button press in connectToInstruments.
function connectToInstruments_Callback(hObject, eventdata, handles)

% Get list selection of Sat program and com ports for both rotors
handles.chosenSatTrackProgram = handles.satelliteTrackProgramList{get(handles.satelliteTrackingProgram,'Value')};
arduinoPortName = handles.comsAvailable{get(handles.arduinoPort,'Value')};
azimuthPortName = handles.comsAvailable{get(handles.azimuthPort,'Value')};

% Connect to ports if not already connected
if handles.azimuthFlag == 0
  [handles.azimuthCom, handles.azimuthFlag] = initializeAzimuthRotor(azimuthPortName);
end

if handles.arduinoFlag == 0
  [handles.arduinoCom, handles.arduinoFlag] = initializeArduino(arduinoPortName);
end

% Connect to Satellite Tracking Program
[handles.chan, handles.flagSatPC] = satpc32_com(handles.chosenSatTrackProgram);

% Display whether you are connected or not
switch (handles.arduinoFlag)
  case 1
    set(handles.myDisplay, 'String', strvcat('Connected to Arduino', get(handles.myDisplay,'String')));
    assignin('base', 'arduinoSerialPort', handles.arduinoCom);
  case 0
    set(handles.myDisplay, 'String', strvcat('Not Connected to Arduino', get(handles.myDisplay,'String')));
end
switch (handles.azimuthFlag)
  case 1
    set(handles.myDisplay, 'String', strvcat('Connected to Azimuth', get(handles.myDisplay,'String')));
    assignin('base', 'azimuthSerialPort', handles.azimuthCom);
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
handles.azimuthFlag = 0;
handles.arduinoFlag = 0;
set(handles.myDisplay, 'String', '');
handles.comsAvailable = getAvailableComPort;
set(handles.arduinoPort, 'String', handles.comsAvailable);
set(handles.azimuthPort, 'String', handles.comsAvailable);
set(handles.myDisplay, 'String', 'Instruments cleared');
% Update handles structure
guidata(hObject, handles);

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
  sendAzimuthTo(0,handles.azimuthCom);
  lastSat = 'firstSat';
  lastAz = getCurrentAzimuth(handles.azimuthCom);
  set(handles.myDisplay, 'String', {sprintf('%5.2f\t%5.2f',Az, El)});
  while toggleStartSatPC == 1 && not(stopButton) % while button is pressed run
    [Az, El, Sat] = satpc32(handles.chan);
    currentAzimuth = getCurrentAzimuth(handles.azimuthCom);
    if currentAzimuth < 182 && currentAzimuth > 178
      set(hObject, 'Value', 0);
      break;
    end
    direction = 'd';
    lastString = get(handles.myDisplay, 'String');
    lastString = [sprintf(['%5.2f\t%5.2f\t' Sat],Az, El); lastString];
    set(handles.myDisplay, 'String', lastString);
    stringAz = convertNumberToFormat(Az);
    stringEl = convertNumberToFormat(abs(El));
    if not(strcmp(lastSat,Sat)) % if satellite has changed, wait for rotor to get in position
      clearArduinoBuffer(handles.arduinoCom);
      clearAzimuthOutput(handles.azimuthCom);
      [AzNext, ElNext, Sat] = satpc32(handles.chan); % get second values
      %       direction = compareAzimuthDirection( Az, AzNext, handles.azimuthCom );
      currentAzimuth = getCurrentAzimuth(handles.azimuthCom);
      if currentAzimuth < 182 && currentAzimuth > 178
        set(hObject, 'Value', 0);
        sendAzimuthTo(0,handles.azimuthCom);
        break;
      else
        sendAzimuthTo(0,handles.azimuthCom);
      end
      %       sendAzimuthTo(Az, handles.azimuthCom);
      set(handles.myDisplay, 'String', {sprintf('Az: %5.2f\tEl:%5.2f\nSetting Azimuth and Elevation to Initial Position Az: %5.2f\tEl:%5.2f',Az, El)});
      fprintf(handles.arduinoCom, ['e' stringEl]);
      pause(0.5);
      timeToDelay = waitForArduinoElevation(handles.arduinoCom, abs(El));
      pause(0.5);
      sprintf('Delay: %g', timeToDelay)
      pause(timeToDelay);
      %       waitForLockMessage(handles.azimuthCom);
      disp('Both Axes set');
      %       fprintf(handles.azimuthCom, 'L<Dad<');
      %       pause(0.5);
      %       fprintf(handles.azimuthCom, 'G<');
      %       fprintf(handles.azimuthCom, 'G<');
    else % if satellite hasn't changed, send elevation and azimuth without waiting for them to get into position
      fprintf(handles.arduinoCom, ['e' stringEl]);
      sendAzimuthTo(Az, handles.azimuthCom);
    end
    set(handles.azimuthDial, 'Value', Az);
    set(handles.elevationDial, 'Value', abs(El));
    set(handles.azimuthValue, 'String', num2str(Az));
    set(handles.elevationValue, 'String', num2str(abs(El)));
    pause(0.2);
    fprintf(handles.arduinoCom, ['a' stringAz]);
    pause(1);
    toggleStartSatPC = get(hObject,'Value');
    stopButton = get(handles.stopButton,'Value');
    lastSat = Sat;
    lastAz = Az;
  end
  % when button isn't pressed, stop both rotors
  clearAzimuthOutput(handles.azimuthCom);
  clearArduinoBuffer(handles.arduinoCom);
  fprintf(handles.arduinoCom, 's');
  fprintf(handles.azimuthCom, 'H<');
end

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

set(handles.startSatPC32, 'Value', 0);
fprintf(handles.arduinoCom, 's');

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
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

clearArduinoBuffer( handles.arduinoCom);
set(handles.myDisplay, 'String', 'Arduino cleared');

function edit4_Callback(hObject, eventdata, handles)

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

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in satelliteTrackingProgram.
function satelliteTrackingProgram_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function satelliteTrackingProgram_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'SatPC32', 'Orbitron','NFW32'});

function edit6_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in arduinoPort.
function arduinoPort_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function arduinoPort_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in azimuthPort.
function azimuthPort_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function azimuthPort_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end

function myDisplay_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function myDisplay_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end

function azimuthValue_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function azimuthValue_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end

function elevationValue_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function elevationValue_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
  set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
