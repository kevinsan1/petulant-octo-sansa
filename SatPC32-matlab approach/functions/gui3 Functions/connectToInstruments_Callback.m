% --- Executes on button press in connectToInstruments.
function [hObject, handles] = connectToInstruments_Callback(hObject, eventdata, handles)
%% Com port names
handles.azimuthCom = 'COM4';
handles.elevationCom = 'COM3';
handles.satTrackProgram = 'SatPC32';
% handles.satTrackProgram = 'NFW_SERVER';
%% Connect to ports if not already connected
% 1 means connected, 0 means not connected
if handles.azimuthFlag == 0
  [handles.azimuthCom, handles.azimuthFlag] = initializeAzimuthRotor( handles.azimuthCom );
end

if handles.elevationFlag == 0
  [handles.elevationCom, handles.elevationFlag] = initializeArduino( handles.elevationCom );
end

%% Connect to Satellite Tracking Program
[handles.chan, handles.flagSatPC] = satpc32_com( handles.satTrackProgram );

%% Display whether you are connected or not
% Check connection to elevation
switch (handles.elevationFlag)
  case 1
    set(handles.edit1, 'String', strvcat('Connected to Arduino', get(handles.edit1,'String')));
    assignin('base', 'arduinoSerialPort', handles.elevationCom);
  case 0
    set(handles.edit1, 'String', strvcat('Not Connected to Arduino', get(handles.edit1,'String')));
end
% Check connection to azimuth
switch (handles.azimuthFlag)
  case 1
    set(handles.edit1, 'String', strvcat('Connected to Azimuth', get(handles.edit1,'String')));
    assignin('base', 'azimuthSerialPort', handles.azimuthCom);
  case 0
    set(handles.edit1, 'String', strvcat('Not connected to Azimuth', get(handles.edit1,'String')));
end

% Update handles structure
guidata(hObject, handles);
