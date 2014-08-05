function [sport, flag] = initializeArduino( comPort )
if nargin < 1
    comPort = 'COM3';
end
flag = 1;
sport = serial(comPort);
set(sport,'DataBits', 8 );
set(sport,'StopBits', 1 );
set(sport,'BaudRate', 9600);
set(sport,'Parity', 'none');
sport.Terminator = {'CR/LF','CR/LF'};
% sport.BytesAvailableFcn = 'fgets(sport)';
sport.Timeout = 1;
try
    fopen(sport);
catch
    flag = 0;
end
%%
% pause(1); %% needed
% fprintf(s,['e145' 'd']);
% pause(1);
% fprintf(s,'a45u');
% pause(1);
% fprintf(s,'e13d');
% pause(.1);
% fprintf(s,'a45s');
% %%
% fclose(s);
%%
% fprintf(sport,'d');
% for i = 1:80
%   fprintf(sport, 'r')
%   down4(:,i) = str2double(ans);
%   pause(1);
% end
% %% First Plot
% figure(1);clf
% plot(1:160,down,'.',1:160,up,'.',1:160,up2,'.',1:160,down2,'.',1:2:160,up3(1:80),'.',1:2:160,down3,'.');
% legend('down','up','up2','down2','up3','down3');
