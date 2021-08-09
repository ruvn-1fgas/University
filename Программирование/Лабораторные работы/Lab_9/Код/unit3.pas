unit Unit3;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, FileUtil;
type
 TValue = record
 surname: string[20];
 firstname: string[10];
 year: integer;
 avsc: integer;
 end;
 TArray = array of TValue;
 function cmp(a, b : TValue): Integer;
 procedure merge_sort(source, dest, tmp1, tmp2 : String);
 procedure swap(var a, b : TValue);
 procedure heapify(var a : TArray; i, sz : Int64);
 procedure make_heap(var a : TArray; sz : Int64);
 procedure heap_sort(var a : TArray; sz : Int64);
 function check_sorted(name : String): Boolean;
 procedure chunk_sort(name, tmp : String; sz, chunk_sz : Int64);
implementation
function cmp(a, b : TValue): Integer;
var
 sn, fn, av, ye : Integer;
begin


 av := b.avsc - a.avsc;
 sn := AnsiCompareStr(a.surname, b.surname);
 fn := AnsiCompareStr(a.firstname, b.firstname);
 ye := b.year - a.year;

 {Ключ сортировки
 1.	year      По возрастанию
 2.	avsc      По убыванию
 3.	surname   По возрастанию
 4.	firstname По возрастанию  }

   if ye = 0 then
   if av = 0 then
   if sn = 0 then
   if fn < 0 then
   cmp := -1
   else if fn > 0 then cmp := 1 else cmp := 0
   else if sn < 0 then cmp := -1 else cmp := 1
   else if av > 0 then cmp := 1 else cmp := -1
   else if ye > 0 then cmp := -1 else cmp := 1;



 //av := AnsiCompareStr(a.avsc, b.avsc);
 //sn := AnsiCompareStr(a.surname, b.surname);
 //fn := AnsiCompareStr(a.firstname, b.firstname);
 //
 //if av = 0 then
 //if sn = 0 then
 //if fn < 0 then
 //cmp := -1
 //else if fn > 0 then
 //cmp := 1
 //else  cmp := 0
 //else if sn < 0 then
 //cmp := -1
 //else
 //cmp := 1
 //else if av > 0 then
 //cmp := -1
 //else
 //cmp := 1;
end;
procedure merge_sort(source, dest, tmp1, tmp2: String);
const
 chunk_size = 10;//131072;           //В 21 раз меньше max_n, желательно ровно в 21, иначе может незначительно увеличиться время сортировки, либо сортировка будет с ошибкой
var
 i, j, cnt, size : Int64;
 dest_f, tmp1_f, tmp2_f : file of TValue;
 tmp, l, r : TValue;
begin


 if not FileExists(dest) then
 assign(dest_f, dest);





 assign(tmp1_f, source);
 reset(tmp1_f);
 cnt := 0;
 // copy to dest
 while not eof(tmp1_f) do
 begin
 read(tmp1_f, tmp);
 inc(cnt);
 end;
 close(tmp1_f);
 chunk_sort(source, dest, cnt, chunk_size);
 size := chunk_size;
 while size < cnt do
 begin
 assign(dest_f, dest);
 reset(dest_f);
 assign(tmp1_f, tmp1);
 rewrite(tmp1_f);
 assign(tmp2_f, tmp2);
 rewrite(tmp2_f);
 // splitting
 while not eof(dest_f) do
 begin
 i := 0;
 while (i < size) and (not eof(dest_f)) do
 begin
 read(dest_f, tmp);
 write(tmp1_f, tmp);
 inc(i);
 end;
 j := 0;
 while (j < size) and (not eof(dest_f)) do
 begin
 read(dest_f, tmp);  write(tmp2_f, tmp);
 inc(j);
 end;
 end;
 close(dest_f);
 close(tmp1_f);
 close(tmp2_f);
 // merging
 assign(dest_f, dest);
 rewrite(dest_f);
 assign(tmp1_f, tmp1);
 reset(tmp1_f);
 assign(tmp2_f, tmp2);
 reset(tmp2_f);
 while (not eof(tmp1_f)) and (not eof(tmp2_f)) do
 begin
 i := 0; j := 0;
 while (i < size)
 and (j < size)
 and (not eof(tmp1_f))
 and (not eof(tmp2_f)) do
 begin
 read(tmp1_f, l);
 read(tmp2_f, r);
 if cmp(r, l) = -1 then // r < l
 begin
 write(dest_f, r);
 seek(tmp1_f, FilePos(tmp1_f) - 1);
 inc(j);
 end
 else // l <= r
 begin
 write(dest_f, l);
 seek(tmp2_f, FilePos(tmp2_f) - 1);
 inc(i);
 end;
 end;
 while (i < size) and (not eof(tmp1_f)) do
 begin
 read(tmp1_f, l);
 write(dest_f, l);
 inc(i);
 end;
 while (j < size) and (not eof(tmp2_f)) do
 begin
 read(tmp2_f, r);
 write(dest_f, r);
 inc(j);
 end;
 end;
 while not eof(tmp1_f) do
 begin  read(tmp1_f, l);
 write(dest_f, l);
 end;
 while not eof(tmp2_f) do
 begin
 read(tmp2_f, r);
 write(dest_f, r);
 end;
 close(tmp1_f);
 close(tmp2_f);
 close(dest_f);
 //writeln(size);
 size := size * 2;
 end;
 //erase(tmp1_f);
 //erase(tmp2_f);
end;
procedure swap(var a, b : TValue);
var
 tmp : TValue;
begin
 tmp := a;
 a := b;
 b := tmp;
end;
procedure heapify(var a : TArray; i, sz : Int64);
var
 left, right, max : Int64;
begin
 max := i;
 repeat
 i := max;
 left := max * 2 + 1;
 right := max * 2 + 2;
 //
 //max := i;
 //
 if (left < sz) and (cmp(a[left], a[max]) = 1) then
 max := left;
 if (right < sz) and (cmp(a[right], a[max]) = 1) then
 max := right;
 if (max <> i) then
 begin
 swap(a[i], a[max]);
 //
 //heapify(a, max, sz);
 //
 end;
 until max = i;
end;
procedure make_heap(var a : TArray; sz : Int64);
var
 i : Int64;
begin
 i := sz div 2;  while i >= 0 do
 begin
 heapify(a, i, sz);
 dec(i);
 end;
end;
procedure heap_sort(var a : TArray; sz : Int64);
var
 i : Int64;
begin
 make_heap(a, sz);
 i := sz - 1;
 while i >= 1 do
 begin
 swap(a[sz - 1], a[0]);
 dec(sz);
 heapify(a, 0, sz);
 dec(i);
 end;
end;
procedure chunk_sort(name, tmp : String; sz, chunk_sz : Int64);
var
 curp, i, j : Int64;
 dest_f, tmp_f : file of TValue;
 a : TArray;
begin
 assign(dest_f, name);
 reset(dest_f);
 assign(tmp_f, tmp);
 rewrite(tmp_f);
 SetLength(a, chunk_sz);
 curp := 0;
 while curp < sz do
 begin
 i := 0;
 while (i < chunk_sz) and (curp < sz) do
 begin
 read(dest_f, a[i]);
 inc(i);
 inc(curp);
 end;
 heap_sort(a, i);
 j := 0;
 while j < i do
 begin
 write(tmp_f, a[j]);
 inc(j);
 end;
 end;
 close(dest_f);
 close(tmp_f);
 CopyFile(tmp, name); end;
function check_sorted(name: String): Boolean;
var
 a, b : TValue;
 dest_f : file of TValue;
begin
 assign(dest_f, name);
 reset(dest_f);
 read(dest_f, a);
 check_sorted := true;
 while not eof(dest_f) do
 begin
 read(dest_f, b);
 if cmp(a, b) = 1 then
 begin
 check_sorted := false;
 break;
 end;
 a := b;
 end;
 close(dest_f);
end;
end.

