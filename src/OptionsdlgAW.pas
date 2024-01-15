unit Optionsdlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Spin, Dialogs, ComCtrls;

type
  TdlgOptions = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    ColorDialog1: TColorDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox4: TGroupBox;
    Label3: TLabel;
    seStrutDamping: TSpinEdit;
    GroupBox6: TGroupBox;
    cbDependsonlength: TCheckBox;
    GroupBox7: TGroupBox;
    Label19: TLabel;
    Label18: TLabel;
    seStrutElasticityR: TSpinEdit;
    seStrutElasticityC: TSpinEdit;
    GroupBox3: TGroupBox;
    Label16: TLabel;
    Label17: TLabel;
    seClipForce: TSpinEdit;
    seGasConst: TSpinEdit;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    seGasConstArea: TSpinEdit;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    pnlColorDefault: TPanel;
    pnlColorSelect: TPanel;
    pnlColorUnselect: TPanel;
    pnlColorMuscle: TPanel;
    pnlColorSelMuscle: TPanel;
    GroupBox2: TGroupBox;
    rbIntegrate: TRadioButton;
    rbSolve: TRadioButton;
    seSolve: TSpinEdit;
    Label7: TLabel;
    seIntegrate: TSpinEdit;
    GroupBox8: TGroupBox;
    cbWarnDuplicateStruts: TCheckBox;
    cbSnap: TCheckBox;
    Label4: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    TabSheet4: TTabSheet;
    GroupBox9: TGroupBox;
    seNormalAnimPeriod: TSpinEdit;
    Label2: TLabel;
    Label5: TLabel;
    GroupBox10: TGroupBox;
    Label6: TLabel;
    Label20: TLabel;
    seMovieAnimPeriod: TSpinEdit;
    Label21: TLabel;
    seMovieFrames: TSpinEdit;
    GroupBox11: TGroupBox;
    Label22: TLabel;
    seVudist: TSpinEdit;
    rbPerspective: TRadioButton;
    rbIsometric: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OKBtnClick(Sender: TObject);
    procedure pnlColorDefaultMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure rbSolveClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadSaveIniFile(Load: Boolean);
  public
    { Public declarations }
  end;

var
  dlgOptions: TdlgOptions;

const Vudist: integer = 700;

implementation

{$R *.DFM}

uses
  IniIO;

procedure TdlgOptions.FormCreate(Sender: TObject);
begin
  LoadSaveIniFile(true);
end;

procedure TdlgOptions.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LoadSaveIniFile(true);
end;

procedure TdlgOptions.OKBtnClick(Sender: TObject);
begin
  if rbPerspective.Checked then
    Vudist:=seVudist.value else
    Vudist:=0;
  LoadSaveIniFile(false);
end;

procedure TdlgOptions.LoadSaveIniFile(Load: Boolean);
begin
  cbSnap.Checked:=LoadSaveMyIniFileBool(Load,'Options','cbSnap.Checked',cbSnap.Checked,cbSnap.Checked);
  cbWarnDuplicateStruts.Checked:=LoadSaveMyIniFileBool(Load,'Options','cbWarnDuplicateStruts.Checked',cbWarnDuplicateStruts.Checked,cbWarnDuplicateStruts.Checked);
  rbIntegrate.Checked:=LoadSaveMyIniFileBool(Load,'Options','rbIntegrate.Checked',rbIntegrate.Checked,rbIntegrate.Checked);
  rbSolve.Checked:=LoadSaveMyIniFileBool(Load,'Options','rbSolve.Checked',rbSolve.Checked,rbSolve.Checked);
  seStrutElasticityR.value:=LoadSaveMyIniFileInt(Load,'Options','seStrutElasticityR.value',seStrutElasticityR.value,seStrutElasticityR.value);
  seStrutElasticityC.value:=LoadSaveMyIniFileInt(Load,'Options','seStrutElasticityC.value',seStrutElasticityC.value,seStrutElasticityC.value);
  seStrutDamping.value:=LoadSaveMyIniFileInt(Load,'Options','seStrutDamping.value',seStrutDamping.value,seStrutDamping.value);
  seGasConst.value:=LoadSaveMyIniFileInt(Load,'Options','seGasConst.value',seGasConst.value,seGasConst.value);
  seGasConstArea.value:=LoadSaveMyIniFileInt(Load,'Options','seGasConstArea.value',seGasConstArea.value,seGasConstArea.value);
  seClipForce.value:=LoadSaveMyIniFileInt(Load,'Options','seClipForce.value',seClipForce.value,seClipForce.value);
  pnlColorSelect.Color:=LoadSaveMyIniFileInt(Load,'Options','pnlColorSelect.Color',pnlColorSelect.Color,pnlColorSelect.Color);
  pnlColorUnselect.Color:=LoadSaveMyIniFileInt(Load,'Options','pnlColorUnselect.Color',pnlColorUnselect.Color,pnlColorUnselect.Color);
  pnlColorDefault.Color:=LoadSaveMyIniFileInt(Load,'Options','pnlColorDefault.Color',pnlColorDefault.Color,pnlColorDefault.Color);
  pnlColorMuscle.Color:=LoadSaveMyIniFileInt(Load,'Options','pnlColorMuscle.Color',pnlColorMuscle.Color,pnlColorMuscle.Color);
  pnlColorSelMuscle.Color:=LoadSaveMyIniFileInt(Load,'Options','pnlColorSelMuscle.Color',pnlColorSelMuscle.Color,pnlColorSelMuscle.Color);
  seSolve.value:=LoadSaveMyIniFileInt(Load,'Options','seSolve.value',seSolve.value,seSolve.value);
  seIntegrate.value:=LoadSaveMyIniFileInt(Load,'Options','seIntegrate.value',seIntegrate.value,seIntegrate.value);
  seNormalAnimPeriod.value:=LoadSaveMyIniFileInt(Load,'Options','seNormalAnimPeriod.value',seNormalAnimPeriod.value,seNormalAnimPeriod.value);
  seMovieAnimPeriod.value:=LoadSaveMyIniFileInt(Load,'Options','seMovieAnimPeriod.value',seMovieAnimPeriod.value,seMovieAnimPeriod.value);
  seMovieFrames.value:=LoadSaveMyIniFileInt(Load,'Options','seMovieFrames.value',seMovieFrames.value,seMovieFrames.value);
  seVudist.value:=LoadSaveMyIniFileInt(Load,'Options','seVudist.value',seVudist.value,seVudist.value);
  Vudist:=LoadSaveMyIniFileInt(Load,'Options','Vudist',Vudist,Vudist);
  rbPerspective.Checked:=LoadSaveMyIniFileBool(Load,'Options','rbPerspective.Checked',rbPerspective.Checked,rbPerspective.Checked);
  rbIsometric.Checked:=LoadSaveMyIniFileBool(Load,'Options','rbIsometric.Checked',rbIsometric.Checked,rbIsometric.Checked);
end;

procedure TdlgOptions.pnlColorDefaultMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ColorDialog1.Color:=TPanel(Sender).Color;
  if ColorDialog1.Execute then
    TPanel(Sender).Color:=ColorDialog1.Color;
end;

procedure TdlgOptions.FormShow(Sender: TObject);
begin
  rbSolveClick(Sender);
  if rbPerspective.Checked then
    seVudist.value:=Vudist;
end;

procedure TdlgOptions.rbSolveClick(Sender: TObject);
begin
  seIntegrate.Visible:=rbIntegrate.Checked;
  seSolve.Visible:=rbSolve.Checked;
end;

end.

