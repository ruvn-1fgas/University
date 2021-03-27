program rand_input;
var inp:text;
a,i,n:integer;
begin
randomize;
assign(inp,'input.txt');
rewrite(inp);
n:=random(10000)+1;
writeln(inp,n);
writeln('');
for i:=1 to n do begin
a:=random(30000)-15000;
write(inp,a);
write(inp, ' ');
end;
close(inp);
end.
