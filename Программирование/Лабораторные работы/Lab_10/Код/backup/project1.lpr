program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Unit1, Unit2;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title := 'Шахматы - Ванчугов Рустам ПИб-1301';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TBox, Box);
  Application.Run;
end.

