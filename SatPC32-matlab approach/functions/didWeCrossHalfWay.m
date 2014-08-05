function answer = didWeCrossHalfWay( lastAz, firstAz )
%DIDWECROSSHALFWAY Summary of this function goes here
%   Detailed explanation goes here
difference = abs( lastAz - firstAz );
if difference < 180
  if lastAz <= 180 && firstAz >= 180
    answer = 'y'; % crossed and we went reverse initially
  elseif lastAz >= 180 && firstAz <= 180
    answer = 'y'; % crossed and we went forward initially
  else
    answer = 'n'; % not crossed
  end
else
  disp('crossed too far');
  answer = 'b';
end


end
