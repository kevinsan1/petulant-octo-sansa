function waitForLockMessage(comPort)
if nargin < 1
  ports = instrfind;
  comPort = ports(3);
end
flag = 1;
for i = 1:10
  try
    fprintf(comPort, '++spoll');
    pause(.5);
    flag = str2double(fgets(comPort));
    if flag == 88
      disp('Lock Message Received');
      break;
    else
      disp('Lock Message not Received');
    end
    pause(1);
  end
end