unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel10: TPanel;
    Panel20: TPanel;
    Panel30: TPanel;
    Panel40: TPanel;
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1Paint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  misc;

procedure TForm1.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//
end;

procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if ssLeft in Shift then
  begin
//    TPanel(Sender).Left:=TPanel(Sender).Left+x-TPanel(Sender).Width div 2;
    TPanel(Sender).Top:=TPanel(Sender).Top+y-TPanel(Sender).Height div 2;
    Paintbox1.Invalidate;
  end;
end;

procedure TForm1.Panel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
var i,j: integer;
    a: TarrayofTSinglePoint;
begin
  with Paintbox1,Canvas do
  begin
    a:=InterpolatePoints([
      SinglePoint(Panel1.Left+Panel1.Width div 2,Panel1.Top+Panel1.Width div 2),
      SinglePoint(Panel2.Left+Panel2.Width div 2,Panel2.Top+Panel2.Width div 2),
      SinglePoint(Panel3.Left+Panel3.Width div 2,Panel3.Top+Panel3.Width div 2),
      SinglePoint(Panel4.Left+Panel4.Width div 2,Panel4.Top+Panel4.Width div 2)],10);
    moveto(round(a[0].x),round(a[0].y));
    for i:=0 to high(a) do
      lineto(round(a[i].x),round(a[i].y));

    a:=InterpolatePoints([
      SinglePoint(Panel10.Left+Panel10.Width div 2,Panel10.Top+Panel10.Width div 2),
      SinglePoint(Panel20.Left+Panel20.Width div 2,Panel20.Top+Panel20.Width div 2),
      SinglePoint(Panel30.Left+Panel30.Width div 2,Panel30.Top+Panel30.Width div 2),
      SinglePoint(Panel40.Left+Panel40.Width div 2,Panel40.Top+Panel40.Width div 2)],10);
    moveto(round(a[0].x),round(a[0].y));
    for i:=0 to high(a) do
      lineto(round(a[i].x),round(a[i].y));
  end;
end;

end.
function InterpolatePoints(Points: array of TSinglePoint; N: integer): TarrayofTSinglePoint;

object Panel100: TPanel 0
  Left = 136
  Top = 136
  Width = 17
  Height = 17
  BevelOuter = bvNone
  BorderStyle = bsSingle
  Caption = ' '
  Ctl3D = False
  ParentCtl3D = False
  TabOrder = 0
  OnMouseDown = Panel10MouseDown
  OnMouseMove = Panel10MouseMove
  OnMouseUp = Panel10MouseUp
end
object Panel200: TPanel 0
  Left = 236
  Top = 104
  Width = 17
  Height = 17
  BevelOuter = bvNone
  BorderStyle = bsSingle
  Caption = ' '
  Ctl3D = False
  ParentCtl3D = False
  TabOrder = 1
  OnMouseDown = Panel10MouseDown
  OnMouseMove = Panel10MouseMove
  OnMouseUp = Panel10MouseUp
end
object Panel300: TPanel 0
  Left = 336
  Top = 112
  Width = 17
  Height = 17
  BevelOuter = bvNone
  BorderStyle = bsSingle
  Caption = ' '
  Ctl3D = False
  ParentCtl3D = False
  TabOrder = 2
  OnMouseDown = Panel1MouseDown
  OnMouseMove = Panel1MouseMove
  OnMouseUp = Panel1MouseUp
end
object Panel40: TPanel
  Left = 436
  Top = 176
  Width = 17
  Height = 17
  BevelOuter = bvNone
  BorderStyle = bsSingle
  Caption = ' '
  Ctl3D = False
  ParentCtl3D = False
  TabOrder = 3
  OnMouseDown = Panel1MouseDown
  OnMouseMove = Panel1MouseMove
  OnMouseUp = Panel1MouseUp
end

