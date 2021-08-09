unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Dialogs,Classes, SysUtils, Forms, Controls, Graphics, StdCtrls, EditBtn, MaskEdit, Unit2, Unit3, MMSystem;


type
 TValue = record
 surname: string[20];
 firstname: string[10];
 year: integer;
 avsc: integer;
 end;

type

  { TSortForm }

  TSortForm = class(TForm)
    GenButton: TButton;
    ExampleLabel: TLabel;
    OpDi1: TOpenDialog;
    OpDi2: TOpenDialog;
    OpDia1: TOpenDialog;
    OpDia2: TOpenDialog;
    SortButton: TButton;
    CheckButton: TButton;
    InputFileButton: TEditButton;
    OutputFileButton: TEditButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure CheckButtonClick(Sender: TObject);
    procedure GenButtonClick(Sender: TObject);
    procedure InputFileButtonButtonClick(Sender: TObject);
    procedure OutputFileButtonButtonClick(Sender: TObject);
    procedure SortButtonClick(Sender: TObject);

  private

  public
  end;

var

  SortForm: TSortForm;
implementation
{$R *.lfm}

{ TSortForm }



procedure TSortForm.GenButtonClick(Sender: TObject);
var start, theend : TDateTime;
begin
 if InputFileButton.Text <> '' then begin
  start := now;
  try
  generate('data\surname.ini','data\firstname.ini','data\years.ini','data\avsc.ini',InputFileButton.Text);
  sndPlaySound('check.wav',SND_ASYNC);
  theend := now;
  MessageDlg('Генерация', 'Файл успешно сгенерирован' + #13#10 + #13#10 + TimeToStr(theend - start),mtCustom,[mbOK], 0);
  except exit;
  end;
  end
  else begin
  MessageDlg('Ошибка', 'Ошибка в названии файла',mtError,[mbOK], 0); exit; end;
end;

procedure TSortForm.CheckButtonClick(Sender: TObject);

  procedure LabelImport(str : TValue);
 begin
  ExampleLabel.caption := ExampleLabel.caption + str.surname + ' ' + str.firstname + ' ' + IntToSTR(str.year) + ' ' + IntToStr(str.avsc) + #13#10;
 end;

var dest : file of TValue;
str : array[1..15] of TValue;
i : integer;
start, theend : TDateTime;
begin
 try
  start := Now;
  if check_sorted(OutputFileButton.Text) then begin
 assignfile(dest, OutputFileButton.Text);
 reset(dest);
 for i := 1 to 15 do begin
 read(dest,str[i]);
 LabelImport(str[i]);
 end;
 sndPlaySound('check.wav',SND_ASYNC);
 theend := Now;
 MessageDlg('Сортировка', 'Файл успешно отсортирован!' + #13#10 + #13#10 + ExampleLabel.Caption + #13#10 + #13#10 + TimeToStr(theend-start),mtCustom,[mbOK], 0);
 closefile(dest);
 ExampleLabel.Caption := '';
  end
 else begin
 sndPlaySound('check.wav',SND_ASYNC);
 MessageDlg('Ошибка', 'Ошибка при сортировке файла',mtError,[mbOK], 0);
 end;
 except MessageDlg('Ошибка', 'Ошибка в названии файла',mtError,[mbOK], 0); exit; end;
end;

procedure TSortForm.InputFileButtonButtonClick(Sender: TObject);
begin
 if OpDi1.Execute then
 InputFileButton.Text := OpDi1.FileName;
end;

procedure TSortForm.OutputFileButtonButtonClick(Sender: TObject);
begin
 if OpDi2.Execute then
 OutputFileButton.Text := OpDi2.FileName;
end;

procedure TSortForm.SortButtonClick(Sender: TObject);
const
 tmp1_f = 'tmp1.tmp';
 tmp2_f = 'tmp2.tmp';
 var
 start, theend : TDateTime;

begin

 if OutputFileButton.Text <> '' then begin

 try
 Start := Now;
 merge_sort(InputFileButton.Text,
 OutputFileButton.Text,
 tmp1_f,
 tmp2_f);
 sndPlaySound('check.wav',SND_ASYNC);
 theend := Now;
 MessageDlg('Сортировка', 'Готово' + #13#10 + #13#10 + TimeToStr(theend-Start) ,mtCustom,[mbOK], 0);
 except MessageDlg('Ошибка', 'Ошибка в названии файла',mtError,[mbOK], 0); end;
 end else MessageDlg('Ошибка', 'Ошибка в названии файла',mtError,[mbOK], 0);


end;

end.

