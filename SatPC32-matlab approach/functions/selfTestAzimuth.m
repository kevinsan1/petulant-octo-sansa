function outputDisplay = selfTestAzimuth ( comPort )
number = 100;
while number ~= 95 && number ~= 96
  fprintf(comPort, '++spoll')
  number = str2num(fgets(comPort));
  pause(0.1);
  if number == 95
    outputDisplay = 'Self-Test Failed';
  elseif number == 96
    outputDisplay = 'Self-Test Passed';
  else
  number = 100;
  end
end
fprintf(comPort, '++spoll');
fgets(comPort);