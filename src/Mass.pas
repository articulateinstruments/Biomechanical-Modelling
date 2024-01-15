unit Mass;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Spin, FSpin;

type
  TdlgMass = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    seMass: TFSpinEdit;
    CheckBox1: TCheckBox;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgMass: TdlgMass;

implementation

{$R *.DFM}

procedure TdlgMass.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = char(vk_return) then
  begin
    key:=#0;
    OKBtn.Click;
  end;
end;

end.


