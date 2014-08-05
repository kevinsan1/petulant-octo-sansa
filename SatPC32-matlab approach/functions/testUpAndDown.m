function [up,down] testUpAndDown( comPort )
if nargin < 1
    comPort = 'COM3';
end
flag = 1;
delete(instrfind);
sport = serial(comPort);
set(sport,'DataBits', 8 );
set(sport,'StopBits', 1 );
set(sport,'BaudRate', 9600);
set(sport,'Parity', 'none');
sport.Terminator = {'CR/LF','CR/LF'};

sport.Timeout = 1;
try
    fopen(sport);
catch
    flag = 0;
end
pause(1);
%% Send all the way down
fprintf(sport, 'r');
pause(0.1);
currentElevation = fgets(sport);
fprintf(sport,'d');
time = 1:80;
for i = 1:80
  fprintf(sport, 'r');
  pause(0.05);
  a = fgets(sport);
  down(:,i) = str2double(a);
  pause(1);
end
fprintf(sport,'u');
time = 1:80;
for i = 1:80
  fprintf(sport, 'r');
  pause(0.05);
  a = fgets(sport);
  up(:,i) = str2double(a);
  pause(1);
end

%% First Plot
figure(1);clf
plot(time,down,'.',time,up,'.')
legend('down','up')
