program Gilbert;

uses crt,fractal,graph;

var press : integer;

procedure print_help;
begin
  writeln('W - увеличение размера');
  writeln('S - уменьшение размера');
  writeln('С - возврат к первоначальному размеру');
  writeln('+ - увеличение глубины');
  writeln('- - уменьшение глубины');
  writeln('Стрелки - перемещение изображения');
  writeln('Esc - завершение работы программы');
  writeln(' ');
  writeln('Нажмите Enter для визуализации фрактала');
end;

begin
  print_help;
  h := 16; //Длина стороны
  n := 1; //Глубина
  repeat
  press := 0
  until crt.readkey = #13;
  move;
end.
