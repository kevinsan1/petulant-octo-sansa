function sendCommand(commands)


try
fprintf(sport, 'H<');
pause(0.1);
fprintf(sport, commands{1});
fprintf(sport, commands{2});
fprintf(sport, 'H<');
pause(.5)                   % Wait 50 msec between 'H' & 'G'
fprintf(sport, 'G<');        % Turn CONTROLLER to 'RUN': Start motion
catch
  disp(lasterr);
end