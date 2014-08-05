function  [chan, flag] = satpc32_com ( program )
if nargin < 1
  program = 'SatPC32';
end
switch program
  case 'Orbitron'
    linktopic = 'Tracking';
  case 'NFW32'
    linktopic = 'NFW_DATA';
  case 'SatPC32'
    linktopic = 'SatPcDdeConv';
end
try
  chan = ddeinit(program,linktopic);
  flag = 1;
  if strcmp(program,'NFW32')
    flag = ddepoke(chan, 'NFW_SERVER','TUNE ON');
  end
catch
  disp(sprintf([program ' not connected\n' lasterr]));
  flag = 0;
  chan = 0;
end
end
