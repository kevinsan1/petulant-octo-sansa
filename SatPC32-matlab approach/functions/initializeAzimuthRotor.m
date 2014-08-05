function [sport, flag] = initializeAzimuthRotor( comPort )
%   comPort = 'COM4'
%   isAlreadyConnected = 1 if connected already
%   isAlreadyConnected = 0 if not connected already
if nargin < 1
  comPort = 'COM4';
end
try
  flag = 1;

  sport = serial(comPort);
  sport.Terminator = {'CR/LF', 'CR/LF'};
  sport.Timeout = .5;

  fopen(sport);

  fprintf(sport, '++mode 1');
  fprintf(sport, '++addr 15');
  fprintf(sport, '++auto 1');
  fprintf(sport, '++clr');
  fprintf(sport, 'H<');
  fprintf(sport, 'L<');
  fprintf(sport, 'Ae0<');
  fprintf(sport, 'Aa1<'); % choose axis'
  fprintf(sport, 'A1<'); 
  fprintf(sport, 'Dad<');  % Take directions automatically
  fprintf(sport, 'Va00999<') % Velocity 99 %
%   fprintf(sport, 'Bf34999<');
%   fprintf(sport, 'Br00000<');
  fprintf(sport, 'MU<') % Sends the orbit to track mode
  fprintf(sport, 'O35000<'); % Offset 350.00 degrees
  fprintf(sport, 'Pat00000<');
%   fprintf(sport, 'H<');
%   pause(0.5);
%   fprintf(sport, 'K<');
%   pause(0.5);
  fprintf(sport, 'G<');
  fprintf(sport, 'G<');
  
%   waitForLockMessage(sport);
catch ME
  flag = 0;
  sport = 0;
end

