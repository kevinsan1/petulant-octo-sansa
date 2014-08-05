function clearArduinoBuffer( arduinoCom )

while arduinoCom.BytesAvailable > 0
  fgets(arduinoCom);
  disp('Clearing Arduino Buffer');
  pause(.1);
end
