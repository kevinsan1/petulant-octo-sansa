function [ direction ] = compareAzimuthDirection( firstAz, secondAz, azimuthPort )

% firstAz
% secondAz
fprintf(azimuthPort, 'H<');
fprintf(azimuthPort, 'L<');
difference = firstAz - secondAz;

if difference < 0
  fprintf(azimuthPort, 'Daf<');
  direction = 'f';
elseif difference >= 0
  fprintf(azimuthPort, 'Dar<');
  direction = 'r';
end
fprintf(azimuthPort, 'H<');

end
