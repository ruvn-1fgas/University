program lab_1;
uses math;
const
start = -9;
endt = 2;
step = 0.3;
var x, y : real;
begin
  	x := start;
  	while (x <= endt) do
  	begin
    		if (x < -7) then
      		y := tan(x) / 71

    		else if (x >= -7) and (x < 0) then begin
      		x := round(x * 100) / 100;
      		y := ((x * x) / (exp(0.1 * (-x) * ln(-x))) * (log2(-x) / (x * x * x)))
    		end

    		else if x >= 0.3 then
      		y := (exp(0.1 * x * ln(x)) / cos(x) + x);

     		writeln('x = ', x:2:2, ' y = ', y:6:2);

    		x := x + step;
  	end;
readln;
end.
