program lab2_2;
var
  s,ss: string;
  i: byte; flag: boolean;
begin
   write('Введите строку: ');
   readln(s);
   flag := true;
   for i := 1 to length(s) div 2 do
     if lowercase(s[i]) <> lowercase(s[length(s) - i + 1]) then begin
       writeln('Строка не является палиндромом');
       flag := false;
     break;
     end;
     if flag then
       write('Строка является палиндромом');
     readln;
end.
