function [] = wrapDialFunction()
%
evalin('base','close all;clc;clear;');
% dial_demo.m--Demonstration of dial.m.
%
% Syntax: dial_demo

% Developed in Matlab 7.6.0.324 (R2008a) on GLNX86.
% Kevin Bartlett (kpb@uvic.ca), 2008-06-20 12:03
%-------------------------------------------------------------------------

% Open figure created in guide.m. Figure contains axes that will be deleted
% once their positions have been extracted and used for creating dial
% objects.
open('demo_layout.fig');
set(gcf,'name','dial.m demonstration');
set(gcf,'NumberTitle','off');
% 
% %-------------------------------------------------------------------------
% % Make non-"snap" dial.
% %-------------------------------------------------------------------------
% 
% % Get position from placeholder axes, then delete them.
% placeHolderName = 'noSnapAx';
% thisAx = findobj('Tag',placeHolderName);
% thisPos = get(thisAx,'position');
% delete(thisAx);
% 
% noSnapDial = dial('refVal',0,...
%     'refOrientation',255*pi/180,...
%     'valRangePerRotation',12, ...
%     'Min',0, ...
%     'Max',11,...
%     'Value',0,...
%     'Position',thisPos,...
%     'Tag','noSnapDial', ...
%     'CallBack',@nosnap_cb,...
%     'titleStr','No Snap',...
%     'titlePos','bottom',...    
%     'tickVals', [0 1 2 3 4 5 6 7 8 9 10 11],...
%     'tickStrs',{'0'  '1'  '2'  '3'  '4'  '5'  '6'  '7'  '8'  '9'  '10'  '11'});
% 
% set(findobj('Tag','noSnapText'),'string',sprintf('%f',noSnapDial.Value));
% set(findobj('Tag','noSnapText'),'BackgroundColor',get(gcf,'color'));
% 
% %-------------------------------------------------------------------------
% % Make "snap" dial.
% %-------------------------------------------------------------------------
% 
% % Get position from placeholder axes, then delete them.
% placeHolderName = 'snapAx';
% thisAx = findobj('Tag',placeHolderName);
% thisPos = get(thisAx,'position');
% delete(thisAx);
% 
% snapDial = dial('refVal',0,...
%     'refOrientation',255*pi/180,...
%     'valRangePerRotation',5, ...
%     'Min',1, ...
%     'Max',4,...
%     'Value',1,...
%     'doSnap',1,...
%     'Position',thisPos,...
%     'dialRadius',0.35,...
%     'tickRadius',0.45,...
%     'tickLabelRadius',0.45,...
%     'HorizontalAlignment','left',...
%     'Tag','snapDial', ...
%     'CallBack',@snap_cb,...
%     'titleStr','''Snapping'' on',...
%     'titlePos','top',...    
%     'tickVals', [1 2 3 4],...
%     'tickStrs',{'OFF'  'A'  'B'  'A + B'});
% 
% set(findobj('Tag','snapText'),'string','OFF');
% 
% % Fine-tune position of dial inside panel using handle graphics ('OFF' tick
% % label is bumping up against edge of panel).
% newLeftPos = 0.36;
% newBottPos = 0.73;
% axPos = get(snapDial.dialAxes,'position');
% axPos(1) = newLeftPos;
% axPos(2) = newBottPos;
% set(snapDial.dialAxes,'position',axPos);
% 
% axPos = get(snapDial.tickPlateAxes,'position');
% axPos(1) = newLeftPos;
% axPos(2) = newBottPos;
% set(snapDial.tickPlateAxes,'position',axPos);
% 
% axPos = get(snapDial.mouseAxes,'position');
% axPos(1) = newLeftPos;
% axPos(2) = newBottPos;
% set(snapDial.mouseAxes,'position',axPos);
% 
% % Use handle graphics to customise dial appearance.
% set(snapDial.dialFaceHndl,'faceColor','k','edgeColor','w');
% set(snapDial.panelHndl,'facecolor','k','edgeColor','w');
% set(snapDial.tickHndls,'color','w');
% set(snapDial.tickLabelHndls,'color','w');
% set(snapDial.titleHndl,'color','w');
% set(snapDial.titleHndl,'position',[0 1.1 0]);
% set(snapDial.linePointerHndl,'color','r');
% set(findobj('Tag','snapText'),'ForegroundColor','k','BackgroundColor','w');

%-------------------------------------------------------------------------
% Make "wrap" dial.
%-------------------------------------------------------------------------

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
% Make "radio tuner" with two circle-style dials, one for coarse tuning,
% the other for fine tuning.
%-------------------------------------------------------------------------

% % FM band is 87.5 to 108.0 MHz. 
% minDialVal = 87.5;
% maxDialVal = 108.0;
% startVal = minDialVal;
% 
% % Magnitude of mega-Hertz value change for one rotation of dial:
% coarseMHzPerRot = 10;
% fineMHzPerRot = .5;
% 
% % Make coarse-tuning dial.
% 
% % ...Get positions from placeholder axes, then delete them.
% placeHolderName = 'coarseAx';
% thisAx = findobj('Tag',placeHolderName);
% coarsePos = get(thisAx,'position');
% delete(thisAx);
% 
% placeHolderName = 'fineAx';
% thisAx = findobj('Tag',placeHolderName);
% finePos = get(thisAx,'position');
% delete(thisAx);
% 
% coarseDial = dial('Tag','coarse',...
%     'Position',coarsePos,...
%     'titleStr','coarse',...
%     'titlePos','top',...
%     'drawTicks',false,...
%     'pointerStyle','circle',...
%     'valRangePerRotation',coarseMHzPerRot,...
%     'refVal',minDialVal,...
%     'refOrientation',90*pi/180,...
%     'Value',startVal,...
%     'Min',minDialVal,...
%     'Max',maxDialVal,...
%     'doWrap',false,...
%     'dialRadius',0.75,...
%     'CallBack',@coarse_cb);
% 
% fineDial = dial('Tag','fine',...
%     'Position',finePos,...
%     'titleStr','fine',...
%     'titlePos','top',...
%     'drawTicks',false,...
%     'pointerStyle','circle',...
%     'circlePtrRadius',0.1,...
%     'valRangePerRotation',fineMHzPerRot,...
%     'refVal',minDialVal,...
%     'refOrientation',90*pi/180,...
%     'Value',startVal,...
%     'Min',minDialVal,...
%     'Max',maxDialVal,...
%     'doWrap',false,...
%     'dialRadius',0.45,...
%     'CallBack',@fine_cb);
% 
% freqStr = get_freq_str(startVal);
% set(findobj('Tag','radioText'),'string',freqStr);
% set(findobj('Tag','radioText'),'BackgroundColor',get(gcf,'color'));
% 
% %-------------------------------------------------------------------------
% function [] = nosnap_cb()
% % nosnap_cb.m--Callback for "nosnap" dial.
% %-------------------------------------------------------------------------
% 
% noSnapDial = dial.find_dial('noSnapDial','-1');
% dialVal = get(noSnapDial,'Value');
% set(findobj('Tag','noSnapText'),'string',sprintf('%f',dialVal));
% 
% %-------------------------------------------------------------------------
% function [] = snap_cb()
% % snap_cb.m--Callback for "snap" dial.
% %-------------------------------------------------------------------------
% 
% snapDial = dial.find_dial('snapDial','-1');
% dialVal = get(snapDial,'Value');
% tickStrs = get(snapDial,'tickStrs');
% thisStr = tickStrs{dialVal};
% set(findobj('Tag','snapText'),'string',thisStr);

%-------------------------------------------------------------------------
function [] = wrap_cb()
% wrap_cb.m--Callback for "wrap" dial.
%-------------------------------------------------------------------------

wrapDial = dial.find_dial('wrapDial','-1');
dialVal = round(get(wrapDial,'Value'));
set(findobj('Tag','wrapText'),'string',sprintf('%d',dialVal));
%        
% %-------------------------------------------------------------------------
% function [] = coarse_cb()
% %
% % coarse_cb.m--Callback for the coarse-tuning dial.
% %
% % Syntax: coarse_cb
% 
% %-------------------------------------------------------------------------
% 
% coarseDial = dial.find_dial(gcf,'coarse','-1');
% fineDial = dial.find_dial(gcf,'fine','-1');
% dialVal = coarseDial.Value;
% 
% set(fineDial,'Value',dialVal);
% freqText =  findobj('Tag','freqText');
% 
% freqStr = get_freq_str(dialVal);
% set(findobj('Tag','radioText'),'string',freqStr);
%  
% %-------------------------------------------------------------------------
% function [] = fine_cb()
% %
% % fine_cb.m--Callback for the fine-tuning dial.
% %
% % Syntax: fine_cb
% 
% %-------------------------------------------------------------------------
% 
% coarseDial = dial.find_dial(gcf,'coarse','-1');
% fineDial = dial.find_dial(gcf,'fine','-1');
% 
% dialVal = fineDial.Value;
% 
% set(coarseDial,'Value',dialVal);
% freqText =  findobj('Tag','freqText');
% freqStr = get_freq_str(dialVal);
% set(findobj('Tag','radioText'),'string',freqStr);
%  
% %-------------------------------------------------------------------------
% function [freqStr] = get_freq_str(dialVal)
% %
% % get_freq_str.m--Get frequency string.
% %
% % Syntax: freqStr = get_freq_str(dialVal)
% 
% % e.g., freqStr = get_freq_str(90.5)
% %-------------------------------------------------------------------------
% 
% freqStr = sprintf('%8.2f MHz',dialVal);
% 
