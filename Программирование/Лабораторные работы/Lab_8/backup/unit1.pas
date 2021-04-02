unit unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, Windows, SysUtils, Forms, Controls,ShellAPI,Clipbrd, Graphics, Dialogs, DateUtils,
  StdCtrls, LazUTF8, Printers, PrintersDlgs, Registry, Menus, StrUtils, ComCtrls,
  ExtCtrls, Unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Find: TFindDialog;
    Font1: TFontDialog;
    Menu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem6: TMenuItem;
    EditTimeDate: TMenuItem;
    FormatTextAlligment: TMenuItem;
    FormatAllLeft: TMenuItem;
    FormatAllCenter: TMenuItem;
    FormatAllRight: TMenuItem;
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
    EditSelectAll: TMenuItem;
    MenuView: TMenuItem;
    StatusBar1: TStatusBar;
    ViewStat: TMenuItem;
    OpenFile: TOpenDialog;
    SaveFile: TSaveDialog;
    procedure EditCancelClick(Sender: TObject);
    procedure EditCopyClick(Sender: TObject);
    procedure EditCutClick(Sender: TObject);
    procedure EditDeleteClick(Sender: TObject);
    procedure EditFindBingClick(Sender: TObject);
    procedure EditFindClick(Sender: TObject);
    procedure EditMenuClick(Sender: TObject);
    procedure EditPasteClick(Sender: TObject);
    procedure FileExitClick(Sender: TObject);
    procedure FileOpenClick(Sender: TObject);
    procedure FilePrintClick(Sender: TObject);
    procedure FileSaveClick(Sender: TObject);
    procedure FindFind(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormatAllCenterClick(Sender: TObject);
    procedure FormatAllLeftClick(Sender: TObject);
    procedure FormatAllRightClick(Sender: TObject);
    procedure FormatFontClick(Sender: TObject);
    procedure FormatWordWrapClick(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormClose(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of string);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormResize(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);

    procedure HelpAboutClick(Sender: TObject);
    procedure EditTimeDateClick(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure N0tepadChange(Sender: TObject);
    procedure FileCreateClick(Sender: TObject);
    procedure EditSelectAllClick(Sender: TObject);
    procedure FileSaveAsClick(Sender: TObject);
    procedure N0tepadClick(Sender: TObject);
    procedure N0tepadKeyPress(Sender: TObject);
    procedure N0tepadKeyUp(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ViewStatClick(Sender: TObject);
    procedure SaveFontToRegistry(FontA: TFont; SubKey: string);
    function ReadFontFromRegistry(FontA: TFont; SubKey: string): boolean;
    procedure GetFilesInDirs(Dir: string);
    procedure AddFile(Filename: string);

  private
  public

  end;

const
  allowedExtensions = '*.txt;*.pas;*.cs;';


var
  ext : string;
  Form1 : TForm1;
  FilePath : string;
  FileName : string;
  t : int64;
  saved, cancel, modcheck : boolean;

implementation

{$R *.lfm}
{ TForm1 }

procedure TForm1.SaveFontToRegistry(FontA: TFont; SubKey: string);
var
  R :  TRegistry;
  FontStyleInt : byte;
  FS : TFontStyles;
begin
  R := TRegistry.Create;
  try
    FS := FontA.Style;
    Move(FS, FontStyleInt, 1);
    R.OpenKey(SubKey, True);
    R.WriteString('Font Name', FontA.Name);
    R.WriteInteger('Color', FontA.Color);
    R.WriteInteger('CharSet', FontA.Charset);
    R.WriteInteger('Size', FontA.Size);
    R.WriteInteger('Style', FontStyleInt);
  finally
    R.Free;
  end;
end;


procedure TForm1.ViewStatClick(Sender: TObject);
begin
  ViewStat.Checked := not ViewStat.Checked;
  if ViewStat.Checked then
    StatusBar1.Visible := True
  else
    StatusBar1.Visible := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  NFont : TFont;
begin
  NFont := TFont.Create;
  if ReadFontFromRegistry(NFont, 'Delphi Kingdom\Fonts') then
  begin
    N0tepad.Font.Assign(NFont);
    Font1.Font.Assign(NFont);
    NFont.Free;
  end;
  SaveFile.FileName := 'Безымянный';
    ext := '';
    Form1.Caption := SaveFile.FileName + ' - Блокнот';
    FileName := '';
    FilePath := SaveFile.FileName;
    N0tepad.Modified := False;
end;

procedure TForm1.FormDblClick(Sender: TObject);
begin

end;

procedure TForm1.FormDropFiles(Sender: TObject; const FileNames: array of string);
var
  RowCounter, Counter : integer;
begin
  if N0tepad.Modified then    //Проверка на изменение файла
    modcheck := False
  else
    modcheck := True;
  ;
  if N0tepad.Modified then
  begin
    case MessageDlg('Сохранение файла',
        'Вы хотите сохранить изменения в файле "' +
        FilePath + '"?', mtCustom, [mbYes, mbNo, mbCancel], 0) of
      mrYes : FileSaveClick(Sender);    //Сохранение
      mrNo : cancel := True;       //Нажатие нет
      mrCancel : exit;             //Отмена
    end;
  end;
  if saved or cancel or modcheck then
    //Если файл сохранен, либо был отказ, либо нн изменен
  begin
    for Counter := 0 to Length(FileNames) - 1 do
    begin
      if DirectoryExists(FileNames[Counter]) then
        //Проверка на существованме директории с файл
        GetFilesInDirs(FileNames[Counter])
      //Запуск процедуры взятия файлов из директории
      else
        AddFile(FileNames[Counter]);
      //Запуск процедуры добавления файлов
    end;
  end;
end;

procedure TForm1.GetFilesInDirs(Dir: string);
var
  DirInfo : TSearchRec;
begin
  if FindFirst(Dir + DirectorySeparator + '*', faAnyFile and faDirectory,
    DirInfo) = 0 then
    repeat
      if (DirInfo.Attr and faDirectory) = faDirectory then
        // it's a dir - go get files in dir
      begin
        if (DirInfo.Name <> '.') and (DirInfo.Name <> '..') then
          GetFilesInDirs(Dir + DirectorySeparator + DirInfo.Name);
      end
      else  // It's a file; add it
        AddFile(Dir + DirectorySeparator + DirInfo.Name);
      //Запуск процедуры добавления файлов
    until FindNext(DirInfo) <> 0;
  FindClose(DirInfo);
end;

procedure TForm1.AddFile(Filename: string);
begin
  if (FileName <> '') and (Pos(LowerCase(ExtractFileExt(Filename)),
    //Сравнение расширения файла с разрешенными (константа)
    allowedExtensions) > 0) then
  begin
    if N0tepad.Text <> '' then
      //Очистка теста, если он не пуст
      N0tepad.Clear;
    N0tepad.Lines.LoadFromFile(Utf8ToSys(Filename));
    //Загрузка текста из файла
    FilePath := Filename;
    //Дальше стандартно
    SaveFile.FileName := ExtractFileName(Filename);
  end
  else
  MessageDlg('Блокнот', 'Данный тип файла не поддерживается', mtError, [mbOK], 0);
  Form1.Caption := SaveFile.FileName + ' - Блокнот';
  FileName := SaveFile.FileName;
  N0tepad.Modified := False;
end;


procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure TForm1.FormResize(Sender: TObject);
begin
  StatusBar1.Panels.Items[3].Text := ' Строк: ' + IntToStr(N0tepad.Lines.Count);
  StatusBar1.Panels.Items[5].Text :=
    ' Стр ' + IntToStr(N0tepad.CaretPos.Y + 1) + ', стлб ' +
    IntToStr(N0tepad.CaretPos.X + 1);
  StatusBar1.Panels.Items[3].Width :=
    Trunc(StatusBar1.Canvas.TextWidth(' Строк: ' +
    IntToStr(N0tepad.Lines.Count)) * 1.5);
  StatusBar1.Panels.Items[5].Width :=
    Trunc(StatusBar1.Canvas.TextWidth(' Стр ' + IntToStr(N0tepad.CaretPos.Y + 1) +
    ', стлб ' + IntToStr(N0tepad.CaretPos.X + 1)) * 1.5);
  StatusBar1.Panels.Items[4].Width :=
    Form1.Width - StatusBar1.Panels.Items[0].Width - StatusBar1.Panels.Items[1].Width -
    StatusBar1.Panels.Items[2].Width - StatusBar1.Panels.Items[3].Width -
    StatusBar1.Panels.Items[5].Width;
end;

procedure TForm1.FormWindowStateChange(Sender: TObject);
begin
  StatusBar1.Panels.Items[3].Text := ' Строк: ' + IntToStr(N0tepad.Lines.Count);
  StatusBar1.Panels.Items[5].Text :=
    ' Стр ' + IntToStr(N0tepad.CaretPos.Y + 1) + ', стлб ' +
    IntToStr(N0tepad.CaretPos.X + 1);
  StatusBar1.Panels.Items[3].Width :=
    Trunc(StatusBar1.Canvas.TextWidth(' Строк: ' +
    IntToStr(N0tepad.Lines.Count)) * 1.5);
  StatusBar1.Panels.Items[5].Width :=
    Trunc(StatusBar1.Canvas.TextWidth(' Стр ' + IntToStr(N0tepad.CaretPos.Y + 1) +
    ', стлб ' + IntToStr(N0tepad.CaretPos.X + 1)) * 1.5);
  StatusBar1.Panels.Items[4].Width :=
    Form1.Width - StatusBar1.Panels.Items[0].Width - StatusBar1.Panels.Items[1].Width -
    StatusBar1.Panels.Items[2].Width - StatusBar1.Panels.Items[3].Width -
    StatusBar1.Panels.Items[5].Width;
end;

procedure TForm1.HelpAboutClick(Sender: TObject);
begin
  QR.Visible := True;
end;

procedure TForm1.EditTimeDateClick(Sender: TObject);
var
  pt : TPoint;
  x :  TPoint;
begin
  x.x := 20;
  pt.x := N0tepad.CaretPos.X + x.x;
  pt.y := N0tepad.CaretPos.Y;
  N0tepad.Text := N0tepad.Text + (TimeToStr(now)) + ' ' + (DateToStr(now));
  //s := pt;
  //N0tepad.Text := pt;
  N0tepad.CaretPos := pt;
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin

end;

procedure TForm1.FileSaveClick(Sender: TObject);
begin
  if FileName <> '' then
  begin
    N0tepad.Lines.SaveToFile(Utf8ToSys(FilePath));
    N0tepad.Modified := False;
    saved := True;
    Form1.Caption := SaveFile.FileName + ' - Блокнот';
  end
  else
    FileSaveAsClick(Sender);
end;

function TForm1.ReadFontFromRegistry(FontA: TFont; SubKey: string): boolean;
var
  R :  TRegistry;
  FontStyleInt : byte;
  FS : TFontStyles;
begin
  R := TRegistry.Create;
  try
    Result := R.OpenKey(SubKey, False);
    if not Result then
      exit;
    FontA.Name := R.ReadString('Font Name');
    FontA.Color := R.ReadInteger('Color');
    FontA.Charset := R.ReadInteger('CharSet');
    FontA.Size := R.ReadInteger('Size');
    FontStyleInt := R.ReadInteger('Style');
    Move(FontStyleInt, FS, 1);
    FontA.Style := FS;
  finally
    R.Free;
  end;
end;

procedure TForm1.FindFind(Sender: TObject);
var
  Found, StartPos : integer;
  ToFind, Where :   string;
begin
  ToFind := Find.FindText;
  Where := N0tepad.Text;
  if not (frMatchCase in Find.Options) then
  begin
    ToFind := AnsiUpperCase(ToFind);
    Where := AnsiUpperCase(Where);
  end;
  if N0tepad.SelStart <> -1 then
  begin
    StartPos := N0tepad.SelStart;
    StartPos := StartPos + N0tepad.SelLength;
  end;
  Found := UTF8Pos(ToFind, Where, StartPos + 1);

  if Found <> 0 then
  begin
    N0tepad.HideSelection := False;
    N0tepad.SelStart := Found - 1;
    N0tepad.SelLength := UTF8Length(Find.FindText);
  end
  else
    MessageDlg('Блокнот', 'Не удается найти "' +
      Find.FindText + '"', mtCustom, [mbOK], 0);
end;

procedure TForm1.FormActivate(Sender: TObject);
begin

end;

procedure TForm1.FormatAllCenterClick(Sender: TObject);
begin
  FormatAllCenter.Checked := not FormatAllCenter.Checked;
  if FormatAllCenter.Checked then begin
    N0tepad.Alignment:=taCenter;
    FormatAllLeft.Checked := False;
    FormatAllRight.Checked := False;
    N0tepad.ScrollBars := ssVertical
end;
end;

procedure TForm1.FormatAllLeftClick(Sender: TObject);
begin
  FormatAllLeft.Checked := not FormatAllLeft.Checked;
  if FormatAllLeft.Checked then begin
    N0tepad.Alignment:=taLeftJustify;
    FormatAllCenter.Checked := False;
    FormatAllRight.Checked := False;
  end;
end;

procedure TForm1.FormatAllRightClick(Sender: TObject);
begin
  FormatAllRight.Checked := not FormatAllRight.Checked;
  if FormatAllRight.Checked then begin
    N0tepad.Alignment:=taRightJustify;
    FormatAllCenter.Checked := False;
    FormatAllLeft.Checked := False;
    N0tepad.ScrollBars := ssVertical
  end;
end;

procedure TForm1.FormatFontClick(Sender: TObject);
begin
  if Font1.Execute then
    N0tepad.Font := Font1.Font;
end;

procedure TForm1.FormatWordWrapClick(Sender: TObject);
begin
  FormatWordWrap.Checked := not FormatWordWrap.Checked;
  N0tepad.WordWrap := FormatWordWrap.Checked;
  if N0tepad.WordWrap then
    N0tepad.ScrollBars := ssVertical
  else
    N0tepad.ScrollBars := ssBoth;
end;

procedure TForm1.FormChangeBounds(Sender: TObject);
begin

end;

procedure TForm1.FormClose(Sender: TObject);
begin
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if N0tepad.Modified then
    modcheck := False
  else
    modcheck := True;
  ;
  if N0tepad.Modified then
  begin
    case MessageDlg('Сохранение файла',
        'Вы хотите сохранить изменения в файле "' +
        FilePath + '"?', mtCustom, [mbYes, mbNo, mbCancel], 0) of
      mrYes : FileSaveClick(Sender);
      mrNo : begin CanClose := True; exit end;
      mrCancel : CanClose := False;
    end;
  end;
  if saved or cancel or modcheck then
  SaveFontToRegistry(N0tepad.Font, 'Delphi Kingdom\Fonts')
  else CanClose := False;
end;

procedure TForm1.EditDeleteClick(Sender: TObject);
begin
  N0tepad.ClearSelection;
end;

procedure TForm1.EditFindBingClick(Sender: TObject);
var
s, tex : string;
p1, p2: int64;
i : int64;
begin


end;

procedure TForm1.EditFindClick(Sender: TObject);
begin
  Find.Execute;
end;

procedure TForm1.EditMenuClick(Sender: TObject);
begin
  with N0tepad do
  begin
    if SelLength >= 1 then
    begin
      EditCopy.Enabled := True;
      EditCut.Enabled := True;
      EditDelete.Enabled := True;
    end
    else
    begin
      EditCopy.Enabled := False;
      EditCut.Enabled := False;
      EditDelete.Enabled := False;
    end;
  end;
  if Clipboard.HasFormat(CF_TEXT) then
    EditPaste.Enabled := True
  else
    EditPaste.Enabled := False;
  if N0tepad.Modified then
    EditCancel.Enabled := True
  else
    EditCancel.Enabled := False;
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
var opened : boolean;
begin
  if N0tepad.Modified then
    modcheck := False
  else
    modcheck := True;
  ;
  opened := false;
  if N0tepad.Modified then
  begin
    case MessageDlg('Сохранение файла',
        'Вы хотите сохранить изменения в файле "' +
        FilePath + '"?', mtCustom, [mbYes, mbNo, mbCancel], 0) of
      mrYes : FileSaveClick(Sender);
      mrNo : cancel := True;
      mrCancel : exit;
    end;
  end;
  if saved or cancel or modcheck then
  begin
    OpenFile.FileName := '';
    OpenFile.Title := 'Открытие';
    if OpenFile.Execute then
    begin
      if N0tepad.Text <> '' then
        N0tepad.Clear;
      N0tepad.Lines.LoadFromFile(Utf8ToSys(OpenFile.FileName));
      FilePath := OpenFile.FileName;
      SaveFile.FileName := ExtractFileName(OpenFile.FileName);
      opened := true
    end;
    if opened then
    N0tepad.Modified := False;
    FileName := StringReplace(ExtractFileName(OpenFile.FileName),ExtractFileExt(OpenFile.FileName), '', []);
    if N0tepad.Modified then
    Form1.Caption := '*' + SaveFile.FileName + ' - Блокнот'
    else
      Form1.Caption := SaveFile.FileName + ' - Блокнот';
  end;
end;

procedure TForm1.FilePrintClick(Sender: TObject);
var
  printerDialog : TPrintDialog;
  myPrinter :     TPrinter;
begin
  printerDialog := TPrintDialog.Create(Form1);
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
   Form1.Caption := '*' + ExtractFileName(SaveFile.FileName)  + ' - Блокнот';
  StatusBar1.Panels.Items[1].Text :=
    ' Символов: ' + IntToStr(UTF8Length(N0tepad.Text));
  StatusBar1.Panels.Items[2].Text :=
    ' Слов: ' + IntToStr(WordCount(N0tepad.Text, StdWordDelims));
  StatusBar1.Panels.Items[3].Text := ' Строк: ' + IntToStr(N0tepad.Lines.Count);
  StatusBar1.Panels.Items[5].Text :=
    ' Стр ' + IntToStr(N0tepad.CaretPos.Y + 1) + ',стлб ' +
    IntToStr(N0tepad.CaretPos.X + 1);

  StatusBar1.Panels.Items[1].Width :=
    Trunc(StatusBar1.Canvas.TextWidth(' Символов: ' +
    IntToStr(UTF8Length(N0tepad.Text))) * 1.5);
  StatusBar1.Panels.Items[2].Width :=
    Trunc(StatusBar1.Canvas.TextWidth(' Слов: ' +
    IntToStr(WordCount(N0tepad.Text, StdWordDelims))) * 1.5);
  StatusBar1.Panels.Items[3].Width :=
    Trunc(StatusBar1.Canvas.TextWidth(' Строк: ' +
    IntToStr(N0tepad.Lines.Count)) * 1.5);
  StatusBar1.Panels.Items[5].Width :=
    Trunc(StatusBar1.Canvas.TextWidth(' Стр ' + IntToStr(N0tepad.CaretPos.Y + 1) +
    ', стлб ' + IntToStr(N0tepad.CaretPos.X + 1)) * 1.5);
  StatusBar1.Panels.Items[4].Width :=
    Form1.Width - StatusBar1.Panels.Items[0].Width - StatusBar1.Panels.Items[1].Width -
    StatusBar1.Panels.Items[2].Width - StatusBar1.Panels.Items[3].Width -
    StatusBar1.Panels.Items[5].Width;
end;

procedure TForm1.FileCreateClick(Sender: TObject);
begin
  if N0tepad.Modified then
    modcheck := False
  else
    modcheck := True;
  if N0tepad.Modified then
  begin
    case MessageDlg('Сохранение файла',
        'Вы хотите сохранить изменения в файле "' +
        FilePath + '"?', mtCustom, [mbYes, mbNo, mbCancel], 0) of
      mrYes : FileSaveClick(Sender);
      mrNo : cancel := True;
      mrCancel : exit;
    end;
  end;
  if saved or cancel or modcheck then
  begin
    if N0tepad.Text <> '' then
      N0tepad.Clear;
    SaveFile.FileName := 'Безымянный';
    ext := '';
    Form1.Caption := SaveFile.FileName + ' - Блокнот';
    FileName := '';
    FilePath := SaveFile.FileName;
    N0tepad.Modified := False;
  end;
end;

procedure TForm1.EditSelectAllClick(Sender: TObject);
begin
  N0tepad.SelectAll;
end;

procedure TForm1.FileSaveAsClick(Sender: TObject);
begin
  if N0tepad.Modified then
    modcheck := False
  else
    modcheck := True;
  ;
  ext := ExtractFileExt(SaveFile.FileName);
  case ext of
    '.txt' : SaveFile.FilterIndex:=1;
    '.pas' : SaveFile.FilterIndex:=2;
    '.cs' : SaveFile.FilterIndex:=3;
    end;
  saved := False;
  SaveFile.Title := 'Сохранить как...';
  if SaveFile.Execute then
  begin
    N0tepad.Lines.SaveToFile(Utf8ToSys(FilePath));
    N0tepad.Modified := False;
    saved := True;
  end;
  if saved or cancel or modcheck then
  begin
  FilePath := SaveFile.FileName;
  FileName := StringReplace(ExtractFileName(SaveFile.FileName),ExtractFileExt(SaveFile.FileName), '', []);
  SaveFile.FileName := ExtractFileName(SaveFile.FileName);
  if not  N0tepad.Modified then
  Form1.Caption := SaveFile.FileName + ' - Блокнот'
  else
  Form1.Caption := '*' + SaveFile.FileName + ' - Блокнот';
  ext := ''
  end
  else
  SaveFile.FileName := ExtractFileName(FilePath);
end;

procedure TForm1.N0tepadClick(Sender: TObject);
begin
  StatusBar1.Panels.Items[5].Text :=
    ' Стр ' + IntToStr(N0tepad.CaretPos.Y + 1) + ',стлб ' +
    IntToStr(N0tepad.CaretPos.X + 1);
end;


procedure TForm1.N0tepadKeyPress(Sender: TObject);
begin
  saved := False;
  cancel := False;
end;

procedure TForm1.N0tepadKeyUp(Sender: TObject);
begin

end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin

end;

end.
