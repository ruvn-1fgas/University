program lab2_1;
var
 a:array[1..100] of integer;
 i, min, max: byte;
 sum, N: integer;
begin
 writeln('Введите кол-во элементов массива');
 readln(N);
 while (N < 1) or (N > 100) do begin
 writeln('Введите целое число от 1 до 100');
 readln(N);
 end;
 for i := 1 to N do begin
   writeln('Введите ',i,'-ый элемент массива');
   read(a[i]);
 end;
 writeln;
 min := 1;
 max := 1;
 for i := 2 to N do begin
   if a[i] <= a[min] then min := i else
   if a[i] >= a[max] then max := i;
 end;
 writeln(a[max],' ', a[min]);

 if min > max then begin
   i := min;
   min := max;
   max := i;
 end;

 sum := 0;
 for i := min + 1 to max - 1 do begin
   sum := sum + a[i]
 end;
 writeln(sum);
 readln;
end.
