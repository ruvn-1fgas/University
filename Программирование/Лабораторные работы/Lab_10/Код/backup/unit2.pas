unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;



type

  { TPieceChose }

  TPieceChose = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
  private

  public
  chosenpiece : string;
  end;

var
  timgfile : array[1..4] of string;
  PieceChose: TPieceChose;

implementation
uses Unit1;
{$R *.lfm}

{ TPieceChose }


procedure TPieceChose.FormShow(Sender: TObject);
begin

   if Box.piececol = 'White' then begin
    Image1.Picture.LoadFromFile('WQ.png');
    timgfile[1] := 'WQ.png';
    Image2.Picture.LoadFromFile('WKN.png');
    timgfile[2] := 'WKN.png';
    Image3.Picture.LoadFromFile('WR.png');
    timgfile[3] := 'WR.png';
    Image4.Picture.LoadFromFile('WBW.png');
    timgfile[4] := 'WBW.png';
  end else
  if Box.piececol = 'Black' then begin
    Image1.Picture.LoadFromFile('BQ.png');
    timgfile[1] := 'BQ.png';
    Image2.Picture.LoadFromFile('BKN.png');
    timgfile[2] := 'BKN.png';
    Image3.Picture.LoadFromFile('BR.png');
    timgfile[3] := 'BR.png';
    Image4.Picture.LoadFromFile('BBW.png');
    timgfile[4] := 'BBW.png';
  end;

end;

procedure TPieceChose.FormCreate(Sender: TObject);
begin




end;

procedure TPieceChose.Image1Click(Sender: TObject);
begin
 chosenpiece := timgfile[1];
  PieceChose.Close;
end;

procedure TPieceChose.Image2Click(Sender: TObject);
begin
  chosenpiece := timgfile[2];
  PieceChose.Close;
end;

procedure TPieceChose.Image3Click(Sender: TObject);
begin
  chosenpiece := timgfile[3];
  PieceChose.Close;
end;

procedure TPieceChose.Image4Click(Sender: TObject);
begin
  chosenpiece := timgfile[4];
  PieceChose.Close;
end;

end.

