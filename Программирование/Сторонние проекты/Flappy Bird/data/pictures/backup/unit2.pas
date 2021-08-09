unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Registry, StdCtrls;

type

  { TWelcomeForm }

  TWelcomeForm = class(TForm)
    Image1: TImage;
    Image2: TImage;
    BestScoreLab: TLabel;
    ScoreLab: TLabel;
    Welcome: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure WelcomeClick(Sender: TObject);
  private

  public

  end;

var
  bestscore : integer;
  WelcomeForm: TWelcomeForm;

implementation
uses Unit1;
{$R *.lfm}

{ TWelcomeForm }

procedure TWelcomeForm.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = 32 then WelcomeForm.Close;

  if key = 27  then GeneralForm.Close;

end;

procedure TWelcomeForm.FormCreate(Sender: TObject);

var Reg : TRegistry;

begin

  try
  Reg := TRegistry.Create;
  Reg.OpenKey('Laz\Flappy_Bird', False);
  try
    BestScore := Reg.ReadInteger('BestScore');
  except
    BestScore := 0;
  end;
    Reg.Free;
  except
  end;


  if BestScore <= GeneralForm.score1 then BestScore := GeneralForm.score1;

  if  not GeneralForm.first_start then begin
    Welcome.Picture.LoadFromFile('data\pictures\deathscreen.png');
    if GeneralForm.score1 >= 30 then image2.Picture.loadfromfile('data\pictures\golden.png');
    if (GeneralForm.score1 < 30) and (GeneralForm.score1 >= 15) then image2.Picture.loadfromfile('data\pictures\silven.png');
    if GeneralForm.score1 < 15 then image2.Picture.loadfromfile('data\pictures\bronze.png');

    ScoreLab.Caption := IntToStr(GeneralForm.score1);
    BestScoreLab.Caption := IntToStr(BestScore);

  end;


end;

procedure TWelcomeForm.WelcomeClick(Sender: TObject);
begin

end;

end.

