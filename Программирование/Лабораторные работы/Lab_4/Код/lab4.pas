program lab_4;

uses
  wincrt,
  crt,
  graph,
  math;

const
  x0 = -2.8675;
var
  lineCh, n,gmashX, gmashY: int64;
  gd,gm:integer;
  key: char;
  gx2, gx1, a, b,h, s, y: double;
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
  writeln('7.Предусмотреть вывод кривой, масштабирование графика, подписи на осях, вывод информации о задании.');
  writeln('8.Реализовать не менее двух возможностей из представленных: независимое масштабирование по осям,');
  writeln('штриховка вычисляемой площади, визуализация численного расчета интеграла.');
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

procedure drawgraph;
var
  gmx, gmy, gx, gdx, gy1, gh, sra: real;
  kolY, kolX, gx0, gy0, gpx, gpy, gi, gn: integer;
  gs: string;

begin
  setbkcolor(white);
  cleardevice;
  setcolor(blue);//15
  gx0 := getmaxX div 2;
  gy0 := (getmaxY div 10) * 9;
  gmx := gmashX * 20;
  gmy := gmashY * 10;
  line(gx0 - round(gmx * 13), gy0, getmaxX - 20, gy0);
  line(gx0, getmaxy - 20, gx0, 20);
  setcolor(3);
  outtextXY(getmaxX - 25, gy0 + 10, 'X');
  outtextXY(gx0 + 15, 20, 'Y');
  setcolor(blue);//15
  kolX := (getmaxX - 50 - gx0) div round(gmx);
  kolY := (getmaxY - 100) div round(gmy);

  for gi := -12 to kolX do
  begin
    if (gi = a) or (gi = b) then
      setcolor(4)
    else
      setcolor(blue);//15
    str(gi, gs);
    outtextXY(gx0 + round(gi * gmx) - 4, gy0 + 10, gs);
    line(gx0 + round(gi * gmx), gy0 - 2, gx0 + round(gi * gmx), gy0 + 2);
  end;

  setcolor(blue);//15

  for gi := 1 to kolY do
  begin
    str(gi, gs);
    outtextXY(gx0 - 20, gy0 - round(gi * gmy) - 3, gs);
    line(gx0 - 2, gy0 - round(gi * gmy), gx0 + 2, gy0 - round(gi * gmy));
  end;

  gx := gx1;
  gdx := 0.001;
  gpy := 200;
  setcolor(10);
  while (gx <= gx2) do
  begin
    gpx := gx0 + round(gx * gmx);
    gy1 := (gx * gx * gx + 2 * gx * gx + gx + 10);
    gpy := gy0 - round(gy1 * gmy);

    if gx = gx1 then
      moveto(gpx, gpy);

    lineto(gpx, gpy);
    gx := gx + gdx;
  end;
  sra := power((gy0 / gmy), 1 / 3);
  setcolor(4);

  if a <> b then
  begin
    if a > sra then
      line(gx0 + round(a * gmx), gy0, gx0 + round(a * gmx), 0)

    else
    if a > x0 then
      line(gx0 + round(a * gmx), gy0, gx0 + round(a * gmx), gy0 - round((a * a * a + 2 * a * a + a + 10) * gmy));

    if b > x0 then
      if b > sra then
        line(gx0 + round(b * gmx), gy0, gx0 + round(b * gmx), 0)

      else
        line(gx0 + round(b * gmx), gy0, gx0 + round(b * gmx), gy0 - round((b * b * b + 2 * b * b + b + 10) * gmy));
    ;
  end;
  gh := 45 / sin(pi / 4) / gmx * 1 / 2;
  gn := round((b - a) / gh) + 10;

  for gi := gn + 50 downto -50 do
  begin
    gx := a;
    while gx <= b do
    begin
      gx := gx + gdx;
      gpx := gx0 + round(gx * gmx);
      gy1 := gx + gh * (gn - gi);
      gpy := gy0 - round(gy1 * gmy * (gmx / gmy));

      if (gpy < gy0) and (gpy > (gy0 - round((gx * gx * gx + 2 * gx * gx + gx + 10) * gmy))) then
        putpixel(gpx, gpy, 4);
    end;
  end;
  setcolor(blue);//15
  outtextXY(20, 40, 'left,right - zooming OX');
  outtextXY(20, 50, 'up,down - zooming OY');
  outtextXY(700, 40, 'f(x) = 1 * x^3 + 2 * x^2 + 1 * x + 10');
end;

procedure grafik();
var
  key: char;
begin
  gmashX := 4;
  gmashY := 4;
  gx1 := -4;
  gx2 := 4;
  gd := detect;
  initgraph(gd, gm,' ');
  drawgraph;

  repeat
    Key := wincrt.readkey;
    if key = #0 then
    begin
      key := wincrt.readkey;
      case key of
        #77:
        begin
          gmashX := gmashX + 1;
          cleardevice;
          drawgraph;
        end;

        #75:
        begin
          if gmashX <> 1 then
            gmashX := gmashX - 1;
          cleardevice;
          drawgraph;
        end;

        #72:
        begin
          gmashY := gmashY + 1;
          cleardevice;
          drawgraph;
        end;

        #80:
        begin
          if gmashY <> 1 then
            gmashY := gmashY - 1;
          cleardevice;
          drawgraph;
        end;
      end;
    end;
  until key = #13;
  closegraph;
end;

procedure printMenu(indexLine: integer);
var
  menu: array[1..8] of string;
  i: integer;
begin
  menu[1] := 'Информация о задании';
  menu[2] := 'Границы интегрирования кол-во разбиений';
  menu[3] := 'Площадь';
  menu[4] := 'Аналитическое значение';
  menu[5] := 'Абсолютная погрешность';
  menu[6] := 'Относительная погрешность';
  menu[7] := 'График';
  menu[8] := 'Выход';

  for i := 1 to 8 do
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
        if lineCh > 8 then
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
          grafik();
        if lineCh = 8 then
          exit;
      end;
      #72: begin
        lineCh := lineCh - 1;
        if lineCh < 1 then
          lineCh := 8;
        printMenu(lineCh);
      end;
      #27: exit;
    end;
  end;
end.
