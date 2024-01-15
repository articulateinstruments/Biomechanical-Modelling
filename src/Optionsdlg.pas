unit Optionsdlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Spin, Dialogs, ComCtrls, FSpin;

type
  Tcbf = (cbfStrutElastic,cbfMuscle,cbfPressure);
  
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
    TabSheet4: TTabSheet;
    GroupBox9: TGroupBox;
    Label2: TLabel;
    Label5: TLabel;
    GroupBox11: TGroupBox;
    Label22: TLabel;
    seVudist: TSpinEdit;
    rbPerspective: TRadioButton;
    rbIsometric: TRadioButton;
    TabSheet5: TTabSheet;
    Label4: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    rbMuscleInterpolate: TRadioGroup;
    fseNormalAnimPeriod: TFSpinEdit;
    Label6: TLabel;
    seCalculateFPS: TSpinEdit;
    Label20: TLabel;
    GroupBox10: TGroupBox;
    Label21: TLabel;
    sePlaybackFPS: TSpinEdit;
    Label23: TLabel;
    TabSheet6: TTabSheet;
    GroupBox12: TGroupBox;
    GroupBox13: TGroupBox;
    cbDisplayForces: TCheckBox;
    cbDisplayPressure: TCheckBox;
    pnlColorForces: TPanel;
    Label24: TLabel;
    pnlColorPressureHigh: TPanel;
    Label25: TLabel;
    Label26: TLabel;
    pnlColorPressureLow: TPanel;
    seForcesScale: TSpinEdit;
    Label27: TLabel;
    Label28: TLabel;
    sePressureMax: TSpinEdit;
    cbForceKind: TComboBox;
    Label29: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OKBtnClick(Sender: TObject);
    procedure pnlColorDefaultMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure rbSolveClick(Sender: TObject);
    procedure seGasConstChange(Sender: TObject);
    procedure seClipForceChange(Sender: TObject);
    procedure cbForceKindChange(Sender: TObject);
  private
    { Private declarations }
    procedure LoadSaveIniFile(Load: Boolean);
  public
    { Public declarations }
  end;

var
  dlgOptions: TdlgOptions;
  GasConst,GasConstArea,ClipGas: single;
  cbf: Tcbf;

const Vudist: integer = 700;

implementation

{$R *.DFM}

uses
  misc,
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
  fseNormalAnimPeriod.value:=LoadSaveMyIniFileDouble(Load,'Options','fseNormalAnimPeriod.value',fseNormalAnimPeriod.value,fseNormalAnimPeriod.value);
  sePlaybackFPS.value:=LoadSaveMyIniFileInt(Load,'Options','sePlaybackFPS.value',sePlaybackFPS.value,sePlaybackFPS.value);
  seCalculateFPS.value:=LoadSaveMyIniFileInt(Load,'Options','seCalculateFPS.value',seCalculateFPS.value,seCalculateFPS.value);
  seVudist.value:=LoadSaveMyIniFileInt(Load,'Options','seVudist.value',seVudist.value,seVudist.value);
  Vudist:=LoadSaveMyIniFileInt(Load,'Options','Vudist',Vudist,Vudist);
  rbPerspective.Checked:=LoadSaveMyIniFileBool(Load,'Options','rbPerspective.Checked',rbPerspective.Checked,rbPerspective.Checked);
  rbIsometric.Checked:=LoadSaveMyIniFileBool(Load,'Options','rbIsometric.Checked',rbIsometric.Checked,rbIsometric.Checked);
  rbMuscleInterpolate.ItemIndex:=LoadSaveMyIniFileInt(Load,'Options','rbMuscleInterpolate.ItemIndex',rbMuscleInterpolate.ItemIndex,rbMuscleInterpolate.ItemIndex);

  cbDisplayForces.Checked:=LoadSaveMyIniFileBool(Load,'Options','cbDisplayForces.Checked',cbDisplayForces.Checked,cbDisplayForces.Checked);
  pnlColorForces.Color:=LoadSaveMyIniFileInt(Load,'Options','pnlColorForces.Color',pnlColorForces.Color,pnlColorForces.Color);
  seForcesScale.Value:=LoadSaveMyIniFileInt(Load,'Options','seForcesScale.Value',seForcesScale.Value,seForcesScale.Value);
  cbDisplayPressure.Checked:=LoadSaveMyIniFileBool(Load,'Options','cbDisplayPressure.Checked',cbDisplayPressure.Checked,cbDisplayPressure.Checked);
  pnlColorPressureHigh.Color:=LoadSaveMyIniFileInt(Load,'Options','pnlColorPressureHigh.Color',pnlColorPressureHigh.Color,pnlColorPressureHigh.Color);
  pnlColorPressureLow.Color:=LoadSaveMyIniFileInt(Load,'Options','pnlColorPressureLow.Color',pnlColorPressureLow.Color,pnlColorPressureLow.Color);
  sePressureMax.Value:=LoadSaveMyIniFileInt(Load,'Options','sePressureMax.Value',sePressureMax.Value,sePressureMax.Value);
  cbForceKind.ItemIndex:=IntRange(LoadSaveMyIniFileInt(Load,'Options','cbForceKind.ItemIndex',cbForceKind.ItemIndex,cbForceKind.ItemIndex),0,cbForceKind.Items.Count-1);
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

procedure TdlgOptions.seGasConstChange(Sender: TObject);
begin
  GasConst:=seGasConst.Value;
end;

procedure TdlgOptions.seClipForceChange(Sender: TObject);
begin
  ClipGas:=seClipForce.Value;
end;

procedure TdlgOptions.cbForceKindChange(Sender: TObject);
begin
  cbf:=Tcbf(cbForceKind.ItemIndex);
end;

end.




