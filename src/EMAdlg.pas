unit EMAdlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, FSpin, Spin, Menus;

type
  TPosRec  = record x,y,z,phi,theta,rms,extra: single; end;
  Tpt = (ptnone,ptXY,ptXZ,ptYX,ptYZ,ptZX,ptZY);

  TdlgEMA = class(TForm)
    ListBox1: TListBox;
    Panel1: TPanel;
    OKBtn: TButton;
    CancelBtn: TButton;
    Button1: TButton;
    Panel3: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    seChannels: TSpinEdit;
    fseRMSvalue: TFSpinEdit;
    fseEXTRAvalue: TFSpinEdit;
    Panel4: TPanel;
    Panel5: TPanel;
    Label4: TLabel;
    Memo1: TMemo;
    Label5: TLabel;
    Edit1: TEdit;
    cbWriteasplaintext: TCheckBox;
    Label7: TLabel;
    cbtheta: TComboBox;
    PopupMenu1: TPopupMenu;
    Delete1: TMenuItem;
    CopyAll1: TMenuItem;
    Label6: TLabel;
    cbphi: TComboBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    fsex: TFSpinEdit;
    fsey: TFSpinEdit;
    fsez: TFSpinEdit;
    fsephi: TFSpinEdit;
    fsetheta: TFSpinEdit;
    Button3: TButton;
    Button4: TButton;
    Button2: TButton;
    Bevel1: TBevel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure seChannelsChange(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure CopyAll1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure fsezChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    sExportEMA: string;
    procedure LoadSaveIniFile(Load: Boolean);
    procedure AddAtom(a,a1: integer);
    procedure DeleteAtom(a: integer);
    procedure AddMuscles(NumMuscles: integer);
    procedure DeleteMuscles;
    procedure PruneEMAs(first,len: integer);
  public
    { Public declarations }
    procedure ExportEMAStart;
    procedure ExportEMAFrame;
    procedure ExportEMAFinish;
    function WriteEMA: string;
    procedure LoadEMAInit;
    procedure LoadEMA(line: string);
  end;

var
  dlgEMA: TdlgEMA;

implementation

{$R *.DFM}

uses
  Clipbrd,
  IniIO, misc, math, Unit1;

procedure TdlgEMA.Button1Click(Sender: TObject);
begin
  Listbox1.clear;
end;

procedure TdlgEMA.AddAtom(a,a1: integer);
begin
  Listbox1.items.addObject(inttostr(a),TObject(MakeLong(a,a1)));
  LoadSaveIniFile(false);
end;

procedure TdlgEMA.FormCreate(Sender: TObject);
begin
  LoadSaveIniFile(true);
end;

procedure TdlgEMA.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LoadSaveIniFile(ModalResult <> mrOK);
end;

procedure TdlgEMA.LoadSaveIniFile(Load: Boolean);
var i: integer;
begin
  seChannels.Value:=LoadSaveMyIniFileInt(Load,'dlgEMA','seChannels.Value',seChannels.Value,seChannels.Value);
  fseRMSvalue.Value:=LoadSaveMyIniFileDouble(Load,'dlgEMA','fseRMSvalue.Value',fseRMSvalue.Value,fseRMSvalue.Value);
  fseEXTRAvalue.Value:=LoadSaveMyIniFileDouble(Load,'dlgEMA','fseEXTRAvalue.Value',fseEXTRAvalue.Value,fseEXTRAvalue.Value);
  cbWriteasplaintext.Checked:=LoadSaveMyIniFileBool(Load,'dlgEMA','cbWriteasplaintext.Checked',cbWriteasplaintext.Checked,cbWriteasplaintext.Checked);
  Edit1.Text:=LoadSaveMyIniFileString(Load,'dlgEMA','Edit1.Text',Edit1.Text,Edit1.Text);
  cbtheta.ItemIndex:=LoadSaveMyIniFileInt(Load,'dlgEMA','cbtheta.ItemIndex',cbtheta.ItemIndex,cbtheta.ItemIndex);
  cbphi.ItemIndex:=LoadSaveMyIniFileInt(Load,'dlgEMA','cbphi.ItemIndex',cbphi.ItemIndex,cbphi.ItemIndex);
  cbtheta.ItemIndex:=IntRange(cbtheta.ItemIndex,0,cbtheta.Items.Count-1);
  cbphi.ItemIndex:=IntRange(cbphi.ItemIndex,0,cbphi.Items.Count-1);

{
  if load then
  begin
    Listbox1.clear;
    for i:=1 to LoadSaveMyIniFileInt(Load,'dlgEMA','ListBox1.Items.Count',ListBox1.Items.Count,ListBox1.Items.Count) do
      ListBox1.Items.Add('xxx');
  end else
    LoadSaveMyIniFileInt(Load,'dlgEMA','ListBox1.Items.Count',ListBox1.Items.Count,ListBox1.Items.Count);
  for i:=0 to ListBox1.Items.Count-1 do
  begin
    ListBox1.Items.Objects[i]:=TObject(LoadSaveMyIniFileInt(Load,'dlgEMA','ListBox1.Items['+inttostr(i)+']',integer(ListBox1.Items.Objects[i]),integer(ListBox1.Items.Objects[i])));
    ListBox1.Items[i]:=LoadSaveMyIniFileString(Load,'dlgEMA','ListBox1.Items['+inttostr(i)+'].str',ListBox1.Items[i],ListBox1.Items[i]);
  end;
}

  if load then
  begin
    Memo1.clear;
    for i:=1 to LoadSaveMyIniFileInt(Load,'dlgEMA','Memo1.Lines.Count',Memo1.Lines.Count,Memo1.Lines.Count) do
      Memo1.Lines.Add('xxx');
  end else
    LoadSaveMyIniFileInt(Load,'dlgEMA','Memo1.Lines.Count',Memo1.Lines.Count,Memo1.Lines.Count);
  for i:=0 to Memo1.Lines.Count-1 do
    Memo1.Lines[i]:=LoadSaveMyIniFileString(Load,'dlgEMA','Memo1.Lines['+inttostr(i)+']',Memo1.Lines[i],Memo1.Lines[i]);

  FormShow(nil);
end;

procedure TdlgEMA.ExportEMAStart;
begin
  sExportEMA:='';
end;

procedure TdlgEMA.ExportEMAFinish;
begin
  if sExportEMA = '' then
    exit;
  if cbWriteasplaintext.Checked then
    Edit1.Text:=ChangeFileExt(ExtractFilename(Edit1.Text),'.txt') else
    Edit1.Text:=ChangeFileExt(ExtractFilename(Edit1.Text),'.pos');
  StringToFile(ChangeToExePath(Edit1.Text),memo1.text+sExportEMA);
  sExportEMA:='';
end;

procedure TdlgEMA.ExportEMAFrame;
var m,i,j: integer;
    PosRec: TPosRec;
begin
  for i:=0 to seChannels.Value-1 do
  begin
    fillchar(PosRec,sizeof(PosRec),0);
    if i < ListBox1.Items.Count then
    if loword(integer(ListBox1.Items.Objects[i])) = $EEEE then
    begin
//////
    end else
    if loword(integer(ListBox1.Items.Objects[i])) = $FFFF then
    begin
      m:=hiword(integer(ListBox1.Items.Objects[i]));
      if InRange(m,0,high(Form1.muscle)) then
      with Form1.muscle[m],EMA do
      begin
        PosRec.x:=TrackBar.Position/100;
        PosRec.y:=y;
        PosRec.z:=z;
        PosRec.phi:=phi;
        PosRec.theta:=theta;
        PosRec.rms:=rms;
        PosRec.extra:=extra;
      end;
    end else
    if loword(integer(ListBox1.Items.Objects[i])) <= Form1.NumAtoms then
    with Form1.Atoms[loword(integer(ListBox1.Items.Objects[i]))] do
    begin
      PosRec.x:=p.x;
      PosRec.y:=p.y;
      PosRec.z:=p.z;
      j:=hiword(integer(ListBox1.Items.Objects[i]));
      if (cbtheta.ItemIndex <> 0) or (cbphi.ItemIndex <> 0) and
         (j > 0) and
         (j <= Form1.NumAtoms) then
      begin
        case Tpt(cbphi.ItemIndex) of
          ptXY: PosRec.phi:=arctan2(Form1.Atoms[j].p.Y,Form1.Atoms[j].p.X);
          ptXZ: PosRec.phi:=arctan2(Form1.Atoms[j].p.Z,Form1.Atoms[j].p.X);
          ptYX: PosRec.phi:=arctan2(Form1.Atoms[j].p.X,Form1.Atoms[j].p.Y);
          ptYZ: PosRec.phi:=arctan2(Form1.Atoms[j].p.Z,Form1.Atoms[j].p.Y);
          ptZX: PosRec.phi:=arctan2(Form1.Atoms[j].p.X,Form1.Atoms[j].p.Z);
          ptZY: PosRec.phi:=arctan2(Form1.Atoms[j].p.Y,Form1.Atoms[j].p.Z);
        end;
        case Tpt(cbtheta.ItemIndex) of
          ptXY: PosRec.theta:=arctan2(Form1.Atoms[j].p.Y,Form1.Atoms[j].p.X);
          ptXZ: PosRec.theta:=arctan2(Form1.Atoms[j].p.Z,Form1.Atoms[j].p.X);
          ptYX: PosRec.theta:=arctan2(Form1.Atoms[j].p.X,Form1.Atoms[j].p.Y);
          ptYZ: PosRec.theta:=arctan2(Form1.Atoms[j].p.Z,Form1.Atoms[j].p.Y);
          ptZX: PosRec.theta:=arctan2(Form1.Atoms[j].p.X,Form1.Atoms[j].p.Z);
          ptZY: PosRec.theta:=arctan2(Form1.Atoms[j].p.Y,Form1.Atoms[j].p.Z);
        end;
      end;
      PosRec.rms:=fseRMSvalue.Value;
      PosRec.extra:=fseEXTRAvalue.Value;
    end;

    if cbWriteasplaintext.Checked then
      sExportEMA:=sExportEMA+
        FixedPointStr(PosRec.x,3)+', '+
        FixedPointStr(PosRec.y,3)+', '+
        FixedPointStr(PosRec.z,3)+', '+
        FixedPointStr(PosRec.phi,3)+', '+
        FixedPointStr(PosRec.theta,3)+', '+
        FixedPointStr(PosRec.rms,3)+', '+
        FixedPointStr(PosRec.extra,3)+#13#10 else
      sExportEMA:=sExportEMA+
        SingleDataToString(PosRec.x)+
        SingleDataToString(PosRec.y)+
        SingleDataToString(PosRec.z)+
        SingleDataToString(PosRec.phi)+
        SingleDataToString(PosRec.theta)+
        SingleDataToString(PosRec.rms)+
        SingleDataToString(PosRec.extra);
  end;
end;

procedure TdlgEMA.FormShow(Sender: TObject);
begin
  seChannelsChange(Sender);
end;

procedure TdlgEMA.seChannelsChange(Sender: TObject);
const c: array[0..2] of char = ('x','y','z');
var i: integer;
begin
  for i:=0 to ListBox1.Items.Count-1 do
  begin
    if loword(integer(ListBox1.Items.Objects[i])) = $EEEE then
    begin
      ListBox1.Items[i]:='Const ('+After(ListBox1.Items[i],'(');
    end else
    if loword(integer(ListBox1.Items.Objects[i])) = $FFFF then
    begin
      ListBox1.Items[i]:='Muscle:';
      ListBox1.Items[i]:=ListBox1.Items[i]+' '+Before(Form1.muscle[hiword(integer(ListBox1.Items.Objects[i]))].Label1.Caption,'=');

      if (i >= seChannels.Value) then
        ListBox1.Items[i]:='('+ListBox1.Items[i]+' - ignored )';
    end else
    begin
      if (cbtheta.ItemIndex <> 0) or (cbphi.ItemIndex <> 0) then
      begin
        if InRange(hiword(integer(ListBox1.Items.Objects[i])),1,Form1.NumAtoms-1) then
          ListBox1.Items[i]:='Atom['+inttostr(loword(integer(ListBox1.Items.Objects[i])))+'] -> '+inttostr(hiword(integer(ListBox1.Items.Objects[i]))) else
          ListBox1.Items[i]:='Atom['+inttostr(loword(integer(ListBox1.Items.Objects[i])))+'] -> ?';
      end else
        ListBox1.Items[i]:='Atom['+inttostr(loword(integer(ListBox1.Items.Objects[i])))+']';

      if (i >= seChannels.Value) or
         (loword(integer(ListBox1.Items.Objects[i])) > Form1.NumAtoms) then
        ListBox1.Items[i]:='('+ListBox1.Items[i]+' - ignored )';
    end;
    ListBox1.Items[i]:=inttostr(i+1)+' '+ListBox1.Items[i];
  end;
end;

procedure TdlgEMA.DeleteAtom(a: integer);
var i: integer;
begin
  for i:=ListBox1.Items.Count-1 downto 0 do
    if loword(integer(ListBox1.Items.Objects[i])) = a then
      ListBox1.Items.Delete(i);
  LoadSaveIniFile(false);
end;

procedure TdlgEMA.AddMuscles(NumMuscles: integer);
var m: integer;
begin
  for m:=0 to NumMuscles-1 do
    if m mod 3 = 0 then
      Listbox1.items.addObject(inttostr(m),TObject(MakeLong($FFFF,m)));
  LoadSaveIniFile(false);
end;

procedure TdlgEMA.DeleteMuscles;
var i: integer;
begin
  for i:=ListBox1.Items.Count-1 downto 0 do
    if loword(integer(ListBox1.Items.Objects[i])) = $FFFF then
      ListBox1.Items.Delete(i);
  LoadSaveIniFile(false);
end;

procedure TdlgEMA.Delete1Click(Sender: TObject);
begin
  if InRange(ListBox1.ItemIndex,0,ListBox1.Items.Count-1) then
    ListBox1.Items.Delete(ListBox1.ItemIndex);
end;

procedure TdlgEMA.CopyAll1Click(Sender: TObject);
begin
  Clipboard.AsText:=ListBox1.Items.Text;
end;

procedure TdlgEMA.PruneEMAs(first,len: integer);
//var s: array of string;
var s: tstringlist;
    i: integer;
begin
  sExportEMA:=FileToString(ChangeToExePath(Edit1.Text));
  Delete(sExportEMA,1,length(memo1.text));
  s:=tstringlist.create;
  if cbWriteasplaintext.Checked then
    s.text:=sExportEMA else
    for i:=0 to length(sExportEMA) div sizeof(TPosRec) -1 do
      s.add(copy(sExportEMA,i*sizeof(TPosRec),sizeof(TPosRec)));

  sExportEMA:=memo1.text;
  for i:=first*seChannels.Value to min((first+len)*seChannels.Value-1,s.count -1) do
    if cbWriteasplaintext.Checked then
      sExportEMA:=sExportEMA+s[i]+#13#10 else
      sExportEMA:=sExportEMA+s[i];

  StringToFile(ChangeToExePath(Edit1.Text),memo1.text+sExportEMA);
  sExportEMA:='';
end;

procedure TdlgEMA.ListBox1Click(Sender: TObject);
var s: string;
    d: Double;
begin
  fsex.Enabled:=false;
  fsey.Enabled:=false;
  fsez.Enabled:=false;

  if InRange(ListBox1.ItemIndex,0,ListBox1.Items.Count-1) then
  if loword(integer(ListBox1.Items.Objects[ListBox1.ItemIndex])) = $EEEE then
  begin
    s:=After(ListBox1.Items[ListBox1.ItemIndex],'(');
    if NextIsSignedDouble(s,d) then
      fsex.Value:=d else
      fsex.Value:=0;
    if NextIs(s,',') then
    begin
      if NextIsSignedDouble(s,d) then
        fsey.Value:=d else
        fsey.Value:=0;
    end;
    if NextIs(s,',') then
    begin
      if NextIsSignedDouble(s,d) then
        fsez.Value:=d else
        fsez.Value:=0;
    end;
    if NextIs(s,',') then
    begin
      if NextIsSignedDouble(s,d) then
        fsephi.Value:=d else
        fsephi.Value:=0;
    end;
    if NextIs(s,',') then
    begin
      if NextIsSignedDouble(s,d) then
        fsetheta.Value:=d else
        fsetheta.Value:=0;
    end;

    fsex.Enabled:=true;
    fsey.Enabled:=true;
    fsez.Enabled:=true;
  end;
  fsephi.Visible:=fsex.Enabled;
  fsetheta.Visible:=fsex.Enabled;
  cbphi.Visible:=not fsex.Enabled;
  cbtheta.Visible:=not fsex.Enabled;
end;

procedure TdlgEMA.fsezChange(Sender: TObject);
var s: string;
    d: Double;
begin
  if fsex.Enabled then
  if InRange(ListBox1.ItemIndex,0,ListBox1.Items.Count-1) then
  if loword(integer(ListBox1.Items.Objects[ListBox1.ItemIndex])) = $EEEE then
  begin
    ListBox1.Items[ListBox1.ItemIndex]:='Const ('+
        FixedPointStr(fsex.Value,3)+','+
        FixedPointStr(fsey.Value,3)+','+
        FixedPointStr(fsez.Value,3)+','+
        FixedPointStr(fsephi.Value,3)+','+
        FixedPointStr(fsetheta.Value,3)+')';
  end;
  seChannelsChange(Sender);
end;

{
procedure TdlgEMA.Button2Click(Sender: TObject);
begin
  ListBox1.ItemIndex:=ListBox1.Items.AddObject(inttostr(ListBox1.Items.Count)+' Const (0,0,0)',TObject(MakeLong($EEEE,0)));
  ListBox1Click(Sender);
end;
}

procedure TdlgEMA.Button2Click(Sender: TObject);
var a: TAtomRef;
begin
  for a:=1 to Form1.NumAtoms do
    if Form1.Atoms[a].Selected then
      DeleteAtom(a);
end;

function TdlgEMA.WriteEMA: string;
var i: integer;
begin
  result:='';
  for i:=0 to ListBox1.Items.Count-1 do
    result:=result+'E:L:'+inttostr(integer(ListBox1.Items.Objects[i]))+','+ListBox1.Items[i]+#13#10;
//  for i:=0 to Memo1.Lines.Count-1 do
//    result:=result+'E:M:'+Memo1.Lines[i]+#13#10;
end;

procedure TdlgEMA.LoadEMAInit;
begin
  ListBox1.Items.Clear;
//  Memo1.clear;
end;

procedure TdlgEMA.LoadEMA(line: string);
var i: integer;
begin
  NextIs(line,'E');
  Mustbe(line,':');
  If NextIs(line,'L') then
  begin
    Mustbe(line,':');
    i:=NextNumber(line);
    Mustbe(line,',');
    ListBox1.Items.AddObject(line,TObject(i));
//  end else
//  If NextIs(line,'M') then
//  begin
//    Mustbe(line,':');
//    Memo1.Lines.Add(line);
  end;
end;

procedure TdlgEMA.Button3Click(Sender: TObject);
var b: TStrutRef;
    a: TAtomRef;
    ok: boolean;
begin
  if (cbtheta.ItemIndex <> 0) or (cbphi.ItemIndex <> 0) then
  begin
    if Form1.AtomsSelectedCount <> Form1.StrutsSelectedCount then
    begin
      ShowErrorMessage('Each selected Atom should have one selected strut and vice versa');
      exit;
    end;
    for b:=1 to Form1.NumStruts do
    if Form1.Struts[b].Selected then
    if (not (Form1.Atoms[Form1.Struts[b].Atom1].Selected or Form1.Atoms[Form1.Struts[b].Atom2].Selected)) or
       (Form1.Atoms[Form1.Struts[b].Atom1].Selected and Form1.Atoms[Form1.Struts[b].Atom2].Selected) then
    begin
      ShowErrorMessage('Each selected Atom should have one selected strut and vice versa');
      exit;
    end;

    for a:=1 to Form1.NumAtoms do
    if Form1.Atoms[a].Selected then
    begin
      ok:=false;
      for b:=1 to Form1.NumStruts do
        if Form1.Struts[b].Selected then
          if (Form1.Struts[b].Atom1 = a) or (Form1.Struts[b].Atom2 = a) then
            ok:=true;
      if not ok then
      begin
        ShowErrorMessage('Each selected Atom should have one selected strut and vice versa');
        exit;
      end;
    end;
    for a:=1 to Form1.NumAtoms do
      if Form1.Atoms[a].Selected then
        for b:=1 to Form1.NumStruts do
          if Form1.Struts[b].Selected then
            if Form1.Struts[b].Atom2 = a then
              AddAtom(a,Form1.Struts[b].Atom1) else
            if Form1.Struts[b].Atom1 = a then
              AddAtom(a,Form1.Struts[b].Atom2);
  end else
  begin
    for a:=1 to Form1.NumAtoms do
      if Form1.Atoms[a].Selected then
        AddAtom(a,0);
  end;
end;

procedure TdlgEMA.Button4Click(Sender: TObject);
begin
  if InRange(Form1.CurMuscle,0,high(Form1.muscle)) then
  begin
    Listbox1.items.addObject(inttostr(Form1.CurMuscle),TObject(MakeLong($FFFF,Form1.CurMuscle)));
    seChannelsChange(Sender);
  end;
end;

end.



