function timeToDelay = waitForArduinoElevation( arduinoSerial, Elevation )
currentElevation = getCurrentElevation(arduinoSerial);
rateOfArduino = 180/83; % 180 degrees/83 seconds
degreeDifference = abs(Elevation - currentElevation);
timeToDelay = degreeDifference / rateOfArduino; % answer in seconds
