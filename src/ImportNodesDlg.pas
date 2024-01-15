unit ImportNodesDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Dialogs, Spin;

type
  TdlgImportNodes = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    OpenDialog4: TOpenDialog;
    cbMakePolygons: TCheckBox;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    cbMakePolyhedra: TCheckBox;
    cbReadMuscles: TCheckBox;
    cbMergeLeftRightMuscles: TCheckBox;
    Button2: TButton;
    Edit2: TEdit;
    Label3: TLabel;
    OpenDialog1: TOpenDialog;
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgImportNodes: TdlgImportNodes;

implementation

{$R *.DFM}

procedure TdlgImportNodes.Edit1Change(Sender: TObject);
begin
  OKBtn.Enabled:=FileExists(Edit1.Text);
end;

procedure TdlgImportNodes.FormCreate(Sender: TObject);
begin
  OpenDialog4.InitialDir:=ExtractFilePath(ParamStr(0));
  OpenDialog1.InitialDir:=OpenDialog1.InitialDir;
end;

procedure TdlgImportNodes.Button1Click(Sender: TObject);
begin
  if OpenDialog4.Execute then
    Edit1.Text:=OpenDialog4.Filename;
end;

procedure TdlgImportNodes.Button2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Edit2.Text:=OpenDialog4.Filename;
end;

end.


