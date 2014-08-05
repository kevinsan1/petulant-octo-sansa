clearvars -except azimuthSerialPort
number = 180;
number = fliplr(number);
i = 1;
while i <= 8
  fprintf(azimuthSerialPort, 'L<')
  stringAz = convertNumberToFormat(number(i));
  fprintf(azimuthSerialPort, ['Pat' stringAz '<'])
  fprintf(azimuthSerialPort, 'G<')
  fprintf(azimuthSerialPort, 'G<')
  pause(1);
  [currentAzimuth, rotorAzimuthOutput] = getCurrentAzimuth(azimuthSerialPort);
  pause(1);
  if (number(i)-currentAzimuth) < 90
    i = i + 1;
  end
  pause(0.5);
end