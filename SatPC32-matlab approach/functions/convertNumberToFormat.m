function stringNumber = convertNumberToFormat(number)
% stringNumber = '03245' -> 32.45
if number >= 100
  stringNumber = num2str(number,'%-5.2f');
elseif number < 10
  stringNumber = ['00' num2str(number,'%-5.2f')];
else
  stringNumber = ['0' num2str(number,'%-5.2f')];
end
stringNumber = strrep(stringNumber, '.', '');