unit MovieDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TdlgMovie = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Panel5: TPanel;
    PaintBox1: TPaintBox;
    Image1: TImage;
    Panel3: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Panel4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
  private
    { Private declarations }
    fFirst: integer;
    fLength: integer;
    procedure SetFirst(Value: integer);
    procedure SetLength(Value: integer);
    procedure ShowBmp(i: integer);
    procedure ShowRange;
    property First: integer read fFirst write SetFirst;
    property Length: integer read fLength write SetLength;
  public
    { Public declarations }
    MovieBMPs: TStringList;
  end;

var
  dlgMovie: TdlgMovie;

implementation

{$R *.DFM}

uses
  misc, EMAdlg;

procedure TdlgMovie.FormCreate(Sender: TObject);
begin
  MovieBMPs:=TStringList.Create;
  first:=0;
  Length:=1;
end;

procedure TdlgMovie.FormShow(Sender: TObject);
begin
  first:=0;
  Length:=dlgMovie.MovieBMPs.Count;
  ShowBmp(First);
end;

procedure TdlgMovie.ShowRange;
begin
  dlgMovie.Panel2.Caption:='Convert BMP pictures ('+
    ExtractFileName(MovieBMPs[IntRange(first,0,MovieBMPs.Count-1)])+'..'+
    ExtractFileName(MovieBMPs[IntRange(first+Length-1,0,MovieBMPs.Count-1)])+') to movie?';
end;

procedure TdlgMovie.SetFirst(Value: integer);
begin
  fFirst:=value;
  if MovieBMPs.Count > 0 then
  begin
    Panel4.Left:=(Panel3.Width-2)*fFirst div MovieBMPs.Count;
    ShowRange;
  end;
end;

procedure TdlgMovie.SetLength(Value: integer);
begin
  fLength:=value;
  if MovieBMPs.Count > 0 then
  begin
    Panel4.Width:=(Panel3.Width-2)*Length div MovieBMPs.Count;
    ShowRange;
  end;
end;

procedure TdlgMovie.Panel4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Panel4MouseMove(Sender,Shift,X,Y);
end;

procedure TdlgMovie.Panel4MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
var n,f,l: integer;
begin
  if ssLeft in Shift then
  with TransformPoint(TControl(Sender),Panel3,Point(x,y)) do
  begin
    n:=round(MovieBMPs.Count*x/(Panel3.Width-2));
    if n < First+Length div 2 then
    begin
      f:=First;
      First:=IntRange(n,0,MovieBMPs.Count-1);
      Length:=IntRange(Length-First+f,1,MovieBMPs.Count-First);
      ShowBmp(First);
    end else
    begin
      Length:=IntRange(n-First,1,MovieBMPs.Count-First);
      ShowBmp(First+Length-1);
    end;
  end;
end;

procedure TdlgMovie.Button1Click(Sender: TObject);
begin
//  dlgEMA.PruneEMAs(first,length);
  while First > 0 do
  begin
    MovieBMPs.Delete(0);
    First:=First-1;
  end;
  while MovieBMPs.Count > length do
    MovieBMPs.Delete(MovieBMPs.Count-1);
end;

procedure TdlgMovie.ShowBmp(i: integer);
begin
  try
    Image1.Picture.LoadFromFile(MovieBMPs[i]);
    PaintBox1Paint(Self);
  except
  end;
end;

procedure TdlgMovie.PaintBox1Paint(Sender: TObject);
var d,x,y: single;
begin
  d:=DoubleMin([PaintBox1.Width/Image1.Width,PaintBox1.Height/Image1.Height,1]);
  x:=(PaintBox1.Width-Image1.Width*d)/2;
  y:=(PaintBox1.Height-Image1.Height*d)/2;
  PaintBox1.Canvas.StretchDraw(Rect(trunc(x),trunc(y),trunc(x+Image1.Width*d),trunc(y+Image1.Height*d)),Image1.Picture.Graphic);
end;

end.

