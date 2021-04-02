unit Unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, unit1;

type

  { TNoteSave }

  TNoteSave = class(TForm)
    NoteSaveLabel: TLabel;
    NotSave: TButton;
    CancelSave: TButton;
    Save: TButton;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure NoteSaveLabelClick(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private

  public

  end;

var
  NoteSave: TNoteSave;

implementation

{$R *.lfm}

{ TNoteSave }

procedure TNoteSave.Panel1Click(Sender: TObject);
begin

end;

procedure TNoteSave.NoteSaveLabelClick(Sender: TObject);
begin

end;

procedure TNoteSave.FormCreate(Sender: TObject);
begin
  NoteSaveLabel.Caption := 'Вы хотите сохранить изменения в файле "' + SaveFile.FileName + '"?';
end;

end.

