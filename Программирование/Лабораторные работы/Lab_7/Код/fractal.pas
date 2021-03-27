unit fractal;

interface

uses
  wincrt,
  Crt,
  Graph;

const
  step = 10;
  max_depth = 9;
  scale = 2;
  depth_1 = 1;

var
  key: char;
  x: integer;
  y: integer;
  h: integer;
  x_r: integer;
  y_r: integer;
  x1: integer;
  y1: integer;
  n: byte;
  n1,n2 : single;
  i : integer;
  
  gm,gd: smallint;

procedure move;

implementation

procedure LD;
begin
  Linerel(0, h);
end;

procedure LU;
begin
  Linerel(0, -h);
end;

procedure LL;
begin
  Linerel(-h, 0);
end;

procedure LR;
begin
  Linerel(h, 0);
end;

procedure GDw(i: byte); forward;
procedure GUp(i: byte); forward;
procedure draw; forward;

procedure GL(i: byte);
begin
  if i > 0 then
  begin
    GDw(i - 1);
    LL;
    GL(i - 1);
    LD;
    GL(i - 1);
    LR;
    GUp(i - 1);
  end;
end;

procedure GR(i: byte);
begin
  if i > 0 then
  begin
    GUp(i - 1);
    LR;
    GR(i - 1);
    LU;
    GR(i - 1);
    LL;
    GDw(i - 1);
  end;
end;

procedure GUp(i: byte);
begin
  if i > 0 then
  begin
    GR(i - 1);
    LU;
    GUp(i - 1);
    LR;
    GUp(i - 1);
    LD;
    GL(i - 1);
  end;
end;

procedure GDw(i: byte);
begin
  if i > 0 then
  begin
    GL(i - 1);
    LD;
    GDw(i - 1);
    LL;
    GDw(i - 1);
    LU;
    GR (i - 1);
  end;
end;

procedure center;
begin
  n1 := -0.5;
  n2 := 1;
for i := 1 to n - 1 do begin
  n2 := n2 * 2;
  end;
  x := trunc((x_r div 2) + (h * (n1 + n2)));
  y := trunc((y_r div 2) - (h * (n1 + n2)));
end;

procedure y_s(step_p: integer);
begin
  y1 := y1 + step_p;
  if y1 > (y_r + 300) then y1 := y_r + 300 else if y1 < -900 then y1 := -300;
  draw;
end;

procedure x_s(step_p: integer);
begin
  x1 := x1 + step_p;
  if (x1 > x_r + 300) then x1 := x_r + 300 else if x1 < -900 then x1 := -300;
  draw;
end;

procedure h_sc(h_scale: integer);
begin
  h := h + h_scale;
  if h_scale = 0 then h := 16;
  if h < 4 then
    h := 4;
  if h > 62 then h := 62;
  draw;
end;

procedure depth(depth_s: integer);
begin
  n := n + depth_s;
  if n < 1 then
    n := 1;
  if (n > max_depth) then n := max_depth;
  //if (h = 4) and (n > max_depth + 1) then n := max_depth + 1;
  draw;
end;

procedure draw;
begin
  center;
  ClearDevice;
  moveto(x + x1, y + y1);
  GDw(n);
end;

procedure move;
var
  key: char;
begin
  gd := VGA;
  gm := detectmode;
  InitGraph(gd, gm, '');
  x_r := GetMaxX;
  y_r := GetMaxY;
  //writeln('x = ', x_r,' ','y = ', y_r);
  draw;
  repeat
    key := wincrt.readkey;
    if key = #0 then
    begin
    key := wincrt.readkey;
    case ord(key) of
    72: y_s(-step);
    80: y_s(step);
    75: x_s(-step);
    77: x_s(step);
    end;
    end
    else begin
    case ord(key) of
    119: h_sc(scale);
    115: h_sc(-scale);
    99: h_sc(0);
    45: depth(-depth_1);
    61: depth(depth_1);
    end;
    end;
  until Ord(key) = 27;
  closegraph;
end;
end.
