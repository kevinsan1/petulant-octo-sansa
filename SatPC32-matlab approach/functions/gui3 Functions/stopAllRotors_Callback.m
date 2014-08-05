% --- Executes on button press in stopAllRotors.
function [hObject, handles] = stopAllRotors_Callback(hObject, eventdata, handles)
% hObject    handle to stopAllRotors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
  set(handles.startFollowingSatProgram, 'Value' , 0);
  fprintf(handles.elevationCom, 's');
  answer = didWeCrossHalfWay( handles.lastAz, handles.firstAz );
  switch answer
    case 'n' % didn't cross, so we just send to zero
      sendAndWaitForAzimuth( 0, handles.azimuthCom)
      disp('did not cross');
    case 'y' % crossed
      if abs(handles.lastAz-180) < 180 % make sure currentAz close enough to 180
        sendAndWaitForAzimuth( 180, handles.azimuthCom );
        sendAndWaitForAzimuth( handles.firstAz, handles.azimuthCom );
        sendAndWaitForAzimuth( 0, handles.azimuthCom );
      end
    case 'b'
      fprintf(handles.azimuthCom, 'H<'); % stop motion
      return;
  end
catch ME
  disp( [ ME.stack(1,1).name ' line ' num2str(ME.stack(1,1).line) ] );
  disp( ME.message );
end
set(handles.startFollowingSatProgram, 'Enable', 'on');
guidata(hObject, handles)