function realElevation = stopElevation( comPort )

fprintf(comPort, 'r');
pause(0.5)
currentElevation = fgets(comPort); % will be string 6578 for 65.78
realElevation = str2double(currentElevation)/100;
currentElevation = convertNumberToFormat(realElevation);
fprintf(comPort, ['e' currentElevation]); 