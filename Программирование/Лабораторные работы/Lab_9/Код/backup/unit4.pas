unit Unit4;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Math, Unit2, MMSystem;

//function gettext2;

type

  { TForm1 }

  TForm1 = class(TForm)
    GenButton1: TButton;
    NumOfStrLabel: TLabel;
    FileSizeLabel: TLabel;
    NumOfStr: TEdit;
    procedure GenButton1Click(Sender: TObject);
    procedure NumOfStrChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  ttext : string;

implementation
 uses Unit1;
{$R *.lfm}

{ TForm1 }

procedure TForm1.NumOfStrChange(Sender: TObject);
var size : int64;
  s: string;
begin
  try
  size := StrToInt64(NumOfStr.Text)*46;
  except size := 0;
  end;

  if (size > 1024) then if size < (1024*1024) then s := 'Примерный размер файла: ' + FloatToStr(SimpleRoundTo(size/(1024),-2)) + ' КБайт';
  if (size > 1024*1024) then if size < (1024*1024*1024) then s := 'Примерный размер файла: ' + FloatToStr(SimpleRoundTo(size/(1024*1024),-2)) + ' МБайт';
  if (size < 1024) then s := 'Примерный размер файла: ' + IntToStr(size) + ' Байт';
  if size > 1024*1024*1024 then s := 'Примерный размер файла: ' + FloatToStr(SimpleRoundTo(size/(1024*1024*1024),-2)) + ' ГБайт';

  FileSizeLabel.Caption := s;


  end;

procedure TForm1.GenButton1Click(Sender: TObject);
var start, theend : TDateTime;
begin

 ttext := SortForm.s;

   if ttext <> '' then begin
 start := now;
 try
 generate('data\surname.ini','data\firstname.ini','data\years.ini','data\avsc.ini',ttext, NumOfStr.Text);
 sndPlaySound('check.wav',SND_ASYNC);
 theend := now;
 MessageDlg('Генерация', 'Файл успешно сгенерирован' + #13#10 + #13#10 + TimeToStr(theend - start),mtCustom,[mbOK], 0);
 except exit;
 end;
 end
 else begin
 MessageDlg('Ошибка', 'Ошибка в названии файла',mtError,[mbOK], 0); exit; end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin

end;

end.

