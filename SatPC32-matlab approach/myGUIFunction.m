function [] = myGUIFunction()
close all force;

open('demo_layout2.fig');
set(gcf,'name','dial.m demonstration');
set(gcf,'NumberTitle','off');

%% Make "wrap" dial.
% Get position from placeholder axes, then delete them.
placeHolderName = 'wrapAx';

thisAx = findobj('Tag',placeHolderName);
thisPos = get(thisAx,'position');
delete(thisAx);

wrapDial = dial('refVal',0,...
    'refOrientation',90*pi/180,...
    'valRangePerRotation',360, ...
    'Min',0,...
    'Max',359,...
    'doWrap',1,...
    'Value',0,...
    'Position',thisPos,...
    'VerticalAlignment','bottom',...
    'Tag','wrapDial',...
    'CallBack',@wrap_cb,...
    'titleStr','''Wrapping'' on',...
    'titlePos','top',...    
    'tickVals', [0 90 180 270],...
    'tickStrs',{'N'  'E'  'S'  'W'});

% Static text object superimposed on dial panel. Will look better if text
% background is same colour as panel.
faceColour = get(wrapDial.panelHndl,'facecolor');
set(findobj('Tag','wrapText'),'BackgroundColor',faceColour,'ForegroundColor','r');
set(findobj('Tag','wrapText'),'string','0');

% Shrink the size of the dial face to show more of the tick lines.
set(wrapDial,'dialRadius',0.55);

% Customise dial pointer using handle graphics (want arrow instead of
% straight line).
x = [0 .55 .4 NaN .55 .4];
y = [0 0 .14 NaN 0 -.14];
set(wrapDial.linePointerHndl,'xdata',x,'ydata',y);
set(wrapDial.linePointerHndl,'color','r');

% Move the tick labels a little further away from the dial face.
set(wrapDial,'tickLabelRadius',0.69);

% Give the tick labels a different font using handle graphics.
set(wrapDial.tickLabelHndls,'fontname','Courier');
set(wrapDial.tickLabelHndls,'fontWeight','Bold');
set(wrapDial.tickLabelHndls,'fontSize',16);

%-------------------------------------------------------------------------
function [] = wrap_cb()
% wrap_cb.m--Callback for "wrap" dial.
%-------------------------------------------------------------------------

wrapDial = dial.find_dial('wrapDial','-1');
dialVal = round(get(wrapDial,'Value'));
set(findobj('Tag','wrapText'),'string',sprintf('%d',dialVal));
