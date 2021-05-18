unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes, MMSystem, SysUtils, FileUtil, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, LCLType, Menus, LResources, Registry, Math;



procedure GenMoves(Piece : string; Pos : integer);
procedure blpsemv(piecename : string; piecepos2 : integer);
procedure whpsemv(piecename : string; piecepos2 : integer);

type

  { TBox }

  TBox = class(TForm)
    BB: TImage;
    EndImg: TImage;
    StalePoint: TLabel;
    BlPa: TPanel;
    BKN: TImage;
    Slash2: TLabel;
    WhitePoint: TLabel;
    Slash1: TLabel;
    BlackPoint: TLabel;
    WQ: TImage;
    WKN: TImage;
    BQ: TImage;
    WR: TImage;
    WB: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;

    Memo1: TMemo;
    WhPa: TPanel;
    BR: TImage;

    procedure BBClick(Sender: TObject);
    procedure BKNClick(Sender: TObject);
    procedure BRClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure WBClick(Sender: TObject);
    procedure WKNClick(Sender: TObject);
    procedure WQClick(Sender: TObject);
    procedure BQClick(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure PiecesBoardClickEvent(Sender: TObject);
    procedure WRClick(Sender: TObject);
    procedure bot_move;


  private

  public

  end;


//procedure whitepseudomove(posit : integer);
//procedure blackpseudomove(posit : integer);


type
  TImgAndName = class(TImage)
  public
    FileName: string;
    Pos: integer;
    Col: string;
    Check: boolean;
    Stalemate : boolean;
    FirstMove : boolean;
    EnPassant : boolean;
  end;

var
  Box :      TBox;
  PiecesBoard : array [0..63] of TImgAndName;
  Board :    array [0..63] of TImgAndName;
  chosen :   string;
  whosmove : boolean = true;

  WhPi :     array[1..8] of string =
    ('WK.png', 'WKN.png', 'WBB.png' , 'WBW.png', 'WP.png', 'WR.png', 'WQ.png', '');
  BlPi :     array[1..8] of string =
    ('BK.png', 'BKN.png', 'BBB.png','BBW.png' , 'BP.png', 'BR.png', 'BQ.png', '');

  left, right : integer;
  lastcol : string;
  lastpiecepos : integer;

  possmoves : array[0..63] of integer;
  temp_pm : array[0..63] of integer;
  nottemp_pm : array[0..63] of integer;


  kn_mv : array[1..8] of integer = (-15,-6,10,17,15,6,-10,-17);
  king_mv : array[1..8] of integer = (-9,-8,-7,-1,1,9,8,7);
  CanMove : boolean;
  lastpassant : integer;
  whitekingposition : integer = -1;
  blackkingposition : integer = -1;
  wkcheck : boolean = false;
  bkcheck : boolean = false;
  castle : boolean = false;

   lastpicture : string;
      lastFirstMove : boolean;
      last2col : string;

  enpass : boolean = false;
  complete : boolean = false;
  newname : string;

  bot_black : boolean = false;

  currentpiecepos, last2piecepos : integer;

  DirectionOffset : array[1..8] of integer = (-8, 8, -1, 1, -9, 9, -7, 7);
  Label7: TLabel;

  firstenter : boolean = true;

  PawnEvalWhite : array[0..63] of single = (0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,
        5.0,  5.0,  5.0,  5.0,  5.0,  5.0,  5.0,  5.0,
        1.0,  1.0,  2.0,  3.0,  3.0,  2.0,  1.0,  1.0,
        0.5,  0.5,  1.0,  2.5,  2.5,  1.0,  0.5,  0.5,
        0.0,  0.0,  0.0,  2.0,  2.0,  0.0,  0.0,  0.0,
        0.5, -0.5, -1.0,  0.0,  0.0, -1.0, -0.5,  0.5,
        0.5,  1.0, 1.0,  -2.0, -2.0,  1.0,  1.0,  0.5,
        0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0);

  PawnEvalBlack : array[0..63] of single =
       (0, 0, 0, 0, 0, 0, 0, 0, -0.5, -1, -1, 2, 2, -1, -1, -0.5, -0.5, 0.5, 1, 0, 0, 1, 0.5, -0.5, 0, 0, 0, -2, -2, 0, 0, 0, -0.5, -0.5, -1, -2.5, -2.5, -1, -0.5, -0.5, -1, -1, -2, -3, -3, -2, -1, -1, -5, -5, -5, -5, -5, -5, -5, -5, 0, 0, 0, 0, 0, 0, 0, 0);

  knightEvalWhite : array[0..63] of single = (
        -5.0, -4.0, -3.0, -3.0, -3.0, -3.0, -4.0, -5.0,
        -4.0, -2.0,  0.0,  0.0,  0.0,  0.0, -2.0, -4.0,
        -3.0,  0.0,  1.0,  1.5,  1.5,  1.0,  0.0, -3.0,
        -3.0,  0.5,  1.5,  2.0,  2.0,  1.5,  0.5, -3.0,
        -3.0,  0.0,  1.5,  2.0,  2.0,  1.5,  0.0, -3.0,
        -3.0,  0.5,  1.0,  1.5,  1.5,  1.0,  0.5, -3.0,
        -4.0, -2.0,  0.0,  0.5,  0.5,  0.0, -2.0, -4.0,
        -5.0, -4.0, -3.0, -3.0, -3.0, -3.0, -4.0, -5.0
    );

  knightEvalBlack : array[0..63] of single = (5, 4, 3, 3, 3, 3, 4, 5, 4, 2, 0, -0.5, -0.5, 0, 2, 4, 3, -0.5, -1, -1.5, -1.5, -1, -0.5, 3, 3, 0, -1.5, -2, -2, -1.5, 0, 3, 3, -0.5, -1.5, -2, -2, -1.5, -0.5, 3, 3, 0, -1, -1.5, -1.5, -1, 0, 3, 4, 2, 0, 0, 0, 0, 2, 4, 5, 4, 3, 3, 3, 3, 4, 5);

  bishopEvalWhite : array[0..63] of single =  (
     -2.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -2.0,
     -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0,
     -1.0,  0.0,  0.5,  1.0,  1.0,  0.5,  0.0, -1.0,
     -1.0,  0.5,  0.5,  1.0,  1.0,  0.5,  0.5, -1.0,
     -1.0,  0.0,  1.0,  1.0,  1.0,  1.0,  0.0, -1.0,
     -1.0,  1.0,  1.0,  1.0,  1.0,  1.0,  1.0, -1.0,
     -1.0,  0.5,  0.0,  0.0,  0.0,  0.0,  0.5, -1.0,
     -2.0, -1.0, -1.0, -1.0, -1.0, -1.0, -1.0, -2.0 );
  bishopEvalBlack : array[0..63] of single = (2, 1, 1, 1, 1, 1, 1, 2, 1, -0.5, 0, 0, 0, 0, -0.5, 1, 1, -1, -1, -1, -1, -1, -1, 1, 1, 0, -1, -1, -1, -1, 0, 1, 1, -0.5, -0.5, -1, -1, -0.5, -0.5, 1, 1, 0, -0.5, -1, -1, -0.5, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 2, 1, 1, 1, 1, 1, 1, 2);

  rookEvalWhite : array[0..63] of single = (
      0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0,
      0.5,  1.0,  1.0,  1.0,  1.0,  1.0,  1.0,  0.5,
     -0.5,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -0.5,
     -0.5,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -0.5,
     -0.5,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -0.5,
     -0.5,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -0.5,
     -0.5,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -0.5,
      0.0,   0.0, 0.0,  0.5,  0.5,  0.0,  0.0,  0.0);

  rookEvalBlack : array[0..63] of single = (0, 0, 0, -0.5, -0.5, 0, 0, 0, 0.5, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0, 0, 0, 0, 0, 0, 0.5, -0.5, -1, -1, -1, -1, -1, -1, -0.5, 0, 0, 0, 0, 0, 0, 0, 0);

  queenEvalWhite : array[0..63] of single = (
    -2.0, -1.0, -1.0, -0.5, -0.5, -1.0, -1.0, -2.0,
    -1.0,  0.0,  0.0,  0.0,  0.0,  0.0,  0.0, -1.0,
    -1.0,  0.0,  0.5,  0.5,  0.5,  0.5,  0.0, -1.0,
    -0.5,  0.0,  0.5,  0.5,  0.5,  0.5,  0.0, -0.5,
     0.0,  0.0,  0.5,  0.5,  0.5,  0.5,  0.0, -0.5,
    -1.0,  0.5,  0.5,  0.5,  0.5,  0.5,  0.0, -1.0,
    -1.0,  0.0,  0.5,  0.0,  0.0,  0.0,  0.0, -1.0,
    -2.0, -1.0, -1.0, -0.5, -0.5, -1.0, -1.0, -2.0);

  queenEvalBlack : array[0..63] of single = (2, 1, 1, 0.5, 0.5, 1, 1, 2, 1, 0, 0, 0, 0, -0.5, 0, 1, 1, 0, -0.5, -0.5, -0.5, -0.5, -0.5, 1, 0.5, 0, -0.5, -0.5, -0.5, -0.5, 0, 0, 0.5, 0, -0.5, -0.5, -0.5, -0.5, 0, 0.5, 1, 0, -0.5, -0.5, -0.5, -0.5, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 2, 1, 1, 0.5, 0.5, 1, 1, 2);

  kingEvalWhite : array[0..63] of single = (
     -3.0, -4.0, -4.0, -5.0, -5.0, -4.0, -4.0, -3.0,
     -3.0, -4.0, -4.0, -5.0, -5.0, -4.0, -4.0, -3.0,
     -3.0, -4.0, -4.0, -5.0, -5.0, -4.0, -4.0, -3.0,
     -3.0, -4.0, -4.0, -5.0, -5.0, -4.0, -4.0, -3.0,
     -2.0, -3.0, -3.0, -4.0, -4.0, -3.0, -3.0, -2.0,
     -1.0, -2.0, -2.0, -2.0, -2.0, -2.0, -2.0, -1.0,
      2.0,  2.0,  0.0,  0.0,  0.0,  0.0,  2.0,  2.0,
      2.0,  3.0,  1.0,  0.0,  0.0,  1.0,  3.0,  2.0);


  kingEvalBlack : array[0..63] of single = (-2, -3, -1, 0, 0, -1, -3, -2, -2, -2, 0, 0, 0, 0, -2, -2, 1, 2, 2, 2, 2, 2, 2, 1, 2, 3, 3, 4, 4, 3, 3, 2, 3, 4, 4, 5, 5, 4, 4, 3, 3, 4, 4, 5, 5, 4, 4, 3, 3, 4, 4, 5, 5, 4, 4, 3, 3, 4, 4, 5, 5, 4, 4, 3);


    attackmoves : array[0..63] of integer;
    found : boolean;


   wfrwhere_col : array[1..10] of string;        //Цвет куда идём
   wfrwhere_name : array[1..10] of  string;       //Имя
   wfrwhere_firstmove : array[1..10] of  boolean; //Первый ли ход
   wwhere_col : array[1..10] of  string;        //Цвет куда идём
   wwhere_name : array[1..10] of  string;       //Имя
   wwhere_firstmove : array[1..10] of  boolean; //Первый ли ход

   frwhere_col : array[1..10] of  string;        //Цвет куда идём
   frwhere_name : array[1..10] of  string;       //Имя
   frwhere_firstmove : array[1..10] of  boolean; //Первый ли ход
   where_col : array[1..10] of  string;        //Цвет куда идём
   where_name : array[1..10] of  string;       //Имя
   where_firstmove : array[1..10] of  boolean; //Первый ли ход
   frwhere_bk : array[1..10] of  integer;      //Прошлая позиция короля
   frwhere_wk : array[1..10] of  integer;      //Прошлая позиция короля
   TotalEvaluation : extended;
   bestSecondMove : integer;



implementation

{$R *.lfm}

{ TBox }



procedure whpsemv(piecename : string; piecepos2 : integer);
   var

   npc, npfn : string;
   nfm: boolean;
   lwkp : integer;

   i,j,m : integer;

   begin
   m := 0;
   for i := 0 to 63 do begin
   temp_pm[i] := possmoves[i];
   nottemp_pm[i] := possmoves[i];
   possmoves[i] := 0;
   end;

   while true do begin

   for i := 0 to 63 do begin
   if temp_pm[i] <> 0 then begin
   temp_pm[i] := 0;

   if piecename = 'WK.png' then begin
   lwkp := whitekingposition;
   whitekingposition := i;
   end;

   npc := PiecesBoard[i].Col;
   npfn := PiecesBoard[i].FileName;
   nfm := PiecesBoard[i].FirstMove;

   PiecesBoard[i].Col := PiecesBoard[piecepos2].Col;
   PiecesBoard[i].FileName := piecename;
   PiecesBoard[i].FirstMove := PiecesBoard[piecepos2].FirstMove;
   PiecesBoard[piecepos2].Col := '';
   PiecesBoard[piecepos2].FirstMove := false;
   PiecesBoard[piecepos2].FileName := '';

   for j := 0 to 63 do begin
      case PiecesBoard[j].FileName of
      'BK.png', 'BKN.png', 'BBB.png','BBW.png' , 'BP.png', 'BR.png', 'BQ.png' : GenMoves(PiecesBoard[j].FileName, j);
      end;
    end;

    for j := 0 to 63 do begin
     if (possmoves[j] = 2) and (j = whitekingposition)
     then wkcheck := true;
     possmoves[j] := 0;
    end;

   if wkcheck then nottemp_pm[i] := 0;

   if piecename = 'WK.png' then
   whitekingposition := lwkp;

   PiecesBoard[piecepos2].Col := PiecesBoard[i].Col;
   PiecesBoard[piecepos2].FirstMove := PiecesBoard[i].FirstMove;
   PiecesBoard[piecepos2].FileName := PiecesBoard[i].FileName;

   PiecesBoard[i].Col := npc;
   PiecesBoard[i].FileName := npfn;
   PiecesBoard[i].FirstMove := nfm;
   end;
   wkcheck := false;
   end;

   for i := 0 to 63 do begin
   if temp_pm[i] <> 0 then m := 1;
   end;
   if m = 0 then break;



   end;

   for i := 0 to 63 do begin
   possmoves[i] := nottemp_pm[i];
   nottemp_pm[i] := 0;

   end;
   end;


   procedure TBox.bot_move;


   function GetPieceValue(j : integer) : Extended;
   begin
   case PiecesBoard[j].FileName of
   'WP.png' : begin GetPieceValue := 10 + pawnEvalWhite[j]; exit; end;
   'BP.png' : begin GetPieceValue := -10 + pawnEvalBlack[j]; exit; end;
   'WR.png' : begin GetPieceValue := 52.5 + rookEvalWhite[j]; exit; end;
   'BR.png' : begin GetPieceValue := -52.5 + rookEvalBlack[j]; exit; end;
   'WKN.png' : begin GetPieceValue := 35 + knightEvalWhite[j]; exit; end;
   'BKN.png' : begin GetPieceValue := -35 + knightEvalBlack[j]; exit; end;
   'WBB.png', 'WBW.png' : begin GetPieceValue := 35 + bishopEvalWhite[j]; exit; end;
   'BBB.png', 'BBW.png' : begin GetPieceValue := -35 + bishopEvalBlack[j]; exit; end;
   'WQ.png' : begin GetPieceValue := 100 + queenEvalWhite[j]; exit; end;
   'BQ.png' : begin GetPieceValue := -100 + queenEvalBlack[j]; exit; end;
   'WK.png' : begin GetPieceValue := 900 + kingEvalWhite[j]; exit; end;
   'BK.png' : begin GetPieceValue := -900 + kingEvalBlack[j]; exit; end;
   end;
   end;

   procedure game_ugly_move(pos_frwhere : integer; pos_where : integer; depth : integer);
   begin

   if PiecesBoard[pos_frwhere].FileName = 'BK.png' then begin
   frwhere_bk[depth] := blackkingposition;
   blackkingposition := pos_where;
   end;

   frwhere_col[depth] := PiecesBoard[pos_frwhere].Col;
   frwhere_name[depth] := PiecesBoard[pos_frwhere].FileName;
   frwhere_firstmove[depth] := PiecesBoard[pos_frwhere].FirstMove;

   where_col[depth] := PiecesBoard[pos_where].Col;
   where_name[depth] := PiecesBoard[pos_where].FileName;
   where_firstmove[depth] := PiecesBoard[pos_where].FirstMove;

   PiecesBoard[pos_where].Col := frwhere_col[depth];
   PiecesBoard[pos_where].FileName := frwhere_name[depth];
   PiecesBoard[pos_where].FirstMove := frwhere_firstmove[depth];
   PiecesBoard[pos_frwhere].Col := '';
   PiecesBoard[pos_frwhere].FirstMove := false;
   PiecesBoard[pos_frwhere].FileName := '';
   end;

   procedure game_undo_move(pos_frwhere : integer; pos_where : integer; depth : integer);
   begin

   if PiecesBoard[pos_where].FileName = 'BK.png' then
   blackkingposition := frwhere_bk[depth];

   PiecesBoard[pos_frwhere].Col := frwhere_col[depth];
   PiecesBoard[pos_frwhere].FirstMove :=  frwhere_firstmove[depth];
   PiecesBoard[pos_frwhere].FileName := frwhere_name[depth];

   PiecesBoard[pos_where].Col := where_col[depth];
   PiecesBoard[pos_where].FileName := where_name[depth];
   PiecesBoard[pos_where].FirstMove := where_firstmove[depth];

   end;


   procedure wgame_ugly_move(pos_frwhere : integer; pos_where : integer; depth : integer);
   begin

   if PiecesBoard[pos_frwhere].FileName = 'WK.png' then begin
   frwhere_wk[depth] := whitekingposition;
   whitekingposition := pos_where;
   end;

   wfrwhere_col[depth] := PiecesBoard[pos_frwhere].Col;
   wfrwhere_name[depth] := PiecesBoard[pos_frwhere].FileName;
   wfrwhere_firstmove[depth] := PiecesBoard[pos_frwhere].FirstMove;

   wwhere_col[depth] := PiecesBoard[pos_where].Col;
   wwhere_name[depth] := PiecesBoard[pos_where].FileName;
   wwhere_firstmove[depth] := PiecesBoard[pos_where].FirstMove;

   PiecesBoard[pos_where].Col := wfrwhere_col[depth];
   PiecesBoard[pos_where].FileName := wfrwhere_name[depth];
   PiecesBoard[pos_where].FirstMove := wfrwhere_firstmove[depth];
   PiecesBoard[pos_frwhere].Col := '';
   PiecesBoard[pos_frwhere].FirstMove := false;
   PiecesBoard[pos_frwhere].FileName := '';
   end;

   procedure wgame_undo_move(pos_frwhere : integer; pos_where : integer; depth : integer);
   begin

   if PiecesBoard[pos_where].FileName = 'WK.png' then
   whitekingposition := frwhere_wk[depth];

   PiecesBoard[pos_frwhere].Col := wfrwhere_col[depth];
   PiecesBoard[pos_frwhere].FirstMove :=  wfrwhere_firstmove[depth];
   PiecesBoard[pos_frwhere].FileName := wfrwhere_name[depth];

   PiecesBoard[pos_where].Col := wwhere_col[depth];
   PiecesBoard[pos_where].FileName := wwhere_name[depth];
   PiecesBoard[pos_where].FirstMove := wwhere_firstmove[depth];

   end;



   procedure evaluateBoard;
   var i : integer;
   begin
   TotalEvaluation := 0;
   for i := 0 to 63 do
   if PiecesBoard[i].FileName <> '' then TotalEvaluation += GetPieceValue(i);
   end;

   function minimax(depth : integer; alpha : single; beta : single; isMaximisingPlayer : boolean) : extended;
   var
   bestMove : single;



   i, j, k : integer;
   begin
   for i := 0 to 63 do possmoves[i] := 0;

   if depth = 0 then begin evaluateBoard; minimax := -TotalEvaluation; exit; end;

   if isMaximisingPlayer then begin
   bestMove := -9999;
   
     for i := 0 to 63 do begin
   if (PiecesBoard[i].Col = 'Black') then begin
   for j := 0 to 63 do begin
   GenMoves(PiecesBoard[i].FileName,i);
   blpsemv(PiecesBoard[i].FileName,i);
   if possmoves[j] <> 0 then begin
   game_ugly_move(i,j,depth);



   bestMove := Max(bestMove,minimax(depth-1, alpha, beta, not isMaximisingPlayer));



   game_undo_move(i,j,depth);

   alpha := max(alpha, bestMove);


   if beta <= alpha then begin
   minimax := bestMove;
   exit;
   end;

   end;
   end;
   for j := 0 to 63 do
   possmoves[j] := 0;
   end;
   end;

   minimax := bestMove;
   exit;
   end


   else begin
   bestMove := 9999;

     for i := 0 to 63 do begin
   if (PiecesBoard[i].Col = 'White') then begin
   for j := 0 to 63 do begin
   GenMoves(PiecesBoard[i].FileName,i);
   whpsemv(PiecesBoard[i].FileName,i);
   if possmoves[j] <> 0 then begin
   wgame_ugly_move(i,j, depth);



   bestMove := Min(bestMove,minimax(depth-1, alpha, beta, not isMaximisingPlayer));



   wgame_undo_move(i,j, depth);

   beta := min(beta, bestMove);


   if beta <= alpha then begin
   minimax := bestMove;
   exit;
   end;

   end;
   end;
   for j := 0 to 63 do
   possmoves[j] := 0;
   end;
   end;

   minimax := bestMove;
   exit;
   end;


   end;




   function minimaxRoot(depth : integer; isMaximisingPlayer : boolean) : integer;
   var
   i,j : integer;
   bestMove : single;
   bestMoveFound : integer;
   value : single;
   begin


   if isMaximisingPlayer = true then begin

   bestMove := -9999;

     for i := 0 to 63 do begin
   if (PiecesBoard[i].Col = 'Black') then begin
   for j := 0 to 63 do begin
   GenMoves(PiecesBoard[i].FileName,i);
   blpsemv(PiecesBoard[i].FileName,i);
   if possmoves[j] <> 0 then begin
   game_ugly_move(i,j, depth);



   value := minimax(depth-1, -10000, 10000, not isMaximisingPlayer);



   game_undo_move(i,j, depth);

   if value > bestMove then begin
   bestMove := value;
   bestMoveFound := i;
   bestSecondMove := j;
   end;

   end;
   end;
   for j := 0 to 63 do
   possmoves[j] := 0;
   end;
   end;

   minimaxRoot := bestMoveFound;

   end else begin

   bestMove := 9999;

     for i := 0 to 63 do begin
   if (PiecesBoard[i].Col = 'White') then begin
   for j := 0 to 63 do begin
   GenMoves(PiecesBoard[i].FileName,i);
   whpsemv(PiecesBoard[i].FileName,i);
   if possmoves[j] <> 0 then begin
   wgame_ugly_move(i,j, depth);



   value := minimax(depth-1, -10000, 10000, not isMaximisingPlayer);



   wgame_undo_move(i,j, depth);

   if value < bestMove then begin
   bestMove := value;
   bestMoveFound := i;
   bestSecondMove := j;
   end;

   end;
   end;
   for j := 0 to 63 do
   possmoves[j] := 0;
   end;
   end;

   minimaxRoot := bestMoveFound;

   end;



   end;








   var
     bestMove : integer;
     i, j : integer;
     num : integer; //Для хода бота
   begin

   found := false;

   if bot_black then begin

   //ПЕРВЫЙ ХОД ЧЁРНОГО БОТА
   if ((not whosmove) and (Label2.Caption = 'Второй ход')) then begin

   bestMove := minimaxRoot(3,true);
   PiecesBoard[bestMove].Click;                                                  //Берём фигуру
   end;


    for j := 1 to 3 do begin
    //ВТОРОЙ ХОД ЧЁРНОГО БОТА
    if ((not whosmove) and (Label2.Caption = 'Первый ход')) then begin
    PiecesBoard[bestSecondMove].Click
    end;
    end;

   end
   else begin
    //ПЕРВЫЙ ХОД БЕЛОГО БОТА
   if whosmove and (Label2.Caption = 'Второй ход') then begin

   bestMove := minimaxRoot(3,false);
   PiecesBoard[bestMove].Click;

   end;

    //ВТОРОЙ ХОД БЕЛОГО БОТА
    for j := 1 to 3 do begin
    if ((whosmove) and (Label2.Caption = 'Первый ход')) then begin
    PiecesBoard[bestSecondMove].Click
    end;
   end;

   end;

   end;

   procedure blpsemv(piecename : string; piecepos2 : integer);
   var

   npc, npfn : string;
   nfm: boolean;
   lbkp : integer;

   i,j,m : integer;

   begin
   m := 0;
   for i := 0 to 63 do begin
   temp_pm[i] := possmoves[i];
   nottemp_pm[i] := possmoves[i];
   possmoves[i] := 0;
   end;

   while true do begin

   for i := 0 to 63 do begin
   if temp_pm[i] <> 0 then begin
   temp_pm[i] := 0;

   if piecename = 'BK.png' then begin
   lbkp := blackkingposition;
   blackkingposition := i;
   end;

   npc := PiecesBoard[i].Col;
   npfn := PiecesBoard[i].FileName;
   nfm := PiecesBoard[i].FirstMove;

   PiecesBoard[i].Col := PiecesBoard[piecepos2].Col;
   PiecesBoard[i].FileName := piecename;
   PiecesBoard[i].FirstMove := PiecesBoard[piecepos2].FirstMove;
   PiecesBoard[piecepos2].Col := '';
   PiecesBoard[piecepos2].FirstMove := false;
   PiecesBoard[piecepos2].FileName := '';

   for j := 0 to 63 do begin
      case PiecesBoard[j].FileName of
      'WK.png', 'WKN.png', 'WBB.png','WBW.png' , 'WP.png', 'WR.png', 'WQ.png' : GenMoves(PiecesBoard[j].FileName, j);
      end;
    end;

    for j := 0 to 63 do begin
     if (possmoves[j] = 2) and (j = blackkingposition)
     then bkcheck := true;
     possmoves[j] := 0;
    end;

   if bkcheck then nottemp_pm[i] := 0;

   if piecename = 'BK.png' then
   blackkingposition := lbkp;

   PiecesBoard[piecepos2].Col := PiecesBoard[i].Col;
   PiecesBoard[piecepos2].FirstMove := PiecesBoard[i].FirstMove;
   PiecesBoard[piecepos2].FileName := PiecesBoard[i].FileName;

   PiecesBoard[i].Col := npc;
   PiecesBoard[i].FileName := npfn;
   PiecesBoard[i].FirstMove := nfm;
   end;
   bkcheck := false;
   end;

   for i := 0 to 63 do begin
   if temp_pm[i] <> 0 then m := 1;
   end;
   if m = 0 then break;



   end;

   for i := 0 to 63 do begin
   //if nottemp_pm[i] <> 0 then
   possmoves[i] := nottemp_pm[i];
   nottemp_pm[i] := 0;
   end;
   end;




procedure GenMoves(Piece : string; Pos : integer);

   procedure knightposmoves(knmv:integer);
   begin
   case PiecesBoard[Pos + knmv].Col of
     '' : possmoves[Pos + knmv] := 1;
     'Black' : possmoves[Pos + knmv] := 2;
     end;
   end;

   procedure blackknightposmoves(knmv:integer);
   begin
   case PiecesBoard[Pos + knmv].Col of
     '' : possmoves[Pos + knmv] := 1;
     'White' : possmoves[Pos + knmv] := 2;
     end;
   end;

   procedure whitekingmove(kingmv:integer);
   begin
   case PiecesBoard[Pos + kingmv].Col of
     '' : possmoves[Pos + kingmv] := 1;
     'Black' : possmoves[Pos + kingmv] := 2;
     end;
   end;

   procedure blackkingmove(kingmv:integer);
   begin
   case PiecesBoard[Pos + kingmv].Col of
     '' : possmoves[Pos + kingmv] := 1;
     'White' : possmoves[Pos + kingmv] := 2;
     end;
   end;





   var
     i : integer;
     r2 : integer;
   begin

     if Piece = 'WP.png' then begin
       case Pos of
       0,1,2,3,4,5,6,7 : exit;
       end;
       if PiecesBoard[Pos].FirstMove = true then begin
       if (PiecesBoard[Pos-8].FileName = '') and (PiecesBoard[Pos-16].FileName = '') then begin
       possmoves[Pos-8] := 1;
       possmoves[Pos-16] := 1;
       end;
       end
       else begin
       if PiecesBoard[Pos-8].FileName = '' then
       possmoves[Pos-8] := 1;
       end;
       if Pos mod 8 = 0 then begin
       if PiecesBoard[Pos-7].EnPassant = true then
       possmoves[Pos-7] := 2;
       if PiecesBoard[Pos-8].Col = '' then
       possmoves[Pos-8] := 1;
       if PiecesBoard[Pos-7].Col = 'Black'
       then possmoves[Pos-7] := 2;
       //if PiecesBoard[Pos-7].Col = 'White'
       //then possmoves[Pos-7] := 3;
       //if PiecesBoard[Pos-7].Col = ''
       //then possmoves[Pos-7] := 3;
       end
       else
       if (Pos mod 8 = 7) then begin
       if PiecesBoard[Pos-9].EnPassant = true then
       possmoves[Pos-9] := 2;
       if PiecesBoard[Pos-8].Col = '' then
       possmoves[Pos-8] := 1;
       if PiecesBoard[Pos-9].Col = 'Black'
       then possmoves[Pos-9] := 2;
       //if PiecesBoard[Pos-9].Col = 'White'
       //then possmoves[Pos-9] := 3;
       // if PiecesBoard[Pos-9].Col = ''
       //then possmoves[Pos-9] := 3;
       end
       else  begin
         if PiecesBoard[Pos-9].EnPassant = true then
       possmoves[Pos-9] := 2;
         if PiecesBoard[Pos-7].EnPassant = true then
       possmoves[Pos-7] := 2;
       if PiecesBoard[Pos-8].Col = '' then
       possmoves[Pos-8] := 1;
       if PiecesBoard[Pos-7].Col = 'Black' then
       possmoves[Pos-7] := 2;
       //if PiecesBoard[Pos-7].Col = 'White' then
       //possmoves[Pos-7] := 3;
       //if PiecesBoard[Pos-7].Col = '' then
       //possmoves[Pos-7] := 3;
       //if PiecesBoard[Pos-7].Col = 'White' then
       //possmoves[Pos-7] := 1;
       if PiecesBoard[Pos-9].Col = 'Black' then
       possmoves[Pos-9] := 2;
       //if PiecesBoard[Pos-9].Col = 'White' then
       //possmoves[Pos-9] := 3;
       //if PiecesBoard[Pos-9].Col = '' then
       //possmoves[Pos-9] := 3;
       end;
     end;

      if Piece = 'BP.png' then begin
       case Pos of
       56,57,58,59,60,61,62,63 : exit;
       end;
       if PiecesBoard[Pos].FirstMove = true then begin
       if (PiecesBoard[Pos+8].FileName = '') and (PiecesBoard[Pos+16].FileName = '') then begin
       possmoves[Pos+8] := 1;
       possmoves[Pos+16] := 1;
       end;
       end
       else begin
       if PiecesBoard[Pos+8].FileName = '' then
       possmoves[Pos+8] := 1;
       end;
       if Pos mod 8 = 0 then begin
        if PiecesBoard[Pos+9].EnPassant = true then
       possmoves[Pos+9] := 2;
        if PiecesBoard[Pos+8].Col = '' then
       possmoves[Pos+8] := 1;
       if PiecesBoard[Pos+9].Col = 'White'
       then possmoves[Pos+9] := 2;
       //if PiecesBoard[Pos+9].Col = 'Black'
       //then possmoves[Pos+9] := 3;
       //if PiecesBoard[Pos+9].Col = ''
       //then possmoves[Pos+9] := 3;
       end
       else
       if (Pos mod 8 = 7) then begin
       if PiecesBoard[Pos+7].EnPassant = true then
       possmoves[Pos+7] := 2;
       if PiecesBoard[Pos+8].Col = '' then
       possmoves[Pos+8] := 1;
       if PiecesBoard[Pos+7].Col = 'White'
       then possmoves[Pos+7] := 2;
       //if PiecesBoard[Pos+7].Col = 'Black'
       //then possmoves[Pos+7] := 3;
       //if PiecesBoard[Pos+7].Col = ''
       //then possmoves[Pos+7] := 3;
       end
       else  begin
        if PiecesBoard[Pos+9].EnPassant = true then
       possmoves[Pos+9] := 2;
         if PiecesBoard[Pos+7].EnPassant = true then
       possmoves[Pos+7] := 2;
       if PiecesBoard[Pos+8].Col = '' then
       possmoves[Pos+8] := 1;
       if PiecesBoard[Pos+7].Col = 'White' then
       possmoves[Pos+7] := 2;
       //if PiecesBoard[Pos+7].Col   = 'Black' then
       //possmoves[Pos+7] := 3;
       //if PiecesBoard[Pos+7].Col = '' then
       //possmoves[Pos+7] := 3;
       if PiecesBoard[Pos+9].Col = 'White' then
       possmoves[Pos+9] := 2;
       //if PiecesBoard[Pos+9].Col = 'Black' then
       //possmoves[Pos+9] := 3;
       //if PiecesBoard[Pos+9].Col = '' then
       //possmoves[Pos+9] := 3;
       end;

     end;


      if Piece = 'BR.png' then begin

      //Проверка на 1-ую горизонталь
      if (Pos <> 0) and (Pos <> 1) and (Pos <> 2) and (Pos <> 3) and (Pos <> 4) and (Pos <> 5) and (Pos <> 6) and (Pos <> 7) then begin

      for i := Pos div 8 - 1 downto 0 do begin
       case PiecesBoard[i*8 + Pos mod 8].Col of
       '' : possmoves[i*8 + Pos mod 8] := 1;                                //Вверх
       'White' : begin possmoves[i*8 + Pos mod 8] := 2; break; end;
       'Black' : break;//begin possmoves[i*8 + Pos mod 8] := 3; break; end;
       end; end;

       end;   //Проверка на 1-ую горизонталь

       if Pos mod 8 <> 0 then begin

       for i := Pos - 1 downto Pos - (Pos mod 8) do begin
        case PiecesBoard[i].Col of
        '' : possmoves[i] := 1;                                      //Влево
        'White' : begin possmoves[i] := 2; break; end;
        'Black' : break; //egin possmoves[i] := 3; break; end;
        end; end;
       end; //if Pos mod 8 <> 0 //Проверка на А вертикаль

       if Pos mod 8 <> 7 then begin

       for i := Pos + 1 to Pos + (7 - Pos mod 8) do begin
         case PiecesBoard[i].Col of
        '' : possmoves[i] := 1;                                    //Вправо
        'White' : begin possmoves[i] := 2; break; end;
        'Black' : break; //begin possmoves[i] := 3; break; end;
        end; end;
       end; //if Pos mod 8 <> 7 //Проверка на А вертикаль

       //Проверка на 8-ую горизонталь
       if (Pos <> 56) and (Pos <> 57) and (Pos <> 58) and (Pos <> 59) and (Pos <> 60) and (Pos <> 61) and (Pos <> 62) and (Pos <> 63) then begin

       for i := Pos div 8 + 1 to 7 do begin
        case PiecesBoard[i*8 + Pos mod 8].Col of
        '' : possmoves[i*8 + Pos mod 8] := 1;                                       //Вниз
        'White' : begin possmoves[i*8 + Pos mod 8] := 2; break; end;
        'Black' : begin possmoves[i*8 + Pos mod 8] := 3; break; end;
        end; end;
       end;    //Проверка на 8-ую горизонталь
      end;



      if Piece = 'WR.png' then begin

      //Проверка на 1-ую горизонталь
      if (Pos <> 0) and (Pos <> 1) and (Pos <> 2) and (Pos <> 3) and (Pos <> 4) and (Pos <> 5) and (Pos <> 6) and (Pos <> 7) then begin

      for i := Pos div 8 - 1 downto 0 do begin
       case PiecesBoard[i*8 + Pos mod 8].Col of
       '' : possmoves[i*8 + Pos mod 8] := 1;                                //Вверх
       'Black' : begin possmoves[i*8 + Pos mod 8] := 2; break; end;
       'White' : break;
       end; end;

       end;   //Проверка на 1-ую горизонталь

       if Pos mod 8 <> 0 then begin

       for i := Pos - 1 downto Pos - (Pos mod 8) do begin
        case PiecesBoard[i].Col of
        '' : possmoves[i] := 1;                                      //Влево
        'Black' : begin possmoves[i] := 2; break; end;
        'White' : break; //begin possmoves[i] := 3; break; end;
        end; end;
       end; //if Pos mod 8 <> 0 //Проверка на А вертикаль

       if Pos mod 8 <> 7 then begin

       for i := Pos + 1 to Pos + (7 - Pos mod 8) do begin
         case PiecesBoard[i].Col of
        '' : possmoves[i] := 1;                                    //Вправо
        'Black' : begin possmoves[i] := 2; break; end;
        'White' : break; //begin possmoves[i] := 3; break; end;
        end; end;
       end; //if Pos mod 8 <> 7 //Проверка на А вертикаль

       //Проверка на 8-ую горизонталь
       if (Pos <> 56) and (Pos <> 57) and (Pos <> 58) and (Pos <> 59) and (Pos <> 60) and (Pos <> 61) and (Pos <> 62) and (Pos <> 63) then begin

       for i := Pos div 8 + 1 to 7 do begin
        case PiecesBoard[i*8 + Pos mod 8].Col of
        '' : possmoves[i*8 + Pos mod 8] := 1;                                       //Вниз
        'Black' : begin possmoves[i*8 + Pos mod 8] := 2; break; end;
        'White' : break; //begin possmoves[i*8 + Pos mod 8] := 3; break; end;
        end; end;
       end;    //Проверка на 8-ую горизонталь


      end;

      //Белопольный белый слон

      if Piece = 'WBW.png' then begin

      if (Pos <> 0) and (Pos mod 8 <> 7) and (Pos <> 2) and (Pos <> 4) and (Pos <> 6) then begin    //Проверка на углы

      r2 := 0;
      case Pos of
      9,11,13,15,22,38,54 : r2 := 1;
      16, 18, 20, 29, 45, 61 : r2 := 2;
      25, 27, 36, 52 : r2 := 3;
      32, 34, 43, 59 : r2 := 4;
      50,41 : r2 := 5;
      48,57 : r2 := 6;
      end;

                                                        //Вправо вверх

      for i := 1 to r2 do begin
       case PiecesBoard[Pos - 7*i].Col of
       '' : possmoves[Pos - 7*i] := 1;
       'Black' : begin possmoves[Pos - 7*i] := 2; break; end;
       'White' : break; //begin possmoves[Pos - 7*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы


      if (Pos mod 8 <> 0) and (Pos <> 63) and (Pos <> 57) and (Pos <> 59) and (Pos <> 61) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      9, 25 ,41 ,50 ,52 ,54 : r2 := 1;
      2, 18, 34, 43, 45, 47 : r2 := 2;
      11, 27, 36, 38 : r2 := 3;
      4, 20, 29, 31 : r2 := 4;
      13, 22 : r2 := 5;
      6, 15 : r2 := 6;
      end;

                                                        //Влево вниз

      for i := 1 to r2 do begin
       case PiecesBoard[Pos + 7*i].Col of
       '' : possmoves[Pos + 7*i] := 1;
       'Black' : begin possmoves[Pos + 7*i] := 2; break; end;
       'White' : break; //begin possmoves[Pos + 7*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы


       if (Pos mod 8 <> 0) and (Pos <> 2) and (Pos <> 4) and (Pos <> 6) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      9, 11, 13, 15, 25, 41, 57 : r2 := 1;
      18, 20, 22, 34, 50 : r2 := 2;
      27, 29, 31, 43, 59 : r2 := 3;
      36, 38, 52 : r2 := 4;
      45, 47, 61 : r2 := 5;
      54 : r2 := 6;
      63 : r2 := 7;
      end;

                                                        //Влево вверх

      for i := 1 to r2 do begin
       case PiecesBoard[Pos - 9*i].Col of
       '' : possmoves[Pos - 9*i] := 1;
       'Black' : begin possmoves[Pos - 9*i] := 2; break; end;
       'White' : break; //begin possmoves[Pos - 9*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы

       if (Pos mod 8 <> 7) and (Pos <> 57) and (Pos <> 59) and (Pos <> 61) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      6, 22, 38, 54, 52, 50, 48 : r2 := 1;
      13, 29, 45, 43, 41 : r2 := 2;
      4, 20, 36, 34, 32 : r2 := 3;
      11, 27, 25: r2 := 4;
      2, 18, 16 : r2 := 5;
      9 : r2 := 6;
      0 : r2 := 7;
      end;

                                                        //Вправо вниз

      for i := 1 to r2 do begin
       case PiecesBoard[Pos + 9*i].Col of
       '' : possmoves[Pos + 9*i] := 1;
       'Black' : begin possmoves[Pos + 9*i] := 2; break; end;
       'White' : break; //begin possmoves[Pos + 9*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы

   end;

      //Чернопольный белый слон

       if Piece = 'WBB.png' then begin

      if (Pos mod 8 <> 7) and (Pos <> 1) and (Pos <> 3) and (Pos <> 5)  then begin    //Проверка на углы

      r2 := 0;
      case Pos of
      8, 10, 12, 14, 30, 46, 62 : r2 := 1;
      17, 19, 21, 37, 53 : r2 := 2;
      24, 26, 36, 28, 44, 60 : r2 := 3;
      33, 35, 51: r2 := 4;
      40, 42, 58 : r2 := 5;
      49 : r2 := 6;
      56 : r2 := 7;
      end;

                                                        //Вправо вверх

      for i := 1 to r2 do begin
       case PiecesBoard[Pos - 7*i].Col of
       '' : possmoves[Pos - 7*i] := 1;
       'Black' : begin possmoves[Pos - 7*i] := 2; break; end;
       'White' : break; //begin possmoves[Pos - 7*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы


      if (Pos mod 8 <> 0) and (Pos <> 62) and (Pos <> 56) and (Pos <> 58) and (Pos <> 60) then begin    //Проверка на углы

      r2 := 0;
      case Pos of
      49, 33, 51, 53, 55, 17, 1 : r2 := 1;
      10, 26, 42, 44, 46 : r2 := 2;
      3, 19, 35, 37, 39: r2 := 3;
      12, 28, 30 : r2 := 4;
      5, 21, 23 : r2 := 5;
      14 : r2 := 6;
      7 : r2 := 7;
      end;

                                                        //Влево вниз

      for i := 1 to r2 do begin
       case PiecesBoard[Pos + 7*i].Col of
       '' : possmoves[Pos + 7*i] := 1;
       'Black' : begin possmoves[Pos + 7*i] := 2; break; end;
       'White' : break; //begin possmoves[Pos + 7*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы


       if (Pos mod 8 <> 0) and (Pos <> 1) and (Pos <> 3) and (Pos <> 5) and (Pos <> 7) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      14, 12, 10, 17, 33, 49 : r2 := 1;
      23, 21, 19, 26, 42, 58 : r2 := 2;
      30, 28, 35, 51 : r2 := 3;
      39, 37, 44, 60 : r2 := 4;
      46, 53 : r2 := 5;
      55, 62 : r2 := 6;
      end;

                                                        //Влево вверх

      for i := 1 to r2 do begin
       case PiecesBoard[Pos - 9*i].Col of
       '' : possmoves[Pos - 9*i] := 1;
       'Black' : begin possmoves[Pos - 9*i] := 2; break; end;
       'White' : break; //begin possmoves[Pos - 9*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы

       if (Pos mod 8 <> 7) and (Pos <> 56) and (Pos <> 58) and (Pos <> 60) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      14, 30, 46, 53, 51, 49 : r2 := 1;
      5, 21, 37, 44, 42, 40: r2 := 2;
      12, 28, 35, 33 : r2 := 3;
      3, 19, 26, 24: r2 := 4;
      10, 17 : r2 := 5;
      1, 8 : r2 := 6;
      end;

                                                        //Вправо вниз

      for i := 1 to r2 do begin
       case PiecesBoard[Pos + 9*i].Col of
       '' : possmoves[Pos + 9*i] := 1;
       'Black' : begin possmoves[Pos + 9*i] := 2; break; end;
       'White' : break; //begin possmoves[Pos + 9*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы

   end;


      //Белопольный черный слон

      if Piece = 'BBW.png' then begin

      if (Pos <> 0) and (Pos mod 8 <> 7) and (Pos <> 2) and (Pos <> 4) and (Pos <> 6) then begin    //Проверка на углы

      r2 := 0;
      case Pos of
      9,11,13,15,22,38,54 : r2 := 1;
      16, 18, 20, 29, 45, 61 : r2 := 2;
      25, 27, 36, 52 : r2 := 3;
      32, 34, 43, 59 : r2 := 4;
      50,41 : r2 := 5;
      48,57 : r2 := 6;
      end;

                                                        //Вправо вверх

      for i := 1 to r2 do begin
       case PiecesBoard[Pos - 7*i].Col of
       '' : possmoves[Pos - 7*i] := 1;
       'White' : begin possmoves[Pos - 7*i] := 2; break; end;
       'Black' : break;
       end; end;
       end;  //Проверка на углы


      if (Pos mod 8 <> 0) and (Pos <> 63) and (Pos <> 57) and (Pos <> 59) and (Pos <> 61) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      9, 25 ,41 ,50 ,52 ,54 : r2 := 1;
      2, 18, 34, 43, 45, 47 : r2 := 2;
      11, 27, 36, 38 : r2 := 3;
      4, 20, 29, 31 : r2 := 4;
      13, 22 : r2 := 5;
      6, 15 : r2 := 6;
      end;

                                                        //Влево вниз

      for i := 1 to r2 do begin
       case PiecesBoard[Pos + 7*i].Col of
       '' : possmoves[Pos + 7*i] := 1;
       'White' : begin possmoves[Pos + 7*i] := 2; break; end;
       'Black' : break; //begin possmoves[Pos + 7*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы


       if (Pos mod 8 <> 0) and (Pos <> 2) and (Pos <> 4) and (Pos <> 6) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      9, 11, 13, 15, 25, 41, 57 : r2 := 1;
      18, 20, 22, 34, 50 : r2 := 2;
      27, 29, 31, 43, 59 : r2 := 3;
      36, 38, 52 : r2 := 4;
      45, 47, 61 : r2 := 5;
      54 : r2 := 6;
      63 : r2 := 7;
      end;

                                                        //Влево вверх

      for i := 1 to r2 do begin
       case PiecesBoard[Pos - 9*i].Col of
       '' : possmoves[Pos - 9*i] := 1;
       'White' : begin possmoves[Pos - 9*i] := 2; break; end;
       'Black' : break; //begin possmoves[Pos - 9*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы

       if (Pos mod 8 <> 7) and (Pos <> 57) and (Pos <> 59) and (Pos <> 61) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      6, 22, 38, 54, 52, 50, 48 : r2 := 1;
      13, 29, 45, 43, 41 : r2 := 2;
      4, 20, 36, 34, 32 : r2 := 3;
      11, 27, 25: r2 := 4;
      2, 18, 16 : r2 := 5;
      9 : r2 := 6;
      0 : r2 := 7;
      end;

                                                        //Вправо вниз

      for i := 1 to r2 do begin
       case PiecesBoard[Pos + 9*i].Col of
       '' : possmoves[Pos + 9*i] := 1;
       'White' : begin possmoves[Pos + 9*i] := 2; break; end;
       'Black' : break; //begin possmoves[Pos + 9*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы

     end;

      //Чернопольный черный слон

       if Piece = 'BBB.png' then begin

      if (Pos mod 8 <> 7) and (Pos <> 1) and (Pos <> 3) and (Pos <> 5)  then begin    //Проверка на углы

      r2 := 0;
      case Pos of
      8, 10, 12, 14, 30, 46, 62 : r2 := 1;
      17, 19, 21, 37, 53 : r2 := 2;
      24, 26, 36, 28, 44, 60 : r2 := 3;
      33, 35, 51: r2 := 4;
      40, 42, 58 : r2 := 5;
      49 : r2 := 6;
      56 : r2 := 7;
      end;

                                                        //Вправо вверх

      for i := 1 to r2 do begin
       case PiecesBoard[Pos - 7*i].Col of
       '' : possmoves[Pos - 7*i] := 1;
       'White' : begin possmoves[Pos - 7*i] := 2; break; end;
       'Black' : break; //begin possmoves[Pos - 7*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы


      if (Pos mod 8 <> 0) and (Pos <> 62) and (Pos <> 56) and (Pos <> 58) and (Pos <> 60) then begin    //Проверка на углы

      r2 := 0;
      case Pos of
      49, 33, 51, 53, 55, 17, 1 : r2 := 1;
      10, 26, 42, 44, 46 : r2 := 2;
      3, 19, 35, 37, 39: r2 := 3;
      12, 28, 30 : r2 := 4;
      5, 21, 23 : r2 := 5;
      14 : r2 := 6;
      7 : r2 := 7;
      end;

                                                        //Влево вниз

      for i := 1 to r2 do begin
       case PiecesBoard[Pos + 7*i].Col of
       '' : possmoves[Pos + 7*i] := 1;
       'White' : begin possmoves[Pos + 7*i] := 2; break; end;
       'Black' : break; //begin possmoves[Pos + 7*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы


       if (Pos mod 8 <> 0) and (Pos <> 1) and (Pos <> 3) and (Pos <> 5) and (Pos <> 7) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      14, 12, 10, 17, 33, 49 : r2 := 1;
      23, 21, 19, 26, 42, 58 : r2 := 2;
      30, 28, 35, 51 : r2 := 3;
      39, 37, 44, 60 : r2 := 4;
      46, 53 : r2 := 5;
      55, 62 : r2 := 6;
      end;

                                                        //Влево вверх

      for i := 1 to r2 do begin
       case PiecesBoard[Pos - 9*i].Col of
       '' : possmoves[Pos - 9*i] := 1;
       'White' : begin possmoves[Pos - 9*i] := 2; break; end;
       'Black' : break; //begin possmoves[Pos - 9*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы

       if (Pos mod 8 <> 7) and (Pos <> 56) and (Pos <> 58) and (Pos <> 60) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      14, 30, 46, 53, 51, 49 : r2 := 1;
      5, 21, 37, 44, 42, 40: r2 := 2;
      12, 28, 35, 33 : r2 := 3;
      3, 19, 26, 24: r2 := 4;
      10, 17 : r2 := 5;
      1, 8 : r2 := 6;
      end;

                                                        //Вправо вниз

      for i := 1 to r2 do begin
       case PiecesBoard[Pos + 9*i].Col of
       '' : possmoves[Pos + 9*i] := 1;
       'White' : begin possmoves[Pos + 9*i] := 2; break; end;
       'Black' : break; //begin possmoves[Pos + 9*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы

   end;

     if Piece = 'WQ.png' then begin

     if (Pos <> 0) and (Pos <> 1) and (Pos <> 2) and (Pos <> 3) and (Pos <> 4) and (Pos <> 5) and (Pos <> 6) and (Pos <> 7) then begin

      for i := Pos div 8 - 1 downto 0 do begin
       case PiecesBoard[i*8 + Pos mod 8].Col of
       '' : possmoves[i*8 + Pos mod 8] := 1;                                //Вверх
       'Black' : begin possmoves[i*8 + Pos mod 8] := 2; break; end;
       'White' : break; //begin possmoves[i*8 + Pos mod 8] := 3; break; end;
       end; end;

       end;   //Проверка на 1-ую горизонталь

       if Pos mod 8 <> 0 then begin

       for i := Pos - 1 downto Pos - (Pos mod 8) do begin
        case PiecesBoard[i].Col of
        '' : possmoves[i] := 1;                                      //Влево
        'Black' : begin possmoves[i] := 2; break; end;
        'White' : break; // possmoves[i] := 3; break; end;
        end; end;
       end; //if Pos mod 8 <> 0 //Проверка на А вертикаль

       if Pos mod 8 <> 7 then begin

       for i := Pos + 1 to Pos + (7 - Pos mod 8) do begin
         case PiecesBoard[i].Col of
        '' : possmoves[i] := 1;                                    //Вправо
        'Black' : begin possmoves[i] := 2; break; end;
        'White' : break; //begin possmoves[i] := 3; break; end;
        end; end;
       end; //if Pos mod 8 <> 7 //Проверка на А вертикаль

       //Проверка на 8-ую горизонталь
       if (Pos <> 56) and (Pos <> 57) and (Pos <> 58) and (Pos <> 59) and (Pos <> 60) and (Pos <> 61) and (Pos <> 62) and (Pos <> 63) then begin

       for i := Pos div 8 + 1 to 7 do begin
        case PiecesBoard[i*8 + Pos mod 8].Col of
        '' : possmoves[i*8 + Pos mod 8] := 1;                                       //Вниз
        'Black' : begin possmoves[i*8 + Pos mod 8] := 2; break; end;
        'White' : break; //begin possmoves[i*8 + Pos mod 8] := 3; break; end;
        end; end;
       end;    //Проверка на 8-ую горизонталь

       if (Pos <> 0) and (Pos mod 8 <> 7) and (Pos <> 2) and (Pos <> 4) and (Pos <> 6) then begin    //Проверка на углы

      r2 := 0;
      case Pos of
      9,11,13,15,22,38,54 : r2 := 1;
      16, 18, 20, 29, 45, 61 : r2 := 2;
      25, 27, 36, 52 : r2 := 3;
      32, 34, 43, 59 : r2 := 4;
      50,41 : r2 := 5;
      48,57 : r2 := 6;
      end;

                                                        //Вправо вверх

      for i := 1 to r2 do begin
       case PiecesBoard[Pos - 7*i].Col of
       '' : possmoves[Pos - 7*i] := 1;
       'Black' : begin possmoves[Pos - 7*i] := 2; break; end;
       'White' : break; //begin possmoves[Pos - 7*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы


      if (Pos mod 8 <> 0) and (Pos <> 63) and (Pos <> 57) and (Pos <> 59) and (Pos <> 61) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      9, 25 ,41 ,50 ,52 ,54 : r2 := 1;
      2, 18, 34, 43, 45, 47 : r2 := 2;
      11, 27, 36, 38 : r2 := 3;
      4, 20, 29, 31 : r2 := 4;
      13, 22 : r2 := 5;
      6, 15 : r2 := 6;
      end;

                                                        //Влево вниз

      for i := 1 to r2 do begin
       case PiecesBoard[Pos + 7*i].Col of
       '' : possmoves[Pos + 7*i] := 1;
       'Black' : begin possmoves[Pos + 7*i] := 2; break; end;
       'White' : break; //begin possmoves[Pos + 7*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы


       if (Pos mod 8 <> 0) and (Pos <> 2) and (Pos <> 4) and (Pos <> 6) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      9, 11, 13, 15, 25, 41, 57 : r2 := 1;
      18, 20, 22, 34, 50 : r2 := 2;
      27, 29, 31, 43, 59 : r2 := 3;
      36, 38, 52 : r2 := 4;
      45, 47, 61 : r2 := 5;
      54 : r2 := 6;
      63 : r2 := 7;
      end;

                                                        //Влево вверх

      for i := 1 to r2 do begin
       case PiecesBoard[Pos - 9*i].Col of
       '' : possmoves[Pos - 9*i] := 1;
       'Black' : begin possmoves[Pos - 9*i] := 2; break; end;
       'White' : break; //begin possmoves[Pos - 9*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы

       if (Pos mod 8 <> 7) and (Pos <> 57) and (Pos <> 59) and (Pos <> 61) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      6, 22, 38, 54, 52, 50, 48 : r2 := 1;
      13, 29, 45, 43, 41 : r2 := 2;
      4, 20, 36, 34, 32 : r2 := 3;
      11, 27, 25: r2 := 4;
      2, 18, 16 : r2 := 5;
      9 : r2 := 6;
      0 : r2 := 7;
      end;

                                                        //Вправо вниз

      for i := 1 to r2 do begin
       case PiecesBoard[Pos + 9*i].Col of
       '' : possmoves[Pos + 9*i] := 1;
       'Black' : begin possmoves[Pos + 9*i] := 2; break; end;
       'White' : break; //begin possmoves[Pos + 9*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы

       if (Pos mod 8 <> 7) and (Pos <> 1) and (Pos <> 3) and (Pos <> 5)  then begin    //Проверка на углы

      r2 := 0;
      case Pos of
      8, 10, 12, 14, 30, 46, 62 : r2 := 1;
      17, 19, 21, 37, 53 : r2 := 2;
      24, 26, 36, 28, 44, 60 : r2 := 3;
      33, 35, 51: r2 := 4;
      40, 42, 58 : r2 := 5;
      49 : r2 := 6;
      56 : r2 := 7;
      end;

                                                        //Вправо вверх

      for i := 1 to r2 do begin
       case PiecesBoard[Pos - 7*i].Col of
       '' : possmoves[Pos - 7*i] := 1;
       'Black' : begin possmoves[Pos - 7*i] := 2; break; end;
       'White' : break; //begin possmoves[Pos - 7*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы


      if (Pos mod 8 <> 0) and (Pos <> 62) and (Pos <> 56) and (Pos <> 58) and (Pos <> 60) then begin    //Проверка на углы

      r2 := 0;
      case Pos of
      49, 33, 51, 53, 55, 17, 1 : r2 := 1;
      10, 26, 42, 44, 46 : r2 := 2;
      3, 19, 35, 37, 39: r2 := 3;
      12, 28, 30 : r2 := 4;
      5, 21, 23 : r2 := 5;
      14 : r2 := 6;
      7 : r2 := 7;
      end;

                                                        //Влево вниз

      for i := 1 to r2 do begin
       case PiecesBoard[Pos + 7*i].Col of
       '' : possmoves[Pos + 7*i] := 1;
       'Black' : begin possmoves[Pos + 7*i] := 2; break; end;
       'White' : break; //begin possmoves[Pos + 7*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы


       if (Pos mod 8 <> 0) and (Pos <> 1) and (Pos <> 3) and (Pos <> 5) and (Pos <> 7) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      14, 12, 10, 17, 33, 49 : r2 := 1;
      23, 21, 19, 26, 42, 58 : r2 := 2;
      30, 28, 35, 51 : r2 := 3;
      39, 37, 44, 60 : r2 := 4;
      46, 53 : r2 := 5;
      55, 62 : r2 := 6;
      end;

                                                        //Влево вверх

      for i := 1 to r2 do begin
       case PiecesBoard[Pos - 9*i].Col of
       '' : possmoves[Pos - 9*i] := 1;
       'Black' : begin possmoves[Pos - 9*i] := 2; break; end;
       'White' : break; //begin possmoves[Pos - 9*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы

       if (Pos mod 8 <> 7) and (Pos <> 56) and (Pos <> 58) and (Pos <> 60) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      14, 30, 46, 53, 51, 49 : r2 := 1;
      5, 21, 37, 44, 42, 40: r2 := 2;
      12, 28, 35, 33 : r2 := 3;
      3, 19, 26, 24: r2 := 4;
      10, 17 : r2 := 5;
      1, 8 : r2 := 6;
      end;

                                                        //Вправо вниз

      for i := 1 to r2 do begin
       case PiecesBoard[Pos + 9*i].Col of
       '' : possmoves[Pos + 9*i] := 1;
       'Black' : begin possmoves[Pos + 9*i] := 2; break; end;
       'White' : break; //begin possmoves[Pos + 9*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы

     end;

     if Piece = 'BQ.png' then begin

     //Проверка на 1-ую горизонталь
      if (Pos <> 0) and (Pos <> 1) and (Pos <> 2) and (Pos <> 3) and (Pos <> 4) and (Pos <> 5) and (Pos <> 6) and (Pos <> 7) then begin

      for i := Pos div 8 - 1 downto 0 do begin
       case PiecesBoard[i*8 + Pos mod 8].Col of
       '' : possmoves[i*8 + Pos mod 8] := 1;                                //Вверх
       'White' : begin possmoves[i*8 + Pos mod 8] := 2; break; end;
       'Black' : break; //begin possmoves[i*8 + Pos mod 8] := 3; break; end;
       end; end;

       end;   //Проверка на 1-ую горизонталь

       if Pos mod 8 <> 0 then begin

       for i := Pos - 1 downto Pos - (Pos mod 8) do begin
        case PiecesBoard[i].Col of
        '' : possmoves[i] := 1;                                      //Влево
        'White' : begin possmoves[i] := 2; break; end;
        'Black' : break; //begin possmoves[i] := 3; break; end;
        end; end;
       end; //if Pos mod 8 <> 0 //Проверка на А вертикаль

       if Pos mod 8 <> 7 then begin

       for i := Pos + 1 to Pos + (7 - Pos mod 8) do begin
         case PiecesBoard[i].Col of
        '' : possmoves[i] := 1;                                    //Вправо
        'White' : begin possmoves[i] := 2; break; end;
        'Black' : break; //begin possmoves[i] := 3; break; end;
        end; end;
       end; //if Pos mod 8 <> 7 //Проверка на А вертикаль

       //Проверка на 8-ую горизонталь
       if (Pos <> 56) and (Pos <> 57) and (Pos <> 58) and (Pos <> 59) and (Pos <> 60) and (Pos <> 61) and (Pos <> 62) and (Pos <> 63) then begin

       for i := Pos div 8 + 1 to 7 do begin
        case PiecesBoard[i*8 + Pos mod 8].Col of
        '' : possmoves[i*8 + Pos mod 8] := 1;                                       //Вниз
        'White' : begin possmoves[i*8 + Pos mod 8] := 2; break; end;
        'Black' : break; //begin possmoves[i*8 + Pos mod 8] := 3; break; end;
        end; end;
       end;    //Проверка на 8-ую горизонталь

       if (Pos <> 0) and (Pos mod 8 <> 7) and (Pos <> 2) and (Pos <> 4) and (Pos <> 6) then begin    //Проверка на углы

      r2 := 0;
      case Pos of
      9,11,13,15,22,38,54 : r2 := 1;
      16, 18, 20, 29, 45, 61 : r2 := 2;
      25, 27, 36, 52 : r2 := 3;
      32, 34, 43, 59 : r2 := 4;
      50,41 : r2 := 5;
      48,57 : r2 := 6;
      end;

                                                        //Вправо вверх

      for i := 1 to r2 do begin
       case PiecesBoard[Pos - 7*i].Col of
       '' : possmoves[Pos - 7*i] := 1;
       'White' : begin possmoves[Pos - 7*i] := 2; break; end;
       'Black' : break; //begin possmoves[Pos - 7*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы


      if (Pos mod 8 <> 0) and (Pos <> 63) and (Pos <> 57) and (Pos <> 59) and (Pos <> 61) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      9, 25 ,41 ,50 ,52 ,54 : r2 := 1;
      2, 18, 34, 43, 45, 47 : r2 := 2;
      11, 27, 36, 38 : r2 := 3;
      4, 20, 29, 31 : r2 := 4;
      13, 22 : r2 := 5;
      6, 15 : r2 := 6;
      end;

                                                        //Влево вниз

      for i := 1 to r2 do begin
       case PiecesBoard[Pos + 7*i].Col of
       '' : possmoves[Pos + 7*i] := 1;
       'White' : begin possmoves[Pos + 7*i] := 2; break; end;
       'Black' : break; //begin possmoves[Pos + 7*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы


       if (Pos mod 8 <> 0) and (Pos <> 2) and (Pos <> 4) and (Pos <> 6) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      9, 11, 13, 15, 25, 41, 57 : r2 := 1;
      18, 20, 22, 34, 50 : r2 := 2;
      27, 29, 31, 43, 59 : r2 := 3;
      36, 38, 52 : r2 := 4;
      45, 47, 61 : r2 := 5;
      54 : r2 := 6;
      63 : r2 := 7;
      end;

                                                        //Влево вверх

      for i := 1 to r2 do begin
       case PiecesBoard[Pos - 9*i].Col of
       '' : possmoves[Pos - 9*i] := 1;
       'White' : begin possmoves[Pos - 9*i] := 2; break; end;
       'Black' : break; //begin possmoves[Pos - 9*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы

       if (Pos mod 8 <> 7) and (Pos <> 57) and (Pos <> 59) and (Pos <> 61) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      6, 22, 38, 54, 52, 50, 48 : r2 := 1;
      13, 29, 45, 43, 41 : r2 := 2;
      4, 20, 36, 34, 32 : r2 := 3;
      11, 27, 25: r2 := 4;
      2, 18, 16 : r2 := 5;
      9 : r2 := 6;
      0 : r2 := 7;
      end;

                                                        //Вправо вниз

      for i := 1 to r2 do begin
       case PiecesBoard[Pos + 9*i].Col of
       '' : possmoves[Pos + 9*i] := 1;
       'White' : begin possmoves[Pos + 9*i] := 2; break; end;
       'Black' : break; //begin possmoves[Pos + 9*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы


       if (Pos mod 8 <> 7) and (Pos <> 1) and (Pos <> 3) and (Pos <> 5)  then begin    //Проверка на углы

      r2 := 0;
      case Pos of
      8, 10, 12, 14, 30, 46, 62 : r2 := 1;
      17, 19, 21, 37, 53 : r2 := 2;
      24, 26, 36, 28, 44, 60 : r2 := 3;
      33, 35, 51: r2 := 4;
      40, 42, 58 : r2 := 5;
      49 : r2 := 6;
      56 : r2 := 7;
      end;

                                                        //Вправо вверх

      for i := 1 to r2 do begin
       case PiecesBoard[Pos - 7*i].Col of
       '' : possmoves[Pos - 7*i] := 1;
       'White' : begin possmoves[Pos - 7*i] := 2; break; end;
       'Black' : break; //begin possmoves[Pos - 7*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы


      if (Pos mod 8 <> 0) and (Pos <> 62) and (Pos <> 56) and (Pos <> 58) and (Pos <> 60) then begin    //Проверка на углы

      r2 := 0;
      case Pos of
      49, 33, 51, 53, 55, 17, 1 : r2 := 1;
      10, 26, 42, 44, 46 : r2 := 2;
      3, 19, 35, 37, 39: r2 := 3;
      12, 28, 30 : r2 := 4;
      5, 21, 23 : r2 := 5;
      14 : r2 := 6;
      7 : r2 := 7;
      end;

                                                        //Влево вниз

      for i := 1 to r2 do begin
       case PiecesBoard[Pos + 7*i].Col of
       '' : possmoves[Pos + 7*i] := 1;
       'White' : begin possmoves[Pos + 7*i] := 2; break; end;
       'Black' : break; //begin possmoves[Pos + 7*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы


       if (Pos mod 8 <> 0) and (Pos <> 1) and (Pos <> 3) and (Pos <> 5) and (Pos <> 7) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      14, 12, 10, 17, 33, 49 : r2 := 1;
      23, 21, 19, 26, 42, 58 : r2 := 2;
      30, 28, 35, 51 : r2 := 3;
      39, 37, 44, 60 : r2 := 4;
      46, 53 : r2 := 5;
      55, 62 : r2 := 6;
      end;

                                                        //Влево вверх

      for i := 1 to r2 do begin
       case PiecesBoard[Pos - 9*i].Col of
       '' : possmoves[Pos - 9*i] := 1;
       'White' : begin possmoves[Pos - 9*i] := 2; break; end;
       'Black' : break; //begin possmoves[Pos - 9*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы

       if (Pos mod 8 <> 7) and (Pos <> 56) and (Pos <> 58) and (Pos <> 60) then begin    //Проверка на углы

       r2 := 0;
      case Pos of
      14, 30, 46, 53, 51, 49 : r2 := 1;
      5, 21, 37, 44, 42, 40: r2 := 2;
      12, 28, 35, 33 : r2 := 3;
      3, 19, 26, 24: r2 := 4;
      10, 17 : r2 := 5;
      1, 8 : r2 := 6;
      end;

                                                        //Вправо вниз

      for i := 1 to r2 do begin
       case PiecesBoard[Pos + 9*i].Col of
       '' : possmoves[Pos + 9*i] := 1;
       'White' : begin possmoves[Pos + 9*i] := 2; break; end;
       'Black' : break; //begin possmoves[Pos + 9*i] := 3; break; end;
       end; end;
       end;  //Проверка на углы



     end;



     if Piece = 'WKN.png' then begin

     case Pos of
     18..21, 26..29, 34..37, 42..45 : begin
     for i := 1 to 8 do begin
     knightposmoves(kn_mv[i]); end; end; end;

     case Pos of
     2..5: begin
     for i := 3 to 6 do begin
     knightposmoves(kn_mv[i]); end; end; end;

     case Pos of
     10..13 : begin
     for i := 2 to 7 do begin
     knightposmoves(kn_mv[i]); end; end; end;

     case Pos of
      50..53 : begin
       for i := 1 to 8 do begin
       case kn_mv[i] of
         6,-10,-17,-15,-6,10 :
          knightposmoves(kn_mv[i]); end; end; end; end;

     case Pos of
       58..61 : begin
       for i := 1 to 8 do begin
       case kn_mv[i] of
         -10,-17,-15,-6 :
          knightposmoves(kn_mv[i]); end; end; end; end;

     case Pos of 17,25,33,41 : begin
       for i := 1 to 8 do begin
       case kn_mv[i] of
         -17,-15,-6,10,17,15 :
          knightposmoves(kn_mv[i]); end; end; end; end;

     case Pos of 22,30,38,46 : begin
       for i := 1 to 8 do begin
       case kn_mv[i] of
         -15,-17,-10,6,15,17 :
          knightposmoves(kn_mv[i]); end; end; end; end;

     case Pos of 16,24,32,40 : begin
       for i := 1 to 8 do begin
       case kn_mv[i] of
         -15,-6,10,17 :
          knightposmoves(kn_mv[i]); end; end; end; end;

     case Pos of 23,31,39,47 : begin
       for i := 1 to 8 do begin
       case kn_mv[i] of
         -17,-10,6,15 :
          knightposmoves(kn_mv[i]); end; end; end; end;

     if Pos = 9 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -6,10,17,15 :
          knightposmoves(kn_mv[i]); end; end; end;

     if Pos = 49 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -17,-15,-6,10 :
          knightposmoves(kn_mv[i]); end; end; end;

      if Pos = 54 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -15,-17,-10,6 :
          knightposmoves(kn_mv[i]); end; end; end;

      if Pos = 54 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -15,-17,-10,6 :
          knightposmoves(kn_mv[i]);end; end; end;

      if Pos = 14 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         17,15,6,-10 :
          knightposmoves(kn_mv[i]); end; end; end;

       if Pos = 0 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         10,17 :
          knightposmoves(kn_mv[i]); end; end; end;

       if Pos = 7 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         6,15 :
          knightposmoves(kn_mv[i]); end; end; end;

       if Pos = 56 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -15,-6 :
          knightposmoves(kn_mv[i]); end; end; end;

       if Pos = 63 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -17,-10 :
          knightposmoves(kn_mv[i]); end; end; end;

       if Pos = 1 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         15,17,10 :
          knightposmoves(kn_mv[i]); end; end; end;

       if Pos = 8 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -6,10,17 :
          knightposmoves(kn_mv[i]); end; end; end;

        if Pos = 48 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -15,-6,10 :
          knightposmoves(kn_mv[i]); end; end; end;

        if Pos = 57 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -17,-15, -6 :
          knightposmoves(kn_mv[i]); end; end; end;

        if Pos = 55 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -17,-10,6 :
          knightposmoves(kn_mv[i]); end; end; end;

         if Pos = 62 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -15,-17,-10 :
          knightposmoves(kn_mv[i]); end; end; end;

         if Pos = 6 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         15, 17, 6 :
          knightposmoves(kn_mv[i]); end; end; end;

         if Pos = 15 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         15, -10, 6 :
          knightposmoves(kn_mv[i]); end; end; end;



     end;     //Белый конь

      if Piece = 'BKN.png' then begin

     case Pos of
     18..21, 26..29, 34..37, 42..45 : begin
     for i := 1 to 8 do begin
     blackknightposmoves(kn_mv[i]); end; end; end;

     case Pos of
     2..5: begin
     for i := 3 to 6 do begin
     blackknightposmoves(kn_mv[i]); end; end; end;

     case Pos of
     10..13 : begin
     for i := 2 to 7 do begin
     blackknightposmoves(kn_mv[i]); end; end; end;

     case Pos of
      50..53 : begin
       for i := 1 to 8 do begin
       case kn_mv[i] of
         6,-10,-17,-15,-6,10 :
          blackknightposmoves(kn_mv[i]); end; end; end; end;

     case Pos of
       58..61 : begin
       for i := 1 to 8 do begin
       case kn_mv[i] of
         -10,-17,-15,-6 :
          blackknightposmoves(kn_mv[i]); end; end; end; end;

     case Pos of 17,25,33,41 : begin
       for i := 1 to 8 do begin
       case kn_mv[i] of
         -17,-15,-6,10,17,15 :
          blackknightposmoves(kn_mv[i]); end; end; end; end;

     case Pos of 22,30,38,46 : begin
       for i := 1 to 8 do begin
       case kn_mv[i] of
         -15,-17,-10,6,15,17 :
          blackknightposmoves(kn_mv[i]); end; end; end; end;

     case Pos of 16,24,32,40 : begin
       for i := 1 to 8 do begin
       case kn_mv[i] of
         -15,-6,10,17 :
          blackknightposmoves(kn_mv[i]); end; end; end; end;

     case Pos of 23,31,39,47 : begin
       for i := 1 to 8 do begin
       case kn_mv[i] of
         -17,-10,6,15 :
          blackknightposmoves(kn_mv[i]); end; end; end; end;

     if Pos = 9 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -6,10,17,15 :
          blackknightposmoves(kn_mv[i]); end; end; end;

     if Pos = 49 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -17,-15,-6,10 :
          blackknightposmoves(kn_mv[i]); end; end; end;

      if Pos = 54 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -15,-17,-10,6 :
          blackknightposmoves(kn_mv[i]); end; end; end;

      if Pos = 54 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -15,-17,-10,6 :
          blackknightposmoves(kn_mv[i]);end; end; end;

      if Pos = 14 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         17,15,6,-10 :
          blackknightposmoves(kn_mv[i]); end; end; end;

       if Pos = 0 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         10,17 :
          blackknightposmoves(kn_mv[i]); end; end; end;

       if Pos = 7 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         6,15 :
          blackknightposmoves(kn_mv[i]); end; end; end;

       if Pos = 56 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -15,-6 :
          blackknightposmoves(kn_mv[i]); end; end; end;

       if Pos = 63 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -17,-10 :
          blackknightposmoves(kn_mv[i]); end; end; end;

       if Pos = 1 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         15,17,10 :
          blackknightposmoves(kn_mv[i]); end; end; end;

       if Pos = 8 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -6,10,17 :
          blackknightposmoves(kn_mv[i]); end; end; end;

        if Pos = 48 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -15,-6,10 :
          blackknightposmoves(kn_mv[i]); end; end; end;

        if Pos = 57 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -17,-15, -6 :
          blackknightposmoves(kn_mv[i]); end; end; end;

        if Pos = 55 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -17,-10,6 :
          blackknightposmoves(kn_mv[i]); end; end; end;

         if Pos = 62 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         -15,-17,-10 :
          blackknightposmoves(kn_mv[i]); end; end; end;

         if Pos = 6 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         15, 17, 6 :
          blackknightposmoves(kn_mv[i]); end; end; end;

         if Pos = 15 then begin
       for i := 1 to 8 do begin
        case kn_mv[i] of
         15, -10, 6 :
          blackknightposmoves(kn_mv[i]); end; end; end;

     end;     //Черный конь

     if Piece = 'WK.png' then begin

       case Pos of 57..62 :
       for i := 1 to 8 do begin
        case king_mv[i] of
         -9,-8,-7,1,-1 :
          whitekingmove(king_mv[i]); end; end; end;

     case Pos of 1..6 :
       for i := 1 to 8 do begin
        case king_mv[i] of
         -1,7,8,9,1 :
          whitekingmove(king_mv[i]); end; end; end;

     case Pos of 8,16,24,32,40,48 :
       for i := 1 to 8 do begin
        case king_mv[i] of
         -8,-7,1,9,8 :
          whitekingmove(king_mv[i]); end; end; end;

     case Pos of 15,23,31,39,47,55 :
       for i := 1 to 8 do begin
        case king_mv[i] of
         -8,-9,-1,7,8 :
          whitekingmove(king_mv[i]); end; end; end;

     if Pos = 0 then begin
       for i := 1 to 8 do begin
        case king_mv[i] of
         1,9,8 :
          whitekingmove(king_mv[i]); end; end; end;

     if Pos = 56 then begin
       for i := 1 to 8 do begin
        case king_mv[i] of
         -8,-7,1 :
          whitekingmove(king_mv[i]); end; end; end;

     if Pos = 7 then begin
       for i := 1 to 8 do begin
        case king_mv[i] of
         -1,7,8 :
          whitekingmove(king_mv[i]); end; end; end;

     if Pos = 63 then begin
       for i := 1 to 8 do begin
        case king_mv[i] of
         -8,-9,-1 :
          whitekingmove(king_mv[i]); end; end; end;

     case Pos of 9..14,17..22,25..30,33..38,41..46,49..54 :
       for i := 1 to 8 do begin
          whitekingmove(king_mv[i]); end; end;

       if (Pos = 60) and (not wkcheck) and (PiecesBoard[Pos].FirstMove = true) and (PiecesBoard[62].FileName = '') and (PiecesBoard[62].FileName = '') and (PiecesBoard[63].FileName = 'WR.png')  and (PiecesBoard[63].FirstMove = true) then begin
          possmoves[62]  := 1;
       end;
       if (Pos = 60) and (not wkcheck) and (PiecesBoard[Pos].FirstMove = true) and (PiecesBoard[59].FileName = '') and (PiecesBoard[57].FileName = '')  and (PiecesBoard[58].FileName = '') and (PiecesBoard[56].FileName = 'WR.png')  and (PiecesBoard[56].FirstMove = true) then begin
          possmoves[58] := 1;
       end;

     end; //Белый король

        if Piece = 'BK.png' then begin

       case Pos of 57..62 :
       for i := 1 to 8 do begin
        case king_mv[i] of
         -9,-8,-7,1,-1 :
          blackkingmove(king_mv[i]); end; end; end;

     case Pos of 1..6 :
       for i := 1 to 8 do begin
        case king_mv[i] of
         -1,7,8,9,1 :
          blackkingmove(king_mv[i]); end; end; end;

     case Pos of 8,16,24,32,40,48 :
       for i := 1 to 8 do begin
        case king_mv[i] of
         -8,-7,1,9,8 :
          blackkingmove(king_mv[i]); end; end; end;

     case Pos of 15,23,31,39,47,55 :
       for i := 1 to 8 do begin
        case king_mv[i] of
         -8,-9,-1,7,8 :
          blackkingmove(king_mv[i]); end; end; end;

     if Pos = 0 then begin
       for i := 1 to 8 do begin
        case king_mv[i] of
         1,9,8 :
          blackkingmove(king_mv[i]); end; end; end;

     if Pos = 56 then begin
       for i := 1 to 8 do begin
        case king_mv[i] of
         -8,-7,1 :
          blackkingmove(king_mv[i]); end; end; end;

     if Pos = 7 then begin
       for i := 1 to 8 do begin
        case king_mv[i] of
         -1,7,8 :
          blackkingmove(king_mv[i]); end; end; end;

     if Pos = 63 then begin
       for i := 1 to 8 do begin
        case king_mv[i] of
         -8,-9,-1 :
          blackkingmove(king_mv[i]); end; end; end;

     case Pos of 9..14,17..22,25..30,33..38,41..46,49..54 :
       for i := 1 to 8 do begin
          blackkingmove(king_mv[i]); end; end;

       if (Pos = 4) and (PiecesBoard[Pos].FirstMove = true) and (PiecesBoard[5].FileName = '') and (PiecesBoard[6].FileName = '') and (PiecesBoard[7].FileName = 'BR.png')  and (PiecesBoard[7].FirstMove = true) and (not bkcheck) then begin
          possmoves[6] := 1;
       end;
       if (Pos = 4) and (PiecesBoard[Pos].FirstMove = true) and (PiecesBoard[3].FileName = '') and (PiecesBoard[2].FileName = '')  and (PiecesBoard[1].FileName = '') and (PiecesBoard[0].FileName = 'BR.png')  and (not bkcheck) and (PiecesBoard[0].FirstMove = true) then begin
          possmoves[2] := 1;
       end;


     end; //Черный король


end;


procedure TBox.FormCreate(Sender: TObject);
var
  x, y, k, n, i : integer;
  ttop1, ttop2, tleft1, tleft2 : integer;
  Reg :  TRegistry;
begin

  if firstenter then begin
  Reg := TRegistry.Create;
  Reg.OpenKey('Laz\Chess', False);
  try
    WhitePoint.Caption := Reg.ReadString('HW');
    BlackPoint.Caption := Reg.ReadString('BW');
    StalePoint.Caption := Reg.ReadString('SM');
  except
    WhitePoint.Caption := '0';
    BlackPoint.Caption := '0';
    StalePoint.Caption := '0';
  end;
    Reg.Free;

  firstenter := false;

  end;

  randomize;

  k := 1;
  // Рисование фигур
  n := 0;
  for y := 0 to 7 do
  begin
    for x := 0 to 7 do
    begin
      PiecesBoard[n] := TImgAndName.Create(self);
      Board[n] := TImgAndName.Create(self);
      if k = 1 then
      begin
        Board[n].left := 50;
        Board[n].top := 50;
        PiecesBoard[n].left := 55;
        PiecesBoard[n].top := 55;
      end;
      if (x <> 0) then
      begin
        Board[n].left := Board[n - 1].left + 100;

        PiecesBoard[n].left := PiecesBoard[n - 1].left + 100;
      end;
      Board[n].Parent := self;
      Board[n].Width := 100;
      Board[n].Height := 100;
      Board[n].Pos := n;

      PiecesBoard[n].Parent := self;
      PiecesBoard[n].Width := 100;
      PiecesBoard[n].Height := 100;
      PiecesBoard[n].onclick := @PiecesBoardClickEvent;
      PiecesBoard[n].Pos := n;

      if (x + y) mod 2 <> 0 then begin
        Board[n].Picture.LoadFromFile('green.png');
        Board[n].FileName := 'green.png';
      end
      else begin
        Board[n].Picture.LoadFromFile('yellow.png');
      Board[n].FileName := 'yellow.png';
      end;
      if y > 0 then
      begin
        Board[n].top := Board[n - 8].top + 100;
        PiecesBoard[n].top := PiecesBoard[n - 8].top + 100;
      end;
      Inc(n);
    end;
  end;

  // Установка фигур в начальное положение

  for i := 0 to 63 do
  begin
    if (i = 0) or (i = 7) then
    begin
      PiecesBoard[i].Picture.LoadFromFile('BR.png');
      PiecesBoard[i].FileName := 'BR.png';
      PiecesBoard[i].Col := 'Black';
      PiecesBoard[i].FirstMove := True;
    end;
    if (i = 1) or (i = 6) then
    begin
      PiecesBoard[i].FileName := 'BKN.png';
      PiecesBoard[i].Picture.LoadFromFile('BKN.png');
      PiecesBoard[i].Col := 'Black';
    end;
    if i = 2 then
    begin
      PiecesBoard[i].Picture.LoadFromFile('BBW.png');
      PiecesBoard[i].FileName := 'BBW.png';
      PiecesBoard[i].Col := 'Black';
    end;
    if i = 5 then
    begin
      PiecesBoard[i].Picture.LoadFromFile('BBB.png');
      PiecesBoard[i].FileName := 'BBB.png';
      PiecesBoard[i].Col := 'Black';
    end;
    if i = 3 then
    begin
      PiecesBoard[i].Picture.LoadFromFile('BQ.png');
      PiecesBoard[i].FileName := 'BQ.png';
      PiecesBoard[i].Col := 'Black';
    end;
    if i = 4 then
    begin
      PiecesBoard[i].Picture.LoadFromFile('BK.png');
      PiecesBoard[i].FileName := 'BK.png';
      PiecesBoard[i].Col := 'Black';
      PiecesBoard[i].FirstMove := True;
      blackkingposition := i;
    end;
    if (i > 7) and (i < 16) then
    begin
      PiecesBoard[i].Picture.LoadFromFile('BP.png');
      PiecesBoard[i].FileName := 'BP.png';
      PiecesBoard[i].Col := 'Black';
      PiecesBoard[i].FirstMove := true;
    end;
      if (i >= 40) and (i <= 47) then
      PiecesBoard[i].Col := '';
    if (i > 47) and (i < 56) then
    begin
      PiecesBoard[i].Picture.LoadFromFile('WP.png');
      PiecesBoard[i].FileName := 'WP.png';
      PiecesBoard[i].Col := 'White';
      PiecesBoard[i].FirstMove := true;
    end;
    if (i = 56) or (i = 63) then
    begin
      PiecesBoard[i].Picture.LoadFromFile('WR.png');
      PiecesBoard[i].FileName := 'WR.png';
      PiecesBoard[i].Col := 'White';
      PiecesBoard[i].FirstMove := True;
    end;
    if (i = 57) or (i = 62) then
    begin
      PiecesBoard[i].Picture.LoadFromFile('WKN.png');
      PiecesBoard[i].FileName := 'WKN.png';
      PiecesBoard[i].Col := 'White';
    end;
    if i = 58 then
    begin
      PiecesBoard[i].Picture.LoadFromFile('WBB.png');
      PiecesBoard[i].FileName := 'WBB.png';
      PiecesBoard[i].Col := 'White';
    end;
    if i = 61 then
    begin
      PiecesBoard[i].Picture.LoadFromFile('WBW.png');
      PiecesBoard[i].FileName := 'WBW.png';
      PiecesBoard[i].Col := 'White';
    end;
    if i = 59 then
    begin
      PiecesBoard[i].Picture.LoadFromFile('WQ.png');
      PiecesBoard[i].FileName := 'WQ.png';
      PiecesBoard[i].Col := 'White';
    end;
    if i = 60 then
    begin
      PiecesBoard[i].Picture.LoadFromFile('WK.png');
      PiecesBoard[i].FileName := 'WK.png';
      PiecesBoard[i].Col := 'White';
      PiecesBoard[i].FirstMove := True;
      whitekingposition := i;
    end;
  end;

   if not bot_black then begin

   for i := 0 to 31 do begin

   ttop1 := Board[i].Top;
   Board[i].Top := Board[63-i].Top;
   Board[63-i].Top := ttop1;
   tleft1 := Board[i].Left;
   Board[i].Left := Board[63-i].Left;
   Board[63-i].Left := tleft1;

   ttop2 := PiecesBoard[i].Top;
   PiecesBoard[i].Top := PiecesBoard[63-i].Top;
   PiecesBoard[63-i].Top := ttop2;
   tleft2 := PiecesBoard[i].Left;
   PiecesBoard[i].Left := PiecesBoard[63-i].Left;
   PiecesBoard[63-i].Left := tleft2

   end;

   end;





   refresh;



   //if bot_black = false then
   //bot_move;

end;

procedure TBox.BKNClick(Sender: TObject);
begin
newname := 'BKN.png';
complete := true;
end;

procedure TBox.BBClick(Sender: TObject);
begin

  if TImgAndName(Sender).Pos mod 2 = 1 then
  newname := 'BBW.png' else newname := 'BBB.png';

  complete := true;
end;

procedure TBox.BRClick(Sender: TObject);
begin
   newname := 'BR.png';
  complete := true;
end;

procedure TBox.FormClose(Sender: TObject; var CloseAction: TCloseAction);
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  try
   Reg.OpenKey('Laz\Chess',True);
   Reg.WriteString('HW',WhitePoint.Caption);
   Reg.WriteString('BW',BlackPoint.Caption);
   Reg.WriteString('SM',StalePoint.Caption);
  finally
    Reg.Free;
  end;

end;


procedure TBox.FormPaint(Sender: TObject);
var
  Letters : array[0..7] of char = ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h');
  Numbers : array[0..7] of char = ('8', '7', '6', '5', '4', '3', '2', '1');
  i, j :    integer;
begin

  Canvas.Brush.Color := RGB(49, 46, 43);
  Canvas.Pen.Color := RGB(49,46,43);
  Canvas.Rectangle(10,50,10,800);
  Canvas.Rectangle(10,800,800,800);

  if bot_black then begin

  // Буквы
  for i := 0 to 7 do
  begin
    if i mod 2 <> 1 then
      Canvas.Font.Color := RGB(239, 239, 211)
    else
      Canvas.Font.Color := RGB(119, 151, 85);
    Canvas.Font.Size := 15;
    Canvas.Brush.Style := bsClear;
    Canvas.TextOut(95 + (i * 100), 850, Letters[i]);
  end;

  // Цифры
  for j := 0 to 7 do
  begin
    if j mod 2 <> 1 then
      Canvas.Font.Color := RGB(119, 151, 85)
    else
      Canvas.Font.Color := RGB(239, 239, 211);
    Canvas.Font.Size := 15;
    Canvas.Brush.Style := bsClear;
    Canvas.TextOut(25, 85 + (j * 100), Numbers[j]);
  end;

  end else begin

   // Буквы
  for i := 0 to 7 do
  begin
    if i mod 2 <> 0 then
      Canvas.Font.Color := RGB(239, 239, 211)
    else
      Canvas.Font.Color := RGB(119, 151, 85);
    Canvas.Font.Size := 15;
    Canvas.Brush.Style := bsClear;
    Canvas.TextOut(795 - (i * 100), 850, Letters[i]);
  end;

  // Цифры
  for j := 0 to 7 do
  begin
    if j mod 2 <> 0 then
      Canvas.Font.Color := RGB(119, 151, 85)
    else
      Canvas.Font.Color := RGB(239, 239, 211);
    Canvas.Font.Size := 15;
    Canvas.Brush.Style := bsClear;
    Canvas.TextOut(25, 780 - (j * 100), Numbers[j]);
  end;

  end;

end;

procedure TBox.Label8Click(Sender: TObject);
begin

end;

procedure TBox.WBClick(Sender: TObject);
begin

  if TImgAndName(Sender).Pos mod 2 = 1 then
  newname := 'WBB.png' else newname := 'WBW.png';

  complete := true;
end;

procedure TBox.WKNClick(Sender: TObject);
begin
  newname := 'WKN.png';
  complete := true;
end;

procedure TBox.WQClick(Sender: TObject);
begin
  newname := 'WQ.png';
  complete := true;
end;

procedure TBox.BQClick(Sender: TObject);
begin
  newname := 'BQ.png';
  complete := true;
end;



procedure TBox.Memo1Change(Sender: TObject);
begin

end;


procedure TBox.PiecesBoardClickEvent(Sender: TObject);

  procedure repaint;
  //Очистка доски, при ходе противника
  var
    x, y, n : integer;
  begin

    n := 0;
    for y := 0 to 7 do
    begin
      for x := 0 to 7 do
      begin
        if (x + y) mod 2 <> 0 then begin
          Board[n].Picture.LoadFromFile('green.png');
          Board[n].FileName := 'green.png';
        end
        else begin
        Board[n].Picture.LoadFromFile('yellow.png');
        Board[n].FileName := ('yellow.png');
        end;
        Inc(n);
      end;
    end;
  end;

  procedure move1(piece: string; new : boolean);

    procedure move_ch(poss: integer);

    var
      x, y, n : integer;
    begin
      n := 0;
      for y := 0 to 7 do
      begin
        for x := 0 to 7 do
        begin
          if n = poss then
            if (x + y) mod 2 <> 0 then begin
              Board[poss].Picture.LoadFromFile('greenmove.png');
              Board[poss].FileName := ('greenmove.png');
            end
            //Закрашиваем клетки из/в котор..ой/ую был сделан ход
            else begin
              Board[poss].Picture.LoadFromFile('yellowmove.png');
              Board[poss].FileName := 'yellowmove.png';
            end;
          Inc(n);
        end;
      end;

    end;


   procedure posmove;
   var
      x, y, n : integer;
    begin
      n := 0;
      for y := 0 to 7 do
      begin
        for x := 0 to 7 do
        begin
          if possmoves[n] = 1 then begin
            if (x + y) mod 2 <> 0 then begin
              Board[n].Picture.LoadFromFile('green_pos_move.png');
              Board[n].FileName := 'green_pos_move.png';
            end
            //Закрашиваем клетки из/в котор..ой/ую был сделан ход
            else begin
             Board[n].Picture.LoadFromFile('yellow_pos_move.png');
             Board[n].FileName := 'yellow_pos_move.png';
            end;

          end
          else if possmoves[n] = 2 then begin
              if (x + y) mod 2 <> 0 then begin
              Board[n].Picture.LoadFromFile('green_pos_capture.png');
              Board[n].FileName := 'green_pos_capture.png';
              end
            //Закрашиваем клетки из/в котор..ой/ую был сделан ход
            else begin
              Board[n].Picture.LoadFromFile('yellow_pos_capture.png');
              Board[n].FileName := 'yellow_pos_capture.png';
            end;
          end;
          Inc(n);
        end;
      end;

    end;





















  var
    i : integer;
    piecepos : integer;
  begin

    castle := false;
    enpass := false;


    piecepos := TImgAndName(Sender).Pos;                                        //Запоминаем позицию клетки, в которую нажали

    if new then begin                                                           //Если выбрана фигура того же цвета
    for i := 0 to 63 do                                                         //Очищаем прошлые доступные ходы
    possmoves[i] := 0;
    repaint;                                                                    //Перерисовываем доску
    posmove;                                                                    //Наносим доступные ходы на доску
    Label2.Caption := 'Первый ход';                                             //Вносим в debug информацию, что это новый ход
    lastpiecepos := piecepos;                                                   //Запоминаем позицию фигуры, как предыдущую
    move_ch(lastpiecepos);                                                      //Закрашиваем поле, в котором взята фигура
    chosen := TImgAndName(Sender).FileName;                                     //Вносим в переменную данную фигуру
    end;

    if piece <> '' then                                                         //Если взята фигура, то
      Label2.Caption := 'Первый ход';                                           //Вносим в debug информацию, что это новый од
    if chosen <> '' then                                                        //Проверка на то, взята ли фигура
    begin
      if new then begin for i := 0 to 63 do possmoves[i]:=0; repaint; end;
      Label3.Caption := 'Прошлая позиция: ' + IntToStr(lastpiecepos);           //Вносим в debug инфомацию о прошлой позиции фигуры
      Label1.Caption := chosen + ' ' + inttostr(piecepos);                      //Вносим в debug инфомацию о фигуре и её положении
      Label2.Caption := 'Второй ход';                                           //Вносим в debug информацию, что ход был выполнен

      if lastpiecepos <> piecepos then                                          //Проверяем выполен ли вход
      if not new then begin                                                     //Проверка на выбор фигуры того же цвета
      PiecesBoard[lastpassant].EnPassant := False;                                                                        //Взятие на проходе
      if (chosen = 'WP.png') then begin
      case piecepos of
      32..39 :  case lastpiecepos of 48..55 : begin PiecesBoard[lastpiecepos-8].EnPassant := True; lastpassant := lastpiecepos - 8; end;
      end; end; end
      else
      if (chosen = 'WK.png') and (lastpiecepos = 60) and (not wkcheck) then begin
      if piecepos = 62 then begin
      PiecesBoard[63].Picture := nil;
      PiecesBoard[63].Col := '';
      PiecesBoard[63].FileName := '';
      PiecesBoard[63].FirstMove := false;                                       //Рокировка белых в короткую
      PiecesBoard[61].Picture.LoadFromFile('WR.png');
      PiecesBoard[61].Col := 'White';
      PiecesBoard[61].FileName := 'WR.png';
      PiecesBoard[61].FirstMove := false;
      castle := true;
      end
      else
      if piecepos = 58 then begin
      PiecesBoard[56].Picture := nil;
      PiecesBoard[56].Col := '';
      PiecesBoard[56].FileName := '';
      PiecesBoard[56].FirstMove := false;
      PiecesBoard[59].Picture.LoadFromFile('WR.png');                           //Рокировка белых в длинную
      PiecesBoard[59].Col := 'White';
      PiecesBoard[59].FileName := 'WR.png';
      PiecesBoard[59].FirstMove := false;
      castle := true;
      end;

      end;
      if (chosen = 'BK.png') and (lastpiecepos = 4) and (not bkcheck) then begin
      if piecepos = 6 then begin
      PiecesBoard[7].Picture := nil;
      PiecesBoard[7].Col := '';
      PiecesBoard[7].FileName := '';
      PiecesBoard[7].FirstMove := false;                                        //Рокировка черных в короткую
      PiecesBoard[5].Picture.LoadFromFile('BR.png');
      PiecesBoard[5].Col := 'Black';
      PiecesBoard[5].FileName := 'BR.png';
      PiecesBoard[5].FirstMove := false;
      castle := true;
      end
      else
      if piecepos = 2 then begin
      PiecesBoard[0].Picture := nil;
      PiecesBoard[0].Col := '';
      PiecesBoard[0].FileName := '';
      PiecesBoard[0].FirstMove := false;                                        //Рокировка белых в короткую
      PiecesBoard[3].Picture.LoadFromFile('WR.png');
      PiecesBoard[3].Col := 'White';
      PiecesBoard[3].FileName := 'WR.png';
      PiecesBoard[3].FirstMove := false;
      castle := true;
      end;
      end;
      if chosen = 'BP.png' then begin
      case piecepos of
      24..31 : case lastpiecepos of 8..15 : begin PiecesBoard[lastpiecepos+8].EnPassant := true; lastpassant := lastpiecepos + 8; end;
      end;end; end;
      if chosen = 'WK.png' then whitekingposition := piecepos
      else if chosen = 'BK.png' then blackkingposition := piecepos;

      lastpicture := PiecesBoard[piecepos].FileName;
      lastFirstMove := PiecesBoard[piecepos].FirstMove;
      last2col := PiecesBoard[piecepos].Col;


      PiecesBoard[piecepos].FirstMove := False;
      PiecesBoard[piecepos].FileName := chosen;                                 //Заносим имя этой фигуры в эту клетку
      PiecesBoard[piecepos].Col := lastcol;                                     //Заносим в клетку цвет фигуры
      PiecesBoard[piecepos].Picture.LoadFromFile(chosen);                       //Переносим фигуру в клетку
      if not new then begin
      for i := 0 to 63 do                                                       //Очищаем доступные ходы и чистим поле
      possmoves[i] := 0;
      repaint;
      end;
      repaint;
      move_ch(lastpiecepos);                                                    //Закрашиваем поле откуда сходили
      move_ch(piecepos);                                                        //Закрашиваем поле куда сходили
      end;
      if new then Label2.Caption := 'Первый ход';                               //Если выбрана фигура того же цвета, что до этого, то это считается новым ходом
      if new then begin
      repaint;                                                                  //Перерисовываем доску
      GenMoves(chosen,piecepos);                                                //Пересчитываем новые доступные ходы

      if PiecesBoard[piecepos].Col = 'White' then
      whpsemv(chosen,piecepos);
      if PiecesBoard[piecepos].Col = 'Black' then
      blpsemv(chosen,piecepos);

      posmove;
      move_ch(piecepos);
      end;
      if not new then begin                                                     //Проверяем, была ли взята фигура того же цвета
      if (piecepos = lastpassant) and (chosen = 'WP.png') then  begin
      PiecesBoard[lastpassant+8].FirstMove := False;
      PiecesBoard[lastpassant+8].Picture := nil;
      PiecesBoard[lastpassant+8].FileName := '';                                //Взятие белых на проходе
      PiecesBoard[lastpassant+8].Col := '';
      Piecesboard[lastpassant+8].FirstMove := False;
      enpass := true;
      end
      else
      if (piecepos = lastpassant) and (chosen = 'BP.png') then  begin
      PiecesBoard[lastpassant-8].FirstMove := False;
      PiecesBoard[lastpassant-8].Picture := nil;
      PiecesBoard[lastpassant-8].FileName := '';                                //Взятие черных на проходе
      PiecesBoard[lastpassant-8].Col := '';
      Piecesboard[lastpassant-8].FirstMove := False;
      enpass := true;
      end;
      PiecesBoard[lastpiecepos].Picture := nil;                                 //Удаляем фигуру из клетки, из которого сходили
      PiecesBoard[lastpiecepos].FileName := '';                                 //Очищаем имя клетки из которой сходили
      PiecesBoard[lastpiecepos].Col := '';                                      //Очищаем цвет клетки из которой сходили
      Piecesboard[lastpiecepos].FirstMove := False;                             //Заносим в прошлую клетку, что из нее уже ходили
      chosen := '';                                                             //Устанавливаем, что фигура больше не выбрана
      end;

    end
    else
    begin
      lastpiecepos := TImgAndName(Sender).Pos;                                  //Запоминаем прошлое положение фигуры
      lastcol := PiecesBoard[lastpiecepos].Col;                                 //Запоминаем прошлый цвет фигуры
      Label5.Caption := lastcol;                                                //Заносим в debug надпись прошлый цвет фигуры
      chosen := piece;                                                          //Запоминаем выбранную фигуру
      last2piecepos := lastpiecepos;
      repaint;
      GenMoves(chosen,piecepos);                                                //Проверяем доступные ходы для этой фигур

      if PiecesBoard[piecepos].Col = 'White' then
      whpsemv(chosen,piecepos);
      if PiecesBoard[piecepos].Col = 'Black' then
      blpsemv(chosen,piecepos);
      posmove;                                                                  //Закрашиваем доступные клетки для хда фигуры
      Label1.Caption := chosen + ' ' + IntToStr(piecepos);                      //Заносим в debug надпись выбранную фигуру и ее позицию
      Label3.Caption := 'Прошлая позиция: ' + IntToStr(lastpiecepos);           //Заносим в debug надпись прошлую позицию фигуры
      if chosen <> '' then                                                      //Если что-то выбрано, то
        move_ch(lastpiecepos);                                                  //Закрашиваем клетку, в которой выбрана фигура
      end;

      if (lastpiecepos <> piecepos) and (not new) then                          //Проверка на то сделал ли пользователь ход выбранной фигурой
        whosmove := not whosmove;                                               //Меняем порядок хода
    end;


var
  piece_n : string;
  col :   string;
  i, j: integer;
  mv_num : integer;
begin
  mv_num := 0;
  complete := false;
  castle := false;
  if chosen = '' then
  piece_n := TImgAndName(Sender).FileName
  else
    piece_n := chosen;
  col := TImgAndName(Sender).Col;

  Label6.Caption := 'Выбрана - ' + piece_n +  '   ' + 'Цвет - ' + col + 'Позиция - ' + IntToStr(TImgAndName(Sender).Pos);
  Memo1.Clear;
  for i := 0 to 63 do begin
   if ((possmoves[i] = 1) or (possmoves[i] = 2)) and (TImgAndName(Sender).Pos = i)
   then  Memo1.Text := Memo1.Text + IntToStr(i);
  end;

  if ((whosmove) and (Label2.Caption = 'Второй ход')) and (col = 'White') then
  begin
    if Label2.Caption = 'Второй ход' then
      repaint;
    move1(piece_n, False);
  end
  else
  if ((whosmove) and (Label2.Caption = 'Первый ход')) and
    ((col = 'Black') or (col = '')) then
  begin   //Проверка очереди хода //Первый ход белых
    try if TImgAndName(Sender).Pos = StrToInt(Memo1.Text) then begin
    if Label2.Caption = 'Второй ход' then
      repaint;
    move1(piece_n,False);
    if (piece_n = 'WP.png') and (TImgAndName(Sender).Pos <= 7) and (TImgAndName(Sender).Pos >= 0)
    then begin PiecesBoard[TImgAndName(Sender).Pos].FileName := 'WQ.png';
    PiecesBoard[TImgAndName(Sender).Pos].Picture.LoadFromFile('WQ.png'); end;
    end; except exit; end;
    GenMoves('BK.png', blackkingposition);
    blpsemv('BK.png', blackkingposition);
    bkcheck := false;
    mv_num := 0;
    for i := 0 to 63 do begin
    if possmoves[i] <> 0 then
    inc(mv_num);
    possmoves[i] := 0;
    end;

    if (mv_num = 0) then begin
    for j := 0 to 63 do begin
      case PiecesBoard[j].FileName of
      'BK.png', 'BKN.png', 'BBB.png','BBW.png' , 'BP.png', 'BR.png', 'BQ.png' : begin
       GenMoves(PiecesBoard[j].FileName, j);
       blpsemv(PiecesBoard[j].FileName, j);

       for i := 0 to 63 do begin
       if possmoves[i] <> 0 then inc(mv_num);
       possmoves[i] := 0;
       end;
      end;
     end;
    end;

    for j := 0 to 63 do begin
      case PiecesBoard[j].FileName of
      'WK.png', 'WKN.png', 'WBB.png','WBW.png' , 'WP.png', 'WR.png', 'WQ.png' : GenMoves(PiecesBoard[j].FileName, j);
      end;
    end;

    for j := 0 to 63 do begin
     if (possmoves[j] = 2) and (j = blackkingposition)
     then bkcheck := true;
     possmoves[j] := 0;
    end;

    if (mv_num = 0) and bkcheck then begin
    sndPlaySound('sounds\check.wav',SND_ASYNC);
    EndImg.Picture.LoadFromFile('WhiteWin.png');
    EndImg.BringToFront;
    if bot_black then
    WhitePoint.Caption := IntToStr(StrToInt(WhitePoint.Caption) + 1)
    else
    BlackPoint.Caption := IntToStr(StrToInt(BlackPoint.Caption) + 1);
    refresh;
    Sleep(5000);
    repaint;
    for i := 0 to 63 do begin
        PiecesBoard[i].Picture := nil;
        PiecesBoard[i].FileName := '';
        PiecesBoard[i].FirstMove := false;
        PiecesBoard[i].EnPassant := false;
        PiecesBoard[i].Col := '';
    end;
    bot_black := not bot_black;
    FormCreate(Self);
    FormPaint(Self);
    EndImg.SendToBack;
    whosmove := true;
    bot_move;
    exit;
    end
    else
      if mv_num = 0 then begin
      EndImg.Picture.LoadFromFile('stalemate.png');
      EndImg.BringToFront;
      StalePoint.Caption := IntToStr(StrToInt(StalePoint.Caption) + 1);
      Refresh;
      Sleep(5000);
      repaint;
      for i := 0 to 63 do begin
        PiecesBoard[i].Picture := nil;
        PiecesBoard[i].FileName := '';
        PiecesBoard[i].FirstMove := false;
        PiecesBoard[i].EnPassant := false;
        PiecesBoard[i].Col := '';
      end;
      bot_black := not bot_black;
      FormCreate(Self);
      FormPaint(Self);
      EndImg.SendToBack;
      whosmove := true;
      bot_move;
      exit;
      end;
    end;
     for j := 0 to 63 do begin
      case PiecesBoard[j].FileName of
      'WK.png', 'WKN.png', 'WBB.png','WBW.png' , 'WP.png', 'WR.png', 'WQ.png' : GenMoves(PiecesBoard[j].FileName, j);
      end;
    end;

    for j := 0 to 63 do begin
     if (possmoves[j] = 2) and (j = blackkingposition)
     then bkcheck := true;
     possmoves[j] := 0;
    end;

     refresh;

  if bkcheck then
    sndPlaySound('sounds\check.wav',SND_ASYNC)
    else if castle then sndPlaySound('sounds\castle.wav',SND_ASYNC)
    else if (last2col = 'Black') or enpass  then sndPlaySound('sounds\capture.wav',SND_ASYNC)
    else sndPlaySound('sounds\move.wav',SND_ASYNC);

    if bot_black then begin
    refresh;
    sleep(200);
    bot_move;
    end;
  end
  else


  if ((not whosmove) and (Label2.Caption = 'Второй ход')) and
    (col = 'Black') then
  begin

    if Label2.Caption = 'Второй ход' then
      repaint;
    move1(piece_n, False);
  end
  else
  if ((not whosmove) and (Label2.Caption = 'Первый ход')) and
    ((col = 'White') or (col = '')) then
  begin                 //Проверка очереди хода //Первый ход черных
    try if TImgAndName(Sender).Pos = StrToInt(Memo1.Text) then begin
    if Label2.Caption = 'Второй ход' then
      repaint;
    move1(piece_n,False);
    if (piece_n = 'BP.png') and (TImgAndName(Sender).Pos <= 63) and (TImgAndName(Sender).Pos >= 56)
    then begin PiecesBoard[TImgAndName(Sender).Pos].FileName := 'BQ.png';
    PiecesBoard[TImgAndName(Sender).Pos].Picture.LoadFromFile('BQ.png'); end;
    end; except exit; end;

    GenMoves('WK.png', whitekingposition);
    whpsemv('WK.png', whitekingposition);
    wkcheck := false;
    mv_num := 0;

    for i := 0 to 63 do begin
    if possmoves[i] <> 0 then
    inc(mv_num);
    possmoves[i] := 0;
    end;
    if (mv_num = 0) then begin

    for j := 0 to 63 do begin
      case PiecesBoard[j].FileName of
      'WK.png', 'WKN.png', 'WBB.png','WBW.png' , 'WP.png', 'WR.png', 'WQ.png' : begin
       GenMoves(PiecesBoard[j].FileName, j);
       whpsemv(PiecesBoard[j].FileName, j);

       for i := 0 to 63 do begin
       if possmoves[i] <> 0 then inc(mv_num);
       possmoves[i] := 0;
       end;

      end;
     end;
    end;

    for j := 0 to 63 do begin
      case PiecesBoard[j].FileName of
      'BK.png', 'BKN.png', 'BBB.png','BBW.png' , 'BP.png', 'BR.png', 'BQ.png' : GenMoves(PiecesBoard[j].FileName, j);
      end;
    end;

    for j := 0 to 63 do begin
     if (possmoves[j] = 2) and (j = whitekingposition)
     then wkcheck := true;
     possmoves[j] := 0;
    end;

    if (mv_num = 0) and wkcheck then begin
    sndPlaySound('sounds\check.wav',SND_ASYNC);
    EndImg.Picture.LoadFromFile('BlackWin.png');
    EndImg.BringToFront;
    if bot_black then
    BlackPoint.Caption := IntToStr(StrToInt(BlackPoint.Caption) + 1)
    else
    WhitePoint.Caption := IntToStr(StrToInt(WhitePoint.Caption) + 1);
    Refresh;
    Sleep(5000);
    repaint;
    for i := 0 to 63 do begin
        PiecesBoard[i].Picture := nil;
        PiecesBoard[i].FileName := '';
        PiecesBoard[i].FirstMove := false;
        PiecesBoard[i].EnPassant := false;
        PiecesBoard[i].Col := '';
    end;
    bot_black := not bot_black;
    FormCreate(Self);
    FormPaint(Self);
    EndImg.SendToBack;
    whosmove := true;
    bot_move;
    exit;
    end
    else
      if mv_num = 0 then begin
      EndImg.Picture.LoadFromFile('stalemate.png');
      EndImg.BringToFront;
      StalePoint.Caption := IntToStr(StrToInt(StalePoint.Caption) + 1);
      refresh;
      Sleep(5000);
      repaint;
      for i := 0 to 63 do begin
          PiecesBoard[i].Picture := nil;
          PiecesBoard[i].FileName := '';
          PiecesBoard[i].FirstMove := false;
          PiecesBoard[i].EnPassant := false;
          PiecesBoard[i].Col := '';
      end;
      bot_black := not bot_black;
      FormCreate(Self);
      FormPaint(Self);
      EndImg.SendToBack;
      whosmove := true;
      bot_move;
      exit;
      end;

    end;




    for j := 0 to 63 do begin
      case PiecesBoard[j].FileName of
      'BK.png', 'BKN.png', 'BBB.png','BBW.png' , 'BP.png', 'BR.png', 'BQ.png' : GenMoves(PiecesBoard[j].FileName, j);
      end;
    end;

    for j := 0 to 63 do begin
     if (possmoves[j] = 2) and (j = whitekingposition)
     then wkcheck := true;
     possmoves[j] := 0;
    end;

    refresh;


    if wkcheck then
    sndPlaySound('sounds\check.wav',SND_ASYNC)
    else if castle then sndPlaySound('sounds\castle.wav',SND_ASYNC)
    else if (last2col = 'White') or enpass then sndPlaySound('sounds\capture.wav',SND_ASYNC)
    else sndPlaySound('sounds\move.wav',SND_ASYNC);

    if not bot_black then begin
    refresh;
    sleep(200);
    bot_move;
    end;
  end
  else
  if ((whosmove) and (Label2.Caption = 'Первый ход')) and (col = 'White') then
  begin
    repaint;
    move1(piece_n, True);
  end
  else
  if ((not whosmove) and (Label2.Caption = 'Первый ход')) and
    (col = 'Black') then
  begin
    repaint;
    move1(piece_n, True);
  end;
  if whosmove then
  begin
    Label4.Caption := ' Ход белых ';
  end;
  if not whosmove then
  begin
    Label4.Caption := ' Ход черных';
  end;
end;

procedure TBox.WRClick(Sender: TObject);
begin
  newname := 'WR.png';
  complete := true;
end;




end.
