function trueAzimuth = getCurrentAzimuth( comPort )
%% trueAzimuth = getCurrentAzimuth( comPort )
% trueAzimuth = number
% comPort = fopen('COM4')
fprintf(comPort, 'X1<');
fprintf(comPort, '++spoll');
pause(1);
fgets(comPort);
rotorAzimuthOutput = fgets(comPort);
pause(1);
if not(isempty(rotorAzimuthOutput))
  currentAzimuth = textscan(rotorAzimuthOutput,'%c%c%f%c%f');
  trueAzimuth = currentAzimuth{5}/1000;
else
  trueAzimuth = -100;
  pause(1);
end