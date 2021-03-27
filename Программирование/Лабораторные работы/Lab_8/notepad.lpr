program notepad;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Translations, printer4lazarus, unit1, Unit2
  { you can add units after this };

{$R *.res}

begin
  Translations.TranslateUnitResourceStrings('lclstrconsts', 'lclstrconsts.ru.po');
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TQR, QR);
  Application.Run;
end.

