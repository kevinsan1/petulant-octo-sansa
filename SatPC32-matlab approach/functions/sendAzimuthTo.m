function sendAzimuthTo( Az, sport )
% Az = number
% sport = fopen('COM4')

try
  % fprintf(sport, 'H<');
  % pause(0.5);
  fprintf(sport, 'L<');
  stringAz = convertNumberToFormat(Az);
  fprintf(sport, ['Pat' stringAz '<']); % fprintf(sport, ['Pat00000<']);
  % fprintf(sport, 'H<');
  % pause(0.5);
  fprintf(sport, 'G<'); % Run
  fprintf(sport, 'G<'); % Run ( needed twice when in direct mode )
catch ME
  disp(ME);
  disp('Error occuring in sendAzimuthTo.m');
end



end