% --- Executes on button press in clearInstruments.
function [hObject, handles] =  clearInstruments_Callback(hObject, eventdata, handles)
% hObject    handle to clearInstruments (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(instrfind); clc;
evalin('base','clear all; delete(instrfind);clc;');
handles.azimuthFlag = 0;
handles.elevationFlag = 0;
set(handles.edit1, 'String', '');
set(handles.edit1, 'String', 'Instruments cleared');
% Update handles structure
guidata(hObject, handles);