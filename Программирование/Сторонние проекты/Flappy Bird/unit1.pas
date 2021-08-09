unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Objects, Graphics, Dialogs, ExtCtrls, StdCtrls, MMSystem, Math, BGRAGraphicControl, BGRABitmap, BGRABitmapTypes, Unit2;

type

  { TGeneralForm }

  TGeneralForm = class(TForm)
    Image1: TImage;
    BackGround: TImage;
    ScoreLabel: TLabel;
    player: TBGRAGraphicControl;
    FPSTimer: TTimer;
    Timer1: TTimer;
    procedure createform;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FPSTimerTimer(Sender: TObject);
    procedure playerRedraw(Sender: TObject; Bitmap: TBGRABitmap);
    procedure Timer1Timer(Sender: TObject);
  private

  public
  image: TBGRABitmap;
  angle : integer;
  score1 : integer;
  first_start : boolean;
  end;

  const

    playerMaxVelY = 10;
    playerMinVelY = -8;
    playerAccY = 1;
    playerVelRot = 3;
    playerRotThr = 20;
    playerFlapAcc = -9;
    BASEY = 800;

var
  pipeVelX : integer = -4;
  newPipe1 : array[1..7] of TImage;
  newPipe2 : array[1..7] of TImage;
  pipesCount : integer = 1;

  PIPE_UP : string = 'data\pictures\pipe-green_up.png';
  PIPE_DOWN : string = 'data\pictures\pipe-green_down.png';
  visibleRot : integer = 0;
  playerRot : integer = -45;
  playerx : integer = 120;
  playery : integer = 415;
  playerVelY : integer = -9;
  GeneralForm: TGeneralForm;
  playerFlapped : boolean = false;

  playerMidPos : integer = 120;

  pipe_y : array[1..12] of integer = (15, -15, 90, -90, 120, -120, 150, -150, 60, -60, 30, -30); //15, 120, - 120, 60, -60, 90, -90, 50, -50, -15, 70, -70, 80, -80

  pipe_was : integer;

  ground : array[1..2] of TImage;

  score : integer;

  crash : boolean = false;

implementation

procedure TGeneralForm.createform;
procedure showWelcomeAnimation;
begin

  WelcomeForm := TWelcomeForm.Create(self);
  WelcomeForm.Top := GeneralForm.Top;
  WelcomeForm.Left := GeneralForm.Left;
  FPSTimer.Enabled := false;
  WelcomeForm.ShowModal;
  WelcomeForm.Close;

end;


var
  i : integer;
begin

  showWelcomeAnimation;

  FPSTimer.Interval := 15;
  score := 0;


  randomize;

  DoubleBuffered := True;
  image := TBGRABitmap.Create('data\pictures\bird.png');


  ground[1] := TImage.create(self);
  ground[1].Left := 0;
  ground[1].Top := 800;
  ground[1].Picture.LoadFromFile('data\pictures\base.png');
  ground[1].Width := 600;
  ground[1].Height := 110;
  ground[1].Parent := self;
  ground[2] := TImage.create(self);
  ground[2].Left := 600;
  ground[2].Top := 800;
  ground[2].Picture.LoadFromFile('data\pictures\base.png');
  ground[2].Width := 600;
  ground[2].Height := 110;
  ground[2].Parent := self;


  for i := 1 to 3 do begin
  newPipe1[i] := TImage.Create(self);
  newPipe1[i].Left := i*300 + 300;
  newPipe1[i].Top := pipe_y[random(12)+1] + 450;
  newPipe1[i].Picture.LoadFromFile(PIPE_UP);
  newPipe1[i].Width := 110;
  newPipe1[i].Height := 800 - newPipe1[i].Top;
  newPipe1[i].Parent := self;

  newPipe2[i] := TImage.Create(self);
  newPipe2[i].Left := newPipe1[i].Left;
  newPipe2[i].Top := newPipe1[i].Top - 165 - 640;
  newPipe2[i].Picture.LoadFromFile(PIPE_DOWN);
  newPipe2[i].Width := 110;
  newPipe2[i].Height := 640;
  newPipe2[i].Parent := self;
  inc(pipesCount);
  end;
  refresh;



  FPSTimer.Enabled := true;

end;

{$R *.lfm}

{ TGeneralForm }

procedure TGeneralForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if not crash then
  if key = 32 then begin
  if playery > -2 * 70 then begin
  playerVelY := playerFlapAcc;
  playerFlapped := true;

  if visibleRot > -25 then visibleRot := playerRot;

  if pipesCount >= 1 then


  SNDPlaySound('data\sounds\wing.wav',SND_ASYNC);
  //FPSTimer.Enabled := true;
  end;
  end;
end;

procedure TGeneralForm.FormCreate(Sender: TObject);
begin
  first_start := true;
  createform;
end;


procedure TGeneralForm.FPSTimerTimer(Sender: TObject);

procedure GetRandomPipe(pipe_was : integer);
begin

  newPipe1[pipe_was] := TImage.Create(nil);
  newPipe1[pipe_was].Left := 800;
  newPipe1[pipe_was].Top := pipe_y[random(12)+1] + 450;
  newPipe1[pipe_was].Picture.LoadFromFile(PIPE_UP);
  newPipe1[pipe_was].Width := 110;
  newPipe1[pipe_was].Height := 800 - newPipe1[pipe_was].Top;
  newPipe1[pipe_was].Parent := self;

  newPipe2[pipe_was] := TImage.Create(nil);
  newPipe2[pipe_was].Left := newPipe1[pipe_was].Left;
  newPipe2[pipe_was].Top := newPipe1[pipe_was].Top  - 165 - 640;
  newPipe2[pipe_was].Picture.LoadFromFile(PIPE_DOWN);
  newPipe2[pipe_was].Width := 110;
  newPipe2[pipe_was].Height := 640;
  newPipe2[pipe_was].Parent := self;
  inc(pipesCount);
  if pipesCount > 4 then pipesCount := 4;

end;


function checkCrash : boolean;

var

  i : integer;

begin



 for i := 1 to 3 do
 if  (((playery + 120 >= newPipe1[i].Top) or (playery + 75 <= newPipe2[i].top + newPipe2[i].height))    and   ((playerx + 32>= newPipe2[i].Left) and (playerx - 32 <=  newPipe2[i].left + newPipe2[i].Width)) ) or  ((playerx = newPipe2[i].Left) and (playery + 50 < newPipe2[i].top + 640)) or ((playerx = newPipe1[i].Left) and (playery + 100 > newPipe1[i].top)) then
 begin

 crash := true;
 pipeVelX := 0;

 FPSTimer.Enabled := false;
 Timer1.Interval := FPSTimer.Interval;
 Timer1.Enabled := true;
 sndplaysound('data\sounds\hit.wav',SND_ASYNC);
 end;

 if playery + 120 >= BASEY - 1 then
  begin
  crash := true;
  pipeVelX := 0;
  sndplaysound('data\sounds\hit.wav',SND_ASYNC);
  FPSTimer.Enabled := false;
  Timer1.Interval := FPSTimer.Interval;
  Timer1.Enabled := true;
  end;

end;



var i : integer;
  pipeMidPos : integer;
begin



  checkCrash;

  if pipe_was <> 0 then
  if pipesCount < 4 then
  GetRandomPipe(pipe_was);

  if ground[1].Left + ground[1].Width < 0 then ground[1].Left := 596;
  if ground[2].Left + ground[2].Width < 0 then ground[2].Left := 596;

  ground[1].Left := ground[1].Left + pipeVelX;
  ground[2].Left := ground[2].Left + pipeVelX;



  for i := 1 to 3 do begin
  newPipe1[i].Left := newPipe1[i].Left + pipeVelX;
  newPipe2[i].Left := newPipe2[i].Left + pipeVelX;
  if newPipe1[i].Left + newPipe1[i].Width < 0 then begin newPipe1[i].Free; newPipe2[i].Free; pipe_was := i ; dec(pipesCount); end;

  pipeMidPos := (newPipe1[i].Left + newPipe1[i].Width) div 2;
  if (pipeMidPos <= playerMidPos) and (playerMidPos < pipeMidPos+2) then begin inc(score); end;//sndplaysound('data\sounds\point.wav',SND_ASYNC); end;

  end;


  if (visibleRot < 84) and (not playerFlapped) then
  visibleRot := visibleRot + 4;

  if (playerVelY < playerMaxVelY) and (not playerFlapped) then
  playerVelY += playerAccY;
  if playerFlapped then playerFlapped := false;

  if FPSTimer.Interval >= 8 then
  FPSTimer.Interval := 15 - score div 10;

  playery := playery + min(playerVelY, BASEY + 80 - playery - player.height);

  ScoreLabel.Caption := 'Score: ' + IntToStr(score);

  ScoreLabel.Left := 510 - ScoreLabel.Width div 2;

  player.top := playery;

  player.BringToFront;

  ScoreLabel.BringToFront;

end;


procedure TGeneralForm.playerRedraw(Sender: TObject; Bitmap: TBGRABitmap);
begin
  bitmap.FillTransparent;

  if first_start then
  bitmap.PutImageAngle(100, 100, image, 0, rfBestQuality, image.width div 2, image.height div 2)
  else
  bitmap.PutImageAngle(100, 100, image, visibleRot, rfBestQuality, image.width div 2, image.height div 2);
  first_start := false;
end;

procedure TGeneralForm.Timer1Timer(Sender: TObject);
var i : integer;
begin

    if (visibleRot < 86) then
    visibleRot := visibleRot + 4;

    if (playerVelY < playerMaxVelY+5) then
    playerVelY += playerAccY*2;
    playery := playery + min(playerVelY, BASEY + 80 - playery - player.height);
    player.top := playery;

    player.BringToFront;

   if playery + 120 >= BASEY - 1 then begin
   Timer1.Enabled := false;

   for i := 1 to 3 do begin
   try
   newPipe1[i].free;

   newPipe2[i].free;

   except
   end;
   end;
   ground[1].Picture := nil;
   ground[2].Picture := nil;
   ground[1].free;
   ground[2].free;
   pipesCount := 1;
   playerVelY := -9;
   VisibleRot := -45;
   player.Top := 515;
   playery := 515;
   crash := false;
   pipeVelX := -4;
   score1 := score;
   createform;

   end;
end;





end.

