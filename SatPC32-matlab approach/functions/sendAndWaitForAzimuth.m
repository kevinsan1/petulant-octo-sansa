function sendAndWaitForAzimuth( thisAz, sport )
sendAzimuthTo( thisAz , sport );
currentAzimuth = getCurrentAzimuth( sport );
while abs(currentAzimuth - thisAz) > 1 && abs(currentAzimuth - thisAz) < 359
  currentAzimuth = getCurrentAzimuth( sport );
  disp('Not there yet');
  pause(1);
end
disp('There');