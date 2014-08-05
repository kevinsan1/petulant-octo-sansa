function varargout = dialTry(varargin)
% DIALTRY M-file for dialTry.fig
%      DIALTRY, by itself, creates a new DIALTRY or raises the existing
%      singleton*.
%
%      H = DIALTRY returns the handle to a new DIALTRY or the handle to
%      the existing singleton*.
%
%      DIALTRY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIALTRY.M with the given input arguments.
%
%      DIALTRY('Property','Value',...) creates a new DIALTRY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before dialTry_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dialTry_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dialTry

% Last Modified by GUIDE v2.5 29-Jul-2014 20:48:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
  'gui_Singleton',  gui_Singleton, ...
  'gui_OpeningFcn', @dialTry_OpeningFcn, ...
  'gui_OutputFcn',  @dialTry_OutputFcn, ...
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


% --- Executes just before dialTry is made visible.
function dialTry_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dialTry (see VARARGIN)

% Choose default command line output for dialTry
handles.output = hObject;
thisPos = get(handles.axes1,'position');
delete(handles.axes1);
handles.wrapDial = dial('refVal',0,...
    'refOrientation',pi,...
    'valRangePerRotation',360, ...
    'Min',0,...
    'Max',359,...
    'doWrap',1,...
    'Value',0,...
    'Position',thisPos,...
    'VerticalAlignment','bottom',...
    'Tag','wrapDial',...
    'titleStr', 'Elevation',...
    'titlePos','top',...    
    'tickVals', [0 90 180],...
    'tickStrs',{'0' '90','180'});
  [handles.chan, handles.flagSatPC] = satpc32_com('SatPC32');
%

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dialTry wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = dialTry_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
toggleState = get(hObject, 'Value');
while toggleState == 1
  [Az, El, Sat] = satpc32(handles.chan, 'SatPC32');
  set(handles.wrapDial, 'Value', abs(El));
  set(handles.text1,'String',sprintf('%g',abs(El)));
  toggleState = get(hObject, 'Value');
  pause(0.5);
end
% Hint: get(hObject,'Value') returns toggle state of radiobutton1


