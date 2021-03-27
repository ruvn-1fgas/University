program lab5_1;
type cmp_t = function(a, b : Longint):Integer;
 array_t = array [0..1000100] of Longint;
function cmp1(a, b : Longint):Integer;
begin
 if a = b then
 cmp1 := 0
 else if a < b then
 cmp1 := 1
 else if a > b then
 cmp1 := -1;
end; 
procedure swap(var a, b : Longint);
var t : Longint;
begin
 t := a;
 a := b;
 b := t;
end;
procedure heapsort(var arr: array_t; n:integer; cmp:cmp_t);
var L, R: integer;
procedure sift (L, R: integer);
var i, j: integer; x: integer;
begin i:=L; j:=2*L; x:=arr[L];
if (j<R) and (cmp(arr[j],arr[j+1])=-1) then j:=j+1;
while (j <= R) and (cmp(x,arr[j])=-1) do begin
arr[i]:=arr[j]; i:=j; j:=2*j;
if (j < R) and (cmp(arr[j],arr[j+1])=-1) then j:=j+1;
end;
arr[i]:=x
end;
begin
L:=(n Div 2)+1; R:=n;
while L > 1 do begin L:=L-1; sift(L, R) end;
while R > 1 do begin 
if cmp(arr[R], arr[1]) = -1 then
swap(arr[1],arr[R]);
dec(R); 
sift(L, R)
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
 for i := 1 to n do
 read(inp, s[i]);
 heapsort(s, n, @cmp1);
 for i := 1 to n do
 write(out, s[i], ' ');
 close(inp);
 close(out);
end.
