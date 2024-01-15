unit BGShiftDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, FSpin;

type
  TdlgBGShift = class(TForm)
    fsSize: TFSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    fsHShift: TFSpinEdit;
    Label4: TLabel;
    Label5: TLabel;
    fsVShift: TFSpinEdit;
    Label6: TLabel;
    procedure fsSizeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure LoadSaveIniFile(Load: Boolean);
  public
    { Public declarations }
    procedure StringToBGShift(s: string);
    function BGShiftToString: string;
  end;

var
  dlgBGShift: TdlgBGShift;

implementation

uses Unit1, misc, iniio;

{$R *.DFM}

procedure TdlgBGShift.fsSizeClick(Sender: TObject);
begin
  Form1.pbYZ.Invalidate;
  Form1.pbXY.Invalidate;
  Form1.pbXZ.Invalidate;
  LoadSaveIniFile(false);
end;

procedure TdlgBGShift.LoadSaveIniFile(Load: Boolean);
begin
//  fsSize.Value:=LoadSaveMyIniFileDouble(Load,'dlgBGShift','fsSize.Value',fsSize.Value,fsSize.Value);
//  fsHShift.Value:=LoadSaveMyIniFileDouble(Load,'dlgBGShift','fsHShift.Value',fsHShift.Value,fsHShift.Value);
//  fsVShift.Value:=LoadSaveMyIniFileDouble(Load,'dlgBGShift','fsVShift.Value',fsVShift.Value,fsVShift.Value);
end;

procedure TdlgBGShift.FormCreate(Sender: TObject);
begin
  LoadSaveIniFile(true);
end;

function TdlgBGShift.BGShiftToString: string;
begin
  result:='B:'+
    FixedPointStr(fsSize.Value,4)+','+
    FixedPointStr(fsHShift.Value,4)+','+
    FixedPointStr(fsVShift.Value,4)+#13#10;
end;

procedure TdlgBGShift.StringToBGShift(s: string);
begin
  Mustbe(s,'B');
  Mustbe(s,':');
  fsSize.Value  :=MustbeSignedDouble(s);        Mustbe(s,',');
  fsHShift.Value:=MustbeSignedDouble(s);        Mustbe(s,',');
  fsVShift.Value:=MustbeSignedDouble(s);
end;

end.


