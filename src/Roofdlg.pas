unit Roofdlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, Spin;

type
  TdlgRoof = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    seMeshsize: TSpinEdit;
    Label3: TLabel;
    seHeight: TSpinEdit;
    pnlPoints: TPanel;
    SpinButton1: TSpinButton;
    pnlColor: TPanel;
    Label4: TLabel;
    ColorDialog1: TColorDialog;
    cbRoofConstraint: TCheckBox;
    Label5: TLabel;
    procedure pnlColorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpinButton1DownClick(Sender: TObject);
    procedure SpinButton1UpClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgRoof: TdlgRoof;

implementation

{$R *.DFM}

uses
  misc;

procedure TdlgRoof.pnlColorMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ColorDialog1.Color:=TPanel(Sender).Color;
  if ColorDialog1.Execute then
    TPanel(Sender).Color:=ColorDialog1.Color;
end;

procedure TdlgRoof.SpinButton1DownClick(Sender: TObject);
begin
  pnlPoints.Tag:=IntRange(pnlPoints.Tag-1,1,20);
  FormShow(Sender);
//  Label3.Enabled:=true;
//  seHeight.Visible:=true;
end;

procedure TdlgRoof.SpinButton1UpClick(Sender: TObject);
begin
  pnlPoints.Tag:=IntRange(pnlPoints.Tag+1,1,20);
  FormShow(Sender);
//  Label3.Enabled:=true;
//  seHeight.Visible:=true;
end;

procedure TdlgRoof.FormShow(Sender: TObject);
begin
  pnlPoints.Caption:=' '+inttostr(pnlPoints.Tag*2+1)+' x '+inttostr(pnlPoints.Tag*2+1);
//  Label3.Enabled:=False;
//  seHeight.Visible:=False;
end;

end.
