function response = sendAndReceive( serialPort,commands, state )
if nargin < 3
    state = 'S<';
end
switch state
case 's' | 'S<' | 's<' | 'S';
    state = 'S<';
  case 'l' | 'L<' | 'l<' | 'L';
    state = 'L<';
end
fprintf(serialPort, 'H<')
fprintf(serialPort, state)
for p = 1:length(commands)
    fprintf(serialPort, commands{p});
    disp(['Command sent: ' commands{p}]);
    if strcmp(state,'S<')
      pause(.5);
      fprintf(serialPort, '++spoll');
      pause(0.5);
      while serialPort.BytesAvailable ~= 0
        response{p} = fgets(serialPort);
        % Display id
        disp(response{p});
        pause(0.5);
      end
    end
end
if state == 'L<'
  fprintf(serialPort, 'G<');
  pause(1);
  response = 'Loaded commands';
end
fprintf(serialPort, 'H<')

end

