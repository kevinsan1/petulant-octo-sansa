function clearAzimuthOutput( sport )
if nargin < 1
  sport = serial('COM4');
  fopen(sport); 
end
number = 1;
try
while number ~= 144 && number ~= 24 && number ~= 20
  fprintf(sport, '++spoll');
  while (sport.BytesAvailable > 0)
    strNum = fgets(sport);
    number = str2double(strNum);
    disp(sprintf('Clear Azimuth Buffer: %g', number));
    pause(1);
    displayEventMessage(strNum);
  end
end
catch
 disp(sprintf(['Error in clearAzimuthOutput.m\n' lasterr]));
end