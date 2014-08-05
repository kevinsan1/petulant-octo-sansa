function displayEventMessage( response )
% Displays event messages from Table 2.5
casesiwant = {findstr(response,'S'), findstr(response,'D'),...
    findstr(response,'B'), findstr(response,'X')};
if [casesiwant{:}] > 0
  fprintf(response);
else
  caseResponse = str2num(response);
  if not(isempty(caseResponse))
    switch caseResponse
      case 80
        fprintf('%g:Both limits on\n',caseResponse)
      case 81
        fprintf('%g:Active axis reached CW limit\n',caseResponse)
      case 82
        fprintf('%g:Active axis reached CCW limit\n',caseResponse)
      case 83
        fprintf('%g:Active axis pulled out from limit\n',caseResponse)
      case 84
        fprintf('%g:Illegal data or command\n',caseResponse)
      case 88
        fprintf('%g:Positioners stopped in a locking window\n',caseResponse)
      case 92
        fprintf('%g:Operating axis crossed an increment angle\n',caseResponse)
      case 95
        fprintf('%g:Self-test failed\n',caseResponse)
      case 96
        fprintf('%g:Self-test passed\n',caseResponse)
      otherwise
        fprintf('%g\n',caseResponse)
    end
  end
end
end

