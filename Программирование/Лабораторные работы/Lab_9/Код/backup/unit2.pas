unit Unit2;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, fileutil;
type
 TValue = record
 surname: string[20];
 firstname: string[10];
 year: integer;
 avsc: integer;
 end;
procedure generate(sn, fn, y, av, d : String);
implementation
//uses unit1;
const max_n = 24504606;//2739137;     //Кол-во записей. Высчитать для гигабайта довольно просто
var
 f1 : file of string[20];
 f2 : file of string[10];
 f3 : file of string[7];
 f4 : file of string[5];
 pathes : array [1..4] of String;
 dest : file of TValue;
 name : String;
 rec : TValue;
 N : Int64;

procedure generate(sn, fn, y, av, d : String);
var s : string[20] = '';
 ss : string[7];
 sss : string[5];
begin

 randomize;
 pathes[1] := sn;
 pathes[2] := fn;
 pathes[3] := y;
 pathes[4] := av;
 name := d;
 Assign(dest, name);
 Rewrite(dest);
 N := 0;

 Assign(f1, pathes[1]);
 Assign(f2, pathes[2]);
 Assign(f3, pathes[3]);
 Assign(f4, pathes[4]);

 Reset(f1);
 Reset(f2);
 Reset(f3);
 Reset(f4);

 randomize;

 while (N < max_n) and (not eof(f3)) do
 begin

 repeat
 seek(f1,random(9300));
 read(f1,s)
 until length(s) > 2;

 seek(f2,random(5000));
 seek(f3,random(340));
 seek(f4,random(400));

 read(f1, rec.surname);
 read(f2, rec.firstname);
 read(f3, ss);//rec.year);
 rec.year := StrToInt(ss);
 read(f4, sss);//rec.avsc);
 rec.avsc := StrToInt(sss);
 write(dest, rec);
 inc(N);

 end;

 close(f1);
 close(f2);
 close(f3);
 close(f4);
 close(dest);

end;

end.

