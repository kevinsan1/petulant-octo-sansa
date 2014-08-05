function currentElevation = getCurrentElevation(comPort)
%  	Description
%	currentElevation = getCurrentElevation(comPort)
%   comPort = fopen(serial('COM4')), already opened in another function

fprintf(comPort, 'r'); % tell arduino to analogread
pause(0.01);
currentElevation = str2double(fgets(comPort))/100; % read in elevation

end % function
