unit unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Clipbrd, Graphics, Dialogs, ExtCtrls,
  StdCtrls, LazUTF8, Printers, PrintersDlgs, Menus, StrUtils, ComCtrls, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    Find: TFindDialog;
    Font1: TFontDialog;
    Menu1: TMainMenu;
    N0tepad: TMemo;
    FileMenu: TMenuItem;
    FileCreate: TMenuItem;
    FileSave: TMenuItem;
    FileOpen: TMenuItem;
    FileSaveAs: TMenuItem;
    EditMenu: TMenuItem;
    EditCancel: TMenuItem;
    MenuItem2: TMenuItem;
    FilePrint: TMenuItem;
    MenuItem3: TMenuItem;
    FileExit: TMenuItem;
    MenuItem4: TMenuItem;
    EditCut: TMenuItem;
    EditCopy: TMenuItem;
    EditPaste: TMenuItem;
    EditDelete: TMenuItem;
    MenuItem5: TMenuItem;
    EditFind: TMenuItem;
    FormatMenu: TMenuItem;
    FormatFont: TMenuItem;
    FormatWordWrap: TMenuItem;
    HelpMenu: TMenuItem;
    HelpAbout: TMenuItem;
    HelpCode: TMenuItem;
    EditSelectAll: TMenuItem;
    MenuView: TMenuItem;
    MenuItem7: TMenuItem;
    StatusBar1: TStatusBar;
    ViewStat: TMenuItem;
    OpenFile: TOpenDialog;
    SaveFile: TSaveDialog;
    procedure EditCancelClick(Sender: TObject);
    procedure EditCopyClick(Sender: TObject);
    procedure EditCutClick(Sender: TObject);
    procedure EditDeleteClick(Sender: TObject);
    procedure EditFindClick(Sender: TObject);
    procedure EditMenuClick(Sender: TObject);
    procedure EditPasteClick(Sender: TObject);
    procedure FileExitClick(Sender: TObject);
    procedure FileOpenClick(Sender: TObject);
    procedure FilePrintClick(Sender: TObject);
    procedure FileSaveClick(Sender: TObject);
    procedure FindFind(Sender: TObject);
    procedure FormatFontClick(Sender: TObject);
    procedure FormatWordWrapClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure N0tepadChange(Sender: TObject);
    procedure FileMenuClick(Sender: TObject);
    procedure FileCreateClick(Sender: TObject);
    procedure EditSelectAllClick(Sender: TObject);
    procedure FileSaveAsClick(Sender: TObject);
    procedure N0tepadUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
    procedure NotepadChange(Sender: TObject);
    procedure Notebook1ChangeBounds(Sender: TObject);
    procedure NotepadResize(Sender: TObject);
    procedure ViewStatClick(Sender: TObject);
  private
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Notebook1ChangeBounds(Sender: TObject);
begin

end;

procedure TForm1.NotepadResize(Sender: TObject);
begin

end;

procedure TForm1.ViewStatClick(Sender: TObject);
begin
  ViewStat.Checked := not ViewStat.Checked;
  if ViewStat.Checked then StatusBar1.Visible := true else StatusBar1.Visible := false;
end;

procedure TForm1.NotepadChange(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  StatusBar1.Panels.Items [1].Text := 'Символов: ' + IntToStr(UTF8Length(N0tepad.Text));
    StatusBar1.Panels.Items [2].Text := 'Слов: ' + IntToStr(WordCount(N0tepad.Text, StdWordDelims));
    StatusBar1.Panels.Items [3].Text := 'Строк: ' + IntToStr(N0tepad.Lines.Count);
end;

procedure TForm1.FormPaint(Sender: TObject);
begin

end;

procedure TForm1.FileSaveClick(Sender: TObject);
begin
  if SaveFile.FileName <> '' then begin
    N0tepad.Lines.SaveToFile(Utf8ToSys(SaveFile.FileName));
    N0tepad.Modified:= false;
  end
  else FileSaveAsClick(Sender);
end;

procedure TForm1.FindFind(Sender: TObject);
  var
     Found, StartPos: Integer;
     ToFind, Where : string;
  begin
     ToFind := Find.FindText;
     Where := N0tepad.Text;
     if not (frMatchCase in Find.Options) then
     begin
        ToFind := AnsiUpperCase(ToFind);
        Where := AnsiUpperCase(Where);
     end;

     if N0tepad.SelLength <> 0 then
     begin
        StartPos := N0tepad.SelStart;
        StartPos := StartPos + N0tepad.SelLength
     end;

        Found := UTF8Pos(ToFind, Where, StartPos + 1);

     if Found <> 0 then
     begin
        N0tepad.HideSelection := False;
        N0tepad.SelStart := Found - 1;
        N0tepad.SelLength := UTF8Length(Find.FindText);
     end
     else
        MessageDlg ('Блокнот', 'Не удается найти "' + Find.FindText + '"', mtConfirmation, [mbOK], 0);
  end;

procedure TForm1.FormatFontClick(Sender: TObject);
begin
  Font1.Font:= N0tepad.Font;
  if Font1.Execute then N0tepad.Font:= Font1.Font;
end;

procedure TForm1.FormatWordWrapClick(Sender: TObject);
begin
  FormatWordWrap.Checked:= not FormatWordWrap.Checked;
  N0tepad.WordWrap:= FormatWordWrap.Checked;
  if N0tepad.WordWrap then N0tepad.ScrollBars:= ssVertical
  else N0tepad.ScrollBars:= ssBoth;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if N0tepad.Modified then begin
    if MessageDlg('Сохранение файла',
                  'Вы хотите сохранить изменения в файле?',
         mtConfirmation, [mbYes, mbNo, mbIgnore], 0) = mrYes then
            FileSaveClick(Sender);
  end;
end;

procedure TForm1.EditDeleteClick(Sender: TObject);
begin
   N0tepad.ClearSelection;
end;

procedure TForm1.EditFindClick(Sender: TObject);
  begin
  with Find do
  begin
  Options := Options + [frHideUpDown, frHideWholeWord];
  Execute;
  end;
end;

procedure TForm1.EditMenuClick(Sender: TObject);
begin
  with N0tepad do begin
  if SelLength >= 1 then begin
  EditCopy.Enabled := true;
  EditCut.Enabled := true;
  EditDelete.Enabled := true;
  end
  else begin
  EditCopy.Enabled := false;
  EditCut.Enabled := false;
  EditDelete.Enabled := false;
  end;
  end;
  if Clipboard.HasFormat(CF_TEXT) then
  EditPaste.Enabled := true
  else
  EditPaste.Enabled := false;
end;

procedure TForm1.EditPasteClick(Sender: TObject);
begin
   N0tepad.PasteFromClipboard;
end;

procedure TForm1.FileExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FileOpenClick(Sender: TObject);
begin
  if N0tepad.Modified then begin
    if MessageDlg('Сохранение файла',
                  'Вы хотите сохранить изменения в файле?',
         mtConfirmation, [mbYes, mbNo, mbIgnore], 0) = mrYes then
            FileSaveClick(Sender);
  end;
  OpenFile.FileName:= '';
  OpenFile.Title:= 'Открытие';
  if OpenFile.Execute then begin
    if N0tepad.Text <> '' then N0tepad.Clear;
    N0tepad.Lines.LoadFromFile(Utf8ToSys(OpenFile.FileName));
    SaveFile.FileName:= OpenFile.FileName;
  end; //if
end;

procedure TForm1.FilePrintClick(Sender: TObject);
var
  printerDialog : TPrintDialog;
  myPrinter   : TPrinter;
begin
  printerDialog:=TPrintDialog.Create(Form1);
  if printerDialog.Execute then
  begin
    myPrinter := Printer;
    with myPrinter do
    begin
      BeginDoc;
      N0tepad.PaintTo(myPrinter.Canvas, 0, 0);
      EndDoc;
    end;
  end;
end;

procedure TForm1.EditCancelClick(Sender: TObject);
begin
  N0tepad.Undo;
end;

procedure TForm1.EditCopyClick(Sender: TObject);
begin
  N0tepad.CopyToClipboard;
end;

procedure TForm1.EditCutClick(Sender: TObject);
begin
  N0tepad.CutToClipboard;
end;

procedure TForm1.N0tepadChange(Sender: TObject);
begin
  StatusBar1.Panels.Items [1].Text := 'Символов: ' + IntToStr(UTF8Length(N0tepad.Text));
    StatusBar1.Panels.Items [2].Text := 'Слов: ' + IntToStr(WordCount(N0tepad.Text, StdWordDelims));
    StatusBar1.Panels.Items [3].Text := 'Строк: ' + IntToStr(N0tepad.Lines.Count);
end;

procedure TForm1.FileMenuClick(Sender: TObject);
begin

end;

procedure TForm1.FileCreateClick(Sender: TObject);
begin
  if N0tepad.Modified then begin
    if MessageDlg('Сохранение файла',
                  'Вы хотите сохранить изменения в файле?',
         mtConfirmation, [mbYes, mbNo, mbIgnore], 0) = mrYes then
            FileSaveClick(Sender);
  end; //if
  if N0tepad.Text <> '' then N0tepad.Clear;
  SaveFile.FileName:= '';
end;

procedure TForm1.EditSelectAllClick(Sender: TObject);
begin
  N0tepad.SelectAll;
end;

procedure TForm1.FileSaveAsClick(Sender: TObject);
begin
  SaveFile.Title := 'Сохранить как...';
  If SaveFile.Execute then begin
    N0tepad.Lines.SaveToFile(Utf8ToSys(SaveFile.FileName));
    N0tepad.Modified:= false;
  end;
end;

procedure TForm1.N0tepadUTF8KeyPress(Sender: TObject; var UTF8Key: TUTF8Char);
begin

end;

end.

