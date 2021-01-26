program lab_3;

uses
  crt;

var
  key: char;
  lineCh: integer;
  y, a, b, h, s: double;
  n: integer;
  i: byte;

function f(x: real): real;
begin
  f := x * x * x + 2 * x * x + x + 10;
end;

function f1(x: real): real;
begin
  f1 := (x * (3 * x * x * x + 8 * x * x + 6 * x + 120)) / 12;
end;

procedure inf();
begin
  writeln('1.Реализовать программу вычисления площади фигуры, ограниченной кривой 1 * x^3 + 2 * x^2 + 1 * x + 10 и осью ОХ(в положительной части по оси OY).');
  writeln('2.Вычисление определенного интеграла должно выполняться численно, с применением метода трапеций.');
  writeln('3.Пределы интегрирования вводятся пользователем.');
  writeln('4.Взаимодействие с пользователем должно осуществляться посредстов case menu.');
  writeln('5.Требуется реализовать возможность оценки погрешности полученного результата.');
  writeln('6.Необходимо использовать процедуры и функции там, где это целесообразно');
end;

procedure interval();
begin
  repeat
    writeln('Введите левую границу интегрирования a > -2,8675 ');
    readln(a);
  until (a >= -2.8675);
  repeat
    writeln('Введите правую границу интегрирования > a');
    readln(b);
  until (b > a);
  repeat
    write('Введите кол-во разбиений от 20 до 250 n = ');
    readln(n);
  until (n >= 20) and (n <= 250);
  writeln('Границы интегрирования: (', round(a), ';', round(b), ')', ' Кол-во разбиений: ', n);
end;

procedure pl();
begin
  h := (b - a) / n;
  s := (f(a) + f(b)) / 2;
  for i := 1 to n - 1 do
    s := s + f(a + i * h);
  s := s * h;
  writeln('Площадь = ', s: 0: 5);
end;

procedure an();
begin
  y := f1(b) - f1(a);
  writeln('Аналитическое значение = ', y: 0: 5);
end;

procedure abpogr();
begin
  y := f1(b) - f1(a);
  writeln('Абсолютная погрешность = ', abs(y - s): 0: 5);
end;

procedure otnpogr();
begin
  y := f1(b) - f1(a);
  writeln('Относительная погрешность = ', abs(y - s) / y: 0: 10);
end;

procedure printMenu(indexLine: integer);
var
  menu: array[1..7] of string;
  i: integer;
begin
  menu[1] := 'Информация о задании';
  menu[2] := 'Границы интегрирования кол-во разбиений';
  menu[3] := 'Площадь';
  menu[4] := 'Аналитическое значение';
  menu[5] := 'Абсолютная погрешность';
  menu[6] := 'Относительная погрешность';
  menu[7] := 'Выход';

  for i := 1 to 7 do
  begin
    if i = indexLine then
      textcolor(2);
    writeln(menu[i]);
    textcolor(7);
  end;
end;

begin
  while true do
  begin
    key := readkey;
    clrscr();
    case key of
      #13: printMenu(lineCh);
      #80: begin
        lineCh := lineCh + 1;
        if lineCh > 7 then
          lineCh := 1;
        printMenu(lineCh);
      end;
      #77: begin
        if lineCh = 1 then
          inf();
        if lineCh = 2 then
          interval();
        if lineCh = 3 then
          pl();
        if lineCh = 4 then
          an();
        if lineCh = 5 then
          abpogr();
        if lineCh = 6 then
          otnpogr();
        if lineCh = 7 then
          exit;
      end;
      #72: begin
        lineCh := lineCh - 1;
        if lineCh < 1 then
          lineCh := 7;
        printMenu(lineCh);
      end;
      #27: exit;
    end;
  end;
end.
