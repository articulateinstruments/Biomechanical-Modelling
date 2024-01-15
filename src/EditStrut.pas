unit EditStrut;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Spin, ComCtrls, FSpin, Dialogs;

type
  TsrcController = (srcFixedlength,srcMuscleControllerS,srcMuscle,srcMusclePhaseController,srcTorque,
    srcTorqueController,srcSonar,srcSpinneret);

  TdlgEditStrut = class(TForm)
    Button3: TButton;
    CancelBtn: TButton;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    sePenWidth: TSpinEdit;
    Label2: TLabel;
    Panel1: TPanel;
    Label3: TLabel;
    ColorDialog1: TColorDialog;
    Button1: TButton;
    GroupBox5: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    fsElasticityR: TSpinEdit;
    fsElasticityC: TSpinEdit;
    ComboBox1: TComboBox;
    Label4: TLabel;
    ceName: TCheckBox;
    Label5: TLabel;
    cePen: TCheckBox;
    ceColor: TCheckBox;
    ceAxis: TCheckBox;
    ceRelaxed: TCheckBox;
    ceContracted: TCheckBox;
    Label6: TLabel;
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure sePenWidthChange(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure fsElasticityRChange(Sender: TObject);
    procedure fsElasticityCChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgEditStrut: TdlgEditStrut;

implementation

{$R *.DFM}

uses
  misc,
  IniIO,
  Optionsdlg, Unit1;


procedure TdlgEditStrut.Panel1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ColorDialog1.Color:=Panel1.Color;
  if ColorDialog1.Execute then
    Panel1.Color:=ColorDialog1.Color;
end;

procedure TdlgEditStrut.Button1Click(Sender: TObject);
begin
  ceColor.Checked:=true;
  Panel1.Color:=clBtnFace;
end;

procedure TdlgEditStrut.Edit1Change(Sender: TObject);
begin
  ceName.Checked:=true;
end;

procedure TdlgEditStrut.sePenWidthChange(Sender: TObject);
begin
  cePen.Checked:=true;
end;

procedure TdlgEditStrut.Panel1Click(Sender: TObject);
begin
  ceColor.Checked:=true;
end;

procedure TdlgEditStrut.ComboBox1Change(Sender: TObject);
begin
  ceAxis.Checked:=true;
end;

procedure TdlgEditStrut.fsElasticityRChange(Sender: TObject);
begin
  ceRelaxed.Checked:=true;
end;

procedure TdlgEditStrut.fsElasticityCChange(Sender: TObject);
begin
  ceContracted.Checked:=true;
end;

end.
=============================================

object pnlChangeAxis: TPanel
  Left = 2
  Top = 96
  Width = 157
  Height = 23
  Align = alBottom
  Caption = 'Change Axis'
  TabOrder = 5
end


