unit ImportImagesdlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, CheckLst, Menus,
  jpegcalc,
  misc, SizePos, FSpin;

type
  TdlgImportImages = class(TForm)
    Panel1: TPanel;
    OpenDialog1: TOpenDialog;
    Panel3: TPanel;
    OKBtn: TButton;
    CancelBtn: TButton;
    CheckListBox1: TCheckListBox;
    PopupMenu1: TPopupMenu;
    CheckAll1: TMenuItem;
    UnCheckAll1: TMenuItem;
    CheckSelected1: TMenuItem;
    UnCheckSelected1: TMenuItem;
    Panel4: TPanel;
    Image1: TImage;
    PaintBox1: TPaintBox;
    Label1: TLabel;
    SizePos1: TSizePos;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    fsXScale: TFSpinEdit;
    fsYScale: TFSpinEdit;
    fsZScale: TFSpinEdit;
    procedure FormShow(Sender: TObject);
    procedure CheckListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure CheckAll1Click(Sender: TObject);
    procedure UnCheckAll1Click(Sender: TObject);
    procedure CheckSelected1Click(Sender: TObject);
    procedure UnCheckSelected1Click(Sender: TObject);
    procedure CheckListBox1Click(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1Paint(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
    moving: (ml,mt,mr,mb,m0);
    bRect: TRect; {rect in bitmap}
    function GetaRect: TRect;
    procedure SetaRect(r: TRect);
    procedure SetaRectLeft(i: integer);
    procedure SetaRectRight(i: integer);
    procedure SetaRectTop(i: integer);
    procedure SetaRectBottom(i: integer);
    property aRect: TRect read GetaRect write SetaRect; {rect in displayed image}
    procedure LoadSaveIniFile(Load: Boolean);
    procedure DeleteAllImageFiles;
    procedure WriteAllImageFiles;
  public
    { Public declarations }
    pixs: array of TPix;
    procedure ReadAllImageFiles;
  end;

var
  dlgImportImages: TdlgImportImages;

implementation

{$R *.DFM}

uses
  jpeg,
  iniio,
  math;

type
  TMyCheckListBox = class(TCheckListBox)
    public
      property MultiSelect;
  end;

procedure TdlgImportImages.FormShow(Sender: TObject);
var i: integer;
begin
  with OpenDialog1 do
  if Execute then
  if UpperCase(AppDirectory) = UpperCase(ExtractFilePath(OpenDialog1.Files[0])) then
  begin
    ShowErrorMessage('Forbidden to import images from directory containaing GGSim:'#13#10+AppDirectory);
    CheckListBox1.Clear;
  end else
  begin
    CheckListBox1.Items.Assign(OpenDialog1.Files);
    for i:=0 to CheckListBox1.Items.Count-1 do
      CheckListBox1.Items[i]:=LpadC(RemoveNonNumerics(ExtractFilename(CheckListBox1.Items[i])),8,'0')+'>'+ExtractFilename(CheckListBox1.Items[i])+'<'+CheckListBox1.Items[i];
    CheckListBox1.Sorted:=true;
    CheckListBox1.Sorted:=false;
    CheckAll1Click(Sender);
    TMyCheckListBox(CheckListBox1).MultiSelect:=true;
    CheckListBox1.ItemIndex:=IntRange(0,0,CheckListBox1.Items.Count-1);
    CheckListBox1Click(Sender);
//    bRect:=rect(0,0,image1.Picture.Bitmap.Width-1,image1.Picture.Bitmap.Height-1);
  end;
end;

procedure TdlgImportImages.CheckListBox1DrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TCheckListBox),Canvas do  { draw on control canvas, not on the form }
  begin
    FillRect(Rect);
    TextOut(Rect.Left + 2, Rect.Top, Before(After(Items[Index],'>'),'<'));
  end;
end;

procedure TdlgImportImages.CheckAll1Click(Sender: TObject);
var i: integer;
begin
  for i:=0 to CheckListBox1.Items.Count-1 do
    CheckListBox1.Checked[i]:=true;
  Paintbox1.Invalidate;
end;

procedure TdlgImportImages.UnCheckAll1Click(Sender: TObject);
var i: integer;
begin
  for i:=0 to CheckListBox1.Items.Count-1 do
    CheckListBox1.Checked[i]:=false;
  Paintbox1.Invalidate;
end;

procedure TdlgImportImages.CheckSelected1Click(Sender: TObject);
var i: integer;
begin
  for i:=0 to CheckListBox1.Items.Count-1 do
    if CheckListBox1.Selected[i] then
      CheckListBox1.Checked[i]:=true;
  Paintbox1.Invalidate;
end;

procedure TdlgImportImages.UnCheckSelected1Click(Sender: TObject);
var i: integer;
begin
  for i:=0 to CheckListBox1.Items.Count-1 do
    if CheckListBox1.Selected[i] then
      CheckListBox1.Checked[i]:=false;
  Paintbox1.Invalidate;
end;

procedure TdlgImportImages.CheckListBox1Click(Sender: TObject);
begin
  if InRange(CheckListBox1.ItemIndex,0,CheckListBox1.Items.Count-1) then
  begin
    JPGLoadImageFromFile(image1,After(CheckListBox1.Items[CheckListBox1.ItemIndex],'<'));
    if image1.Picture.Bitmap.Width/image1.Picture.Bitmap.Height > Panel4.Width/Panel4.Height then
    begin
      image1.Width:=Panel4.Width;
      image1.Height:=image1.Picture.Bitmap.Height*Panel4.Width div image1.Picture.Bitmap.Width;
    end else
    begin
      image1.Width:=image1.Picture.Bitmap.Width*Panel4.Height div image1.Picture.Bitmap.Height;
      image1.Height:=Panel4.Height;
    end;
    image1.Width:=min(image1.Width,image1.Picture.Bitmap.Width);
    image1.Height:=min(image1.Height,image1.Picture.Bitmap.Height);
    Paintbox1.Invalidate;
  end;
end;

procedure TdlgImportImages.PaintBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (abs(x-aRect.Left) < 8) then
    moving:=ml else
  if (abs(x-aRect.Right) < 8) then
    moving:=mr else
  if (abs(y-aRect.Top) < 8) then
    moving:=mt else
  if (abs(y-aRect.Bottom) < 8) then
    moving:=mb else
  begin
    moving:=m0;
    aRect:=Rect(x,y,x,y);
  end;
  aRect:=Rect(IntRange(aRect.Left,0,Image1.Width-1),IntRange(aRect.Top,0,Image1.Height-1),IntRange(aRect.Right,0,Image1.Width-1),IntRange(aRect.Bottom,0,Image1.Height-1));
  Paintbox1.Invalidate;
end;

procedure TdlgImportImages.PaintBox1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then
  begin
    case moving of
      ml: SetaRectLeft(x);
      mt: SetaRectTop(y);
      mr: SetaRectRight(x);
      mb: SetaRectBottom(y);
      else aRect:=Rect(aRect.Left,aRect.Top,x,y);
    end;
    aRect:=Rect(IntRange(aRect.Left,0,Image1.Width-1),IntRange(aRect.Top,0,Image1.Height-1),IntRange(aRect.Right,0,Image1.Width-1),IntRange(aRect.Bottom,0,Image1.Height-1));
    Paintbox1.Invalidate;
  end;
end;

procedure TdlgImportImages.PaintBox1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  aRect:=SortRect(aRect);
  Paintbox1.Invalidate;
end;

procedure TdlgImportImages.PaintBox1Paint(Sender: TObject);
var i,j: integer;
begin
  if CheckListBox1.Items.Count = 0 then
    ModalResult:=mrCancel;

  with Paintbox1,Canvas do
  begin
    pen.color:=clBlack;
    brush.color:=clWhite;
    pen.style:=psDot;
    OutlineTRect(Canvas,aRect);

    j:=0;
    for i:=0 to CheckListBox1.Items.Count-1 do
      if CheckListBox1.Checked[i] then
        inc(j);
    label1.Caption:=inttostr(round(bRect.Right-bRect.Left))+' x '+inttostr(round(bRect.Bottom-bRect.Top))+' x '+inttostr(j)+' ('+inttostr(CheckListBox1.SelCount)+')';
    OKBtn.enabled:=(bRect.Right> bRect.Left) and (bRect.Bottom> bRect.Top);
  end;
end;

procedure TdlgImportImages.CheckListBox1ClickCheck(Sender: TObject);
begin
  Paintbox1.Invalidate;
end;

function TdlgImportImages.GetaRect: TRect;
begin
  if image1.Picture.Bitmap.Width = 0 then
    exit;
  result.Left:=round(bRect.Left*image1.Width / image1.Picture.Bitmap.Width);
  result.Right:=round(bRect.Right*image1.Width / image1.Picture.Bitmap.Width);
  result.Top:=round(bRect.Top*image1.Height / image1.Picture.Bitmap.Height);
  result.Bottom:=round(bRect.Bottom*image1.Height / image1.Picture.Bitmap.Height);
end;

procedure TdlgImportImages.SetaRect(r: TRect);
begin
  SetaRectLeft(r.Left);
  SetaRectRight(r.Right);
  SetaRectTop(r.Top);
  SetaRectBottom(r.Bottom);
end;

procedure TdlgImportImages.SetaRectLeft(i: integer);
begin
  bRect.Left:=round(i*image1.Picture.Bitmap.Width / image1.Width);
end;

procedure TdlgImportImages.SetaRectRight(i: integer);
begin
  bRect.Right:=round(i*image1.Picture.Bitmap.Width / image1.Width);
end;

procedure TdlgImportImages.SetaRectTop(i: integer);
begin
  bRect.Top:=round(i*image1.Picture.Bitmap.Height / image1.Height);
end;

procedure TdlgImportImages.SetaRectBottom(i: integer);
begin
  bRect.Bottom:=round(i*image1.Picture.Bitmap.Height / image1.Height);
end;

procedure TdlgImportImages.FormCreate(Sender: TObject);
begin
  LoadSaveIniFile(true);
end;

procedure TdlgImportImages.LoadSaveIniFile(Load: Boolean);
begin
  bRect.Left:=LoadSaveMyIniFileInt(Load,'dlgImportImages','bRect.Left',bRect.Left,100);
  bRect.Right:=LoadSaveMyIniFileInt(Load,'dlgImportImages','bRect.Right',bRect.Right,100);
  bRect.Top:=LoadSaveMyIniFileInt(Load,'dlgImportImages','bRect.Top',bRect.Top,200);
  bRect.Bottom:=LoadSaveMyIniFileInt(Load,'dlgImportImages','bRect.Bottom',bRect.Bottom,200);
  fsXScale.Value:=LoadSaveMyIniFileDouble(Load,'dlgImportImages','fsXScale.Value',fsXScale.Value,1);
  fsYScale.Value:=LoadSaveMyIniFileDouble(Load,'dlgImportImages','fsYScale.Value',fsYScale.Value,1);
  fsZScale.Value:=LoadSaveMyIniFileDouble(Load,'dlgImportImages','fsZScale.Value',fsZScale.Value,1);
end;

procedure TdlgImportImages.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  LoadSaveIniFile(ModalResult <> mrOK);
end;

procedure TdlgImportImages.OKBtnClick(Sender: TObject);
var i: integer;
begin
  DeleteAllImageFiles;
  SetLength(pixs,0);
  for i:=0 to CheckListBox1.Items.Count-1 do
  begin
    SetLength(pixs,Length(pixs)+1);
    JPGLoadImageFromFile(image1,After(CheckListBox1.Items[i],'<'));
    image1.update;
    pixs[high(pixs)]:=PixGetRect(BitmapToPix(image1.Picture.Bitmap,cgRGB),bRect);
  end;
  WriteAllImageFiles;
end;

procedure TdlgImportImages.DeleteAllImageFiles;
begin
  oldEraseFiles(ChangeToExePath('section*.jpg'));
end;

procedure TdlgImportImages.WriteAllImageFiles;
var i: integer;
begin
  for i:=0 to high(pixs) do
    PixSaveToFile(pixs[i],ChangeToExePath('section'+inttostr(i)+'.jpg'));
end;

procedure TdlgImportImages.ReadAllImageFiles;
var i: integer;
begin
  try
    Screen.Cursor:=crHourglass;
    SetLength(pixs,0);
    i:=0;
    while fileexists(ChangeToExePath('section'+inttostr(i)+'.jpg')) do
    begin
      SetLength(pixs,Length(pixs)+1);
      JPGLoadImageFromFile(image1,ChangeToExePath('section'+inttostr(i)+'.jpg'));
      image1.update;
      pixs[high(pixs)]:=BitmapToPix(image1.Picture.Bitmap,cgRGB);
      inc(i);
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

end.


