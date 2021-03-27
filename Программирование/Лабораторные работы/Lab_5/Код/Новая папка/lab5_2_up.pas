program lab5_2_up;

type cmp = function(a,b:longint):boolean;

var
  t: text;
  a: array of longint;
  r,i: longint;

function cmp1(a,b:longint):boolean; begin cmp1:=a>b end;
function cmp2(a,b:longint):boolean; begin cmp2:=a<b end;

procedure drevodo(var k:array of longint; r1,i:longint; c:cmp);
var l,r,t,b:longint;
begin
t:=i;
l:=2*t+1;
r:=l+1;
if l < r1 then if c(k[l], k[t]) then t:=l;
if r < r1 then if c(k[r], k[t]) then t:=r;
if t<>i then begin
b:=k[i];
k[i]:=k[t];
k[t]:=b;
drevodo(k,r1,t,c);
end;
end;

procedure drevosort(r1:longint; var k:array of longint; c:cmp);
var i,b:longint;
begin
for i:=(r1 div 2)-1 downto 0 do drevodo(k,r1,i,c);
for i:=r1-1 downto 1 do begin
b:=k[0];
k[0]:=k[i];
k[i]:=b;
drevodo(k,i,0,c);
end;
end;

begin
  assign(t, 'input.txt');
  reset(t);
  read(t, r);
  setlength(a,r);
  for i := 0 to r - 1 do
    read(t, a[i]);
  close(t);

  drevosort(r,a,@cmp1);

  assign(t, 'output.txt');
  rewrite(t);
  for i := 0 to  r- 1 do
    write(t, a[i], ' ');
  close(t);

end.

