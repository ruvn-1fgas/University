program lab5_1;
type cmp_t = function(a, b : Longint):Integer;
 array_t = array [0..1000100] of Longint;
function cmp1(a, b : Longint):Integer;
begin
 if a = b then
 cmp1 := 0
 else if a < b then
 cmp1 := -1
 else if a > b then
 cmp1 := 1;
end; 
procedure swap(var a, b : Longint);
var t : Longint;
begin
 t := a;
 a := b;
 b := t;
end;
procedure pyramid(var arr : array_t; count:integer; cmp : cmp_t);
procedure DownHeap(index, Count:Integer; Current:integer);
var
 Child:integer;
begin
 while index < Count div 2 do
     begin
      Child := (index+1)*2-1;
      if (Child < Count-1) and (arr[Child] < arr[Child+1]) then
        Child:=Child+1;
      if Current >= arr[Child] then
        break;
      arr[index] := arr[Child];
      index := Child;
    end;
    arr[index] := Current;
end;
var
  i: integer;
  Current: integer;
begin
  for i := (Count div 2)-1 downto 0 do
    DownHeap(i, Count, arr[i]);
    if cmp1(arr[i - 1], arr[i]) = 1 then 
  for i := Count downto 0 do begin
    Current := arr[i];
    arr[i] := arr[0];
    DownHeap(0, i, Current);
  end
  else if cmp1(arr[i - 1], arr[i]) = -1 then
    for i := 0 downto Count do begin
    Current := arr[i];
    arr[i] := arr[0];
    DownHeap(0, i, Current);
  end;
end;
var inp, out : TextFile;
 s : array_t;
 n, i : Longint;
begin
 assign(inp, 'input.txt');
 assign(out, 'output.txt');
 reset(inp);
 rewrite(out);
 readln(inp, n);
 for i := 0 to n - 1 do
 read(inp, s[i]);
 pyramid(s, n, @cmp1);
 for i := 0 to n - 1 do
 write(out, s[i], ' ');
 close(inp);
 close(out);
end.
