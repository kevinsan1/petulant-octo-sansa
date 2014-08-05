% **************** SatPc32 - Matlab Interface ************
% Works via DDE, SatPC32 will respond with the string ** NO SATELLITE ** if
% the elevation is less than zero. This can be fixed, see documenation for DDE in SatPc32.

function [Az, El, Sat] = satpc32(chan, program)
if nargin < 2
  program = 'SatPC32';
end
% SatPC delivers a string with the following strucutre:
%SNJUGNU AZ16.3 EL-48.4 UP0 UM DN0 DM MA132.0

key1 = 'AZ';
key2 ='EL';
key3 = 'DN'; %For satellite name

switch program
  case 'SatPC32'
    linkItem = 'SatPcDdeItem';
    data = ddereq(chan, linkItem, [1,1]);
    Index1 = strfind(data, key1);
    Index2 = strfind(data, key2);
    Index3 = strfind(data, key3);
    Az = sscanf(data(Index1(1) + length(key1):end), '%g', 1); % For Satpc
    El = sscanf(data(Index2(1) + length(key2):end), '%g', 1) ;
    Sat = data(3:(Index1-1));
  case 'Orbitron'
    data = ddereq(chan, linkItem, [1,1]);
    Index1 = strfind(data, key1);
    Index2 = strfind(data, key2);
    Index3 = strfind(data, key3);
    Sat = data(3:(Index1-1));
    Az = sscanf(data((Index1(1) + length(key1)):(Index2-1)), '%f', 1);
    El = sscanf(data((Index2(1) + length(key2)):(Index3-1)), '%f', 1);
end


end