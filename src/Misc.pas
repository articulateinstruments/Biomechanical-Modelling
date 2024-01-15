(************************************************************************)
(* This Source file is copyright Analogue Information Systems 1994-2014 *)
(*                                                                      *)
(* You may use this Source within your own organisation but may         *)
(* not pass copies of it to other parties. You are free to              *)
(* distribute any number of copies of executable files containing       *)
(* compiled versions of this Source                                     *)
(************************************************************************)

//procedure ShowErrorMessage(const APrompt: string);
//procedure ShowInformationMessage(const APrompt: string//procedure ShowWarningMessage(const APrompt: string);
//function YesNoBox(const APrompt: string): Boolean;
//function YesNoCancelBox(const APrompt: string): TModalResult;
//function InputBox(const ACaption, APrompt, ADefault: string): string;
//function InputMemo(const ACaption, APrompt, ADefault: string): string;
//function InputQuery(const ACaption, APrompt: string; var Value: string): Boolean;
//function InputNumberQuery(const ACaption, APrompt: string; var aValue: integer; min,max: integer): Boolean;
//function InputNumberQuery2(const ACaption, APrompt1,APrompt2: string; var aValue1,aValue2: integer; min,max: integer): Boolean;
//function InputNumberQuery3(const ACaption, APrompt1,APrompt2: string; var aValue1,aValue2: integer; min,max: integer): Boolean;
//function InputNumberQuery4(const ACaption, APrompt1,APrompt2: string; var aValue1,aValue2: integer; min,max: integer): Boolean;
//function InputDoubleQuery(const ACaption, APrompt: string; var aValue: double; min,max: double): Boolean;
//function InputStringYesNoCancel(const ACaption, APrompt: string; var aValue: string): TModalResult;
//function ChooseOne(const ACaption, APrompt: string; const s: array of string; var index: integer): Boolean;
//function ChooseOneStrs(const ACaption, APrompt: string; s: strings; var index: integer): Boolean;

//function ClipCursor(lpRect: PRect): BOOL; stdcall;
//function GetCapture: HWND; stdcall;
//function SetCapture(hWnd: HWND): HWND; stdcall;
//function ReleaseCapture: BOOL; stdcall;
//function SetCaptureControl(aImage);
//if csDestroying in ComponentState then exit;
//function FindComponent(const AName: string): TComponent;
//procedure ZeroMemory(Destination: Pointer; Length: DWORD);
//  ForceDirectories(s); //creates all the directories in a path
{
var Stream: TFileStream;
  try
    Stream:=TFileStream.Create(filename, fmOpenRead);
    Stream.Read(ByteOrder,sizeof(ByteOrder));
    Stream.Seek(l,soFromBeginning);
  finally
    Stream.Free;
  end;

=======================================================

  if csDestroying in ComponentState then
  if csLoading in ComponentState then

=======================================================

const first: boolean = true;
begin
  if first then
  begin
    first:=false;
    ...
  end;
end;

=======================================================

get the RGB of a system color
    GetSysColor(clBtnFace and $000000FF)

=======================================================
}
(*
uses
  shellapi;

    procedure WMDropFiles(var Msg: TMessage); message wm_DropFiles;
procedure TForm1.WMDropFiles(var Msg: TMessage);
  var TotalNumberOfFiles: integer;
      hDrop: Thandle;
      nFileLength: integer;
      buf: array[0..1000] of char;
      i: integer;                          
begin
  hDrop:=msg.WParam;
  i:=-1;
  {$R-}
  TotalNumberOfFiles:=DragQueryFile( hDrop , i, nil, 0 );
  {$R+}
  Memo1.Clear;
  for i:=0 to TotalNumberOfFiles-1 do
  begin
    nFileLength:=DragQueryFile( hDrop , i , nil, 0 );
    if nFileLength > sizeof(buf)-1 then nFileLength:=sizeof(buf)-1;
    DragQueryFile( hDrop , i, buf, nFileLength + 1 );
    Memo1.Lines.Add(GetFullPath(StrPas(buf)));
  end;
  DragFinish( hDrop );
end;

  DragAcceptFiles(Handle, TRUE);
*){

=======================================================
  getting these is very slow
    SpinEdit1.value
    ComboBox1.itemindex
  getting these is very fast
    checkbox1.checked
    RadioGroup1.itemindex
    RadioButton2.checked

=======================================================
put picture into clipboard
    Clipboard.Assign(Image1.Picture);

get picture from clipboard
  if Clipboard.HasFormat(CF_Bitmap) then
    Image1.Picture.Assign(Clipboard);


=======================================================
  SendMessage(hWnd_Broadcast,WM_MyMessage,handle,-1);
  WM_MyMessage:=RegisterWindowMessage('WM_MyMessage');
var
  WM_MyMessage: word;
procedure TForm1.WndProc(var Message: TMessage);
begin
  if Message.Msg = WM_MyMessage then
    WMMyMessage(Message) else
    inherited WndProc(Message);
end;

procedure TForm1.WMMyMessage(var Message: TMessage);
begin
  with Message do
  begin
    lParam
    wParam
  end;
end;

procedure WMMyMessage(var Message: TMessage);
procedure WndProc(var Message: TMessage); override;

====================================================
draws controls including "close" small button
DrawFrameControl(handle,r,

draws parts of a border frame including diagonals
DrawEdge(handle,r,BDR_RAISEDINNER +    BDR_SUNKENOUTER

====================================================
  try
    Screen.Cursor:=crHourglass;
    ...
  finally
    Screen.Cursor:=crDefault;
  end;
=====================================================
  var oldCursor: TCursor;
  try
    oldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourglass;
    ...
  finally
    Screen.Cursor:=oldCursor;
  end;
=====================================================

a reSource file can be created and accessed with:
        format is
          FF 0A 00
          'P' 'U' 'Z' 'Z' 'L' 'E' 00   name of reSource, upper case, null terminated
          30 00
          xx xx xx xx    length of data
          xx ... xx      data
        var p: pointer;
        s: string;
        p:=LockReSource(LoadReSource(HInstance,FindReSource(HInstance,'PUZZLE', RT_RCDATA)));
        s:='aaaaaaaaaa';
        move(p^,s[1],10);
        showmessage(s);

========================================================

uses misc;
    procedure WMMOUSEWHEEL(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
procedure TForm1.WMMOUSEWHEEL(var Message: TWMMouseWheel);
begin
  if smallint(Message.WheelDelta) > 0 then
    Value:=Value+increment else
    Value:=Value-increment;
end;                   

OR COULD USE AppMessage

    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
  Application.OnMessage := AppMessage;
procedure TForm1.AppMessage(var Msg: TMsg; var Handled: Boolean);
var aMessage: TMessage;
begin
  if Msg.message = WM_MOUSEWHEEL then
  begin
    aMessage.Msg:=Msg.message;
    aMessage.WParam:=Msg.WParam;
    aMessage.LParam:=Msg.LParam;
    Handled := True;
    WMMOUSEWHEEL(TWMMouseWheel(aMessage));
  end;
end;


=========================================================================
const Executing: boolean = false;
  if not Executing then
  try
    Executing:=true;
    ...
  finally
    Executing:=false;
  end;
=========================================================================
Const First: boolean = true;
begin
  if First then
  begin
    First:=false;
    ...
  end;
end;
=============================================================================
  try
    ...
  except
    on E:Exception do
      ShowMessage(E.Message);
  end;

  raise Exception.Create('error');

  try
    ...
  except
    ...
    raise;
  end;

=========================================================================

 procedure AppOnIdle(Sender: TObject; var Done: Boolean);
procedure TForm1.AppOnIdle(Sender: TObject; var Done: Boolean);
begin
   CheckBox1.Checked := Odd(GetKeyState(VK_CAPITAL));
   CheckBox2.Checked := Odd(GetKeyState(VK_SHIFT));
   CheckBox3.Checked := Odd(GetKeyState(VK_NUMLOCK));
   CheckBox4.Checked := Odd(GetKeyState(VK_SCROLL));
   Done := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Application.OnIdle := AppOnIdle;
end;
===========================================================================
($R cursors.RES)

const
  crHandGrab = 1;
  crHandFlat = 2;

  Screen.Cursors[crHandGrab]:=LoadCursor(HInstance,'HANDGRAB');
  Screen.Cursors[crHandFlat]:=LoadCursor(HInstance,'HANDFLAT');

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  pMouse:=Point(x,y);
  if (ssLeft in Shift) and (Screen.Cursor = crHandFlat) then
  begin
    Screen.Cursor:=crHandGrab;
  end else
  begin
  end;
end;

procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; x,
  Y: Integer);
begin
  if Screen.Cursor <> crDefault then
  begin
    if Screen.Cursor = crHandGrab then
    begin
      xOfs:=pMouse.x-x+xOfs;
      yOfs:=pMouse.y-y+yOfs;
      PaintBox1.Invalidate;
    end;
  end else
  begin
  end;
  pMouse:=Point(x,y);
end;

procedure TForm1.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Screen.Cursor <> crDefault then
  begin
    if GetKeyState(vk_Control) >= 0 then
      Screen.Cursor:=crDefault else
      Screen.Cursor:=crHandFlat;
  end else
  begin
  end;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_Control then
  begin
    if Screen.Cursor = crDefault then
      Screen.Cursor:=crHandFlat;
  end else
  begin
  end;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_Control then
    if Screen.Cursor = crHandFlat then
      Screen.Cursor:=crDefault;
end;

==============================================================================
    procedure DoShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
procedure TForm1.DoShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
begin
  if HintInfo.HintControl = SpeedButton3 then
  begin
    with HintInfo do
    begin
      HintStr:='xxx';
    end;
  end;
end;

  Application.ShowHint := True;
  Application.OnShowHint := DoShowHint;
=========================================================================
an invisible window
  TInvWin = Class ( TPanel )
  Private
    fImage: TImage;
    Procedure WMPaint ( Var Message : TWMPaint ); message WM_PAINT;
  Protected
     Procedure CreateParams ( Var Params : TCreateParams ); override;
  End;

  InvWin : TInvWin;

function MakePanelImage(aImage: TImage): TInvWin;
Begin
  result := TInvWin.Create ( aImage.Owner );
  result.ControlStyle := [csOpaque];
  result.Visible := true;
  result.Parent := aImage.Parent;
  result.fImage:=aImage;
  aImage.Visible:=false;
  result.Left:=aImage.Left;
  result.Top:=aImage.Top;
  result.Width:=aImage.Width;
  result.Height:=aImage.Height;
End;

Procedure TInvWin.CreateParams ( Var Params : TCreateParams );
Begin
  Inherited CreateParams ( Params );
  Params.ExStyle := Params.ExStyle or WS_EX_TRANSPARENT;
End;

Procedure TInvWin.WMPaint ( Var Message : TWMPaint );
Var
   DC : THandle;
   PS : TPaintStruct;
   Canvas: TCanvas;
Begin
  DC := BeginPaint ( Handle, PS );
  Canvas:=TCanvas.Create;
  Canvas.Handle:=DC;
  Canvas.Draw(0,0,fimage.picture.graphic);
  Canvas.Free;
  EndPaint ( Handle, PS );
End;


  InvWin.Invalidate;
  InvWin.Update;
================================================================================
current mouse state

  if GetAsyncKeyState(VK_LBUTTON) < 0 then
================================================================================

move menu item to the right

procedure TfmPaperX.ShowStatus(s: string);
var mmi: TMenuItemInfo;
  MyMenu: hMenu;
  Buffer: array[0..79] of Char;
const prev: string = '';
begin
  if s = prev then
    exit;

  MyMenu := GetMenu(Handle);
  MMI.cbSize := SizeOf(MMI);
  MMI.fMask := MIIM_TYPE;
  MMI.dwTypeData := Buffer;
  MMI.cch := SizeOf(Buffer);
  GetMenuItemInfo(MyMenu, MainMenu1_B.Items.Count-1, True, MMI);
  MMI.fType := MMI.fType or MFT_RIGHTJUSTIFY or MFT_STRING;
  StrPCopy(Buffer,s);
  SetMenuItemInfo(MyMenu, MainMenu1_B.Items.Count-1, True, MMI);
  SetMenu(handle,MyMenu);
  prev:=s;
end;

========================================================================================
invert an affine matrix

bx1 = ax1*p + ay1*q + r
bx2 = ax2*p + ay2*q + r
bx3 = ax3*p + ay3*q + r
by1 = ax1*s + ay1*t + u
by2 = ax2*s + ay2*t + u
by3 = ax3*s + ay3*t + u
p := ((ay2*(bx3 - bx1)) + (ay1*(bx2 - bx3)) + (ay3*(bx1 - bx2))) / ((ay3*(ax1 - ax2)) + (ay2*(ax3 - ax1)) + (ay1*(ax2 - ax3)));
q := ((ax1*(bx3 - bx2)) + (ax2*(bx1 - bx3)) + (ax3*(bx2 - bx1))) / ((ax1*(ay3 - ay2)) + (ax2*(ay1 - ay3)) + (ax3*(ay2 - ay1)));
r := ((ay1*((bx3*ax2) - (ax3*bx2))) + (ax1*((ay3*bx2) - (bx3*ay2))) + (bx1*((ax3*ay2) - (ay3*ax2)))) / ((ax1*(ay3 - ay2)) - (ay3*ax2) + (ax3*ay2) + (ay1*(ax2 - ax3)));
s := ((ay2*(by3 - by1)) + (ay1*(by2 - by3)) + (ay3*(by1 - by2))) / ((ay3*(ax1 - ax2)) + (ay2*(ax3 - ax1)) + (ay1*(ax2 - ax3)));
t := ((ax1*(by3 - by2)) + (ax2*(by1 - by3)) + (ax3*(by2 - by1))) / ((ax1*(ay3 - ay2)) + (ax2*(ay1 - ay3)) + (ax3*(ay2 - ay1)));
u := ((ay1*((by3*ax2) - (ax3*by2))) + (ax1*((ay3*by2) - (by3*ay2))) + (by1*((ax3*ay2) - (ay3*ax2)))) / ((ax1*(ay3 - ay2)) - (ay3*ax2) + (ax3*ay2) + (ay1*(ax2 - ax3)));

}

unit Misc;
              
interface

uses
  Windows,
  ComCtrls,ExtCtrls,Forms,Graphics,WinProcs,WinTypes,classes,StdCtrls,
  controls,
  menus,
  MMSystem,
  Spin,checklst,
  Grids;

type
  TWMMouseWheel = record
    Msg: Cardinal;
    Keys: SmallInt;
    WheelDelta: SmallInt;
    case Integer of
      0: (
        XPos: Smallint;
        YPos: Smallint);
      1: (
        Pos: TSmallPoint;
        Result: Longint);
  end;

const
  WM_MOUSEWHEEL       = $020A;
  WM_TOUCH            = $0240;

const
  HKEY_CLASSES_ROOT   = $80000000;
  HKEY_CURRENT_USER   = $80000001;
  HKEY_LOCAL_MACHINE  = $80000002;
  HKEY_USERS          = $80000003;

  fsPathName	= 79;
  fsDirectory	= 67;
  fsFileName	= 8;
  fsExtension	= 4;
  MaxSmallInt = $7FFF;


  clLightBlue    = clBlue;
  clLightGray    = clSilver;
  clLightGreen   = clLime;
  clLightRed     = clRed;
  clLightYellow  = clYellow;
  clLightCyan    = clLightBlue+clLightGreen;
  clLightMagenta = clLightBlue+clLightRed;
  clCyan = clLightCyan;
  clMagenta = clLightMagenta;

  clDarkBlue    = clNavy;
  clDarkGray    = clDkGray;
  clDarkGreen   = clGreen;
  clDarkRed     = clMaroon;
  clDarkYellow  = clOlive;
  clDarkCyan    = clDarkBlue+clDarkGreen;
  clDarkMagenta = clDarkBlue+clDarkRed;

  clOrange = clLightRed+clDarkGreen;
  clPaleBlue = clBlue+clGreen+clMaroon;

  ColorTable: array[0..15] of TColor =
    (clBlack,
     clLightRed,
     clLightGreen,
     clLightYellow,
     clLightBlue,
     clLightCyan,
     clLightMagenta,
     clLightGray,
     clDarkGray,
     clDarkRed,
     clDarkGreen,
     clDarkYellow,
     clDarkBlue,
     clDarkCyan,
     clDarkMagenta,
     clWhite);
  BitValue: array[0..31] of Longword =
    ($00000001,$00000002,$00000004,$00000008,$00000010,$00000020,$00000040,$00000080,
     $00000100,$00000200,$00000400,$00000800,$00001000,$00002000,$00004000,$00008000,
     $00010000,$00020000,$00040000,$00080000,$00100000,$00200000,$00400000,$00800000,
     $01000000,$02000000,$04000000,$08000000,$10000000,$20000000,$40000000,$80000000);

type
  string255 = string[255];
  Pstring255 = ^string255;
  Pstring = ^string;
  string20 = string[20];
  string50 = string[50];
  string3  = string[3];
  PathStr = array[0..fsPathName] of Char;

  TSinglePoint = record x,y: single; end;
  gPSinglePoint = ^TSinglePoint;
  T3DPoint = record x,y,z: single; end;
  TInt3DPoint = record x,y,z: integer; end;
  TArrayofT3DPoint = array of T3DPoint;
  TPlane = record p: T3DPoint; d: single; end; {p must be normalised; equation of plane is px*x + py*y + pz*z+d = 0}
  TAffineMatrix = array[1..3] of TSinglePoint;
  TSingleRect = record
      case Integer of        0: (Left, Top, Right, Bottom: single);        1: (TopLeft, BottomRight: TsinglePoint);    end;
  TMatrix3X3 = array[1..3,1..3] of Single;

  SmallintArray = Array[0..maxint div sizeof(Smallint) -1] of Smallint;
  pSmallintArray = ^SmallintArray;
  ShortintArray = Array[0..maxint div sizeof(Shortint) -1] of Shortint;
  pShortintArray = ^ShortintArray;
  IntegerArray = Array[0..maxint div sizeof(Integer) -1] of Integer;
  pIntegerArray = ^IntegerArray;
  ByteArray = Array[0..maxint div sizeof(Byte) -1] of Byte;
  pByteArray = ^ByteArray;

  TArrayofTPoint = Array of TPoint;
  TArrayofTSinglePoint = Array of TSinglePoint;
  TArrayofInteger = Array of Integer;
  TArrayofSingle = Array of Single;

  TArrayofSmallint = Array of Smallint;
  TArrayofShortInt = Array of ShortInt;
  TArrayofDouble = Array of Double;
  TSetOfChar = set of char;
  TarrayofByte = array of Byte;
  TSetOfByte = set of Byte;

const
  AffineIdentity: TAffineMatrix = ((x:1;y:0),(x:0;y:1),(x:0;y:0));

type
  PLinkedListRec = ^TLinkedListRec;
  TLinkedListRec = object
    next: PLinkedListRec;

    constructor NewRec;
    constructor NewSortedRec(var list: PLinkedListRec);
    constructor NewHeadRec(var list: PLinkedListRec);
    constructor NewTailRec(var list: PLinkedListRec);
    procedure InitRec; virtual;
    procedure DestroyRec(var list: PLinkedListRec); virtual;
    function before(a,b: PLinkedListRec): boolean; virtual;
  end;
  procedure DestroyList(var list: PLinkedListRec);
  procedure SortList(var oldlist: PLinkedListRec);

type
  TLinkedList = class
    next: TLinkedList;

    constructor NewRec;
    constructor NewSortedRec(var list: TLinkedList);
    constructor NewHeadRec(var list: TLinkedList);
    constructor NewTailRec(var list: TLinkedList);
    procedure InitRec; virtual;
    procedure DestroyRec(var list: TLinkedList); virtual;
    function before(a,b: TLinkedList): boolean; virtual;
  end;
  procedure DestroyLinkedList(var list: TLinkedList);
  procedure SortLinkedList(var oldlist: TLinkedList);

type
  PModuleRec = ^TModuleRec;
  TModuleRec = record
    hModule: THandle;
    DLLName: string;
    next: PModuleRec;
  end;
const ModuleList: PModuleRec = nil;

type
  PBGRQuad = ^TBGRQuad;
  TBGRQuad = packed record
    bgrR: Byte;
    bgrG: Byte;
    bgrB: Byte;
    bgrReserved: Byte;
  end;

  T2DArray = array of TArrayofDouble;
  T3DArray = array of T2DArray;

type TWaveHeaderRec = record
      RIFF: array[1..4] of char;  { 'RIFF' }
      filesize: longint;          { total size from next field onwards }
      WAVE: array[1..4] of char;  { 'WAVE' }
      fmtb: array[1..4] of char;  { 'fmt ' }
      hdrsize:  longint;          { = 16 bytes }
      format: word;               { 1 }
      Channels: word;             { 1 or 2 }
      SamplesPerSec: longint;     { e.g. 22050 }
      AvgBytesPerSec: longint;    { e.g. 22050 }
      BlockAlignment: word;       { e.g. 1 }
      BitsPerSample: word;        { e.g. 8 1..8 = unsigned byte, >8 = signed }
    end;
    TDataHeaderRec = record
      data: array[1..4] of char;  { 'data' }
      datasize: longint;          { data from next field onwards }
    end;

{numeric/text functions}
function NumStr(l,len: longint): string;
function DoubleStr(r: Double; NumLength: integer; Accuracy: Double; truncate: boolean): string;
function DoubleStrDP(r: Double; NumLength: integer; Accuracy: Double; truncate: boolean): string;
function DoubleToStr(r: Double; NumLength: integer; Accuracy: Double; truncate: boolean): string;
function FixedPointStr(r: Double; AfterDP: integer): string;
function FixedPointStrDP(r: Double; AfterDP: integer): string;
function FixedPointStrTruncate(r: Double; AfterDP: integer): string;
function FixedLengthStr(r: Double; Len: integer): string;
function StrToDouble(s: string; var i: Double; ReportError: boolean): boolean;
function StrToDoubleDef(const S: string; Default: Double): Double;
function StrToFloatDP(const s:string): single;
function MyStrToInt(const s: string; var i: integer; ReportError: boolean): boolean;
function StrToLongint(const s: string; var i: longint; ReportError: boolean): boolean;
function StrToWord(const s: string; var i: word; ReportError: boolean): boolean;
function HexDigitsToStr(s: string): string;
function StrToHexDigits(s: string): string;
function HexDigitsToInt(s: string): string;
function IntToHexDigits(s: string): string;
{function StrToHexBytes(const s: string): string; /// use StrToHexDigits}
function StrToHexDigits2(s: string): string;
function HexDigitsToStr2(s: string): string;
function StrToBinDigits(s: string): string;
function LongStrToNumber(s: string; var i: longint; radix: integer; ReportError: boolean): boolean;
function LongStrToHex(s: string; var i: longint; ReportError: boolean): boolean;
function LongStrToBin(s: string; var i: longint; ReportError: boolean): boolean;
function DWordStrToBin(s: string; var i: DWord; ReportError: boolean): boolean;
function StrToHex(const s: string; var i: word; ReportError: boolean): boolean;
function StrToHexInt(const s: string; var i: integer; ReportError: boolean): boolean;
function StrToHexDef(const s: string; default: longint): longint;
function LongStrToOct(s: string; var i: longint; ReportError: boolean): boolean;
function StrToOct(const s: string; var i: word; ReportError: boolean): boolean;
function StrToBin(const s: string; var i: word; ReportError: boolean): boolean;
function StrToBinDef(const s: string; default: word): word;
function BinToStr(w: longint; l: integer): string;
function IntToBin(w: longint; l: integer): string;
function IntToNumber(w: longint; l,radix: integer): string;
function DWordToNumber(w: DWord; l,radix: integer): string;
function StrToBool(const S: string): Boolean;
function StrToBoolDef(const S: string; Default: boolean): boolean;
function IncrementSuffix(s,separator: string): string;
function DecrementSuffix(s,separator: string): string;
function IncDecSuffix(s,separator: string; d: integer): string;
function RemoveTrailingDigits(s: string): string;
procedure Quicksort(var arr: array of integer);

{text functions}
function DataToString(var Data; len: longint): string;
function IntDataToString(i: longint): string;
function StringDataToString(s: string): string;
function DoubleDataToString(i: Double): string;
function SingleDataToString(i: Single): string;
procedure StringToData(var s: string; var Data; len: longint);
function StringToIntData(var s: string): longint;
function StringToIntDataReverse(var s: string): longint;
function StringToDoubleData(var s: string): Double;
function StringToStringData(var s: string): string;
function StrToPChar(s: string): PChar;
//function PasStrIComp(s1,s2: string): integer;
function encode(s: string): string;
function decode(s: string): string;
function encodeMinLen(s: string; minLength: integer; Terminate: char): string;
function decodeMinLen(s: string; Terminate: char): string;
function GetStringTable(ID: Word; const default: string): string255;
function MyPos(c: char; s: string; IgnoreIfInQuotes: boolean): integer;
function MyPosStr(substr,s: string; IgnoreIfInQuotes: boolean; n: integer): integer;
function MyPosIdentifier(substr,s: string; IgnoreIfInQuotes: boolean): integer;
function CountSubstr(s,substr: string): integer;
function StrBefore(s: string; n: integer; c: string; IgnoreIfInQuotes: boolean): string;
function StrAfter(s: string; n: integer; c: string; IgnoreIfInQuotes: boolean): string;
function Before(s: string; c: string): string;
function After(s: string; c: string): string;
function Between(s: string; c1,c2: string): string;
function BetweenEx(s: string; c: string; n: integer): string;
function StrReplace(s: string; const SubStr1,SubStr2: string; All: boolean): string;
function StrReplaceEx(s: string; const SubStr1,SubStr2: string; All,IgnoreCase: boolean): string;
function RemoveChar(s: string; c: char): string;
function StrReplaceIdentifier(s: string; const SubStr1,SubStr2: string; All: boolean): string;
function MemoryToString(var mem; size: integer): string;
procedure StringToMemory(s: string; var mem);
function DlgGetSetEdit(aControl: TEdit; value: string; Get: boolean): string;
function Capitalise(s: string): string;
function CapitaliseWords(s: string): string;
function CapitaliseFirst(s: string): string;
function ReverseStr(s: string): string;
function LPad(const s: string; len: integer): string;
function RPad(const s: string; len: integer): string;
function LPadC(const s: string; len: integer; c: char): string;
function RPadC(const s: string; len: integer; c: char): string;
function BoolToStr(b: boolean): string;
function BoolStr(sT,sF: string; b: boolean): string;
procedure AddLineToMemo(Memo1: TMemo; const s: string; MaxLines: integer);
function UpString(const s: string): string;
function GetRichEditRTFStr(RichEdit1: TRichEdit): string;
procedure SetRichEditRTFStr(RichEdit1: TRichEdit; str: string);
function GetDirDateModified(DirName: string): TDateTime;
function RemoveTrailingBackslash(const s: string): string;
function RemoveTrailingChar(const s: string; c: char): string;
function RemoveNonNumerics(const s: string): string;
procedure SetScreenCursorFilex(Filename: string; default: TCursor);
procedure SetCursorFile(Control: TControl; Filename: string; default: TCursor);
function StrToAlignDef(const S: string; Default: TAlign): TAlign;
function StrToAlignmentDef(const S: string; Default: TAlignment): TAlignment;
function StrToPanelBevelDef(const S: string; Default: TPanelBevel): TPanelBevel;
procedure SortStrings(Strings: TStrings);
function scramble(s: string): string;
function RandomiseName(name: string50): longint;
procedure SetStringAssoc(index,value: String; var assoc: String);
function GetStringAssoc(index: String; assoc: string): string;
function GetStringAssocIndex(i: integer; var assoc: string): string;
function Printable(c: string): string;
function MessageToString(msg: integer): string;
function URLEncode(c: string): string;
function SplitString(s: String; delimiter: char): TStringList;

{Stream functions}
procedure StreamReadLnInit;
function ReadInt(Stream: TStream): integer;
procedure WriteInt(Stream: TStream; i: integer);
procedure WriteWord(Stream: TStream; i: word);
function ReadBool(Stream: TStream): boolean;
procedure WriteBool(Stream: TStream; i: boolean);
function LoadSaveInt(Load: boolean; Stream: TStream; i: integer): integer;
function LoadSaveBool(Load: boolean; Stream: TStream; i: Boolean): Boolean;
function ReadStr(Stream: TStream): string;
procedure WriteStr(Stream: TStream; s: string);
function LoadSaveStr(Load: boolean; Stream: TStream; s: string): string;
procedure StreamWriteLnInt(Stream: TStream; i: integer);
procedure StreamWriteInt(Stream: TStream; i: integer);
function StreamReadLnInt(Stream: TStream): integer;
function StreamReadLnEOF(Stream: TStream): boolean;
procedure StreamWrite(Stream: TStream; s: string);
procedure StreamWriteLn(Stream: TStream; s: string);
function StreamReadLn(Stream: TStream): string;
function StreamReadStr(Stream: TStream; len: integer): string;

{File functions}
function CheckFileIntegrity: boolean;
function AppendFile(var f: File; Source: string): Boolean;
function ExtractFile(var f: File; Dest: string; Size: longint): boolean;
function GetFileSize(const FileName: string): longint;
function GetFileAttr(const FileName: string): DWORD;
procedure SetFileAttr(const FileName: string; dwFileAttributes: DWORD);
function FileExtIs(Filename,ext: string): Boolean;
function AddPathToFile(const Path: string; const Filename: string): string;
function ChangeToExePath(const Filename: string): string;
function NullPathToExePath(const Filename: string): string;
function MyExtractFilePath(const FileName: string): string;
function RemoveBadFilenameChars(const s: string): string;
function CanOverwrite(const FileName: string): Boolean;
function ShortPathName(Filename: string): string;
function oldEraseFile(Filename: string): Boolean;
function EraseFile(handle: hWnd; Filename: string; query: boolean): boolean;
function oldEraseFiles(filter: string): Boolean;
function EraseFiles(dir,filter: string): Boolean;
function oldRename(oldname,newname: string): Boolean;
function CopyFile(const Source,Dest: string; CopyAttrs: boolean): boolean;
procedure CopyFileExcept(const Source,Dest: string; CopyAttrs: boolean);
function CopyFileToDir(handle: hWnd; const Source,newDir: string): Boolean;
function RenameFile(handle: hWnd; Source,newName: string): Boolean;
function CopyFiles(Sourcedir,destdir,filter: string; CopyAttrs: boolean): boolean;
procedure FindFiles(Strings: TStrings; filter: string; FullPath: boolean);
procedure FindFilesEx(Strings: TStrings; filter: string; FullPath,Files,Directories: boolean);
procedure FindFilesEx2(Strings: TStrings; filter: string; FullPath,Files,Directories: boolean; Attr: Integer);
procedure FindFilesEx3(Strings: TStrings; filter: string; FullPath,Files,Directories,SearchSubdirs: boolean; Attr: Integer);
procedure FindFilesInSubdir(Strings: TStrings; filter: string; FullPath: boolean);
function MoveFile(handle: hWnd; Filename,newDir: string): Boolean;
function GetFileCRC(const Filename: string; shift: integer): word;
function FilesExist(filter: string): Boolean;
function GetFileDate(FileName: string): TDateTime;
procedure SetFileDate(FileName: string; date: TDateTime);
procedure SaveToFileString(FileName,s: string);
procedure StringToFile(FileName,s: string);
{function LoadFromFile(const FileName: string): string; use LoadFromFileString }
function LoadFromFileString(FileName: string): string;
function FileToString(FileName: string): string;
function FileToStringEx(FileName: string; maxlen: integer): string;
procedure ReadFileBlock(Filename: string; var buf; start,len: integer);
procedure WriteFileBlock(Filename: string; var buf; len: integer);
function DirSize(const Path: string; IncludeSubdirs: boolean): longint;
function TidyPath(const Path: string): string;
function GetShortPath(Path: string): string;
function GetFullPath(Path: string): string;
procedure MakeDirectories(Path: string);
function IsDirectory(filename: string): boolean;
function DirExists(dir: string): Boolean;
function GetSpecialFolderPath(Folder: Integer; CanCreate: Boolean): string;
                                                         
{System functions}
function ExecAssociation(Filename: string): hinst;
function ExecAssociationEx(Filename: string): hinst;
function ExecAssociation2(Filename,params: string): hinst;
function ExecAssociation2Ex(Filename,params: string): hinst;
function WinExecError(hModule: THandle): string;
function RunProgram(const CommandLine: string): THandle;
function RunProgramEx(CommandLine: string; CmdShow: Word): THandle;
function LastError: string;
function IOErrorMsg(err: integer): string;
function DLLLoaded(s: string): THandle;
function LoadDLL(s: string): THandle;
procedure ShowLongint(const s: string; value: longint);
function FormExists(fm: TForm): boolean;
function NameToComponent(const name: string; Form: TForm): TComponent;
function ComponentToText(Component: TComponent): String;
function GetRegistrationEntry(Root: HKEY; Key,SubKey: string): string;
procedure SetRegistrationEntry(Root: HKEY; Key,Value: string);
//procedure BDEModifyLeaf(sSelectedNode,sMyPath,sMyValue: string);
function WinExecAndWait32(FileName:string; Visibility : integer): DWord;
function WinExecNoWait32(FileName:string; Visibility : integer): DWord;
procedure Delay(msecs: integer);
procedure DelayNoYield(msecs: integer);
function MessageString(msg: word): string;
function GetProfileLongint(AppName, KeyName: PChar; Default: longint): Longint;
procedure MyYield(loop: boolean);
function GetShift: TShiftState;
function WindowRespondsToMsg(hWindow: HWnd; msg,wParam: word): THandle;
function IsWin95: boolean;
function InstanceExists(instance: THandle): boolean;
function CheckForString(s: pChar; Key: Char): boolean;
function TransformPoint(Source,Dest: TControl; const Point: TPoint): TPoint;
function CursorInControl(Control: TControl): TPoint;
function IsCursorInControl(Control: TControl): boolean;
function mmErr(i: MMRESULT): boolean;
function WindowWithClassName(xhWindow: hWnd; p: pChar; recurse: boolean): THandle;
function LoadDLLProc(DLL: string255; name: string255; ReportError: boolean): pointer;
procedure FreeDlls;
function CopyFont(Font: TFont; angle: integer): TLogFont;
function TextToClipboard(pText: pChar): boolean;
function TextToClipboardWin(pText: pChar; hWindow: hWnd): boolean;
procedure StringsToClipboard(Strings: TStrings);
procedure WindowToClipboard(hWindow: hWnd);
procedure CanvasToClipboard(Canvas: TCanvas);
procedure PrivateFromClipboard(id: pChar; var hData: THandle; var DataSize: word);
function PrivateToClipboard(id: pChar; Data: pointer; DataSize: word): boolean;
procedure PrintStrings(Strings: TStrings; FontSize: integer;
  FontStyle: TFontStyles; const FontName: string);
function CreateAndGetFont(FaceName: PChar; size: integer;
    bold,Italic,Underline,StrikeOut: boolean; angle: integer): HFont;
function DelphiIsRunning : boolean;
procedure ClipCursorControl(Control: TControl);
function MyGetTickCount: integer;
function TimeDiff(t1,t2: integer): integer;
function TimeSince(t2: integer): integer;
function GetVolumeNum: longint;
function YesNoBox(const APrompt: string): Boolean;
function YesNoCancelBox(const APrompt: string): TModalResult;
procedure ShowErrorMessage(const APrompt: string);
procedure ShowInformationMessage(const APrompt: string);
procedure ShowWarningMessage(const APrompt: string);
function InputBox(const ACaption, APrompt, ADefault: string): string;
function InputMemo(const ACaption, APrompt, ADefault: string): string;
function InputQuery(const ACaption, APrompt: string; var aValue: string): Boolean;
procedure CreatePopupMenuList(aMenu: TPopupMenu; StringList: TStrings; Click: TNotifyEvent);
procedure CreateSubMenuList(aMenu: TMenuItem; StringList: TStrings; Click: TNotifyEvent);

function NearestSecond(Time: TDateTime): TDateTime;
function ForceDateToCentury(d: TDateTime; CenturyStarts: integer): TDateTime;
function ThisYear: Word;
procedure DateDiff(d1,d2: TDateTime; var Year, Month, Day: Word);
function DateTimeToUnix(ConvDate: TDateTime): Longint;
function UnixToDateTime(USec: Longint): TDateTime;

{Maths functions}
function ArcTan2(opp,adj: Double): Double;
function Tan(x: Double): Double;
function ArcSin(x: Double): Double;
function ArcCos(x: Double): Double;
function cube(a: double): double;
function CubeRoot(a: double): double;
function cot(x: double): double;
function SafeTrunc(x: Double; max: longint): longint;
function SafeRound(x: Double; max: longint): longint;
function IntTrunc(x: Double): integer;
function ClipToByte(x: integer): byte;
function WordTrunc(x: Double): word;
function IntRound(x: Double): integer;
function Ceiling(x: Double): integer;
function Floor(x: Double): integer;
function RoundUp(i,granularity: integer): integer;
function RoundDown(i,granularity: integer): integer;
function RoundEx(i: single; granularity: integer): integer;
function IntMin(const a: array of longint): longint;
function IntMax(const a: array of longint): longint;
function IntRange(a,min,max: longint): longint;
function ByteRange(a: longint): byte;
function InRange(a,min,max: longint): boolean;
function RealRange(a,min,max: double): double;
function InRealRange(a,min,max: double): boolean;
function DoubleMin(const a: array of Double): Double;
function DoubleMax(const a: array of Double): Double;
procedure SetMinMax(i: integer; var amin,amax: integer);
procedure SetMinMaxDouble(i: Double; var amin,amax: Double);
procedure SetMinMaxSingle(i: Single; var amin,amax: Single);
function Sign(a: longint): longint;
function DblSign(a: double): double;
function Cosh(x: double): double;
function Sinh(x: double): double;
function Pythag(x,y: double): double;
procedure UnitLength(var x,y: double);
procedure UnitLength3d(var x,y,z: double);
function Pythag3d(x,y,z: double): double;
function log(a: double): double;
function alog(a: double): double;
function pwr(a,b: double): double;
function Scale_1_2_5(a: double): double;
function float(a: double): double;
procedure FillRandom(var X; Count: Integer);
function safeDivide(a,b: Double): Double;
function safeDiv(a,b: integer): integer;
function RealMod(a,b: Double): Double;
function TwoPiRange(a: Double): Double;
function CalcCRC16(s: string): word;
function CalcCRC32(s: String): dword;
function CalcCRC32b(s: String): dword;
function CalcCRC32c(s: String): dword;
function UniqueNumber: integer;
function GetVolumeSerialNumber(const DriveLetter: Char): DWORD;
procedure SortSingle(var a: TArrayofSingle);
procedure SortInteger(var a: Array of Integer);
procedure Swap(var a,b: Integer);
procedure SwapSingle(var a,b: Single);
procedure SwapStr(var a,b: String);
procedure SwapObj(var a,b: TObject);
procedure RegressionInit;
procedure RegressionData(x,y,z: double);
procedure RegressionAnswer(var a,b,c: double);
procedure RegressionNInit;
procedure RegressionNData(x: array of double);
procedure RegressionNDataW(x: array of double; Weight: double);
function RegressionNAnswer(var ans: array of double): boolean;
function Det3x3(A: TMatrix3X3): Single;
procedure CubicCoeff(var DataPoint: Array of TSinglePoint; var a,b,c,d: Single);
procedure QuadraticCoeff(var DataPoint: Array of TSinglePoint; var a,b,c: Single);
procedure LinearCoeff(var DataPoint: Array of TSinglePoint; var a,b: Single);
procedure CubicCoeffC(DataPoint: Array of TSinglePoint; var a,b,c,d: Single);
procedure QuadraticCoeffC(DataPoint: Array of TSinglePoint; var a,b,c: Single);
procedure LinearCoeffC(DataPoint: Array of TSinglePoint; var a,b: Single);
function InvertMatrix(matrix: T2DArray): T2DArray;
function MultMatrixMatrix(A,B: T2DArray): T2DArray;
function MultMatrixVector(A: T2DArray; B: TArrayofDouble): TArrayofDouble;
function DotProductVector(A,B: TArrayofDouble): double;
function Make1DArray(x: integer): TArrayofDouble;
function Make2DArray(x,y: integer): T2DArray;
function Make3DArray(x,y,z: integer): T3DArray;
function CopyMatrix(B: T2DArray): T2DArray;
procedure T_Test(mean1,mean2,var1,var2: double; n1,n2: integer; var t: double; var dof: integer);
function Mean(sx,n: double): double;
function Variance(sx,sxx,n: double): double;
function StandardDeviation(sx,sxx,n: double): double;
function Skew(sx,sxx,sxxx,n: double): double;
function Skewness(sx,sxx,sxxx,n: double): double;
FUNCTION IsNanDouble(CONST d: DOUBLE): BOOLEAN;
FUNCTION IsInfinityDouble(CONST d: DOUBLE): BOOLEAN;
FUNCTION IsNanSingle(CONST d: Single): BOOLEAN;
FUNCTION IsInfinitySingle(CONST d: Single): BOOLEAN;
function gaussian_eliminate(var a: T2DArray): boolean;
function CountSet(s: TSetOfByte): Byte;

{Graphics functions}
procedure DrawFilledQuad(Canvas: TCanvas; x1,y1,x2,y2,x3,y3,x4,y4: integer; col: TColor);
procedure DrawFilledQuadPt(Canvas: TCanvas; a1,a2,a3,a4: TPoint; col: TColor);
procedure DrawFilledTrian(Canvas: TCanvas; x1,y1,x2,y2,x3,y3: integer; col: TColor);
procedure DrawHatchPolygon(aCanvas: TCanvas; p: array of TPoint; NS,EW,NE,NW: integer);
procedure FillPoly(Canvas: TCanvas; Poly1: array of TPoint);
procedure DrawLine(aCanvas: TCanvas; x1,y1,x2,y2: integer);
procedure DrawLineP(aCanvas: TCanvas; p1,p2: TPoint);
procedure DrawLineSP(aCanvas: TCanvas; p1,p2: TSinglePoint);
procedure DrawDottedLine(aCanvas: TCanvas; x1,y1,x2,y2,pattern: integer);
procedure DrawDottedRect(aCanvas: TCanvas; x1,y1,x2,y2,pattern: integer);
procedure DrawArrow(aCanvas: TCanvas; x1,y1,x2,y2,HeadLen,HeadWidth: integer);
procedure OutlineRect(aCanvas: TCanvas; x1,y1,x2,y2: integer);
procedure OutlineTRect(aCanvas: TCanvas; rect: TRect);
procedure FillHatchedRect(aCanvas: TCanvas; x1,y1,x2,y2,period: integer);
procedure FillHatchedTRect(aCanvas: TCanvas; rect: TRect; period: integer);
procedure DrawPlus(aCanvas: TCanvas; x,y,size: integer);
procedure DrawX(aCanvas: TCanvas; x,y,size: integer);
procedure DrawSquare(aCanvas: TCanvas; x,y,size: integer);
procedure DrawSquareFilled(aCanvas: TCanvas; x,y,size: integer);
procedure DrawCircle(aCanvas: TCanvas; x,y,size: integer);
procedure DrawCircleFilled(aCanvas: TCanvas; x,y,size: integer);
procedure DrawCircleEx(aCanvas: TCanvas; x1,y1,x2,y2: integer);
procedure DrawDiamond(aCanvas: TCanvas; x,y,size: integer);
procedure DrawStar(Canvas: TCanvas; cx,cy,r1,r2,ang: single; n: integer);
procedure DrawEllipseTheta(Canvas: TCanvas; cx,cy,major,minor,sinA,cosA: single; DrawAxes: boolean);
procedure zigzag(Canvas: TCanvas; x1,y1,x2,y2,w: single; n: integer);
procedure CircleThroughThreePoints(p1,p2,p3: TPoint; var c: TPoint; var r: single);
procedure DrawArcThroughThreePoints(Canvas: TCanvas; p1,p2,p3: TPoint);
procedure MaskedDraw(Canvas: TCanvas; xDest,yDest: integer; img: TImage; xSrc,ySrc,Width,Height: integer);
procedure DrawTransparent(Canvas: TCanvas; xDest,yDest: integer; Bitmap: graphics.TBitmap; col: TColor);
procedure RotatedTextOut(Canvas: TCanvas; X, Y: Integer; const Text: string;
  Angle: integer);
procedure RotatedTextOutOld(Canvas: TCanvas; X, Y: Integer; const Text: string;
  Angle,BkMode: integer);
procedure RotatedTextInRect(Canvas: TCanvas; Text: string; Angle: integer; aRect: TRect);
procedure RotatedTextNew(Canvas: TCanvas; x,y: integer; Text: string; Angle: integer);
procedure DrawTriangle(aCanvas: TCanvas; x,y,size: integer);
procedure RotatedTextOutFont(Canvas: TCanvas; X, Y: Integer; const Text: string; Angle: integer; Font: TFont);
procedure DrawSmoothLine(Canvas: TCanvas; Points: array of TPoint);
procedure DrawSmoothQuadratic(Canvas: TCanvas; p0,p1,p2: TPoint);
procedure TextOutEx(aCanvas: TCanvas; x,Y: integer; const Text: string; xAlign,yAlign: integer);
function RectPt(LeftTop,RightBottom: TPoint): TRect;
function MyUnionRect(Src1Rect, Src2Rect: TRect): TRect;
function MyIntersectRect(Src1Rect, Src2Rect: TRect): TRect;
function RectOverlap(Rect1,Rect2: TRect): boolean;
function RectOverlapMargin(Rect1,Rect2: TRect; Margin: integer): boolean;
function RectOverlapMargin2(Rect1,Rect2: TRect; xMargin,yMargin: integer): boolean;
function RectCircleOverlap(Rect1: TRect; xc2,yc2,r2: integer): boolean;
function RectLineOverlap(Rect1: TRect; xa2,ya2,xb2,yb2: integer): boolean;
function RectPolyOverlap(Rect1: TRect; Poly2: array of TPoint): boolean;
function CircleOverlap(xc1,yc1,r1: integer; xc2,yc2,r2: integer): boolean;
function CircleLineOverlap(xc1,yc1,r1: integer; xa2,ya2,xb2,yb2: integer): boolean;
function CirclePolyOverlap(xc1,yc1,r1: integer; Poly2: array of TPoint): boolean;
function LineOverlap(xa1,ya1,xb1,yb1, xa2,ya2,xb2,yb2, w: integer): boolean;
function LinePolyOverlap(xa1,ya1,xb1,yb1: integer; Poly2: array of TPoint): boolean;
function PolyOverlap(Poly1: array of TPoint; Poly2: array of TPoint): boolean;
function SortRect(Rect: TRect): TRect;
procedure ScaleRect(var lprc: TRect; dx, dy: double);
function MyOffsetRect(aRect: TRect; dx, dy: integer): TRect;
function MyInflateRect(aRect: TRect; dx, dy: integer): TRect;
function DistPointToLine(p,p1,p2: TPoint): double;
function DistPointToLineInfinite(p,p1,p2: TPoint): double;
function DistSinglePointToLine(p,p1,p2: TSinglePoint): double;
function DistPointToPoint(p1,p2: TPoint): double;
function DistSinglePointToPoint(p1,p2: TSinglePoint): double;
function NearestPointOnLineToPoint(p,p1,p2: TPoint): TPoint;
function NearestSinglePointOnLineToPoint(p,p1,p2: TSinglePoint): TSinglePoint;
function NearestSinglePointOnLineToPointEx(p,p1,p2: TSinglePoint; var t: single): TSinglePoint;
function NearestSinglePointOnLineToPointUnclipped(p,p1,p2: TSinglePoint; var t: single): TSinglePoint;
function AddPoints(p1,p2: TPoint): TPoint;
function SubPoints(p1,p2: TPoint): TPoint;
function textheight(DC: HDC): word;
function textwidth(DC: HDC; const s: string): word;
procedure BitmapToBitmap(DC: hDC; Source,dest: THandle; xDest,yDest,w,h,xSrc,ySrc: integer);
function CopyBitmap(DC: HDC; src: HBitmap): HBitmap;
procedure BitmapSize(Bitmap: hBitmap; var w,h: integer);
procedure BitmapToDCEx(DC: hDC; Bitmap: THandle; x,y,w,h,xSrc,ySrc: integer;
      ROP2: longint);
procedure BitmapToDC(DC: hDC; Bitmap: THandle; x,y,w,h,xSrc,ySrc: integer);
function Red(color: TColor): integer;
function Green(color: TColor): integer;
function Blue(color: TColor): integer;
function ColorToGrey(col: TColor): TColor;
function ColorToSilver(col: TColor; Invert: boolean): TColor;
function LightenColor(c: TColor; lighter: boolean): TColor;
function LightenColorEx(c: TColor; i: integer): TColor;
function DarkenColorEx(c: TColor; i: integer): TColor;
function ContrastColor(col: TColor): TColor;
function GradeColor(col,bg: TColor; a: single): TColor;
procedure Meet(p1,p2: TSinglePoint; l1,l2: single; var ans: TSinglePoint);
function SinglePoint(x,y: Single): TSinglePoint;
function AddSP(p1,p2: TSinglePoint): TSinglePoint;
function SubSP(p1,p2: TSinglePoint): TSinglePoint;
function TurnSP(p: TSinglePoint; a: single): TSinglePoint;
function cwOrthog(p: TSinglePoint): TSinglePoint;
function ccwOrthog(p: TSinglePoint): TSinglePoint;
function UnitVector(p: TSinglePoint): TSinglePoint;
function ScaleVector(p: TSinglePoint; scale: single): TSinglePoint;
function ScaleSP(p: TSinglePoint; scale: single): TSinglePoint;
function AddVector(p,q: TSinglePoint): TSinglePoint;
function SubVector(p,q: TSinglePoint): TSinglePoint;
function MultVector(p,q: TSinglePoint): TSinglePoint;
function DotProduct(a,b: TSinglePoint): double;
function a3DPoint(x,y,z: Single): T3DPoint;
function Int3DPoint(x,y,z: integer): TInt3DPoint;
function MeanPoint3D(p: array of T3DPoint): T3DPoint;
function Dist3D(a,b: T3DPoint): Single;
function Length3D(a: T3DPoint): Single;
function Sub3D(a,b: T3DPoint): T3DPoint;
function Scale3D(a: T3DPoint; b: single): T3DPoint;
function Normalise3D(nrm: T3DPoint): T3DPoint;
function CrossProduct3D(left,right: T3DPoint): T3DPoint;
function DotProduct3D(a,b: T3DPoint): single;
function Transform3D(origin,u,v,w,p: T3DPoint): T3DPoint;
function UnTransform3D(origin,u,v,w,p: T3DPoint): T3DPoint;
procedure DrawPoly3D(Canvas: TCanvas; p: array of T3DPoint);
function Add3D(a,b: T3DPoint): T3DPoint;
function NearestPointsOnLines3D(a1,a2,b1,b2: T3DPoint; var t,u: single; var j,k: T3DPoint): boolean;
function NearestPointOnLineToPoint3D(p,p1,p2: T3DPoint): T3DPoint;
function DistPointToLine3D(p,p1,p2: T3DPoint): single;
function FaceNormal3D(vertices: array of T3DPoint): T3DPoint;
function FaceCenter3D(vertices: array of T3DPoint): T3DPoint;
procedure Extend(p1,p2: TSinglePoint; l: single; var ans: TSinglePoint);
function DistPointToPlane(pt: T3DPoint; pl: TPlane): single;
function PlaneThroughThreePoints(p1,p2,p3: T3DPoint): TPlane;
function PlaneThroughManyPoints(p: array of T3DPoint): TPlane;
function NearestPointOnPlaneToPoint(pt: T3DPoint; pl: TPlane): T3DPoint;
function IntersectionOfLineAndPlane(LineA,LineB: T3DPoint; pl: TPlane): T3DPoint;
function ClosestApproachOfTwoLines(LineA1,LineA2,LineB1,LineB2: T3DPoint; var pA,pB: T3DPoint): boolean;
function PlaneThroughPointParallelToPlane(pt: T3DPoint; pl: TPlane): TPlane;
function PlaneThroughPointNormalToLine(LineA,LineB,pt: T3DPoint): TPlane;
function Dist(p2,p4: TSinglePoint): single;
function DistPoints(p2,p4: TPoint): single;
function LengthVector(p: TSinglePoint): single;
function side(xp,yp,x1,y1,x2,y2: Double): Double;
function sideI(xp,yp,x1,y1,x2,y2: integer): integer;
function sidePoint(p,p1,p2: TSinglePoint): Double;
function sideTPoint(p,p1,p2: TPoint): integer;
function IntersectCircles(p1: TSinglePoint; var p2,knee: TSinglePoint; r1,r2,accy: single; side: boolean): integer;
function DoubleJoint(p1: TSinglePoint; var p2,knee,ankle: TSinglePoint; r1,r2,r3,accy: single; side1,side2: boolean): integer;
function ColorName(Color: Longint): string;
function ClipRGB(R,G,B: Longint): TColor;
function LinesCross(xk,yk,xl,yl,xm,ym,xn,yn: Double; var xa,ya,s,t: Double): boolean;
function LinesCrossNoClip(xk,yk,xl,yl,xm,ym,xn,yn: Double; var xa,ya,s,t: Double): boolean;
function LinesCrossNoClipI(xk,yk,xl,yl,xm,ym,xn,yn: integer; var xa,ya: integer): boolean;
function LinesCrossNoClipSP(k,l,m,n: TSinglePoint; var a: TSinglePoint; var s,t: Double): boolean;
function LinesCrossNoClipTP(k,l,m,n: TPoint; var a: TPoint): boolean;
function LinesCrossTP(k,l,m,n: TPoint; var a: TPoint): boolean;
function LinesCrossSP(k,l,m,n: TSinglePoint; var a: TSinglePoint): boolean;
function bLinesCross(xk,yk,xl,yl,xm,ym,xn,yn: Double): boolean;
function EqPoints(p1,p2: TPoint): boolean;
function EqSinglePoints(p1,p2: TSinglePoint; delta: single): boolean;
function PointToSinglePoint(p: TPoint): TSinglePoint;
function SinglePointToPoint(p: TSinglePoint): TPoint;
procedure ProjectInit(cx1,cy1,cz1, wx1,wy1,wz1: single);
procedure ProjectInitOfs(u,v: single);
procedure ProjectInitZoom(zm: single);
function Project3D(x,y,z: single): TSinglePoint;                 
function AreaInt(var Points: TArrayofTPoint): integer;
function AreaInt3(Points: Array of TPoint): integer;
function ClockwiseInt(var Points: TArrayofTPoint): integer;
function AreaSingle(Points: Array of TSinglePoint): Single;
function Area3D(Points: Array of T3DPoint): Single;
function AreaTriangle3D(p1,p2,p3: T3DPoint): Single;
function AreaQuad3D(p1,p2,p3,p4: T3DPoint): Single;
function ClockwiseSingle(var Points: Array of TSinglePoint): integer;
function TetrahedronVolume(x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4: single): single;
function TetrahedronVolumeP(p1,p2,p3,p4: T3DPoint): single;
function AffineCoeffs(p1,p2,p3,q1,q2,q3: TSinglePoint): TAffineMatrix;
function AffineMultiply(m1,m2: TAffineMatrix): TAffineMatrix;
function AffineApply(m: TAffineMatrix; p: TSinglePoint): TSinglePoint;
function AffineInverse(m: TAffineMatrix): TAffineMatrix;
function AreaInt2(Points: TArrayofTPoint): integer;
function ClockwiseInt2(Points: TArrayofTPoint): integer;
{function AreaSingle2 - use AreaSingle}
function ClockwiseSingle2(Points: Array of TSinglePoint): integer;
function PolarToCartesian(r,a: single): TSinglePoint;
function PointInsidePolygonSingle(pt: TSinglePoint; C: Array of TSinglePoint): boolean;
function PointInsidePolygon(pt: TPoint; var C: Array of TPoint): boolean;
function PtInPolygon(pt: TPoint; Points: array of TPoint): boolean;
function SinglePointInPolygon(pt: TSinglePoint; Points: array of TSinglePoint): boolean;
function PointInsideTriangleSingle(pt,p1,p2,p3: TSinglePoint): boolean;
function IntersectPoly(Points,ClipPoly: array of TPoint): TarrayofTPoint;
function PolyIsConvex(Points: array of TPoint): boolean;
procedure PrincipalAxis(var DataPoint: Array of TSinglePoint; var a,b: TSinglePoint; var e: single);
procedure BezierToCoeff(Q: Array of TSinglePoint; var a,b,c,d: TSinglePoint);
function CoeffToBezier(a,b,c,d: TSinglePoint): TArrayofTSinglePoint;
procedure DrawBezierCoeff(Canvas: TCanvas; a,b,c,d: TSinglePoint);
procedure DrawBezierKnots(Canvas: TCanvas; k1,c1,c2,k2: TSinglePoint);
function SingleRect(ALeft, ATop, ARight, ABottom: single): TSingleRect;
function SingleRectToRect(aRect: TSingleRect): TRect;
function PolyBoundingRect(Points: array of TPoint): TRect;
function LineInDottedRect(x1,y1,x2,y2: integer; Rect: TRect): boolean;
function LineInDottedRectP(p1,p2: TPoint; Rect: TRect): boolean;
function ClipLineToRect(var x1,y1,x2,y2: integer; rect: TRect): boolean;
function CoGPoly(Poly1: array of TPoint): TSinglePoint;

{Syntax functions}
function NextIs(var s: string; const substr: string): Boolean;
function PeekIs(var s: string; const substr: string): boolean;
function NextIsFixed(var s: string; const substr: string): Boolean;
function NextIsCharSet(var s: string; cset: TSetOfChar; var c: char): boolean;
function NextIsId(var s: string; var id: string): Boolean;
function NextIsIdKeepCase(var s: string; var id: string): Boolean;
function NextIsIdNumeric(var s: string; var id: string): Boolean;
function NextIsIdNumericKeepCase(var s: string; var id: string): Boolean;
function NextIsString(var s: string; var str: string): Boolean;
function NextIsNumber(var s: string; var i: integer): boolean;
function NextIsSignedNumber(var s: string; var i: integer): boolean;
function NextIsHexNumber(var s: string; var i: integer): boolean;
function NextIsAnyNumber(var s: string; var i: integer): boolean;
function NextIsSignedDouble(var s: string; var i: Double): boolean;
function NextDouble(var s: string): Double;
function NextDoubleDef(var s: string; default: Double): Double;
function MustbeDouble(var s: string): Double;
function MustbeSignedDouble(var s: string): Double;
function NextWord(var s: string): string;
function NextNumber(var s: string): integer;
function NextNumberDef(var s: string; default: integer): integer;
function NextHexNumber(var s: string): integer;
function NextAnyNumber(var s: string): integer;
function NextHexNumberDef(var s: string; default: integer): integer;
procedure Mustbe(var s: string; const substr: string);
function MustbeId(var s: string): string;
function MustbeIdKeepCase(var s: string): string;
function MustbeString(var s: string): string;
function MustbeNumber(var s: string): integer;
function MustbeBool(var s: string): boolean;
function MustbeSignedNumber(var s: string): integer;
function NextIsIdAKeepCase(var s: string; var id: string): boolean;
function NextIsIdA(var s: string; var id: string): boolean;
function MustbeEFormat(var s: string): Double;
function NextIsExpression(var s: string; var i: double): boolean;
function NextExpression(var s: string): Double;
function NextExpressionDef(var s: string; default: double): double;
function MustbeExpression(var s: string): Double;
function SkipBlanks(s: string): string;
procedure SkipBlanksComments(var s: string);
function StripBlanks(const s: string): string;
function StripTrailingBlanks(const s: string): string;
function ConvertToAlpha(s: string; OtherChars: string): string;
function ConvertToAlphanum(s: string; OtherChars: string): string;
function ConvertToIdentifier(s,default: string): string;
function ConvertToIdentifierEx(s,default: string; OtherChars: string): string;
function RemoveNonHex(s: string): string;
function WindowsDirectory: string;
function AppDirectory: string;
function HasParameter(const s: string; whole: boolean): boolean;
function GetParameter(const s,default: string): string;
function GetParameterAfter(const s,default: string): string;
function KeyName(vk: integer): string;
function KeyNameEx(key: word): string;
function mmErrString(i: MMRESULT): string;
procedure SetSkipComments(b: boolean);
procedure SetSkipBlanks(b: boolean);
procedure SetSkipSlashStar(b: boolean);
function alpha(c: char): boolean;
function alphanum(c: char): boolean;
function digit(c: char): boolean;
function NextCharIs(var s: string; c: char): boolean;

function NextCharIsP(const sq: string; var ptr: integer; c: char): boolean;
function NextIsP(const sq: string; var ptr: integer; const substr: string): Boolean;
function PeekIsP(const sq: string; var ptr: integer; const substr: string): boolean;
function NextIsFixedP(const sq: string; var ptr: integer; const substr: string): Boolean;
function NextIsCharSetP(const sq: string; var ptr: integer; cset: TSetOfChar; var c: char): boolean;
function NextIsIdP(const sq: string; var ptr: integer; var id: string): Boolean;
function NextIsIdKeepCaseP(const sq: string; var ptr: integer; var id: string): Boolean;
function NextIsIdNumericP(const sq: string; var ptr: integer; var id: string): Boolean;
function NextIsIdNumericKeepCaseP(const sq: string; var ptr: integer; var id: string): Boolean;
function NextIsStringP(const sq: string; var ptr: integer; var str: string): Boolean;
function NextIsNumberP(const sq: string; var ptr: integer; var i: integer): boolean;
function NextIsSignedNumberP(const sq: string; var ptr: integer; var i: integer): boolean;
function NextIsHexNumberP(const sq: string; var ptr: integer; var i: integer): boolean;
function NextIsSignedDoubleP(const sq: string; var ptr: integer; var i: Double): boolean;
function NextDoubleP(const sq: string; var ptr: integer): Double;
function NextDoubleDefP(const sq: string; var ptr: integer; default: Double): Double;
function MustbeDoubleP(const sq: string; var ptr: integer): Double;
function MustbeSignedDoubleP(const sq: string; var ptr: integer): Double;
function NextWordP(const sq: string; var ptr: integer): string;
function NextNumberP(const sq: string; var ptr: integer): integer;
function NextNumberDefP(const sq: string; var ptr: integer; default: integer): integer;
function NextHexNumberP(const sq: string; var ptr: integer): integer;
function NextHexNumberDefP(const sq: string; var ptr: integer; default: integer): integer;
procedure MustbeP(const sq: string; var ptr: integer; const substr: string);
function MustbeIdP(const sq: string; var ptr: integer): string;
function MustbeIdKeepCaseP(const sq: string; var ptr: integer): string;
function MustbeStringP(const sq: string; var ptr: integer): string;
function MustbeNumberP(const sq: string; var ptr: integer): integer;
function MustbeBoolP(const sq: string; var ptr: integer): boolean;
function MustbeSignedNumberP(const sq: string; var ptr: integer): integer;
function NextIsIdAKeepCaseP(const sq: string; var ptr: integer; var id: string): boolean;
function NextIsIdAP(const sq: string; var ptr: integer; var id: string): boolean;
function MustbeEFormatP(const sq: string; var ptr: integer): Double;
function NextIsExpressionP(const sq: string; var ptr: integer; var i: double): boolean;
function NextExpressionP(const sq: string; var ptr: integer): Double;
function NextExpressionDefP(const sq: string; var ptr: integer; default: double): double;
function MustbeExpressionP(const sq: string; var ptr: integer): Double;
procedure SkipBlanksP(const sq: string; var ptr: integer);
procedure SkipBlanksCommentsP(const sq: string; var ptr: integer);

{Component functions}
function GetStringTableInt(ID: Word; default: longint): longint;
function OffsetToLine(memo: TMemo; offset: integer): integer;
procedure MemoLineToTop(Memo: TMemo; Linenum: integer);
function CurLine(memo: TMemo): integer;
procedure SetCurLine(memo: TMemo; i: integer);
function OffsetToLineRE(RichEdit: TRichEdit; offset: integer): integer;
function StringOffsetToLine(s: string; offset: integer): integer;
function LineToOffset(memo: TMemo; line: integer): integer;
procedure SetPageControlIndex(Control: TPageControl; value: integer);
procedure SetPageControlPage(Control: TPageControl; TabSheet: TTabSheet);
procedure HighlightListboxItem(Listbox1: TListbox; i: integer);
procedure Listbox_CalcLineHeights(AListbox:TListbox);
function DlgGetSetCheckBox(aControl: TCheckBox; value: boolean; Get: boolean): boolean;
function DlgGetSetSpinEdit(aControl: TSpinEdit; value: integer; Get: boolean): integer;
function DlgGetSetColor(aControl: TPanel; value: TColor; Get: boolean): TColor;
function RichEditColLineToPos(RichEdit: TRichEdit; Col,Line: integer): integer;
function RichEditPosToColLine(RichEdit: TRichEdit; pos: integer): TPoint;
function RichEditPosToXY(RichEdit: TRichEdit; pos: integer): TPoint;
function RichEditCurLine(RichEdit: TRichEdit): integer;
function RichEditCurCol(RichEdit: TRichEdit): integer;
procedure RichEditLineToTop(RichEdit: TRichEdit; Linenum: integer);
function GetRichEditRTFStrings(RichEdit1: TRichEdit): TStrings;
procedure SetRichEditRTFStrings(RichEdit1: TRichEdit; strings: TStrings);
function RTFtoPlain(strings: TStrings; aForm: TForm): TStrings;
function LineFromPos(Memo:  TMemo; TextPos: integer): integer;
function MemoPosToLine(Memo: TMemo; pos: integer): integer;
//function MemoPosToXY(Memo: TMemo; pos: integer): TPoint;
procedure DeleteStringGridRow(StringGrid: TStringGrid; aRow: integer);
procedure CopyStringGridRow(StringGrid: TStringGrid; SourceRow,DestRow: integer);
procedure InsertStringGridRow(StringGrid: TStringGrid; aRow: integer);
procedure MoveStringGridRow(StringGrid: TStringGrid; SourceRow,DestRow: integer);
procedure DeleteStringGridCol(StringGrid: TStringGrid; aCol: integer);
procedure CopyStringGridCol(StringGrid: TStringGrid; SourceCol,DestCol: integer);
procedure InsertStringGridCol(StringGrid: TStringGrid; aCol: integer);
procedure MoveStringGridCol(StringGrid: TStringGrid; SourceCol,DestCol: integer);
function StringGridToString(StringGrid: TStringGrid): string;
type TGridSortKind = (gskString,gskNumber,gskDate);
procedure SortStringGridRows(StringGrid: TStringGrid; SortCol: integer; GridSortKind: TGridSortKind);
procedure SortStringGridRowsEx(StringGrid: TStringGrid; SortCol: integer; GridSortKind: TGridSortKind; MinRow,MaxRow: integer);
function CheckedCount(CheckListBox: TCheckListBox): integer;
function FirstChecked(CheckListBox: TCheckListBox): integer;

function calcTheta(target,origin: TPoint):double;
function rotate(theta:double; target,origin: TPoint) : TPoint;
function rotateSgl(theta:double; target,origin: TSinglePoint) : TSinglePoint;
function rotatePt(theta:double; target,origin: TPoint) : TPoint;
function calcThetaXY(targetx,targety,originx,originy: single):single;
procedure rotateXY(theta: single;targetX,targetY,originX,originY:single; var resultX,resultY: single);
procedure rotateXY2(theta: single;targetX,targetY,originX,originY:single; var resultX,resultY: single);
function InputNumberQuery(const ACaption, APrompt: string; var aValue: integer; min,max: integer): Boolean;
function InputNumberQuery2(const ACaption, APrompt1,APrompt2: string; var aValue1,aValue2: integer; min,max: integer): Boolean;
function InputNumberQuery3(const ACaption, APrompt1,APrompt2,APrompt3: string; var aValue1,aValue2,aValue3: integer; min,max: integer): Boolean;
function InputNumberQuery4(const ACaption, APrompt1,APrompt2,APrompt3,APrompt4: string; var aValue1,aValue2,aValue3,aValue4: integer; min,max: integer): Boolean;
function InputDoubleQuery(const ACaption, APrompt: string; var aValue: double; min,max: double): Boolean;
function InputStringYesNoCancel(const ACaption, APrompt: string; var aValue: string): TModalResult;
function InputNumberYesNoCancel(const ACaption, APrompt: string; var aValue: integer; min,max: integer): TModalResult;
function InputComboQueryEx(const ACaption, APrompt: string; aItems: string; var Value: string; aStyle: TComboBoxStyle; aSorted: boolean): Boolean;
function InputComboQuery(const ACaption, APrompt: string; aItems: string; var Value: string): Boolean;
function ChooseOne(const ACaption, APrompt: string; const s: array of string; var aIndex: integer): Boolean;
function ChooseOneStrs(const ACaption, APrompt: string; s: Tstrings; var aIndex: integer): Boolean;

procedure DialDTMF(number: string; vol: integer);
function SlowDownSound(s: string; speed: integer): string;
function SlowDownSound2(s: string; speed: integer): string;
function SlowDownSound3(s: string; speed: integer): string;
function SlowDownSoundData(s: string; SamplesPerSec,BitsPerSample,Channels,speed: integer): string;
function SlowDownSoundData2(s: string; SamplesPerSec,BitsPerSample,Channels,speed: integer): string;
function SlowDownSoundData3(s: string; SamplesPerSec,BitsPerSample,Channels,speed: integer): string;
function AddHeaderStr(s: string; aSampleRate,aBitsPerSample,aChannels: integer): string;
function AddHeaderMem(var mem; len,aSampleRate,aBitsPerSample,aChannels: integer): string;
Procedure RightMenu(Form: TForm; MenuItem: TMenuItem);
Procedure RightMenuEx(Form: TForm; MenuItem: TMenuItem; s: string);
procedure ShutDownWindows;

const
  sin12: array[0..12] of single = (0.00000000,0.49999999,0.86602540,1.00000000,0.86602540,0.49999999,0.00000000,-0.4999999,-0.8660254,-1.0000000,-0.8660254,-0.5000000,0.00000000);
  cos12: array[0..12] of single = (1.00000000,0.86602540,0.50000000,0.00000000,-0.4999999,-0.8660254,-1.0000000,-0.8660254,-0.5000000,0.00000000,0.50000000,0.86602540,1.00000000);
  sin16: array[0..16] of single = (0.00000000,0.38268343,0.70710678,0.92387953,1.00000000,0.92387953,0.70710678,0.38268343,0.00000000,-0.3826834,-0.7071067,-0.9238795,-1.0000000,-0.9238795,-0.7071067,-0.3826834,0.00000000);
  cos16: array[0..16] of single = (1.00000000,0.92387953,0.70710678,0.38268343,0.00000000,-0.3826834,-0.7071067,-0.9238795,-1.0000000,-0.9238795,-0.7071067,-0.3826834,0.00000000,0.38268343,0.70710678,0.92387953,1.00000000);
  sin20: array[0..20] of single = (0.00000000,0.30901699,0.58778525,0.80901699,0.95105651,1.00000000,0.95105651,0.80901699,0.58778525,0.30901699,0.00000000,-0.3090169,-0.5877852,-0.8090169,-0.9510565,-1.0000000,-0.9510565,-0.8090169,-0.5877852,-0.3090169,0.00000000);
  cos20: array[0..20] of single = (1.00000000,0.95105651,0.80901699,0.58778525,0.30901699,0.00000000,-0.3090169,-0.5877852,-0.8090169,-0.9510565,-1.0000000,-0.9510565,-0.8090169,-0.5877852,-0.3090169,0.00000000,0.30901699,0.58778525,0.80901699,0.95105651,1.00000000);
  sin32: array[0..32] of single = (0.00000000,0.19509032,0.38268343,0.55557023,0.70710678,0.83146961,0.92387953,0.98078528,1.00000000,0.98078528,0.92387953,0.83146961,0.70710678,0.55557023,0.38268343,0.19509032,0.00000000,-0.1950903,-0.3826834,-0.5555702,-0.7071067,-0.8314696,-0.9238795,-0.9807852,-1.0000000,-0.9807852,-0.9238795,-0.8314696,-0.7071067,-0.5555702,-0.3826834,-0.1950903,0.00000000);
  cos32: array[0..32] of single = (1.00000000,0.98078528,0.92387953,0.83146961,0.70710678,0.55557023,0.38268343,0.19509032,0.00000000,-0.1950903,-0.3826834,-0.5555702,-0.7071067,-0.8314696,-0.9238795,-0.9807852,-1.0000000,-0.9807852,-0.9238795,-0.8314696,-0.7071067,-0.5555702,-0.3826834,-0.1950903,0.00000000,0.19509032,0.38268343,0.55557023,0.70710678,0.83146961,0.92387953,0.98078528,1.00000000);

  Palette16: array[0..15] of TColor =
     ($000000,  { black               0}
      $00007F,  { dark red            1}
      $007F00,  { dark green          2}
      $007F7F,  { dark yellow         3}
      $7F0000,  { dark blue           4}
      $7F007F,  { dark magenta        5}
      $7F7F00,  { dark cyan           6}
      $7F7F7F,  { dark gray           7}
      $C0C0C0,  { light gray          8}
      $0000FF,  { light red           9}
      $00FF00,  { light green        10}
      $00FFFF,  { light yellow       11}
      $FF0000,  { light blue         12}
      $FF00FF,  { light cyan         13}
      $FFFF00,  { light magenta      14}
      $FFFFFF); { light white        15}

  { Ternary raster operations }
  { the name is the reverse-polish expression    }
  { D	Destination bitmap                       }
  { P	Selected brush (also called pattern)     }
  { S	Source bitmap                            }

  { a	Bitwise AND                              }
  { n	Bitwise NOT (inverse)                    }
  { o	Bitwise OR                               }
  { x	Bitwise exclusive OR (XOR)               }

  rop0  	= $00000042;	{BLACKNESS}
  ropDPSoon	= $00010289;
  ropDPSona	= $00020C89;	
  ropPSon	= $000300AA;
  ropSDPona	= $00040C88;	
  ropDPon	= $000500A9;
  ropPDSxnon	= $00060865;
  ropPDSaon	= $000702C5;
  ropSDPnaa	= $00080F08;	
  ropPDSxon	= $00090245;	
  ropDPna	= $000A0329;
  ropPSDnaon	= $000B0B2A;
  ropSPna	= $000C0324;	
  ropPDSnaon	= $000D0B25;
  ropPDSonon	= $000E08A5;
  ropPn 	= $000F0001;	
  ropPDSona	= $00100C85;
  ropDSon	= $001100A6;	{NOTSRCERASE}
  ropSDPxnon	= $00120868;	
  ropSDPaon	= $001302C8;	
  ropDPSxnon	= $00140869;
  ropDPSaon	= $001502C9;	
  ropPSDPSanaxx	= $00165CCA;
  ropSSPxDSxaxn	= $00171D54;	
  ropSPxPDxa	= $00180D59;
  ropSDPSanaxn	= $00191CC8;
  ropPDSPaox	= $001A06C5;	
  ropSDPSxaxn	= $001B0768;	
  ropPSDPaox	= $001C06CA;
  ropDSPDxaxn	= $001D0766;
  ropPDSox	= $001E01A5;
  ropPDSoan	= $001F0385;
  ropDPSnaa	= $00200F09;	
  ropSDPxon	= $00210248;
  ropDSna	= $00220326;	
  ropSPDnaon	= $00230B24;	
  ropSPxDSxa	= $00240D55;	
  ropPDSPanaxn	= $00251CC5;	
  ropSDPSaox	= $002606C8;
  ropSDPSxnox	= $00271868;	
  ropDPSxa	= $00280369;	
  ropPSDPSaoxxn	= $002916CA;	
  ropDPSana	= $002A0CC9;	
  ropSSPxPDxaxn	= $002B1D58;
  ropSPDSoax	= $002C0784;	
  ropPSDnox	= $002D060A;	
  ropPSDPxox	= $002E064A;	
  ropPSDnoan	= $002F0E2A;
  ropPSna	= $0030032A;	
  ropSDPnaon	= $00310B28;
  ropSDPSoox	= $00320688;
  ropSn 	= $00330008;	{NOTSRCCOPY}
  ropSPDSaox	= $003406C4;
  ropSPDSxnox	= $00351864;	
  ropSDPox	= $003601A8;	
  ropSDPoan	= $00370388;
  ropPSDPoax	= $0038078A;	
  ropSPDnox	= $00390604;	
  ropSPDSxox	= $003A0644;	
  ropSPDnoan	= $003B0E24;	
  ropPSx	= $003C004A;	
  ropSPDSonox	= $003D18A4;
  ropSPDSnaox	= $003E1B24;
  ropPSan	= $003F00EA;	
  ropPSDnaa	= $00400F0A;
  ropDPSxon	= $00410249;
  ropSDxPDxa	= $00420D5D;	
  ropSPDSanaxn	= $00431CC4;
  ropSDna	= $00440328;	{SRCERASE}
  ropDPSnaon	= $00450B29;	
  ropDSPDaox	= $004606C6;	
  ropPSDPxaxn	= $0047076A;	
  ropSDPxa	= $00480368;
  ropPDSPDaoxxn	= $004916C5;
  ropDPSDoax	= $004A0789;
  ropPDSnox	= $004B0605;	
  ropSDPana	= $004C0CC8;	
  ropSSPxDSxoxn	= $004D1954;	
  ropPDSPxox	= $004E0645;	
  ropPDSnoan	= $004F0E25;	
  ropPDna	= $00500325;	
  ropDSPnaon	= $00510B26;
  ropDPSDaox	= $005206C9;
  ropSPDSxaxn	= $00530764;	
  ropDPSonon	= $005408A9;
  ropDn 	= $00550009;	{DSTINVERT}
  ropDPSox	= $005601A9;
  ropDPSoan	= $00570389;	
  ropPDSPoax	= $00580785;	
  ropDPSnox	= $00590609;	
  ropDPx	= $005A0049;	{PATINVERT}
  ropDPSDonox	= $005B18A9;	
  ropDPSDxox	= $005C0649;	
  ropDPSnoan	= $005D0E29;	
  ropDPSDnaox	= $005E1B29;	
  ropDPan	= $005F00E9;
  ropPDSxa	= $00600365;	
  ropDSPDSaoxxn	= $006116C6;	
  ropDSPDoax	= $00620786;	
  ropSDPnox	= $00630608;	
  ropSDPSoax	= $00640788;
  ropDSPnox	= $00650606;
  ropDSx	= $00660046;	{SRCINVERT}
  ropSDPSonox	= $006718A8;	
  ropDSPDSonoxxn	= $006858A6;	
  ropPDresultn	= $00690145;	
  ropDPSax	= $006A01E9;
  ropPSDPSoaxxn	= $006B178A;	
  ropSDPax	= $006C01E8;	
  ropPDSPDoaxxn	= $006D1785;
  ropSDPSnoax	= $006E1E28;
  ropPDSxnan	= $006F0C65;	
  ropPDSana	= $00700CC5;	
  ropSSDxPDxaxn	= $00711D5C;
  ropSDPSxox	= $00720648;	
  ropSDPnoan	= $00730E28;	
  ropDSPDxox	= $00740646;	
  ropDSPnoan	= $00750E26;
  ropSDPSnaox	= $00761B28;
  ropDSan	= $007700E6;
  ropPDSax	= $007801E5;	
  ropDSPDSoaxxn	= $00791786;	
  ropDPSDnoax	= $007A1E29;	
  ropSDPxnan	= $007B0C68;	
  ropSPDSnoax	= $007C1E24;	
  ropDPSxnan	= $007D0C69;	
  ropSPxDSxo	= $007E0955;	
  ropDPSaan	= $007F03C9;
  ropDPSaa	= $008003E9;
  ropSPxDSxon	= $00810975;	
  ropDPSxna	= $00820C49;	
  ropSPDSnoaxn	= $00831E04;	
  ropSDPxna	= $00840C48;	
  ropPDSPnoaxn	= $00851E05;	
  ropDSPDSoaxx	= $008617A6;
  ropPDSaxn	= $008701C5;
  ropDSa	= $008800C6;	{SRCAND}
  ropSDPSnaoxn	= $00891B08;	
  ropDSPnoa	= $008A0E06;
  ropDSPDxoxn	= $008B0666;
  ropSDPnoa	= $008C0E08;	
  ropSDPSxoxn	= $008D0668;	
  ropSSDxPDxax	= $008E1D7C;	
  ropPDSanan	= $008F0CE5;	
  ropPDSxna	= $00900C45;	
  ropSDPSnoaxn	= $00911E08;	
  ropDPSDPoaxx	= $009217A9;	
  ropSPDaxn	= $009301C4;	
  ropPSDPSoaxx	= $009417AA;
  ropDPSaxn	= $009501C9;	
  ropDPresult	= $00960169;	
  ropPSDPSonoxx	= $0097588A;	
  ropSDPSonoxn	= $00981888;
  ropDSxn	= $00990066;	
  ropDPSnax	= $009A0709;
  ropSDPSoaxn	= $009B07A8;	
  ropSPDnax	= $009C0704;	
  ropDSPDoaxn	= $009D07A6;
  ropDSPDSaoxx	= $009E16E6;
  ropPDSxan	= $009F0345;	
  ropDPa	= $00A000C9;	
  ropPDSPnaoxn	= $00A11B05;
  ropDPSnoa	= $00A20E09;	
  ropDPSDxoxn	= $00A30669;
  ropPDSPonoxn	= $00A41885;	
  ropPDxn	= $00A50065;	
  ropDSPnax	= $00A60706;	
  ropPDSPoaxn	= $00A707A5;	
  ropDPSoa	= $00A803A9;	
  ropDPSoxn	= $00A90189;
  ropD  	= $00AA0029;	
  ropDPSono	= $00AB0889;	
  ropSPDSxax	= $00AC0744;	
  ropDPSDaoxn	= $00AD06E9;	
  ropDSPnao	= $00AE0B06;
  ropDPno	= $00AF0229;	
  ropPDSnoa	= $00B00E05;
  ropPDSPxoxn	= $00B10665;	
  ropSSPxDSxox	= $00B21974;	
  ropSDPanan	= $00B30CE8;	
  ropPSDnax	= $00B4070A;	
  ropDPSDoaxn	= $00B507A9;	
  ropDPSDPaoxx	= $00B616E9;
  ropSDPxan	= $00B70348;
  ropPSDPxax	= $00B8074A;	
  ropDSPDaoxn	= $00B906E6;	
  ropDPSnao	= $00BA0B09;
  ropDSno	= $00BB0226;	{MERGEPAINT}
  ropSPDSanax	= $00BC1CE4;	
  ropSDxPDxan	= $00BD0D7D;	
  ropDPSxo	= $00BE0269;
  ropDPSano	= $00BF08C9;	
  ropPSa	= $00C000CA;	{MERGECOPY}
  ropSPDSnaoxn	= $00C11B04;	
  ropSPDSonoxn	= $00C21884;	
  ropPSxn	= $00C3006A;
  ropSPDnoa	= $00C40E04;	
  ropSPDSxoxn	= $00C50664;	
  ropSDPnax	= $00C60708;	
  ropPSDPoaxn	= $00C707AA;
  ropSDPoa	= $00C803A8;	
  ropSPDoxn	= $00C90184;
  ropDPSDxax	= $00CA0749;	
  ropSPDSaoxn	= $00CB06E4;
  ropS  	= $00CC0020;	{SRCCOPY}
  ropSDPono	= $00CD0888;
  ropSDPnao	= $00CE0B08;
  ropSPno	= $00CF0224;	
  ropPSDnoa	= $00D00E0A;	
  ropPSDPxoxn	= $00D1066A;	
  ropPDSnax	= $00D20705;	
  ropSPDSoaxn	= $00D307A4;
  ropSSPxPDxax	= $00D41D78;	
  ropDPSanan	= $00D50CE9;	
  ropPSDPSaoxx	= $00D616EA;
  ropDPSxan	= $00D70349;	
  ropPDSPxax	= $00D80745;	
  ropSDPSaoxn	= $00D906E8;
  ropDPSDanax	= $00DA1CE9;	
  ropSPxDSxan	= $00DB0D75;	
  ropSPDnao	= $00DC0B04;
  ropSDno	= $00DD0228;	
  ropSDPxo	= $00DE0268;	
  ropSDPano	= $00DF08C8;	
  ropPDSoa	= $00E003A5;	
  ropPDSoxn	= $00E10185;	
  ropDSPDxax	= $00E20746;	
  ropPSDPaoxn	= $00E306EA;
  ropSDPSxax	= $00E40748;
  ropPDSPaoxn	= $00E506E5;	
  ropSDPSanax	= $00E61CE8;
  ropSPxPDxan	= $00E70D79;	
  ropSSPxDSxax	= $00E81D74;
  ropDSPDSanaxxn	= $00E95CE6;
  ropDPSao	= $00EA02E9;	
  ropDPSxno	= $00EB0849;	
  ropSDPao	= $00EC02E8;	
  ropSDPxno	= $00ED0848;
  ropDSo	= $00EE0086;	{SRCPAINT}
  ropSDPnoo	= $00EF0A08;	
  ropP  	= $00F00021;	{PATCOPY}
  ropPDSono	= $00F10885;	
  ropPDSnao	= $00F20B05;	
  ropPSno	= $00F3022A;	
  ropPSDnao	= $00F40B0A;
  ropPDno	= $00F50225;	
  ropPDSxo	= $00F60265;	
  ropPDSano	= $00F708C5;	
  ropPDSao	= $00F802E5;
  ropPDSxno	= $00F90845;
  ropDPo	= $00FA0089;	
  ropDPSnoo	= $00FB0A09;	{PATPAINT}
  ropPSo	= $00FC008A;
  ropPSDnoo	= $00FD0A0A;
  ropDPSoo	= $00FE02A9;
  rop1  	= $00FF0062;	{WHITENESS}

  Zero3DPoint: T3DPoint = (x:0;y:0;z:0); 

type
  PMyHeapRecOld = ^TMyHeapRecOld;
  TMyHeapRecOld = record
    max: word;
    Next: PMyHeapRecOld;
    buffer: array[0..$FFEF] of byte;
  end;
  PMyHeapRecOld2 = ^TMyHeapRecOld2;
  TMyHeapRecOld2 = record
    max,size: integer;
    Next: PMyHeapRecOld2;
    bufferx: array[0..0] of byte;
  end;
(*
  PMyHeapRec = ^TMyHeapRec;
  TMyHeapRec = record
    max,size: integer;
    Next: PMyHeapRec;
    bufferx: array[0..0] of byte;
  end;
*)
  PMyHeapRec = ^TMyHeapRec;
  TMyHeapRec = record
    s: string;
    Next: PMyHeapRec;
  end;

function MyGetMem(var P: Pointer; Size: longint): boolean;
function MyNew(Size: longint): Pointer;
function MyNewPChar(s: string): pchar;
procedure FreeMyHeap;
function MyGetMemExt(var P: Pointer; Size: longint; var MyHeap: PMyHeapRec): boolean;
function MyNewExt(Size: longint; var MyHeap: PMyHeapRec): Pointer;
procedure FreeMyHeapExt(var MyHeap: PMyHeapRec);

function MyGetMemOld2(var P: Pointer; Size: longint): boolean;
function MyNewOld2(Size: longint): Pointer;
function MyNewPCharOld2(s: string): pchar;
function MyGetMemExtOld2(var P: Pointer; Size: longint; var MyHeap: PMyHeapRecOld2): boolean;
procedure FreeMyHeapOld2;
procedure FreeMyHeapExtOld2(var MyHeap: PMyHeapRecOld2);

function MyGetMemOld(var P: Pointer; Size: longint): boolean;
function MyNewOld(Size: longint): Pointer;
function MyNewPCharOld(s: string): pchar;
function MyGetMemExtOld(var P: Pointer; Size: longint; var MyHeap: PMyHeapRecOld): boolean;
procedure FreeMyHeapOld;
procedure FreeMyHeapExtOld(var MyHeap: PMyHeapRecOld);

{numeric/text functions}
function SmallIntDataToString(i: SmallInt): string;
procedure AddUnique(Strings: TStrings; s: string; First: boolean);
function myTrunc(x: extended) : int64;
function TPointToTSinglePoint(p: TPoint): TSinglePoint;
function InterpolatePoints(Points: array of TSinglePoint; N: integer): TarrayofTSinglePoint;
function InterpolateSingles(Singles: array of Single; N: integer): TarrayofSingle;
function InterpolateBytes(Bytes: array of byte; N: integer): TarrayofByte;
function EnabledTextColor(enabled: boolean): TColor;

const
  T_TestProb:  array[1..2, 1..8] of single = {[tails,prob]}
              ((0.80,     0.50,     0.20,     0.10,     0.05,    0.02,    0.01,    0.001),   //2-tail significance level
               (0.40,     0.25,     0.10,     0.05,     0.025,   0.01,    0.005,   0.0005)); //1-tail significance level
  T_TestTable: array[1..31,1..8] of single = {[dof,prob]}
    {1 dof}   ((0.324920, 1.000000, 3.077684, 6.313752, 12.7062, 31.8205, 63.6567, 636.61),
    {2 }       (0.288675, 0.816497, 1.885618, 2.919986, 4.30265, 6.96456, 9.92484, 31.599),
    {3 }       (0.276671, 0.764892, 1.637744, 2.353363, 3.18245, 4.54070, 5.84091, 12.924),
    {4 }       (0.270722, 0.740697, 1.533206, 2.131847, 2.77645, 3.74695, 4.60409, 8.6103),
    {5 }       (0.267181, 0.726687, 1.475884, 2.015048, 2.57058, 3.36493, 4.03214, 6.8688),
    {6 }       (0.264835, 0.717558, 1.439756, 1.943180, 2.44691, 3.14267, 3.70743, 5.9588),
    {7 }       (0.263167, 0.711142, 1.414924, 1.894579, 2.36462, 2.99795, 3.49948, 5.4079),
    {8 }       (0.261921, 0.706387, 1.396815, 1.859548, 2.30600, 2.89646, 3.35539, 5.0413),
    {9 }       (0.260955, 0.702722, 1.383029, 1.833113, 2.26216, 2.82144, 3.24984, 4.7809),
    {10}       (0.260185, 0.699812, 1.372184, 1.812461, 2.22814, 2.76377, 3.16927, 4.5869),
    {11}       (0.259556, 0.697445, 1.363430, 1.795885, 2.20099, 2.71808, 3.10581, 4.4370),
    {12}       (0.259033, 0.695483, 1.356217, 1.782288, 2.17881, 2.68100, 3.05454, 4.3178),
    {13}       (0.258591, 0.693829, 1.350171, 1.770933, 2.16037, 2.65031, 3.01228, 4.2208),
    {14}       (0.258213, 0.692417, 1.345030, 1.761310, 2.14479, 2.62449, 2.97684, 4.1405),
    {15}       (0.257885, 0.691197, 1.340606, 1.753050, 2.13145, 2.60248, 2.94671, 4.0728),
    {16}       (0.257599, 0.690132, 1.336757, 1.745884, 2.11991, 2.58349, 2.92078, 4.0150),
    {17}       (0.257347, 0.689195, 1.333379, 1.739607, 2.10982, 2.56693, 2.89823, 3.9651),
    {18}       (0.257123, 0.688364, 1.330391, 1.734064, 2.10092, 2.55238, 2.87844, 3.9216),
    {19}       (0.256923, 0.687621, 1.327728, 1.729133, 2.09302, 2.53948, 2.86093, 3.8834),
    {20}       (0.256743, 0.686954, 1.325341, 1.724718, 2.08596, 2.52798, 2.84534, 3.8495),
    {21}       (0.256580, 0.686352, 1.323188, 1.720743, 2.07961, 2.51765, 2.83136, 3.8193),
    {22}       (0.256432, 0.685805, 1.321237, 1.717144, 2.07387, 2.50832, 2.81876, 3.7921),
    {23}       (0.256297, 0.685306, 1.319460, 1.713872, 2.06866, 2.49987, 2.80734, 3.7676),
    {24}       (0.256173, 0.684850, 1.317836, 1.710882, 2.06390, 2.49216, 2.79694, 3.7454),
    {25}       (0.256060, 0.684430, 1.316345, 1.708141, 2.05954, 2.48511, 2.78744, 3.7251),
    {26}       (0.255955, 0.684043, 1.314972, 1.705618, 2.05553, 2.47863, 2.77871, 3.7066),
    {27}       (0.255858, 0.683685, 1.313703, 1.703288, 2.05183, 2.47266, 2.77068, 3.6896),
    {28}       (0.255768, 0.683353, 1.312527, 1.701131, 2.04841, 2.46714, 2.76326, 3.6739),
    {29}       (0.255684, 0.683044, 1.311434, 1.699127, 2.04523, 2.46202, 2.75639, 3.6594),
    {30}       (0.255605, 0.682756, 1.310415, 1.697261, 2.04227, 2.45726, 2.75000, 3.6460),
    {inf}      (0.253347, 0.674490, 1.281552, 1.644854, 1.95996, 2.32635, 2.57583, 3.2905));

{$EXTERNALSYM RegisterTouchWindow}
function RegisterTouchWindow(hWnd: hWnd; ulFlags: longint): boolean;

implementation

uses Dialogs,
  DbiProcs,DB, DbiTypes, DbiErrs,
  Messages,
  ShellApi,
  ShlObj,
  math,
  RichEdit,
  FSpin,
  Clipbrd,
  Printers,
  lzexpand,
  SysUtils;

{$EXTERNALSYM RegisterTouchWindow}
function RegisterTouchWindow(hWnd: hWnd; ulFlags: longint): boolean; external user32 name 'RegisterTouchWindow';

var StreamInputBuffer: string;
const fSkipComments: boolean = true;
const fSkipBlanks: boolean = true;
const fSkipSlashStar: boolean = false; {true if allow /* ... */ in comments}
var RegressionN_rec: record
    N,M: integer;
    SWgt: double;
    a,SS: T2DArray;
    S: TArrayofDouble;
  end;

var ProjectRec: record vx,vy,vz,va,vb,vc,vudist,vd,uOfs,vOfs,zoom: Single; end;

const CRCTable: Array[0..255] of DWord =
     ($00000000, $77073096, $EE0E612C, $990951BA,
      $076DC419, $706AF48F, $E963A535, $9E6495A3,
      $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988,
      $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91,
      $1DB71064, $6AB020F2, $F3B97148, $84BE41DE,
      $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
      $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC,
      $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5,
      $3B6E20C8, $4C69105E, $D56041E4, $A2677172,
      $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B,
      $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940,
      $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59,
      $26D930AC, $51DE003A, $C8D75180, $BFD06116,
      $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F,
      $2802B89E, $5F058808, $C60CD9B2, $B10BE924,
      $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D,
      $76DC4190, $01DB7106, $98D220BC, $EFD5102A,
      $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433,
      $7807C9A2, $0F00F934, $9609A88E, $E10E9818,
      $7F6A0DBB, $086D3D2D, $91646C97, $E6635C01,
      $6B6B51F4, $1C6C6162, $856530D8, $F262004E,
      $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457,
      $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C,
      $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65,
      $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2,
      $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB,
      $4369E96A, $346ED9FC, $AD678846, $DA60B8D0,
      $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9,
      $5005713C, $270241AA, $BE0B1010, $C90C2086,
      $5768B525, $206F85B3, $B966D409, $CE61E49F,
      $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4,
      $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD,
      $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A,
      $EAD54739, $9DD277AF, $04DB2615, $73DC1683,
      $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8,
      $E40ECF0B, $9309FF9D, $0A00AE27, $7D079EB1,
      $F00F9344, $8708A3D2, $1E01F268, $6906C2FE,
      $F762575D, $806567CB, $196C3671, $6E6B06E7,
      $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC,
      $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5,
      $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252,
      $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
      $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60,
      $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79,
      $CB61B38C, $BC66831A, $256FD2A0, $5268E236,
      $CC0C7795, $BB0B4703, $220216B9, $5505262F,
      $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04,
      $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,
      $9B64C2B0, $EC63F226, $756AA39C, $026D930A,
      $9C0906A9, $EB0E363F, $72076785, $05005713,
      $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38,
      $92D28E9B, $E5D5BE0D, $7CDCEFB7, $0BDBDF21,
      $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E,
      $81BE16CD, $F6B9265B, $6FB077E1, $18B74777,
      $88085AE6, $FF0F6A70, $66063BCA, $11010B5C,
      $8F659EFF, $F862AE69, $616BFFD3, $166CCF45,
      $A00AE278, $D70DD2EE, $4E048354, $3903B3C2,
      $A7672661, $D06016F7, $4969474D, $3E6E77DB,
      $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0,
      $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9,
      $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6,
      $BAD03605, $CDD70693, $54DE5729, $23D967BF,
      $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94,
      $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D);


function LPadC(const s: string; len: integer; c: char): string;
begin
  result:='';
  if len-length(s) > 0 then
  begin
    SetLength(result,len-length(s));
    Fillchar(result[1],length(result),c);
  end;
  result:=result+s;
end;

function RPadC(const s: string; len: integer; c: char): string;
begin
  result:='';
  if len-length(s) > 0 then
  begin
    SetLength(result,len-length(s));
    Fillchar(result[1],length(result),c);
  end;
  result:=s+result;

//  result:=s;
//  while length(result) < len do result:=result+c;
end;

function LPad(const s: string; len: integer): string;
begin
  result:=LPadC(s,len,' ');
end;

function RPad(const s: string; len: integer): string;
begin
  result:=RPadC(s,len,' ');
end;

{ height of text }
function textheight(DC: HDC): word;
  const s: pChar = 'X';
  var Size: TSize;
begin
  GetTextExtentPoint32(DC,s,1,SIZE);
  result:=SIZE.cy;
end;

{ width of text }
function textwidth(DC: HDC; const s: string): word;
var Size: TSize;
begin
  GetTextExtentPoint32(DC,pChar(s),length(s),SIZE);
  result:=SIZE.cx;
end;

{ error messages for WinExec }
function WinExecError(hModule: THandle): string;
begin
  if hModule <= 32 then
  case hModule of
    0:   WinExecError:='System out of memory or file corrupt';
    2:   WinExecError:='File not found';
    3:   WinExecError:='Path not found';
    5:   WinExecError:='Illegal attempt to dynamic link';
    6:   WinExecError:='Library requires separate data segments';
    8:   WinExecError:='Insufficient memory';
    10:  WinExecError:='Incorrect Windows version';
    11:  WinExecError:='Invalid or non-Windows application';
    12:  WinExecError:='Not a Windows application';
    13:  WinExecError:='Not a Windows application';
    14:  WinExecError:='Unknown executable file type';
    15:  WinExecError:='Incorrect Windows version';
    16:  WinExecError:='Data segments not read-only';
    19:  WinExecError:='Compressed executable file';
    20:  WinExecError:='Invalid Dynamic-link library file';
    21:  WinExecError:='Requires 32-bit extensions';
    else WinExecError:=IntToStr(hModule);
  end else
    WinExecError:='Executed OK';
end;

function StrToPChar(s: string): PChar;
  const n = 3;
        p: array[0..n-1,0..256] of char = ('','','');
        i: integer = 0;
begin
  i:=(i+1) mod n;
  StrPCopy(p[i],s);
  StrToPChar:=p[i];
end;

function HiWord(l: longint): word;
  var r: record w1,w2: word end absolute l;
begin
  HiWord:=r.w2;
end;

function LoWord(l: longint): word;
  var r: record w1,w2: word end absolute l;
begin
  LoWord:=r.w1;
end;

function AppendFile(var f: file; Source: string): Boolean;
  var fin: file;
      buf: array[1..1024] of byte;
      w: integer;
  label error;
begin
  SetCursor(LoadCursor(0,idc_wait));

  {$I-}
  result:=true;

  FileMode:=0;  {Read only}
  assign(fin,Source);
  reset(fin,1);                        if IOResult <> 0 then goto error;
  FileMode:=2;  {Read/Write - default}

  while not eof(fin) do
  begin
    blockread(fin,buf,sizeof(buf),w);  if IOResult <> 0 then goto error;
    blockwrite(f,buf,w);             if IOResult <> 0 then goto error;
  end;

  close(fin);                          if IOResult <> 0 then goto error;
  SetCursor(LoadCursor(0,idc_arrow));

  exit;

  error:
    close(fin);                        if IOResult <> 0 then ;
    result:=false;
    SetCursor(LoadCursor(0,idc_arrow));
  {$I+}
end;

{ copy a file }
function ExtractFile(var f: file; Dest: string; Size: longint): boolean;
  var fout: file;
      buf: array[1..1024] of byte;
      v:word;
      w: integer;
  label error;
begin
  SetCursor(LoadCursor(0,idc_wait));

  {$I-}
  result:=true;

  assign(fout,Dest);
  rewrite(fout,1);                     if IOResult <> 0 then goto error;

  while not eof(f) and (Size > 0) do
  begin
    v:=sizeof(buf);
    if v > Size then v:=Size;
    blockread(f,buf,v,w);              if IOResult <> 0 then goto error;
    blockwrite(fout,buf,w);            if IOResult <> 0 then goto error;
    dec(Size,w);
  end;

  close(fout);                         if IOResult <> 0 then goto error;
  SetCursor(LoadCursor(0,idc_arrow));

  exit;

  error:
    close(fout);                       if IOResult <> 0 then ;
    result:=false;
    SetCursor(LoadCursor(0,idc_arrow));
  {$I+}
end;

function DirSize(const Path: string; IncludeSubdirs: boolean): longint;
var ErrDos: integer;
    DirSearchRec: TSearchRec;
begin
  result:=0;
  ErrDos:=FindFirst(path+'\*.*',faReadOnly + faArchive + faHidden, DirSearchRec);
  while ErrDos = 0 do
  begin
    result:=result+GetFileSize(AddPathToFile(Path,DirSearchRec.Name));
    ErrDos:=FindNext(DirSearchRec);
  end;
  if IncludeSubdirs then
  begin
    ErrDos:=FindFirst(path+'\*.*',faDirectory	, DirSearchRec);
    while ErrDos = 0 do
    begin
      if DirSearchRec.Name[1] <> '.' then
        result:=result+DirSize(AddPathToFile(Path,DirSearchRec.Name),true);
      ErrDos:=FindNext(DirSearchRec);
    end;
  end;
  FindClose(DirSearchRec);
end;

function DirExists(dir: string): Boolean;
var ErrDos: integer;
    DirSearchRec: TSearchRec;
begin
  result:=true;
  try
    if (dir <> '') and (dir[length(dir)] = '\') then
      delete(dir,length(dir),1);
      
    ErrDos:=FindFirst(AddPathToFile(ExtractFilePath(dir),'*.*'),faDirectory	, DirSearchRec);
    while ErrDos = 0 do
    begin
      if uppercase(AddPathToFile(ExtractFilePath(dir),DirSearchRec.Name)) = uppercase(dir) then
        exit;
      ErrDos:=FindNext(DirSearchRec);
    end;
    result:=false;
  finally
    FindClose(DirSearchRec);
  end;
end;

procedure SetFileAttr(const FileName: string; dwFileAttributes: DWORD);
begin
  SetFileAttributes(pChar(FileName),dwFileAttributes);
end;

function GetFileAttr(const FileName: string): DWORD;
begin
  result:=GetFileAttributes(pChar(FileName));
end;

function GetFileSize(const FileName: string): longint;
  var f: file;
begin
  {$I-}
  GetFileSize:=0;
  FileMode:=0;  {Read only}
  assign(f,FileName);
  reset(f,1);               if IOResult <> 0 then exit;
  FileMode:=2;  {Read/Write - default}
  GetFileSize:=Filesize(f); if IOResult <> 0 then exit;
  close(f);                 if IOResult <> 0 then exit;
  {$I+}
end;

{ convert a fixed point Double to a string }
function FixedPointStr(r: Double; AfterDP: integer): string;
begin
  result:=Format('%.'+inttostr(AfterDP)+'f',[r]);
end;

function FixedPointStrDP(r: Double; AfterDP: integer): string;
begin
  result:=FixedPointStr(r,AfterDP);
  result:=StrReplace(result,',','.',true);
end;

function DoubleStrDP(r: Double; NumLength: integer; Accuracy: Double; truncate: boolean): string;
begin
  result:=DoubleStr(r,NumLength,Accuracy,truncate);
  result:=StrReplace(result,',','.',true);
end;

{ convert a Double to a string }
function DoubleStr(r: Double; NumLength: integer; Accuracy: Double; truncate: boolean): string;
  function sDouble(r: Double; len: integer; Accuracy: Double): string;
    var s: string;
        i: integer;
  begin
    if len > 0 then
    begin
      if abs(r) < 2*Accuracy then
      begin
        sDouble:=copy('0.000000000000000000000000000000000000',1,Len);
        exit;
      end;

      if r < 0 then
      begin
        sDouble:='-'+sDouble(-r,len-1,accuracy);
        exit;
      end;
      str(r:1:20,s);
      if (pos('E',s) = 0) and (pos('.',s) < len-2) then
      begin
        sDouble:=copy(s,1,len);
        if s[1] = '-' then s:=copy(s,2,255);
        if s[1] <> '0' then exit;    s:=copy(s,2,255);
        if s[1] <> '.' then exit;    s:=copy(s,2,255);
        for i:=1 to len-7 do
        begin
          if s[1] <> '0' then exit;
          s:=copy(s,2,255);
        end;
      end;
    end;

    if abs(r) < 2*Accuracy then r:=0;

    str(r:abs(len)+1,s);
    if s[1] = ' ' then s:=copy(s,2,255);
    sDouble:=s;
  end;

  var s: string;
begin
  if not truncate then
  begin
    DoubleStr:=sDouble(r,NumLength,accuracy);
    exit;
  end;

  if r < 0 then
  begin
    s:='-'+DoubleStr(-r,NumLength,accuracy,truncate);
    DoubleStr:=s;
    exit;
  end;

  s:=sDouble(r,NumLength,Accuracy);
  if (length(s) > 5) and (pos('E+0000',s) = length(s)-5) then
    s:=copy(s,1,length(s)-6);
  while (pos('.',s) <> 0) and (pos('E',s) = 0) and (s[length(s)] = '0') do
    s:=copy(s,1,length(s)-1);
  if s[length(s)] = '.' then
    s:=copy(s,1,length(s)-1);
  while (length(s) > 1) and (s[1] = '0') do s:=copy(s,2,255);
  if s[1] = '.' then s:='0'+s;
  DoubleStr:=s;
end;

function DoubleToStr(r: Double; NumLength: integer; Accuracy: Double; truncate: boolean): string;
begin
  DoubleToStr:=DoubleStr(r,NumLength,Accuracy,truncate);
end;

function FixedLengthStr(r: Double; Len: integer): string;
var i: integer;
begin
  str(r:1:20,result);
  if Pos('E',result) > 0 then
  begin
    result:=FixedLengthStr(StrToDoubleDef(before(result,'E'),0),Len)+'E'+after(result,'E');
  end else
  if length(result) > Len then
  begin
    i:=20;
    while (i > 0) and ((length(result) > Len) or (result[length(result)] = '0')) do
    begin
      dec(i);
      str(r:1:i,result);
      if result = '-0' then
        result:='0';
    end;
  end;
end;

{ converts a longint into a string }
{ lpads with blanks to len chars }
{ if len < 0 then lpads with zeros to len chars }
function NumStr(l,len: longint): string;
  var s: string;
begin
  if len = -1 then
    numstr:=NumStr(l,1) else
  if len < 0 then
  begin
    if l < 0 then
      numstr:='-'+NumStr(-l,len) else
      numstr:=NumStr(l div 10,len+1)+NumStr(l mod 10,1);
  end else
  begin
    str(l:len,s);
    numstr:=s;
  end;
end;

{ converts a string into a Double }
function StrToDouble(s: string; var i: Double; ReportError: boolean): boolean;
  var k: Double;
      j: integer;
begin
  {$R-}
  val(s,k,j);
  {$R+}
  if j = 0 then
    i:=k else
  if ReportError then
    ShowMessage('Error: Bad numeric input - ignored: '+s);
  StrToDouble:=j = 0;
end;

function StrToDoubleDef(const S: string; Default: Double): Double;
begin
  if not StrToDouble(s,result,false) then result:=Default;
end;

{====TLinkedListRec==============================================================}

constructor TLinkedListRec.NewSortedRec(var list: PLinkedListRec);
  var p: PLinkedListRec;
begin
  if (list = nil) or before(@self,list) then
  begin
    next:=list;
    list:=@self;
  end else
  begin
    p:=list;
    while (p^.next <> nil) and not before(@self,p^.next) do p:=p^.next;
    next:=p^.next;
    p^.next:=@self;
  end;
end;

constructor TLinkedListRec.NewRec;
begin
  InitRec;
end;

constructor TLinkedListRec.NewHeadRec(var list: PLinkedListRec);
begin
  InitRec;
  next:=list;
  list:=@self;
end;

constructor TLinkedListRec.NewTailRec(var list: PLinkedListRec);
  var p: PLinkedListRec;
begin
  InitRec;
  if list = nil then
  begin
    list:=@self;
    next:=nil;
  end else
  begin
    p:=list;
    while p^.next <> nil do p:=p^.next;
    p^.next:=@self;
    next:=nil;
  end;
end;

procedure TLinkedListRec.InitRec;
begin
  next:=nil;
end;

procedure TLinkedListRec.DestroyRec(var list: PLinkedListRec);
  var p: PLinkedListRec;
begin
  if list = nil then exit;
  if list = @self then 
  begin
    list:=next;
  end else
  begin
    p:=list;
    while (p <> nil) and (p^.next <> @self) do p:=p^.next;
    if p <> nil then
      p^.next:=next;
  end;
  dispose(@self);
end;

procedure DestroyList(var list: PLinkedListRec);
begin
  while list <> nil do
    list^.DestroyRec(list);
end;

procedure SortList(var oldlist: PLinkedListRec);
  var p,rec,newlist: PLinkedListRec;
begin
  newlist:=nil;
  while oldlist <> nil do
  begin
    rec:=oldlist;
    oldlist:=oldlist^.next;
    if (newlist = nil) or rec^.before(rec,newlist) then
    begin
      rec^.next:=newlist;
      newlist:=rec;
    end else
    begin
      p:=newlist;
      while (p^.next <> nil) and not rec^.before(rec,p^.next) do p:=p^.next;
      rec^.next:=p^.next;
      p^.next:=rec;
    end;
  end;
  oldlist:=newlist; 
end;

function TLinkedListRec.before(a,b: PLinkedListRec): boolean;
begin
  before:=true;
end;

function MyStrToInt(const s: string; var i: integer; ReportError: boolean): boolean;
  var k,j: integer;
begin
  {$R-}
  val(s,k,j);
  {$R+}
  if j = 0 then
    i:=k else
  if ReportError then
    ShowMessage('Error: Bad numeric input - ignored: '+s);
  MyStrToInt:=j = 0;
end;

{ converts a string into a longint }
function StrToLongint(const s: string; var i: Longint; ReportError: boolean): boolean;
  var k: Longint;
      j: integer;
begin
  {$R-}
  val(s,k,j);
  {$R+}
  if j = 0 then
    i:=k else
  if ReportError then
    ShowMessage('Error: Bad numeric input - ignored: '+s);
  StrToLongint:=j = 0;
end;

{ converts a string into a word }
function StrToWord(const s: string; var i: word; ReportError: boolean): boolean;
  var k: word;
      j: integer;
begin
  {$R-}
  val(s,k,j);
  {$R+}
  if j = 0 then
    i:=k else
  if ReportError then
    ShowMessage('Error: Bad numeric input - ignored: '+s);
  StrToWord:=j = 0;
end;

{ converts a hexadecimal string into a word }
function StrToHex(const s: string; var i: word; ReportError: boolean): boolean;
  var l: longint;
begin
  StrToHex:=false;
  if LongStrToHex(s,l,ReportError) and (HiWord(l) = 0) then
  begin
    i:=l;
    StrToHex:=true;
  end;
end;

{ converts a hexadecimal string into a integer }
function StrToHexInt(const s: string; var i: integer; ReportError: boolean): boolean;
var l: longint;
begin
  result:=false;
  if LongStrToHex(s,l,ReportError) then
  begin
    i:=l;
    result:=true;
  end;
end;

function StrToHexDef(const s: string; default: integer): integer;
begin
  LongStrToHex(s,default,false);
  result:=default;
end;

{ converts a string into pairs of hex digits with blanks }
function StrToHexDigits(s: string): string;
var i: integer;
begin
  SetLength(result,length(s)*3);
  for i:=1 to length(s) do
  begin
    result[i*3-2]:=inttohex(ord(s[i]) div 16,1)[1];
    result[i*3-1]:=inttohex(ord(s[i]) mod 16,1)[1];
    result[i*3  ]:=' ';
  end;
end;

{ converts pairs of hex digits with blanks into a string }
function HexDigitsToStr(s: string): string;
var l: integer;
begin
  result:='';
  s:=SkipBlanks(s);
  while s <> '' do
  begin
    if LongStrToHex(StrBefore(s,1,' ',false),l,false) and (l <= $FF) then
      result:=result+char(l);
    s:=SkipBlanks(StrAfter(s,1,' ',false));
  end;
end;

{ converts a string into pairs of hex digits }
function StrToHexDigits2(s: string): string;
var i: integer;
begin
  SetLength(result,length(s)*2);
  for i:=1 to length(s) do
  begin
    result[i*2-1]:=inttohex(ord(s[i]) div 16,1)[1];
    result[i*2  ]:=inttohex(ord(s[i]) mod 16,1)[1];
  end;
end;

{ converts pairs of hex digits with blanks into a string }
function HexDigitsToInt(s: string): string;
var l: integer;
begin
  result:='';
  s:=SkipBlanks(s);
  while s <> '' do
  begin
    if LongStrToHex(StrBefore(s,1,' ',false),l,false) then
      result:=result+inttostr(l)+' ';
    s:=SkipBlanks(StrAfter(s,1,' ',false));
  end;
end;

{ converts a string into pairs of hex digits }
function IntToHexDigits(s: string): string;
var i: integer;
var l: integer;
begin
  result:='';
  s:=SkipBlanks(s);
  while s <> '' do
    if NextIsNumber(s,l) then
      result:=result+inttohex(l,2)+' ' else
      delete(s,1,1);
end;

{ converts pairs of hex digits into a string }
function HexDigitsToStr2(s: string): string;
const c: array ['0'..'F'] of byte =
    (0,1,2,3,4,5,6,7,8,9,0,0,0,0,0,0,0,10,11,12,13,14,15);
var i: integer;
begin
  SetLength(result,length(s) div 2);
  for i:=1 to length(result) do
    result[i]:=char(c[upcase(s[i*2-1])]*16+c[upcase(s[i*2])]);
end;

function StrToBinDigits(s: string): string;
var i: integer;
begin
  result:='';
  for i:=1 to length(s) do
    result:=result+inttobin(ord(s[i]),8)+' ';
end;

{ converts a hexadecimal string into a longint }
function LongStrToHex(s: string; var i: longint; ReportError: boolean): boolean;
  const c: array ['0'..'F'] of byte =
    (0,1,2,3,4,5,6,7,8,9,0,0,0,0,0,0,0,10,11,12,13,14,15);
  var k: longint;
begin
  LongStrToHex:=false;
  k:=0;
  if s = '' then exit;

  while s <> '' do
  begin
    case upcase(s[1]) of
      '0'..'9','A'..'F': k:=(k shl 4)+c[upcase(s[1])];
      else
        begin
          if ReportError then
            ShowMessage('Error: Bad numeric input - ignored: '+s);
          exit;
        end;
    end;
    delete(s,1,1);
  end;
  i:=k;
  LongStrToHex:=true;
end;

{ converts a hexadecimal string into a longint }
function LongStrToNumber(s: string; var i: longint; radix: integer; ReportError: boolean): boolean;
  const c: array ['0'..'Z'] of byte =
    (0,1,2,3,4,5,6,7,8,9,0,0,0,0,0,0,0,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35);
  var d: longint;
      k: int64;
begin
  LongStrToNumber:=false;
  k:=0;
  if s = '' then exit;

  while s <> '' do
  begin
    case upcase(s[1]) of
      '0'..'9','A'..'Z':
        begin
          d:=c[upcase(s[1])];
          if d >= radix then
          begin
            if ReportError then
              ShowMessage('Error: Bad numeric input - ignored: '+s);
            exit;
          end;
          k:=k*radix+d;
        end;
      else
        begin
          if ReportError then
            ShowMessage('Error: Bad numeric input - ignored: '+s);
          exit;
        end;
    end;
    delete(s,1,1);
  end;
  {$R-}
  i:=k;
  {$R+}
  LongStrToNumber:=true;
end;

{ converts a hexadecimal string into a longint }
function LongStrToBin(s: string; var i: longint; ReportError: boolean): boolean;
  var k: longint;
begin
  LongStrToBin:=false;
  k:=0;
  if s = '' then exit;

  while s <> '' do
  begin
    case upcase(s[1]) of
      '0': k:=k*2;
      '1': k:=k*2+1;
      else
        begin
          if ReportError then
            ShowMessage('Error: Bad numeric input - ignored: '+s);
          exit;
        end;
    end;
    delete(s,1,1);
  end;
  i:=k;
  LongStrToBin:=true;
end;

function DWordStrToBin(s: string; var i: DWord; ReportError: boolean): boolean;
var d: longint;
begin
  result:=LongStrToBin(s,d,ReportError);
{$R-}
  if result then
    i:=d;
{$R+}
end;

{ converts a Binary string into a word }
function StrToBin(const s: string; var i: word; ReportError: boolean): boolean;
  var l: longint;
begin
  StrToBin:=false;
  if LongStrToBin(s,l,ReportError) and (HiWord(l) = 0) then
  begin
    i:=l;
    StrToBin:=true;
  end;
end;

function StrToBinDef(const s: string; default: word): word;
begin
  if not StrToBin(s,result,false) then
    result:=default;
end;

{ converts a octal string into a longint }
function LongStrToOct(s: string; var i: longint; ReportError: boolean): boolean;
  const c: array ['0'..'7'] of byte =
    (0,1,2,3,4,5,6,7);
  var k: longint;
begin
  LongStrToOct:=false;
  k:=0;
  if s = '' then exit;

  while s <> '' do
  begin
    case upcase(s[1]) of
      '0'..'7': k:=k*8+c[upcase(s[1])];
      else
        begin
          if ReportError then
            ShowMessage('Error: Bad numeric input - ignored: '+s);
          exit;
        end;
    end;
    delete(s,1,1);
  end;
  i:=k;
  LongStrToOct:=true;
end;

{ converts a octal string into a word }
function StrToOct(const s: string; var i: word; ReportError: boolean): boolean;
  var l: longint;
begin
  StrToOct:=false;
  if LongStrToOct(s,l,ReportError) and (HiWord(l) = 0) then
  begin
    i:=l;
    StrToOct:=true;
  end;
end;

function DataToString(var Data; len: longint): string;
begin
  setlength(result,len);
  if len > 0 then
    move(Data,result[1],len);
end;

function StringDataToString(s: string): string;
begin
  result:=IntDataToString(length(s))+s;
end;

function IntDataToString(i: longint): string;
begin
  result:=DataToString(i,sizeof(i));
end;

function DoubleDataToString(i: Double): string;
begin
  result:=DataToString(i,sizeof(i));
end;

procedure StringToData(var s: string; var Data; len: longint);
begin
  move(s[1],Data,len);
  delete(s,1,len);
end;

function StringToIntData(var s: string): longint;
begin
  move(s[1],result,sizeof(result));
  delete(s,1,sizeof(result));
end;

function StringToIntDataReverse(var s: string): longint;
begin
  result:=
     ord(s[4])+
    (ord(s[3]) shl 8)+
    (ord(s[2]) shl 16)+
    (ord(s[1]) shl 24);
  delete(s,1,sizeof(result));
end;

function StringToStringData(var s: string): string;
var i: integer;
begin
  i:=StringToIntData(s);
  result:=copy(s,1,i);
  delete(s,1,i);
end;

function StringToDoubleData(var s: string): Double;
begin
  move(s[1],result,sizeof(result));
  delete(s,1,sizeof(result));
end;

function BinToStr(w: longint; l: integer): string;
  var s: string;
begin
  s:='';
  repeat
      s:=char(ord('0')+(w and 1))+s;
    w:=w shr 1;
    dec(l);
  until (w = 0) and (l<=0);
  BinToStr:=s;
end;

function IntToBin(w: longint; l: integer): string;
  var s: string;
begin
  s:='';
  repeat
      s:=char(ord('0')+(w and 1))+s;
    w:=w shr 1;
    dec(l);
  until (w = 0) and (l<=0);
  IntToBin:=s;
end;

function DWordToNumber(w: DWord; l,radix: integer): string;
const c: array [0..35] of char= ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G',
  'H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z');
begin
  result:='';
  repeat
    result:=c[w mod radix]+result;
    w:=w div radix;
    dec(l);
  until (w = 0) and (l<=0);
end;

function IntToNumber(w: longint; l,radix: integer): string;
const c: array [0..35] of char= ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','G',
  'H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z');
begin
  result:='';
  repeat
    result:=c[w mod radix]+result;
    w:=w div radix;
    dec(l);
  until (w = 0) and (l<=0);
end;

function MyExtractFilePath(const FileName: string): string;
begin { removes trailing \ }
  result:=ExtractFilePath(FileName);
  if (length(result) > 3) and (result[length(result)] = '\') then
    delete(result,length(result),1);
end;

function GetShortPath(path: string): string;
var t: array[0..1000] of char;
begin
  GetShortPathName(pchar(path),t,1000);
  result:=strpas(t);
end;

function GetFullPath(path: string): string;
var ErrDos: integer;
    DirSearchRec: TSearchRec;
begin
  if (path <> '') and (path[length(path)] = '\') then
    delete(path,length(path),1);
  result:=path;
  if pos('~',result) <> 0 then
  begin
    ErrDos:=FindFirst(ExtractFilePath(path)+'\*.*',faAnyFile, DirSearchRec);
    while ErrDos = 0 do
    begin
      if ExtractFileName(GetShortPath(
        AddPathToFile(ExtractFilePath(path),DirSearchRec.Name))) = ExtractFileName(path) then
        result:=AddPathToFile(ExtractFilePath(path),DirSearchRec.Name);
      ErrDos:=FindNext(DirSearchRec);
    end;
    FindClose(DirSearchRec);
  end;

  if pos('\',result) <> 0 then
    result:=AddPathToFile(GetFullPath(ExtractFilePath(result)),ExtractFileName(result));
end;

function FileExtIs(filename,ext: string): Boolean;
{should include the . of the Ext}
begin
  result:=UpperCase(ExtractFileExt(filename)) = UpperCase(Ext);
end;

function TidyPath(const path: string): string;
var s: string;
begin
  s:=copy(path,1,2);
  result:=path;
  delete(result,1,2);
  while pos('\\',result) > 1 do
    delete(result,pos('\\',result),1);
  while pos('..',result) <> 0 do
    delete(result,pos('..',result),1);
  while pos('\\',result) > 1 do
    delete(result,pos('\\',result),1);
  result:=s+result;
end;

function AddPathToFile(const path: string; const filename: string): string;
begin
  result:=TidyPath(path+'\'+filename);
end;

function NullPathToExePath(const Filename: string): string;
begin
  if ExtractFilePath(filename) = '' then
    result:=ChangeToExePath(filename) else
    result:=filename;
end;

function ChangeToExePath(const filename: string): string;
begin
  result:=AddPathToFile(AppDirectory,ExtractFileName(filename));
end;

function ExecAssociation(filename: string): hinst;
var s: string;
begin
  s:=ExtractFilePath(filename);
  result:=ShellExecute(Application.MainForm.Handle, 'open', pchar(filename), nil,
     pchar(s),SW_SHOWNORMAL);
end;

function ExecAssociationEx(filename: string): hinst;
var s: string;
begin
  result:=ExecAssociation(filename);
  case result of
    0:                           s:='The operating system is out of memory or reSources.';
    ERROR_FILE_NOT_FOUND:        s:='The specified file was not found.';
    ERROR_PATH_NOT_FOUND:        s:='The specified path was not found.';
    ERROR_BAD_FORMAT:            s:='The .EXE file is invalid (non-Win32 .EXE or error in .EXE image).';
    SE_ERR_ACCESSDENIED:         s:='The operating system denied access to the specified file.';
    SE_ERR_ASSOCINCOMPLETE:      s:='The filename association is incomplete or invalid.';
    SE_ERR_DDEBUSY:              s:='The DDE transaction could not be completed because other DDE transactions were being processed.';
    SE_ERR_DDEFAIL:              s:='The DDE transaction failed.';
    SE_ERR_DDETIMEOUT:           s:='The DDE transaction could not be completed because the request timed out.';
    SE_ERR_DLLNOTFOUND:          s:='The specified dynamic-link library was not found.';
    SE_ERR_NOASSOC:              s:='There is no application associated with the given filename extension.';
    SE_ERR_OOM:                  s:='There was not enough memory to complete the operation.';
    SE_ERR_SHARE:                s:='A sharing violation occurred.';
    else                         if result > 32 then
                                   exit else
                                   s:='Unknown error.';
  end;
  ShowErrorMessage('Unable to open file: '+filename+#13#10+s);
end;

function ExecAssociation2(filename,params: string): hinst;
var s: string;
begin
  s:=ExtractFilePath(filename);
  result:=ShellExecute(Application.MainForm.Handle, 'open', pchar(filename), pchar(params),
     pchar(s),SW_SHOWNORMAL);
end;

function ExecAssociation2Ex(filename,params: string): hinst;
var s: string;
begin
  result:=ExecAssociation2(filename,params);
  case result of
    0:                           s:='The operating system is out of memory or reSources.';
    ERROR_FILE_NOT_FOUND:        s:='The specified file was not found.';
    ERROR_PATH_NOT_FOUND:        s:='The specified path was not found.';
    ERROR_BAD_FORMAT:            s:='The .EXE file is invalid (non-Win32 .EXE or error in .EXE image).';
    SE_ERR_ACCESSDENIED:         s:='The operating system denied access to the specified file.';
    SE_ERR_ASSOCINCOMPLETE:      s:='The filename association is incomplete or invalid.';
    SE_ERR_DDEBUSY:              s:='The DDE transaction could not be completed because other DDE transactions were being processed.';
    SE_ERR_DDEFAIL:              s:='The DDE transaction failed.';
    SE_ERR_DDETIMEOUT:           s:='The DDE transaction could not be completed because the request timed out.';
    SE_ERR_DLLNOTFOUND:          s:='The specified dynamic-link library was not found.';
    SE_ERR_NOASSOC:              s:='There is no application associated with the given filename extension.';
    SE_ERR_OOM:                  s:='There was not enough memory to complete the operation.';
    SE_ERR_SHARE:                s:='A sharing violation occurred.';
    else                         if result > 32 then
                                   exit else
                                   s:='Unknown error.';
  end;
  ShowErrorMessage('Unable to open file: '+filename+#13#10+s);
end;

function oldExecAssociation(filename: string255; ext: string): word;
  var s: string255;
begin
  if ext = '' then
  begin
    s:=ExtractFileExt(filename);
    ext:=copy(s,2,3);
  end;
  s[0]:=char(GetProfileString('Extensions',
    StrToPChar(ext), '', @s[1],sizeof(s)-1));
  if pos(' ',s) <> 0 then delete(s,pos(' ',s),255);
  if s = '' then s:='notepad.exe ';
  s:=s+' '+filename+#0;
  result:=WinExec(@s[1],sw_Normal);
end;

function GetProfileLongint(AppName, KeyName: PChar; Default: longint): Longint;
  var s: string20;
begin
  s[0]:=char(GetProfileString(AppName,KeyName,'', @s[1],sizeof(s)-1));
  if s = '' then
    result:=Default else
    StrToLongint(s,result,false);
end;

(*
{ like StrIComp but works with strings }
function PasStrIComp(s1,s2: string): integer;
  var i,j: word;
begin
  if length(s1) < length(s2) then
    j:=length(s1) else
    j:=length(s2);

  for i:=1 to j do
  begin
    if upcase(s1[i]) < upcase(s2[i]) then
    begin
      PasStrIComp:=-1;
      exit;
    end;
    if upcase(s1[i]) > upcase(s2[i]) then
    begin
      PasStrIComp:=+1;
      exit;
    end;
  end;
  if length(s1) < length(s2) then
    PasStrIComp:=-1 else
  if length(s1) > length(s2) then
    PasStrIComp:=+1 else
    PasStrIComp:=0;
end;

*)
function scramble(s: string): string;
   var i: integer;
       p: char;
begin
   p:=s[length(s)];
   for i:=0 to length(s)-2 do
   begin
     inc(p);
     s[i+1]:=char(ord(s[i+1]) xor (ord(p) and 15));
   end;
   scramble:=s;
end;

function encode(s: string): string;
begin
  result:=encodeMinLen(s,0,' ');
end;

function decode(s: string): string;
begin
  result:=decodeMinLen(s,#0);
end;

function encodeMinLen(s: string; minLength: integer; Terminate: char): string;
var i: integer;
    p: char;
begin
  if length(s) < minLength then
    s:=s+Terminate;
  while length(s) < minLength do
    s:=s+char(ord(' ')+random(90));

  p:=char(15);
  for i:=1 to length(s) do
  begin
    s[i]:=char(ord(s[i]) xor (ord(p)));
    p:=char(ord(s[i]) and 15);
  end;
  encodeMinLen:=scramble(s);
end;

function decodeMinLen(s: string; Terminate: char): string;
   var i: integer;
       p: char;
begin
   s:=scramble(s);
   for i:=length(s) downto 2 do
   begin
     p:=char(ord(s[i-1]) and 15);
     s[i]:=char(ord(s[i]) xor (ord(p)));
   end;
   s[1]:=char(ord(s[1]) xor 15);
   if pos(Terminate,s) > 0 then
     delete(s,pos(Terminate,s),255);
   decodeMinLen:=s;
end;

{ same as Yield but actually works }
{ maybe should use ApplicationProcessMessages; }
procedure MyYield(loop: boolean);
  var Msg: TMsg;
begin
  repeat
    if PeekMessage(Msg, 0, 0, 0, pm_Remove) then
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end else
      exit;
  until not loop;
end;

function GetShift: TShiftState;
begin
  result:=[];
  if GetKeyState(vk_Shift)   < 0 then result:=result+[ssShift];
  if GetKeyState(vk_Menu)    < 0 then result:=result+[ssAlt];
  if GetKeyState(vk_Control) < 0 then result:=result+[ssCtrl];
  if GetKeyState(vk_RButton) < 0 then result:=result+[ssRight];
  if GetKeyState(vk_LButton) < 0 then result:=result+[ssLeft];
  if GetKeyState(vk_MButton) < 0 then result:=result+[ssMiddle];
end;

function WindowRespondsToMsg(hWindow: HWnd; msg,wParam: word): THandle;
  procedure Search(w: hWnd);
    var l: longint;
  begin
    w:=GetWindow(W,gw_HWndFirst);
    while w <> 0 do
    begin
      l:=SendMessage(w,msg,wParam,hWindow);
      if (l <> 0) and (l <> hWindow) then
      begin
        WindowRespondsToMsg:=loWord(l);
        exit;
      end;

      Search(GetWindow(W,gw_Child));
      if w = GetWindow(w,gw_HWndLast) then w:=0;
      w:=GetWindow(w,gw_HWndNext);
    end;
  end;

  var W: HWnd;
begin
  WindowRespondsToMsg:=0;
  w:=GetWindow(GetDesktopWindow,GW_Child);
{
  if w = 0 then
    w:=Application^.MainWindow^.hWindow;
  while GetParent(w) <> 0 do w:=GetParent(w);
}
  Search(w);
end;

function RunProgram(const CommandLine: string): THandle;
begin
  result:=RunProgramEx(CommandLine,sw_Normal);
end;

function RunProgramEx(CommandLine: string; CmdShow: Word): THandle;
  var hExecModule: THandle;
begin
  CommandLine:=CommandLine+#0; 
  hExecModule:=WinExec(@CommandLine[1],CmdShow);

  if hExecModule <= 32 then
    ShowMessage('Unable to execute: '+WinExecError(hExecModule)+#13#10+CommandLine);

  RunProgramEx:=hExecModule;
end;

function GetStringTable(ID: Word; const default: string): string255;
begin
  result[0]:=char(LoadString(HInstance,ID,@result[1],sizeof(result)-2));
  if result = '' then result:=default;
end;

function CountSubstr(s,substr: string): integer;
var i: integer;
begin
  i:=1;
  result:=0;
  while MyPosStr(substr,s,false,i) > 0 do
  begin
    i:=MyPosStr(substr,s,false,i)+1;
    inc(result);
  end;
end;

function MyPosStr(substr,s: string; IgnoreIfInQuotes: boolean; n: integer): integer;
{ occurrence of substr in s }
{ on or after char n }
  var i: integer;
      InQuotes: char;
begin
  MyPosStr:=0;
  InQuotes:=' ';
  for i:=n to length(s) do
  begin
    if IgnoreIfInQuotes and ((s[i] = '''') or (s[i] = '"')) then
    begin
      if InQuotes = ' ' then InQuotes:=s[i] else
      if InQuotes = s[i] then InQuotes:=' ';
    end else
    if (InQuotes = ' ') and (copy(s,i,length(substr)) = substr) then
    begin
      MyPosStr:=i;
      exit;
    end;
  end;
end;

function MyPosIdentifier(substr,s: string; IgnoreIfInQuotes: boolean): integer;
{ occurrence of substr in s }
{ on or after char n }
  var i: integer;
      InQuotes: char;
begin
  result:=0;
  InQuotes:=' ';
  s:=' '+s+' ';
  for i:=1 to length(s)-1 do
  begin
    if IgnoreIfInQuotes and ((s[i] = '''') or (s[i] = '"')) then
    begin
      if InQuotes = ' ' then InQuotes:=s[i] else
      if InQuotes = s[i] then InQuotes:=' ';
    end else
    if (InQuotes = ' ') and not alpha(s[i]) and
       (CompareText(copy(s,i+1,length(substr)),substr) = 0) and
       not alphanum(s[i+length(substr)+1]) then
    begin
      result:=i;
      exit;
    end;
  end;
end;

function MyPos(c: char; s: string; IgnoreIfInQuotes: boolean): integer;
  var i: integer;
      InQuotes: char;
begin
  MyPos:=0;
  if IgnoreIfInQuotes then
  begin
    InQuotes:=' ';
    for i:=1 to length(s) do
    begin
      if (s[i] = '''') or (s[i] = '"') then
      begin
        if InQuotes = ' ' then InQuotes:=s[i] else
        if InQuotes = s[i] then InQuotes:=' ';
      end else
      if (InQuotes = ' ') and (s[i] = c) then
      begin
        result:=i;
        exit;
      end;
    end;
  end else
    MyPos:=Pos(c,s);
end;

function StrBefore(s: string; n: integer; c: string; IgnoreIfInQuotes: boolean): string;
  { StrBefore('abc,def,ghi',2,',') is 'abc,def'}
  var i,p: integer;
      t: string;
begin
  t:=s;
  for i:=2 to n do
  begin
    p:=MyPosStr(c,t,IgnoreIfInQuotes,1);
    if p <> 0 then t[p]:=char(ord(t[p]) xor 1);
  end;
  p:=MyPosStr(c,t,IgnoreIfInQuotes,1);
  if p <> 0 then s:=copy(s,1,p-1);
  if n <= 0 then s:='';
  StrBefore:=s;
end;

function StrAfter(s: string; n: integer; c: string; IgnoreIfInQuotes: boolean): string;
  { StrAfter('abc,def,ghi',1,',') is 'def,ghi'}
  var i,p: integer;
begin
  for i:=1 to n do
  begin                                            
    p:=MyPosStr(c,s,IgnoreIfInQuotes,1);
    if p <> 0 then
      delete(s,1,p+length(c)-1) else
      s:='';
  end;
  StrAfter:=s;
end;

function Before(s: string; c: string): string;
begin
  result:=StrBefore(s,1,c,false);
end;

function After(s: string; c: string): string;
begin
  result:=StrAfter(s,1,c,false);
end;

function Between(s: string; c1,c2: string): string;
begin
  result:=Before(After(s,c1),c2);
end;

function BetweenEx(s: string; c: string; n: integer): string;
{BetweenEx('a/b/c/d','/',1) returns 'b'}
begin
  result:=Before(StrAfter(s,n,c,false),c);
end;

function ArcTan2(opp,adj: Double): Double;
begin
  if abs(adj) > abs(opp) then
    result:=ArcTan(opp / adj) else
  if abs(opp) > abs(adj) then
    result:=Pi/2-ArcTan(adj / opp)+Pi else
  if (opp > 0) and (adj > 0) then
    result:=Pi*1/4 else
  if (opp > 0) and (adj < 0) then
    result:=Pi*7/4 else
  if (opp < 0) and (adj > 0) then
    result:=Pi*7/4 else
    result:=Pi*5/4;

  while result < -Pi do
    result:=result+2*Pi;
  while result > +Pi do
    result:=result-2*Pi;

  if opp-adj > 0 then
    result:=result+Pi;
  while result < 0 do
    result:=result+2*pi;
end;

function Tan(x: Double): Double;
begin
  result:=Sin(x) / Cos(x);
end;

function ArcSin(x: Double): Double;
begin
  if x < 0 then
    result:=-ArcSin(-x) else
  begin
    while x > 2*pi do x:=x-2*pi;
    if x > sqrt(0.5) then
      result:=Pi/2-ArcCos(x) else
      result:=ArcTan (x/sqrt(abs(1-sqr (x))));
  end;
end;

function ArcCos(x: Double): Double;
begin
  x:=abs(x);
  while x > 2*pi do x:=x-2*pi;
  if x < sqrt(0.5) then
    result:=Pi/2-ArcSin(x) else
    result:=ArcTan (sqrt(abs(1-sqr (x))) /x);
end;

function cube(a: double): double;
begin
  result:=a*a*a;
end;

function CubeRoot(a: double): double;
begin
  if a > 0 then
    result:=pwr(a,1/3) else
  if a < 0 then
    result:=-pwr(-a,1/3) else
    result:=0;
end;

function cot(x: double): double;
begin
  result:=Cos(x) / Sin(x);
end;

function pwr(a,b: double): double;
begin
  if a = 0 then
    result:=0 else
    result:=exp(ln(a)*b);
end;

function log(a: double): double;
begin
  result:=ln(a)/ln(10);
end;

function alog(a: double): double;
begin
  result:=exp(ln(10)*a)
end;

function Scale_1_2_5(a: double): double;
{find the nearest match in the scale
    0.1     0.2    0.5
    1       2      5
    10      20     50
    100     200    500
    1000    etc.}
begin
  if a < 0 then
    result:=-Scale_1_2_5(-a) else
  if a = 0 then
    result:=0 else
  begin
    result:=alog(1000-(trunc(log(a)+1000)));
    result:=round(alog(round(log(result*a)*3)/3))/result;
  end;
end;

function IntRound(x: Double): integer;
begin
  result:=IntTrunc(x+0.5);
end;

function ClipToByte(x: integer): byte;
begin
  result:=ByteRange(x);
end;

function RoundUp(i,granularity: integer): integer;
var j: integer;
begin
  j:=i mod granularity;
  if j = 0 then
    result:=i else
  if i < 0 then
    result:=i-j else
    result:=i+granularity-j;
end;

function RoundEx(i: single; granularity: integer): integer;
begin
  result:=round(i/granularity)*granularity;
end;

function Floor(x: Double): integer;
begin
  result:=Trunc(x);
  if x < result then dec(result);
end;

function Ceiling(x: Double): integer;
begin
  result:=Trunc(x);
  if x > result then inc(result);
end; 

function IntTrunc(x: Double): integer;
begin
  if x > maxint then
    result:=maxint else
  if x < -maxint then
    result:=-maxint else
    result:=trunc(x);
end;

function WordTrunc(x: Double): word;
begin
  if x > high(word) then
    result:=high(word) else
  if x < low(word) then
    result:=low(word) else
    result:=trunc(x);
end;

function SafeRound(x: Double; max: longint): longint;
begin
  result:=SafeTrunc(x+0.5,max);
end;

function SafeTrunc(x: Double; max: longint): longint;
begin
  if x > max then
    result:=max else
  if x < -max then
    result:=-max else
    result:=trunc(x);
end;

function GetStringTableInt(ID: Word; default: longint): longint;
var s: string[20];
begin
  s[0]:=char(LoadString(HInstance,ID,@s[1],sizeof(s)-2));
  if not StrToLongint(s,result,false) then result:=default;
end;

function CanOverwrite(const FileName: string): Boolean;
begin
  CanOverwrite:=not FileExists(FileName) or
    (MessageDlg(
      'File already exists, overwrite? '+FileName,
      mtConfirmation, [mbYes,mbNo], 0) = mrYes);
end;

function ReverseStr(s: string): string;
var c: char;
    i: integer;
begin
{
  if s = '' then
    result:=s else
    result:=ReverseStr(copy(s,2,maxint))+s[1];
}
  for i:=1 to length(s) div 2 do
  begin
    c:=s[i];
    s[i]:=s[length(s)+1-i];
    s[length(s)+1-i]:=c;
  end;

  result:=s;
end;

function CapitaliseWords(s: string): string;
var i: integer;
begin
  Result:=Lowercase(s);
  for i:=1 to length(s) do
    if (i=1) or not alpha(result[i-1]) then
      Result[i]:=Upcase(Result[i]);
end;

function Capitalise(s: string): string;
begin
  Result:=Lowercase(s);
  if result <> '' then
    Result[1]:=Upcase(Result[1]);
end;

function CapitaliseFirst(s: string): string;
begin
  Result:=s;
  if result <> '' then
    Result[1]:=Upcase(Result[1]);
end;

function StrReplace(s: string; const SubStr1,SubStr2: string; All: boolean): string;
begin
  result:=StrReplaceEx(s,SubStr1,SubStr2,All,false);
end;

function RemoveChar(s: string; c: char): string;
var i,j: integer;
begin
  result:=s;
  j:=0;
  for i:=1 to length(s) do
  if s[i] <> c then
  begin
    inc(j);
    result[j]:=s[i];
  end;
  setlength(result,j);
end;

function StrReplaceEx(s: string; const SubStr1,SubStr2: string; All,IgnoreCase: boolean): string;
var i: integer;
begin
  result:=s;
  if IgnoreCase then
    i:=pos(UpperCase(SubStr1),UpperCase(result)) else
    i:=pos(SubStr1,result);
  while i > 0 do
  begin
    delete(result,i,length(SubStr1));
    insert(SubStr2,result,i);
    if not all then exit;
    if IgnoreCase then
      i:=myposStr(UpperCase(SubStr1),UpperCase(result),false,i+length(SubStr2)) else
      i:=myposStr(SubStr1,result,false,i+length(SubStr2));
  end;
end;

function StrReplaceIdentifier(s: string; const SubStr1,SubStr2: string; All: boolean): string;
var i: integer;
begin
  result:='';
  i:=MyPosIdentifier(SubStr1,s,true);
  while i > 0 do
  begin
    result:=result+copy(s,1,i-1);
    result:=result+SubStr2;
    delete(s,1,i-1+length(SubStr1));
    if not all then exit;
    i:=MyPosIdentifier(SubStr1,s,true);
  end;
  result:=result+s;
end;

function LineToOffset(memo: TMemo; line: integer): integer;
var i: integer;
begin
  result:=0;
  if line >= memo.lines.count then
    result:=memo.GetTextLen else
  for i:=1 to line do
    inc(result,length(memo.lines.strings[i-1])+2);
end;

function CurLine(memo: TMemo): integer;
begin
  result:=OffsetToLine(memo,memo.SelStart);
end;

procedure SetCurLine(memo: TMemo; i: integer);
begin
  memo.SelStart:=LineToOffset(memo,i);
  memo.SelLength:=0;
end;

function OffsetToLine(memo: TMemo; offset: integer): integer;
begin
  result:=StringOffsetToLine(memo.text,offset);
end;

function OffsetToLineRE(RichEdit: TRichEdit; offset: integer): integer;
begin
  result:=StringOffsetToLine(RichEdit.text,offset);
end;

function StringOffsetToLine(s: string; offset: integer): integer;
{first line is line 0}
var i: integer;
begin
  result:=0;
  for i:=1 to IntMin([offset,length(s)]) do
    if s[i] = #10 then
      inc(result);
end;

function StripBlanks(const s: string): string;
begin
  result:=s;
  while pos(' ',result) <> 0 do delete(result,pos(' ',result),1);
end;

function StripTrailingBlanks(const s: string): string;
begin
  result:=s;
  while (result <> '') and (result[length(result)] = ' ') do delete(result,length(result),1);
end;

function SkipBlanks(s: string): string;
begin
  result:=s;
  repeat
    if result = '' then exit;
    case result[1] of
      ' ',char(vk_Tab),#13,#10:
        delete(result,1,1);
      else exit;
    end;
  until false;
end;

function alpha(c: char): boolean;
begin
  alpha:=c in ['a'..'z','A'..'Z'];
end;

function alphanum(c: char): boolean;
begin
  alphanum:=c in ['a'..'z','A'..'Z','0'..'9','_'];
end;

function digit(c: char): boolean;
begin
  digit:=c in ['0'..'9'];
end;

(*
procedure SkipBlanksComments(var s: string);
begin
  repeat
    if s = '' then exit;
    if s[1] <= ' ' then delete(s,1,1) else
    if s[1] = '{' then
    begin
      while (s <> '') and (s[1] <> '}') do
        delete(s,1,1);
      delete(s,1,1);
    end else
      exit;
  until false;
end;

*)

procedure SetSkipComments(b: boolean);
begin
  fSkipComments:=b;
end;

procedure SetSkipBlanks(b: boolean);
begin
  fSkipBlanks:=b;
end;

procedure SetSkipSlashStar(b: boolean);
begin
  fSkipSlashStar:=b;
end;

procedure SkipBlanksComments(var s: string);
begin
  repeat
    if s = '' then exit;

    if (copy(s,1,2) = '/*') and fSkipSlashStar then
    begin
      delete(s,1,2);
      while (s <> '') and (copy(s,1,2) <> '*/') do
        delete(s,1,1);
      delete(s,1,2);
    end;

    case s[1] of
      ' ',char(vk_Tab),#13,#10:
        if fSkipBlanks then
          delete(s,1,1) else
          exit;
      '{':
        if fSkipComments then
        begin
          while (s <> '') and (s[1] <> '}') do
            delete(s,1,1);
          delete(s,1,1);
        end else
          exit;
      else exit;
    end;
  until false;
end;

function ConvertToAlpha(s: string; OtherChars: string): string;
var i: integer;
begin
  for i:=length(s) downto 1 do
    if not ((s[i] in ['a'..'z','A'..'Z']) or (pos(s[i],OtherChars) > 0)) then
      delete(s,i,1);
  result:=s;
end;

function ConvertToAlphanum(s: string; OtherChars: string): string;
var i: integer;
begin
  for i:=length(s) downto 1 do
    if not ((s[i] in ['a'..'z','A'..'Z','0'..'9']) or (pos(s[i],OtherChars) > 0)) then
      delete(s,i,1);
  result:=s;
end;

function RemoveNonHex(s: string): string;
var i: integer;
begin
  for i:=length(s) downto 1 do
    if not (s[i] in ['a'..'f','A'..'F','0'..'9']) then
      delete(s,i,1);
  result:=s;
end;

function ConvertToIdentifierEx(s,default: string; OtherChars: string): string;
begin
  s:=ConvertToAlphanum(s,OtherChars);
  if (s = '') or not alpha(s[1]) then
    s:=default+s;
  result:=s;
end;

function ConvertToIdentifier(s,default: string): string;
begin
  result:=ConvertToIdentifierEx(s,default,'_');
end;

function NextNumberDef(var s: string; default: integer): integer;
begin
  SkipBlanksComments(s);
  if (s <> '') and (s[1] >= '0') and (s[1] <= '9') then
    result:=NextNumber(s) else
    result:=default;
end;

function NextHexNumberDef(var s: string; default: integer): integer;
begin
  SkipBlanksComments(s);
  if (s = '') then
    result:=default else
  case upcase(s[1]) of
    '0'..'9','A'..'F': result:=NextHexNumber(s)
    else result:=default;
  end;
end;

function NextHexNumber(var s: string): integer;
begin
  result:=0;
  try
    while (s <> '') do
    case upcase(s[1]) of
      '0'..'9':
        begin
          result:=result*16+ord(s[1])-ord('0');
          delete(s,1,1);
        end;
      'A'..'F':
        begin
          result:=result*16+ord(upcase(s[1]))-ord('A')+10;
          delete(s,1,1);
        end;
      else exit;
    end;
  finally
    SkipBlanksComments(s);
  end;
end;

function NextNumber(var s: string): integer;
begin
  if Nextis(s,'-') then
    result:=-NextNumber(s) else
  begin
    result:=0;
    while (s <> '') and (s[1] >= '0') and (s[1] <= '9') do
    begin
      result:=result*10+ord(s[1])-ord('0');
      delete(s,1,1);
    end;
  end;
  SkipBlanksComments(s);
end;

function NextExpression(var s: string): Double;
begin
  result:=NextExpressionDef(s,0);
end;

function MustbeExpression(var s: string): Double;
  function Term: double;
  begin
    if nextis(s,'(') then
    begin
      result:=MustbeExpression(s);
      Mustbe(s,')');
    end else
    if nextis(s,'+') then
    begin
      result:=Term;
    end else
    if nextis(s,'-') then
    begin
      result:=-Term;
    end else
      result:=MustbeDouble(s);
  end;
  function MultExp: double;
  begin
    result:=Term;
    repeat
      if NextIs(s,'*') then
        result:=result*Term else
      if NextIs(s,'/') then
        result:=result/Term else
        exit;
    until false;
  end;
  function AddExp: double;
  begin
    result:=MultExp;
    repeat
      if NextIs(s,'+') then
        result:=result+MultExp else
      if NextIs(s,'-') then
        result:=result-MultExp else
        exit;
    until false;
  end;
begin
  SkipBlanksComments(s);
  result:=AddExp;
  SkipBlanksComments(s);
end;

function NextWord(var s: string): string;
begin
  SkipBlanksComments(s);
  result:='';
  while (s <> '') and (s[1] <> ' ') do
  begin
    result:=result+s[1];
    delete(s,1,1);
  end;
  SkipBlanksComments(s);
end;

procedure Mustbe(var s: string; const substr: string);
begin
   if not Nextis(s,substr) then
     raise Exception.Create('"'+substr+'" expected');
end;

function MustbeIdKeepCase(var s: string): string;
begin
  if not NextisIdKeepCase(s,result) then
    raise Exception.Create('Identifier expected');
end;

function MustbeId(var s: string): string;
begin
  if not NextisId(s,result) then
    raise Exception.Create('Identifier expected');
end;

function MustbeString(var s: string): string;
begin
  if not NextisString(s,result) then
    raise Exception.Create('String expected');
end;

function MustbeSignedNumber(var s: string): integer;
var i: integer;
begin
  if Nextis(s,'-') then i:=-1 else
  if Nextis(s,'+') then i:=+1 else
                        i:=+1;
  result:=i*MustbeNumber(s);
end;

function MustbeNumber(var s: string): integer;
begin
  if not NextisNumber(s,result) then
    raise Exception.Create('Number expected');
end;

function MustbeBool(var s: string): boolean;
begin
  if Nextis(s,'true') or Nextis(s,'t') then result:=true else
  if Nextis(s,'false') or Nextis(s,'f') then result:=false else
    raise Exception.Create('Boolean expected');
end;

function PeekIs(var s: string; const substr: string): boolean;
var t: string;
begin
  t:=s;
  result:=NextIs(s,substr);
  if result then
    s:=t;
end;

function NextIs(var s: string; const substr: string): Boolean;
begin
  SkipBlanksComments(s);
  if ((CompareText(copy(s,1,length(substr)),substr)= 0) or
     (copy(s,1,length(substr)) = substr)) and
     (not alphanum(substr[length(substr)]) or
       (length(substr) = length(s)) or
       not alphanum(s[1+length(substr)])) then
  begin
    NextIs:=true;
    delete(s,1,length(substr));
  end else
    NextIs:=false;
  SkipBlanksComments(s);
end;

function NextIsCharSet(var s: string; cset: TSetOfChar; var c: char): boolean;
{case sensitive}
begin
  SkipBlanksComments(s);
  if (s <> '') and (s[1] in cset) then
  begin
    c:=s[1];
    result:=true;
    delete(s,1,1);
  end else
    result:=false;
  SkipBlanksComments(s);
end;

function NextIsFixed(var s: string; const substr: string): Boolean;
{ is substr the next few chars - don't worry whether it's a whole id - ignore case}
begin
  SkipBlanksComments(s);
  if (CompareText(copy(s,1,length(substr)),substr)= 0) then
  begin
    result:=true;
    delete(s,1,length(substr));
  end else
    result:=false;
  SkipBlanksComments(s);
end;

function NextIsNumber(var s: string; var i: integer): boolean;
begin
  SkipBlanksComments(s);
  result:=(s <> '') and (s[1] >= '0') and (s[1] <= '9');
  if result then
    i:=NextNumber(s);
end;

function NextIsHexNumber(var s: string; var i: integer): boolean;
begin
  SkipBlanksComments(s);
  result:=false;
  if (s <> '') then
  case upcase(s[1]) of
    '0'..'9','A'..'F': result:=true;
  end;
  if result then
    i:=NextHexNumber(s);
end;

function NextIsAnyNumber(var s: string; var i: integer): boolean;
begin
  SkipBlanksComments(s);
  result:=false;
  if NextIsFixed(s,'0x') then
    result:=NextIsHexNumber(s,i) else
    result:=NextIsNumber(s,i);
end;

function NextAnyNumber(var s: string): integer;
begin
  if not NextIsAnyNumber(s,result) then
     raise Exception.Create('Number expected');
end;

function NextIsExpression(var s: string; var i: double): boolean;
begin
  SkipBlanksComments(s);
  result:=(s <> '');
  if result then
  case s[1] of
    '0'..'9','(','+','-': ;
    else result:=false;
  end;
  if result then
    i:=MustbeExpression(s);
end;

function NextIsString(var s: string; var str: string): Boolean;
begin
  result:=false;
  SkipBlanksComments(s);
  if (s <> '') and (s[1] = '''') then
  begin
    delete(s,1,1);
    str:=Before(s,'''');
    s:=After(s,'''');
    result:=true;
  end else
  if (s <> '') and (s[1] = '"') then
  begin
    delete(s,1,1);
    str:=Before(s,'"');
    s:=After(s,'"');
    result:=true;
  end;
  SkipBlanksComments(s);
end;

function NextExpressionDef(var s: string; default: double): double;
begin
  if not NextIsExpression(s,result) then
    result:=default;
end;

function NextIsId(var s: string; var id: string): Boolean;
begin
  result:=NextIsIdKeepCase(s,id);
  if result then
    id:=UpperCase(id);
end;

function NextIsIdKeepCase(var s: string; var id: string): Boolean;
var id2: string;
begin
  SkipBlanksComments(s);
  id2:='';
  result:=(s <> '') and alpha(s[1]);
  if result then
  begin
    while (s <> '') and alphanum(s[1]) do
    begin
      id2:=id2+s[1];
      delete(s,1,1);
    end;
    SkipBlanksComments(s);
      id:=id2;
  end;
end;

//differs from next is ID in that ID can start with a number
function NextIsIdNumeric(var s: string; var id: string): Boolean;
begin
  result:=NextIsIdNumericKeepCase(s,id);
  if result then
    id:=UpperCase(id);
end;

function NextIsIdNumericKeepCase(var s: string; var id: string): Boolean;
var id2: string;
begin
  SkipBlanksComments(s);
  id2:='';
  result:=(s <> '') and alphanum(s[1]);
  if result then
  begin
    while (s <> '') and alphanum(s[1]) do
    begin
      id2:=id2+s[1];
      delete(s,1,1);
    end;
    SkipBlanksComments(s);
      id:=id2;
  end;
end;

function NextIsSignedNumber(var s: string; var i: integer): boolean;
begin
  nextis(s,'+');

  if nextis(s,'-') then
  begin
    result:=NextIsSignedNumber(s,i);
    i:=-i;
  end else
    result:=NextIsnumber(s,i);
end;

function NextIsSignedDouble(var s: string; var i: Double): boolean;
var j: integer;
begin
  nextis(s,'+');

  if nextis(s,'-') then
  begin
    result:=NextIsSignedDouble(s,i);
    i:=-i;
  end else
  begin
    result:=NextIsnumber(s,j);
    i:=j;
    if result and NextIs(s,'.') then
    begin
      j:=10;
      while (s <> '') and digit(s[1]) do
      begin
        i:=i+(ord(s[1])-ord('0'))/j;
        j:=j*10;
        delete(s,1,1);
      end;
    end;
    if result and Nextis(s,'E') then
      i:=i*alog(MustbeSignedNumber(s));
  end;
end;

function NextDouble(var s: string): Double;
begin
  result:=NextDoubleDef(s,0);
end;

function NextDoubleDef(var s: string; default: Double): Double;
begin
  if not NextIsSignedDouble(s,result) then
    result:=default;
end;

function IsWin95: boolean;
begin
  result:=((GetVersion and $FF) > 3) or
    (((GetVersion and $FF) = 3) and ((GetVersion and $FF00) > $4000));
end;

function MustbeDouble(var s: string): Double;
begin
  if not NextIsSignedDouble(s,result) then
    raise Exception.Create('Number expected');
end;

function MustbeSignedDouble(var s: string): Double;
begin
  if NextIs(s,'+') then
    result:=MustbeDouble(s) else
  if NextIs(s,'-') then
    result:=-MustbeDouble(s) else
    result:=MustbeDouble(s);
end;

function Printable(c: string): string;
var i: integer;
begin
  for i:=1 to length(c) do
  case c[i] of
    ' '..#255: ;
    else       c[i]:='.';
  end;
  result:=c;
end;

function URLEncode(c: string): string;
var i: integer;
begin
  result:='';
  for i:=1 to length(c) do
  case c[i] of
    'a'..'z','A'..'Z','0'..'9','-','.','_','~': result:=result+c[i];
    else result:=result+'%'+IntToHex(ord(c[i]),2);
  end;
end;

function InstanceExists(instance: THandle): boolean;
  var Proc: TFarProc;
begin
  Proc:=MakeProcInstance(@InstanceExists,Instance);
  if Proc <> nil then
  begin
    FreeProcInstance(Proc);
    InstanceExists:=true;
  end else
    InstanceExists:=false;
end;

function WindowsDirectory: string;
var s: PathStr;
begin
  GetWindowsDirectory(s,sizeof(s)-1);
  result:=StrPas(s);
end;

function AppDirectory: string;
begin
  result:=ExtractFilePath(ParamStr(0));
end;

function CheckForString(s: pChar; Key: Char): boolean;
const ppEdit: array[1..10] of pChar = (nil,nil,nil,nil,nil,nil,nil,nil,nil,nil);
var i: integer;
begin
  result:=false;
  for i:=low(ppEdit) to high(ppEdit) do
  if (ppEdit[i] = nil) or (StrEnd(ppEdit[i]) = StrEnd(s)) then
  begin
    if ppEdit[i] = nil then
      ppEdit[i]:=s;
    if ppEdit[i]^ = Key then                      
      ppEdit[i]:=@ppEdit[i][1] else
      ppEdit[i]:=s;
    result:=ppEdit[i]^ = #0;
    if result then
      ppEdit[i]:=s;
    exit;
  end;
end;

function HasParameter(const s: string; whole: boolean): boolean;
var i: integer;
begin
  result:=false;
  for i:=1 to paramcount do
    if (whole and (upperCase(paramstr(i)) = UpperCase(s)) or
       (not whole and (upperCase(copy(paramstr(i),1,length(s))) = UpperCase(s)))) then
      result:=true;
end;

function GetParameter(const s,default: string): string;
var i: integer;
begin
  result:=default;
  for i:=1 to paramcount do
    if upperCase(copy(paramstr(i),1,length(s))) = UpperCase(s) then
      result:=copy(paramstr(i),length(s)+1,255);
end;

function GetParameterAfter(const s,default: string): string;
var i: integer;
begin
  result:=default;
  for i:=1 to paramcount do
    if upperCase(paramstr(i)) = UpperCase(s) then
      result:=paramstr(i+1);
end;

function IntMin(const a: array of longint): longint;
var i: integer;
begin
  result:=a[low(a)];
  for i:=low(a)+1 to high(a) do
    if a[i] < result then result:=a[i];
end;

function IntMax(const a: array of longint): longint;
var i: integer;
begin
  result:=a[low(a)];
  for i:=low(a)+1 to high(a) do
    if a[i] > result then result:=a[i];
end;

function InRealRange(a,min,max: double): boolean;
begin
  result:=(a >= min) and (a <= max);
end;

function InRange(a,min,max: longint): boolean;
begin
  result:=(a >= min) and (a <= max);
end;

function IntRange(a,min,max: longint): longint;
begin
  if a < min then result:=min else
  if a > max then result:=max else
    result:=a;
end;

function ByteRange(a: longint): byte;
begin
  if a < 0 then result:=0 else
  if a > 255 then result:=255 else
    result:=Lobyte(a);
end;

function RealRange(a,min,max: double): double;
begin
  if a < min then
    result:=min else
  if a > max then
    result:=max else
    result:=a;
end;

function DoubleMin(const a: array of Double): Double;
var i: integer;
begin
  result:=a[low(a)];
  for i:=low(a)+1 to high(a) do
    if a[i] < result then result:=a[i];
end;

function DoubleMax(const a: array of Double): Double;
var i: integer;
begin
  result:=a[low(a)];
  for i:=low(a)+1 to high(a) do
    if a[i] > result then result:=a[i];
end;

procedure SetMinMax(i: integer; var amin,amax: integer);
begin
//if i < 0 then
//randseed:=i;
//if i > 1000 then
//randseed:=i;
  if amax < amin then
  begin
    amax:=i;
    amin:=i;
  end;
  if i < amin then amin:=i;
  if i > amax then amax:=i;
end;

procedure SetMinMaxDouble(i: Double; var amin,amax: Double);
begin
  if amax < amin then
  begin
    amax:=i;
    amin:=i;
  end;
  if i < amin then amin:=i;
  if i > amax then amax:=i;
end;

procedure SetMinMaxSingle(i: Single; var amin,amax: Single);
begin
  if amax < amin then
  begin
    amax:=i;
    amin:=i;
  end;
  if i < amin then amin:=i;
  if i > amax then amax:=i;
end;

function WindowWithClassName(xhWindow: hWnd; p: pChar; recurse: boolean): THandle;
  var Str: array[0..100] of char;

  procedure Search(w: hWnd);
  begin
    w:=GetWindow(W,gw_HWndFirst);
    while w <> 0 do
    begin
      WinProcs.GetClassName(w,Str,sizeof(Str)-1);
      if StrIComp(Str,p) = 0 then
      begin
        WindowWithClassName:=w;
        exit;
      end;
      if recurse then 
        Search(GetWindow(W,gw_Child));
      if w = GetWindow(w,gw_HWndLast) then w:=0;
      w:=GetWindow(w,gw_HWndNext);
    end;
  end;

  var W: HWnd;
begin
  WindowWithClassName:=0;
             
  if xhWindow = 0 then
    xhWindow:=GetWindow(GetDesktopWindow,GW_Child);

  w:=xhWindow;
  while GetParent(w) <> 0 do w:=GetParent(w);

  Search(w);
end;

{ draws a bitmap on a bitmap }
procedure BitmapToBitmap(DC: hDC; Source,dest: THandle; xDest,yDest,w,h,xSrc,ySrc: integer);
  var SourceDC,DestDC: hDC;
      OldSource,OldDest: hBitmap;
begin
  if Source = 0 then exit;

  SourceDC:=CreateCompatibleDC(DC);
  DestDC:=CreateCompatibleDC(DC);
  OldSource:=SelectObject(SourceDC,Source);
  OldDest:=SelectObject(DestDC,Dest);

  BitBlt(DestDC,xDest,yDest,w,h,SourceDC,xSrc,ySrc,srcCopy);

  SelectObject(DestDC,OldDest);
  SelectObject(SourceDC,OldSource);
  DeleteDC(DestDC);
  DeleteDC(SourceDC);
end;

{ x,y size of a bitmap }
procedure BitmapSize(Bitmap: hBitmap; var w,h: integer);
  var BitmapRec: TBitmap;
begin
  GetObject(Bitmap,Sizeof(BitmapRec),@BitmapRec);

  with BitmapRec do
  begin
    w:=bmwidth;
    h:=bmHeight;
  end;
end;

{ copies a bitmap: new bitmap is compatible with DC }
function CopyBitmap(DC: HDC; src: HBitmap): HBitmap;
{ if DC is 0 then uses desktop DC }
  var Width, Height: Integer;
      cpy: HBitmap;
begin
  if DC = 0 then
  begin
    DC:=GetDC(0);
    CopyBitmap:=CopyBitmap(DC,src);
    ReleaseDC(0,DC);
  end else
  if src <> 0 then
  begin
    BitmapSize(src,Width,Height);
    cpy:=CreateCompatibleBitmap(DC,Width,Height);
    BitmapToBitmap(DC,src,cpy,0,0,Width,Height,0,0);
    CopyBitmap:=cpy;
  end else
    CopyBitmap:=0;
end;

{ copies from a bitmap to a DC with a RasterOp }
procedure BitmapToDCEx(DC: hDC; Bitmap: THandle; x,y,w,h,xSrc,ySrc: integer;
      ROP2: longint);
  var memDC: hDC;
      OldBitmap: hBitmap;
begin
  if Bitmap = 0 then exit;

  memDC:=CreateCompatibleDC(DC);
  OldBitmap:=SelectObject(MemDC,Bitmap);
  BitBlt(DC,x,y,w,h,MemDC,xSrc,ySrc,ROP2);
  SelectObject(MemDC,OldBitmap);
  DeleteDC(MemDC);
end;

{ copies from a bitmap to a DC }
procedure BitmapToDC(DC: hDC; Bitmap: THandle; x,y,w,h,xSrc,ySrc: integer);
begin
  BitmapToDCEx(DC,Bitmap,x,y,w,h,xSrc,ySrc,srcCopy);
end;

function DLLLoaded(s: string): THandle;
  var p: PModuleRec;
begin
  s:=s+#0; s[sizeof(s)-1]:=#0;

  p:=ModuleList;
  while p <> nil do
  begin
    if CompareText(p^.DLLName,s) = 0 then
    begin
      result:=p^.hModule;
      exit;
    end;
    p:=p^.next;
  end;
  result:=0;
end;

function LoadDLL(s: string): THandle;
  var hModule: THandle;
      p: PModuleRec;
begin
  result:=DLLLoaded(s);
  if result <> 0 then exit;

  s:=s+#0; s[sizeof(s)-1]:=#0;
  hModule:=LoadLibrary(@s[1]);
  new(p);
  p^.hModule:=hModule;
  p^.DLLName:=s;
  p^.next:=ModuleList;
  ModuleList:=p;
  result:=hModule;
end;

function LoadDLLProc(DLL: string255; name: string255; ReportError: boolean): pointer;
  var hModule: THandle;
      p: pointer;
begin
  result:=nil;
  hModule:=LoadDLL(DLL);
  if hModule > 32 then
  begin
    name:=name+#0; name[sizeof(name)-1]:=#0; dec(name[0]);
    p:=GetProcAddress(hModule,@name[1]);
    result:=p;
    if (p = nil) and ReportError then
      ShowMessage('Can''t find '+name+' in '+DLL);
  end;
end;

procedure FreeDlls;
  var p: PModuleRec;
begin
  p:=ModuleList;
  while p <> nil do
  begin
    FreeLibrary(p^.hModule);
    p:=p^.next;
  end;
  ModuleList:=nil;
end;

procedure ShowLongint(const s: string; value: longint);
begin
  ShowMessage(s+#13#10+inttostr(value));
end;

function ComponentToText(Component: TComponent): String;
var  myStream1: TMemoryStream;
     b: byte;
begin
  myStream1 := TMemoryStream.Create;
  myStream1.WriteComponent(Component);
  myStream1.Seek(0,soFromBeginning);

  result:='';
  repeat
    myStream1.Read(b,1);
    //unfinished
(*
0 data
1
2 byte
3 word
4 longint
5
6
7
8 boolean
9
a data


54 50 46 30                TPF0
06 54 49 6D 61 67 65       TImage
07 49 6D 61 67 65 33 35    Image35
03 54 61 67                Tag
04 02 03 00 40
04 4C 65 66 74             Left
02 48
03 54 6F 70                Top
03 20 01
05 57 69 64 74 68          Width
02 1E
06 48 65 69 67 68 74       Height
02 1E
0C 50 69 63 74 75 72 65 2E 44 61 74 61  Picture.Data
0A 4A 0B 00 00           datalen=000B4A
07 54 42                 data starts
69 74 6D 61 70 3E 0B 00 00 42 4D 3E 0B 00 00 00
00 00 00 36 04 00 00 28 00 00 00 3C 00 00 00 1E
00 00 00 01 00 08 00 00 00 00 00 08 07 00 00 00
................
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 FF FF FF FF FF FF FF
FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF
FF FF FF FF FF FF FF
07 56 69 73 69 62 6C 65    Visible
08 00
00                         end

object Image35: TImage
  Tag = 1073742594
  Left = 72
  Top = 288
  Width = 30
  Height = 30
  Picture.Data = {
    07544269746D61703E0B0000424D3E0B00000000000036040000280000003C00
    00001E0000000100080000000000080700000000000000000000000100000001
    000000000000000080000080000000808000800000008000800080800000C0C0
    C000C0DCC000F0CAA60000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000F0FBFF00A4A0
    A000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFF
    FF00000000000000000000000000000000000000000000000000000000000000
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
    00000000000000000000000000000000000000000000000000000000FFFFFFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000
    000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFF
    FFFFFF0000000000000000FFFFFFFFFFFFFFFFFFFFFF00000000000000000000
    00FB00000000FB00000000000000000000000000FFFFFFFFFFFFFFFFFFFF0000
    00000000000000FFFFFFFFFFFFFFFFFFFFFF000000000000000000FDFDFDFDFD
    FDFD0505000000000000000000000000FFFFFFFFFFFFFFFFFF00000000000000
    00000000FFFFFFFFFFFFFFFFFFFF000000000000000000FDFDFDFDFDFDFD0505
    000000000000000000000000FFFFFFFFFFFFFFFFFF0000000000000000000000
    00FFFFFFFFFFFFFFFFFF000000000000000000FDFDFDFDFDFDFD0505FBFB0000
    0000000000000000FFFFFFFFFFFFFFFFFF000000000000000000000000FFFFFF
    FFFFFFFFFFFF000000000000000000FDFDFDFDFDFDFD0505FBFB000000000000
    00000000FFFFFFFFFFFFFFFFFF000000000000000000000000FFFFFFFFFFFFFF
    FFFF0000000000000000FD050505050505050505000000000000000000000000
    FFFFFFFFFFFFFFFF00000000000000000000000000FFFFFFFFFFFFFFFFFF0000
    000000000000FD050505050505050505050000000000000000000000FFFFFFFF
    FFFFFFFF000000000000000000000000FFFFFFFFFFFFFFFFFFFF000000000000
    00FDFFFFFFFFFFFFFF050505050000000000000000000000FFFFFFFFFFFFFF00
    000000000000000000000000FFFFFFFFFFFFFFFFFFFF00000000000000FDFFFF
    FFFFFFFF05050505050000000000000000000000FFFFFFFFFFFFFF0000000000
    0000000000000000FFFFFFFFFFFFFFFFFFFF000000000000FD05050505050505
    05FF0505050000000000000000000000FFFFFFFFFFFF00000000000000000000
    00000000FFFFFFFFFFFFFFFFFFFF000000000000FDFDFDFDFDFDFDFDFDFF0505
    050000000000000000000000FFFFFFFFFFFF0000000000000000000000000000
    FFFFFFFFFFFFFFFFFFFF000000000000FDFDFDFDFDFDFDFDFDFF050505000000
    0000000000000000FFFFFFFFFFFF0000000000000000000000000000FFFFFFFF
    FFFFFFFFFFFF000000000000FDFDFDFDFDFDFDFDFDFF05050500000000000000
    00000000FFFFFFFFFFFF0000000000000000000000000000FFFFFFFFFFFFFFFF
    FFFF000000000000FDFDFDFDFDFDFDFDFD050505050000000000000000000000
    FFFFFFFFFFFF0000000000000000000000000000FFFFFFFFFFFFFFFFFFFF0000
    00000000FDFDFDFDFDFDFDFDFDFF0505050000000000000000000000FFFFFFFF
    FFFF0000000000000000000000000000FFFFFFFFFFFFFFFFFFFF000000000000
    FDFDFDFDFDFDFDFDFDFF0505050000000000000000000000FFFFFFFFFFFF0000
    000000000000000000000000FFFFFFFFFFFFFFFFFFFF000000000000FDFDFDFD
    FDFDFDFDFDFF0505050000000000000000000000FFFFFFFFFFFF000000000000
    0000000000000000FFFFFFFFFFFFFFFFFFFF000000000000FD05050505050505
    05FF0505000000000000000000000000FFFFFFFFFFFF00000000000000000000
    0000000000FFFFFFFFFFFFFFFFFF00000000000000FD07070707070707050505
    FBFB00000000000000000000FFFFFFFFFFFFFF00000000000000000000000000
    00FFFFFFFFFFFFFFFFFF00000000000000FDFDFDFDFDFDFDFDFD0505FBFB0000
    0000000000000000FFFFFFFFFFFFFF0000000000000000000000000000FFFFFF
    FFFFFFFFFFFF0000000000000000FDFDFDFDFDFDFDFD05050000000000000000
    00000000FFFFFFFFFFFFFFFF00000000000000000000000000FFFFFFFFFFFFFF
    FFFF0000000000000000FDFDFDFDFDFDFDFD0505050000000000000000000000
    FFFFFFFFFFFFFFFF000000000000000000000000FFFFFFFFFFFFFFFFFFFF0000
    000000000000FDFDFDFDFDFDFDFD0505000000000000000000000000FFFFFFFF
    FFFFFFFF0000000000000000000000FFFFFFFFFFFFFFFFFFFFFF000000000000
    0000000000F900000000F900000000000000000000000000FFFFFFFFFFFFFFFF
    FF000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000
    0000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFF0000
    0000000000FFFFFFFFFFFFFFFFFFFFFFFFFF0000000000000000000000000000
    00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000000
    000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
    FFFFFFFFFFFFFFFFFFFF}
  Visible = False
  OnMouseDown = imgNS1MouseDown
end

*)
  until false;

  myStream1.Destroy;
end;

function NameToComponent(const name: string; Form: TForm): TComponent;
var
  I: Integer;
begin
  result:=nil;
  for I := 0 to Form.ComponentCount -1 do
    if Form.Components[I].Name = name then
      result:=Form.Components[I];
end;

function CreateAndGetFont(FaceName: PChar; size: integer;
    bold,Italic,Underline,StrikeOut: boolean; angle: integer): HFont;
  var FontInfo: TLogFont;
begin
  with FontInfo do
  begin
    FillChar(FontInfo, SizeOf(FontInfo), #0);
    lfHeight:=size;
    lfWidth:=0;
    lfEscapement:=angle*10;
    lfOrientation:=angle*10;
    if bold then lfWeight:=FW_BOLD else lfWeight:=FW_NORMAL;
    lfItalic:=ord(Italic);
    lfUnderline:=ord(Underline);
    lfStrikeOut:=ord(StrikeOut);
    lfCharSet:=DEFAULT_CHARSET;
    lfOutPrecision:=Out_Default_Precis;
    lfClipPrecision:=Out_Default_Precis;
    lfQuality:=Default_Quality;
    lfPitchAndFamily:=Default_Pitch;
    StrCopy(lfFaceName,FaceName);

    CreateAndGetFont:=CreateFontIndirect(FontInfo);
  end;
end;

procedure RotatedTextOutOld(Canvas: TCanvas; X, Y: Integer; const Text: string;
  Angle,BkMode: integer);
var NewFont,OldFont: HFont;
begin
  NewFont:=CreateAndGetFont(
    StrToPChar(Canvas.Font.Name),
    -abs(Canvas.Font.Height),
    fsBold in Canvas.Font.Style,
    fsItalic in Canvas.Font.Style,
    fsUnderline in Canvas.Font.Style,
    fsStrikeOut in Canvas.Font.Style,
    Angle);

  OldFont:=SelectObject(Canvas.Handle,NewFont);
  SetBkMode(Canvas.Handle,BkMode);
  TextOut(Canvas.Handle,X,Y,@Text[1],length(Text));
  SelectObject(Canvas.Handle,OldFont);
  DeleteObject(NewFont);
end;

procedure RotatedTextNew(Canvas: TCanvas; x,y: integer; Text: string; Angle: integer);
var
  LogRec: TLOGFONT;
  OldFont,
  NewFont: HFONT;
  P1, P2, P3, P4: TPoint;
begin
  with Canvas do
  begin
    Font := Canvas.Font;
    Brush.Style := bsClear;
    GetObject(Font.Handle, SizeOf(LogRec), @LogRec);
    LogRec.lfEscapement := Angle*10;
    LogRec.lfOutPrecision := OUT_TT_ONLY_PRECIS;
    NewFont := CreateFontIndirect(LogRec);
    OldFont := SelectObject(Canvas.Handle,NewFont);
    TextOut(X, Y, Text);
    NewFont := SelectObject(Canvas.Handle,OldFont);
    DeleteObject(NewFont);
  end;
end;

procedure RotatedTextInRect(Canvas: TCanvas; Text: string; Angle: integer; aRect: TRect);
var
  LogRec: TLOGFONT;
  OldFont,
  NewFont: HFONT;
  midX, midY, H, W, X, Y: integer;
  P1, P2, P3, P4: TPoint;
begin
  with Canvas do
  begin
    Font := Canvas.Font;
    midX := (aRect.Left+aRect.Right) div 2;
    midY := (aRect.Top+aRect.Bottom) div 2;
    Brush.Style := bsClear;
    GetObject(Font.Handle, SizeOf(LogRec), @LogRec);
    LogRec.lfEscapement := Angle*10;
    LogRec.lfOutPrecision := OUT_TT_ONLY_PRECIS;
    NewFont := CreateFontIndirect(LogRec);
    OldFont := SelectObject(Canvas.Handle,NewFont);
    W := TextWidth(Text);
    H := TextHeight(Text);
    X := midX - trunc(W/2*cos(Angle*PI/180)) - trunc(H/2*sin(Angle*PI/180));
    Y := midY + trunc(W/2*sin(Angle*PI/180)) - trunc(H/2*cos(Angle*PI/180));
    TextOut(X, Y, Text);
    NewFont := SelectObject(Canvas.Handle,OldFont);
    DeleteObject(NewFont);
  end;
end;

function CopyFont(Font: TFont; angle: integer): TLogFont;
begin
  result.lfHeight:=abs(Font.Height)-1;//should be minus internal leading??? (not -1)
  StrPCopy(result.lfFaceName,Font.Name);
  result.lfWidth:=$00001000;
//  result.lfWidth:=0;
  result.lfEscapement:= Angle*10;
//  result.lfEscapement:=0;
  result.lfOrientation:= Angle*10;
//  result.lfOrientation:= 0;
  result.lfItalic:=ord(fsItalic in Font.Style);
  result.lfUnderline:=ord(fsUnderline in Font.Style);
  result.lfStrikeOut:=ord(fsStrikeOut in Font.Style);
  if fsBold in Font.Style then
    result.lfWeight:=FW_BOLD else
    result.lfWeight:=FW_NORMAL;
  result.lfCharSet:=DEFAULT_CHARSET;
  result.lfOutPrecision:=OUT_DEFAULT_PRECIS;
  result.lfClipPrecision:=CLIP_DEFAULT_PRECIS;
  result.lfQuality:=DEFAULT_QUALITY;
  result.lfPitchAndFamily:=DEFAULT_PITCH;
end;

procedure RotatedTextOut(Canvas: TCanvas; X, Y: Integer; const Text: string;
  Angle: integer);
var NewFont,OldFont: HFont;
    h: HDC;
begin
  NewFont:= CreateFontIndirect(CopyFont(Canvas.Font,Angle));
  h:=Canvas.Handle;
  OldFont:=SelectObject(h,NewFont);
  TextOut(h,X,Y,pchar(Text),length(Text));
  SelectObject(h,OldFont);
  DeleteObject(NewFont);
end;

{ draws a filled triangle in a colour }
procedure DrawFilledTrian(Canvas: TCanvas; x1,y1,x2,y2,x3,y3: integer; col: TColor);
begin
  With Canvas do
  begin
    Brush.Color:=col;
    Polygon([Point(x1,y1),Point(x2,y2),Point(x3,y3)]);
  end;
end;

{ draws a filled quadrilateral in a colour }
procedure DrawFilledQuad(Canvas: TCanvas; x1,y1,x2,y2,x3,y3,x4,y4: integer; col: TColor);
begin
  With Canvas do
  begin
    Brush.Color:=col;
    Polygon([Point(x1,y1),Point(x2,y2),Point(x3,y3),Point(x4,y4)]);
  end;
end;

procedure DrawFilledQuadPt(Canvas: TCanvas; a1,a2,a3,a4: TPoint; col: TColor);
begin
  DrawFilledQuad(Canvas,a1.x,a1.y,a2.x,a2.y,a3.x,a3.y,a4.x,a4.y,col);
end;

procedure DrawHatchPolygon(aCanvas: TCanvas; p: array of TPoint; NS,EW,NE,NW: integer);
var RGN: HRGN;
    i,x1,x2,y1,y2: integer;
begin
  with aCanvas do
  begin
    x1:=maxint;
    y1:=maxint;
    x2:=-maxint;
    y2:=-maxint;

    moveto(p[high(p)].x,p[high(p)].y);
    for i:=0 to high(p) do
    begin
      x1:=min(x1,p[i].x);
      y1:=min(y1,p[i].y);
      x2:=max(x2,p[i].x);
      y2:=max(y2,p[i].y);
      lineto(p[i].x,p[i].y);
    end;

    i:=length(p);
    RGN:=CreatePolyPolygonRgn(p,i,1, ALTERNATE);
    SelectClipRgn(handle,RGN);


    if NW > 0 then
    for i:=0 to x2-x1+y2-y1 do
    if (i-x1) mod NW = 0 then
    begin
      moveto(x1+i,y1);
      lineto(x1,y1+i);
    end;

    if NE > 0 then
    for i:=0 to x2-x1+y2-y1 do
    if (i-x1) mod NE = 0 then
    begin
      moveto(x1+i,y2);
      lineto(x1,y2-i);
    end;

    if NS > 0 then
    for i:=x1 to x2 do
    if (i-x1) mod NS = 0 then
    begin
      moveto(i,y1);
      lineto(i,y2);
    end;

    if EW > 0 then
    for i:=y1 to y2 do
    if (i-y1) mod EW = 0 then
    begin
      moveto(x1,i);
      lineto(x2,i);
    end;

    SelectClipRgn(handle,0);
    DeleteObject(RGN);
  end;
end;

procedure FillPoly(Canvas: TCanvas; Poly1: array of TPoint);
var FRgn: HRGN;
    i: integer;
begin
  with Canvas do
  try
    i:=length(poly1);
    FRgn:=CreatePolyPolygonRgn(Poly1,i, 1, ALTERNATE);
    FillRgn(Canvas.Handle, FRgn, Canvas.Brush.Handle);
  finally
    DeleteObject(FRgn);
  end;
end;

function safeDiv(a,b: integer): integer;
begin
  if b = 0 then
    safeDiv:=0 else
    safeDiv:=a div b;
end;

function safeDivide(a,b: Double): Double;
begin
  if b = 0 then
    safeDivide:=0 else
    safeDivide:=a/b;
end;

function RealMod(a,b: Double): Double;
begin
  result:=a-b*IntTrunc(a/b);
  while result < 0 do result:=result+b;
  while result > b do result:=result-b;
end;

function TwoPiRange(a: Double): Double;
begin
  result:=RealMod(a,2*pi);
end;

function BoolStr(sT,sF: string; b: boolean): string;
begin
  if b then result:=sT else result:=sF;
end;

function BoolToStr(b: boolean): string;
begin
  result:=BoolStr('true','false',b);
end;

procedure SortStrings(Strings: TStrings);
var StringList: TStringList;
begin
  try
    StringList:=TStringList.Create;
    StringList.Assign(Strings);
    StringList.Sort;
    Strings.Assign(StringList);
  finally
    StringList.Free;
  end;
end;

procedure StringsToClipboard(Strings: TStrings);
var Buffer: PChar;
    Size: integer;
    MemStr: TMemoryStream;
begin
  MemStr := TMemoryStream.Create;
  try
    Strings.SaveToStream(MemStr);
    try
      Size:=MemStr.Seek(0,soFromEnd);
      GetMem(Buffer, Size+1);
      MemStr.Seek(0,0);
      MemStr.ReadBuffer(Buffer^,Size);
      Buffer[Size]:=#0;
      Clipboard.SetTextBuf(Buffer);
    finally
      FreeMem(Buffer, Size+1);
    end;
  finally
    MemStr.Free;
  end;
end;

{ copies whole window contents into the clipboard as a bitmap}
procedure WindowToClipboard(hWindow: hWnd);
  var BitmapH: hBitmap;
      WindowDC,BitmapDC: hDC;
      hPrev: hBitMap;
      ok: boolean;
      R: TRect;
begin
  ok:=false;
  GetClientRect(hWindow,R);
  WindowDC:=GetDC(hWindow);
  BitmapDC:=CreateCompatibleDC(WindowDC);
  BitmapH:=CreateCompatibleBitMap(WindowDC,R.right,R.bottom);
  hPrev:=SelectObject(BitmapDC,BitmapH);
  if (WindowDC <> 0) and (BitmapDC <> 0) and (BitmapH <> 0) and
    BitBlt(BitmapDC,0,0,R.right,R.bottom,WindowDC,0,0,srcCopy) and
    OpenClipboard(hWindow) then
  begin
    EmptyClipboard;
    SetClipboardData(cf_Bitmap,BitmapH);
    ok:=true;
    CloseClipboard;
    InvertRect(WindowDC,R);
    InvertRect(WindowDC,R);
  end;

  SelectObject(BitmapDC,hPrev);
  DeleteDC(BitmapDC);
  ReleaseDC(hWindow,WindowDC);

  if not ok then
    messagebox(0,'Error: unable to copy plot to Clipboard',
      'Copy Window',mb_OK or mb_TaskModal);
end;

procedure PrintStrings(Strings: TStrings; FontSize: integer;
  FontStyle: TFontStyles; const FontName: string);
  var h,y,i: integer;
begin
  Printer.BeginDoc;
  with Printer.Canvas do
  try
    Font.Size:=FontSize;
    Font.Style:=FontStyle;
    Font.Name:=FontName;
    textOut(0,0,' ');
    h:=textheight('X');
    y:=3*h;

    for i:=0 to Strings.Count-1 do
    begin
      if y+3*h > Printer.PageHeight then
      begin
        Printer.NewPage;
        y:=3*h;
      end;
      textOut(0,y,'      '+Strings.Strings[i]);
      inc(y,h);
    end;
  finally
    Printer.EndDoc;
  end;
end;

procedure CanvasToClipboard(Canvas: TCanvas);
var
  TheImage: Graphics.TBitmap;
begin
  with Canvas do
  begin
    TheImage := Graphics.TBitmap.Create;
    try
      TheImage.Height := ClipRect.Bottom;
      TheImage.Width := ClipRect.Right;
      TheImage.Canvas.CopyRect(ClipRect, Canvas, ClipRect);
      Clipboard.Assign(TheImage);
    finally
      TheImage.Destroy;
    end;
  end;
{
  WindowToClipboard(Handle);
}
end;

{ fetches private data format from the clipboard }
procedure PrivateFromClipboard(id: pChar; var hData: THandle; var DataSize: word);
  type TArray = array[1..65535] of byte;
  var hClip: THandle;
      pData,pClip: ^TArray;
      j,i: word;
begin
  hData:=0;

  if IsClipboardFormatAvailable(cf_DSPText) and
     OpenClipboard(0) then
  begin
    hClip:=GetClipboardData(cf_DSPText);
    if hClip <> 0 then
    begin
      pClip:=GlobalLock(hClip);
      if pClip <> nil then
      begin
        if (StrLComp(id,pChar(pClip),strlen(id)) = 0) and
          (pClip^[strlen(id)+1] = 255) then
        begin
          i:=strlen(id)+2;
          DataSize:=((pClip^[i+3] and 15) shl 12) +
                    ((pClip^[i+2] and 15) shl  8) +
                    ((pClip^[i+1] and 15) shl  4) +
                    ((pClip^[i+0] and 15) shl  0);
          i:=i+4;

          hData:=GlobalAlloc(gmem_Moveable or gmem_Zeroinit,DataSize);
          if hData <> 0 then
          begin
            pData:=GlobalLock(hData);
            if pData <> nil then
            begin
              for j:=1 to DataSize do
              if pClip^[i] = 1 then
              begin
                inc(i);
                pData^[j]:=pClip^[i]-1; inc(i);
              end else
              begin
                pData^[j]:=pClip^[i]; inc(i);
              end;

              GlobalUnlock(hData);
            end;
          end;
        end;

        GlobalUnlock(hClip);
      end;
    end;
    CloseClipboard;
  end;
end;

{ puts private data format into the clipboard }
function PrivateToClipboard(id: pChar; Data: pointer; DataSize: word): boolean;
  type TArray = array[1..65535] of byte;
  var hClip: THandle;
      pData: ^TArray absolute Data;
      pClip: ^TArray;
      size: longint;
      j,i: word;
begin
  PrivateToClipboard:=false;
  if (id = nil) or (strlen(id) = 0) then exit;

  size:=DataSize;
  size:=size+strlen(id)+5;
  if size > $FFFE then exit;

  hClip := GlobalAlloc(gmem_Moveable,size);
  if hClip <> 0 then
  begin
    pClip:=GlobalLock(hClip);
    if pClip <> nil then
    begin
      move(id^,pClip^,strlen(id));
      i:=strlen(id)+1;
      pClip^[i]:=255; inc(i);
      pClip^[i]:=(DataSize shr  0) and 15 + ord('0'); inc(i);
      pClip^[i]:=(DataSize shr  4) and 15 + ord('0'); inc(i);
      pClip^[i]:=(DataSize shr  8) and 15 + ord('0'); inc(i);
      pClip^[i]:=(DataSize shr 12) and 15 + ord('0'); inc(i);
      for j:=1 to DataSize do
      begin
        if i+2 > GlobalSize(hClip) then
        begin
          GlobalUnlock(hClip);
          if i+3 > $FFFE then
          begin
            GlobalFree(hClip);
            exit;
          end;
          hClip:=GlobalReAlloc(hClip,i+3,gmem_Moveable);
          if hClip=0 then exit;
        end;

        if pData^[j] < 2 then
        begin
          pClip^[i]:=1; inc(i);
          pClip^[i]:=pData^[j]+1; inc(i);
        end else
        begin
          pClip^[i]:=pData^[j]; inc(i);
        end;
      end;

      pClip^[i]:=0;
      GlobalUnlock(hClip);

      if OpenClipboard(0) then
      begin
        EmptyClipboard;
        SetClipboardData(cf_DSPText,hClip);
        CloseClipboard;
        PrivateToClipboard:=true;
      end else
        GlobalFree(hClip);
    end else
      GlobalFree(hClip);
  end;
end;

function NearestSecond(Time: TDateTime): TDateTime;
var Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(Time,Hour,Min,Sec,MSec);
  result:=EncodeTime(Hour, Min, Sec, 0);
end;

function GetRegistrationEntry(Root: HKEY; Key,SubKey: string): string;
var cb,kind: Longint;
    k: HKEY;
    Value: array[0..255] of char;
begin
  result:='';
  if RegOpenKey(Root,@Key[1],k) = ERROR_SUCCESS then
  begin
    cb := sizeof(Value);
    RegQueryValueEx(k,@SubKey[1],nil,@kind,@Value,@cb);
    result:=StrPas(Value);
    RegCloseKey(k);
  end;
end;

procedure SetRegistrationEntry(Root: HKEY; Key,Value: String);
var key2: hKey;
begin
  if (RegCreateKey(HKEY_CLASSES_ROOT,@key[1],Key2) = ERROR_SUCCESS) then
  begin
    RegSetValueEx(Key2,'',0,Reg_Sz,@Value[1],length(Value)+1);
    RegCloseKey(Key2);
    RegFlushKey(Key2);
  end else
    raise Exception.Create('Cannot create Registry key: '+Value);
end;

{ erase a file }
function oldEraseFile(filename: string): Boolean;
var f: file;
begin
  {$I-}
  assign(f,filename);
  erase(f);
  result:=IOResult = 0;
  {$I+}
end;

function oldRename(oldname,newname: string): Boolean;
var f: file;
begin
  {$I-}
  assign(f,oldname);
  Rename(f,Newname);
  result:=IOResult = 0;
  {$I+}
end;

{ erase many files }
function EraseFiles(dir,filter: string): Boolean;
var ErrDos: integer;
    DirSearchRec: TSearchRec;
begin
  result:=true;
  ErrDos:=FindFirst(AddPathToFile(dir,filter),faReadOnly + faArchive + faHidden, DirSearchRec);
  while ErrDos = 0 do 
  begin
    result:=result and
      EraseFile(0,AddPathToFile(dir,DirSearchRec.Name),false);
    ErrDos:=FindNext(DirSearchRec);
  end;
  FindClose(DirSearchRec);
end;

{ erase many files }
function oldEraseFiles(filter: string): Boolean;
var ErrDos: integer;
    DirSearchRec: TSearchRec;
begin
  result:=true;
  ErrDos:=FindFirst(filter,faReadOnly + faArchive + faHidden, DirSearchRec);
  while ErrDos = 0 do
  begin
    result:=result and
      oldEraseFile(AddPathToFile(ExtractFilePath(filter),DirSearchRec.Name));
    ErrDos:=FindNext(DirSearchRec);
  end;
  FindClose(DirSearchRec);
end;

function CopyFiles(Sourcedir,destdir,filter: string; CopyAttrs: boolean): boolean;
var ErrDos: integer;
    DirSearchRec: TSearchRec;
begin
  result:=true;
  ErrDos:=FindFirst(AddPathToFile(Sourcedir,filter),faReadOnly + faArchive + faHidden, DirSearchRec);
  while ErrDos = 0 do
  begin
    result:=result and
      CopyFile(AddPathToFile(Sourcedir,DirSearchRec.Name),
        AddPathToFile(destdir,DirSearchRec.Name),CopyAttrs);
    ErrDos:=FindNext(DirSearchRec);
  end;
  FindClose(DirSearchRec);
end;

procedure FindFilesEx(Strings: TStrings; filter: string; FullPath,Files,Directories: boolean);
begin
  FindFilesEx2(Strings,filter,FullPath,Files,Directories,faAnyFile);
end;

procedure FindFilesEx2(Strings: TStrings; filter: string; FullPath,Files,Directories: boolean; Attr: Integer);
begin
  FindFilesEx3(Strings,filter,FullPath,Files,Directories,false,Attr);
end;

procedure FindFilesEx3(Strings: TStrings; filter: string; FullPath,Files,Directories,SearchSubdirs: boolean; Attr: Integer);
var ErrDos: integer;
    DirSearchRec: TSearchRec;
const depth: integer = 0;
begin
  inc(depth);
  if depth = 1 then
    Strings.Clear;
  ErrDos:=FindFirst(filter,Attr,DirSearchRec);
  while ErrDos = 0 do
  begin
    if (((DirSearchRec.Attr and faDirectory) <> 0) and Directories) or
       (((DirSearchRec.Attr and faDirectory) =  0) and Files) then
      if FullPath then
        Strings.Add(AddPathToFile(ExtractFilePath(filter),DirSearchRec.Name)) else
        Strings.Add(DirSearchRec.Name);
    ErrDos:=FindNext(DirSearchRec);
  end;
  FindClose(DirSearchRec);

  if SearchSubdirs then
  begin
    ErrDos:=FindFirst(AddPathToFile(ExtractFilePath(filter),'*.*'),faDirectory,DirSearchRec);
    while ErrDos = 0 do
    begin
      if ((DirSearchRec.Attr and faDirectory) <> 0) and (DirSearchRec.Name <> '.') and (DirSearchRec.Name <> '..') then
        FindFilesEx3(Strings,
          AddPathToFile(AddPathToFile(ExtractFilePath(filter),DirSearchRec.Name),ExtractFileName(filter)),
          FullPath,Files,Directories,SearchSubdirs,Attr);
        ErrDos:=FindNext(DirSearchRec);
    end;
    FindClose(DirSearchRec);
  end;
  dec(depth);
end;

procedure FindFiles(Strings: TStrings; filter: string; FullPath: boolean);
begin
  FindFilesEx(Strings,filter,FullPath,true,true);
end;

procedure FindFilesInSubdir(Strings: TStrings; filter: string; FullPath: boolean);
begin
  FindFilesEx3(Strings,filter,FullPath,true,true,true,faAnyFile);
end;

{ copy a file }
function CopyFile(const Source,Dest: string; CopyAttrs: boolean): boolean;
  var fin,fout: file;
      buf: array[1..1024] of byte;
      w:integer;
      index,size: int64;
      err:integer;
  label error;
// returns file size in bytes or -1 if not found.
 function FileSize(fileName : wideString) : Int64;
 var
   sr : TSearchRec;
 begin
   if FindFirst(fileName, faAnyFile, sr ) = 0 then
      result := Int64(sr.FindData.nFileSizeHigh) shl Int64(32) + Int64(sr.FindData.nFileSizeLow)
   else
      result := -1;
 
   FindClose(sr) ;
 end;
 begin
  try
    Screen.Cursor:=crHourglass;

    {$I-}
    result:=true;
    FileMode:=0;  {Read only}
    assign(fin,Source);
    reset(fin,1);                        err:=IOResult; if err <> 0 then goto error;
    FileMode:=2;  {Read/Write - default}

    assign(fout,Dest);
    rewrite(fout,1);                     err:=IOResult; if err <> 0 then goto error;
    size := filesize(Source);
    index:=0;

//    while not eof(fin) do
    while index < size do
    begin
      blockread(fin,buf,sizeof(buf),w);  err:=IOResult; if err <> 0 then goto error;
      blockwrite(fout,buf,w);            err:=IOResult; if err <> 0 then goto error;
      index:= index+w;
    end;
    close(fin);                          err:=IOResult; if err <> 0 then goto error;
    close(fout);                         err:=IOResult; if err <> 0 then goto error;

    if CopyAttrs then
    try
      SetFileDate(Dest,GetFileDate(Source));
      FileSetAttr(Dest,FileGetAttr(Source));
    except
      ShowMessage('Unable to set attributes while copying file: '+Source);
      result:=false;
    end;

    exit;

    error:
      SetCursor(LoadCursor(0,idc_arrow));
      ShowMessage('Error '+inttostr(err)+' while copying file: '+Source);
      close(fin);                        if IOResult <> 0 then ;
      close(fout);                       if IOResult <> 0 then ;
      result:=false;
    {$I+}
  finally
    Screen.Cursor:=crDefault;
  end;
end;

{ copy a file - raise exception if error}
procedure CopyFileExcept(const Source,Dest: string; CopyAttrs: boolean);
  var fin,fout: file;
      buf: array[1..1024] of byte;
      index,size: int64;
      w:integer;
      err:integer;
  label error;
  // returns file size in bytes or -1 if not found.
 function FileSize(fileName : wideString) : Int64;
 var
   sr : TSearchRec;
 begin
   if FindFirst(fileName, faAnyFile, sr ) = 0 then
      result := Int64(sr.FindData.nFileSizeHigh) shl Int64(32) + Int64(sr.FindData.nFileSizeLow)
   else
      result := -1;
 
   FindClose(sr) ;
 end;

begin
  try
    Screen.Cursor:=crHourglass;

    {$I-}
    FileMode:=0;  {Read only}
    assign(fin,Source);
    reset(fin,1);                        err:=IOResult; if err <> 0 then goto error;
    FileMode:=2;  {Read/Write - default}

    assign(fout,Dest);
    rewrite(fout,1);                     err:=IOResult; if err <> 0 then goto error;
    size := filesize(Source);
    index:=0;

//    while not eof(fin) do
    while index < size do
    begin
      blockread(fin,buf,sizeof(buf),w);  err:=IOResult; if err <> 0 then goto error;
      blockwrite(fout,buf,w);            err:=IOResult; if err <> 0 then goto error;
      index:= index+w;
    end;

    close(fin);                          err:=IOResult; if err <> 0 then goto error;
    close(fout);                         err:=IOResult; if err <> 0 then goto error;

    if CopyAttrs then
    try
      SetFileDate(Dest,GetFileDate(Source));
      FileSetAttr(Dest,FileGetAttr(Source));
    except
      raise Exception.Create('Unable to set attributes while copying file: '+Source);
    end;

    exit;

    error:
      SetCursor(LoadCursor(0,idc_arrow));
      close(fin);                        if IOResult <> 0 then ;
      close(fout);                       if IOResult <> 0 then ;
      raise Exception.Create('Error '+inttostr(err)+' while copying file: '+Source);
    {$I+}
  finally
    Screen.Cursor:=crDefault;
  end;
end;

(*
{ copy a file }
function CopyFile(const Source,Dest: string; CopyAttrs: boolean): boolean;
  var fin,fout: file;
      buf: array[1..1024] of byte;
      w:integer;
      err:integer;
  label error;
begin
  try
    Screen.Cursor:=crHourglass;

    {$I-}
    result:=true;

    FileMode:=0;  {Read only}
    assign(fin,Source);
    reset(fin,1);                        err:=IOResult; if err <> 0 then goto error;
    FileMode:=2;  {Read/Write - default}

    assign(fout,Dest);
    rewrite(fout,1);                     err:=IOResult; if err <> 0 then goto error;

    while not eof(fin) do
    begin
      blockread(fin,buf,sizeof(buf),w);  err:=IOResult; if err <> 0 then goto error;
      blockwrite(fout,buf,w);            err:=IOResult; if err <> 0 then goto error;
    end;

    close(fin);                          err:=IOResult; if err <> 0 then goto error;
    close(fout);                         err:=IOResult; if err <> 0 then goto error;

    if CopyAttrs then
    try
      SetFileDate(Dest,GetFileDate(Source));
      FileSetAttr(Dest,FileGetAttr(Source));
    except
      ShowMessage('Unable to set attributes while copying file: '+Source);
      result:=false;
    end;

    exit;

    error:
      SetCursor(LoadCursor(0,idc_arrow));
      ShowMessage('Error '+inttostr(err)+' while copying file: '+Source);
      close(fin);                        if IOResult <> 0 then ;
      close(fout);                       if IOResult <> 0 then ;
      result:=false;
    {$I+}
  finally
    Screen.Cursor:=crDefault;
  end;
end;

{ copy a file - raise exception if error}
procedure CopyFileExcept(const Source,Dest: string; CopyAttrs: boolean);
  var fin,fout: file;
      buf: array[1..1024] of byte;
      w:integer;
      err:integer;
  label error;
begin
  try
    Screen.Cursor:=crHourglass;

    {$I-}
    FileMode:=0;  {Read only}
    assign(fin,Source);
    reset(fin,1);                        err:=IOResult; if err <> 0 then goto error;
    FileMode:=2;  {Read/Write - default}

    assign(fout,Dest);
    rewrite(fout,1);                     err:=IOResult; if err <> 0 then goto error;

    while not eof(fin) do
    begin
      blockread(fin,buf,sizeof(buf),w);  err:=IOResult; if err <> 0 then goto error;
      blockwrite(fout,buf,w);            err:=IOResult; if err <> 0 then goto error;
    end;

    close(fin);                          err:=IOResult; if err <> 0 then goto error;
    close(fout);                         err:=IOResult; if err <> 0 then goto error;

    if CopyAttrs then
    try
      SetFileDate(Dest,GetFileDate(Source));
      FileSetAttr(Dest,FileGetAttr(Source));
    except
      raise Exception.Create('Unable to set attributes while copying file: '+Source);
    end;

    exit;

    error:
      SetCursor(LoadCursor(0,idc_arrow));
      close(fin);                        if IOResult <> 0 then ;
      close(fout);                       if IOResult <> 0 then ;
      raise Exception.Create('Error '+inttostr(err)+' while copying file: '+Source);
    {$I+}
  finally
    Screen.Cursor:=crDefault;
  end;
end;
*)

function GetFileCRC(const Filename: string; shift: integer): word;
var f: file;
    buf: array[1..1024] of byte;
    i,len: integer;
    l: longint;
begin
  {$I-}
  l:=0;
  FileMode:=0;
  System.assign(f,Filename);
  System.reset(f,1);
  FileMode:=2;  {Read/Write - default}
  repeat
    blockread(f,buf,sizeof(buf),len);
    for i:=1 to len do
    begin
      l:=l shl shift;
      l:=loword(l)+hiword(l)+buf[i];
     end;
  until len = 0;
  System.close(f);
  if IOResult <> 0 then
    result:=0 else
    result:=loword(l);
  {$I+}
end;

procedure AddLineToMemo(Memo1: TMemo; const s: string; MaxLines: integer);
const MaxLength = 16000;
begin
  Memo1.Lines.BeginUpdate;
  if Memo1.GetTextLen > MaxLength then
  begin
    Memo1.SelStart:=0;
    Memo1.SelLength:=Memo1.GetTextLen-MaxLength;
    Memo1.ClearSelection;
    Memo1.Lines.Delete(0);
  end;
  while Memo1.Lines.Count >= IntMax([MaxLines,0]) do
    Memo1.Lines.Delete(0);
  Memo1.Lines.EndUpdate;
  Memo1.Lines.Add(s);
  Memo1.SelStart:=maxint;
end;

function FilesExist(filter: string): Boolean;
var SearchRec: TSearchRec;
begin
  Result := FindFirst(filter, faReadOnly + faArchive + faHidden, SearchRec) = 0;
  FindClose(SearchRec);
end;

function UpString(const s: string): string;
  var i: word;
begin
  result:=s;
  for i:=1 to length(result) do result[i]:=upcase(result[i]);
end;

(*
{Node is leaf, propose modification of leaf value}
procedure BDEModifyLeaf(sSelectedNode,sMyPath,sMyValue: string);
var
  sMyNode,sTestNode : string;
  MyError : Word;
  Found : boolean;
  szMyPath : array[0..255] of Char;
  hCur      : hDBICur;
  pRecBuf   : Pointer;
  MyDesc    : CFGDesc;
begin
  {Leaf mode text has value added. We must wipe it}
  sTestNode:=sSelectedNode;
  if Pos(' = ',sTestNode)>0
  then sTestNode:=Copy(sTestNode,1,Pos(' = ',sTestNode)-1);
  try
    {Allocate memory for buffer}
    GetMem(pRecBuf, sizeof(CFGDesc));


    {Initialize BDE}
    DB.Check(DbiInit(nil));

    {Get BDEConfig info as a table. Table lists all nodes under current node}
    StrPCopy(szMyPath,sMyPath);
    Check(DbiOpenCfgInfoList(nil, dbiREADWRITE, cfgPersistent, szMyPath, hCur));

    {Go to top of table}
    Check(DbiSetToBegin (hCur));

    {Clear Found flag. Will be set when selected node is located}
    Found:=false;

    {Scan table looking for selected node}
    repeat

      {Go to next line in table and put data in buffer pRecBuf}
      MyError:=DbiGetNextRecord ( hCur,dbiNOLOCK,pRecBuf,nil);

      {Good requests return DBIERR_NONE. EOF is a bad request}
      if MyError=DBIERR_NONE then
      begin

        {Transfer data from buffer to CFGDesc record,
         then pull title and value}
        MyDesc:=CFGDesc(pRecBuf^);
        sMyNode:=StrPas(MyDesc.szNodeName);

        {if node is same as selected node drop out of loop.}
        if sMyNode=sTestNode then
        begin
          Found:=true;
          break;
        end;
      end;
    until MyError<>DBIERR_NONE;

    {We are on the right node again}
    if Found then
    begin
      {Update record with new value}
      StrPCopy(MyDesc.szValue,sMyValue);

      {Transfer updated record to buffer}
      CFGDesc(pRecBuf^):=MyDesc;

      {Update BDEConfig entry with buffer}
      Check(DbiModifyRecord (hCur,pRecBuf,False));
    end;
  finally
    {Release cursor and exit DBI}
    Check(DbiCloseCursor(hCur));
    Check(DbiExit);

    {Free memory for buffer}
    FreeMem(pRecBuf, sizeof(CFGDesc));
  end;
end;
(**)

function WinExecAndWait32(FileName:String; Visibility : integer): DWord;
{SW_SHOWNORMAL}
var
  zAppName:array[0..512] of char;
  zCurDir:array[0..255] of char;
  WorkDir:String;
  StartupInfo:TStartupInfo;
  ProcessInfo:TProcessInformation;
begin
  StrPCopy(zAppName,FileName);
  GetDir(0,WorkDir);
  StrPCopy(zCurDir,WorkDir);
  FillChar(StartupInfo,Sizeof(StartupInfo),#0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil,
      zAppName,                      { pointer to command line string }
      nil,                           { pointer to process security attributes }
      nil,                           { pointer to thread security attributes }
      false,                         { handle inheritance flag }
      CREATE_NEW_CONSOLE or          { creation flags }
      CREATE_SEPARATE_WOW_VDM or
      NORMAL_PRIORITY_CLASS,
      nil,                           { pointer to new environment block }
      nil,                           { pointer to current directory name }
      StartupInfo,                   { pointer to STARTUPINFO }
      ProcessInfo) then
  begin
    Result := $FFFFFFFF;
  end else
  begin
    WaitforSingleObject(ProcessInfo.hProcess,INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess,Result);
  end;
end;

function WinExecNoWait32(FileName:String; Visibility : integer): DWord;
{SW_SHOWNORMAL}
var
  zAppName:array[0..512] of char;
  zCurDir:array[0..255] of char;
  WorkDir:String;
  StartupInfo:TStartupInfo;
  ProcessInfo:TProcessInformation;
begin
  StrPCopy(zAppName,FileName);
  GetDir(0,WorkDir);
  StrPCopy(zCurDir,WorkDir);
  FillChar(StartupInfo,Sizeof(StartupInfo),#0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil,
    zAppName,                      { pointer to command line string }
    nil,                           { pointer to process security attributes }
    nil,                           { pointer to thread security attributes }
    false,                         { handle inheritance flag }
    CREATE_NEW_CONSOLE or          { creation flags }
    CREATE_SEPARATE_WOW_VDM or
    NORMAL_PRIORITY_CLASS,
    nil,                           { pointer to new environment block }
    nil,                           { pointer to current directory name }
    StartupInfo,                   { pointer to STARTUPINFO }
    ProcessInfo) then Result := $FFFFFFFF { pointer to PROCESS_INF }
  else
    Result:=0;
end;

function DelphiIsRunning : boolean;
begin
  Result := (FindWindowEx(0,0,'TfmSpectra', nil) <> 0);
{
  Result := (FindWindowEx(0,0,'TPUtilWindow', nil) <> 0) and
            (FindWindowEx(0,0,'TAlignPalette', nil) <> 0) and
            (FindWindowEx(0,0,'TWatchWindow', nil) <> 0) and
            (FindWindowEx(0,0,'TEditWindow', nil) <> 0) and
            (FindWindowEx(0,0,'TMenuBuilder', nil) <> 0) and
            (FindWindowEx(0,0,'TAppBuilder', nil) <> 0) and
            (FindWindowEx(0,0,'TProjectManager', nil) <> 0) and
            (FindWindowEx(0,0,'TPropertyInspector', nil) <> 0) and
            (FindWindowEx(0,0,'TBPWindow', nil) <> 0) and
            (FindWindowEx(0,0,'TCallStackWindow', nil) <> 0) and
            (FindWindowEx(0,0,'TApplication', nil) <> 0);
{
  Result := (FindWindow('TPUtilWindow', nil) <> 0) and
            (FindWindow('TAlignPalette', nil) <> 0) and
            (FindWindow('TWatchWindow', nil) <> 0) and
            (FindWindow('TEditWindow', nil) <> 0) and
            (FindWindow('TMenuBuilder', nil) <> 0) and
            (FindWindow('TAppBuilder', nil) <> 0) and
            (FindWindow('TProjectManager', nil) <> 0) and
            (FindWindow('TPropertyInspector', nil) <> 0) and
            (FindWindow('TBPWindow', nil) <> 0) and
            (FindWindow('TCallStackWindow', nil) <> 0) and
            (FindWindow('TApplication', nil) <> 0);
}
end;

function CheckFileIntegrity: boolean;
type TChecksum = record
       a: array[1..8] of char;
       chk: longint;
     end;
const checksum: TChecksum = (a: ('(','F','(','z','*','3','2',';'); chk: 0);
      n = 1000+sizeof(checksum);
      NewChecksum: longint = 0;
      depth: integer = 0;
var i: integer;
    f1: file;
    f2: file;
    s,t: string;
    w: integer;
    sum,l: longint;
    achecksum: TChecksum;
  procedure CalcSum;
  var i: integer;
  begin
    for i:=1 to n do
    if i mod sizeof(longint) = 0 then
    begin
      move(s[i],l,sizeof(l));
      if sum < 0 then sum:=1-sum;
      sum:=sum*2+l;
    end;
  end;
  procedure ReadBlock(var F: File; var Buf; Count: Integer; var Result: Integer);
  begin
    blockread(F,Buf,Count,Result);
    i:=pos(t,s);
    if (i > 0) and (i <= 2*n) then
    begin
      move(s[i],achecksum,sizeof(checksum));
      move(checksum,s[i],sizeof(checksum));
      if depth > 1 then
        blockwrite(f2,s[1],n);
      fillchar(s[i],sizeof(checksum),0);
      CalcSum;
      move(achecksum,s[i],sizeof(checksum));
    end else
    begin
      CalcSum;
      if depth > 1 then
        blockwrite(f2,s[1],n);
    end;
  end;
begin
  inc(depth);
  s:='';
  Setlength(t,sizeof(checksum.a));
  move(checksum.a,t[1],sizeof(checksum.a));
  sum:=0;
  if depth > 1 then
    checksum.chk:=NewChecksum;
  FileMode:=0;  {Read only}
  assign(f1,paramstr(0));
  reset(f1,1);
  FileMode:=2;  {Read/Write - default}
  if depth > 1 then
  begin
    assign(f2,ChangeFileExt(ParamStr(0), '.exx'));
    rewrite(f2,1);
  end;

  while not eof(f1) do
  begin
    if s = '' then
    begin
      Setlength(s,3*n);
      ReadBlock(f1,s[1],length(s),w);
    end else
    begin
      move(s[n+1],s[1],2*n);
      ReadBlock(f1,s[2*n+1],n,w);
    end;
  end;

{
  if achecksum.chk <> sum then
    MessageDlg(inttostr(achecksum.chk)+' '+inttostr(sum),
      mtConfirmation, [mbOK], 0);
}

  if depth > 1 then
  begin
    blockwrite(f2,s[n+1],filesize(f1)-filesize(f2));
    close(f2);
    ShowInformationMessage('File written');
  end else
  if (achecksum.chk <> sum) and (checksum.chk = 0) then
  begin
    NewChecksum:=sum;
    CheckFileIntegrity;
  end;
  close(f1);
  result:=achecksum.chk = sum;
  dec(depth);
end;

function GetVolumeNum: longint;
var lpMaximumComponentLength,lpFileSystemFlags: dword;
begin
  if not GetVolumeInformation(
      nil,
      nil,
      0,
      @result,
      lpMaximumComponentLength,
      lpFileSystemFlags,
      nil,
      0
     ) then
    result:=0;
  ShowInformationMessage(inttohex(result,8));
end;

{========================================================}
{====TLinkedList==============================================================}

constructor TLinkedList.NewSortedRec(var list: TLinkedList);
  var p: TLinkedList;
begin
  if (list = nil) or before(self,list) then
  begin
    next:=list;
    list:=self;
  end else
  begin
    p:=list;
    while (p.next <> nil) and not before(self,p.next) do p:=p.next;
    next:=p.next;
    p.next:=self;
  end;
end;

constructor TLinkedList.NewRec;
begin
  InitRec;
end;

constructor TLinkedList.NewHeadRec(var list: TLinkedList);
begin
  InitRec;
  next:=list;
  list:=self;
end;

constructor TLinkedList.NewTailRec(var list: TLinkedList);
  var p: TLinkedList;
begin
  InitRec;
  if list = nil then
  begin
    list:=self;
    next:=nil;
  end else
  begin
    p:=list;
    while p.next <> nil do p:=p.next;
    p.next:=self;
    next:=nil;
  end;
end;

procedure TLinkedList.InitRec;
begin
  next:=nil;
end;

procedure TLinkedList.DestroyRec(var list: TLinkedList);
  var p: TLinkedList;
begin
  if list = nil then exit;
  if list = self then 
  begin
    list:=next;
  end else
  begin
    p:=list;
    while (p <> nil) and (p.next <> self) do p:=p.next;
    if p <> nil then
      p.next:=next;
  end;
  self.Free;
end;

procedure DestroyLinkedList(var list: TLinkedList);
begin
  while list <> nil do
    list.DestroyRec(list);
end;

procedure SortLinkedList(var oldlist: TLinkedList);
  var p,rec,newlist: TLinkedList;
begin
  newlist:=nil;
  while oldlist <> nil do
  begin
    rec:=oldlist;
    oldlist:=oldlist.next;
    if (newlist = nil) or rec.before(rec,newlist) then
    begin
      rec.next:=newlist;
      newlist:=rec;
    end else
    begin
      p:=newlist;
      while (p.next <> nil) and not rec.before(rec,p.next) do p:=p.next;
      rec.next:=p.next;
      p.next:=rec;
    end;
  end;
  oldlist:=newlist; 
end;

function TLinkedList.before(a,b: TLinkedList): boolean;
begin
  before:=true;
end;

function MessageString(msg: word): string;
begin
  result:=MessageToString(msg);
end;

const MyHeapOld: PMyHeapRecOld = nil;
const MyHeapx: PMyHeapRecOld2 = nil;
const MyHeapz: PMyHeapRec = nil;
//const MyHeapz: string = '';

procedure FreeMyHeapExtOld(var MyHeap: PMyHeapRecOld);
var q: PMyHeapRecOld;
begin
  while MyHeap <> nil do
  begin
    q:=MyHeap^.next;
    dispose(MyHeap);
    MyHeap:=q;
  end;
end;

procedure FreeMyHeapOld;
begin
  FreeMyHeapExtOld(MyHeapOld);
end;

function MyGetMemExtOld(var P: Pointer; Size: longint; var MyHeap: PMyHeapRecOld): boolean;
var q: PMyHeapRecOld;
begin
  result:=true;
  if (Size < 0) or (Size > sizeof(MyHeap^.Buffer)) then
  begin
    p:=nil;
    result:=false;
  end else
  begin
    if (MyHeap = nil) or (Size > sizeof(MyHeap^.Buffer)-MyHeap^.max) then
    begin
      new(q);
      fillchar(q^,sizeof(q^),0);
      q^.max:=0;
      q^.next:=MyHeap;
      MyHeap:=q;
    end;
    p:=@MyHeap^.buffer[MyHeap^.max];
    MyHeap^.max:=MyHeap^.max+Size;
  end;
end;

function MyGetMemOld(var P: Pointer; Size: longint): boolean;
begin
  result:=MyGetMemExtOld(P,Size,MyHeapOld);
end;

function MyNewOld(Size: longint): Pointer;
begin
  MyGetMemOld(result,Size);
end;

function MyNewPCharOld(s: string): pchar;
begin
  result:=MyNewOld(length(s)+1);
  StrPCopy(result,s);
end;

procedure FreeMyHeapExtOld2(var MyHeap: PMyHeapRecOld2);
var q: PMyHeapRecOld2;
begin
  while MyHeap <> nil do
  begin
    q:=MyHeap^.next;
    FreeMem(MyHeap,MyHeap.size+sizeof(TMyHeapRecOld2));
    MyHeap:=q;
  end;
end;

procedure FreeMyHeapOld2;
begin
  FreeMyHeapExtOld2(MyHeapx);
end;

function MyGetMemExtOld2(var P: Pointer; Size: longint; var MyHeap: PMyHeapRecOld2): boolean;
var q: PMyHeapRecOld2;
    sz: integer;
const DefaultBuf = 1024;
begin
  result:=true;
  if Size <= 0 then
  begin
    p:=nil;
    result:=false;
  end else
  begin
    if (MyHeap = nil) or (Size > MyHeap^.size-MyHeap^.max) then
    begin
      sz:=Intmax([DefaultBuf,Size]);
      Getmem(q,sz+sizeof(TMyHeapRecOld2));
      q^.size:=sz;
      q^.max:=0;
      q^.next:=MyHeap;
      MyHeap:=q;
    end;
    {$R-}
    p:=@MyHeap^.bufferx[MyHeap^.max];
    {$R+}
    MyHeap^.max:=MyHeap^.max+Size;
  end;
end;

function MyGetMemOld2(var P: Pointer; Size: longint): boolean;
begin
  result:=MyGetMemExtOld2(P,Size,MyHeapx);
end;

function MyNewOld2(Size: longint): Pointer;
begin
  MyGetMemOld2(result,Size);
end;

function MyNewPCharOld2(s: string): pchar;
begin
  result:=MyNewOld2(length(s)+1);
  StrPCopy(result,s);
end;

procedure FreeMyHeap;
begin
  FreeMyHeapExt(MyHeapz);
end;

(*
function MyGetMemExt(var P: Pointer; Size: longint; var MyHeap: string): boolean;
var i: integer;
begin
  result:=true;
  if Size <= 0 then
  begin
    p:=nil;
    result:=false;
  end else
  begin
    i:=length(MyHeap);
    setlength(MyHeap,length(MyHeap)+size);
    p:=@MyHeap[i+1];
    {$R+}
  end;
end;

procedure FreeMyHeapExt(var MyHeap: string);
begin
  MyHeap:='';
end;

procedure FreeMyHeapExt(var MyHeap: PMyHeapRec);
var q: PMyHeapRec;
begin
  while MyHeap <> nil do
  begin
    q:=MyHeap^.next;
    FreeMem(MyHeap,MyHeap.size+sizeof(TMyHeapRec));
    MyHeap:=q;
  end;
end;

function MyGetMemExt(var P: Pointer; Size: longint; var MyHeap: PMyHeapRec): boolean;
var q: PMyHeapRec;
    sz: integer;
const DefaultBuf = 1024;
begin
  result:=true;
  if Size <= 0 then
  begin
    p:=nil;
    result:=false;
  end else
  begin
    if (MyHeap = nil) or (Size > MyHeap^.size-MyHeap^.max) then
    begin
      sz:=Intmax([DefaultBuf,Size]);
      Getmem(q,sz+sizeof(TMyHeapRec));
      q^.size:=sz;
      q^.max:=0;
      q^.next:=MyHeap;
      MyHeap:=q;
    end;
    {$R-}
    p:=@MyHeap^.bufferx[MyHeap^.max];
    {$R+}
    MyHeap^.max:=MyHeap^.max+Size;
  end;
end;
*)
procedure FreeMyHeapExt(var MyHeap: PMyHeapRec);
var q: PMyHeapRec;
begin
  while MyHeap <> nil do
  begin
    q:=MyHeap^.next;
    dispose(MyHeap);
    MyHeap:=q;
  end;
end;

function MyGetMemExt(var P: Pointer; Size: longint; var MyHeap: PMyHeapRec): boolean;
var q: PMyHeapRec;
var i: integer;
begin
  result:=true;
  if Size <= 0 then
  begin
    p:=nil;
    result:=false;
  end else
{
  if MyHeap <> nil then
  begin
    i:=length(MyHeap.s);
    setlength(MyHeap.s,length(MyHeap.s)+size+10);
    p:=@MyHeap.s[i+1+5];
  end else
}
  begin
    new(q);
    fillchar(q^,sizeof(q^),0);
    setlength(q^.s,size);
    q^.next:=MyHeap;
    MyHeap:=q;
    {$R-}
    p:=@MyHeap.s[1];
    {$R+}
  end;
end;

function MyGetMem(var P: Pointer; Size: longint): boolean;
begin
  result:=MyGetMemExt(P,Size,MyHeapz);
end;

function MyNewExt(Size: longint; var MyHeap: PMyHeapRec): Pointer;
begin
  MyGetMemExt(result,Size,MyHeap);
end;

function MyNew(Size: longint): Pointer;
begin
  MyGetMem(result,Size);
end;

function MyNewPChar(s: string): pchar;
begin
  result:=MyNew(length(s)+1);
  StrPCopy(result,s);
end;

{ puts text into the clipboard (requires hWindow parameter) }
function TextToClipboardWin(pText: pChar; hWindow: hWnd): boolean;
  var hText: THandle;
      pClip: pChar;
      i,len: word;
begin
  TextToClipboardWin:=false;
  len:=strlen(pText);
  if pText = nil then exit;

  hText := GlobalAlloc(gmem_Moveable,len+1);
  if hText = 0 then exit;

  pClip:=GlobalLock(hText);
  if pClip <> nil then
  begin
{
    strcopy(pClip,pText);
    move(pText,pClip,len+1);
}
for i:=0 to len do
pClip[i]:=pText[i];

    GlobalUnlock(hText);

    if OpenClipboard(hWindow) then
    begin
      EmptyClipboard;
      SetClipboardData(cf_Text,hText);
      CloseClipboard;
      TextToClipboardWin:=true;
      exit;
    end
  end;

  GlobalFree(hText);
end;

{ puts text into the clipboard }
function TextToClipboard(pText: pChar): boolean;
begin
  TextToClipboard:=TextToClipboardWin(pText,{Application^.MainWindow^.hWindow}GetDesktopWindow);
end;

procedure SetFileDate(FileName: string; date: TDateTime);
var FileHandle : Integer;
begin
  FileHandle := FileOpen(FileName, fmOpenWrite or fmShareExclusive);
  if FileHandle > 0 then
  begin
    FileSetDate(FileHandle,DateTimeToFileDate(date));
    FileClose(FileHandle);
  end;
end;

function GetDirDateModified(DirName: string): TDateTime;
var ErrDos: integer;
    DirSearchRec: TSearchRec;
begin
  ErrDos:=FindFirst(DirName,faDirectory, DirSearchRec);
  if ErrDos = 0 then
    result:=FileDateToDateTime(DirSearchRec.Time) else
    result:=0;
  FindClose(DirSearchRec);
end;

function GetFileDate(FileName: string): TDateTime;
var i: Integer;
begin
  i:=FileAge(filename);
  if i > 0 then
    result:=FileDateToDateTime(i) else
    result:=0;
end;

function IsDirectory(filename: string): boolean;
begin
  result:=(GetFileAttributes(pchar(filename)) <> $FFFFFFFF) and ((GetFileAttributes(pchar(filename)) and FILE_ATTRIBUTE_DIRECTORY) <> 0);
end;

procedure MakeDirectories(path: string);
begin
  {$I-}
  if (path <> '') and (path[length(path)] = '\') then
    delete(path,length(path),1);
  if pos('\',path) > 0 then
    MakeDirectories(ExtractFilePath(path));
  MkDir(path);
  if IOResult = 0 then ;
  {$I+}
end;

function float(a: double): double;
begin
  result:=a;
end;

procedure DrawTransparent(Canvas: TCanvas; xDest,yDest: integer; Bitmap: graphics.TBitmap; col: TColor);
{col specifies the color in Bitmap to replace with the Brush of the canvas.}
begin
  Canvas.BrushCopy(Bounds(xDest,yDest,Bitmap.Width, Bitmap.Height),
    Bitmap, Bounds(0, 0, Bitmap.Width, Bitmap.Height), col);
end;

procedure MaskedDraw(Canvas: TCanvas; xDest,yDest: integer; img: TImage; xSrc,ySrc,Width,Height: integer);
{mask must be directly under the Source rect}
begin
  BitBlt(
    Canvas.Handle,
    XDest,YDest,Width,Height,
    img.Picture.Bitmap.Canvas.Handle,
    xSrc,ySrc+Height,
    SRCAND);
  BitBlt(
    Canvas.Handle,
    XDest,YDest,Width,Height,
    img.Picture.Bitmap.Canvas.Handle,
    xSrc,ySrc,
    SRCPAINT);
end;

function RemoveTrailingBackslash(const s: string): string;
begin
  result:=s;
  if (length(result) > 3) and (result[length(result)] = '\') then
    result:=copy(result,1,length(result)-1);
end;

function RemoveTrailingChar(const s: string; c: char): string;
begin
  result:=s;
  if (length(result) > 0) and (result[length(result)] = c) then
    result:=copy(result,1,length(result)-1);
end;

function RemoveNonNumerics(const s: string): string;
var i: integer;
begin
  result:=s;
  for i:=length(result) downto 1 do
  case result[i] of
    '0'..'9': ;
    else delete(result,i,1);
  end;
end;

function RemoveBadFilenameChars(const s: string): string;
var i: integer;
begin
  result:=s;
  for i:=length(result) downto 1 do
  case result[i] of
    '/','\',':','*','?','"','<','>','|',#0..#31: delete(result,i,1);
  end;
  result:=StripTrailingBlanks(SkipBlanks(result));
end;

function IOErrorMsg(err: integer): string;
begin
  case err of
    100: result:='Disk read error';
    101: result:='Disk write error';
    102: result:='File not assigned';
    103: result:='File not open';
    104: result:='File not open for input';
    105: result:='File not open for output';
    106: result:='Invalid numeric format';
    else Result:='I/O Error '+inttostr(err);
  end;
end;

function RichEditColLineToPos(RichEdit: TRichEdit; Col,Line: integer): integer;
begin
  try
    result:=RichEdit.Perform(EM_LINEINDEX,Line,0)+col;
  except
    result:=0;
  end;
end;

function RichEditPosToColLine(RichEdit: TRichEdit; pos: integer): TPoint;
begin
  try
    result.y:=RichEdit.Perform(EM_EXLINEFROMCHAR,0,pos);
    result.x:=pos-RichEdit.Perform(EM_LINEINDEX,result.y,0);
  except
    result:=Point(0,0);
  end;
end;

function RichEditPosToXY(RichEdit: TRichEdit; pos: integer): TPoint;
begin
  try
    RichEdit.Perform(EM_POSFROMCHAR,longint(@result),pos);
  except
    result:=Point(0,0);
  end;
end;

function RichEditCurLine(RichEdit: TRichEdit): integer;
begin
  try
    result:=RichEdit.Perform(EM_EXLINEFROMCHAR,0,RichEdit.SelStart);
  except
    result:=0;
  end;
end;

function RichEditCurCol(RichEdit: TRichEdit): integer;
begin
  try
    result:=RichEdit.SelStart-RichEdit.Perform(EM_LINEINDEX,RichEditCurLine(RichEdit),0);
  except
    result:=0;
  end;
end;

function MemoPosToLine(Memo: TMemo; pos: integer): integer;
begin
  try
    result:=Memo.Perform(EM_LINEFROMCHAR,pos,0);
  except
    result:=0;
  end;
end;

procedure RichEditLineToTop(RichEdit: TRichEdit; Linenum: integer);
begin
  RichEdit.Perform(EM_LINESCROLL,-1000,-10000);
  RichEdit.Perform(EM_LINESCROLL,0,linenum);
end;

procedure MemoLineToTop(Memo: TMemo; Linenum: integer);
begin
  Memo.Perform(EM_LINESCROLL,-1000,-10000);
  Memo.Perform(EM_LINESCROLL,0,linenum);
end;

{ doesn't seem to work
function MemoPosToXY(Memo: TMemo; pos: integer): TPoint;
begin
  try
    Memo.Perform(EM_POSFROMCHAR,longint(@result),pos);
  except
    result:=Point(0,0);
  end;
end;
}

function LineFromPos(Memo:  TMemo; TextPos: integer): integer;
begin
  with Memo,Lines do
  begin
    for result:=1 to Count do
    begin
      dec(TextPos,length(Strings[result-1])+2);
      if TextPos < 0 then
        exit;
    end;
    result:=Count;
  end;
end;

function LastError: string;
begin
  SetLength(result,1000);
  SetLength(result,FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM,
    nil,GetLastError,
    (((WORD(SUBLANG_DEFAULT)) shl 10) or WORD(LANG_NEUTRAL)),
    pchar(result),Length(result),nil));
end;

function ShortPathName(filename: string): string;
    function Shorten(filename: string): string;
    var i: integer;
    begin
      SetLength(result,1000);
      i:=GetShortPathName(pChar(filename),pChar(result),length(result));
      result:=copy(result,1,i);
    end;
begin
  result:=Shorten(filename);

  if result = '' then
    result:=AddPathToFile(Shorten(ExtractFilePath(filename)),ExtractFileName(filename));

  if result = '' then
  begin
    ShowErrorMessage('FormatMessage: '+LastError+#13#10+filename);
    result:=filename;
  end;
end;

procedure DeleteStringGridRow(StringGrid: TStringGrid; aRow: integer);
var x,y: integer;
begin
  with StringGrid do
  begin
    for y:=aRow to RowCount-2 do
    for x:=0 to ColCount-1 do
    begin
      Cells[x,y]:=Cells[x,y+1];
      Objects[x,y]:=Objects[x,y+1];
    end;
    RowCount:=RowCount-1;
    Update;
  end;
end;

procedure CopyStringGridRow(StringGrid: TStringGrid; SourceRow,DestRow: integer);
var x: integer;
begin
  with StringGrid do
  begin
    for x:=0 to ColCount-1 do
    begin
      Cells[x,DestRow]:=Cells[x,SourceRow];
      Objects[x,DestRow]:=Objects[x,SourceRow];
    end;
    Update;
  end;
end;

procedure InsertStringGridRow(StringGrid: TStringGrid; aRow: integer);
var x,y: integer;
begin
  with StringGrid do
  begin
    RowCount:=RowCount+1;
    for y:=RowCount-2 downto aRow do
    for x:=0 to ColCount-1 do
    begin
      Cells[x,y+1]:=Cells[x,y];
      Objects[x,y+1]:=Objects[x,y];
    end;
    Update;
  end;
end;

procedure SortStringGridRows(StringGrid: TStringGrid; SortCol: integer; GridSortKind: TGridSortKind);
begin
  SortStringGridRowsEx(StringGrid,SortCol,GridSortKind,0, StringGrid.RowCount-1);
end;

(*
procedure SortStringGridRowsEx(StringGrid: TStringGrid; SortCol: integer; GridSortKind: TGridSortKind; MinRow,MaxRow: integer);
  procedure QuicksortRecur(start, stop: integer);
  var m: integer; { the location separating the high and low parts. }
      splitpt: integer; { the Quicksort split algorithm. takes the range, and returns the split point. }
    function split(start, stop: integer): integer;
      var left, right: integer;    { scan pointers. }
        sPivot: string;       { pivot value. }
        dPivot: double;       { pivot value. number or date}
      function LT_Pivot(a: string): boolean;
      begin
        if GridSortKind = gskString then
          result:=a < sPivot else
          result:=StrToDoubleDef(a,0) < dPivot;
      end;
      procedure swap(var a, b: integer); { interchange the parameters. }
      var t: string;
          c: integer;
      begin
        for c:=0 to StringGrid.ColCount-1 do
        begin
          t:=StringGrid.Cells[c,a];
          StringGrid.Cells[c,a]:=StringGrid.Cells[c,b];
          StringGrid.Cells[c,b]:=t
        end;
      end;
    begin { split }
      { set up the pointers for the hight and low sections, and
       get the pivot value. }
      case GridSortKind of
        gskNumber: dpivot:=StrToDoubleDef(spivot,0);
        gskDate:   dpivot:=StrToDate(spivot);
        else       spivot:=StringGrid.Cells[SortCol,start];
      end;

      left:=start + 1;
      right:=stop;

      { look for pairs out of place and swap 'em. }
      while left <= right do begin
        while (left <= stop) and LT_Pivot(StringGrid.Cells[SortCol,left]) do
          left:=left + 1;
        while (right > start) and not LT_Pivot(StringGrid.Cells[SortCol,right]) do
          right:=right - 1;
        if left < right then
          swap(left, right);
      end;

      { put the pivot between the halves. }
      swap(start, right);

      { this is how you return function values in pascal.
       yeccch. }
      split:=right
    end;
  begin { QuicksortRecur }
    { if there's anything to do... }
    if start < stop then begin
      splitpt:=split(start, stop);
      QuicksortRecur(start, splitpt-1);
      QuicksortRecur(splitpt+1, stop);
    end
  end;
begin
  QuicksortRecur(MinRow,MaxRow);
end;

*)
procedure SortStringGridRowsEx(StringGrid: TStringGrid; SortCol: integer; GridSortKind: TGridSortKind; MinRow,MaxRow: integer);
  procedure QuicksortRecur(start, stop: integer);
  var m: integer; { the location separating the high and low parts. }
      splitpt: integer; { the Quicksort split algorithm. takes the range, and returns the split point. }
    function split(start, stop: integer): integer;
      var left, right: integer;    { scan pointers. }
        Pivot: string;       { pivot value. }
      function LT_Pivot(a,b: string): boolean;
      begin
        case GridSortKind of
          gskNumber: result:=StrToDoubleDef(a,0) < StrToDoubleDef(b,0);
          gskDate:   result:=StrToDate(a) < StrToDate(b);
          else       result:=a < b;
        end;
      end;
      procedure swap(var a, b: integer); { interchange the parameters. }
      var t: string;
          c: integer;
      begin
        for c:=0 to StringGrid.ColCount-1 do
        begin
          t:=StringGrid.Cells[c,a];
          StringGrid.Cells[c,a]:=StringGrid.Cells[c,b];
          StringGrid.Cells[c,b]:=t
        end;
      end;
    begin { split }
      { set up the pointers for the hight and low sections, and
       get the pivot value. }
      pivot:=StringGrid.Cells[SortCol,start];

      left:=start + 1;
      right:=stop;

      { look for pairs out of place and swap 'em. }
      while left <= right do begin
        while (left <= stop) and LT_Pivot(StringGrid.Cells[SortCol,left],Pivot) do
          left:=left + 1;
        while (right > start) and not LT_Pivot(StringGrid.Cells[SortCol,right],Pivot) do
          right:=right - 1;
        if left < right then
          swap(left, right);
      end;

      { put the pivot between the halves. }
      swap(start, right);

      { this is how you return function values in pascal.
       yeccch. }
      split:=right
    end;
  begin { QuicksortRecur }
    { if there's anything to do... }
    if start < stop then begin
      splitpt:=split(start, stop);
      QuicksortRecur(start, splitpt-1);
      QuicksortRecur(splitpt+1, stop);
    end
  end;
begin
  QuicksortRecur(MinRow,MaxRow);
end;

function StringGridToString(StringGrid: TStringGrid): string;
var i,j: integer;
begin
  result:='';
  with StringGrid do
  for j:=0 to RowCount-1 do
  begin
    for i:=0 to ColCount-1 do
      result:=result+Cells[i,j]+char(vk_tab);
    result:=result+#13#10;
  end;
end;

procedure MoveStringGridRow(StringGrid: TStringGrid; SourceRow,DestRow: integer);
begin
  DestRow:=IntMin([DestRow,StringGrid.RowCount-1]);
  if SourceRow < DestRow then
  begin
    InsertStringGridRow(StringGrid,DestRow+1);
    CopyStringGridRow(StringGrid,SourceRow,DestRow+1);
    DeleteStringGridRow(StringGrid,SourceRow);
  end else
  if SourceRow > DestRow then
  begin
    InsertStringGridRow(StringGrid,DestRow);
    CopyStringGridRow(StringGrid,SourceRow+1,DestRow);
    DeleteStringGridRow(StringGrid,SourceRow+1);
  end;
end;

procedure DeleteStringGridCol(StringGrid: TStringGrid; aCol: integer);
var x,y: integer;
begin
  with StringGrid do
  begin
    for y:=aCol to ColCount-2 do
    for x:=0 to RowCount-1 do
    begin
      Cells[y,x]:=Cells[y+1,x];
      Objects[y,x]:=Objects[y+1,x];
    end;
    ColCount:=ColCount-1;
    Update;
  end;
end;

procedure CopyStringGridCol(StringGrid: TStringGrid; SourceCol,DestCol: integer);
var x: integer;
begin
  with StringGrid do
  begin
    for x:=0 to RowCount-1 do
    begin
      Cells[DestCol,x]:=Cells[SourceCol,x];
      Objects[DestCol,x]:=Objects[SourceCol,x];
    end;
    Update;
  end;
end;

procedure InsertStringGridCol(StringGrid: TStringGrid; aCol: integer);
var x,y: integer;
begin
  with StringGrid do
  begin
    ColCount:=ColCount+1;
    for y:=ColCount-2 downto aCol do
    for x:=0 to RowCount-1 do
    begin
      Cells[y+1,x]:=Cells[y,x];
      Objects[y+1,x]:=Objects[y,x];
    end;
    Update;
  end;
end;

procedure MoveStringGridCol(StringGrid: TStringGrid; SourceCol,DestCol: integer);
begin
  DestCol:=IntMin([DestCol,StringGrid.ColCount-1]);
  if SourceCol < DestCol then
  begin
    InsertStringGridCol(StringGrid,DestCol+1);
    CopyStringGridCol(StringGrid,SourceCol,DestCol+1);
    DeleteStringGridCol(StringGrid,SourceCol);
  end else
  if SourceCol > DestCol then
  begin
    InsertStringGridCol(StringGrid,DestCol);
    CopyStringGridCol(StringGrid,SourceCol+1,DestCol);
    DeleteStringGridCol(StringGrid,SourceCol+1);
  end;
end;

function MoveFile(handle: hWnd; filename,newDir: string): Boolean;
var lpFileOp: TSHFileOpStruct;
begin
  MakeDirectories(newDir);
  filename:=filename+#0;
  newDir:=newDir+#0;
  with lpFileOp do
  begin
    Wnd:=handle;
    wFunc:=FO_MOVE;
    pFrom:=pchar(@filename[1]);
    pTo:=pchar(@newDir[1]);
    fFlags:=FOF_ALLOWUNDO or FOF_RENAMEONCOLLISION;
    hNameMappings:=nil;
    lpszProgressTitle:=nil;
  end;

  result:=SHFileOperation(lpFileOp) = 0;
end;

function EraseFile(handle: hWnd; filename: string; query: boolean): boolean;
var lpFileOp: TSHFileOpStruct;
begin
  result:=true;
  if (pos('*',filename) = 0) and (pos('?',filename) = 0) and not FileExists(filename) then
    exit;

  filename:=filename+#0;
  with lpFileOp do
  begin
    Wnd:=handle;
    wFunc:=FO_DELETE;
    pFrom:=pchar(@filename[1]);
    pTo:=pchar(@filename[1]);
    fFlags:=FOF_ALLOWUNDO;
    if not query then
      fFlags:=fFlags or FOF_NOCONFIRMATION;
    hNameMappings:=nil;
    lpszProgressTitle:=nil;
  end;

  result:=SHFileOperation(lpFileOp) = 0;
end;

function CopyFileToDir(handle: hWnd; const Source,newDir: string): Boolean;
var lpFileOp: TSHFileOpStruct;
begin
  MakeDirectories(newDir);
  with lpFileOp do
  begin
    Wnd:=handle;
    wFunc:=FO_COPY;
    pFrom:=pchar(Source);
    pTo:=pchar(newDir);
    fFlags:=FOF_ALLOWUNDO or FOF_RENAMEONCOLLISION;
    hNameMappings:=nil;
    lpszProgressTitle:=nil;
  end;

  result:=SHFileOperation(lpFileOp) = 0;
end;

function RenameFile(handle: hWnd; Source,newName: string): Boolean;
var lpFileOp: TSHFileOpStruct;
begin
  with lpFileOp do
  begin
    Wnd:=handle;
    wFunc:=FO_RENAME;
    pFrom:=pchar(Source);
    pTo:=pchar(newName);
    fFlags:=FOF_ALLOWUNDO or FOF_RENAMEONCOLLISION;
    hNameMappings:=nil;
    lpszProgressTitle:=nil;
  end;

  result:=SHFileOperation(lpFileOp) = 0;
end;

procedure FillRandom(var X; Count: Integer);
var p: ^byte;
begin
  p:=@X;
  while Count > 0 do
  begin
    p^:=random(256);
    inc(p);
    dec(Count);
  end;
end;

procedure SetScreenCursorFilex(filename: string; default: TCursor);
begin
  if fileexists(filename) then
  begin
    screen.cursors[1001]:=LoadCursorFromFile(pchar(filename));
    screen.cursor:=1001;
  end else
    screen.cursor:=default;
  mouse.CursorPos:=Point(mouse.CursorPos.x,mouse.CursorPos.y);
end;

procedure SetCursorFile(Control: TControl; filename: string; default: TCursor);
begin
  if fileexists(filename) then
  begin
    screen.cursors[1002]:=LoadCursorFromFile(pchar(filename));
    Control.cursor:=1002;
  end else
    screen.cursor:=default;
  mouse.CursorPos:=Point(mouse.CursorPos.x,mouse.CursorPos.y);
end;
                        
function TransformPoint(Source,Dest: TControl; const Point: TPoint): TPoint;
begin
  result:=Point;
  if Source <> nil then result:=Source.ClientToScreen(result);
  if Dest <> nil then result:=Dest.ScreenToClient(result);
end;

function CursorInControl(Control: TControl): TPoint;
begin
  result:=Control.ScreenToClient(Mouse.CursorPos);
end;

function IsCursorInControl(Control: TControl): boolean;
begin
  result:=PtInRect(Control.ClientRect,Control.ScreenToClient(Mouse.CursorPos));
end;

function FindControlAtPoint(Control: TWinControl; pos: TPoint): TControl;
{pos is point on screen}
var
  I: Integer;
begin
  for I:= 0 to Control.ControlCount -1 do
  begin
    result := Control.Controls[I];
    if result.Visible and PtInRect(result.BoundsRect,Control.ScreenToClient(Pos)) then
      exit;
  end;
  result := nil;
end;

function FindControlAtCursor(Form: Tform): TControl;
begin
  result:=FindControlAtPoint(form,Mouse.CursorPos);
end;

function RectPt(LeftTop,RightBottom: TPoint): TRect;
begin
  Result:=Rect(LeftTop.x,LeftTop.y,RightBottom.x,RightBottom.y);
end;

function MyUnionRect(Src1Rect, Src2Rect: TRect): TRect;
begin
  Result:=Src1Rect;
  with Src2Rect do
  begin
    if left < result.left then result.left:=left;
    if right > result.right then result.right:=right;
    if top < result.top then result.top:=top;
    if bottom > result.bottom then result.bottom:=bottom;
  end;
end;

function SortRect(Rect: TRect): TRect;
var i: integer;
begin
  result:=rect;
  if result.right < result.Left then
  begin
    i:=result.right;
    result.right:=result.Left;
    result.Left:=i;
  end;
  if result.bottom < result.Top then
  begin
    i:=result.bottom;
    result.bottom:=result.Top;
    result.Top:=i;
  end;
end;

function RectOverlap(Rect1,Rect2: TRect): boolean;
begin
  result:=not(
    (Rect2.Left >= Rect1.Right) or
    (Rect2.Right <= Rect1.Left) or
    (Rect2.Top >= Rect1.Bottom) or
    (Rect2.Bottom <= Rect1.Top));
end;

function RectOverlapMargin(Rect1,Rect2: TRect; Margin: integer): boolean;
begin
  result:=not(
    (Rect2.Left >= Rect1.Right+margin) or
    (Rect2.Right+margin <= Rect1.Left) or
    (Rect2.Top >= Rect1.Bottom+margin) or
    (Rect2.Bottom+margin <= Rect1.Top));
end;

function RectOverlapMargin2(Rect1,Rect2: TRect; xMargin,yMargin: integer): boolean;
begin
  result:=not(
    (Rect2.Left >= Rect1.Right+xmargin) or
    (Rect2.Right+xmargin <= Rect1.Left) or
    (Rect2.Top >= Rect1.Bottom+ymargin) or
    (Rect2.Bottom+ymargin <= Rect1.Top));
end;

procedure ScaleRect(var lprc: TRect; dx, dy: double);
begin
  lprc.Left:=trunc(lprc.Left*dx);
  lprc.Right:=trunc(lprc.Right*dx);
  lprc.Top:=trunc(lprc.Top*dy);
  lprc.Bottom:=trunc(lprc.Bottom*dy);
end;

function MyOffsetRect(aRect: TRect; dx, dy: integer): TRect;
begin
  Result:=aRect;
  with Result do
  begin
    left:=left+dx;
    right:=right+dx;
    top:=top+dy;
    bottom:=bottom+dy;
  end;
end;

function MyInflateRect(aRect: TRect; dx, dy: integer): TRect;
begin
  Result:=aRect;
  with Result do
  begin
    left:=left-dx;
    right:=right+dx;
    top:=top-dy;
    bottom:=bottom+dy;
  end;
end;

function MyIntersectRect(Src1Rect, Src2Rect: TRect): TRect;
begin
  Result:=Src1Rect;
  with Src2Rect do
  begin
    if left > result.left then result.left:=left;
    if right < result.right then result.right:=right;
    if top > result.top then result.top:=top;
    if bottom < result.bottom then result.bottom:=bottom;
  end;
  with result do
  begin
    if right < left then right:=left;
    if bottom < top then bottom:=top;
  end;
end;

function KeyName(vk: integer): string;
begin
  case vk of
    VK_SHIFT:   result:='Shift';
    VK_CONTROL: result:='Ctrl';
    VK_MENU:    result:='Alt';
    else        result:=ShortCutToText(vk);
  end;
end;

function KeyNameEx(key: word): string;
begin
  case key of
    VK_CANCEL: result:='CANCEL';
    VK_BACK: result:='BACK';
    VK_TAB: result:='TAB';
    VK_CLEAR: result:='CLEAR';
    VK_RETURN: result:='RETURN';
    VK_SHIFT: result:='SHIFT';
    VK_CONTROL: result:='CONTROL';
    VK_MENU: result:='MENU';
    VK_PAUSE: result:='PAUSE';
    VK_CAPITAL: result:='CAPITAL';
    VK_KANA: result:='KANA';
{    VK_HANGUL: result:='HANGUL';}
    VK_JUNJA: result:='JUNJA';
    VK_FINAL: result:='FINAL';
    VK_HANJA: result:='HANJA';
{    VK_KANJI: result:='KANJI';}
    VK_CONVERT: result:='CONVERT';
    VK_NONCONVERT: result:='NONCONVERT';
    VK_ACCEPT: result:='ACCEPT';
    VK_MODECHANGE: result:='MODECHANGE';
    VK_ESCAPE: result:='ESCAPE';
    VK_SPACE: result:='SPACE';
    VK_PRIOR: result:='PRIOR';
    VK_NEXT: result:='NEXT';
    VK_END: result:='end';
    VK_HOME: result:='HOME';
    VK_LEFT: result:='LEFT';
    VK_UP: result:='UP';
    VK_RIGHT: result:='RIGHT';
    VK_DOWN: result:='DOWN';
    VK_SELECT: result:='SELECT';
    VK_PRINT: result:='PRINT';
    VK_EXECUTE: result:='EXECUTE';
    VK_SNAPSHOT: result:='SNAPSHOT';
    VK_INSERT: result:='INSERT';
    VK_DELETE: result:='DELETE';
    VK_HELP: result:='HELP';
    VK_LWIN: result:='LWIN';
    VK_RWIN: result:='RWIN';
    VK_APPS: result:='APPS';
    VK_NUMPAD0: result:='NUMPAD0';
    VK_NUMPAD1: result:='NUMPAD1';
    VK_NUMPAD2: result:='NUMPAD2';
    VK_NUMPAD3: result:='NUMPAD3';
    VK_NUMPAD4: result:='NUMPAD4';
    VK_NUMPAD5: result:='NUMPAD5';
    VK_NUMPAD6: result:='NUMPAD6';
    VK_NUMPAD7: result:='NUMPAD7';
    VK_NUMPAD8: result:='NUMPAD8';
    VK_NUMPAD9: result:='NUMPAD9';
    VK_MULTIPLY: result:='MULTIPLY';
    VK_ADD: result:='ADD';
    VK_SEPARATOR: result:='SEPARATOR';
    VK_SUBTRACT: result:='SUBTRACT';
    VK_DECIMAL: result:='DECIMAL';
    VK_DIVIDE: result:='DIVIDE';
    VK_F1: result:='F1';
    VK_F2: result:='F2';
    VK_F3: result:='F3';
    VK_F4: result:='F4';
    VK_F5: result:='F5';
    VK_F6: result:='F6';
    VK_F7: result:='F7';
    VK_F9: result:='F9';
    VK_F10: result:='F10';
    VK_F11: result:='F11';
    VK_F12: result:='F12';
    VK_F13: result:='F13';
    VK_F14: result:='F14';
    VK_F15: result:='F15';
    VK_F16: result:='F16';
    VK_F17: result:='F17';
    VK_F18: result:='F18';
    VK_F19: result:='F19';
    VK_F20: result:='F20';
    VK_F21: result:='F21';
    VK_F22: result:='F22';
    VK_F23: result:='F23';
    VK_F24: result:='F24';
    VK_NUMLOCK: result:='NUMLOCK';
    VK_SCROLL: result:='SCROLL';
    VK_LSHIFT: result:='LSHIFT';
    VK_RSHIFT: result:='RSHIFT';
    VK_LCONTROL: result:='LCONTROL';
    VK_RCONTROL: result:='RCONTROL';
    VK_LMENU: result:='LMENU';
    VK_RMENU: result:='RMENU';
    VK_PROCESSKEY: result:='PROCESSKEY';
    VK_ATTN: result:='ATTN';
    VK_CRSEL: result:='CRSEL';
    VK_EXSEL: result:='EXSEL';
    VK_EREOF: result:='EREOF';
    VK_PLAY: result:='PLAY';
    VK_ZOOM: result:='ZOOM';
    VK_NONAME: result:='NONAME';
    VK_PA1: result:='PA1';
    VK_OEM_CLEAR: result:='OEM_CLEAR';
    ord('0')..ord('9'): result:=char(key);
    ord('A')..ord('Z'): result:=char(key);
    else result:='';
  end;
end;

function mmErrString(i: MMRESULT): string;
var t: string[255];
begin
  result:='';
  if i = MMSYSERR_NOERROR then exit;

  if WaveInGetErrorText(i,@t[1],sizeof(t)-2) = MMSYSERR_NOERROR then
  begin
    t[0]:=char(strlen(@t[1]));
    result:='Waveform audio In error: '+t;
  end else
  if WaveOutGetErrorText(i,@t[1],sizeof(t)-2) = MMSYSERR_NOERROR then
  begin
    t[0]:=char(strlen(@t[1]));
    result:='Waveform audio Out error: '+t;
  end else
  if MIDIInGetErrorText(i,@t[1],sizeof(t)-2) = MMSYSERR_NOERROR then
  begin
    t[0]:=char(strlen(@t[1]));
    result:='MIDI In error: '+t;
  end else
  if MIDIOutGetErrorText(i,@t[1],sizeof(t)-2) = MMSYSERR_NOERROR then
  begin
    t[0]:=char(strlen(@t[1]));
    result:='MIDI Out error: '+t;
  end else
  case i of
{
    ACMERR_CANCELED:           result:='ACM Error: The user chose the Cancel button or the Close command on the System menu to close the dialog box.';
    ACMERR_NOTPOSSIBLE:        result:='ACM Error: The buffer identified by the pwfx member of the ACMFORMATCHOOSE structure is too small to contain the selected format.';
    ACMERR_BUSY:               result:='ACM Error: The Stream header specified in pash is currently in use and cannot be reused.';
    ACMERR_UNPREPARED:         result:='ACM Error: The Stream header specified in pash is currently not prepared by the acmStreamPrepareHeader function.';
}

    MMSYSERR_ERROR:            result:='Multimedia system error: unspecified error';
    MMSYSERR_BADDEVICEID:      result:='Multimedia system error: Specified device identifier is out of range.';
    MMSYSERR_NOTENABLED:       result:='Multimedia system error: driver failed enable';
    MMSYSERR_ALLOCATED:        result:='Multimedia system error: Specified reSource is already allocated.';
    MMSYSERR_INVALHANDLE:      result:='Multimedia system error: The specified handle is invalid.';
    MMSYSERR_NODRIVER:         result:='Multimedia system error: A suitable driver is not available to provide valid format selections.';
    MMSYSERR_NOMEM:            result:='Multimedia system error: Unable to allocate or lock memory.';
    MMSYSERR_NOTSUPPORTED:     result:='Multimedia system error: function isn''t supported.';
    MMSYSERR_BADERRNUM:        result:='Multimedia system error: Specified error number is out of range.';
    MMSYSERR_INVALFLAG:        result:='Multimedia system error: At least one flag is invalid.';
    MMSYSERR_INVALPARAM:       result:='Multimedia system error: At least one parameter is invalid.';
    MMSYSERR_HANDLEBUSY:       result:='Multimedia system error: handle being used simultaneously on another thread (eg callback)';
    MMSYSERR_INVALIDALIAS:     result:='Multimedia system error: specified alias not found';
    MMSYSERR_BADDB:            result:='Multimedia system error: bad registry database';
    MMSYSERR_KEYNOTFOUND:      result:='Multimedia system error: registry key not found';
    MMSYSERR_READERROR:        result:='Multimedia system error: registry read error';
    MMSYSERR_WRITEERROR:       result:='Multimedia system error: registry write error';
    MMSYSERR_DELETEERROR:      result:='Multimedia system error: registry delete error';
    MMSYSERR_VALNOTFOUND:      result:='Multimedia system error: registry value not found';
    MMSYSERR_NODRIVERCB:       result:='Multimedia system error: driver does not call DriverCallback';

    WAVERR_BADFORMAT:          result:='Waveform audio error: Attempted to open with an unsupported waveform-audio format.';
    WAVERR_STILLPLAYING:       result:='Waveform audio error: The data block pointed to by the pwh parameter is still in the queue.';
    WAVERR_UNPREPARED:         result:='Waveform audio error: The buffer pointed to by the pwh parameter is not prepared';
    WAVERR_SYNC:               result:='Waveform audio error: The device is synchronous but waveOutOpen was called without using the WAVE_ALLOWSYNC flag.';

    MIDIERR_UNPREPARED:        result:='MIDI error: header not prepared';
    MIDIERR_STILLPLAYING:      result:='MIDI error: still something playing';
    MIDIERR_NOMAP:             result:='MIDI error: no current map';
    MIDIERR_NOTREADY:          result:='MIDI error: hardware is still busy';
    MIDIERR_NODEVICE:          result:='MIDI error: port no longer connected';
    MIDIERR_INVALIDSETUP:      result:='MIDI error: invalid setup';
    MIDIERR_BADOPENMODE:       result:='MIDI error: operation unsupported w/ open mode';
    MIDIERR_DONT_CONTINUE:     result:='MIDI error: thru device ''eating'' a message';

    MIXERR_INVALCONTROL:       result:='Mixer error: The control reference is invalid.';
    MIXERR_INVALLINE:          result:='Mixer error: MIXERR_INVALLINE';
    MIXERR_INVALVALUE:         result:='Mixer error: MIXERR_INVALVALUE';

    TIMERR_NOCANDO:            result:='Multimedia timer error: request not completed';
    TIMERR_STRUCT:             result:='Multimedia timer error: time struct size';

    JOYERR_NOERROR:            result:='Joystick error: no error';
    JOYERR_PARMS:              result:='Joystick error: bad parameters';
    JOYERR_NOCANDO:            result:='Joystick error: request not completed';
    JOYERR_UNPLUGGED:          result:='Joystick error: joystick is unplugged';

    MMIOERR_FILENOTFOUND:      result:='Multimedia I/O error: file not found';
    MMIOERR_OUTOFMEMORY:       result:='Multimedia I/O error: out of memory';
    MMIOERR_CANNOTOPEN:        result:='Multimedia I/O error: cannot open';
    MMIOERR_CANNOTCLOSE:       result:='Multimedia I/O error: cannot close';
    MMIOERR_CANNOTREAD:        result:='Multimedia I/O error: cannot read';
    MMIOERR_CANNOTWRITE:       result:='Multimedia I/O error: cannot write';
    MMIOERR_CANNOTSEEK:        result:='Multimedia I/O error: cannot seek';
    MMIOERR_CANNOTEXPAND:      result:='Multimedia I/O error: cannot expand file';
    MMIOERR_CHUNKNOTFOUND:     result:='Multimedia I/O error: chunk not found';
    MMIOERR_UNBUFFERED:        result:='Multimedia I/O error: file is unbuffered';
    MMIOERR_PATHNOTFOUND:      result:='Multimedia I/O error: path incorrect';
    MMIOERR_ACCESSDENIED:      result:='Multimedia I/O error: file was protected';
    MMIOERR_SHARINGVIOLATION:  result:='Multimedia I/O error: file in use';
    MMIOERR_NETWORKERROR:      result:='Multimedia I/O error: network not responding';
    MMIOERR_TOOMANYOPENFILES:  result:='Multimedia I/O error: no more file handles';
    MMIOERR_INVALIDFILE:       result:='Multimedia I/O error: default error file error';

    else                       result:='Error: '+inttostr(i);
  end;
end;

function mmErr(i: MMRESULT): boolean;
begin
  if i = MMSYSERR_NOERROR then
    result:=false else
  begin
    result:=true;
    ShowErrorMessage(mmErrString(i));
  end;
end;

function Cosh(x: double): double;
begin
  result:=(exp(x)+exp(-x))/2;
end;

function Sinh(x: double): double;
begin
  result:=(exp(x)-exp(-x))/2;
end;

function DblSign(a: double): double;
begin
  if a > 0 then result:=+1 else
  if a < 0 then result:=-1 else
                result:=0;
end;

function Sign(a: longint): longint;
begin
  if a > 0 then result:=+1 else
  if a < 0 then result:=-1 else
                result:=0;
end;

function Pythag(x,y: double): double;
begin
  result:=sqrt(sqr(x)+sqr(y));
end;

function AddSP(p1,p2: TSinglePoint): TSinglePoint;
begin
  result.x:=p1.x+p2.x;
  result.y:=p1.y+p2.y;
end;

function SubSP(p1,p2: TSinglePoint): TSinglePoint;
begin
  result.x:=p1.x-p2.x;
  result.y:=p1.y-p2.y;
end;

function cwOrthog(p: TSinglePoint): TSinglePoint;
begin
  result.x:=+p.y;
  result.y:=-p.x;
end;

function ccwOrthog(p: TSinglePoint): TSinglePoint;
begin
  result.x:=-p.y;
  result.y:=+p.x;
end;

function TurnSP(p: TSinglePoint; a: single): TSinglePoint;
begin
  result.x:=+p.x*cos(a)+p.y*sin(a);
  result.y:=-p.x*sin(a)+p.y*cos(a);
end;

function UnitVector(p: TSinglePoint): TSinglePoint;
var l: double;
begin
  result:=p;
  l:=Pythag(p.x,p.y);
  if result.x <> 0 then result.x:=result.x/l;
  if result.y <> 0 then result.y:=result.y/l;
end;

function ScaleVector(p: TSinglePoint; scale: single): TSinglePoint;
begin
  result.x:=p.x*scale;
  result.y:=p.y*scale;
end;

function ScaleSP(p: TSinglePoint; scale: single): TSinglePoint;
begin
  result.x:=p.x*scale;
  result.y:=p.y*scale;
end;

function AddVector(p,q: TSinglePoint): TSinglePoint;
begin
  result.x:=p.x+q.x;
  result.y:=p.y+q.y;
end;

function SubVector(p,q: TSinglePoint): TSinglePoint;
begin
  result.x:=p.x-q.x;
  result.y:=p.y-q.y;
end;

function MultVector(p,q: TSinglePoint): TSinglePoint;
begin
  result.x:=p.x*q.x;
  result.y:=p.y*q.y;
end;

function DotProduct(a,b: TSinglePoint): double;
begin
  result:=a.x*b.x+a.y*b.y;
end;

procedure UnitLength(var x,y: double);
var l: double;
begin
  l:=Pythag(x,y);
  if x <> 0 then x:=x/l;
  if y <> 0 then y:=y/l;
end;

procedure UnitLength3d(var x,y,z: double);
var l: single;
begin
  l:=Pythag3D(x,y,z);
  if x <> 0 then x:=x/l;
  if y <> 0 then y:=y/l;
  if z <> 0 then z:=z/l;
end;

function Pythag3d(x,y,z: double): double;
begin
  result:=sqrt(sqr(x)+sqr(y)+sqr(z));
end;

function DistSinglePointToPoint(p1,p2: TSinglePoint): double;
begin
  result:=Pythag(p1.x-p2.x,p1.y-p2.y);
end;

function DistPointToPoint(p1,p2: TPoint): double;
begin
  result:=Pythag(p1.x-p2.x,p1.y-p2.y);
end;

function DistSinglePointToLine(p,p1,p2: TSinglePoint): double;
begin
  with NearestSinglePointOnLineToPoint(p,p1,p2) do
    result:=sqrt(sqr(p.x-x)+sqr(p.y-y));
end;

function DistPointToLine(p,p1,p2: TPoint): double;
begin
  with NearestPointOnLineToPoint(p,p1,p2) do
    result:=sqrt(sqr(p.x-x)+sqr(p.y-y));
end;

function DistPointToLineInfinite(p,p1,p2: TPoint): double;
var L: double;
begin
  L:=DistPointToPoint(p1,p2);
  if L = 0 then
    result:=DistPointToPoint(p,p1) else
    result:=abs((p2.y-p1.y)*p.x-(p2.x-p1.x)*p.y-p1.x*p2.y+p2.x*p1.y)/L;
end;

function AddPoints(p1,p2: TPoint): TPoint;
begin
  result.x:=p1.x+p2.x;
  result.y:=p1.y+p2.y;
end;

function SubPoints(p1,p2: TPoint): TPoint;
begin
  result.x:=p1.x-p2.x;
  result.y:=p1.y-p2.y;
end;

function NearestSinglePointOnLineToPoint(p,p1,p2: TSinglePoint): TSinglePoint;
var t: single;
begin
  result:=NearestSinglePointOnLineToPointEx(p,p1,p2,t);
end;

function NearestSinglePointOnLineToPointEx(p,p1,p2: TSinglePoint; var t: single): TSinglePoint;
{l is length of line x1,y1,x2,y2}
var l: double;
begin
  l:=(sqr(p2.x-p1.x)+sqr(p2.y-p1.y));
  if l < 0.0001 then
    t:=0 else
    t:=((p.x-p1.x)*(p2.x-p1.x)+(p.y-p1.y)*(p2.y-p1.y))/l;
  if t < 0 then
    result:=p1 else
  if t > 1 then
    result:=p2 else
  begin
    result.x:=(p2.x-p1.x)*t+p1.x;
    result.y:=(p2.y-p1.y)*t+p1.y;
  end;
end;

function NearestSinglePointOnLineToPointUnclipped(p,p1,p2: TSinglePoint; var t: single): TSinglePoint;
{l is length of line x1,y1,x2,y2}
var l: double;
begin
  l:=(sqr(p2.x-p1.x)+sqr(p2.y-p1.y));
  if l < 0.0001 then
    t:=0 else
    t:=((p.x-p1.x)*(p2.x-p1.x)+(p.y-p1.y)*(p2.y-p1.y))/l;
  result.x:=(p2.x-p1.x)*t+p1.x;
  result.y:=(p2.y-p1.y)*t+p1.y;
end;

function NearestPointOnLineToPoint(p,p1,p2: TPoint): TPoint;
{l is length of line x1,y1,x2,y2}
var t: double;
var l: double;
begin
  l:=(sqr(p2.x-p1.x)+sqr(p2.y-p1.y));
  if l < 0.0001 then
  begin
    result:=p1;
  end else
  begin
    t:=((p.x-p1.x)*(p2.x-p1.x)+(p.y-p1.y)*(p2.y-p1.y))/l;
    if t < 0 then
      result:=p1 else
    if t > 1 then
      result:=p2 else
    begin
      result.x:=round((p2.x-p1.x)*t+p1.x);
      result.y:=round((p2.y-p1.y)*t+p1.y);
    end;
  end;
end;

procedure ClipCursorControl(Control: TControl);
var aRect: TRect;
begin
  if Control = nil then
    ClipCursor(nil) else
  begin
    aRect:=Control.ClientRect;
    with Control.ClientToScreen(Point(0,0)) do
      OffsetRect(aRect,x,y);
    ClipCursor(@aRect);
  end;
end;

function MyGetTickCount: integer;
begin
  result:=GetTickCount and maxint;
end;

function TimeDiff(t1,t2: integer): integer;
begin
  result:=(t1-t2) and maxint;
end;

function TimeSince(t2: integer): integer; 
begin
  result:=TimeDiff(MyGetTickCount,t2);
end;

function FileToString(FileName: string): string;
begin
  result:=LoadFromFileString(FileName);
end;

function FileToStringEx(FileName: string; maxlen: integer): string;
var fStream: TFileStream;
begin
  try
    fStream:=TFileStream.Create(filename, fmOpenRead);
    SetLength(result,min(fStream.Size,maxlen));
    if fStream.Size > 0 then
      fStream.read(result[1],Length(result));
  finally
    fStream.Free;
  end;
end;

function LoadFromFileString(FileName: string): string;
var fStream: TFileStream;
begin
  try
    fStream:=TFileStream.Create(filename, fmOpenRead);
    SetLength(result,fStream.Size);
    if fStream.Size > 0 then
      fStream.read(result[1],fStream.Size);
  finally
    fStream.Free;
  end;
end;

procedure StringToFile(FileName,s: string);
begin
  SaveToFileString(FileName,s);
end;

procedure SaveToFileString(FileName,s: string);
var fStream: TFileStream;
begin
  try
    fStream:=nil;
    fStream:=TFileStream.Create(filename, fmCreate);
    if s <> '' then
      fStream.Write(s[1],length(s));
  finally
    if fStream <> nil then
      fStream.Free;
  end;
end;

procedure StreamWrite(Stream: TStream; s: string);
begin
  Stream.Write(s[1],length(s));
end;

procedure StreamWriteLn(Stream: TStream; s: string);
begin
  StreamWrite(Stream,s+#13#10);
end;

procedure StreamWriteLnInt(Stream: TStream; i: integer);
begin
  StreamWriteLn(Stream,inttostr(i));
end;

procedure StreamWriteInt(Stream: TStream; i: integer);
begin
  StreamWrite(Stream,inttostr(i));
end;

procedure StreamReadLnInit;
begin
  StreamInputBuffer:='';
end;

function StreamReadStr(Stream: TStream; len: integer): string;
var i: integer;
begin
  i:=IntMin([len,Stream.Size-Stream.Position]);
  SetLength(result,i);
  if i > 0 then
    Stream.ReadBuffer(result[1],i);
end;

procedure WriteFileBlock(Filename: string; var buf; len: integer);
var iFile: TFileStream;
begin
  try
    iFile:=TFileStream.Create(filename,fmCreate);
    iFile.Write(buf,len);
  finally
    iFile.Free;
  end;
end;

procedure ReadFileBlock(filename: string; var buf; start,len: integer);
var iFile: TFileStream;
begin
  try
    iFile:=TFileStream.Create(filename,fmOpenRead);
    iFile.position:=start;
    iFile.Read(buf,len);
  finally
    iFile.Free;
  end;
end;

function StreamReadLn(Stream: TStream): string;
var i: integer;
begin
  i:=IntMin([1024,Stream.Size-Stream.Position-1]);
  if (pos(#13,StreamInputBuffer) = 0) and (i > 0) then
  begin
    SetLength(result,i);
    Stream.ReadBuffer(result[1],i);
    StreamInputBuffer:=StreamInputBuffer+result;
  end;

  result:=StrBefore(StreamInputBuffer,1,#13,false);
  StreamInputBuffer:=StrAfter(StreamInputBuffer,1,#13,false);
  result:=StrReplace(result,#10,'',true);
end;

function StreamReadLnInt(Stream: TStream): integer;
begin
  result:=StrToInt(StreamReadLn(Stream));
end;

function StreamReadLnEOF(Stream: TStream): boolean;
begin
  result:=(Stream.Position >= Stream.Size-1) and (StreamInputBuffer = '');
end;

function Red(color: TColor): integer;    begin result:=GetRValue(Color and clwhite); end;
function Green(color: TColor): integer;  begin result:=GetGValue(Color and clwhite); end;
function Blue(color: TColor): integer;   begin result:=GetBValue(Color and clwhite); end;

function ColorName(Color: Longint): string;
begin
  if not ColorToIdent(Color,result) then
    result:='RGB('+inttostr(Red(color))+','+inttostr(Green(color))+','+inttostr(Blue(color))+')';
end;

function ClipRGB(R,G,B: Longint): TColor;
begin
  Result:=RGB(ByteRange(R), ByteRange(G), ByteRange(B));
end;

function ColorToGrey(col: TColor): TColor;
begin
  result:=(Red(col)+Green(col)+Blue(col)) div 3;
  result:=rgb(result,result,result);
end;

function DarkenColorEx(c: TColor; i: integer): TColor;
begin
  with TRGBQUAD(c) do
    result:=ClipRGB(
        rgbBlue-i,
        rgbGreen-i,
        rgbRed-i);
end;

function LightenColorEx(c: TColor; i: integer): TColor;
begin
  with TRGBQUAD(c) do
    result:=ClipRGB(
        rgbBlue+(255-rgbBlue) div 2+i,
        rgbGreen+(255-rgbGreen) div 2+i,
        rgbRed+(255-rgbRed) div 2+i);
end;

function LightenColor(c: TColor; lighter: boolean): TColor;
begin
  with TRGBQUAD(c) do
    if lighter then
    begin
      result:=ClipRGB(
        rgbBlue+(255-rgbBlue) div 2+20,
        rgbGreen+(255-rgbGreen) div 2+20,
        rgbRed+(255-rgbRed) div 2+20);
//      if result = clWhite then
//        result:=clSilver;
    end else
      result:=ClipRGB(
        rgbBlue*2 div 3-20,
        rgbGreen*2 div 3-20,
        rgbRed*2 div 3-20);
end;

procedure SetPageControlPage(Control: TPageControl; TabSheet: TTabSheet);
begin
  SetPageControlIndex(Control,TabSheet.TabIndex);
end;

procedure SetPageControlIndex(Control: TPageControl; value: integer);
{ doesn't work if you select an invisible page}
var i,j: integer;
begin
  for i:=1 to Control.PageCount do
  begin
    if Control.ActivePage.TabIndex = value then
      exit;
    Control.SelectNextPage(true);
  end;
end;

function SetTStrings(Strings: TStrings; index: integer;
  const s: array of string; const a: array of integer): integer;
var i: integer;
begin
  result:=-1;
  Strings.Clear;
  for i:=low(a) to high(a) do
    Strings.AddObject(s[i],system.pointer(a[i]));
  for i:=0 to Strings.Count-1 do
    if Strings.Objects[i] = system.pointer(index) then
      result:=i;
end;

function DlgGetSetCheckBox(aControl: TCheckBox; value: boolean; Get: boolean): boolean;
begin
  result:=value;
  if Get then
    result:=aControl.Checked else
    aControl.Checked:=value;
end;

function DlgGetSetSpinEdit(aControl: TSpinEdit; value: integer; Get: boolean): integer;
begin
  result:=value;
  if Get then
    result:=aControl.Value else
    aControl.Value:=value;
end;

function DlgGetSetColor(aControl: TPanel; value: TColor; Get: boolean): TColor;
begin
  result:=value;
  if Get then
    result:=aControl.Color else
    aControl.Color:=value;
end;

function DlgGetSetEdit(aControl: TEdit; value: string; Get: boolean): string;
begin
  result:=value;
  if Get then
    result:=aControl.Text else
    aControl.Text:=value;
end;

function MemoryToString(var mem; size: integer): string;
begin
  setlength(result,size);
  move(mem,result[1],size);
end;

procedure StringToMemory(s: string; var mem);
begin
  move(s[1],mem,length(s));
end;

function ReadInt(Stream: TStream): integer;
begin
  Stream.Read(result,sizeof(result));
end;

procedure WriteInt(Stream: TStream; i: integer);
begin
  Stream.Write(i,sizeof(i));
end;

procedure WriteWord(Stream: TStream; i: word);
begin
  Stream.Write(i,sizeof(i));
end;

function ReadBool(Stream: TStream): boolean;
begin
  Stream.Read(result,sizeof(result));
end;

procedure WriteBool(Stream: TStream; i: boolean);
begin
  Stream.Write(i,sizeof(i));
end;

function ReadStr(Stream: TStream): string;
var i: integer;
begin
  i:=ReadInt(Stream);
  assert(Stream.Position+i <= Stream.Size,'Error while reading from Stream');
  setlength(result,i);
  if result <> '' then
    Stream.Read(result[1],length(result)) else
    result:='';
end;

procedure WriteStr(Stream: TStream; s: string);
begin
  WriteInt(Stream,length(s));
  if s <> '' then
    Stream.Write(s[1],length(s));
end;

function LoadSaveInt(Load: boolean; Stream: TStream; i: integer): integer;
begin
  if load then
    result:=ReadInt(Stream) else
  begin
    result:=i;
    WriteInt(Stream,i);
  end;
end;

function LoadSaveBool(Load: boolean; Stream: TStream; i: Boolean): Boolean;
begin
  if load then
    Stream.Read(result,sizeof(result)) else
  begin
    result:=i;
    Stream.Write(i,sizeof(i));
  end;
end;

function LoadSaveStr(Load: boolean; Stream: TStream; s: string): string;
begin
  if load then
  begin
    result:=ReadStr(Stream);
  end else
  begin
    result:=s;
    WriteStr(Stream,s);
  end;
end;

procedure HighlightListboxItem(Listbox1: TListbox; i: integer);
begin
  Listbox1.ItemIndex:=-1;
  Listbox1.ItemIndex:=Listbox1.Items.Count-1;
  if Listbox1.Items.Count > 0 then
    Listbox1.ItemIndex:=0;
  Listbox1.ItemIndex:=i;
end;

procedure FillHatchedTRect(aCanvas: TCanvas; rect: TRect; period: integer);
begin
  with rect do
    FillHatchedRect(aCanvas,left,Top,Right,Bottom,period);
end;

procedure FillHatchedRect(aCanvas: TCanvas; x1,y1,x2,y2,period: integer);
var i,xa,ya,xb,yb: integer;
begin
  with aCanvas do
  begin
      if x1 > x2 then
        swap(x1,x2);
      if y1 > y2 then
        swap(y1,y2);
      for i:=0 to y2-y1+x2-x1 do
      if i mod period = 0 then
      begin
        xa:=x1+i;
        ya:=y1;
        xb:=x1;
        yb:=y1+i;
        if xa > x2 then
        begin
          ya:=y1+xa-x2;
          xa:=x2;
        end;
        if yb > y2 then
        begin
          xb:=x1+yb-y2;
          yb:=y2;
        end;
        MoveTo(xa,ya);
        LineTo(xb,yb);
      end;
  end;
end;

procedure OutlineTRect(aCanvas: TCanvas; rect: TRect);
begin
  with rect do
    OutlineRect(aCanvas,left,Top,Right,Bottom);
end;

procedure OutlineRect(aCanvas: TCanvas; x1,y1,x2,y2: integer);
begin
  with aCanvas do
  begin
    moveto(x1,y1);
    lineto(x1,y2);
    lineto(x2,y2);
    lineto(x2,y1);
    lineto(x1,y1);
  end;
end;

procedure DrawArrow(aCanvas: TCanvas; x1,y1,x2,y2,HeadLen,HeadWidth: integer);
var d,a1,a2: single;
begin
  d:=DistPointToPoint(Point(x1,y1),Point(x2,y2));
  if d > 0 then
  with aCanvas do
  begin
    Moveto(x1,y1);
    LineTo(x2,y2);
    Pixels[x2,y2]:=pen.color;
    a1:=HeadWidth/d;
    a2:=HeadLen/d;
    Moveto(x2,y2);
    LineTo(
      round(x2-(y2-y1)*a1-(x2-x1)*a2),
      round(y2+(x2-x1)*a1-(y2-y1)*a2));
    Moveto(x2,y2);
    LineTo(
      round(x2+(y2-y1)*a1-(x2-x1)*a2),
      round(y2-(x2-x1)*a1-(y2-y1)*a2));
  end;
end;

procedure DrawLineSP(aCanvas: TCanvas; p1,p2: TSinglePoint);
begin
  aCanvas.Moveto(round(p1.x),round(p1.y));
  aCanvas.Lineto(round(p2.x),round(p2.y));
end;

procedure DrawLineP(aCanvas: TCanvas; p1,p2: TPoint);
begin
  aCanvas.Moveto(p1.x,p1.y);
  aCanvas.Lineto(p2.x,p2.y);
end;

procedure DrawLine(aCanvas: TCanvas; x1,y1,x2,y2: integer);
var e,da,db,sa,sb: integer;
    pa1,pb1,pa2,pb2: ^integer;
begin
  if abs(x2-x1) > abs(y2-y1) then
  begin
    pa1:=@x1;
    pb1:=@y1;
    pa2:=@x2;
    pb2:=@y2;
  end else
  begin
    pa1:=@y1;
    pb1:=@x1;
    pa2:=@y2;
    pb2:=@x2;
  end;

  if pa1^ > pa2^ then sa:=-1 else sa:=+1;
  if pb1^ > pb2^ then sb:=-1 else sb:=+1;
  da:=abs(pa2^-pa1^);
  db:=abs(pb2^-pb1^);
  e:=da div 2;

  while pa2^ <> pa1^ do
  begin
    if aCanvas <> nil then
      if aCanvas.pen.Width = 1 then
        aCanvas.pixels[x1,y1]:=aCanvas.Pen.Color else
        aCanvas.Ellipse(x1-aCanvas.pen.Width div 2,
                        y1-aCanvas.pen.Width div 2,
                        x1+aCanvas.pen.Width div 2,
                        y1+aCanvas.pen.Width div 2);

    inc(pa1^,sa);
    inc(e,db);
    if e > da then
    begin
      inc(pb1^,sb);
      e:=e-da;
    end;
  end;                                            
end;

procedure DrawDottedRect(aCanvas: TCanvas; x1,y1,x2,y2,pattern: integer);
begin
  DrawDottedLine(aCanvas,x1,y1,x1,y2,pattern);
  DrawDottedLine(aCanvas,x1,y2,x2,y2,pattern);
  DrawDottedLine(aCanvas,x2,y2,x2,y1,pattern);
  DrawDottedLine(aCanvas,x2,y1,x1,y1,pattern);
end;

procedure DrawDottedLine(aCanvas: TCanvas; x1,y1,x2,y2,pattern: integer);
{ pattern is a 32-bit pixel pattern }
  procedure SetPix(x,y: integer);
  var ix,iy,k: integer;
  const prevx: integer = -1;
        prevy: integer = -1;
        dotMask: integer = 1;
        dotCnt: integer = 1;
  begin
    if (x = prevx) and (y = prevy) then
      exit;

    if dotMask and pattern <> 0 then
    begin
      if aCanvas.pen.Width > 1 then
      begin
        aCanvas.Ellipse(x-aCanvas.pen.Width div 2,
                        y-aCanvas.pen.Width div 2,
                        x-aCanvas.pen.Width div 2+aCanvas.pen.Width,
                        y-aCanvas.pen.Width div 2+aCanvas.pen.Width);
{
        k:=PenWidth*2 div 3;
        for ix:=-PenWidth div 2 to (-PenWidth div 2)+PenWidth do
          for iy:=-PenWidth div 2 to (-PenWidth div 2)+PenWidth do
            if abs(ix)+abs(iy) <= k then
              aCanvas.Pixels[x+ix,y+iy]:=aCanvas.Pen.Color;
}
      end else
        aCanvas.Pixels[x,y]:=aCanvas.Pen.Color;
    end;
    inc(dotCnt);
    if dotCnt mod aCanvas.pen.Width = 0 then
      dotMask:=max(dotMask shl 1,1);
  end;
var x,y: integer;
begin
  if (x1 = x2) and (y1 = y2) then
    exit;

  if abs(x1-x2) > abs(y1-y2) then
  begin
    if x1 < x2 then
      for x:=x1 to x2 do
        SetPix(x,round(y1+(x-x1)*(y2-y1)/(x2-x1))) else
//      for x:=x2 to x1 do
//        SetPix(x,round(y2+(x-x2)*(y1-y2)/(x1-x2)));
      for x:=x1 downto x2 do
        SetPix(x,round(y1+(x-x1)*(y2-y1)/(x2-x1)));
  end else
  begin
    if y1 < y2 then
      for y:=y1 to y2 do
        SetPix(round(x1+(y-y1)*(x2-x1)/(y2-y1)),y) else
//      for y:=y2 to y1 do
//        SetPix(round(x2+(y-y2)*(x1-x2)/(y1-y2)),y);
      for y:=y1 downto y2 do
        SetPix(round(x1+(y-y1)*(x2-x1)/(y2-y1)),y);
  end;
  aCanvas.moveto(x2,y2);
end;

(*
procedure DrawDottedLine(aCanvas: TCanvas; x1,y1,x2,y2,pattern: integer);
{ pattern is a 32-bit pixel pattern }
  procedure SetPix(x,y: integer);
  var ix,iy,k: integer;
  const prevx: integer = -1;
        prevy: integer = -1;
        dotMask: integer = 1;
        dotCnt: integer = 1;
  begin
    if (x = prevx) and (y = prevy) then
      exit;

    if dotMask and pattern <> 0 then
    begin
      if aCanvas.pen.Width > 1 then
      begin
        aCanvas.Ellipse(x-aCanvas.pen.Width div 2,
                        y-aCanvas.pen.Width div 2,
                        x-aCanvas.pen.Width div 2+aCanvas.pen.Width,
                        y-aCanvas.pen.Width div 2+aCanvas.pen.Width);
{
        k:=PenWidth*2 div 3;
        for ix:=-PenWidth div 2 to (-PenWidth div 2)+PenWidth do
          for iy:=-PenWidth div 2 to (-PenWidth div 2)+PenWidth do
            if abs(ix)+abs(iy) <= k then
              aCanvas.Pixels[x+ix,y+iy]:=aCanvas.Pen.Color;
}
      end else
        aCanvas.Pixels[x,y]:=aCanvas.Pen.Color;
    end;
    inc(dotCnt);
    if dotCnt mod aCanvas.pen.Width = 0 then
      dotMask:=max(dotMask shl 1,1);
  end;
var x,y: integer;
begin
  if (x1 = x2) and (y1 = y2) then
    exit;

  if abs(x1-x2) > abs(y1-y2) then
  begin
    if x1 < x2 then
      for x:=x1 to x2 do
        SetPix(x,round(y1+(x-x1)*(y2-y1)/(x2-x1))) else
      for x:=x2 to x1 do
        SetPix(x,round(y2+(x-x2)*(y1-y2)/(x1-x2)));
  end else
  begin
    if y1 < y2 then
      for y:=y1 to y2 do
        SetPix(round(x1+(y-y1)*(x2-x1)/(y2-y1)),y) else
      for y:=y2 to y1 do
        SetPix(round(x2+(y-y2)*(x1-x2)/(y1-y2)),y);
  end;
  aCanvas.moveto(x2,y2);
end;
*)

procedure DrawPlus(aCanvas: TCanvas; x,y,size: integer);
begin
  with aCanvas do
  begin
    moveto(x-size,y);
    lineto(x+size+1,y);
    moveto(x,y-size);
    lineto(x,y+size+1);
  end;
end;

procedure DrawX(aCanvas: TCanvas; x,y,size: integer);
begin
  with aCanvas do
  begin
    moveto(x-size,y-size);
    lineto(x+size+1,y+size+1);
    moveto(x+size,y-size);
    lineto(x-size-1,y+size+1);
  end;
end;

procedure DrawCircleFilled(aCanvas: TCanvas; x,y,size: integer);
var bs: TBrushStyle;
    c: TColor;
begin
  with aCanvas do
  begin
    bs:=Brush.Style;
    c:=Brush.color;
    Brush.Style:=bssolid;
    Brush.color:=pen.color;
    ellipse(x-size,y-size,x+size,y+size);
    Brush.Style:=bs;
    Brush.color:=c;
  end;
end;

procedure DrawCircle(aCanvas: TCanvas; x,y,size: integer);
var bs: TBrushStyle;
begin
  with aCanvas do
  begin
    bs:=Brush.Style;
    Brush.Style:=bsClear;
    ellipse(x-size,y-size,x+size+1,y+size+1);
    Brush.Style:=bs;
  end;
end;

procedure DrawCircleEx(aCanvas: TCanvas; x1,y1,x2,y2: integer);
var bs: TBrushStyle;
begin
  with aCanvas do
  begin
    bs:=Brush.Style;
    Brush.Style:=bsClear;
    ellipse(x1,y1,x2,y2);
    Brush.Style:=bs;
  end;
end;

procedure DrawSquareFilled(aCanvas: TCanvas; x,y,size: integer);
var bs: TBrushStyle;
    c: TColor;
begin
  with aCanvas do
  begin
    bs:=Brush.Style;
    c:=Brush.color;
    Brush.Style:=bssolid;
    Brush.color:=pen.color;
    FillRect(Rect(x-size,y-size,x+size+1,y+size+1));
    Brush.Style:=bs;
    Brush.color:=c;
  end;
end;

procedure DrawSquare(aCanvas: TCanvas; x,y,size: integer);
begin
  with aCanvas do
  begin
    moveto(x-size,y-size);
    lineto(x-size,y+size);
    lineto(x+size,y+size);
    lineto(x+size,y-size);
    lineto(x-size,y-size);
  end;
end;

procedure DrawDiamond(aCanvas: TCanvas; x,y,size: integer);
begin
  with aCanvas do
  begin
    moveto(x-size,y);
    lineto(x,y+size);
    lineto(x+size,y);
    lineto(x,y-size);
    lineto(x-size,y);
  end;
end;

procedure DrawStar(Canvas: TCanvas; cx,cy,r1,r2,ang: single; n: integer);
var i,x,y: integer;
    b,d,e: single;
    Points: array of TPoint;
begin
  with Canvas do
  begin
    setlength(Points,n);
    for i:=0 to N-1 do
      if odd(i) then
        Points[i]:=Point(
          round(cx+r1*sin(ang+i/n*2*pi)),
          round(cy+r1*cos(ang+i/n*2*pi))) else
        Points[i]:=Point(
          round(cx+r2*sin(ang+i/n*2*pi)),
          round(cy+r2*cos(ang+i/n*2*pi)));
    Polygon(Points);
  end;
end;

procedure zigzag(Canvas: TCanvas; x1,y1,x2,y2,w: single; n: integer);
{w is width of folds in pixels}
var i: integer;
    dx,dy: single;
begin
  with Canvas do
  begin
    w:=w/sqrt(sqr(x2-x1)+sqr(y2-y1));
    dx:=(y2-y1)*w;
    dy:=(x1-x2)*w;
    moveto(round(x1),round(y1));
    for i:=1 to n do
      if odd(i) then
        lineto(round((x2-x1)*i/n+x1+dx),round((y2-y1)*i/n+y1+dy)) else
        lineto(round((x2-x1)*i/n+x1),round((y2-y1)*i/n+y1))
  end;
end;

procedure DrawEllipseTheta(Canvas: TCanvas; cx,cy,major,minor,sinA,cosA: single; DrawAxes: boolean);
var i: integer;
    bx,by,ax,ay: single;
begin
  with canvas do
  begin
    for i:=0 to 50 do
    begin
      ax:=sin(i/50*2*pi)*major;
      ay:=cos(i/50*2*pi)*minor;
      bx:=ax*sinA+ay*cosA + cx;
      by:=ax*cosA-ay*sinA + cy;
      if i = 0 then
        moveto(round(bx),round(by)) else
        lineto(round(bx),round(by));
    end;

    if DrawAxes then
    begin
      moveto(round(cx+minor*cosA),round(cy-minor*sinA));
      lineto(round(cx-minor*cosA),round(cy+minor*sinA));

      moveto(round(cx+major*sinA),round(cy+major*cosA));
      lineto(round(cx-major*sinA),round(cy-major*cosA));
    end;
  end;
end;

procedure DrawSmoothQuadratic(Canvas: TCanvas; p0,p1,p2: TPoint);
var i,n: integer;
var a,b,c,d: TSinglePoint;
    p: TArrayofTSinglePoint;
begin
  with Canvas do
  begin
    a:=SinglePoint(p0.x,p0.y);
    c:=SinglePoint((p0.x+p2.x-2*p1.x)/2,(p0.y+p2.y-2*p1.y)/2);
    b:=SinglePoint((p1.x-c.x-p0.x)*2,(p1.y-c.y-p0.y)*2);
    c:=ScaleVector(c,4/1);
    d:=SinglePoint(0,0);

    p:=CoeffToBezier(a,b,c,d); { x=a+bt+ctt+dttt; t=0..1 }
    PolyBezier([SinglePointToPoint(p[0]),SinglePointToPoint(p[1]),SinglePointToPoint(p[2]),SinglePointToPoint(p[3])]);
  end;
end;

procedure oldDrawSmoothQuadratic(Canvas: TCanvas; p0,p1,p2: TPoint);
  function coord(t: single; a,b,c: TSinglePoint): TPoint;
  begin
    result.x:=round(a.x*t*t+b.x*t+c.x);
    result.y:=round(a.y*t*t+b.y*t+c.y);
  end;
var i,n: integer;
var a,b,c: TSinglePoint;
begin
  with Canvas do
  begin
    c:=SinglePoint(p0.x,p0.y);
    a:=SinglePoint((p0.x+p2.x-2*p1.x)/2,(p0.y+p2.y-2*p1.y)/2);
    b:=SinglePoint(p1.x-a.x-p0.x,p1.y-a.y-p0.y);
    n:=min(max(intmax([abs(p0.x-p1.x),abs(p2.x-p1.x),abs(p0.y-p1.y),abs(p2.y-p1.y)]) div 4,2),20);
    with coord(0,a,b,c) do
      moveto(x,y);
    for i:=1 to 2*n do
      with coord(i/n,a,b,c) do
        lineto(x,y);
    end;
end;

procedure DrawSmoothLine(Canvas: TCanvas; Points: array of TPoint);
  function coord(t: single; a,b,c,d: TSinglePoint): TPoint;
  begin
    result.x:=round(a.x*t*t*T+b.x*t*t+c.x*t+d.x);
    result.y:=round(a.y*t*t*T+b.y*t*t+c.y*t+d.y);
  end;
  procedure DrawCurve(a,b,c,d: TSinglePoint);
  var i: integer;
  begin
    with Canvas do
    begin
      with coord(0,a,b,c,d) do
        moveto(x,y);
      for i:=1 to 20 do
        with coord(i/20,a,b,c,d) do
          lineto(x,y);
    end;
  end;
  procedure DrawCurve4(p1,p2,p3,p4: TPoint);
  var g,h,a,b,c,d: TSinglePoint;
  begin
    with Canvas do
    begin
      g.y:=(p3.y-p1.y)/2;
      h.y:=(p4.y-p2.y)/2;
      a.y:=2*g.y+2*p2.y-g.y-2*p3.y+h.y;
      d.y:=p2.y;
      c.y:=g.y;
      b.y:=3*p3.y-3*p2.y-2*g.y-h.y;

      g.x:=(p3.x-p1.x)/2;
      h.x:=(p4.x-p2.x)/2;
      a.x:=+2*g.x+2*p2.x-g.x-2*p3.x+h.x;
      d.x:=p2.x;
      c.x:=g.x;
      b.x:=3*p3.x-3*p2.x-2*g.x-h.x;

      DrawCurve(a,b,c,d);
    end;
  end;
  procedure DrawCurve3a(p1,p2,p3: TPoint);
  var g,a,b,c,d: TSinglePoint;
  begin
    with Canvas do
    begin
      a.y:=0;
      g.y:=(p3.y-p1.y)/2;
      d.y:=p1.y;
      b.y:=p1.y-p2.y+g.y;
      c.y:=2*p2.y-2*p1.y-g.y;

      a.x:=0;
      g.x:=(p3.x-p1.x)/2;
      d.x:=p1.x;
      b.x:=p1.x-p2.x+g.x;
      c.x:=2*p2.x-2*p1.x-g.x;

      DrawCurve(a,b,c,d);
    end;
  end;
  procedure DrawCurve3b(p1,p2,p3: TPoint);
  var g,a,b,c,d: TSinglePoint;
  begin
    with Canvas do
    begin

      a.y:=0;
      c.y:=(p3.y-p1.y)/2;
      d.y:=p2.y;
      b.y:=p3.y-c.y-d.y;

      a.x:=0;
      c.x:=(p3.x-p1.x)/2;
      d.x:=p2.x;
      b.x:=p3.x-c.x-d.x;

      DrawCurve(a,b,c,d);
    end;
  end;
var i: integer;
begin
  DrawCurve3a(Points[0],Points[1],Points[2]);
  for i:=low(Points)+1 to high(Points)-2 do
    DrawCurve4(Points[i-1],Points[i],Points[i+1],Points[i+2]);
  DrawCurve3b(Points[high(Points)-2],Points[high(Points)-1],Points[high(Points)]);
end;

function UniqueNumber: integer;
const i: integer = 0;
begin
  inc(i);
  result:=i;
end;

procedure BuildCRC32Table;
{you don't need to call this; it calcs the CRC table}
const CRCPOLY = $EDB88320;
var i, j: Word;
    r: DWord;
begin
  {$I-}
  FillChar(CRCTable, SizeOf(CRCTable), 0);
  for i := 0 to 255 do
  begin
    r := i shl 1;
    for j := 8 downto 0 do
      if (r and 1) <> 0 then
        r := (r Shr 1) xor CRCPOLY else
        r := r shr 1;
    CRCTable[i] := r;
   end;
  {$I+}
end;

function CalcCRC32(s: String): dword;
var i: Word;
begin
  result := $ffffffff;
  {$I-}
  for i := 1 to length(s) do
    result := (result shr 8) xor CRCTable[ord(s[i]) xor (result and $000000FF)];
  {$I+}
  result := not result;
end;

function CalcCRC32b(s: String): dword;
var CRC32: array[0..3] of byte absolute result;
    temp: byte;
  procedure clcCRC32b(w: byte);
  begin
    w:=w xor CRC32[0];                  {xorwf	crc_lo,w}
    temp:=w;                            {movwf	temp}
    // low byte
    W:=CRC32[1];
    if (temp and BitValue[0]) <> 0 then {btfsc	temp,0}
      w:=w xor $96;                     {xorlw	0x96}
    if (temp and BitValue[1]) <> 0 then {btfsc	temp,1}
      w:=w xor $2c;                     {xorlw	0x2c}
    if (temp and BitValue[2]) <> 0 then {btfsc	temp,2}
      w:=w xor $19;                     {xorlw	0x19}
    if (temp and BitValue[3]) <> 0 then {btfsc	temp,3}
      w:=w xor $32;                     {xorlw	0x32}
    if (temp and BitValue[4]) <> 0 then {btfsc	temp,4}
      w:=w xor $64;                     {xorlw	0x64}
    if (temp and BitValue[5]) <> 0 then {btfsc	temp,5}
      w:=w xor $c8;                     {xorlw	0xc8}
    if (temp and BitValue[6]) <> 0 then {btfsc	temp,6}
      w:=w xor $90;                     {xorlw	0x90}
    if (temp and BitValue[7]) <> 0 then {btfsc	temp,7}
      w:=w xor $20;                     {xorlw	0x20}
    CRC32[0]:=w;                        {movwf	crc_lo}
    // mid-low byte
    W:=CRC32[2];
    if (temp and BitValue[0]) <> 0 then {btfsc	temp,0}
      w:=w xor $30;                     {xorlw	0x30}
    if (temp and BitValue[1]) <> 0 then {btfsc	temp,1}
      w:=w xor $61;                     {xorlw	0x61}
    if (temp and BitValue[2]) <> 0 then {btfsc	temp,2}
      w:=w xor $c4;                     {xorlw	0xc4}
    if (temp and BitValue[3]) <> 0 then {btfsc	temp,3}
      w:=w xor $88;                     {xorlw	0x88}
    if (temp and BitValue[4]) <> 0 then {btfsc	temp,4}
      w:=w xor $10;                     {xorlw	0x10}
    if (temp and BitValue[5]) <> 0 then {btfsc	temp,5}
      w:=w xor $20;                     {xorlw	0x20}
    if (temp and BitValue[6]) <> 0 then {btfsc	temp,6}
      w:=w xor $41;                     {xorlw	0x41}
    if (temp and BitValue[7]) <> 0 then {btfsc	temp,7}
      w:=w xor $83;                     {xorlw	0x83}
    CRC32[1]:=w;                        {movwf	crc_ml}
    // mid-high byte
    W:=CRC32[3];
    if (temp and BitValue[0]) <> 0 then {btfsc	temp,0}
      w:=w xor $07;                     {xorlw	0x07}
    if (temp and BitValue[1]) <> 0 then {btfsc	temp,1}
      w:=w xor $0e;                     {xorlw	0x0e}
    if (temp and BitValue[2]) <> 0 then {btfsc	temp,2}
      w:=w xor $6d;                     {xorlw	0x6d}
    if (temp and BitValue[3]) <> 0 then {btfsc	temp,3}
      w:=w xor $db;                     {xorlw	0xdb}
    if (temp and BitValue[4]) <> 0 then {btfsc	temp,4}
      w:=w xor $b7;                     {xorlw	0xb7}
    if (temp and BitValue[5]) <> 0 then {btfsc	temp,5}
      w:=w xor $6e;                     {xorlw	0x6e}
    if (temp and BitValue[6]) <> 0 then {btfsc	temp,6}
      w:=w xor $dc;                     {xorlw	0xdc}
    if (temp and BitValue[7]) <> 0 then {btfsc	temp,7}
      w:=w xor $b8;                     {xorlw	0xb8}
    CRC32[2]:=w;                        {movwf	crc_mh}
    // hi byte                          {; hi byte}
    w:=0;                               {clrw}
    if (temp and BitValue[0]) <> 0 then {btfsc	temp,0}
      w:=w xor $77;                     {xorlw	0x77}
    if (temp and BitValue[1]) <> 0 then {btfsc	temp,1}
      w:=w xor $ee;                     {xorlw	0xee}
    if (temp and BitValue[2]) <> 0 then {btfsc	temp,2}
      w:=w xor $07;                     {xorlw	0x07}
    if (temp and BitValue[3]) <> 0 then {btfsc	temp,3}
      w:=w xor $0e;                     {xorlw	0x0e}
    if (temp and BitValue[4]) <> 0 then {btfsc	temp,4}
      w:=w xor $1d;                     {xorlw	0x1d}
    if (temp and BitValue[5]) <> 0 then {btfsc	temp,5}
      w:=w xor $3b;                     {xorlw	0x3b}
    if (temp and BitValue[6]) <> 0 then {btfsc	temp,6}
      w:=w xor $76;                     {xorlw	0x76}
    if (temp and BitValue[7]) <> 0 then {btfsc	temp,7}
      w:=w xor $ed;                     {xorlw	0xed}
    CRC32[3]:=w;                        {movwf	crc_hi}
  end;
var i: Word;
begin
  CRC32[0]:=$FF;
  CRC32[1]:=$FF;
  CRC32[2]:=$FF;
  CRC32[3]:=$FF;
  for i:=1 to length(s) do
    clcCRC32b(ord(s[i]));

  CRC32[0]:=CRC32[0] xor $FF;
  CRC32[1]:=CRC32[1] xor $FF;
  CRC32[2]:=CRC32[2] xor $FF;
  CRC32[3]:=CRC32[3] xor $FF;

//  result:=CRC32[0]+(CRC32[1] shl 8)+(CRC32[2] shl 8)+(CRC32[3] shl 8);
end;

function CalcCRC32c(s: String): dword;
var CRC32: array[0..3] of byte absolute result;
    tempCRC: byte;
  procedure clcCRC32b(w: byte);
  begin
    w:=w xor CRC32[0];                     {xorwf	crc_lo,w}
    tempCRC:=w;                            {movwf	tempCRC}
    // low byte
    w:=CRC32[1];
    if (tempCRC and BitValue[0]) = 0 then  {btfss	tempCRC,0}
      w:=w xor $96;                        {xorlw	0x96}
    if (tempCRC and BitValue[1]) = 0 then  {btfss	tempCRC,1}
      w:=w xor $2c;                        {xorlw	0x2c}
    if (tempCRC and BitValue[2]) = 0 then  {btfss	tempCRC,2}
      w:=w xor $19;                        {xorlw	0x19}
    if (tempCRC and BitValue[3]) = 0 then  {btfss	tempCRC,3}
      w:=w xor $32;                        {xorlw	0x32}
    if (tempCRC and BitValue[4]) = 0 then  {btfss	tempCRC,4}
      w:=w xor $64;                        {xorlw	0x64}
    if (tempCRC and BitValue[5]) = 0 then  {btfss	tempCRC,5}
      w:=w xor $c8;                        {xorlw	0xc8}
    if (tempCRC and BitValue[6]) = 0 then  {btfss	tempCRC,6}
      w:=w xor $90;                        {xorlw	0x90}
    if (tempCRC and BitValue[7]) = 0 then  {btfss	tempCRC,7}
      w:=w xor $20;                        {xorlw	0x20}
    CRC32[0]:=w;                           {movwf	crc_lo}
    // mid-low byte
    w:=CRC32[2];
    if (tempCRC and BitValue[0]) = 0 then  {btfss	tempCRC,0}
      w:=w xor $30;                        {xorlw	0x30}
    if (tempCRC and BitValue[1]) = 0 then  {btfss	tempCRC,1}
      w:=w xor $61;                        {xorlw	0x61}
    if (tempCRC and BitValue[2]) = 0 then  {btfss	tempCRC,2}
      w:=w xor $c4;                        {xorlw	0xc4}
    if (tempCRC and BitValue[3]) = 0 then  {btfss	tempCRC,3}
      w:=w xor $88;                        {xorlw	0x88}
    if (tempCRC and BitValue[4]) = 0 then  {btfss	tempCRC,4}
      w:=w xor $10;                        {xorlw	0x10}
    if (tempCRC and BitValue[5]) = 0 then  {btfss	tempCRC,5}
      w:=w xor $20;                        {xorlw	0x20}
    if (tempCRC and BitValue[6]) = 0 then  {btfss	tempCRC,6}
      w:=w xor $41;                        {xorlw	0x41}
    if (tempCRC and BitValue[7]) = 0 then  {btfss	tempCRC,7}
      w:=w xor $83;                        {xorlw	0x83}
    CRC32[1]:=w;                           {movwf	crc_ml}
    // mid-high byte
    w:=CRC32[3];
    if (tempCRC and BitValue[0]) = 0 then  {btfss	tempCRC,0}
      w:=w xor $07;                        {xorlw	0x07}
    if (tempCRC and BitValue[1]) = 0 then  {btfss	tempCRC,1}
      w:=w xor $0e;                        {xorlw	0x0e}
    if (tempCRC and BitValue[2]) = 0 then  {btfss	tempCRC,2}
      w:=w xor $6d;                        {xorlw	0x6d}
    if (tempCRC and BitValue[3]) = 0 then  {btfss	tempCRC,3}
      w:=w xor $db;                        {xorlw	0xdb}
    if (tempCRC and BitValue[4]) = 0 then  {btfss	tempCRC,4}
      w:=w xor $b7;                        {xorlw	0xb7}
    if (tempCRC and BitValue[5]) = 0 then  {btfss	tempCRC,5}
      w:=w xor $6e;                        {xorlw	0x6e}
    if (tempCRC and BitValue[6]) = 0 then  {btfss	tempCRC,6}
      w:=w xor $dc;                        {xorlw	0xdc}
    if (tempCRC and BitValue[7]) = 0 then  {btfss	tempCRC,7}
      w:=w xor $b8;                        {xorlw	0xb8}
    CRC32[2]:=w;                           {movwf	crc_mh}
    // hi byte                             {; hi byte}
    w:=$FF;
    if (tempCRC and BitValue[0]) = 0 then  {btfss	tempCRC,0}
      w:=w xor $77;                        {xorlw	0x77}
    if (tempCRC and BitValue[1]) = 0 then  {btfss	tempCRC,1}
      w:=w xor $ee;                        {xorlw	0xee}
    if (tempCRC and BitValue[2]) = 0 then  {btfss	tempCRC,2}
      w:=w xor $07;                        {xorlw	0x07}
    if (tempCRC and BitValue[3]) = 0 then  {btfss	tempCRC,3}
      w:=w xor $0e;                        {xorlw	0x0e}
    if (tempCRC and BitValue[4]) = 0 then  {btfss	tempCRC,4}
      w:=w xor $1d;                        {xorlw	0x1d}
    if (tempCRC and BitValue[5]) = 0 then  {btfss	tempCRC,5}
      w:=w xor $3b;                        {xorlw	0x3b}
    if (tempCRC and BitValue[6]) = 0 then  {btfss	tempCRC,6}
      w:=w xor $76;                        {xorlw	0x76}
    if (tempCRC and BitValue[7]) = 0 then  {btfss	tempCRC,7}
      w:=w xor $ed;                        {xorlw	0xed}
    CRC32[3]:=w;                           {movwf	crc_hi}
  end;
var i: Word;
begin
  CRC32[0]:=0;
  CRC32[1]:=0;
  CRC32[2]:=0;
  CRC32[3]:=0;
  for i:=1 to length(s) do
    clcCRC32b(ord(s[i]));
end;

function CalcCRC16(s: string): word;
var i,j: integer;
begin
  result:=$FFFF;
  for i:=1 to length(s) do
  begin
    result:=result xor ord(s[i]);
    for j:=0 to 7 do
    begin
      if odd(result) then
        result:=(result shr 1) xor $8408 else
        result:=(result shr 1);
    end;
  end;
end;

function StrToBool(const S: string): Boolean;
begin
  if comparetext(s,'true') = 0 then result:=true else
  if comparetext(s,'false') = 0 then result:=false else
    raise Exception.Create('Boolean value expected');
end;

function StrToBoolDef(const S: string; Default: boolean): boolean;
begin
  if comparetext(s,'true') = 0 then result:=true else
  if comparetext(s,'false') = 0 then result:=false else
    result:=Default;
end;

function StrToAlignDef(const S: string; Default: TAlign): TAlign;
begin
  if comparetext(s,'alNone') = 0 then result:=alNone else
  if comparetext(s,'alTop') = 0 then result:=alTop else
  if comparetext(s,'alBottom') = 0 then result:=alBottom else
  if comparetext(s,'alLeft') = 0 then result:=alLeft else
  if comparetext(s,'alRight') = 0 then result:=alRight else
  if comparetext(s,'alClient') = 0 then result:=alClient else
    result:=Default;
end;

function StrToAlignmentDef(const S: string; Default: TAlignment): TAlignment;
begin
  if comparetext(s,'taLeftJustify') = 0 then result:=taLeftJustify else
  if comparetext(s,'taCenter') = 0 then result:=taCenter else
  if comparetext(s,'taRightJustify') = 0 then result:=taRightJustify else
    result:=Default;
end;

function StrToPanelBevelDef(const S: string; Default: TPanelBevel): TPanelBevel;
begin
  if comparetext(s,'bvNone') = 0 then result:=bvNone else
  if comparetext(s,'bvLowered') = 0 then result:=bvLowered else
  if comparetext(s,'bvRaised') = 0 then result:=bvRaised else
    result:=Default;
end;

function IncDecSuffix(s,separator: string; d: integer): string;
var i: integer;
begin
  result:=Before(s,separator);
  s:=After(s,separator);
  while pos(separator,s) > 0 do
  begin
    result:=result+separator+Before(s,separator);
    s:=After(s,separator);
  end;
  i:=StrToIntDef(S,-maxint);
  if i = -maxint then
  begin
    if s <> '' then
      result:=result+separator;
    result:=result+s;
    i:=1;
  end else
    inc(i,d);
  result:=result+separator+inttostr(i);
end;

function IncrementSuffix(s,separator: string): string;
begin
  result:=IncDecSuffix(s,separator,+1);
end;

function DecrementSuffix(s,separator: string): string;
begin
  result:=IncDecSuffix(s,separator,-1);
end;

function RemoveTrailingDigits(s: string): string;
begin
  while (s <> '') and digit(s[length(s)]) do
    delete(s,length(s),1);
  result:=s;
end;

procedure Extend(p1,p2: TSinglePoint; l: single; var ans: TSinglePoint);
var p: single;
begin
  p:=l/Dist(p1,p2);
  ans.x:=p*(p2.x-p1.x)+p1.x;
  ans.y:=p*(p2.y-p1.y)+p1.y;
end;

function DistPoints(p2,p4: TPoint): single;
begin
  result:=Pythag(p2.x-p4.x,p2.y-p4.y);
end;

function Dist(p2,p4: TSinglePoint): single;
begin
  result:=Pythag(p2.x-p4.x,p2.y-p4.y);
end;

function LengthVector(p: TSinglePoint): single;
begin
  result:=Pythag(p.x,p.y);
end;

function SinglePoint(x,y: Single): TSinglePoint;
begin
  result.x:=x;
  result.y:=y;
end;

function a3DPoint(x,y,z: Single): T3DPoint;
begin
  result.x:=x;
  result.y:=y;
  result.z:=z;
end;

function Int3DPoint(x,y,z: integer): TInt3DPoint;
begin
  result.x:=x;
  result.y:=y;
  result.z:=z;
end;

function Normalise3D(nrm: T3DPoint): T3DPoint;
var l: single;
begin
  l:=Pythag3d(nrm.x,nrm.y,nrm.z);
  if l = 0 then
    result:=Zero3DPoint else
    result:=Scale3D(nrm,1/l);
end;

function CrossProduct3D(left,right: T3DPoint): T3DPoint;
begin
  result.x :=(left.y * right.z) -(left.z * right.y);
  result.y :=(left.z * right.x) -(left.x * right.z);
  result.z :=(left.x * right.y) -(left.y * right.x);
end;

function DotProduct3D(a,b: T3DPoint): single;
begin
  result:=a.x*b.x+a.y*b.y+a.z*b.z;
end;

function Transform3D(origin,u,v,w,p: T3DPoint): T3DPoint;
{ transform point p from x,y,z cood system to uvw coord system }
{ 3 axes from origin->u, origin->v, origin->w }
{ u,v,w are normalised and at rt-ang }
{ p transformed to uvw coord system }
begin
//  p:=Sub3D(p,origin);
  result:=a3DPoint(
    DotProduct3D(p,u),
    DotProduct3D(p,v),
    DotProduct3D(p,w));
  result:=Add3D(result,origin);
end;

function UnTransform3D(origin,u,v,w,p: T3DPoint): T3DPoint;
begin
  p:=Sub3D(p,origin);
  result:=Transform3D(Zero3DPoint,
    a3DPoint(u.x,v.x,w.x),
    a3DPoint(u.y,v.y,w.y),
    a3DPoint(u.z,v.z,w.z),p);
//  result:=Add3D(result,origin);
end;

function Scale3D(a: T3DPoint; b: single): T3DPoint;
begin
  try
    result.x:=a.x*b;
    result.y:=a.y*b;
    result.z:=a.z*b;
  except
    result.x:=1000;
    result.y:=1000;
    result.z:=1000;
  end;
end;

function Sub3D(a,b: T3DPoint): T3DPoint;
begin
  result.x:=a.x-b.x;
  result.y:=a.y-b.y;
  result.z:=a.z-b.z;
end;

function Dist3D(a,b: T3DPoint): Single;
begin
  with Sub3D(a,b) do
    result:=Pythag3d(x,y,z);
end;

function Length3D(a: T3DPoint): Single;
begin
  result:=Pythag3d(a.x,a.y,a.z);
end;

function MeanPoint3D(p: array of T3DPoint): T3DPoint;
var i: integer;
begin
  result:=p[0];
  for i:=low(p)+1 to high(p) do
  begin
    result.x:=result.x+p[i].x;
    result.y:=result.y+p[i].y;
    result.z:=result.z+p[i].z;
  end;
  result.x:=result.x/length(p);
  result.y:=result.y/length(p);
  result.z:=result.z/length(p);
end;

procedure DrawPoly3D(Canvas: TCanvas; p: array of T3DPoint);
var d: single;
    a: array[0..100] of TPoint;
    i: integer;
begin
  for i:=low(p) to high(p) do
    a[i]:=SinglePointToPoint(Project3D(p[i].x,p[i].y,p[i].z));

  if side(a[1].x,a[1].y,a[2].x,a[2].y,a[3].x,a[3].y) > 0 then
  with Canvas do
    Polygon(Slice(a,high(p)+1));
end;

procedure DrawBlock3D(Canvas: TCanvas; t,b,w,e,n,s: single);
var nnet,enet,nnwt,wnwt,sset,eset,sswt,wswt,nneb,eneb,nnwb,wnwb,sseb,eseb,sswb,wswb: T3DPoint;
    q: single;
begin
  nnwb:=a3DPoint(n,(e+3*w)/6,b);
  wnwb:=a3DPoint((s+3*n)/6,w,b);
  nneb:=a3DPoint(n,(w+3*e)/6,b);
  eneb:=a3DPoint((s+3*n)/6,e,b);
  sswb:=a3DPoint(s,(e+3*w)/6,b);
  wswb:=a3DPoint((n+3*s)/6,w,b);
  sseb:=a3DPoint(s,(w+3*e)/6,b);
  eseb:=a3DPoint((n+3*s)/6,e,b);

  q:=(n+s)/2*0.3+n*(1-0.3);
  s:=(n+s)/2*0.3+s*(1-0.3);
  n:=q;

  q:=(e+w)/2*0.3+e*(1-0.3);
  w:=(e+w)/2*0.3+w*(1-0.3);
  e:=q;

  nnwt:=a3DPoint(n,(e+3*w)/6,t); 
  wnwt:=a3DPoint((s+3*n)/6,w,t);
  nnet:=a3DPoint(n,(w+3*e)/6,t);
  enet:=a3DPoint((s+3*n)/6,e,t);
  sswt:=a3DPoint(s,(e+3*w)/6,t);
  wswt:=a3DPoint((n+3*s)/6,w,t);
  sset:=a3DPoint(s,(w+3*e)/6,t);
  eset:=a3DPoint((n+3*s)/6,e,t);

  with nnwt do z:=(z-b)- 0.5*(t-b)*(x-n)/(s-n) +b;
  with wnwt do z:=(z-b)- 0.5*(t-b)*(x-n)/(s-n) +b;
  with nnet do z:=(z-b)- 0.5*(t-b)*(x-n)/(s-n) +b;
  with enet do z:=(z-b)- 0.5*(t-b)*(x-n)/(s-n) +b;
  with sswt do z:=(z-b)- 0.5*(t-b)*(x-n)/(s-n) +b;
  with wswt do z:=(z-b)- 0.5*(t-b)*(x-n)/(s-n) +b;
  with sset do z:=(z-b)- 0.5*(t-b)*(x-n)/(s-n) +b;
  with eset do z:=(z-b)- 0.5*(t-b)*(x-n)/(s-n) +b;

  DrawPoly3D(Canvas,[nnwt,nnet,nneb,nnwb]);
  DrawPoly3D(Canvas,[nnet,enet,eneb,nneb]);
  DrawPoly3D(Canvas,[enet,eset,eseb,eneb]);
  DrawPoly3D(Canvas,[eset,sset,sseb,eseb]);
  DrawPoly3D(Canvas,[sset,sswt,sswb,sseb]);
  DrawPoly3D(Canvas,[sswt,wswt,wswb,sswb]);
  DrawPoly3D(Canvas,[wswt,wnwt,wnwb,wswb]);
  DrawPoly3D(Canvas,[wnwt,nnwt,nnwb,wnwb]);

  DrawPoly3D(Canvas,[nnwb,nneb,eneb,eseb,sseb,sswb,wswb,wnwb]);
  DrawPoly3D(Canvas,[nnwt,wnwt,wswt,sswt,sset,eset,enet,nnet]);

{
  DrawPoly3D([a3DPoint(s,e,b), a3DPoint(s,w,b), a3DPoint(n,w,b), a3DPoint(n,e,b)]);
  DrawPoly3D([a3DPoint(n,e,t), a3DPoint(n,w,t), a3DPoint(s,w,t), a3DPoint(s,e,t)]);
  DrawPoly3D([a3DPoint(n,e,b), a3DPoint(n,w,b), a3DPoint(n,w,t), a3DPoint(n,e,t)]);
  DrawPoly3D([a3DPoint(s,e,t), a3DPoint(s,w,t), a3DPoint(s,w,b), a3DPoint(s,e,b)]);
  DrawPoly3D([a3DPoint(n,e,b), a3DPoint(n,e,t), a3DPoint(s,e,t), a3DPoint(s,e,b)]);
  DrawPoly3D([a3DPoint(s,w,b), a3DPoint(s,w,t), a3DPoint(n,w,t), a3DPoint(n,w,b)]);
}
end;

function Add3D(a,b: T3DPoint): T3DPoint;
begin
  result.x:=a.x+b.x;
  result.y:=a.y+b.y;
  result.z:=a.z+b.z;
end;

function DistPointToLine3D(p,p1,p2: T3DPoint): single;
var d,xy,zx,yz: single;
    v,f,j: T3DPoint;
begin
  v:=CrossProduct3D(sub3d(p,p1),sub3d(p2,p1));
  v:=CrossProduct3D(sub3d(p2,p1),v);
  v:=normalise3d(v);
  d:=DotProduct3D(sub3d(p,p1),v);
  result:=d;
end;

function NearestPointOnLineToPoint3D(p,p1,p2: T3DPoint): T3DPoint;
var t: single;
var q: T3DPoint;
begin
  q:=sub3d(p2,p1);
//  t:=DotProduct3D(sub3d(p,p1),normalise3d(q))/length3D(q);
  t:=(DotProduct3D(q,p)-DotProduct3D(q,p1))/DotProduct3D(q,q);
  result:=Add3D(p1,Scale3D(q,t));
end;

function NearestPointsOnLines3D(a1,a2,b1,b2: T3DPoint; var t,u: single; var j,k: T3DPoint): boolean;
var x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4,
    xp,yp,zp,fp,gp,hp,
    xq,yq,zq,fq,gq,hq,
    apq,aqq,app,
    bpq,bqq,bqp,bpp,
    a,
    xj,yj,zj,
    xk,yk,zk: single;
begin
  x1:=a1.x;  y1:=a1.y;  z1:=a1.z;
  x2:=a2.x;  y2:=a2.y;  z2:=a2.z;
  x3:=b1.x;  y3:=b1.y;  z3:=b1.z;
  x4:=b2.x;  y4:=b2.y;  z4:=b2.z;

  {line p is through points 1,2}
  xp:=x1;
  yp:=y1;
  zp:=z1;
  fp:=(x2-x1);
  gp:=(y2-y1);
  hp:=(z2-z1);

  {line q is through points 3,4}
  xq:=x3;
  yq:=y3;
  zq:=z3;
  fq:=(x4-x3);
  gq:=(y4-y3);
  hq:=(z4-z3);

  apq:=fp*fq + gp*gq + hp*hq;
  aqq:=fq*fq + gq*gq + hq*hq;
  app:=fp*fp + gp*gp + hp*hp;
  bpq:=xp*fq + yp*gq + zp*hq;
  bqp:=xq*fp + yq*gp + zq*hp;
  bqq:=xq*fq + yq*gq + zq*hq;
  bpp:=xp*fp + yp*gp + zp*hp;

  {point j on line p}
  a:=(apq*apq - app*aqq);
  result:=abs(a) > 0.0000001;
  if result then
  begin
    {point j on line p}
    t:=(apq*(bqq-bpq) + aqq*(bpp-bqp))/a;
    xj:=xp+fp*t;
    yj:=yp+gp*t;
    zj:=zp+hp*t;

    {point k on line q}
    u:=(apq*(bpp-bqp) + app*(bqq-bpq))/a;
    xk:=xq+fq*u;
    yk:=yq+gq*u;
    zk:=zq+hq*u;

    j.x:=xj;    j.y:=yj;    j.z:=zj;
    k.x:=xk;    k.y:=yk;    k.z:=zk;
  end;
end;

function FaceNormal3D(vertices: array of T3DPoint): T3DPoint;
var i: integer;
    v: T3DPoint;
begin
  result:=CrossProduct3D(vertices[high(vertices)],vertices[low(vertices)]);
  for i:=low(vertices) to high(vertices)-1 do
    result:=Add3D(result,CrossProduct3D(vertices[i],vertices[i+1]));
  result:=Normalise3D(result);
end;

function FaceCenter3D(vertices: array of T3DPoint): T3DPoint;
var i: integer;
    v: T3DPoint;
begin
  result:=Zero3DPoint;
  for i:=low(vertices) to high(vertices) do
    result:=Add3D(result,vertices[i]);
  result:=Scale3D(result,1/(high(vertices)+1));
end;

function ColorToSilver(col: TColor; Invert: boolean): TColor;
begin
  result:=(Red(col)+Green(col)+Blue(col));
  if Invert then
    result:=3*$FF - result;
  case result of
    0..$FF:        result:=clBlack;
    $100..$1FF:    result:=clGray;
    $200..3*$FF-1: result:=clSilver;
    else           result:=clWhite;
  end;
end;

function GradeColor(col,bg: TColor; a: single): TColor;
begin
  result:=ClipRGB(
    round(Red(bg)+(Red(col)-Red(bg))*a),
    round(Green(bg)+(Green(col)-Green(bg))*a),
    round(Blue(bg)+(Blue(col)-Blue(bg))*a));
end;

function ContrastColor(col: TColor): TColor;
begin
    if ColorToGrey(Col) and 255 >= 96 then
      result:=clBlack else
      result:=clWhite;
end;

procedure Meet(p1,p2: TSinglePoint; l1,l2: single; var ans: TSinglePoint);
var i: integer;
begin
  for i:=1 to 1000 do
  begin
    extend(p1,ans,l1,ans);
    extend(p2,ans,l2,ans);
    if abs(Dist(p1,ans)-l1) < 0.1 then
      exit;
  end;
end;

function LinesCrossNoClipI(xk,yk,xl,yl,xm,ym,xn,yn: integer; var xa,ya: integer): boolean;
{returns true if lines cross anywhere}
var det,s,t: single;
    xlk,ylk,xnm,ynm,xmk,ymk: integer;
begin
  xlk:=xl-xk;
  ylk:=yl-yk;
  xnm:=xn-xm;
  ynm:=yn-ym;
  xmk:=xm-xk;
  ymk:=ym-yk;
  det:=xnm*ylk-ynm*xlk;
  if abs(det) < 0.00000001*sqr(abs(xlk)+abs(ylk)+abs(xnm)+abs(ynm)) then
  begin {parallel}
    s:=maxint;
    t:=maxint;
    result:=false;
  end else
  begin
    det:=1/det;
    s:=(xnm*ymk-ynm*xmk)*det;
    t:=(xlk*ymk-ylk*xmk)*det;
    xa:=round(xk+xlk*s);
    ya:=round(yk+ylk*s);
    result:=true;
  end;
end;

function LinesCrossNoClip(xk,yk,xl,yl,xm,ym,xn,yn: Double; var xa,ya,s,t: Double): boolean;
{returns true if lines cross anywhere}
var det,xlk,ylk,xnm,ynm,xmk,ymk: double;
begin
  xlk:=xl-xk;
  ylk:=yl-yk;
  xnm:=xn-xm;
  ynm:=yn-ym;
  xmk:=xm-xk;
  ymk:=ym-yk;
  det:=xnm*ylk-ynm*xlk;
  if abs(det) <= 0.00000001*sqr(abs(xlk)+abs(ylk)+abs(xnm)+abs(ynm)) then
  begin {parallel}
    s:=maxint;
    t:=maxint;
    result:=false;
  end else
  begin
    det:=1/det;
    s:=(xnm*ymk-ynm*xmk)*det;
    t:=(xlk*ymk-ylk*xmk)*det;
    xa:=xk+xlk*s;
    ya:=yk+ylk*s;
    result:=true;
  end;
end;

function LinesCrossSP(k,l,m,n: TSinglePoint; var a: TSinglePoint): boolean;
var bx,by: double;
    s,t: Double;
begin
  result:=LinesCross(k.x,k.y,l.x,l.y,m.x,m.y,n.x,n.y,bx,by,s,t);
  if result then
    a:=SinglePoint(bx,by);
end;

function LinesCrossTP(k,l,m,n: TPoint; var a: TPoint): boolean;
var bx,by: double;
    s,t: Double;
begin
  result:=LinesCross(k.x,k.y,l.x,l.y,m.x,m.y,n.x,n.y,bx,by,s,t);
  if result then
    a:=Point(round(bx),round(by));
end;

function LinesCrossNoClipTP(k,l,m,n: TPoint; var a: TPoint): boolean;
begin
  result:=LinesCrossNoClipI(k.x,k.y,l.x,l.y,m.x,m.y,n.x,n.y,a.x,a.y);
end;

function LinesCrossNoClipSP(k,l,m,n: TSinglePoint; var a: TSinglePoint; var s,t: Double): boolean;
var ax,ay: Double;
begin
  result:=LinesCrossNoClip(k.x,k.y,l.x,l.y,m.x,m.y,n.x,n.y,ax,ay,s,t);
  if result then
  begin
    a.x:=ax;
    a.y:=ay;
  end;
end;

function bLinesCross(xk,yk,xl,yl,xm,ym,xn,yn: Double): boolean;
var s,t: Double;
var det,xlk,ylk,xnm,ynm,xmk,ymk: double;
begin
  xlk:=xl-xk;
  ylk:=yl-yk;
  xnm:=xn-xm;
  ynm:=yn-ym;
  xmk:=xm-xk;
  ymk:=ym-yk;
  det:=xnm*ylk-ynm*xlk;
  s:=(xnm*ymk-ynm*xmk);
  t:=(xlk*ymk-ylk*xmk);
  if det < 0 then
    result:=InRealRange(s,det,0) and InRealRange(t,det,0) else
    result:=InRealRange(s,0,det) and InRealRange(t,0,det);
end;

function LinesCross(xk,yk,xl,yl,xm,ym,xn,yn: Double; var xa,ya,s,t: Double): boolean;
{returns true if lines cross in range of (xk,yk..xl,yl) and (xm,ym..xn,yn)}
var xb,yb: Double;
begin
  if LinesCrossNoClip(xk,yk,xl,yl,xm,ym,xn,yn,xb,yb,s,t) then
  begin
    result:=InRealRange(s,0,1) and InRealRange(t,0,1);
    if result then
    begin
      xa:=xb;
      ya:=yb;
    end;
  end else
    result:=false;
end;

function EqSinglePoints(p1,p2: TSinglePoint; delta: single): boolean;
begin
  result:=(abs(p1.x-p2.x) < delta) and (abs(p1.y-p2.y) < delta);
end;

function EqPoints(p1,p2: TPoint): boolean;
begin
  result:=(p1.x = p2.x) and (p1.y = p2.y);
end;

function side(xp,yp,x1,y1,x2,y2: Double): Double;
{which side of line x1,y1,x2,y2 is xp,yp on?}
begin
  side:=(yp-y1)*(x2-x1)-(xp-x1)*(y2-y1);
end;

function sideI(xp,yp,x1,y1,x2,y2: integer): integer;
{which side of line x1,y1,x2,y2 is xp,yp on?}
begin
  sideI:=(yp-y1)*(x2-x1)-(xp-x1)*(y2-y1);
end;

function sidePoint(p,p1,p2: TSinglePoint): Double;
begin
  result:=side(p.x,p.y,p1.x,p1.y,p2.x,p2.y);
end;

function sideTPoint(p,p1,p2: TPoint): integer;
begin
  result:=sideI(p.x,p.y,p1.x,p1.y,p2.x,p2.y);
end;

function PointToSinglePoint(p: TPoint): TSinglePoint;
begin
  result.x:=p.x;
  result.y:=p.y;
end;

function SinglePointToPoint(p: TSinglePoint): TPoint;
begin
  result.x:=round(p.x);
  result.y:=round(p.y);
end;

function IntersectCircles(p1: TSinglePoint; var p2,knee: TSinglePoint; r1,r2,accy: single; side: boolean): integer;
{OK               result:=0}
{OK circles touch result:=1}
{same centre      result:=2}
{too close        result:=3}
{too far apart    result:=4}
var distsq,de2rsq,sumrsq,root,dstinv,sc2,y21,x21,r2sq,r1sq: single;
begin
  r1sq:=r2*r2;
  r2sq:=r1*r1;
  x21:=p1.x-p2.x;
  y21:=p1.y-p2.y;
  distsq:=x21*x21+y21*y21;
  if distsq <= accy then
  begin {same centre}
    result:=2;
    knee.x:=p1.x+r1;
    knee.y:=p1.y;
    p2.x:=p1.x-(r2-r1);
  end else
  begin
    de2rsq:=r2sq-r1sq;
    sumrsq:=r2sq+r1sq;
    root:=2*sumrsq*distsq-distsq*distsq-de2rsq*de2rsq;
    if root <= -accy then
    begin {circles dont intersect}
      if distsq < sqr(r1+r2) then
      begin {too close}
        result:=3;
        distsq:=sqrt(distsq);
        knee.x:=p1.x-(p2.x-p1.x)*(r2-r1)/distsq;
        knee.y:=p1.y-(p2.y-p1.y)*(r2-r1)/distsq;
        p2.x:=p1.x+(p2.x-p1.x)*r1/distsq;
        p2.y:=p1.y+(p2.y-p1.y)*r1/distsq;
      end else
      begin {too far apart}
        result:=4;
        distsq:=sqrt(distsq);
        knee.x:=p1.x+(p2.x-p1.x)*r1/distsq;
        knee.y:=p1.y+(p2.y-p1.y)*r1/distsq;
        p2.x:=p1.x+(p2.x-p1.x)*(r2+r1)/distsq;
        p2.y:=p1.y+(p2.y-p1.y)*(r2+r1)/distsq;
      end;
    end else
    begin
      dstinv:=0.5/distsq;
      sc2:=0.5-de2rsq*dstinv;
      knee.x:=x21*sc2+p2.x;
      knee.y:=y21*sc2+p2.y;
      if root <= accy then
      begin {circles touch at x,y}
        result:=1;
      end else
      begin
        result:=0;
        root:=dstinv*sqrt(root);
        if side then
        begin
          knee.x:=knee.x+y21*root;
          knee.y:=knee.y-x21*root;
        end else
        begin
          knee.x:=knee.x-y21*root;
          knee.y:=knee.y+x21*root;
        end;
      end;
    end;
  end;
end;

function DoubleJoint(p1: TSinglePoint; var p2,knee,ankle: TSinglePoint; r1,r2,r3,accy: single; side1,side2: boolean): integer;
var l: single;
begin
  l:=pythag(p1.x-p2.x,p1.y-p2.y);
  if l > r1+r2+r3 then
  begin
    l:=r2+r3; 
    result:=IntersectCircles(p1,p2,knee,r1,l,accy,side1);
    result:=IntMax([result,IntersectCircles(knee,p2,ankle,r2,r3,accy,side2)]);
  end else
  if r1 > r3 then
  begin
    l:=l*(r2+r1)/(r1+r2+r3);
    result:=IntersectCircles(p1,p2,ankle,l,r3,accy,side2);
    result:=IntMax([result,IntersectCircles(p1,ankle,knee,r1,r2,accy,side1)]);
  end else
  begin
    l:=l*(r2+r3)/(r1+r2+r3);
    result:=IntersectCircles(p1,p2,knee,r1,l,accy,side1);
    result:=IntMax([result,IntersectCircles(knee,p2,ankle,r2,r3,accy,side2)]);
  end;
end;

procedure ProjectInit(cx1,cy1,cz1, wx1,wy1,wz1: single);
begin
  with ProjectRec do
  begin
    vx:=wx1-cx1;
    vy:=wy1-cy1;
    vz:=wz1-cz1;
    uOfs:=0;
    vOfs:=0;
    zoom:=1;

    va:=vx*vx+vy*vy;
    vb:=va+vz*vz;
    vc:=1/sqrt(vb);
    vudist:=sqrt(vb);
    vd:=1/vudist;
  end;
end;

procedure ProjectInitOfs(u,v: single);
begin
  with ProjectRec do
  begin
    uOfs:=u;
    vOfs:=v;
  end;
end;

procedure ProjectInitZoom(zm: single);
begin
  with ProjectRec do
  begin
    zoom:=zm;
  end;
end;

function Project3D(x,y,z: single): TSinglePoint;
var vk,w: single;
begin
  with ProjectRec do
  begin
    w:=(vx*x+vy*y+vz*z)*vd;
    result.x:=(-vy*x+vx*y)*vc;
    result.y:=(-vx*vz*x+vy*vz*y+va*z)*vc*vd;
    vk:=vudist/(vudist-w);
    result.x:=result.x*vk*zoom+uOfs;
    result.y:=result.y*vk*zoom+vOfs;
  end;
end;

function AffineCoeffs(p1,p2,p3,q1,q2,q3: TSinglePoint): TAffineMatrix;
{ points p1,p2,p3 in the new coord system (i.e. after the affine transform)  }
{ are mapped onto                                                      }
{ points q1,q2,q3 in the old coord system (i.e. before the affine transform) }
begin
  result[1].x:=SafeDivide(((q2.y-q1.y)*(p3.x-p1.x)-(q3.y-q1.y)*(p2.x-p1.x)),((q2.y-q1.y)*(q3.x-q1.x)-(q3.y-q1.y)*(q2.x-q1.x)));
  result[2].x:=SafeDivide(((q2.x-q1.x)*(p3.x-p1.x)-(q3.x-q1.x)*(p2.x-p1.x)),((q2.x-q1.x)*(q3.y-q1.y)-(q3.x-q1.x)*(q2.y-q1.y)));
  result[3].x:=p1.x-result[2].x*q1.y-result[1].x*q1.x;
  result[1].y:=SafeDivide(((q2.y-q1.y)*(p3.y-p1.y)-(q3.y-q1.y)*(p2.y-p1.y)),((q2.y-q1.y)*(q3.x-q1.x)-(q3.y-q1.y)*(q2.x-q1.x)));
  result[2].y:=SafeDivide(((q2.x-q1.x)*(p3.y-p1.y)-(q3.x-q1.x)*(p2.y-p1.y)),((q2.x-q1.x)*(q3.y-q1.y)-(q3.x-q1.x)*(q2.y-q1.y)));
  result[3].y:=p1.y-result[1].y*q1.x-result[2].y*q1.y;
end;

function AffineMultiply(m1,m2: TAffineMatrix): TAffineMatrix;
begin
  result[1].x:=m2[1].x*m1[1].x+m2[2].x*m1[1].y;
  result[2].x:=m2[1].x*m1[2].x+m2[2].x*m1[2].y;
  result[3].x:=m2[1].x*m1[3].x+m2[2].x*m1[3].y+m2[3].x;
  result[1].y:=m2[1].y*m1[1].x+m2[2].y*m1[1].y;
  result[2].y:=m2[1].y*m1[2].x+m2[2].y*m1[2].y;
  result[3].y:=m2[1].y*m1[3].x+m2[2].y*m1[3].y+m2[3].y;
end;

function AffineInverse(m: TAffineMatrix): TAffineMatrix;
begin
  result[1].x:=+m[2].y/(m[2].y*m[1].x-m[2].x*m[1].y);
  result[2].x:=-m[2].x/(m[2].y*m[1].x-m[2].x*m[1].y);
  result[1].y:=+m[1].y/(m[1].y*m[2].x-m[1].x*m[2].y);
  result[2].y:=-m[1].x/(m[1].y*m[2].x-m[1].x*m[2].y);
  result[3].x:=-result[1].x*m[3].x-result[2].x*m[3].y;
  result[3].y:=-result[1].y*m[3].x-result[2].y*m[3].y;
end;

function AffineApply(m: TAffineMatrix; p: TSinglePoint): TSinglePoint;
begin
  Result.x:=p.x*m[1].x+p.y*m[2].x+m[3].x;
  Result.y:=p.x*m[1].y+p.y*m[2].y+m[3].y;
end;

function ClockwiseInt2(Points: TArrayofTPoint): integer;
begin
  if AreaInt(Points) > 0 then
    result:=+1 else
  if AreaInt(Points) < 0 then
    result:=-1 else
    result:=0;
end;

function TetrahedronVolume(x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4: single): single;
var det: single;
begin
  x1:=x1-x4;    y1:=y1-y4;    z1:=z1-z4;
  x2:=x2-x4;    y2:=y2-y4;    z2:=z2-z4;
  x3:=x3-x4;    y3:=y3-y4;    z3:=z3-z4;
  det := (x1*y2*z3+y1*z2*x3+z1*x2*y3)-(z1*y2*x3+y1*x2*z3+x1*z2*y3);
  result:=det/6;
end;

function TetrahedronVolumeP(p1,p2,p3,p4: T3DPoint): single;
begin
  result:=TetrahedronVolume(p1.x,p1.y,p1.z,p2.x,p2.y,p2.z,p3.x,p3.y,p3.z,p4.x,p4.y,p4.z);
end;

function AreaQuad3D(p1,p2,p3,p4: T3DPoint): Single;
begin
  result:=Length3D(CrossProduct3D(Sub3D(p1,p3),Sub3D(p2,p4)))/2;
end;

function AreaTriangle3D(p1,p2,p3: T3DPoint): Single;
begin
  result:=Length3D(CrossProduct3D(Sub3D(p1,p2),Sub3D(p1,p3)))/2;
end;

function Area3D(Points: Array of T3DPoint): Single;
{points should form a planar polygon}
var i: integer;
    p: T3DPoint;
begin
  p:=Zero3DPoint;
  for i:=2 to high(Points) do
    p:=Add3D(p,CrossProduct3D(Sub3D(Points[i-2],Points[i-1]),Sub3D(Points[i-2],Points[i])));
  result:=Length3D(p)/2;
end;

function AreaSingle(Points: Array of TSinglePoint): Single;
var i: integer;
begin
  result:=0;
  for i:=low(Points) to high(Points) do
    result:=result+
      (Points[(i+1) mod length(Points)].x-Points[i].x)*
      (Points[(i+1) mod length(Points)].y+Points[i].y);
  result:=result/2;
end;

function ClockwiseSingle2(Points: Array of TSinglePoint): integer;
begin
  if AreaSingle(Points) > 0 then
    result:=+1 else
  if AreaSingle(Points) < 0 then
    result:=-1 else
    result:=0;
end;

function ClockwiseSingle(var Points: Array of TSinglePoint): integer;
begin
  if AreaSingle(Points) > 0 then
    result:=+1 else
  if AreaSingle(Points) < 0 then
    result:=-1 else
    result:=0;
end;

function PolarToCartesian(r,a: single): TSinglePoint;
begin
  result.x:=r*sin(a);
  result.y:=r*cos(a);
end;

procedure AddUnique(Strings: TStrings; s: string; First: boolean);
begin
  if s <> '' then
  with Strings do
  begin
    if IndexOf(s) >= 0 then
      Delete(IndexOf(s));

    if First then
      Insert(0,s) else
      Add(s);
  end;
end;

function GetRichEditRTFStr(RichEdit1: TRichEdit): String;
begin
  result:=GetRichEditRTFStrings(RichEdit1).Text;
end;

procedure SetRichEditRTFStr(RichEdit1: TRichEdit; str: String);
var s: TStringList;
begin
  s:=TStringList.Create;
  s.Text:=str;
  SetRichEditRTFStrings(RichEdit1,s);
  s.Free;
end;

function GetRichEditRTFStrings(RichEdit1: TRichEdit): TStrings;
const StringList: TStringList = nil;
var m: TMemoryStream;
    s: string;
begin
  if StringList = nil then
    StringList:=TStringList.Create;
  try
    m:=TMemoryStream.Create;
    RichEdit1.Lines.SaveToStream(m);
    m.position:=0;
    setlength(s,m.size);
    m.Read(s[1],m.size);
    StringList.Text:=s;
  finally
    m.free;
  end;
  result:=StringList;
end;

procedure SetRichEditRTFStrings(RichEdit1: TRichEdit; strings: TStrings);
var m: TMemoryStream;
begin
  try
    m:=TMemoryStream.Create;
    strings.SaveToStream(m);
    m.position:=0;
    RichEdit1.Lines.LoadFromStream(m);
  finally
    m.free;
  end;
end;

function RTFtoPlain(strings: TStrings; aForm: TForm): TStrings;
{Form sets default attributes}
var RichEdit1: TRichEdit;
const StringList: TStringList = nil;
begin
  if StringList = nil then
    StringList:=TStringList.Create;
  try
    RichEdit1:=TRichEdit.Create(aForm);
    RichEdit1.visible:=false;
    RichEdit1.WordWrap :=false;

    RichEdit1.parent:=aForm;
    SetRichEditRTFStrings(RichEdit1,strings);
    StringList.Assign(RichEdit1.Lines);
    result:=StringList;
  finally
    RichEdit1.free;
  end;
end;

procedure SetStringAssoc(index,value: String; var assoc: String);
begin
  if pos('('+index+'=',assoc) <> 0 then
    assoc:=before(assoc,'('+index+'=')+after(after(assoc,'('+index+'='),')');
  if value <> '' then
    assoc:='('+index+'='+value+')'+assoc;
end;

function GetStringAssoc(index: String; assoc: string): string;
begin
  result:=Before(After(assoc,'('+index+'='),')');
end;

function GetStringAssocIndex(i: integer; var assoc: string): string;
{the first accociation is GetStringAssocIndex(1)}
begin
  result:=Before(StrAfter(assoc,i,'(',false),'=');
end;

function RandomiseName(name: string50): longint;
  var i,n: longint;
  var oldrandseed: longint;
begin
  oldrandseed:=randseed;
  randseed:=12345;
//  randseed:=778245;
  for i:=0 to length(name) do
  begin
    randseed:=randseed xor ord(upcase(name[i]));
    n:=random(maxint);
  end;
  RandomiseName:=abs(randseed);
  randseed:=oldrandseed;
end;

procedure ShowErrorMessage(const APrompt: string);
begin
  MessageDlg(APrompt,mtError,[mbOK],0);
end;

procedure ShowInformationMessage(const APrompt: string);
begin
  MessageDlg(APrompt,mtInformation,[mbOK],0);
end;

procedure ShowWarningMessage(const APrompt: string);
begin
  MessageDlg(APrompt,mtWarning,[mbOK],0);
end;

function YesNoCancelBox(const APrompt: string): TModalResult;
begin
  if pos(Uppercase('Error'),Uppercase(APrompt)) > 0 then
    result:=MessageDlg(APrompt,mtError,        mbYesNoCancel, 0) else
    result:=MessageDlg(APrompt,mtConfirmation, mbYesNoCancel, 0);
end;

function YesNoBox(const APrompt: string): Boolean;
begin
  if pos(Uppercase('Error'),Uppercase(APrompt)) > 0 then
    result:=MessageDlg(APrompt,mtError,        [mbYes,mbNo], 0) = mrYes else
    result:=MessageDlg(APrompt,mtConfirmation, [mbYes,mbNo], 0) = mrYes;
end;

function AreaInt2(Points: TArrayofTPoint): integer;
var i: integer;
begin
  result:=0;
  for i:=low(Points) to high(Points) do
    result:=result+
      (Points[(i+1) mod length(Points)].x-Points[i].x)*
      (Points[(i+1) mod length(Points)].y+Points[i].y);
  result:=result div 2;
end;

function AreaInt(var Points: TArrayofTPoint): integer;
var i: integer;
begin
  result:=0;
  for i:=low(Points) to high(Points) do
    result:=result+
      (Points[(i+1) mod length(Points)].x-Points[i].x)*
      (Points[(i+1) mod length(Points)].y+Points[i].y);
  result:=result div 2;
end;

function AreaInt3(Points: Array of TPoint): integer;
var i: integer;
begin
  result:=0;
  for i:=low(Points) to high(Points) do
    result:=result+
      (Points[(i+1) mod length(Points)].x-Points[i].x)*
      (Points[(i+1) mod length(Points)].y+Points[i].y);
  result:=result div 2;
end;

function ClockwiseInt(var Points: TArrayofTPoint): integer;
begin
  if AreaInt(Points) > 0 then
    result:=+1 else
  if AreaInt(Points) < 0 then
    result:=-1 else
    result:=0;
end;

procedure SortSingle(var a: TArrayofSingle);
var n: integer;
  procedure exchange(i,j: integer);
  var t: Single;
  begin
    t:=a[i];
    a[i]:=a[j];
    a[j]:=t;
  end;
  procedure downheap(v: integer);
  var w: integer;
  begin
    w:=2*v+1;  // first descendant of v
    while (w<n) do
    begin
      if (w+1<n) then   // is there a second descendant?
        if (a[w+1]>a[w]) then
          inc(w);
      // w is the descendant of v with maximum label

      if (a[v]>=a[w]) then exit;  // v has heap property
      // otherwise
      exchange(v, w);  // exchange labels of v and w
      v:=w;    // continue
      w:=2*v+1;
    end;
  end;
  procedure buildheap();
  var v: integer;
  begin
    v:=n div 2-1;
    while v>=0 do
    begin
      downheap (v);
      dec(v);
    end;
  end;
begin
  n:=length(a);
  buildheap();
  while (n>1) do
  begin
    dec(n);
    exchange (0, n);
    downheap (0);
  end;
end;

procedure SwapSingle(var a,b: Single);
var t: Single;
begin
  t:=a;
  a:=b;
  b:=t;
end;

procedure Swap(var a,b: Integer);
var t: integer;
begin
  t:=a;
  a:=b;
  b:=t;
end;

procedure SwapStr(var a,b: String);
var t: String;
begin
  t:=a;
  a:=b;
  b:=t;
end;

procedure SwapObj(var a,b: TObject);
var t: TObject;
begin
  t:=a;
  a:=b;
  b:=t;
end;

procedure SortInteger(var a: Array of Integer);
var n: integer;
  procedure exchange(i,j: integer);
  var t: integer;
  begin
    t:=a[i];
    a[i]:=a[j];
    a[j]:=t;
  end;
  procedure downheap(v: integer);
  var w: integer;
  begin
    w:=2*v+1;  // first descendant of v
    while (w<n) do
    begin
      if (w+1<n) then   // is there a second descendant?
        if (a[w+1]>a[w]) then
          inc(w);
      // w is the descendant of v with maximum label

      if (a[v]>=a[w]) then exit;  // v has heap property
      // otherwise
      exchange(v, w);  // exchange labels of v and w
      v:=w;    // continue
      w:=2*v+1;
    end;
  end;
  procedure buildheap();
  var v: integer;
  begin
    v:=n div 2-1;
    while v>=0 do
    begin
      downheap (v);
      dec(v);
    end;
  end;
begin
  n:=length(a);
  buildheap();
  while (n>1) do
  begin
    dec(n);
    exchange (0, n);
    downheap (0);
  end;
end;

function  calcTheta(target,origin: TPoint):double;
begin
     result:= arctan2((target.y-origin.y),(target.x-origin.x));
end;

function  calcThetaXY(targetx,targety,originx,originy: single):single;
begin
     result:= arctan2((targety-originy),(targetx-originx));
end;

function rotate(theta:double; target,origin: TPoint) : TPoint;
var R: double;
begin
  R:= sqrt(sqr(target.x-origin.x)+sqr(target.y-origin.y));
  result.x:=trunc(R*cos(Theta))+origin.x;
  result.y:=trunc(R*sin(Theta))+origin.y;
end;

function rotateSgl(theta:double; target,origin: TSinglePoint) : TSinglePoint;
begin
  result.x:=(target.x-origin.x)*cos(Theta)-(target.y-origin.y)*sin(Theta)+origin.x;
  result.y:=(target.x-origin.x)*sin(Theta)+(target.y-origin.y)*cos(Theta)+origin.y;
end;

function rotatePt(theta:double; target,origin: TPoint) : TPoint;
begin
  result.x:=round((target.x-origin.x)*cos(Theta)-(target.y-origin.y)*sin(Theta)+origin.x);
  result.y:=round((target.x-origin.x)*sin(Theta)+(target.y-origin.y)*cos(Theta)+origin.y);
end;

procedure rotateXY(theta: single;targetX,targetY,originX,originY:single; var resultX,resultY: single);
var R,ax: double;
begin
  R:= sqrt(sqr(targetx-originx)+sqr(targety-originy));
  ax:=(R*cos(Theta))+originx;
  resulty:=(R*sin(Theta))+originy;
  resultx:=ax;
end;

procedure rotateXY2(theta: single;targetX,targetY,originX,originY:single; var resultX,resultY: single);
var s,c,ax: double;
begin
  s:=sin(Theta);
  c:=cos(Theta);
  ax     :=+(targetx-originx)*c+(targety-originy)*s+originx;
  resulty:=-(targetx-originx)*s+(targety-originy)*c+originy;
  resultx:=ax;
end;

function InputNumberQuery2(const ACaption, APrompt1,APrompt2: string; var aValue1,aValue2: integer; min,max: integer): Boolean;
var fm: TForm;
    Bevel1: TBevel;
    Label1,Label2: TLabel;
    OKBtn: TButton;
    CancelBtn: TButton;
    SpinEdit1,SpinEdit2: TSpinEdit;
begin
  fm:=TForm.Create(nil);
  with fm do
  begin
    BorderStyle:=bsDialog;
    Caption:=ACaption;
    ClientHeight:=153;
    ClientWidth:=216;
    Color:=clBtnFace;
    Position:=poScreenCenter;
    KeyPreview:=True;

    Bevel1:=TBevel.Create(fm);
    with Bevel1 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=8;
      Width:=201;
      Height:=105;
      Shape:=bsFrame;
    end;
    OKBtn:=TButton.Create(fm);
    with OKBtn do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=31;
      Top:=120;
      Width:=75;
      Height:=25;
      Caption:='OK';
      Default:=True;
      ModalResult:=1;
      TabOrder:=0;
    end;
    CancelBtn:=TButton.Create(fm);
    with CancelBtn do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=111;
      Top:=120;
      Width:=75;
      Height:=25;
      Cancel:=True;
      Caption:='Cancel';
      ModalResult:=2;
      TabOrder:=1;
    end;
    SpinEdit1:=TSpinEdit.Create(fm);
    with SpinEdit1 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=40;
      Top:=32;
      Width:=153;
      Height:=22;
      TabOrder:=2;
      MaxValue:=max;
      MinValue:=min;
      Value:=IntRange(aValue1,min,max);
    end;
    Label1:=TLabel.Create(fm);
    with Label1 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=16;
      Top:=16;
      Width:=32;
      Height:=13;
      Caption:=APrompt1;
    end;
    Label2:=TLabel.Create(fm);
    with Label2 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=16;
      Top:=64;
      Width:=32;
      Height:=13;
      Caption:=APrompt2;
    end;
    SpinEdit2:=TSpinEdit.Create(fm);
    with SpinEdit2 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=40;
      Top:=80;
      Width:=153;
      Height:=22;
      MaxValue:=0;
      MinValue:=0;
      TabOrder:=3;
      MaxValue:=max;
      MinValue:=min;
      Value:=IntRange(aValue2,min,max);
    end;
  end;

  result:=fm.ShowModal = mrOK;
  if result then
  begin
    aValue1:=IntRange(SpinEdit1.Value,min,max);
    aValue2:=IntRange(SpinEdit2.Value,min,max);
  end;
  fm.free;
end;

function InputNumberQuery3(const ACaption, APrompt1,APrompt2,APrompt3: string; var aValue1,aValue2,aValue3: integer; min,max: integer): Boolean;
var fm: TForm;
    Bevel1: TBevel;
    Label1,Label2: TLabel;
    OKBtn: TButton;
    CancelBtn: TButton;
    SpinEdit1,SpinEdit2,SpinEdit3: TSpinEdit;
const dy = 48;
begin
  fm:=TForm.Create(nil);
  with fm do
  begin
    BorderStyle:=bsDialog;
    Caption:=ACaption;
    ClientHeight:=153+dy;
    ClientWidth:=216;
    Color:=clBtnFace;
    Position:=poScreenCenter;
    KeyPreview:=True;

    Bevel1:=TBevel.Create(fm);
    with Bevel1 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=8;
      Width:=201;
      Height:=105+dy;
      Shape:=bsFrame;
    end;
    OKBtn:=TButton.Create(fm);
    with OKBtn do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=31;
      Top:=120+dy;
      Width:=75;
      Height:=25;
      Caption:='OK';
      Default:=True;
      ModalResult:=1;
      TabOrder:=0;
    end;
    CancelBtn:=TButton.Create(fm);
    with CancelBtn do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=111;
      Top:=OKBtn.Top;
      Width:=75;
      Height:=25;
      Cancel:=True;
      Caption:='Cancel';
      ModalResult:=2;
      TabOrder:=1;
    end;
    SpinEdit1:=TSpinEdit.Create(fm);
    with SpinEdit1 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=40;
      Top:=32;
      Width:=153;
      Height:=22;
      TabOrder:=2;
      MaxValue:=max;
      MinValue:=min;
      Value:=IntRange(aValue1,min,max);
    end;
    Label1:=TLabel.Create(fm);
    with Label1 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=16;
      Top:=16;
      Width:=32;
      Height:=13;
      Caption:=APrompt1;
    end;
    Label2:=TLabel.Create(fm);
    with Label2 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=16;
      Top:=Label1.Top+dy;
      Width:=32;
      Height:=13;
      Caption:=APrompt2;
    end;
    Label2:=TLabel.Create(fm);
    with Label2 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=16;
      Top:=Label1.Top+dy*2;
      Width:=32;
      Height:=13;
      Caption:=APrompt3;
    end;
    SpinEdit2:=TSpinEdit.Create(fm);
    with SpinEdit2 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=40;
      Top:=SpinEdit1.Top+dy;
      Width:=153;
      Height:=22;
      MaxValue:=0;
      MinValue:=0;
      TabOrder:=3;
      MaxValue:=max;
      MinValue:=min;
      Value:=IntRange(aValue2,min,max);
    end;
    SpinEdit3:=TSpinEdit.Create(fm);
    with SpinEdit3 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=40;
      Top:=SpinEdit1.Top+dy*2;
      Width:=153;
      Height:=22;
      MaxValue:=0;
      MinValue:=0;
      TabOrder:=3;
      MaxValue:=max;
      MinValue:=min;
      Value:=IntRange(aValue3,min,max);
    end;
  end;

  result:=fm.ShowModal = mrOK;
  if result then
  begin
    aValue1:=IntRange(SpinEdit1.Value,min,max);
    aValue2:=IntRange(SpinEdit2.Value,min,max);
    aValue3:=IntRange(SpinEdit3.Value,min,max);
  end;
  fm.free;
end;

function InputNumberQuery4(const ACaption, APrompt1,APrompt2,APrompt3,APrompt4: string; var aValue1,aValue2,aValue3,aValue4: integer; min,max: integer): Boolean;
var fm: TForm;
    Bevel1: TBevel;
    Label1,Label2: TLabel;
    OKBtn: TButton;
    CancelBtn: TButton;
    SpinEdit1,SpinEdit2,SpinEdit3,SpinEdit4: TSpinEdit;
const dy = 48;
begin
  fm:=TForm.Create(nil);
  with fm do
  begin
    BorderStyle:=bsDialog;
    Caption:=ACaption;
    ClientHeight:=153+dy*2;
    ClientWidth:=216;
    Color:=clBtnFace;
    Position:=poScreenCenter;
    KeyPreview:=True;

    Bevel1:=TBevel.Create(fm);
    with Bevel1 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=8;
      Width:=201;
      Height:=105+dy*2;
      Shape:=bsFrame;
    end;
    OKBtn:=TButton.Create(fm);
    with OKBtn do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=31;
      Top:=120+dy*2;
      Width:=75;
      Height:=25;
      Caption:='OK';
      Default:=True;
      ModalResult:=1;
      TabOrder:=0;
    end;
    CancelBtn:=TButton.Create(fm);
    with CancelBtn do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=111;
      Top:=OKBtn.Top;
      Width:=75;
      Height:=25;
      Cancel:=True;
      Caption:='Cancel';
      ModalResult:=2;
      TabOrder:=1;
    end;
    SpinEdit1:=TSpinEdit.Create(fm);
    with SpinEdit1 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=40;
      Top:=32;
      Width:=153;
      Height:=22;
      TabOrder:=2;
      MaxValue:=max;
      MinValue:=min;
      Value:=IntRange(aValue1,min,max);
    end;
    Label1:=TLabel.Create(fm);
    with Label1 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=16;
      Top:=16;
      Width:=32;
      Height:=13;
      Caption:=APrompt1;
    end;
    Label2:=TLabel.Create(fm);
    with Label2 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=16;
      Top:=Label1.Top+dy;
      Width:=32;
      Height:=13;
      Caption:=APrompt2;
    end;
    Label2:=TLabel.Create(fm);
    with Label2 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=16;
      Top:=Label1.Top+dy*2;
      Width:=32;
      Height:=13;
      Caption:=APrompt3;
    end;
    Label2:=TLabel.Create(fm);
    with Label2 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=16;
      Top:=Label1.Top+dy*3;
      Width:=32;
      Height:=13;
      Caption:=APrompt4;
    end;
    SpinEdit2:=TSpinEdit.Create(fm);
    with SpinEdit2 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=40;
      Top:=SpinEdit1.Top+dy;
      Width:=153;
      Height:=22;
      MaxValue:=0;
      MinValue:=0;
      TabOrder:=3;
      MaxValue:=max;
      MinValue:=min;
      Value:=IntRange(aValue2,min,max);
    end;
    SpinEdit3:=TSpinEdit.Create(fm);
    with SpinEdit3 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=40;
      Top:=SpinEdit1.Top+dy*2;
      Width:=153;
      Height:=22;
      MaxValue:=0;
      MinValue:=0;
      TabOrder:=3;
      MaxValue:=max;
      MinValue:=min;
      Value:=IntRange(aValue3,min,max);
    end;
    SpinEdit4:=TSpinEdit.Create(fm);
    with SpinEdit4 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=40;
      Top:=SpinEdit1.Top+dy*3;
      Width:=153;
      Height:=22;
      MaxValue:=0;
      MinValue:=0;
      TabOrder:=3;
      MaxValue:=max;
      MinValue:=min;
      Value:=IntRange(aValue4,min,max);
    end;
  end;

  result:=fm.ShowModal = mrOK;
  if result then
  begin
    aValue1:=IntRange(SpinEdit1.Value,min,max);
    aValue2:=IntRange(SpinEdit2.Value,min,max);
    aValue3:=IntRange(SpinEdit3.Value,min,max);
    aValue4:=IntRange(SpinEdit4.Value,min,max);
  end;
  fm.free;
end;


function InputNumberQuery(const ACaption, APrompt: string; var aValue: integer; min,max: integer): Boolean;
var fm: TForm;
    Bevel1: TBevel;
    Label1: TLabel;
    OKBtn: TButton;
    CancelBtn: TButton;
    SpinEdit1: TSpinEdit;
begin
  fm:=TForm.Create(nil);
  with fm do
  begin
    BorderStyle:=bsDialog;
    Caption:=ACaption;
    ClientHeight:=105;
    ClientWidth:=168;
    Color:=clBtnFace;
    Position:=poScreenCenter;
    KeyPreview:=True;

    Bevel1:=TBevel.Create(fm);
    with Bevel1 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=8;
      Width:=153;
      Height:=57;
      Shape:=bsFrame;
    end;
    Label1:=TLabel.Create(fm);
    with Label1 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=16;
      Top:=16;
      Width:=40;
      Height:=13;
      Caption:=APrompt;
    end;
    SpinEdit1:=TSpinEdit.Create(fm);
    with SpinEdit1 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=24;
      Top:=32;
      Width:=129;
      Height:=22;
      MaxValue:=max;
      MinValue:=min;
      Value:=IntRange(aValue,min,max);
      TabOrder:=0;
    end;
    OKBtn:=TButton.Create(fm);
    with OKBtn do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=72;
      Width:=73;
      Height:=25;
      Caption:='OK';
      Default:=True;
      ModalResult:=mrOK;
      TabOrder:=1;
    end;
    CancelBtn:=TButton.Create(fm);
    with CancelBtn do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=88;
      Top:=72;
      Width:=73;
      Height:=25;
      Cancel:=True;
      Caption:='Cancel';
      ModalResult:=mrCancel;
      TabOrder:=2;
    end;
  end;

  result:=fm.ShowModal = mrOK;
  if result then
    aValue:=IntRange(SpinEdit1.Value,min,max);
  fm.free;
end;

function InputNumberYesNoCancel(const ACaption, APrompt: string; var aValue: integer; min,max: integer): TModalResult;
var fm: TForm;
    Bevel1: TBevel;
    Label1: TLabel;
    OKBtn: TButton;
    CancelBtn: TButton;
    SpinEdit1: TSpinEdit;
begin
  fm:=TForm.Create(nil);
  with fm do
  begin
    BorderStyle:=bsDialog;
    Caption:=ACaption;
    ClientHeight:=105;
    ClientWidth:=168;
    Color:=clBtnFace;
    Position:=poScreenCenter;
    KeyPreview:=True;

    Bevel1:=TBevel.Create(fm);
    with Bevel1 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=8;
      Width:=153;
      Height:=57;
      Shape:=bsFrame;
    end;
    Label1:=TLabel.Create(fm);
    with Label1 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=16;
      Top:=16;
      Width:=40;
      Height:=13;
      Caption:=APrompt;
    end;
    SpinEdit1:=TSpinEdit.Create(fm);
    with SpinEdit1 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=24;
      Top:=32;
      Width:=129;
      Height:=22;
      MaxValue:=max;
      MinValue:=min;
      Value:=IntRange(aValue,min,max);
      TabOrder:=0;
    end;
    with TButton.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=72;
      Width:=73;
      Height:=25;
      Caption:='Yes';
      Default:=True;
      ModalResult:=mrYes;
      TabOrder:=1;
    end;
    with TButton.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=88;
      Top:=72;
      Width:=73;
      Height:=25;
      Caption:='No';
      ModalResult:=mrNo;
      TabOrder:=2;
    end;
    with TButton.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=168;
      Top:=72;
      Width:=73;
      Height:=25;
      Cancel:=True;
      Caption:='Cancel';
      ModalResult:=mrCancel;
      TabOrder:=3;
    end;
  end;

  result:=fm.ShowModal;
  if result <> mrCancel then
    aValue:=IntRange(SpinEdit1.Value,min,max);
  fm.free;
end;

function InputDoubleQuery(const ACaption, APrompt: string; var aValue: double; min,max: double): Boolean;
var fm: TForm;
    Bevel1: TBevel;
    Label1: TLabel;
    OKBtn: TButton;
    CancelBtn: TButton;
    FSpinEdit1: TFSpinEdit;
begin
  fm:=TForm.Create(nil);
  with fm do
  begin
    BorderStyle:=bsDialog;
    Caption:=ACaption;
    ClientHeight:=105;
    ClientWidth:=168;
    Color:=clBtnFace;
    Position:=poScreenCenter;
    KeyPreview:=True;

    Bevel1:=TBevel.Create(fm);
    with Bevel1 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=8;
      Width:=153;
      Height:=57;
      Shape:=bsFrame;
    end;
    Label1:=TLabel.Create(fm);
    with Label1 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=16;
      Top:=16;
      Width:=40;
      Height:=13;
      Caption:=APrompt;
    end;
    FSpinEdit1:=TFSpinEdit.Create(fm);
    with FSpinEdit1 do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=24;
      Top:=32;
      Width:=129;
      Height:=22;
      MaxValue:=max;
      MinValue:=min;
      Value:=RealRange(aValue,min,max);
      TabOrder:=0;
    end;
    OKBtn:=TButton.Create(fm);
    with OKBtn do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=72;
      Width:=73;
      Height:=25;
      Caption:='OK';
      Default:=True;
      ModalResult:=1;
      TabOrder:=1;
    end;
    CancelBtn:=TButton.Create(fm);
    with CancelBtn do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=88;
      Top:=72;
      Width:=73;
      Height:=25;
      Cancel:=True;
      Caption:='Cancel';
      ModalResult:=2;
      TabOrder:=2;
    end;
  end;

  result:=fm.ShowModal = mrOK;
  if result then
    aValue:=RealRange(FSpinEdit1.Value,min,max);
  fm.free;
end;

function InputQuery(const ACaption, APrompt: string; var aValue: string): Boolean;
var fm: TForm;
begin
  fm:=TForm.Create(nil);
  with fm do
  begin
    BorderStyle:=bsDialog;
    Caption:=ACaption;
    ClientHeight:=105;
    ClientWidth:=248;
    Color:=clBtnFace;
    Position:=poScreenCenter;
    KeyPreview:=True;

    with TBevel.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=8;
      Width:=153+80;
      Height:=57;
      Shape:=bsFrame;
    end;
    with TLabel.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=16;
      Top:=16;
      Width:=40;
      Height:=13;
      Caption:=APrompt;
    end;
    with TButton.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=48;
      Top:=72;
      Width:=73;
      Height:=25;
      Caption:='OK';
      Default:=True;
      ModalResult:=mrYes;
      TabOrder:=1;
    end;
    with TButton.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=128;
      Top:=72;
      Width:=73;
      Height:=25;
      Caption:='Cancel';
      ModalResult:=mrNo;
      TabOrder:=2;
    end;
  end;
  with TEdit.Create(fm) do
  begin
    Parent:=fm;
    Visible:=true;
    Left:=24;
    Top:=32;
    Width:=209;
    Height:=22;
    Text:=aValue;
    TabOrder:=0;
    result:=fm.ShowModal = mrYes;
    if result then
      aValue:=text;
  end;

  fm.free;
end;

function InputBox(const ACaption, APrompt, ADefault: string): string;
var fm: TForm;
begin
  fm:=TForm.Create(nil);
  with fm do
  begin
    BorderStyle:=bsDialog;
    Caption:=ACaption;
    ClientHeight:=105;
    ClientWidth:=248;
    Color:=clBtnFace;
    Position:=poScreenCenter;
    KeyPreview:=True;

    with TBevel.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=8;
      Width:=153+80;
      Height:=57;
      Shape:=bsFrame;
    end;
    with TLabel.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=16;
      Top:=16;
      Width:=40;
      Height:=13;
      Caption:=APrompt;
    end;
    with TButton.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=88;
      Top:=72;
      Width:=73;
      Height:=25;
      Caption:='OK';
      Default:=True;
      ModalResult:=mrOK;
      TabOrder:=1;
    end;
  end;
  with TEdit.Create(fm) do
  begin
    Parent:=fm;
    Visible:=true;
    Left:=24;
    Top:=32;
    Width:=209;
    Height:=22;
    Text:=ADefault;
    TabOrder:=0;
    if fm.ShowModal = mrOK then
      result:=text else
      result:=ADefault;
  end;
  fm.free;
end;

function InputMemo(const ACaption, APrompt, ADefault: string): string;
var fm: TForm;
begin
  fm:=TForm.Create(nil);
  with fm do
  begin
    Left:=197;
    Top:=110;
    Width:=568;
    Height:=409;
    Caption:=ACaption;
    Color:=clBtnFace;
    Font.Charset:=DEFAULT_CHARSET;
    Font.Color:=clWindowText;
    Font.Height:=-11;
    Font.Name:='MS Sans Serif';
    Font.Style:=[];
    OldCreateOrder:=False;
    PixelsPerInch:=96;
    BorderStyle:=bsDialog;
    Position:=poScreenCenter;
    KeyPreview:=True;
    with TLabel.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=8;
      Width:=32;
      Height:=13;
      Caption:=APrompt;
    end;
    with TButton.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=242;
      Top:=344;
      Width:=75;
      Height:=25;
      Caption:='OK';
      Default:=True;
      ModalResult:=1;
      TabOrder:=1;
    end;
    with TMemo.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=24;
      Width:=545;
      Height:=313;
      Text:=ADefault;
      ScrollBars:=ssVertical;
      TabOrder:=0;
      if fm.ShowModal = mrOK then
        result:=text else
        result:=ADefault;
    end;
  end;
  fm.free;
end;

function InputStringYesNoCancel(const ACaption, APrompt: string; var aValue: string): TModalResult;
var fm: TForm;
begin
  fm:=TForm.Create(nil);
  with fm do
  begin
    BorderStyle:=bsDialog;
    Caption:=ACaption;
    ClientHeight:=105;
    ClientWidth:=248;
    Color:=clBtnFace;
    Position:=poScreenCenter;
    KeyPreview:=True;

    with TBevel.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=8;
      Width:=153+80;
      Height:=57;
      Shape:=bsFrame;
    end;
    with TLabel.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=16;
      Top:=16;
      Width:=40;
      Height:=13;
      Caption:=APrompt;
    end;
    with TButton.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=72;
      Width:=73;
      Height:=25;
      Caption:='Yes';
      Default:=True;
      ModalResult:=mrYes;
      TabOrder:=1;
    end;
    with TButton.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=88;
      Top:=72;
      Width:=73;
      Height:=25;
      Caption:='No';
      ModalResult:=mrNo;
      TabOrder:=2;
    end;
    with TButton.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=168;
      Top:=72;
      Width:=73;
      Height:=25;
      Cancel:=True;
      Caption:='Cancel';
      ModalResult:=mrCancel;
      TabOrder:=3;
    end;
  end;
  with TEdit.Create(fm) do
  begin
    Parent:=fm;
    Visible:=true;
    Left:=24;
    Top:=32;
    Width:=209;
    Height:=22;
    Text:=aValue;
    TabOrder:=0;
    result:=fm.ShowModal;
    if result <> mrCancel then
      aValue:=text;
  end;
  fm.free;
end;

function ChooseOneEx(const ACaption, APrompt: string; const s1: array of string; s2: Tstrings; var aIndex: integer): Boolean;
var fm: TForm;
    i: integer;
    OKBtn: TButton;
    CancelBtn: TButton;
    RadioGroup: TRadioGroup;
begin
  fm:=TForm.Create(nil);
  with fm do
  begin
    BorderStyle:=bsDialog;
    Caption:=ACaption;
    ClientWidth:=313;
    Color:=clBtnFace;
    Position:=poScreenCenter;
    KeyPreview:=True;

    RadioGroup:=TRadioGroup.Create(fm);
    with RadioGroup do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=8;
      Width:=297;
      Height:=17+length(s1)*20;
      Caption:=APrompt;
      if s2.Count > 0 then
      begin
        for i:=0 to s2.Count-1 do
          Items.Add(s2[i]);
      end else
      begin
        for i:=0 to high(s1) do
          Items.Add(s1[i]);
      end;
      ItemIndex:=aIndex;
      TabOrder:=2;
    end;

    OKBtn:=TButton.Create(fm);
    with OKBtn do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=79;
      Top:=RadioGroup.Top+RadioGroup.Height+8;
      Width:=75;
      Height:=25;
      Caption:='OK';
      Default:=True;
      ModalResult:=1;
      TabOrder:=0;
    end;
    CancelBtn:=TButton.Create(fm);
    with CancelBtn do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=159;
      Top:=OKBtn.Top;
      Width:=75;
      Height:=25;
      Cancel:=True;
      Caption:='Cancel';
      ModalResult:=2;
      TabOrder:=1;
    end;
    ClientHeight:=OKBtn.Top+OKBtn.Height+8;
  end;

  result:=fm.ShowModal = mrOK;
  if result then
    aIndex:=RadioGroup.ItemIndex;
  fm.free;

  fm:=TForm.Create(nil);
  with fm do
  begin
    BorderStyle:=bsDialog;
    Caption:=ACaption;
    ClientWidth:=313;
    Color:=clBtnFace;
    Position:=poScreenCenter;
    KeyPreview:=True;

    RadioGroup:=TRadioGroup.Create(fm);
    with RadioGroup do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=8;
      Width:=297;
      Height:=17+s2.Count*20;
      Caption:=APrompt;
      for i:=0 to s2.Count-1 do
        Items.Add(s2[i]);
      ItemIndex:=aIndex;
      TabOrder:=2;
    end;

    OKBtn:=TButton.Create(fm);
    with OKBtn do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=79;
      Top:=RadioGroup.Top+RadioGroup.Height+8;
      Width:=75;
      Height:=25;
      Caption:='OK';
      Default:=True;
      ModalResult:=1;
      TabOrder:=0;
    end;
    CancelBtn:=TButton.Create(fm);
    with CancelBtn do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=159;
      Top:=OKBtn.Top;
      Width:=75;
      Height:=25;
      Cancel:=True;
      Caption:='Cancel';
      ModalResult:=2;
      TabOrder:=1;
    end;
    ClientHeight:=OKBtn.Top+OKBtn.Height+8;
  end;

  result:=fm.ShowModal = mrOK;
  if result then
    aIndex:=RadioGroup.ItemIndex;
  fm.free;
end;

function ChooseOne(const ACaption, APrompt: string; const s: array of string; var aIndex: integer): Boolean;
begin
  result:=ChooseOneEx(ACaption, APrompt,s,nil,aIndex);
end;

function ChooseOneStrs(const ACaption, APrompt: string; s: Tstrings; var aIndex: integer): Boolean;
begin
  result:=ChooseOneEx(ACaption, APrompt,[],s,aIndex);
end;

function ChooseOneComboEx(const ACaption, APrompt: string; const s1: array of string; s2: Tstrings; var aIndex: integer): Boolean;
var fm: TForm;
    i: integer;
    OKBtn: TButton;
    CancelBtn: TButton;
    RadioGroup: TRadioGroup;
begin
(*
  fm:=TForm.Create(nil);
  with fm do
  begin
    BorderStyle:=bsDialog;
    Caption:=ACaption;
    ClientWidth:=313;
    Color:=clBtnFace;
    Position:=poScreenCenter;
    KeyPreview:=True;

    with TBevel.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=8;
      Width:=153+80;
      Height:=57;
      Shape:=bsFrame;
    end;
    with TLabel.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=16;
      Top:=16;
      Width:=40;
      Height:=13;
      Caption:=APrompt;
    end;
    with TButton.Create(fm) do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=88;
      Top:=72;
      Width:=73;
      Height:=25;
      Caption:='OK';
      Default:=True;
      ModalResult:=mrOK;
      TabOrder:=1;
    end;
  end;
  with TCombo.Create(fm) do
  begin
    Parent:=fm;
    Visible:=true;
    Left:=24;
    Top:=32;
    Width:=209;
    Height:=22;
    Text:=ADefault;
    TabOrder:=0;
    if fm.ShowModal = mrOK then
      result:=text else
      result:=ADefault;
  end;
  fm.free;
=========
/
    RadioGroup:=TRadioGroup.Create(fm);
    with RadioGroup do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=8;
      Width:=297;
      Height:=17+length(s1)*20;
      Caption:=APrompt;
      if s2.Count > 0 then
      begin
        for i:=0 to s2.Count-1 do
          Items.Add(s2[i]);
      end else
      begin
        for i:=0 to high(s1) do
          Items.Add(s1[i]);
      end;
      ItemIndex:=aIndex;
      TabOrder:=2;
    end;

    OKBtn:=TButton.Create(fm);
    with OKBtn do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=79;
      Top:=RadioGroup.Top+RadioGroup.Height+8;
      Width:=75;
      Height:=25;
      Caption:='OK';
      Default:=True;
      ModalResult:=1;
      TabOrder:=0;
    end;
    CancelBtn:=TButton.Create(fm);
    with CancelBtn do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=159;
      Top:=OKBtn.Top;
      Width:=75;
      Height:=25;
      Cancel:=True;
      Caption:='Cancel';
      ModalResult:=2;
      TabOrder:=1;
    end;
    ClientHeight:=OKBtn.Top+OKBtn.Height+8;
  end;

  result:=fm.ShowModal = mrOK;
  if result then
    aIndex:=RadioGroup.ItemIndex;
  fm.free;

  fm:=TForm.Create(nil);
  with fm do
  begin
    BorderStyle:=bsDialog;
    Caption:=ACaption;
    ClientWidth:=313;
    Color:=clBtnFace;
    Position:=poScreenCenter;
    KeyPreview:=True;

    RadioGroup:=TRadioGroup.Create(fm);
    with RadioGroup do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=8;
      Top:=8;
      Width:=297;
      Height:=17+s2.Count*20;
      Caption:=APrompt;
      for i:=0 to s2.Count-1 do
        Items.Add(s2[i]);
      ItemIndex:=aIndex;
      TabOrder:=2;
    end;

    OKBtn:=TButton.Create(fm);
    with OKBtn do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=79;
      Top:=RadioGroup.Top+RadioGroup.Height+8;
      Width:=75;
      Height:=25;
      Caption:='OK';
      Default:=True;
      ModalResult:=1;
      TabOrder:=0;
    end;
    CancelBtn:=TButton.Create(fm);
    with CancelBtn do
    begin
      Parent:=fm;
      Visible:=true;
      Left:=159;
      Top:=OKBtn.Top;
      Width:=75;
      Height:=25;
      Cancel:=True;
      Caption:='Cancel';
      ModalResult:=2;
      TabOrder:=1;
    end;
    ClientHeight:=OKBtn.Top+OKBtn.Height+8;
  end;

  result:=fm.ShowModal = mrOK;
  if result then
    aIndex:=RadioGroup.ItemIndex;
  fm.free;
*)
end;

function ChooseOneCombo(const ACaption, APrompt: string; const s: array of string; var aIndex: integer): Boolean;
begin
  result:=ChooseOneEx(ACaption, APrompt,s,nil,aIndex);
end;

function ChooseOneComboStrs(const ACaption, APrompt: string; s: Tstrings; var aIndex: integer): Boolean;
begin
  result:=ChooseOneEx(ACaption, APrompt,[],s,aIndex);
end;

function ForceDateToCentury(d: TDateTime; CenturyStarts: integer): TDateTime;
var Year1, Month1, Day1: Word;
begin
  DecodeDate(d,Year1, Month1, Day1);
  while year1 >= CenturyStarts+100 do
    dec(year1,100);
  while year1 < CenturyStarts do
    inc(year1,100);
  try
    result:=EncodeDate(Year1, Month1, Day1);
  except
    result:=EncodeDate(Year1, Month1, Day1-1);
  end;
end;

function ThisYear: Word;
var Month1, Day1: Word;
begin
  DecodeDate(now,result, Month1, Day1);
end;

procedure DateDiff(d1,d2: TDateTime; var Year, Month, Day: Word);
var Year1, Month1, Day1: Word;
var Year2, Month2, Day2: Word;
var ThisYear: Word;
begin
  d1:=trunc(d1);
  d2:=trunc(d2);
  DecodeDate(d1,Year1, Month1, Day1);
  DecodeDate(d2,Year2, Month2, Day2);

  if d1 < d2 then
    DateDiff(d2,d1,Year, Month, Day) else
  begin
    Year:=0;
    Month:=0;
    Day:=0;

    if Day2 > Day1 then
    begin
      while Day2 > 1 do
      begin
        d1:=d1-1;
        d2:=d2-1;
        DecodeDate(d1,Year1, Month1, Day1);
        DecodeDate(d2,Year2, Month2, Day2);
      end;
    end;

    Day:=Day1-Day2;
    if Month1 >= Month2 then
    begin
      Month:=Month1-Month2;
      Year:=Year1-Year2;
    end else
    begin
      Month:=Month1-Month2+12;
      Year:=Year1-Year2-1;
    end;
  end;
end;

var Regression: record Sxx,Sxz,Syy,Sxy,Sz,Sy,Sx,Syz: double; n: integer; end;

procedure RegressionInit;
begin
  with Regression do
  begin
    Sxx:=0;
    Sxz:=0;
    Syy:=0;
    Sxy:=0;
    Syz:=0;
    Sz:=0;
    Sy:=0;
    Sx:=0;
    n:=0;
  end;
end;

procedure RegressionData(x,y,z: double);
{z:=ax + by + c}
begin
  with Regression do
  begin
    Sxx:=Sxx+x*x;
    Sxz:=Sxz+x*z;
    Syy:=Syy+y*y;
    Sxy:=Sxy+x*y;
    Syz:=Syz+y*z;
    Sz:=Sz+z;
    Sy:=Sy+y;
    Sx:=Sx+x;
    n:=n+1;
  end;
end;

procedure RegressionAnswer(var a,b,c: double);
{z:=ax + by + c}
begin
  with Regression do
  if n = 0 then
  begin
    a:=0;
    b:=0;
    c:=0;
  end else
  begin
    c:=((Sxy-Sx*Sy/n)*(Sxy-Sx*Sy/n) - (Syy-Sy*Sy/n)*(Sxx-Sx*Sx/n));
    if c = 0 then
    begin
      a:=0;
      b:=0;
    end else
    begin
      a:=((Syz-Sy*Sz/n)*(Sxy-Sx*Sy/n) - (Syy-Sy*Sy/n)*(Sxz-Sx*Sz/n))/c;
      b:=((Sxz-Sx*Sz/n)*(Sxy-Sx*Sy/n) - (Sxx-Sx*Sx/n)*(Syz-Sy*Sz/n))/c;
    end;
    c:=(Sz-a*Sx-b*Sy)/n;
  end;
end;

function PolyBoundingRect(Points: array of TPoint): TRect;
var i: integer;
begin
  result.Left:=maxint;
  result.Top:=maxint;
  result.Right:=-maxint;
  result.Bottom:=-maxint;

  for i:=low(Points) to high(Points) do
  begin
    result.Left  :=min(result.Left  ,Points[i].x);
    result.Top   :=min(result.Top   ,Points[i].y);
    result.Right :=max(result.Right ,Points[i].x);
    result.Bottom:=max(result.Bottom,Points[i].y);
  end;
end;

function PointInsidePolygonSingle(pt: TSinglePoint; C: Array of TSinglePoint): boolean;
var i: integer;
    p: TSinglePoint;
begin
  result:=false;
  if length(C) = 0 then
    exit;
  p:=C[high(C)];
  for i:=low(C) to high(C) do
  begin
    if p.x <> C[i].x then
      if (pt.x >  p.x) = (pt.x <= C[i].x) then
        if pt.y-p.y <= (pt.x-p.x)*(C[i].y-p.y)/(C[i].x-p.x) then
          result:=not result;
    p:=C[i];
  end;
end;

function PointInsidePolygon(pt: TPoint; var C: Array of TPoint): boolean;
var i: integer;
    p: TPoint;
begin
  result:=false;
  if length(C) = 0 then
    exit;


  p:=C[high(C)];
  for i:=low(C) to high(C) do
  begin
    if p.x <> C[i].x then
      if (pt.x >  p.x) = (pt.x <= C[i].x) then
        if pt.y-p.y <= (pt.x-p.x)*(C[i].y-p.y)/(C[i].x-p.x) then
          result:=not result;
    p:=C[i];
  end;
end;

function LineInDottedRectP(p1,p2: TPoint; Rect: TRect): boolean;
begin
  result:=LineInDottedRect(p1.x,p1.y,p2.x,p2.y,Rect);
end;

function LineInDottedRect(x1,y1,x2,y2: integer; Rect: TRect): boolean;
{line starts in, ends in or passes through rect}
var p: TPoint;
begin
  result:=
       PtInRect(SortRect(Rect),Point(x1,y1)) or
       PtInRect(SortRect(Rect),Point(x2,y2)) or
       LinesCrossTP(Point(x1,y1),Point(x2,y2), Point(Rect.Left, Rect.top), Point(Rect.Left, Rect.Bottom),p) or
       LinesCrossTP(Point(x1,y1),Point(x2,y2), Point(Rect.Left, Rect.top), Point(Rect.Right, Rect.top),p) or
       LinesCrossTP(Point(x1,y1),Point(x2,y2), Point(Rect.Right, Rect.Bottom), Point(Rect.Left, Rect.top),p) or
       LinesCrossTP(Point(x1,y1),Point(x2,y2), Point(Rect.Right, Rect.Bottom), Point(Rect.Right, Rect.top),p);
end;

function PtInPolygon(pt: TPoint; Points: array of TPoint): boolean;
var i: integer;
    p: TPoint;
begin
  result:=false;
  if length(Points) = 0 then
    exit;

  p:=Points[high(Points)];
  for i:=low(Points) to high(Points) do
  begin
    if p.x <> Points[i].x then
      if (pt.x >  p.x) = (pt.x <= Points[i].x) then
        if pt.y-p.y <= (pt.x-p.x)*(Points[i].y-p.y)/(Points[i].x-p.x) then
          result:=not result;
    p:=Points[i];
  end;
end;

function CoGPoly(Poly1: array of TPoint): TSinglePoint;
{Centroid of polygon}
var a: single;
    i,j: integer;
begin
  a:=0;
  result.x:=0;
  result.y:=0;
  for i:=0 to high(Poly1) do
  begin
    j:=(i+1) mod length(Poly1);
    a:=a+Poly1[i].x*Poly1[j].y-Poly1[j].x*Poly1[i].y;
    result.x:=result.x+(Poly1[i].x+Poly1[j].x)*(Poly1[i].x*Poly1[j].y-Poly1[j].x*Poly1[i].y);
    result.y:=result.y+(Poly1[i].y+Poly1[j].y)*(Poly1[i].x*Poly1[j].y-Poly1[j].x*Poly1[i].y);
  end;
  a:=a/2;
  if a <> 0 then
  begin
    result.x:=result.x/(6*a);
    result.y:=result.y/(6*a);
  end;
end;

procedure BezierToCoeff(Q: Array of TSinglePoint; var a,b,c,d: TSinglePoint);
begin
  a.x:=+Q[0].x;
  b.x:=-Q[0].x*3 +Q[1].x*3;
  c.x:=+Q[0].x*3 -Q[1].x*6 +Q[2].x*3;
  d.x:=-Q[0].x   +Q[1].x*3 -Q[2].x*3 +Q[3].x;
  a.y:=+Q[0].y;
  b.y:=-Q[0].y*3 +Q[1].y*3;
  c.y:=+Q[0].y*3 -Q[1].y*6 +Q[2].y*3;
  d.y:=-Q[0].y   +Q[1].y*3 -Q[2].y*3 +Q[3].y;
end;

function CoeffToBezier(a,b,c,d: TSinglePoint): TArrayofTSinglePoint;
{ x=a+bt+ctt+dttt; t=0..1 }
begin
  SetLength(result,4);
  result[0].x:= a.x;
  result[1].x:= a.x+b.x/3;
  result[2].x:= a.x+b.x*2/3+c.x/3;
  result[3].x:= a.x+b.x+c.x+d.x;
  result[0].y:= a.y;
  result[1].y:= a.y+b.y/3;
  result[2].y:= a.y+b.y*2/3+c.y/3;
  result[3].y:= a.y+b.y+c.y+d.y;
end;

procedure DrawBezierKnots(Canvas: TCanvas; k1,c1,c2,k2: TSinglePoint);
var a,b,c,d: TSinglePoint;
    Q: Array [0..3] of TSinglePoint;
begin
  Q[0]:=k1;
  Q[1]:=c1;
  Q[2]:=c2;
  Q[3]:=k2;
  BezierToCoeff(Q,a,b,c,d);
  DrawBezierCoeff(Canvas,a,b,c,d);
end;

procedure DrawBezierCoeff(Canvas: TCanvas; a,b,c,d: TSinglePoint);
var n,t,x,y: integer;
    u: single;
    v: Single;
const MinSeg = 2;
begin
  with Canvas do
  begin
    if d.x <> 0 then
      u:=-c.x/3/d.x else
      u:=0;
    u:=RealRange(u,0,1);
    v:=DoubleMax([abs(b.x),abs(b.x+2*c.x+3*d.x),abs(b.x+2*c.x*u+3*d.x*u*u)]);
    if d.y <> 0 then
      u:=-2*c.y/6/d.y else
      u:=0;
    u:=RealRange(u,0,1);
    v:=DoubleMax([v,abs(b.y),abs(b.y+2*c.y+3*d.y),abs(b.y+2*c.y*u+3*d.y*u*u)]);

    n:=IntMax([trunc(v/Minseg),1]);

    for t:=0 to n-1 do
    begin
      u:=t/n;
      x:=round((a.x+(b.x+(c.x+d.x*u)*u)*u));
      y:=round((a.y+(b.y+(c.y+d.y*u)*u)*u));
      if t = 0 then
        moveto(x,y) else
        Lineto(x,y);
    end;
  end;
end;

function SingleRect(ALeft, ATop, ARight, ABottom: single): TSingleRect;
begin
  result.Left:=ALeft;
  result.Top:=ATop;
  result.Right:=ARight;
  result.Bottom:=ABottom;
end;

function SingleRectToRect(aRect: TSingleRect): TRect;
begin
  result:=Rect(round(aRect.Left), round(aRect.Top), round(aRect.Right), round(aRect.Bottom));
end;

procedure PrincipalAxis(var DataPoint: Array of TSinglePoint; var a,b: TSinglePoint; var e: single);
{ a and b are ends of Principal Axis line }
{ a is mean of points }
{ if there's an ellipse surrounding the points then e = minor_axis/major_axis }
{ so the eccentricity is sqrt(1-sqr(e)) }
var n,i: integer;
var sx,sy,sxy,sx2,sy2: Single;
begin
  sx:=0;
  sy:=0;
  sx2:=0;
  sy2:=0;
  sxy:=0;
  n:=0;

  for i:=0 to high(DataPoint) do
  with DataPoint[i mod length(DataPoint)] do
  begin
    sx:=sx+x;
    sy:=sy+y;
    sx2:=sx2+x*x;
    sy2:=sy2+y*y;
    sxy:=sxy+x*y;
    n:=n+1;
  end;

  Sxy := Sxy - Sx*Sy/n;
  Sx2 := Sx2 - Sx*Sx/n;
  Sy2 := Sy2 - Sy*Sy/n;

  a.x:=sx/n;
  a.y:=sy/n;
  b.x:=2*sxy;
  b.y:=((sy2-sx2)+sqrt(sqr((sy2-sx2))+sqr(2*sxy)));

  e:=sqrt(
    (b.x*b.x*sy2-2*b.x*b.y*sxy+b.y*b.y*sx2)/
    (b.x*b.x*sx2+2*b.x*b.y*sxy+b.y*b.y*sy2));

  b.x:=a.x+b.x;
  b.y:=a.y+b.y;
end;

function DistPointToPlane(pt: T3DPoint; pl: TPlane): single;
begin
  result:=pl.p.x*pt.x+pl.p.y*pt.y+pl.p.z*pt.z+pl.d;
end;

function PlaneThroughThreePoints(p1,p2,p3: T3DPoint): TPlane;
begin
  result.p:=Normalise3D(CrossProduct3D(Sub3D(p2,p1),Sub3D(p3,p1)));
  result.d:=-DotProduct3D(p2,result.p);
end;

function NearestPointOnPlaneToPoint(pt: T3DPoint; pl: TPlane): T3DPoint;
var t: single;
begin
  t:=-DotProduct3D(pt,pl.p)-pl.d;
  result:=Add3D(pt,Scale3D(pl.p,t));
end;

function ClosestApproachOfTwoLines(LineA1,LineA2,LineB1,LineB2: T3DPoint; var pA,pB: T3DPoint): boolean;
var s,t,Lap,Lbp,LaLa,LaLb,LbLb,LbLa: single;
    p,Lb,La: T3DPoint;
begin
  p:=sub3D(LineB1,LineA1);
  Lb:=sub3D(LineB2,LineB1);
  La:=sub3D(LineA2,LineA1);
  Lap:=DotProduct3D(La,p);
  Lbp:=DotProduct3D(Lb,p);
  LaLa:=DotProduct3D(La,La);
  LaLb:=DotProduct3D(La,Lb);
  LbLb:=DotProduct3D(Lb,Lb);
  LbLa:=DotProduct3D(Lb,La);

  //Lap + LaLb*t -LaLa*s = 0
  //Lbp + LbLb*t -LbLa*s = 0

  result:=(abs(LaLa*LbLb-LbLa*LaLb) > 0.000001) and (abs(LaLa*LbLb-LbLa*LaLb) > 0.000001);
  if result then
  begin
    t:=(LbLa*Lap-LaLa*Lbp)/(LaLa*LbLb-LbLa*LaLb);
    s:=(Lap*LbLb-Lbp*LaLb)/(LaLa*LbLb-LbLa*LaLb);
  end else
  begin
    t:=0;
    s:=0;
  end;

  pA:=Add3D(LineA1,scale3D(La,s));
  pB:=Add3D(LineB1,scale3D(Lb,t));
end;

function IntersectionOfLineAndPlane(LineA,LineB: T3DPoint; pl: TPlane): T3DPoint;
var t,f,g,h: double;
begin
assert(false,'this routine has not been tested yet: IntersectionOfLineAndPlane');
  LineB:=Normalise3D(Sub3D(LineB,LineA));
  f:=LineB.x;
  g:=LineB.y;
  h:=LineB.z;
  t:=-(pl.p.x*LineA.x+pl.p.y*LineA.y+pl.p.z*LineA.z+pl.d)/(pl.p.x*f+pl.p.y*g+pl.p.z*h);
  result.x:=LineA.x+f*t;
  result.y:=LineA.y+g*t;
  result.z:=LineA.z+h*t;
end;

function PlaneThroughPointParallelToPlane(pt: T3DPoint; pl: TPlane): TPlane;
begin
  result:=pl;
  result.d:=-(result.p.x*pt.x+result.p.y*pt.y+result.p.z*pt.z);
end;

function PlaneThroughPointNormalToLine(LineA,LineB,pt: T3DPoint): TPlane;
var pl: TPlane;
begin
assert(false,'this routine has not been tested yet: IntersectionOfLineAndPlane');
  pl.p:=Normalise3D(Sub3D(LineB,LineA));
  pl.d:=0;
  result:=PlaneThroughPointParallelToPlane(pt,pl);
end;

function NextIsIdAKeepCase(var s: string; var id: string): boolean;
var id2: string;
begin
  SkipBlanksComments(s);
  id2:='';
  result:=(s <> '') and alphanum(s[1]);
  if result then
  begin
    while (s <> '') and alphanum(s[1]) do
    begin
      id2:=id2+s[1];
      delete(s,1,1);
    end;
    SkipBlanksComments(s);
      id:=id2;
  end;
end;

//differs from next is ID in that ID can start with a number
function NextIsIdA(var s: string; var id: string): boolean;
begin
  result:=NextIsIdAKeepCase(s,id);
  if result then
    id:=UpperCase(id);
end;

function MustbeEFormat(var s: string): Double;
begin
  result:=MustbeSignedDouble(s);
  if Nextis(s,'E') then
    result:=result*alog(MustbeSignedNumber(s));
end;

function SingleDataToString(i: Single): string;
begin
  result:=DataToString(i,sizeof(i));
end;

function SmallIntDataToString(i: SmallInt): string;
begin
  result:=DataToString(i,sizeof(i));
end;

function myTrunc(x: Extended): int64;
begin
  result:=trunc(x+0.0000000001);
end;

function RoundDown(i,granularity: integer): integer;
begin
  result:=i-i mod granularity;
  if i < 0 then result:=result-granularity;
end;

procedure DrawTriangle(aCanvas: TCanvas; x,y,size: integer);
begin
  with aCanvas do
  begin
    moveto(x-size,y-size);
    lineto(x,y+size);
    lineto(x+size,y-size);
    lineto(x-size,y-size);
  end;
end;

procedure TextOutEx(aCanvas: TCanvas; x,Y: integer; const Text: string; xAlign,yAlign: integer);
begin
  with aCanvas do
  begin
    x:=x+xAlign*TextWidth(text) div 2;
    y:=y+yAlign*TextHeight(text) div 2;
    TextOut(x,y,Text);
  end;
end;

procedure RotatedTextOutFont(Canvas: TCanvas; X, Y: Integer; const Text: string; Angle: integer; Font: TFont);
var NewFont,OldFont: HFont;
    h: HDC;
begin
  NewFont:=CreateFontIndirect(CopyFont(Font,Angle));
  h:=Canvas.Handle;
  OldFont:=SelectObject(h,NewFont);
  TextOut(h,X,Y,pchar(Text),length(Text));
  SelectObject(h,OldFont);
  DeleteObject(NewFont);
end;

function TPointToTSinglePoint(p: TPoint): TSinglePoint;
begin
  result.x:=p.x;
  result.y:=p.y;
end;

function InterpolatePoints(Points: array of TSinglePoint; N: integer): TarrayofTSinglePoint;
var pt: integer;
  function coord(t: single; a,b,c,d: TSinglePoint): TSinglePoint;
  begin
    result.x:=a.x*t*t*T+b.x*t*t+c.x*t+d.x;
    result.y:=a.y*t*t*T+b.y*t*t+c.y*t+d.y;
  end;
  procedure InterpCurve(a,b,c,d: TSinglePoint);
  var i: integer;
  begin
    for i:=1 to N do
    begin
      inc(pt);
      result[pt]:=coord(i/N,a,b,c,d);
    end;
  end;
  procedure InterpCurve4(p1,p2,p3,p4: integer);
  var g,h,a,b,c,d: TSinglePoint;
  begin
    g.y:=(Points[p3].y-Points[p1].y)/2;
    h.y:=(Points[p4].y-Points[p2].y)/2;
    a.y:=2*g.y+2*Points[p2].y-g.y-2*Points[p3].y+h.y;
    d.y:=Points[p2].y;
    c.y:=g.y;
    b.y:=3*Points[p3].y-3*Points[p2].y-2*g.y-h.y;

    g.x:=(Points[p3].x-Points[p1].x)/2;
    h.x:=(Points[p4].x-Points[p2].x)/2;
    a.x:=+2*g.x+2*Points[p2].x-g.x-2*Points[p3].x+h.x;
    d.x:=Points[p2].x;
    c.x:=g.x;
    b.x:=3*Points[p3].x-3*Points[p2].x-2*g.x-h.x;

    InterpCurve(a,b,c,d);
  end;
  procedure InterpCurve3a(p1,p2,p3: integer);
  var g,a,b,c,d: TSinglePoint;
  begin
    a.y:=0;
    g.y:=(Points[p3].y-Points[p1].y)/2;
    d.y:=Points[p1].y;
    b.y:=Points[p1].y-Points[p2].y+g.y;
    c.y:=2*Points[p2].y-2*Points[p1].y-g.y;

    a.x:=0;
    g.x:=(Points[p3].x-Points[p1].x)/2;
    d.x:=Points[p1].x;
    b.x:=Points[p1].x-Points[p2].x+g.x;
    c.x:=2*Points[p2].x-2*Points[p1].x-g.x;

    InterpCurve(a,b,c,d);
  end;
  procedure InterpCurve3b(p1,p2,p3: integer);
  var g,a,b,c,d: TSinglePoint;
  begin
    a.y:=0;
    c.y:=(Points[p3].y-Points[p1].y)/2;
    d.y:=Points[p2].y;
    b.y:=Points[p3].y-c.y-d.y;

    a.x:=0;
    c.x:=(Points[p3].x-Points[p1].x)/2;
    d.x:=Points[p2].x;
    b.x:=Points[p3].x-c.x-d.x;

    InterpCurve(a,b,c,d);
  end;
var i: integer;
begin
  SetLength(result,(Length(Points)-1)*N+1);

  pt:=0;
  result[pt]:=Points[0];

  case length(Points) of
    1: ;
    2: for i:=0 to N do
         result[i]:=SinglePoint(Points[0].x+(Points[1].x-Points[0].x)*i/N,Points[0].y+(Points[1].y-Points[0].y)*i/N);
    else
      begin
        InterpCurve3a(0,1,2);
        for i:=low(Points)+1 to high(Points)-2 do
          InterpCurve4(i-1,i,i+1,i+2);
        InterpCurve3b(high(Points)-2,high(Points)-1,high(Points));
      end;
  end;
end;

function InterpolateSingles(Singles: array of Single; N: integer): TarrayofSingle;
var pt: integer;
  function coord(t: single; a,b,c,d: Single): Single;
  begin
    result:=a*t*t*T+b*t*t+c*t+d;
  end;
  procedure InterpCurve(a,b,c,d: Single);
  var i: integer;
  begin
    for i:=1 to N do
    begin
      inc(pt);
      result[pt]:=coord(i/N,a,b,c,d);
    end;
  end;
  procedure InterpCurve4(p1,p2,p3,p4: integer);
  var g,h,a,b,c,d: Single;
  begin
    g:=(Singles[p3]-Singles[p1])/2;
    h:=(Singles[p4]-Singles[p2])/2;
    a:=+2*g+2*Singles[p2]-g-2*Singles[p3]+h;
    d:=Singles[p2];
    c:=g;
    b:=3*Singles[p3]-3*Singles[p2]-2*g-h;

    InterpCurve(a,b,c,d);
  end;
  procedure InterpCurve3a(p1,p2,p3: integer);
  var g,a,b,c,d: Single;
  begin
    a:=0;
    g:=(Singles[p3]-Singles[p1])/2;
    d:=Singles[p1];
    b:=Singles[p1]-Singles[p2]+g;
    c:=2*Singles[p2]-2*Singles[p1]-g;

    InterpCurve(a,b,c,d);
  end;
  procedure InterpCurve3b(p1,p2,p3: integer);
  var a,b,c,d: Single;
  begin
    a:=0;
    c:=(Singles[p3]-Singles[p1])/2;
    d:=Singles[p2];
    b:=Singles[p3]-c-d;

    InterpCurve(a,b,c,d);
  end;
  procedure InterpCurve2(p1,p2: integer);
  var a,b,c,d: Single;
  begin
    a:=0;
    b:=0;
    c:=Singles[p2]-Singles[p1];
    d:=Singles[p2];
    InterpCurve(a,b,c,d);
  end;
var i: integer;
begin
  SetLength(result,(Length(Singles)-1)*N+1);

  pt:=0;
  result[pt]:=Singles[0];

  case length(Singles) of
    1: ;
    2: InterpCurve2(0,1);
    else
      begin
        InterpCurve3a(0,1,2);
        for i:=low(Singles)+1 to high(Singles)-2 do
          InterpCurve4(i-1,i,i+1,i+2);
        InterpCurve3b(high(Singles)-2,high(Singles)-1,high(Singles));
      end;
  end;
end;

function InterpolateBytes(Bytes: array of byte; N: integer): TarrayofByte;
var pt: integer;
var i,j: integer;
begin
  SetLength(result,(Length(Bytes)-1)*N+1);
  pt:=0;
  result[pt]:=Bytes[0];

  for i:=low(Bytes) to high(Bytes)-1 do
  for j:=1 to N do
  begin
    inc(pt);
    result[pt]:=round(Bytes[i+1]*j/N+Bytes[i]*(1-j/N));
  end;
end;

function EnabledTextColor(enabled: boolean): TColor;
begin
  if enabled then
    result:=clWindowText else
    result:=clGrayText;
end;

function FixedPointStrTruncate(r: Double; AfterDP: integer): string;
begin
  result:=FixedPointStrDP(r,AfterDP);
  while (length(result) > 1) and (result[length(result)] = '0') do
    delete(result,length(result),1);
  if (length(result) > 1) and (result[length(result)] = '.') then
    delete(result,length(result),1);
end;

function InputComboQuery(const ACaption, APrompt: string; aItems: string; var Value: string): Boolean;
begin
  result:=InputComboQueryEx(ACaption, APrompt,aItems,Value,csDropDown,false);
end;

function InputComboQueryEx(const ACaption, APrompt: string; aItems: string; var Value: string; aStyle: TComboBoxStyle; aSorted: boolean): Boolean;
var OKBottomDlg: TForm;
    Label1: TLabel;
    OKBtn: TButton;
    CancelBtn: TButton;
    ComboBox1: TComboBox;
begin
  OKBottomDlg:=TForm.Create(nil);
  with OKBottomDlg do
  begin
    Left:=236;
    Top:=173;
    BorderStyle:=bsDialog;
    ClientHeight:=87;
    ClientWidth:=311;
    Color:=clBtnFace;
    ParentFont:=True;
    OldCreateOrder:=True;
    Position:=poScreenCenter;
    PixelsPerInch:=96;
    Font.Height:=13;
    Caption:=ACaption;
    Label1:=TLabel.Create(OKBottomDlg);
    with Label1 do
    begin
      Parent:=OKBottomDlg;
      Visible:=true;
      Left:=8;
      Top:=8;
      Width:=32;
      Height:=13;
      Caption:=APrompt;
    end;
    OKBtn:=TButton.Create(OKBottomDlg);
    with OKBtn do
    begin
      Parent:=OKBottomDlg;
      Visible:=true;
      Left:=78;
      Top:=52;
      Width:=75;
      Height:=25;
      Caption:='OK';
      Default:=True;
      ModalResult:=1;
      TabOrder:=0;
    end;
    CancelBtn:=TButton.Create(OKBottomDlg);
    with CancelBtn do
    begin
      Parent:=OKBottomDlg;
      Visible:=true;
      Left:=158;
      Top:=52;
      Width:=75;
      Height:=25;
      Cancel:=True;
      Caption:='Cancel';
      ModalResult:=2;
      TabOrder:=1;
    end;
    ComboBox1:=TComboBox.Create(OKBottomDlg);
    with ComboBox1 do
    begin
      Parent:=OKBottomDlg;
      Visible:=true;
      Left:=8;
      Top:=24;
      Width:=297;
      Height:=21;
      ItemHeight:=13;
      TabOrder:=2;
      Text:=Value;
      Items.Text:=aItems;
      Style:=aStyle;
      Sorted:=aSorted;
      if Items.Count > 0 then
        ItemIndex:=0;
    end;

    result:=ShowModal = mrOK;
    if result then
      Value:=ComboBox1.Text;

    Free;
  end;
end;

procedure DialDTMF(number: string; vol: integer);
const NumSamples = 8000;
      aSampleRate = 44100;
  function SineData(f1,f2,v1,v2: integer): string;
  var t: integer;
  begin
    SetLength(result,NumSamples);

    for t:=0 to NumSamples-1 do
      result[t+1]:=char(trunc(
        sin(t*(f1)*pi*2.0/aSampleRate)*v1+
        sin(t*(f2)*pi*2.0/aSampleRate)*v2+
        128));
  end;
  function ToneData(c: char; v1,v2: integer): string;
  begin
    case c of
      '1': result:=SineData(697,1209,v1,v2);
      '2': result:=SineData(697,1336,v1,v2);
      '3': result:=SineData(697,1477,v1,v2);
      '4': result:=SineData(770,1209,v1,v2);
      '5': result:=SineData(770,1336,v1,v2);
      '6': result:=SineData(770,1477,v1,v2);
      '7': result:=SineData(852,1209,v1,v2);
      '8': result:=SineData(852,1336,v1,v2);
      '9': result:=SineData(852,1477,v1,v2);
      '*': result:=SineData(941,1209,v1,v2);
      '0': result:=SineData(941,1336,v1,v2);
      '#': result:=SineData(941,1477,v1,v2);
      else result:='';
    end;
  end;
  function Silence: string;
  begin
    result:=RPadC('',NumSamples div 2,#128);
  end;
  function AddHeader(s: string): string;
  var WaveHeader: TWaveHeaderRec;
      DataHeader: TDataHeaderRec;
  begin
    with DataHeader do
    begin
      data[1]:='d'; data[2]:='a'; data[3]:='t'; data[4]:='a';
      datasize:=length(s);
    end;

    with WaveHeader do
    begin
      RIFF[1]:='R'; RIFF[2]:='I'; RIFF[3]:='F'; RIFF[4]:='F';
      {is this right?:}
      filesize:=DataHeader.datasize+sizeof(WaveHeader);
      WAVE[1]:='W'; WAVE[2]:='A'; WAVE[3]:='V'; WAVE[4]:='E';
      fmtb[1]:='f'; fmtb[2]:='m'; fmtb[3]:='t'; fmtb[4]:=' ';
      hdrsize:=sizeof(WaveHeader)-(longint(@format)-longint(@WaveHeader));
      format:=1;
      Channels:=1;
      SamplesPerSec:=aSampleRate;
      AvgBytesPerSec:=aSampleRate;
      BlockAlignment:=1;
      BitsPerSample:=8;
    end;

    result:=DataToString(WaveHeader,sizeof(WaveHeader))+DataToString(DataHeader,sizeof(DataHeader))+s;
  end;
var s: string;
    i: integer;
begin
  s:='';
  for i:=1 to length(number) do
    if number[i] in ['0'..'9'] then
      s:=s+ToneData(number[i],vol,vol*2)+Silence;
  s:=AddHeader(s);
  sndPlaySound(@s[1],snd_Sync or snd_Memory);
end;

function CheckedCount(CheckListBox: TCheckListBox): integer;
var i: integer;
begin
  result:=0;
  for i:=0 to CheckListBox.Items.Count-1 do
    if CheckListBox.Checked[i] then
      inc(result);
end;

function FirstChecked(CheckListBox: TCheckListBox): integer;
begin
  for result:=0 to CheckListBox.Items.Count-1 do
    if CheckListBox.Checked[result] then
      exit;
  result:=-1;
end;

function MessageToString(msg: integer): string;
begin
  case msg of
    WM_NULL:                   result:='WM_NULL';
    WM_ACTIVATE:               result:='WM_ACTIVATE';
    WM_ACTIVATEAPP:            result:='WM_ACTIVATEAPP';
    WM_APP:                    result:='WM_APP';
    WM_ASKCBFORMATNAME:        result:='WM_ASKCBFORMATNAME';
    WM_CANCELJOURNAL:          result:='WM_CANCELJOURNAL';
    WM_CANCELMODE:             result:='WM_CANCELMODE';
    WM_CAPTURECHANGED:         result:='WM_CAPTURECHANGED';
    WM_CHANGECBCHAIN:          result:='WM_CHANGECBCHAIN';
    WM_CHAR:                   result:='WM_CHAR';
    WM_CHARTOITEM:             result:='WM_CHARTOITEM';
    WM_CHILDACTIVATE:          result:='WM_CHILDACTIVATE';
    WM_CLEAR:                  result:='WM_CLEAR';
    WM_CLOSE:                  result:='WM_CLOSE';
    WM_COALESCE_FIRST:         result:='WM_COALESCE_FIRST';
    WM_COALESCE_LAST:          result:='WM_COALESCE_LAST';
    WM_COMMAND:                result:='WM_COMMAND';
    WM_COMMNOTIFY:             result:='WM_COMMNOTIFY';
    WM_COMPACTING:             result:='WM_COMPACTING';
    WM_COMPAREITEM:            result:='WM_COMPAREITEM';
    WM_CONTEXTMENU:            result:='WM_CONTEXTMENU';
    WM_COPY:                   result:='WM_COPY';
    WM_COPYDATA:               result:='WM_COPYDATA';
    WM_CREATE:                 result:='WM_CREATE';
    WM_CTLCOLOR:               result:='WM_CTLCOLOR';
    WM_CTLCOLORBTN:            result:='WM_CTLCOLORBTN';
    WM_CTLCOLORDLG:            result:='WM_CTLCOLORDLG';
    WM_CTLCOLOREDIT:           result:='WM_CTLCOLOREDIT';
    WM_CTLCOLORLISTBOX:        result:='WM_CTLCOLORLISTBOX';
    WM_CTLCOLORMSGBOX:         result:='WM_CTLCOLORMSGBOX';
    WM_CTLCOLORSCROLLBAR:      result:='WM_CTLCOLORSCROLLBAR';
    WM_CTLCOLORSTATIC:         result:='WM_CTLCOLORSTATIC';
    WM_CUT:                    result:='WM_CUT';
    WM_DDE_ACK:                result:='WM_DDE_ACK';
    WM_DDE_ADVISE:             result:='WM_DDE_ADVISE';
    WM_DDE_DATA:               result:='WM_DDE_DATA';
    WM_DDE_EXECUTE:            result:='WM_DDE_EXECUTE';
    WM_DDE_FIRST:              result:='WM_DDE_FIRST';
//    WM_DDE_INITIATE:         result:='WM_DDE_INITIATE';
    WM_DDE_POKE:               result:='WM_DDE_POKE';
    WM_DDE_REQUEST:            result:='WM_DDE_REQUEST';
    WM_DDE_TERMINATE:          result:='WM_DDE_TERMINATE';
    WM_DDE_UNADVISE:           result:='WM_DDE_UNADVISE';
    WM_DEADCHAR:               result:='WM_DEADCHAR';
    WM_DELETEITEM:             result:='WM_DELETEITEM';
    WM_DESTROY:                result:='WM_DESTROY';
    WM_DESTROYCLIPBOARD:       result:='WM_DESTROYCLIPBOARD';
    WM_DEVICECHANGE:           result:='WM_DEVICECHANGE';
    WM_DEVMODECHANGE:          result:='WM_DEVMODECHANGE';
    WM_DISPLAYCHANGE:          result:='WM_DISPLAYCHANGE';
    WM_DRAWCLIPBOARD:          result:='WM_DRAWCLIPBOARD';
    WM_DRAWITEM:               result:='WM_DRAWITEM';
    WM_DROPFILES:              result:='WM_DROPFILES';
    WM_ENABLE:                 result:='WM_KILLFOCUS';
    WM_ENDSESSION:             result:='WM_ENDSESSION';
    WM_ENTERIDLE:              result:='WM_ENTERIDLE';
    WM_ENTERMENULOOP:          result:='WM_ENTERMENULOOP';
    WM_ENTERSIZEMOVE:          result:='WM_ENTERSIZEMOVE';
    WM_ERASEBKGND:             result:='WM_QUIT';
    WM_EXITMENULOOP:           result:='WM_EXITMENULOOP';
    WM_EXITSIZEMOVE:           result:='WM_EXITSIZEMOVE';
    WM_FONTCHANGE:             result:='WM_FONTCHANGE';
    WM_GETDLGCODE:             result:='WM_GETDLGCODE';
    WM_GETFONT:                result:='WM_GETFONT';
    WM_GETHOTKEY:              result:='WM_GETHOTKEY';
    WM_GETICON:                result:='WM_GETICON';
    WM_GETMINMAXINFO:          result:='WM_GETMINMAXINFO';
    WM_GETOBJECT:              result:='WM_GETOBJECT';
    WM_GETTEXT:                result:='WM_GETTEXT';
    WM_GETTEXTLENGTH:          result:='WM_GETTEXT';
    WM_HANDHELDFIRST:          result:='WM_HANDHELDFIRST';
    WM_HANDHELDLAST:           result:='WM_HANDHELDLAST';
    WM_HELP:                   result:='WM_HELP';
    WM_HOTKEY:                 result:='WM_HOTKEY';
    WM_HSCROLL:                result:='WM_HSCROLL';
    WM_HSCROLLCLIPBOARD:       result:='WM_HSCROLLCLIPBOARD';
    WM_ICONERASEBKGND:         result:='WM_ICONERASEBKGND';
    WM_IME_CHAR:               result:='WM_IME_CHAR';
    WM_IME_COMPOSITION:        result:='WM_IME_COMPOSITION';
    WM_IME_COMPOSITIONFULL:    result:='WM_IME_COMPOSITIONFULL';
    WM_IME_CONTROL:            result:='WM_IME_CONTROL';
    WM_IME_ENDCOMPOSITION:     result:='WM_IME_ENDCOMPOSITION';
    WM_IME_KEYDOWN:            result:='WM_IME_KEYDOWN';
    WM_IME_KEYUP:              result:='WM_IME_KEYUP';
    WM_IME_NOTIFY:             result:='WM_IME_NOTIFY';
    WM_IME_REQUEST:            result:='WM_IME_REQUEST';
    WM_IME_SELECT:             result:='WM_IME_SELECT';
    WM_IME_SETCONTEXT:         result:='WM_IME_SETCONTEXT';
    WM_IME_STARTCOMPOSITION:   result:='WM_IME_STARTCOMPOSITION';
    WM_INITDIALOG:             result:='WM_INITDIALOG';
    WM_INITMENU:               result:='WM_INITMENU';
    WM_INITMENUPOPUP:          result:='WM_INITMENUPOPUP';
    WM_INPUTLANGCHANGE:        result:='WM_INPUTLANGCHANGE';
    WM_INPUTLANGCHANGEREQUEST: result:='WM_INPUTLANGCHANGEREQUEST';
    WM_KEYDOWN:                result:='WM_KEYDOWN';
    WM_KEYLAST:                result:='WM_KEYLAST';
    WM_KEYUP:                  result:='WM_KEYUP';
    WM_KILLFOCUS:              result:='WM_KILLFOCUS';
    WM_LBUTTONDBLCLK:          result:='WM_LBUTTONDBLCLK';
    WM_LBUTTONDOWN:            result:='WM_LBUTTONDOWN';
    WM_LBUTTONUP:              result:='WM_LBUTTONUP';
    WM_MBUTTONDBLCLK:          result:='WM_MBUTTONDBLCLK';
    WM_MBUTTONDOWN:            result:='WM_MBUTTONDOWN';
    WM_MBUTTONUP:              result:='WM_MBUTTONUP';
    WM_MDIACTIVATE:            result:='WM_MDIACTIVATE';
    WM_MDICASCADE:             result:='WM_MDICASCADE';
    WM_MDICREATE:              result:='WM_MDICREATE';
    WM_MDIDESTROY:             result:='WM_MDIDESTROY';
    WM_MDIGETACTIVE:           result:='WM_MDIGETACTIVE';
    WM_MDIICONARRANGE:         result:='WM_MDIICONARRANGE';
    WM_MDIMAXIMIZE:            result:='WM_MDIMAXIMIZE';
    WM_MDINEXT:                result:='WM_MDINEXT';
    WM_MDIREFRESHMENU:         result:='WM_MDIREFRESHMENU';
    WM_MDIRESTORE:             result:='WM_MDIRESTORE';
    WM_MDISETMENU:             result:='WM_MDISETMENU';
    WM_MDITILE:                result:='WM_MDITILE';
    WM_MEASUREITEM:            result:='WM_MEASUREITEM';
    WM_MENUCHAR:               result:='WM_MENUCHAR';
    WM_MENUCOMMAND:            result:='WM_MENUCOMMAND';
    WM_MENUDRAG:               result:='WM_MENUDRAG';
    WM_MENUGETOBJECT:          result:='WM_MENUGETOBJECT';
    WM_MENURBUTTONUP:          result:='WM_MENURBUTTONUP';
    WM_MENUSELECT:             result:='WM_MENUSELECT';
    WM_MOUSEACTIVATE:          result:='WM_MOUSEACTIVATE';
    WM_MOUSEHOVER:             result:='WM_MOUSEHOVER';
    WM_MOUSELEAVE:             result:='WM_MOUSELEAVE';
    WM_MOUSEMOVE:              result:='WM_MOUSEMOVE';
    WM_MOUSEWHEEL:             result:='WM_MOUSEWHEEL';
    WM_MOVE:                   result:='WM_MOVE';
    WM_MOVING:                 result:='WM_MOVING';
    WM_NCACTIVATE:             result:='WM_NCACTIVATE';
    WM_NCCALCSIZE:             result:='WM_NCCALCSIZE';
    WM_NCCREATE:               result:='WM_NCCREATE';
    WM_NCDESTROY:              result:='WM_NCDESTROY';
    WM_NCHITTEST:              result:='WM_NCHITTEST';
    WM_NCLBUTTONDBLCLK:        result:='WM_NCLBUTTONDBLCLK';
    WM_NCLBUTTONDOWN:          result:='WM_NCLBUTTONDOWN';
    WM_NCLBUTTONUP:            result:='WM_NCLBUTTONUP';
    WM_NCMBUTTONDBLCLK:        result:='WM_NCMBUTTONDBLCLK';
    WM_NCMBUTTONDOWN:          result:='WM_NCMBUTTONDOWN';
    WM_NCMBUTTONUP:            result:='WM_NCMBUTTONUP';
    WM_NCMOUSEMOVE:            result:='WM_NCMOUSEMOVE';
    WM_NCPAINT:                result:='WM_NCPAINT';
    WM_NCRBUTTONDBLCLK:        result:='WM_NCRBUTTONDBLCLK';
    WM_NCRBUTTONDOWN:          result:='WM_NCRBUTTONDOWN';
    WM_NCRBUTTONUP:            result:='WM_NCRBUTTONUP';
    WM_NEXTDLGCTL:             result:='WM_NEXTDLGCTL';
    WM_NEXTMENU:               result:='WM_NEXTMENU';
    WM_NOTIFY:                 result:='WM_NOTIFY';
    WM_NOTIFYFORMAT:           result:='WM_NOTIFYFORMAT';
    WM_PAINT:                  result:='WM_GETTEXT';
    WM_PAINTCLIPBOARD:         result:='WM_PAINTCLIPBOARD';
    WM_PAINTICON:              result:='WM_PAINTICON';
    WM_PALETTECHANGED:         result:='WM_PALETTECHANGED';
    WM_PALETTEISCHANGING:      result:='WM_PALETTEISCHANGING';
    WM_PARENTNOTIFY:           result:='WM_PARENTNOTIFY';
    WM_PASTE:                  result:='WM_PASTE';
    WM_PENWINFIRST:            result:='WM_PENWINFIRST';
    WM_PENWINLAST:             result:='WM_PENWINLAST';
    WM_POWER:                  result:='WM_POWER';
    WM_POWERBROADCAST:         result:='WM_POWERBROADCAST';
    WM_PRINT:                  result:='WM_PRINT';
    WM_PRINTCLIENT:            result:='WM_PRINTCLIENT';
    WM_QUERYDRAGICON:          result:='WM_QUERYDRAGICON';
    WM_QUERYENDSESSION:        result:='WM_QUERYENDSESSION';
    WM_QUERYNEWPALETTE:        result:='WM_QUERYNEWPALETTE';
    WM_QUERYOPEN:              result:='WM_QUIT';
    WM_QUEUESYNC:              result:='WM_QUEUESYNC';
    WM_QUIT:                   result:='WM_QUIT';
    WM_RBUTTONDBLCLK:          result:='WM_RBUTTONDBLCLK';
    WM_RBUTTONDOWN:            result:='WM_RBUTTONDOWN';
    WM_RBUTTONUP:              result:='WM_RBUTTONUP';
    WM_RENDERALLFORMATS:       result:='WM_RENDERALLFORMATS';
    WM_RENDERFORMAT:           result:='WM_RENDERFORMAT';
    WM_SETCURSOR:              result:='WM_SETCURSOR';
    WM_SETFOCUS:               result:='WM_ACTIVATE';
    WM_SETFONT:                result:='WM_SETFONT';
    WM_SETHOTKEY:              result:='WM_SETHOTKEY';
    WM_SETICON:                result:='WM_SETICON';
    WM_SETREDRAW:              result:='WM_SETREDRAW';
    WM_SETTEXT:                result:='WM_SETREDRAW';
    WM_SHOWWINDOW:             result:='WM_SHOWWINDOW';
    WM_SIZE:                   result:='WM_MOVE';
    WM_SIZECLIPBOARD:          result:='WM_SIZECLIPBOARD';
    WM_SIZING:                 result:='WM_SIZING';
    WM_SPOOLERSTATUS:          result:='WM_SPOOLERSTATUS';
    WM_STYLECHANGED:           result:='WM_STYLECHANGED';
    WM_STYLECHANGING:          result:='WM_STYLECHANGING';
    WM_SYSCHAR:                result:='WM_SYSCHAR';
    WM_SYSCOLORCHANGE:         result:='WM_QUIT';
    WM_SYSCOMMAND:             result:='WM_SYSCOMMAND';
    WM_SYSDEADCHAR:            result:='WM_SYSDEADCHAR';
    WM_SYSKEYDOWN:             result:='WM_SYSKEYDOWN';
    WM_SYSKEYUP:               result:='WM_SYSKEYUP';
    WM_SYSTEMERROR:            result:='WM_SYSTEMERROR';
    WM_TCARD:                  result:='WM_TCARD';
    WM_TIMECHANGE:             result:='WM_TIMECHANGE';
    WM_TIMER:                  result:='WM_TIMER';
    WM_UNDO:                   result:='WM_UNDO';
    WM_UNINITMENUPOPUP:        result:='WM_UNINITMENUPOPUP';
    WM_USERCHANGED:            result:='WM_USERCHANGED';
    WM_VKEYTOITEM:             result:='WM_VKEYTOITEM';
    WM_VSCROLL:                result:='WM_VSCROLL';
    WM_VSCROLLCLIPBOARD:       result:='WM_VSCROLLCLIPBOARD';
    WM_WINDOWPOSCHANGED:       result:='WM_WINDOWPOSCHANGED';
    WM_WINDOWPOSCHANGING:      result:='WM_WINDOWPOSCHANGING';
    WM_WININICHANGE:           result:='WM_WININICHANGE';
    else                       result:='$'+inttohex(msg,4);
  end;
end;

function InvertMatrix(matrix: T2DArray): T2DArray;
var
   big,dum,pivinv: double;
   i,icol,irow,j,k,l,ll: integer;
   indxc,indxr,ipiv: array[1..1000] of integer;
begin
  result:=CopyMatrix(matrix);

  for j := 1 to high(result) do
    ipiv[j] := 0;
  for i := 1 to high(result) do
  begin
    big := 0.0;
    for j := 1 to high(result) do
      if (ipiv[j] <> 1) then
        for k := 1 to high(result) do
          if (ipiv[k] = 0) then
          begin
            if (abs(result[j,k]) >= big) then
            begin
              big := abs(result[j,k]);
              irow := j;
              icol := k
            end;
          end else if (ipiv[k] > 1) then
            begin result:=nil; exit; end;
    ipiv[icol] := ipiv[icol]+1;
    if (irow <> icol) then
    for l := 1 to high(result) do
    begin
      dum := result[irow,l];
      result[irow,l] := result[icol,l];
      result[icol,l] := dum
    end;
    indxr[i] := irow;
    indxc[i] := icol;
    if (result[icol,icol] = 0.0) then
      begin result:=nil; exit; end;
    pivinv := 1.0/result[icol,icol];
    result[icol,icol] := 1.0;
    for l := 1 to high(result) do
      result[icol,l] := result[icol,l]*pivinv;
    for ll := 1 to high(result) do
      if (ll <> icol) then
      begin
        dum := result[ll,icol];
        result[ll,icol] := 0.0;
        for l := 1 to high(result) do
          result[ll,l] := result[ll,l]-result[icol,l]*dum
      end;
  end;
  for l := high(result) DOWNTO 1 do
    if (indxr[l] <> indxc[l]) then
      for k := 1 to high(result) do
      begin
        dum := result[k,indxr[l]];
        result[k,indxr[l]] := result[k,indxc[l]];
        result[k,indxc[l]] := dum
      end;
end;

function MultMatrixMatrix(A,B: T2DArray): T2DArray;
{ result:=A*B
    A: array [1..n, 1..m] of double;
    B: array [1..r, 1..n] of double;
    result: array [1..r, 1..m] of double; }
var i,j,k: integer;
begin
  result:=Make2DArray(length(B),length(A[0]));

  for j:=1 to high(A[0]) do
    for k:=1 to high(B) do
      result[k,j]:=0;
  for i:=1 to high(A) do
    for j:=1 to high(A[0]) do
      for k:=1 to high(B) do
        result[k,j]:=result[k,j]+a[i,j]*B[k,i];
end;

function MultMatrixVector(A: T2DArray; B: TArrayofDouble): TArrayofDouble;
{ C:=A*B
    A: array [1..n, 1..m] of double;
    B: array [1..n] of double;
    C: array [1..m] of double; }
var i,j: integer;
begin
  result:=Make1DArray(length(A[0]));

  for j:=1 to high(A[0]) do
      result[j]:=0;
  for i:=1 to high(A) do
    for j:=1 to high(A[0]) do
      result[j]:=result[j]+a[i,j]*B[i];
end;

function DotProductVector(A,B: TArrayofDouble): double;
{ type of amatrix must be
    A: array [1..n, 1..n] of double;
    B: array [1..n, 1..n] of double;}
var i: integer;
begin
  result:=0;
  for i:=1 to high(A) do
    result:=result+A[i]*B[i];
end;

function Make1DArray(x: integer): TArrayofDouble;
begin
  setlength(result,x+1);
  fillchar(result[0],sizeof(result[0])*x,0);
end;

function Make2DArray(x,y: integer): T2DArray;
var i: integer;
begin
  Setlength(result,x+1);
  for i:=0 to high(result) do
  begin
    result[i]:=Make1DArray(y);
    fillchar(result[i,0],length(result[i])*sizeof(result[i]),0);
  end;
end;

function Make3DArray(x,y,z: integer): T3DArray;
var i: integer;
begin
  Setlength(result,x+1);
  for i:=0 to high(result) do
    result[i]:=Make2DArray(y,z);
end;

function CopyMatrix(B: T2DArray): T2DArray;
{A:=B}
var i,j: integer;
begin
  SetLength(result,Length(B));
  for i:=0 to high(result) do
  begin
    SetLength(result[i],Length(B[i]));
    for j:=0 to high(result[i]) do
      result[i,j]:=b[i,j];
  end;
end;

procedure Quicksort(var arr: array of integer);
  { this does the actual work of the Quicksort. it takes the
   parameters which define the range of the array to work on,
   and references the array as a global. }
  procedure QuicksortRecur(start, stop: integer);
  var m: integer; { the location separating the high and low parts. }
      splitpt: integer; { the Quicksort split algorithm. takes the range, and returns the split point. }
    function split(start, stop: integer): integer;
      var left, right: integer;    { scan pointers. }
        pivot: integer;       { pivot value. }
      function LT(a,b: integer): boolean;
      begin
        result:=a < b;
      end;
      procedure swap(var a, b: integer); { interchange the parameters. }
      var t: integer;
      begin
        t := a;
        a := b;
        b := t
      end;
    begin { split }
      { set up the pointers for the hight and low sections, and
       get the pivot value. }
      pivot := arr[start];
      left := start + 1;
      right := stop;

      { look for pairs out of place and swap 'em. }
      while left <= right do begin
        while (left <= stop) and LT(arr[left],pivot) do
          left := left + 1;
        while (right > start) and not LT(arr[right],pivot) do
          right := right - 1;
        if left < right then
          swap(arr[left], arr[right]);
      end;

      { put the pivot between the halves. }
      swap(arr[start], arr[right]);

      { this is how you return function values in pascal.
       yeccch. }
      split := right
    end;

  begin { QuicksortRecur }
    { if there's anything to do... }
    if start < stop then begin
      splitpt := split(start, stop);
      QuicksortRecur(start, splitpt-1);
      QuicksortRecur(splitpt+1, stop);
    end
  end;
begin { Quicksort }
  QuicksortRecur(0, high(arr))
end;

procedure T_Test(mean1,mean2,var1,var2: double; n1,n2: integer; var t: double; var dof: integer);
{2-tailed test assuming unequal variances and unequal sample sizes; uses the Welch-Satterthwaite equation}
begin
  t:=abs((mean1-mean2)/sqrt(var1/n1+var2/n2));
  dof:=round((sqr(var1/n1+var2/n2))/(sqr(var1/n1)/(n1-1)+sqr(var2/n2)/(n2-1)));
end;

function Mean(sx,n: double): double;
begin
  result:=sx/n;
end;

function Variance(sx,sxx,n: double): double;
begin
  result:=(sxx-sqr(sx)/n)/(n-1);
end;

function StandardDeviation(sx,sxx,n: double): double;
begin
  result:=sqrt(Variance(sx,sxx,n));
end;

function Skew(sx,sxx,sxxx,n: double): double;
{Pearson's moment coefficient of skewness}
{result is dimensionless}
var m,sd: double;
begin
  m:=Mean(sx,n);
  sd:=StandardDeviation(sx,sxx,n);
  result:=(sxxx-3*m*sd*sd-m*m*m)/(sd*sd*sd)/n;
end;

function Skewness(sx,sxx,sxxx,n: double): double;
{mean-skewness/2 is approximately equal to mode}
{or maybe mean-skewness/3 is approximately equal to mode}
{maybe mean-skewness/4 is approximately equal to median}
var m: double;
begin
  m:=Mean(sx,n);
  result:=(+sxxx-3*sxx*m+3*sx*m*m-n*m*m*m)/n;
  result:=CubeRoot(result);
end;

// Since a NAN is not a single, unique value, a special function is
// needed for this test
FUNCTION IsNanDouble(CONST d: DOUBLE): BOOLEAN;
  VAR
    Overlay: Int64 ABSOLUTE d;
BEGIN
  RESULT :=
    ((Overlay AND $7FF0000000000000)  = $7FF0000000000000) AND
    ((Overlay AND $000FFFFFFFFFFFFF) <> $0000000000000000)
END {IsNAN};

// Like a NaN, an INF Double value has an exponent of 7FF, but the INF
// values have a fraction field of 0. INF values can be positive or
// negative, which is specified in the high-order, sign bit.
FUNCTION IsInfinityDouble(CONST d: DOUBLE): BOOLEAN;
  VAR
    Overlay: Int64 ABSOLUTE d;
BEGIN
  RESULT :=
    ((Overlay AND $7FF0000000000000) = $7FF0000000000000) AND
    ((Overlay AND $000FFFFFFFFFFFFF) = $0000000000000000)
END {IsInfinity};

FUNCTION IsNanSingle(CONST d: Single): BOOLEAN;
VAR Overlay: integer ABSOLUTE d;
BEGIN
  RESULT :=
    ((Overlay AND $7F800000) =  $7F800000) AND
    ((Overlay AND $7FFFFFFF) <> $7F800000);
END;

FUNCTION IsInfinitySingle(CONST d: Single): BOOLEAN;
VAR Overlay: integer ABSOLUTE d;
BEGIN
  RESULT :=(Overlay AND $7FFFFFFF) = $7F800000;
END {IsInfinity};

function SlowDownSoundData(s: string; SamplesPerSec,BitsPerSample,Channels,speed: integer): string;
type TSndByte = array[0..1] of byte;
type TSndSmallInt = array[0..1] of SmallInt;
var ch,len,kSnd,iSnd,piSnd,maxGrainLen,maxSnd,pSnd,Snd: integer;
    ah8,bh8: ^TSndByte;
    ah16: ^TSndSmallInt absolute ah8;
    bh16: ^TSndSmallInt absolute bh8;
    midSnd,hiSnd,decay: single;
    first: boolean;
begin
  getmem(ah8,length(s));
  getmem(bh8,length(s)*speed);
//  move(s[1],ah8^,min(length(s),sizeof(ah8^)));
//  move(s[1],bh8^,min(length(s),sizeof(TWaveHeaderRec)+sizeof(TDataHeaderRec)));
  move(s[1],ah8^,length(s));
  move(s[1],bh8^,sizeof(TWaveHeaderRec)+sizeof(TDataHeaderRec));

  decay:=exp(-20/SamplesPerSec);
  maxGrainLen:=Channels*SamplesPerSec div 20;

  for ch:=0 to Channels-1 do
  begin
    kSnd:=ch;
    iSnd:=ch;
    piSnd:=iSnd;
    maxSnd:=0;
    hiSnd:=128;
    midSnd:=128;
    first:=true;
    len:=length(s)*8 div BitsPerSample;
    while (iSnd < len) and (kSnd < len*speed) do
    begin
      {$R-}
      if BitsPerSample = 8 then
      begin
        Snd:=ah8^[iSnd];
        bh8^[kSnd]:=Snd;
      end else
      begin
        Snd:=ah16^[iSnd];
        bh16^[kSnd]:=Snd;
      end;
      {$R+}

      inc(kSnd,Channels);

      if first then
      begin
        maxSnd:=Snd;
        hiSnd:=Snd;
        midSnd:=Snd;
        first:=false;
      end;

      maxSnd:=max(maxSnd,Snd);
      hiSnd:=max(decay*hiSnd+(1-decay)*midSnd,Snd);
      midSnd:=midSnd*decay+Snd*(1-decay);

      if (Snd > midSnd) and (pSnd <= midSnd) and ((maxSnd > hiSnd) or (iSnd > piSnd+maxGrainLen)) then
      begin
        if kSnd < iSnd*speed then
          iSnd:=piSnd else
          piSnd:=iSnd;
        maxSnd:=0;
      end;

      inc(iSnd,Channels);
      pSnd:=Snd;
    end;

    while kSnd < len*speed do
    begin
      {$R-}
      if BitsPerSample = 8 then
        bh8^[kSnd]:=Snd else
        bh16^[kSnd]:=Snd;
      {$R+}
      inc(kSnd,Channels);
    end;
  end;

  setlength(result,length(s)*speed);
  move(bh8^,result[1],length(result));
  freemem(ah8,length(s));
  freemem(bh8,length(s)*speed);
end;

function SlowDownSoundData2(s: string; SamplesPerSec,BitsPerSample,Channels,speed: integer): string;
type TSndByte = array[0..1] of byte;
type TSndSmallInt = array[0..1] of SmallInt;
var ch,len,kSnd,iSnd,piSnd,minGrainLen,pSnd,Snd: integer;
    ah8,bh8: ^TSndByte;
    ah16: ^TSndSmallInt absolute ah8;
    bh16: ^TSndSmallInt absolute bh8;
    midSnd,decay: single;
    first: boolean;
begin
  getmem(ah8,length(s));
  getmem(bh8,length(s)*speed);
//  move(s[1],ah8^,min(length(s),sizeof(ah8^)));
//  move(s[1],bh8^,min(length(s),sizeof(TWaveHeaderRec)+sizeof(TDataHeaderRec)));
  move(s[1],ah8^,length(s));
  move(s[1],bh8^,sizeof(TWaveHeaderRec)+sizeof(TDataHeaderRec));

  decay:=exp(-20/SamplesPerSec);
  minGrainLen:=Channels*SamplesPerSec div 100;

  for ch:=0 to Channels-1 do
  begin
    kSnd:=ch;
    iSnd:=ch;
    piSnd:=iSnd;
    midSnd:=128;
    first:=true;
    len:=length(s)*8 div BitsPerSample;
    while (iSnd < len) and (kSnd < len*speed) do
    begin
      {$R-}
      if BitsPerSample = 8 then
      begin
        Snd:=ah8^[iSnd];
        bh8^[kSnd]:=Snd;
      end else
      begin
        Snd:=ah16^[iSnd];
        bh16^[kSnd]:=Snd;
      end;
      {$R+}

      inc(kSnd,Channels);

      if first then
      begin
        midSnd:=Snd;
        first:=false;
      end;

      midSnd:=midSnd*decay+Snd*(1-decay);

      if (Snd > midSnd) and (pSnd <= midSnd) and (iSnd > piSnd+minGrainLen) then
      begin
        if kSnd < iSnd*speed then
          iSnd:=piSnd else
          piSnd:=iSnd;
      end;

      inc(iSnd,Channels);
      pSnd:=Snd;
    end;

    while kSnd < len*speed do
    begin
      {$R-}
      if BitsPerSample = 8 then
        bh8^[kSnd]:=Snd else
        bh16^[kSnd]:=Snd;
      {$R+}
      inc(kSnd,Channels);
    end;
  end;

  setlength(result,length(s)*speed);
  move(bh8^,result[1],length(result));
  freemem(ah8,length(s));
  freemem(bh8,length(s)*speed);
end;

function SlowDownSoundData3(s: string; SamplesPerSec,BitsPerSample,Channels,speed: integer): string;
type TSndByte = array[0..1] of byte;
type TSndSmallInt = array[0..1] of SmallInt;
var ch,len,kSnd,iSnd,piSnd,maxGrainLen,Snd1: integer;
    ah8,bh8: ^TSndByte;
    ah16: ^TSndSmallInt absolute ah8;
    bh16: ^TSndSmallInt absolute bh8;
    midSnd,hiSnd,decay,maxSnd,pSnd,Snd2a,Snd2b,Snd2c: single;
    first: boolean;
    hist: array[0..10000] of single;
    prevZC: array[0..10] of integer;
  function BestPrev(iSnd: integer): integer;
  var n,m,i,j: integer;
  const q: single = 80;
  begin
    i:=iSnd div Channels;
    if i > prevZC[0] then
    begin
      move(prevZC[0],prevZC[1],(length(prevZC)-1)*sizeof(prevZC[0]));
      prevZC[0]:=i;
    end;

    n:=Channels*SamplesPerSec div 100;
    m:=min(n*20,high(hist));
    if prevZC[0] > m then
    begin
      for i:=1 to m do
        hist[i]:=hist[i]*0.9;
      for i:=1 to high(prevZC) do
        for j:=-100 to 100 do
        if InRange(prevZC[0]-prevZC[i]+j,0,m) then
        begin
          hist[prevZC[0]-prevZC[i]+j]:=hist[prevZC[0]-prevZC[i]+j]+(100-abs(j))/i;
        end;

      j:=n;
      for i:=n to m do
        if hist[i] > hist[j] then
          j:=i;
      q:=q*0.99+(1-0.99)*j;
      result:=iSnd-round(q)*Channels;
    end else
      result:=iSnd;
  end;
begin
  getmem(ah8,length(s));
  getmem(bh8,length(s)*speed);
//  move(s[1],ah8^,min(length(s),sizeof(ah8^)));
//  move(s[1],bh8^,min(length(s),sizeof(TWaveHeaderRec)+sizeof(TDataHeaderRec)));
  move(s[1],ah8^,length(s));
  move(s[1],bh8^,sizeof(TWaveHeaderRec)+sizeof(TDataHeaderRec));

  decay:=exp(-20/SamplesPerSec);
  maxGrainLen:=Channels*SamplesPerSec div 20;
  fillchar(hist,sizeof(hist),0);
  fillchar(prevZC,sizeof(prevZC),0);

  for ch:=0 to Channels-1 do
  begin
    kSnd:=ch;
    iSnd:=ch;
    piSnd:=iSnd;
    maxSnd:=0;
    hiSnd:=128;
    midSnd:=128;
    first:=true;
    len:=length(s)*8 div BitsPerSample;

    while (iSnd < len) and (kSnd < len*speed) do
    begin
      {$R-}
      if BitsPerSample = 8 then
      begin
        Snd1:=ah8^[iSnd];
        bh8^[kSnd]:=Snd1;
      end else
      begin
        Snd1:=ah16^[iSnd];
        bh16^[kSnd]:=Snd1;
      end;
      {$R+}

      inc(kSnd,Channels);

      if first then
      begin
        Snd2a:=Snd1;
        Snd2b:=Snd1;
        maxSnd:=Snd1;
        hiSnd:=Snd1;
        midSnd:=Snd1;
        first:=false;
      end;

      Snd2a:=Snd2a*0.999+Snd1*(1-0.999);
      Snd2b:=Snd2b*0.998+Snd1*(1-0.998);
      Snd2c:=Snd2a-Snd2b;
//      Snd2c:=Snd2a;


      maxSnd:=max(maxSnd,Snd2c);
      hiSnd:=max(decay*hiSnd+(1-decay)*midSnd,Snd2c);
      midSnd:=midSnd*decay+Snd2c*(1-decay);

//      if (Snd2c > midSnd) and (pSnd <= midSnd) and ((maxSnd > hiSnd) or (iSnd > piSnd+maxGrainLen)) then
      if (Snd2c > midSnd) and (pSnd <= midSnd) and (iSnd > piSnd+Channels*SamplesPerSec div 100) then
      begin
{
        if kSnd < iSnd*speed then
          iSnd:=piSnd else
          piSnd:=iSnd;
}
        if kSnd < iSnd*speed then
          iSnd:=BestPrev(iSnd);
        maxSnd:=0;
      end;

      inc(iSnd,Channels);
      pSnd:=Snd2c;
    end;

    while kSnd < len*speed do
    begin
      {$R-}
      if BitsPerSample = 8 then
        bh8^[kSnd]:=Snd1 else
        bh16^[kSnd]:=Snd1;
      {$R+}
      inc(kSnd,Channels);
    end;
  end;

  setlength(result,length(s)*speed);
  move(bh8^,result[1],length(result));
  freemem(ah8,length(s));
  freemem(bh8,length(s)*speed);
end;

function AddHeaderStr(s: string; aSampleRate,aBitsPerSample,aChannels: integer): string;
begin
  result:=AddHeaderMem(s[1],length(s),aSampleRate,aBitsPerSample,aChannels);
end;

function AddHeaderMem(var mem; len,aSampleRate,aBitsPerSample,aChannels: integer): string;
var WaveHeader: TWaveHeaderRec;
    DataHeader: TDataHeaderRec;
begin
  if len = 0 then
  begin
    result:='';
    exit;
  end;
  
  with DataHeader do
  begin
    data[1]:='d'; data[2]:='a'; data[3]:='t'; data[4]:='a';
    datasize:=len;
  end;

  with WaveHeader do
  begin
    RIFF[1]:='R'; RIFF[2]:='I'; RIFF[3]:='F'; RIFF[4]:='F';
    {is this right?:}
    filesize:=DataHeader.datasize+sizeof(WaveHeader);
    WAVE[1]:='W'; WAVE[2]:='A'; WAVE[3]:='V'; WAVE[4]:='E';
    fmtb[1]:='f'; fmtb[2]:='m'; fmtb[3]:='t'; fmtb[4]:=' ';
    hdrsize:=sizeof(WaveHeader)-(longint(@format)-longint(@WaveHeader));
    format:=1;
    Channels:=aChannels;
    SamplesPerSec:=aSampleRate;
    AvgBytesPerSec:=aSampleRate;
    BlockAlignment:=1;
    BitsPerSample:=aBitsPerSample;
  end;

  setlength(result,len);
  move(mem,result[1],len);
  result:=DataToString(WaveHeader,sizeof(WaveHeader))+DataToString(DataHeader,sizeof(DataHeader))+result;
end;

function SlowDownSound(s: string; speed: integer): string;
{s is the contents of a WAV file}
var hdr: record whr: TWaveHeaderRec; dhr: TDataHeaderRec; end;
    t: string;
    i: integer;
begin
{
  move(s[1],hdr,sizeof(hdr));
  t:=copy(s,sizeof(hdr)+1,maxint);
  t:=SlowDownSoundData(t,hdr.whr.SamplesPerSec,hdr.whr.BitsPerSample,hdr.whr.Channels,speed);
  hdr.dhr.datasize:=hdr.dhr.datasize*speed;
  result:=MemoryToString(hdr,sizeof(hdr))+t;
}
  move(s[1],hdr,sizeof(hdr));
  t:=copy(s,1+sizeof(hdr),maxint);
  t:=SlowDownSoundData(t,hdr.whr.SamplesPerSec,hdr.whr.BitsPerSample,hdr.whr.Channels,speed);
  hdr.dhr.datasize:=hdr.dhr.datasize*speed;
//  result:=MemoryToString(hdr,sizeof(hdr))+t;
  result:=AddHeaderStr(t,hdr.whr.SamplesPerSec,hdr.whr.BitsPerSample,hdr.whr.Channels);
end;

function SlowDownSound2(s: string; speed: integer): string;
{s is the contents of a WAV file}
var hdr: record whr: TWaveHeaderRec; dhr: TDataHeaderRec; end;
    t: string;
begin
  move(s[1],hdr,sizeof(hdr));
  t:=copy(s,sizeof(hdr)+1,maxint);
  t:=SlowDownSoundData2(t,hdr.whr.SamplesPerSec,hdr.whr.BitsPerSample,hdr.whr.Channels,speed);
  hdr.dhr.datasize:=hdr.dhr.datasize*speed;
  result:=MemoryToString(hdr,sizeof(hdr))+t;
end;

function SlowDownSound3(s: string; speed: integer): string;
{s is the contents of a WAV file}
var hdr: record whr: TWaveHeaderRec; dhr: TDataHeaderRec; end;
    t: string;
begin
  move(s[1],hdr,sizeof(hdr));
  t:=copy(s,sizeof(hdr)+1,maxint);
  t:=SlowDownSoundData3(t,hdr.whr.SamplesPerSec,hdr.whr.BitsPerSample,hdr.whr.Channels,speed);
  hdr.dhr.datasize:=hdr.dhr.datasize*speed;
  result:=AddHeaderStr(t,hdr.whr.SamplesPerSec,hdr.whr.BitsPerSample,hdr.whr.Channels);
end;

function GetSpecialFolderPath(Folder: Integer; CanCreate: Boolean): string;
//  CSIDL_DESKTOP                       = $0000; { <desktop> }
//  CSIDL_INTERNET                      = $0001; { Internet Explorer (icon on desktop) }
//  CSIDL_PROGRAMS                      = $0002; { Start Menu\Programs }
//  CSIDL_CONTROLS                      = $0003; { My Computer\Control Panel }
//  CSIDL_PRINTERS                      = $0004; { My Computer\Printers }
//  CSIDL_PERSONAL                      = $0005; { My Documents.  This is equivalent to CSIDL_MYDOCUMENTS in XP and above }
//  CSIDL_FAVORITES                     = $0006; { <user name>\Favorites }
//  CSIDL_STARTUP                       = $0007; { Start Menu\Programs\Startup }
//  CSIDL_RECENT                        = $0008; { <user name>\Recent }
//  CSIDL_SENDTO                        = $0009; { <user name>\SendTo }
//  CSIDL_BITBUCKET                     = $000a; { <desktop>\Recycle Bin }
//  CSIDL_STARTMENU                     = $000b; { <user name>\Start Menu }
//  CSIDL_MYDOCUMENTS                   = $000c; { logical "My Documents" desktop icon }
//  CSIDL_MYMUSIC                       = $000d; { "My Music" folder }
//  CSIDL_MYVIDEO                       = $000e; { "My Video" folder }
//  CSIDL_DESKTOPDIRECTORY              = $0010; { <user name>\Desktop }
//  CSIDL_DRIVES                        = $0011; { My Computer }
//  CSIDL_NETWORK                       = $0012; { Network Neighborhood (My Network Places) }
//  CSIDL_NETHOOD                       = $0013; { <user name>\nethood }
//  CSIDL_FONTS                         = $0014; { windows\fonts }
//  CSIDL_TEMPLATES                     = $0015;
//  CSIDL_COMMON_STARTMENU              = $0016; { All Users\Start Menu }
//  CSIDL_COMMON_PROGRAMS               = $0017; { All Users\Start Menu\Programs }
//  CSIDL_COMMON_STARTUP                = $0018; { All Users\Startup }
//  CSIDL_COMMON_DESKTOPDIRECTORY       = $0019; { All Users\Desktop }
//  CSIDL_APPDATA                       = $001a; { <user name>\Application Data }
//  CSIDL_PRINTHOOD                     = $001b; { <user name>\PrintHood }
//  CSIDL_LOCAL_APPDATA                 = $001c; { <user name>\Local Settings\Application Data (non roaming) }
//  CSIDL_ALTSTARTUP                    = $001d; { non localized startup }
//  CSIDL_COMMON_ALTSTARTUP             = $001e; { non localized common startup }
//  CSIDL_COMMON_FAVORITES              = $001f;
//  CSIDL_INTERNET_CACHE                = $0020;
//  CSIDL_COOKIES                       = $0021;
//  CSIDL_HISTORY                       = $0022;
//  CSIDL_COMMON_APPDATA                = $0023; { All Users\Application Data }
//  CSIDL_WINDOWS                       = $0024; { GetWindowsDirectory() }
//  CSIDL_SYSTEM                        = $0025; { GetSystemDirectory() }
//  CSIDL_PROGRAM_FILES                 = $0026; { C:\Program Files }
//  CSIDL_MYPICTURES                    = $0027; { C:\Program Files\My Pictures }
//  CSIDL_PROFILE                       = $0028; { USERPROFILE }
//  CSIDL_SYSTEMX86                     = $0029; { x86 system directory on RISC }
//  CSIDL_PROGRAM_FILESX86              = $002a; { x86 C:\Program Files on RISC }
//  CSIDL_PROGRAM_FILES_COMMON          = $002b; { C:\Program Files\Common }
//  CSIDL_PROGRAM_FILES_COMMONX86       = $002c; { x86 C:\Program Files\Common on RISC }
//  CSIDL_COMMON_TEMPLATES              = $002d; { All Users\Templates }
//  CSIDL_COMMON_DOCUMENTS              = $002e; { All Users\Documents }
//  CSIDL_COMMON_ADMINTOOLS             = $002f; { All Users\Start Menu\Programs\Administrative Tools }
//  CSIDL_ADMINTOOLS                    = $0030; { <user name>\Start Menu\Programs\Administrative Tools }
//  CSIDL_CONNECTIONS                   = $0031; { Network and Dial-up Connections }
//  CSIDL_COMMON_MUSIC                  = $0035; { All Users\My Music }
//  CSIDL_COMMON_PICTURES               = $0036; { All Users\My Pictures }
//  CSIDL_COMMON_VIDEO                  = $0037; { All Users\My Video }
//  CSIDL_RESOURCES                     = $0038; { Resource Directory }
//  CSIDL_RESOURCES_LOCALIZED           = $0039; { Localized Resource Directory }
//  CSIDL_COMMON_OEM_LINKS              = $003a; { Links to All Users OEM specific apps }
//  CSIDL_CDBURN_AREA                   = $003b; { USERPROFILE\Local Settings\Application Data\Microsoft\CD Burning }
//  CSIDL_COMPUTERSNEARME               = $003d; { Computers Near Me (computered from Workgroup membership) }
//  CSIDL_PROFILES                      = $003e;
var
   FilePath: array [0..255] of char;
begin
 SHGetSpecialFolderPath(0, @FilePath[0], FOLDER, CanCreate);
 Result := FilePath;
end;

function CountSet(s: TSetOfByte): Byte;
var b: Byte;
begin
  result:=0;
  for b:=0 to 255 do
    if b in s then
      inc(result);
end;

function gaussian_eliminate(var a: T2DArray): boolean;
{     for solving linear simultaneous equs of the form
        z + 3w + 7x + 2y = 0
      if imax is 5 then matrix should be of the form array [1..5,0..5] of double
      result will have the form:
        0  0  0  0  0  0
        d -1  0  0  0  0
        e  0 -1  0  0  0
        f  0  0 -1  0  0
        g  0  0  0 -1  0
        h  0  0  0  0 -1
      where in a[i,j], i is vertical axis and j is horizontal axis

  say you have three unknowns r,s,t
  so there are equations
      r*x1  + s*y1  + t*z1 = k1
      r*x2  + s*y2  + t*z2 = k2
      r*x3  + s*y3  + t*z3 = k3
  then set up the array like this
      a:=Make2DArray(3,3);
      a[1,0]:=-k1; a[1,1]:=x1; a[1,2]:=y1; a[1,3]:=z1;
      a[2,0]:=-k2; a[2,2]:=x2; a[2,2]:=y2; a[2,3]:=z2;
      a[3,0]:=-k3; a[3,3]:=x3; a[3,3]:=y3; a[3,3]:=z3;
      gaussian_eliminate(a);
  and the answer is in
      r = a[1,0]
      s = a[2,0]
      t = a[3,0]
}
  var i,j,k,l: integer;
      r: double;
begin
  gaussian_eliminate:=false;
  for k:=1 to high(a) do
  begin
    { swap to biggest pivot }
    l:=k;
    for i:=k+1 to high(a) do
      if abs(a[i,k]) > abs(a[l,k]) then l:=i;
    if l <> k then
    for j:=0 to high(a) do
      begin r:=a[k,j]; a[k,j]:=a[l,j]; a[l,j]:=r; end;

    { set diagonal element to -1 }
    if a[k,k] = 0 then exit;
    r:=-1/a[k,k];
    for j:=0 to high(a) do
      a[k,j]:=a[k,j]*r;

    { set lower part of column to 0 }
    for i:=1 to high(a) do
    if (i <> k) and (a[i,k] <> 0) then
    begin
      r:=a[i,k];
      for j:=0 to high(a) do
        a[i,j]:=a[i,j]+a[k,j]*r;
    end;
  end;

  gaussian_eliminate:=true;
end;

(*
procedure RegressionNInit;
{ var ans: array[0..M] of double;
  RegressionNInit;
  for k:=1 to N do
  begin
    p:=random; // independent variable
    q:=random; // independent variable
    r:=random; // independent variable
    s:=random; // independent variable
    z:=d+e*p+f*q+g*r+h*s+random/10; // dependent variable; defgh are constants
    RegressionNData([z,p,q,r,s]);
  end;
  if RegressionNAnswer(ans) then
    ... ans[0..4] are d,e,f,g,h
}
begin
  with RegressionN_rec do
    N:=0;
end;

procedure RegressionNData(x: array of double);
var i,j: integer;
begin
  with RegressionN_rec do
  begin
    if n = 0 then
    begin
      M:=high(x);
      SetLength(a,M+1);
      for i:=0 to M do
        SetLength(a[i],M+1);
      SetLength(SS,M+1);
      for i:=0 to M do
        SetLength(SS[i],M+1);
      SetLength(S,M+1);

      for i:=0 to M do
        for j:=0 to M do
          SS[i,j]:=0;
      for i:=0 to M do
        S[i]:=0;
    end;

    assert(M = high(x));

    inc(N);

    for i:=0 to M do
    begin
      for j:=1 to M do
        SS[i,j]:=SS[i,j]+x[i]*x[j];
      S[i]:=S[i]+x[i];
    end;
  end;
end;

function RegressionNAnswer(var ans: array of double): boolean;
var i,j: integer;
begin
  with RegressionN_rec do
if N > M then
//  if N > 0 then
  begin
    assert(M = high(ans),'Regression: ans should be array[0..'+inttostr(M)+'] of double');
    assert(N > M,'Regression: should have at least '+inttostr(M+1)+' data points');

    for i:=0 to M do
      for j:=1 to M do
        A[j,i]:=SS[i,j]-S[i]*S[j]/N;

    result:=gaussian_eliminate(a);
    if result then
    begin
      ans[0]:=S[0];
      for i:=0 to M do
        ans[0]:=ans[0]+a[i,0]*S[i];
      ans[0]:=ans[0]/N;

      for i:=1 to M do
        ans[i]:=-a[i,0];
    end;
  end else
    result:=false;
end;
*)

procedure RegressionNInit;
{ var ans: array[0..M] of double;
  RegressionNInit;
  for k:=1 to N do
  begin
    p:=random; // independent variable
    q:=random; // independent variable
    r:=random; // independent variable
    s:=random; // independent variable
    z:=d+e*p+f*q+g*r+h*s+random/10; // dependent variable; defgh are constants
    RegressionNData([z,p,q,r,s]);
  end;
  if RegressionNAnswer(ans) then
    ... ans[0..4] are d,e,f,g,h
}
begin
  with RegressionN_rec do
  begin
    N:=0;
    SWgt:=0;
  end;
end;

procedure RegressionNDataW(x: array of double; Weight: double);
var i,j: integer;
begin
  with RegressionN_rec do
  begin
    if N = 0 then
    begin
      M:=high(x);
      SetLength(a,M+1);
      for i:=0 to M do
        SetLength(a[i],M+1);
      SetLength(SS,M+1);
      for i:=0 to M do
        SetLength(SS[i],M+1);
      SetLength(S,M+1);

      for i:=0 to M do
        for j:=0 to M do
          SS[i,j]:=0;
      for i:=0 to M do
        S[i]:=0;
    end;

    assert(M = high(x),'Regression: size of array must remain the same');

    SWgt:=SWgt+weight;
    inc(N);

    for i:=0 to M do
    begin
      for j:=1 to M do
        SS[i,j]:=SS[i,j]+(x[i]*x[j])*weight;
      S[i]:=S[i]+x[i]*weight;
    end;
  end;
end;

procedure RegressionNData(x: array of double);
begin
  RegressionNDataW(x,1);
end;

function RegressionNAnswer(var ans: array of double): boolean;
var i,j: integer;
begin
  with RegressionN_rec do
  if N > M then
  begin
    assert(M = high(ans),'Regression: ans should be array[0..'+inttostr(M)+'] of double');
    assert(N > M,'Regression: should have at least '+inttostr(M+1)+' data points');

    for i:=0 to M do
      for j:=1 to M do
        A[j,i]:=SS[i,j]-S[i]*S[j]/SWgt;

    result:=gaussian_eliminate(a);
    if result then
    begin
      ans[0]:=S[0];
      for i:=0 to M do
        ans[0]:=ans[0]+a[i,0]*S[i];
      ans[0]:=ans[0]/SWgt;

      for i:=1 to M do
        ans[i]:=-a[i,0];
    end;
  end else
    result:=false;
end;

procedure CubicCoeff(var DataPoint: Array of TSinglePoint; var a,b,c,d: Single);
{ y = dxxx + cxx + bx +a}
var Sx,Sx4,Sx2,Sx5,Sx2y,Sx3,Sx6,Sx3y,Sxy,Sy: Single;
var Tx1x2,Tx1x3,Tx2,Tx2x2,Tx2x3,Tx2y,Tx3x3,Tx3y,Txy: Single;
    x3,x2,x,y,e: Single;
    n,i: integer;
    p,q,r,s,t,u,v: Single;
begin
  n:=length(DataPoint);
  Sx:=0;
  Sx4:=0;
  Sx2:=0;
  Sx5:=0;
  Sx2y:=0;
  Sx3:=0;
  Sx6:=0;
  Sx3y:=0;
  Sxy:=0;
  Sy:=0;

  for i:=0 to high(DataPoint) do
  begin
    y:=DataPoint[i].y;
    x:=DataPoint[i].x;
    x2:=x*x;
    x3:=x*x*x;

    Sx:=Sx+x;
    Sy:=Sy+y;
    Sx2:=Sx2+x2;
    Sx3:=Sx3+x3;
    Sx4:=Sx4+x*x3;
    Sx5:=Sx5+x2*x3;
    Sx6:=Sx6+x3*x3;
    Sxy:=Sxy+x*y;
    Sx2y:=Sx2y+x2*y;
    Sx3y:=Sx3y+x3*y;
  end;

  Tx2:=Sx2-Sx*Sx/n;
  Tx1x2:=Sx3-Sx*Sx2/n;
  Tx1x3:=Sx4-Sx*Sx3/n;
  Tx2x2:=Sx4-Sx2*Sx2/n;
  Tx2x3:=Sx5-Sx2*Sx3/n;
  Tx3x3:=Sx6-Sx3*Sx3/n;
  Tx2y:=Sx2y-Sx2*Sy/n;
  Tx3y:=Sx3y-Sx3*Sy/n;
  Txy:=Sxy-Sx*Sy/n;

  p:=-Tx1x2*Tx1x2+Tx2*Tx2x2;
  q:=+Tx1x2*Tx1x3-Tx2*Tx2x3;
  r:=+Tx1x2*Tx2x3-Tx1x3*Tx2x2;
  s:=+Tx1x2*Tx2x3-Tx2x2*Tx1x3;
  t:=-Tx1x2*Tx3x3+Tx1x3*Tx2x3;
  u:=-Tx1x3*Tx1x3+Tx3x3*Tx2;
  v:=-Tx2x3*Tx2x3+Tx2x2*Tx3x3;

  b:=((-Tx3y*Tx2x3+Tx2y*Tx3x3)*s-(-Tx2y*Tx1x3+Txy*Tx2x3)*v);
  e:=(q*v-t*s);
  if e <> 0 then b:=b/e;

  c:=((-Txy*Tx1x3+Tx3y*Tx2)*t-(-Tx3y*Tx1x2+Tx2y*Tx1x3)*u);
  e:=(r*u-q*t);
  if e <> 0 then c:=c/e;

  d:=((-Tx2y*Tx1x2+Txy*Tx2x2)*q-(-Txy*Tx2x3+Tx3y*Tx1x2)*p);
  e:=(t*p-r*q);
  if e <> 0 then d:=d/e;

  a:=(Sy-d*Sx3-c*Sx2-b*Sx)/n;
end;

procedure QuadraticCoeff(var DataPoint: Array of TSinglePoint; var a,b,c: Single);
{ y = cxx+bx +a}
var Sx4,Sx2y,Sx2,Sx3,Sy,Sx,Sxy: double;
    n,i: integer;
begin
  Sx4:=0;
  Sx2y:=0;
  Sx2:=0;
  Sx3:=0;
  Sxy:=0;
  Sy:=0;
  Sx:=0;
  n:=0;

  for i:=0 to high(DataPoint) do
  with DataPoint[i] do
  begin
    Sx4:=Sx4+x*x*x*x;
    Sx2y:=Sx2y+x*x*y;
    Sx2:=Sx2+x*x;
    Sx3:=Sx3+x*x*x;
    Sxy:=Sxy+x*y;
    Sy:=Sy+y;
    Sx:=Sx+x;
    n:=n+1;
  end;

  if n = 0 then
  begin
    c:=0;
    b:=0;
    a:=0;
  end else
  begin
    a:=((Sx3-Sx2*Sx/n)*(Sx3-Sx2*Sx/n) - (Sx2-Sx*Sx/n)*(Sx4-Sx2*Sx2/n));
    if a = 0 then
    begin
      c:=0;
      b:=0;
    end else
    begin
      c:=((Sxy-Sx*Sy/n)*(Sx3-Sx2*Sx/n) - (Sx2-Sx*Sx/n)*(Sx2y-Sx2*Sy/n))/a;
      b:=((Sx2y-Sx2*Sy/n)*(Sx3-Sx2*Sx/n) - (Sx4-Sx2*Sx2/n)*(Sxy-Sx*Sy/n))/a;
    end;
    a:=(Sy-c*Sx2-b*Sx)/n;
  end;
end;

procedure LinearCoeff(var DataPoint: Array of TSinglePoint; var a,b: Single);
{ y = cxx+bx +a}
var Sx2,Sy,Sx,Sxy: double;
    n,i: integer;
begin
  Sx2:=0;
  Sxy:=0;
  Sy:=0;
  Sx:=0;
  n:=0;

  for i:=0 to high(DataPoint) do
  with DataPoint[i] do
  begin
    {z:=ax + by + c}

    Sx2:=Sx2+x*x;
    Sxy:=Sxy+x*y;
    Sy:=Sy+y;
    Sx:=Sx+x;
    n:=n+1;
  end;

  if n = 0 then
  begin
    b:=0;
    a:=0;
  end else
  begin
    if Sx2-Sx*Sx/n = 0 then
      b:=0 else
      b:=(Sxy-Sx*Sy/n)/(Sx2-Sx*Sx/n);
    a:=(Sy-b*Sx)/n;
  end;
end;

procedure CubicCoeffC(DataPoint: Array of TSinglePoint; var a,b,c,d: Single);
begin
  CubicCoeff(DataPoint,a,b,c,d);
end;

procedure QuadraticCoeffC(DataPoint: Array of TSinglePoint; var a,b,c: Single);
begin
  QuadraticCoeff(DataPoint,a,b,c);
end;

procedure LinearCoeffC(DataPoint: Array of TSinglePoint; var a,b: Single);
begin
  LinearCoeff(DataPoint,a,b);
end;

function NextNumberDefP(const sq: string; var ptr: integer; default: integer): integer;
begin
assert(false,'this routine has not been tested yet: NextNumberDefP');
  SkipBlanksCommentsP(sq,ptr);
  if (ptr <= length(sq)) and (sq[ptr] >= '0') and (sq[ptr] <= '9') then
    result:=NextNumberP(sq,ptr) else
    result:=default;
end;

function NextHexNumberDefP(const sq: string; var ptr: integer; default: integer): integer;
begin
assert(false,'this routine has not been tested yet: NextHexNumberDefP');
  SkipBlanksCommentsP(sq,ptr);
  if (ptr > length(sq)) then
    result:=default else
  case upcase(sq[ptr]) of
    '0'..'9','A'..'F': result:=NextHexNumberP(sq,ptr)
    else result:=default;
  end;
end;

function NextHexNumberP(const sq: string; var ptr: integer): integer;
begin
assert(false,'this routine has not been tested yet: NextHexNumberP');
  result:=0;
  try
    while (ptr <= length(sq)) do
    case upcase(sq[ptr]) of
      '0'..'9':
        begin
          result:=result*16+ord(sq[ptr])-ord('0');
          inc(ptr);
        end;
      'A'..'F':
        begin
          result:=result*16+ord(upcase(sq[ptr]))-ord('A')+10;
          inc(ptr);
        end;
      else exit;
    end;
  finally
    SkipBlanksCommentsP(sq,ptr);
  end;
end;

function NextNumberP(const sq: string; var ptr: integer): integer;
begin
  if NextisP(sq,ptr,'-') then
    result:=-NextNumberP(sq,ptr) else
  begin
    result:=0;
    while (ptr <= length(sq)) and (sq[ptr] >= '0') and (sq[ptr] <= '9') do
    begin
      result:=result*10+ord(sq[ptr])-ord('0');
      inc(ptr);
    end;
  end;
  SkipBlanksCommentsP(sq,ptr);
end;

function NextExpressionP(const sq: string; var ptr: integer): Double;
begin
assert(false,'this routine has not been tested yet: NextExpressionP');
  result:=NextExpressionDefP(sq,ptr,0);
end;

function MustbeExpressionP(const sq: string; var ptr: integer): Double;
  function Term: double;
  begin
    if nextisP(sq,ptr,'(') then
    begin
      result:=MustbeExpressionP(sq,ptr);
      MustbeP(sq,ptr,')');
    end else
    if nextisP(sq,ptr,'+') then
    begin
      result:=Term;
    end else
    if nextisP(sq,ptr,'-') then
    begin
      result:=-Term;
    end else
      result:=MustbeDoubleP(sq,ptr);
  end;
  function MultExp: double;
  begin
    result:=Term;
    repeat
      if NextIsP(sq,ptr,'*') then
        result:=result*Term else
      if NextIsP(sq,ptr,'/') then
        result:=result/Term else
        exit;
    until false;
  end;
  function AddExp: double;
  begin
    result:=MultExp;
    repeat
      if NextIsP(sq,ptr,'+') then
        result:=result+MultExp else
      if NextIsP(sq,ptr,'-') then
        result:=result-MultExp else
        exit;
    until false;
  end;
begin
assert(false,'this routine has not been tested yet: MustbeExpressionP');
  SkipBlanksCommentsP(sq,ptr);
  result:=AddExp;
  SkipBlanksCommentsP(sq,ptr);
end;

function NextWordP(const sq: string; var ptr: integer): string;
begin
assert(false,'this routine has not been tested yet: NextWordP');
  SkipBlanksCommentsP(sq,ptr);
  result:='';
  while (ptr <= length(sq)) and (sq[ptr] <> ' ') do
  begin
    result:=result+sq[ptr];
    inc(ptr);
  end;
  SkipBlanksCommentsP(sq,ptr);
end;

function MustbeIdKeepCaseP(const sq: string; var ptr: integer): string;
begin
assert(false,'this routine has not been tested yet: MustbeIdKeepCaseP');
  if not NextisIdKeepCaseP(sq,ptr,result) then
    raise Exception.Create('Identifier expected');
end;

function MustbeIdP(const sq: string; var ptr: integer): string;
begin
assert(false,'this routine has not been tested yet: MustbeIdP');
  if not NextisIdP(sq,ptr,result) then
    raise Exception.Create('Identifier expected');
end;

function MustbeStringP(const sq: string; var ptr: integer): string;
begin
  if not NextisStringP(sq,ptr,result) then
    raise Exception.Create('String expected');
end;

function MustbeSignedNumberP(const sq: string; var ptr: integer): integer;
var i: integer;
begin
  if NextisP(sq,ptr,'-') then i:=-1 else
  if NextisP(sq,ptr,'+') then i:=+1 else
                        i:=+1;
  result:=i*MustbeNumberP(sq,ptr);
end;

function MustbeNumberP(const sq: string; var ptr: integer): integer;
begin
  if not NextisNumberP(sq,ptr,result) then
    raise Exception.Create('Number expected');
end;

function MustbeBoolP(const sq: string; var ptr: integer): boolean;
begin
assert(false,'this routine has not been tested yet: MustbeBoolP');
  if NextisP(sq,ptr,'true') or NextisP(sq,ptr,'t') then result:=true else
  if NextisP(sq,ptr,'false') or NextisP(sq,ptr,'f') then result:=false else
    raise Exception.Create('Boolean expected');
end;

function NextIsP(const sq: string; var ptr: integer; const substr: string): Boolean;
begin
  SkipBlanksCommentsP(sq,ptr);
  if ((CompareText(copy(sq,ptr,length(substr)),substr)= 0) or
     (copy(sq,ptr,length(substr)) = substr)) and
     (not alphanum(substr[length(substr)]) or
       (length(substr) = length(sq)-ptr+1) or
       not alphanum(sq[ptr+length(substr)])) then
  begin
    NextIsP:=true;
    inc(ptr,length(substr));
  end else
    NextIsP:=false;
  SkipBlanksCommentsP(sq,ptr);
end;

function PeekIsP(const sq: string; var ptr: integer; const substr: string): boolean;
var i: integer;
begin
assert(false,'this routine has not been tested yet: PeekIsP');
  i:=ptr;
  result:=NextisP(sq,i,substr);
end;

function NextIsCharSetP(const sq: string; var ptr: integer; cset: TSetOfChar; var c: char): boolean;
{case sensitive}
begin
assert(false,'this routine has not been tested yet: NextIsCharSetP');
  SkipBlanksCommentsP(sq,ptr);
  if (ptr <= length(sq)) and (sq[ptr] in cset) then
  begin
    c:=sq[ptr];
    result:=true;
    inc(ptr);
  end else
    result:=false;
  SkipBlanksCommentsP(sq,ptr);
end;

function NextIsFixedP(const sq: string; var ptr: integer; const substr: string): Boolean;
{ is substr the next few chars - don't worry whether it's a whole id - ignore case}
begin
//assert(false,'this routine has not been tested yet: NextIsFixedP');
  SkipBlanksCommentsP(sq,ptr);
  if (CompareText(copy(sq,ptr,length(substr)),substr)= 0) then
  begin
    result:=true;
    inc(ptr,length(substr));
  end else
    result:=false;
  SkipBlanksCommentsP(sq,ptr);
end;

function NextIsNumberP(const sq: string; var ptr: integer; var i: integer): boolean;
begin
  SkipBlanksCommentsP(sq,ptr);
  result:=(ptr <= length(sq)) and (sq[ptr] >= '0') and (sq[ptr] <= '9');
  if result then
    i:=NextNumberP(sq,ptr);
end;

function NextIsHexNumberP(const sq: string; var ptr: integer; var i: integer): boolean;
begin
assert(false,'this routine has not been tested yet: NextIsHexNumberP');
  SkipBlanksCommentsP(sq,ptr);
  result:=false;
  if (ptr <= length(sq)) then
  case upcase(sq[ptr]) of
    '0'..'9','A'..'F': result:=true;
  end;
  if result then
    i:=NextHexNumberP(sq,ptr);
end;

function NextIsExpressionP(const sq: string; var ptr: integer; var i: double): boolean;
begin
assert(false,'this routine has not been tested yet: NextIsExpressionP');
  SkipBlanksCommentsP(sq,ptr);
  result:=(ptr <= length(sq));
  if result then
  case sq[ptr] of
    '0'..'9','(','+','-': ;
    else result:=false;
  end;
  if result then
    i:=MustbeExpressionP(sq,ptr);
end;

function NextIsStringP(const sq: string; var ptr: integer; var str: string): Boolean;
begin
  result:=false;
  SkipBlanksCommentsP(sq,ptr);
  if (sq <> '') and (sq[ptr] = '''') then
  begin
    inc(ptr);
    str:='';
    while (ptr <= length(sq)) and (sq[ptr] <> '''') do
    begin
      str:=str+sq[ptr];
      inc(ptr);
    end;
    NextIsP(sq,ptr,'''');
    result:=true;
  end else
  if (sq <> '') and (sq[ptr] = '"') then
  begin
    inc(ptr);
    str:='';
    while (ptr <= length(sq)) and (sq[ptr] <> '"') do
    begin
      str:=str+sq[ptr];
      inc(ptr);
    end;
    NextIsP(sq,ptr,'"');
    result:=true;
  end;
  SkipBlanksCommentsP(sq,ptr);
end;

function NextExpressionDefP(const sq: string; var ptr: integer; default: double): double;
begin
assert(false,'this routine has not been tested yet: NextExpressionDefP');
  if not NextIsExpressionP(sq,ptr,result) then
    result:=default;
end;

function NextIsIdP(const sq: string; var ptr: integer; var id: string): Boolean;
begin
assert(false,'this routine has not been tested yet: NextIsIdP');
  result:=NextIsIdKeepCaseP(sq,ptr,id);
  if result then
    id:=UpperCase(id);
end;

function NextIsIdKeepCaseP(const sq: string; var ptr: integer; var id: string): Boolean;
var id2: string;
begin
assert(false,'this routine has not been tested yet: NextIsIdKeepCaseP');
  SkipBlanksCommentsP(sq,ptr);
  id2:='';
  result:=(ptr <= length(sq)) and alpha(sq[ptr]);
  if result then
  begin
    while (ptr <= length(sq)) and alphanum(sq[ptr]) do
    begin
      id2:=id2+sq[ptr];
      inc(ptr);
    end;
    SkipBlanksCommentsP(sq,ptr);
      id:=id2;
  end;
end;

function NextIsIdNumericP(const sq: string; var ptr: integer; var id: string): Boolean;
begin
assert(false,'this routine has not been tested yet: NextIsIdNumericP');
  result:=NextIsIdNumericKeepCaseP(sq,ptr,id);
  if result then
    id:=UpperCase(id);
end;

function NextIsIdNumericKeepCaseP(const sq: string; var ptr: integer; var id: string): Boolean;
var id2: string;
begin
assert(false,'this routine has not been tested yet: NextIsIdNumericKeepCaseP');
  SkipBlanksCommentsP(sq,ptr);
  id2:='';
  result:=(ptr <= length(sq)) and alphanum(sq[ptr]);
  if result then
  begin
    while (ptr <= length(sq)) and alphanum(sq[ptr]) do
    begin
      id2:=id2+sq[ptr];
      inc(ptr);
    end;
    SkipBlanksCommentsP(sq,ptr);
      id:=id2;
  end;
end;

function NextIsSignedNumberP(const sq: string; var ptr: integer; var i: integer): boolean;
begin
assert(false,'this routine has not been tested yet: NextIsSignedNumberP');
  NextisP(sq,ptr,'+');

  if NextisP(sq,ptr,'-') then
  begin
    result:=NextIsSignedNumberP(sq,ptr,i);
    i:=-i;
  end else
    result:=NextIsnumberP(sq,ptr,i);
end;

function NextIsSignedDoubleP(const sq: string; var ptr: integer; var i: Double): boolean;
var j: integer;
begin
  NextisP(sq,ptr,'+');

  if NextisP(sq,ptr,'-') then
  begin
    result:=NextIsSignedDoubleP(sq,ptr,i);
    i:=-i;
  end else
  begin
    result:=NextIsnumberP(sq,ptr,j);
    i:=j;
    if result and NextisP(sq,ptr,'.') then
    begin
      j:=10;
      while (ptr <= length(sq)) and digit(sq[ptr]) do
      begin
        i:=i+(ord(sq[ptr])-ord('0'))/j;
        j:=j*10;
        inc(ptr);
      end;
    end;
    if result and NextisP(sq,ptr,'E') then
      i:=i*alog(MustbeSignedNumberP(sq,ptr));
  end;
end;

function NextDoubleP(const sq: string; var ptr: integer): Double;
begin
assert(false,'this routine has not been tested yet: NextDoubleP');
  result:=NextDoubleDefP(sq,ptr,0);
end;

function NextDoubleDefP(const sq: string; var ptr: integer; default: Double): Double;
begin
assert(false,'this routine has not been tested yet: NextDoubleDefP');
  if not NextIsSignedDoubleP(sq,ptr,result) then
    result:=default;
end;

function MustbeDoubleP(const sq: string; var ptr: integer): Double;
begin
assert(false,'this routine has not been tested yet: MustbeDoubleP');
  if not NextIsSignedDoubleP(sq,ptr,result) then
    raise Exception.Create('Number expected');
end;

function MustbeSignedDoubleP(const sq: string; var ptr: integer): Double;
begin
assert(false,'this routine has not been tested yet: MustbeSignedDoubleP');
  if NextisP(sq,ptr,'+') then
    result:=MustbeDoubleP(sq,ptr) else
  if NextisP(sq,ptr,'-') then
    result:=-MustbeDoubleP(sq,ptr) else
    result:=MustbeDoubleP(sq,ptr);
end;

function NextIsIdAKeepCaseP(const sq: string; var ptr: integer; var id: string): boolean;
var id2: string;
begin
assert(false,'this routine has not been tested yet: NextIsIdAKeepCaseP');
  SkipBlanksCommentsP(sq,ptr);
  id2:='';
  result:=(ptr <= length(sq)) and alphanum(sq[ptr]);
  if result then
  begin
    while (ptr <= length(sq)) and alphanum(sq[ptr]) do
    begin
      id2:=id2+sq[ptr];
      inc(ptr);
    end;
    SkipBlanksCommentsP(sq,ptr);
      id:=id2;
  end;
end;

function NextIsIdAP(const sq: string; var ptr: integer; var id: string): boolean;
begin
assert(false,'this routine has not been tested yet: NextIsIdAP');
  result:=NextIsIdAKeepCaseP(sq,ptr,id);
  if result then
    id:=UpperCase(id);
end;

function MustbeEFormatP(const sq: string; var ptr: integer): Double;
begin
assert(false,'this routine has not been tested yet: MustbeEFormatP');
  result:=MustbeSignedDoubleP(sq,ptr);
  if NextisP(sq,ptr,'E') then
    result:=result*alog(MustbeSignedNumberP(sq,ptr));
end;

procedure MustbeP(const sq: string; var ptr: integer; const substr: string);
begin
   if not NextisP(sq,ptr,substr) then
     raise Exception.Create('"'+substr+'" expected');
end;

procedure SkipBlanksP(const sq: string; var ptr: integer);
begin
assert(false,'this routine has not been tested yet: SkipBlanksP');
  repeat
    if ptr > length(sq) then exit;
    case sq[ptr] of
      ' ',char(vk_Tab),#13,#10: inc(ptr);
      else exit;
    end;
  until false;
end;

procedure SkipBlanksCommentsP(const sq: string; var ptr: integer);
var t: string;
begin
  repeat
    if ptr > length(sq) then exit;

    if (copy(sq,ptr,2) = '/*') and fSkipSlashStar then
    begin
      inc(ptr,2);
      while (ptr <= length(sq)) and (copy(sq,ptr,2) <> '*/') do
        inc(ptr);
      inc(ptr,2);
    end;

    case sq[ptr] of
      ' ',char(vk_Tab),#13,#10:
        if fSkipBlanks then
          inc(ptr,1) else
          exit;
      '{':
        if fSkipComments then
        begin
          while (ptr <= length(sq)) and (sq[ptr] <> '}') do
            inc(ptr);
          inc(ptr);
        end else
          exit;
      else exit;
    end;
  until false;
end;

Procedure RightMenuEx(Form: TForm; MenuItem: TMenuItem; s: string);
var mii: TMenuItemInfo;
    MainMenu: hMenu;
    Buffer: array[0..79] of Char;
begin
  MainMenu := Form.Menu.Handle;
  FillChar(mii,SizeOf(TMenuItemInfo), #0) ;
  mii.cbSize := SizeOf(mii) ;
  mii.fMask := MIIM_TYPE;
  mii.dwTypeData := Buffer;
  mii.cch := SizeOf(Buffer) ;

  GetMenuItemInfo(MainMenu, MenuItem.Command, false, mii) ;
  mii.fType := mii.fType or MFT_RIGHTJUSTIFY;
//  SetMenuItemInfo(MainMenu, MenuItem.Command, false, mii) ;

//  mii.fMask := MIIM_TYPE or MIIM_ID or MIIM_STATE;
//mii.fType := mii.fType or MFT_STRING;
  mii.fType := mii.fType or MFT_STRING;
  mii.dwTypeData := pchar(s);
  mii.cch := Length(s) ;
  SetMenuItemInfo(MainMenu, MenuItem.Command, false, mii) ;
//  Form.Invalidate;
DrawMenuBar(Form.Handle);
end;

Procedure RightMenu(Form: TForm; MenuItem: TMenuItem); // Shift in the right of last item of the menu
var mii: TMenuItemInfo;
    MainMenu: hMenu;
    Buffer: array[0..79] of Char;
begin
exit;
  MainMenu := Form.Menu.Handle;
  mii.cbSize := SizeOf(mii) ;
  mii.fMask := MIIM_TYPE;
  mii.dwTypeData := Buffer;
  mii.cch := SizeOf(Buffer) ;
  GetMenuItemInfo(MainMenu, MenuItem.Command, false, mii) ;
  mii.fType := mii.fType or MFT_RIGHTJUSTIFY;
  SetMenuItemInfo(MainMenu, MenuItem.Command, false, mii) ;
//  Form.Invalidate;
end;

const
  // Sets UnixStartDate to TDateTime of 01/01/1970 
  UnixStartDate: TDateTime = 25569.0; 

function DateTimeToUnix(ConvDate: TDateTime): Longint; 
begin 
  Result := Round((ConvDate - UnixStartDate) * 86400); 
end; 

function UnixToDateTime(USec: Longint): TDateTime; 
begin
  Result := (Usec / 86400) + UnixStartDate;
end;

procedure CreateSubMenuList(aMenu: TMenuItem; StringList: TStrings; Click: TNotifyEvent);
{tag of menu item is 0..n-1}
{if caption starts with a '+' then it's Checked}
{parent menu item must already have a sub-menu}
  procedure AddItem(s: string; i: integer);
  var a: TMenuItem;
  begin
    a:=TMenuItem.Create(nil);
    a.Caption:=s;
    a.OnClick:=Click;
    a.tag:=i;
    aMenu.Add(a);
  end;
var i: integer;
  var a: TMenuItem;
begin
  while aMenu.Count > 1 do
    aMenu.Items[0].Free;
  aMenu.Items[0].Caption:='<none>';
  aMenu.Items[0].Checked:=false;

  for i:=0 to StringList.Count-1 do
    AddItem(StringList[i],longint(StringList.objects[i]));

  if aMenu.Count > 1 then
  begin
    aMenu.Items[0].Free;
    aMenu.Items[0].Enabled:=true;
  end else
  begin
    aMenu.Items[0].Enabled:=false;
  end;

  for i:=0 to aMenu.Count-1 do
  begin
    if copy(aMenu.Items[i].Caption,1,1) = '+' then
    begin
      aMenu.Items[i].Caption:=copy(aMenu.Items[i].Caption,2,1000);
      aMenu.Items[i].Checked:=true;
    end;
    aMenu.Items[i].tag:=i;
  end;
end;

procedure CreatePopupMenuList(aMenu: TPopupMenu; StringList: TStrings; Click: TNotifyEvent);
  procedure AddItem(s: string; i: integer);
  var a: TMenuItem;
  begin
    a:=TMenuItem.Create(nil);
    a.Caption:=s;
    a.OnClick:=Click;
    a.tag:=i;
    aMenu.Items.Add(a);
  end;
var i: integer;
  var a: TMenuItem;
begin
  while aMenu.Items.Count > 1 do
    aMenu.Items[0].Free;
  aMenu.Items[0].Caption:='<none>';

  for i:=0 to StringList.Count-1 do
    AddItem(StringList[i],longint(StringList.objects[i]));

  if aMenu.Items.Count > 1 then
  begin
    aMenu.Items[0].Free;
    aMenu.Items[0].Enabled:=true;
  end else
  begin
    aMenu.Items[0].Enabled:=false;
  end;
end;

function StrToFloatDP(const s:string): single;
var ss : string;
begin
  ss:= StrReplace(s,'.',DecimalSeparator,true);
  ss:= StrReplace(ss,',',DecimalSeparator,true);
  result := StrToFloat(ss);
end;

function SplitString(s: String; delimiter: char): TStringList;
begin
  result:=TStringList.Create;
  while pos(delimiter,s) > 0 do
  begin
    result.add(before(s,delimiter));
    s:=after(s,delimiter);
  end;
  if s <> '' then
    result.add(s);
end;

function SinglePointInPolygon(pt: TSinglePoint; Points: array of TSinglePoint): boolean;
var i: integer;
    p: TSinglePoint;
begin
  result:=false;
  if length(Points) = 0 then
    exit;

  p:=Points[high(Points)];
  for i:=low(Points) to high(Points) do
  begin
    if p.x <> Points[i].x then
      if (pt.x >  p.x) = (pt.x <= Points[i].x) then
        if pt.y-p.y <= (pt.x-p.x)*(Points[i].y-p.y)/(Points[i].x-p.x) then
          result:=not result;
    p:=Points[i];
  end;
end;

function NextCharIs(var s: string; c: char): boolean;
{case sensitive}
begin
  if (s <> '') and (s[1] = c) then
  begin
    result:=true;
    delete(s,1,1);
  end else
    result:=false;
end;

function NextCharIsP(const sq: string; var ptr: integer; c: char): boolean;
{case sensitive}
begin
assert(false,'this routine has not been tested yet');
  SkipBlanksCommentsP(sq,ptr);
  if (ptr <= length(sq)) and (sq[ptr] = c) then
  begin
    result:=true;
    inc(ptr);
  end else
    result:=false;
  SkipBlanksCommentsP(sq,ptr);
end;

procedure CircleThroughThreePoints(p1,p2,p3: TPoint; var c: TPoint; var r: single);
var d,s,t,x1,y1,x2,y2,f1,g1,f2,g2,ma,mb: single;
begin
  x1:=(p1.x+p2.x)/2;
  f1:=p2.y-p1.y;
  y1:=(p1.y+p2.y)/2;
  g1:=p1.x-p2.x;

  x2:=(p2.x+p3.x)/2;
  f2:=p3.y-p2.y;
  y2:=(p2.y+p3.y)/2;
  g2:=p2.x-p3.x;

  d:=f2*g1-f1*g2;

  if d = 0 then
  begin
    r:=0;
    c.x:=p2.x;
    c.y:=p2.y;
  end else
  begin
    s:=(f2*(y2-y1)-g2*(x2-x1))/d;
    c.x:=round(x1+f1*s);
    c.y:=round(y1+g1*s);
    r:=sqrt(sqr(p2.x-c.x)+sqr(p2.y-c.y));
  end;
end;

procedure DrawArcThroughThreePoints(Canvas: TCanvas; p1,p2,p3: TPoint);
var r: single;
    c: TPoint;
begin
  with Canvas do
  begin
    CircleThroughThreePoints(p1,p2,p3,c,r);

    if r = 0 then
    begin
      Moveto(p1.x,p1.y);
      Lineto(p3.x,p3.y);
    end else
    begin
      if sideTPoint(p2,p1,p3) > 0 then
        Arc(round(c.x-r),round(c.y-r),round(c.x+r+1),round(c.y+r+1),p1.x,p1.y,p3.x,p3.y) else
        Arc(round(c.x-r),round(c.y-r),round(c.x+r+1),round(c.y+r+1),p3.x,p3.y,p1.x,p1.y);
    end;
  end;
end;

function IntersectPoly(Points,ClipPoly: array of TPoint): TarrayofTPoint;
{ClipPoly must be convex}
{poly areas should be positive}
var i,j,k: integer;
    inputList: array of TPoint;
    s,e: TPoint;
    xa,ya,sa,ta: integer;
begin
  if not RectOverlap(PolyBoundingRect(Points),PolyBoundingRect(ClipPoly)) then
  begin
    result:=nil;
    exit;
  end;

  {List outputList = subjectPolygon}
  setlength(result,length(Points));
  for j:=0 to high(Points) do
    result[j]:=Points[j];

  {for (Edge clipEdge in clipPolygon) do}
  for i:=0 to high(ClipPoly) do
  begin
    {List inputList = outputList}
    setlength(inputList,length(result));
    for j:=0 to high(result) do
      inputList[j]:=result[j];

    {outputList.clear()}
    setlength(result,0);
    {Point S = inputList.last}
    if length(inputList) > 0 then
      s:=inputList[high(inputList)];
    {for (Point E in inputList) do}
    for k:=0 to high(inputList) do
    begin
      e:=inputList[k];
      {if (E inside clipEdge) then}
      if sideTPoint(e,ClipPoly[(i+1) mod length(ClipPoly)],ClipPoly[i]) > 0 then
      begin
        {if (S not inside clipEdge) then}
        if sideTPoint(s,ClipPoly[(i+1) mod length(ClipPoly)],ClipPoly[i]) <= 0 then
        begin
          {outputList.add(ComputeIntersection(S,E,clipEdge))}
          setlength(result,length(result)+1);
          LinesCrossNoClipTP(s,e,ClipPoly[i],ClipPoly[(i+1) mod length(ClipPoly)],result[high(result)]);
        end;
        {outputList.add(E)}
        setlength(result,length(result)+1);
        result[high(result)]:=e;
      end else
      {if (S inside clipEdge) then}
      if sideTPoint(s,ClipPoly[(i+1) mod length(ClipPoly)],ClipPoly[i]) > 0 then
      begin
        {outputList.add(ComputeIntersection(S,E,clipEdge))}
        setlength(result,length(result)+1);
        LinesCrossNoClipTP(s,e,ClipPoly[i],ClipPoly[(i+1) mod length(ClipPoly)],result[high(result)]);
      end;
      S:=E;
    end;
  end;
end;

function PolyIsConvex(Points: array of TPoint): boolean;
{poly area should be positive}
var i: integer;
begin
  result:=false;
  for i:=0 to high(Points) do
    if sideTPoint(
          Points[(i+0) mod length(Points)],
          Points[(i+1) mod length(Points)],
          Points[(i+2) mod length(Points)]) > 0 then
      exit;
  result:=true;
end;

procedure DelayNoYield(msecs: integer);
var
  FirstTickCount: longint;
begin
  FirstTickCount := GetTickCount;
  repeat
  until ((GetTickCount-FirstTickCount) >= Longint(msecs));
end;

procedure Delay(msecs: integer);
var
  FirstTickCount: longint;
begin
  FirstTickCount := GetTickCount;
  repeat
    Application.ProcessMessages;
  until ((GetTickCount-FirstTickCount) >= Longint(msecs));
end;

function DistPointToPointSq(p1,p2: TPoint): integer;
begin
  result:=sqr(p1.x-p2.x)+sqr(p1.y-p2.y);
end;

function RectCircleOverlap(Rect1: TRect; xc2,yc2,r2: integer): boolean;
begin
  result:=false;
  Rect1:=SortRect(Rect1);

  if not RectOverlap(Rect1,Rect(xc2-r2,yc2-r2,xc2+r2,yc2+r2)) or
     not PtinRect(MyInflateRect(Rect1,r2,r2),Point(xc2,yc2)) then
    exit;

  result:=
     InRange(xc2,Rect1.Left,Rect1.Right) or
     InRange(yc2,Rect1.Top,Rect1.Bottom) or
     (DistPointToPointSq(Point(xc2,yc2),Point(Rect1.Left,Rect1.Top)) < r2*r2) or
     (DistPointToPointSq(Point(xc2,yc2),Point(Rect1.Right,Rect1.Top)) < r2*r2) or
     (DistPointToPointSq(Point(xc2,yc2),Point(Rect1.Left,Rect1.Bottom)) < r2*r2) or
     (DistPointToPointSq(Point(xc2,yc2),Point(Rect1.Right,Rect1.Bottom)) < r2*r2);
end;

function RectLineOverlap(Rect1: TRect; xa2,ya2,xb2,yb2: integer): boolean;
  function LinesCrossHorz(k,l,m,n: TPoint): boolean;
  var det,t: Double;
  begin
    k.y:=k.y-m.y;
    l.y:=l.y-m.y;

    if k.y*l.y < 0 then
    begin
      k.x:=k.x-m.x;
      l.x:=l.x-m.x;
      n.x:=n.x-m.x;
      det:=n.x*(l.y-k.y);
      t:=(l.y-k.y)*k.x-(l.x-k.x)*k.y;
      result:=InRealRange(t,0,det) or InRealRange(t,det,0);
    end else
      result:=false;
  end;
  function LinesCrossVert(k,l,m,n: TPoint): boolean;
  var det,t: Double;
  begin
    k.x:=k.x-m.x;
    l.x:=l.x-m.x;

    if k.x*l.x < 0 then
    begin
      k.y:=k.y-m.y;
      l.y:=l.y-m.y;
      n.y:=n.y-m.y;
      det:=n.y*(l.x-k.x);
      t:=(l.x-k.x)*k.y-(l.y-k.y)*k.x;
      result:=InRealRange(t,0,det) or InRealRange(t,det,0);
    end else
      result:=false;
  end;
begin
  result:=false;
  Rect1:=SortRect(Rect1);
  if not RectOverlap(Rect1,SortRect(Rect(xa2,ya2,xb2,yb2))) then
    exit;

  result:=
      PtinRect(Rect1,Point(xa2,ya2)) or
      PtinRect(Rect1,Point(xb2,yb2)) or
      LinesCrossVert(Point(xa2,ya2),Point(xb2,yb2),Point(Rect1.Left,Rect1.Top),Point(Rect1.Left,Rect1.Bottom)) or
      LinesCrossVert(Point(xa2,ya2),Point(xb2,yb2),Point(Rect1.Right,Rect1.Top),Point(Rect1.Right,Rect1.Bottom)) or
      LinesCrossHorz(Point(xa2,ya2),Point(xb2,yb2),Point(Rect1.Left,Rect1.Top),Point(Rect1.Right,Rect1.Top)) or
      LinesCrossHorz(Point(xa2,ya2),Point(xb2,yb2),Point(Rect1.Left,Rect1.Bottom),Point(Rect1.Right,Rect1.Bottom));
end;

function RectPolyOverlap(Rect1: TRect; Poly2: array of TPoint): boolean;
var a: TPoint;
    j: integer;
begin
  result:=false;
  Rect1:=SortRect(Rect1);
  if not RectOverlap(Rect1,PolyBoundingRect(Poly2)) then
    exit;

  result:=true;

  if PtInPolygon(Rect1.TopLeft,Poly2) then
    exit;
  if PtInPolygon(Rect1.BottomRight,Poly2) then
    exit;
  if PtInPolygon(Point(Rect1.Left,Rect1.Bottom),Poly2) then
    exit;
  if PtInPolygon(Point(Rect1.Right,Rect1.Top),Poly2) then
    exit;

  for j:=0 to high(Poly2) do
    if PtInRect(Rect1,Poly2[j]) then
      exit;

  for j:=0 to high(Poly2) do
  begin
    if LinesCrossTP(
        Point(Rect1.Left,Rect1.Bottom),Point(Rect1.Right,Rect1.Bottom),
        Poly2[j],Poly2[(j+1) mod length(Poly2)],a) then
      exit;

    if LinesCrossTP(
        Point(Rect1.Left,Rect1.Top),Point(Rect1.Right,Rect1.Top),
        Poly2[j],Poly2[(j+1) mod length(Poly2)],a) then
      exit;

    if LinesCrossTP(
        Point(Rect1.Left,Rect1.Bottom),Point(Rect1.Left,Rect1.Top),
        Poly2[j],Poly2[(j+1) mod length(Poly2)],a) then
      exit;

    if LinesCrossTP(
        Point(Rect1.Right,Rect1.Bottom),Point(Rect1.Right,Rect1.Top),
        Poly2[j],Poly2[(j+1) mod length(Poly2)],a) then
      exit;
  end;

  result:=false;
end;

function CircleOverlap(xc1,yc1,r1: integer; xc2,yc2,r2: integer): boolean;
begin
  result:=DistPointToPointSq(Point(xc1,yc1),Point(xc2,yc2)) < sqr(r1+r2);
end;

function CircleLineOverlap(xc1,yc1,r1: integer; xa2,ya2,xb2,yb2: integer): boolean;
begin
  result:=false;
  if not RectOverlap(Rect(xc1-r1,yc1-r1,xc1+r1,yc1+r1),SortRect(Rect(xa2,ya2,xb2,yb2))) then
    exit;

  result:=DistPointToLine(Point(xc1,yc1),Point(xa2,ya2),Point(xb2,yb2)) < r1;
end;

function CirclePolyOverlap(xc1,yc1,r1: integer; Poly2: array of TPoint): boolean;
var i: integer;
begin
  result:=false;
  if not RectOverlap(Rect(xc1-r1,yc1-r1,xc1+r1,yc1+r1),PolyBoundingRect(Poly2)) then
    exit;

  result:=true;

  if PtInPolygon(Point(xc1,yc1),Poly2) then
    exit;

  for i:=0 to high(Poly2) do
    if DistPointToPointSq(Point(xc1,yc1),Poly2[i]) < r1*r1 then
      exit;

  for i:=0 to high(Poly2) do
    if DistPointToLine(Point(xc1,yc1),
        Poly2[i],Poly2[(i+1) mod length(Poly2)]) < r1 then
      exit;

  result:=false;
end;

function LineOverlap(xa1,ya1,xb1,yb1, xa2,ya2,xb2,yb2, w: integer): boolean;
{lines cross or approach closer then w}
var xa,ya,s,t: Double;
begin
  result:=false;
//  if not RectOverlap(MyInflateRect(Rect(xa1,ya1,xb1,yb1),w,w),Rect(xa2,ya2,xb2,yb2)) then
//    exit;

  result:=LinesCross(xa1,ya1,xb1,yb1, xa2,ya2,xb2,yb2, xa,ya,s,t) or
          (DistPointToLine(Point(xa1,ya1), Point(xa2,ya2),Point(xb2,yb2)) < w) or
          (DistPointToLine(Point(xb1,yb1), Point(xa2,ya2),Point(xb2,yb2)) < w) or
          (DistPointToLine(Point(xa2,ya2), Point(xa1,ya1),Point(xb1,yb1)) < w) or
          (DistPointToLine(Point(xb2,yb2), Point(xa1,ya1),Point(xb1,yb1)) < w);
end;

function LinePolyOverlap(xa1,ya1,xb1,yb1: integer; Poly2: array of TPoint): boolean;
var a: TPoint;
    i: integer;
begin
  result:=false;
  if not RectOverlap(SortRect(Rect(xa1,ya1,xb1,yb1)),PolyBoundingRect(Poly2)) then
    exit;

  result:=true;
  if PtInPolygon(Point(xa1,ya1),Poly2) then
    exit;
  if PtInPolygon(Point(xb1,yb1),Poly2) then
    exit;

  for i:=0 to high(Poly2) do
    if LinesCrossTP(Point(xa1,ya1),Point(xb1,yb1),Poly2[i],Poly2[(i+1) mod length(Poly2)],a) then
      exit;

  result:=false;
end;

function PolyOverlap(Poly1: array of TPoint; Poly2: array of TPoint): boolean;
var a: TPoint;
    i,j: integer;
begin
  result:=false;
  if not RectOverlap(PolyBoundingRect(Poly1),PolyBoundingRect(Poly2)) then
    exit;

  result:=true;
  for i:=0 to high(Poly1) do
    if PtInPolygon(Poly1[i],Poly2) then
      exit;

  for i:=0 to high(Poly2) do
    if PtInPolygon(Poly2[i],Poly1) then
      exit;

  for i:=0 to high(Poly1) do
  for j:=0 to high(Poly2) do
    if LinesCrossTP(
        Poly1[i],Poly1[(i+1) mod length(Poly1)],
        Poly2[j],Poly2[(j+1) mod length(Poly2)],a) then
      exit;

  result:=false;
end;

procedure PlaneThroughFour4DPoints(x1,y1,z1,w1,x2,y2,z2,w2,x3,y3,z3,w3,x4,y4,z4,w4: single; var a,b,c,d,k: single);
{ equation of 3D plane in 4D is a*x + b*y + c*z + d*w + k = 0 }
begin
  a := -y1*z2*w3 +y1*z2*w4 +y1*z3*w2 -y1*z3*w4 -y1*z4*w2 +y1*z4*w3 +y2*z1*w3 -y2*z1*w4 -y2*z3*w1 +y2*z3*w4 +y2*z4*w1 -y2*z4*w3 -y3*z1*w2 +y3*z1*w4 +y3*z2*w1 -y3*z2*w4 -y3*z4*w1 +y3*z4*w2 +y4*z1*w2 -y4*z1*w3 -y4*z2*w1 +y4*z2*w3 +y4*z3*w1 -y4*z3*w2;
  b := +w1*x2*z3 -w1*x2*z4 -w1*x3*z2 +w1*x3*z4 +w1*x4*z2 -w1*x4*z3 -w2*x1*z3 +w2*x1*z4 +w2*x3*z1 -w2*x3*z4 -w2*x4*z1 +w2*x4*z3 +w3*x1*z2 -w3*x1*z4 -w3*x2*z1 +w3*x2*z4 +w3*x4*z1 -w3*x4*z2 -w4*x1*z2 +w4*x1*z3 +w4*x2*z1 -w4*x2*z3 -w4*x3*z1 +w4*x3*z2;
  c := -y1*w2*x3 +y1*w2*x4 +y1*w3*x2 -y1*w3*x4 -y1*w4*x2 +y1*w4*x3 +y2*w1*x3 -y2*w1*x4 -y2*w3*x1 +y2*w3*x4 +y2*w4*x1 -y2*w4*x3 -y3*w1*x2 +y3*w1*x4 +y3*w2*x1 -y3*w2*x4 -y3*w4*x1 +y3*w4*x2 +y4*w1*x2 -y4*w1*x3 -y4*w2*x1 +y4*w2*x3 +y4*w3*x1 -y4*w3*x2;
  d := +x1*y2*z3 -x1*y2*z4 -x1*y3*z2 +x1*y3*z4 +x1*y4*z2 -x1*y4*z3 -x2*y1*z3 +x2*y1*z4 +x2*y3*z1 -x2*y3*z4 -x2*y4*z1 +x2*y4*z3 +x3*y1*z2 -x3*y1*z4 -x3*y2*z1 +x3*y2*z4 +x3*y4*z1 -x3*y4*z2 -x4*y1*z2 +x4*y1*z3 +x4*y2*z1 -x4*y2*z3 -x4*y3*z1 +x4*y3*z2;
  k := -(x2*a+y2*b+z2*c+w2*d)
end;

procedure filltrian(Canvas: TCanvas; x1,y1,x2,y2,x3,y3: integer; col: TColor);
  procedure horizline(x1,x2,y: single; col: TColor);
  begin
    with Canvas do
    begin
      pen.color:=col;
      moveto(round(x1),round(y));
      lineto(round(x2),round(y));
    end;
  end;
var ey,sy: integer;
    ex,sx,dx1,dx2,dx3: single;
begin
  if y1 > y2 then
  begin
    filltrian(Canvas,x2,y2,x1,y1,x3,y3,col);
    exit;
  end;
  if y2 > y3 then
  begin
    filltrian(Canvas,x1,y1,x3,y3,x2,y2,col);
    exit;
  end;

  if (y2-y1 > 0) then dx1:=(x2-x1)/(y2-y1) else dx1:=0;
  if (y3-y1 > 0) then dx2:=(x3-x1)/(y3-y1) else dx2:=0;
  if (y3-y2 > 0) then dx3:=(x3-x2)/(y3-y2) else dx3:=0;

  Ex:=x1;
  Ey:=y1;
  Sx:=x1;
  Sy:=y1;
  if(dx1 > dx2) then begin
    while Sy<=y2 do
    begin
      horizline(Sx,Ex,Sy,col);
      Sy:=Sy+1;
      Ey:=Ey+1;
      Sx:=Sx+dx2;
      Ex:=Ex+dx1;
    end;
    Ex:=x2;
    Ey:=y2;
    while Sy<=y3 do
    begin
      horizline(Sx,Ex,Sy,col);
      Sy:=Sy+1;
      Ey:=Ey+1;
      Sx:=Sx+dx2;
      Ex:=Ex+dx3;
    end;
  end else
  begin
    while Sy<=y2 do
    begin
      horizline(Sx,Ex,Sy,col);
      Sy:=Sy+1;
      Ey:=Ey+1;
      Sx:=Sx+dx1;
      Ex:=Ex+dx2;
    end;
    Sx:=x2;
    Sy:=y2;
    while Sy<=y3 do
    begin
      horizline(Sx,Ex,Sy,col);
      Sy:=Sy+1;
      Ey:=Ey+1;
      Sx:=Sx+dx3;
      Ex:=Ex+dx2;
    end;
  end;
end;

procedure gouraudtrian(Canvas: TCanvas; x1,y1,x2,y2,x3,y3: integer; col1,col2,col3: TColor);
  procedure horizline(x1,x2,y,r1,g1,b1,r2,g2,b2: single);
  var x: integer;
      r,g,b: single;
  begin
    with Canvas do
    begin
      for x:=round(x1) to round(x2) do
      begin
        r:=r1+safedivide((r2-r1)*(x-x1),(x2-x1));
        g:=g1+safedivide((g2-g1)*(x-x1),(x2-x1));
        b:=b1+safedivide((b2-b1)*(x-x1),(x2-x1));
        pixels[x,round(y)]:=rgb(round(r),round(g),round(b));
      end;
    end;
  end;
var ey,sy: integer;
    ex,sx,dx1,dx2,dx3: single;
    er,sr,dr1,dr2,dr3: single;
    eg,sg,dg1,dg2,dg3: single;
    eb,sb,db1,db2,db3: single;
begin
//    DrawFilledTrian(Canvas,x1,y1,x2,y2,x3,y3,col);
  //exit;

  if y1 > y2 then
  begin
    gouraudtrian(Canvas,x2,y2,x1,y1,x3,y3,col2,col1,col3);
    exit;
  end;
  if y2 > y3 then
  begin
    gouraudtrian(Canvas,x1,y1,x3,y3,x2,y2,col1,col3,col2);
    exit;
  end;

  if (y2-y1 > 0) then
  begin
    dx1:=(x2-x1)/(y2-y1);
    dr1:=(red(col2)-red(col1))/(y2-y1);
    dg1:=(green(col2)-green(col1))/(y2-y1);
    db1:=(blue(col2)-blue(col1))/(y2-y1);
  end else
  begin
    dx1:=0;
    dr1:=0;
    dg1:=0;
    db1:=0;
  end;
  if (y3-y1 > 0) then
  begin
    dx2:=(x3-x1)/(y3-y1);
    dr2:=(red(col3)-red(col1))/(y3-y1);
    dg2:=(green(col3)-green(col1))/(y3-y1);
    db2:=(blue(col3)-blue(col1))/(y3-y1);
  end else
  begin
    dx2:=0;
    dr2:=0;
    dg2:=0;
    db2:=0;
  end;
  if (y3-y2 > 0) then
  begin
    dx3:=(x3-x2)/(y3-y2);
    dr3:=(red(col3)-red(col2))/(y3-y2);
    dg3:=(green(col3)-green(col2))/(y3-y2);
    db3:=(blue(col3)-blue(col2))/(y3-y2);
  end else
  begin
    dx3:=0;
    dr3:=0;
    dg3:=0;
    db3:=0;
  end;

  Ex:=x1;
  Ey:=y1;
  Sx:=x1;
  Sy:=y1;
  Er:=red(col1);
  Sr:=red(col1);
  Eg:=green(col1);
  Sg:=green(col1);
  Eb:=blue(col1);
  Sb:=blue(col1);

  if(dx1 > dx2) then begin
    while Sy<=y2 do
    begin
      horizline(Sx,Ex,Sy,Sr,Sg,Sb,Er,Eg,Eb);
      Sy:=Sy+1;
      Ey:=Ey+1;
      Sx:=Sx+dx2;
      Sr:=Sr+dr2;
      Sg:=Sg+dg2;
      Sb:=Sb+db2;
      Ex:=Ex+dx1;
      Er:=Er+dr1;
      Eg:=Eg+dg1;
      Eb:=Eb+db1;
    end;
    Ex:=x2;
    Ex:=x2;
    Er:=red(col2);
    Eg:=green(col2);
    Eb:=blue(col2);
    Ey:=y2;
    while Sy<=y3 do
    begin
      horizline(Sx,Ex,Sy,Sr,Sg,Sb,Er,Eg,Eb);
      Sy:=Sy+1;
      Ey:=Ey+1;
      Sx:=Sx+dx2;
      Sr:=Sr+dr2;
      Sg:=Sg+dg2;
      Sb:=Sb+db2;
      Ex:=Ex+dx3;
      Er:=Er+dr3;
      Eg:=Eg+dg3;
      Eb:=Eb+db3;
    end;
  end else
  begin
    while Sy<=y2 do
    begin
      horizline(Sx,Ex,Sy,Sr,Sg,Sb,Er,Eg,Eb);
      Sy:=Sy+1;
      Ey:=Ey+1;
      Sx:=Sx+dx1;
      Sr:=Sr+dr1;
      Sg:=Sg+dg1;
      Sb:=Sb+db1;
      Ex:=Ex+dx2;
      Er:=Er+dr2;
      Eg:=Eg+dg2;
      Eb:=Eb+db2;
    end;
    Sx:=x2;
    Sr:=red(col2);
    Sg:=green(col2);
    Sb:=blue(col2);
    Sy:=y2;
    while Sy<=y3 do
    begin
      horizline(Sx,Ex,Sy,Sr,Sg,Sb,Er,Eg,Eb);
      Sy:=Sy+1;
      Ey:=Ey+1;
      Sx:=Sx+dx3;
      Sr:=Sr+dr3;
      Sg:=Sg+dg3;
      Sb:=Sb+db3;
      Ex:=Ex+dx2;
      Er:=Er+dr2;
      Eg:=Eg+dg2;
      Eb:=Eb+db2;
    end;
  end;
end;

procedure gouraudtrianBres(Canvas: TCanvas; x1,y1,x2,y2,x3,y3: integer; col1,col2,col3: TColor);
  procedure horizline(x1,x2,y,r1,g1,b1,r2,g2,b2: single);
  var x: integer;
      r,g,b: single;
  begin
    with Canvas do
    begin
      for x:=round(x1) to round(x2) do
      begin
        r:=r1+safedivide((r2-r1)*(x-x1),(x2-x1));
        g:=g1+safedivide((g2-g1)*(x-x1),(x2-x1));
        b:=b1+safedivide((b2-b1)*(x-x1),(x2-x1));
        pixels[x,round(y)]:=rgb(round(r),round(g),round(b));
      end;
    end;
  end;
var ey,sy: integer;
    x21,x31,x32: integer;
    y21,y31,y32: integer;
    ex,sx: integer;
    dx1,dx2,dx3: integer;
    er,sr: integer;
    dr1,dr2,dr3: integer;
    eg,sg: integer;
    dg1,dg2,dg3: integer;
    eb,sb: integer;
    db1,db2,db3: integer;
begin
{works but I have't finished converting it to bresenham yet}
  if y1 > y2 then
  begin
    gouraudtrian(Canvas,x2,y2,x1,y1,x3,y3,col2,col1,col3);
    exit;
  end;
  if y2 > y3 then
  begin
    gouraudtrian(Canvas,x1,y1,x3,y3,x2,y2,col1,col3,col2);
    exit;
  end;

  x21:=x2-x1;
  x31:=x3-x1;
  x32:=x3-x2;
  y21:=y2-y1;
  y31:=y3-y1;
  y32:=y3-y2;

  if (y21 > 0) then
  begin
    dx1:=(x21);
    dr1:=(red(col2)-red(col1));
    dg1:=(green(col2)-green(col1));
    db1:=(blue(col2)-blue(col1));
  end else
  begin
    dx1:=0;
    dr1:=0;
    dg1:=0;
    db1:=0;
  end;
  if (y31 > 0) then
  begin
    dx2:=(x31);
    dr2:=(red(col3)-red(col1));
    dg2:=(green(col3)-green(col1));
    db2:=(blue(col3)-blue(col1));
  end else
  begin
    dx2:=0;
    dr2:=0;
    dg2:=0;
    db2:=0;
  end;
  if (y32 > 0) then
  begin
    dx3:=(x32);
    dr3:=(red(col3)-red(col2));
    dg3:=(green(col3)-green(col2));
    db3:=(blue(col3)-blue(col2));
  end else
  begin
    dx3:=0;
    dr3:=0;
    dg3:=0;
    db3:=0;
  end;

  Ex:=x1;
  Ey:=y1;
  Sx:=x1;
  Sy:=y1;
  Er:=red(col1);
  Sr:=red(col1);
  Eg:=green(col1);
  Sg:=green(col1);
  Eb:=blue(col1);
  Sb:=blue(col1);

  if(dx1/y21 > dx2/y31) then begin
    while Sy<=y2 do
    begin
      horizline(Sx/y31,Ex/y21,Sy,Sr/y31,Sg/y31,Sb/y31,Er/y21,Eg/y21,Eb/y21);
      Sy:=Sy+1;
      Ey:=Ey+1;
      Sx:=Sx+dx2;
      Sr:=Sr+dr2;
      Sg:=Sg+dg2;
      Sb:=Sb+db2;
      Ex:=Ex+dx1;
      Er:=Er+dr1;
      Eg:=Eg+dg1;
      Eb:=Eb+db1;
    end;
    Ex:=x2;
    Ex:=x2;
    Er:=red(col2);
    Eg:=green(col2);
    Eb:=blue(col2);
    Ey:=y2;
    while Sy<=y3 do
    begin
      horizline(Sx/y31,Ex/y32,Sy,Sr/y31,Sg/y31,Sb/y31,Er/y32,Eg/y32,Eb/y32);
      Sy:=Sy+1;
      Ey:=Ey+1;
      Sx:=Sx+dx2;
      Sr:=Sr+dr2;
      Sg:=Sg+dg2;
      Sb:=Sb+db2;
      Ex:=Ex+dx3;
      Er:=Er+dr3;
      Eg:=Eg+dg3;
      Eb:=Eb+db3;
    end;
  end else
  begin
    while Sy<=y2 do
    begin
      horizline(Sx/y21,Ex/y31,Sy,Sr/y21,Sg/y21,Sb/y21,Er/y31,Eg/y31,Eb/y31);
      Sy:=Sy+1;
      Ey:=Ey+1;
      Sx:=Sx+dx1;
      Sr:=Sr+dr1;
      Sg:=Sg+dg1;
      Sb:=Sb+db1;
      Ex:=Ex+dx2;
      Er:=Er+dr2;
      Eg:=Eg+dg2;
      Eb:=Eb+db2;
    end;
    Sx:=x2;
    Sr:=red(col2);
    Sg:=green(col2);
    Sb:=blue(col2);
    Sy:=y2;
    while Sy<=y3 do
    begin
      horizline(Sx/y32,Ex/y31,Sy,Sr/y32,Sg/y32,Sb/y32,Er/y31,Eg/y31,Eb/y31);
      Sy:=Sy+1;
      Ey:=Ey+1;
      Sx:=Sx+dx3;
      Sr:=Sr+dr3;
      Sg:=Sg+dg3;
      Sb:=Sb+db3;
      Ex:=Ex+dx2;
      Er:=Er+dr2;
      Eg:=Eg+dg2;
      Eb:=Eb+db2;
    end;
  end;
end;

function PointInsideTriangleSingle(pt,p1,p2,p3: TSinglePoint): boolean;
begin
  result:=false;
  if (pt.x < p1.x) and (pt.x < p2.x) and (pt.x < p3.x) then
    exit;
  if (pt.y < p1.y) and (pt.y < p2.y) and (pt.y < p3.y) then
    exit;

  if p3.x <> p1.x then
    if (pt.x >  p3.x) = (pt.x <= p1.x) then
      if pt.y-p3.y <= (pt.x-p3.x)*(p1.y-p3.y)/(p1.x-p3.x) then
        result:=not result;
  if p1.x <> p2.x then
    if (pt.x >  p1.x) = (pt.x <= p2.x) then
      if pt.y-p1.y <= (pt.x-p1.x)*(p2.y-p1.y)/(p2.x-p1.x) then
        result:=not result;
  if p2.x <> p3.x then
    if (pt.x >  p2.x) = (pt.x <= p3.x) then
      if pt.y-p2.y <= (pt.x-p2.x)*(p3.y-p2.y)/(p3.x-p2.x) then
        result:=not result;
end;

function ClipLineToRect(var x1,y1,x2,y2: integer; rect: TRect): boolean;
  function Clip(var x1,y1,x2,y2: integer; x: integer; b: boolean): boolean;
  begin
    if x1 = x2 then
      exit;
    if (x1 > x2) = b then
      result:=Clip(x2,y2,x1,y1,x,b) else
    if ((x1 < x) = b) and ((x2 > x) = b) then
    begin
      y1:=round((y2-y1)*(x-x1)/(x2-x1))+y1;
      x1:=x;
    end;
  end;
begin
  Clip(x1,y1,x2,y2,rect.left,true);
  Clip(y1,x1,y2,x2,rect.top,true);
  Clip(x1,y1,x2,y2,rect.right,false);
  Clip(y1,x1,y2,x2,rect.bottom,false);
  result:=
      PtinRect(Rect,Point((x1+x2) div 2,(y1+y2) div 2));
end;

function Det3x3(A: TMatrix3X3): Single;
begin
  result:=a[1,1]*(a[2,2]*a[3,3]-a[2,3]*a[3,2])-a[1,2]*(a[2,1]*a[3,3]-a[2,3]*a[3,1])+a[1,3]*(a[2,1]*a[3,2]-a[2,2]*a[3,1]);
end;

function PlaneThroughManyPoints(p: array of T3DPoint): TPlane;
var i: integer;
    means: T3DPoint;
    ax1,ay1,az1,ax2,ay2,az2,ax3,ay3,az3,sxz,syy,syz,szz,sxy,sxx: single;
begin
  means:=MeanPoint3D(p);

  sxx:=0;
  sxy:=0;
  sxz:=0;
  syy:=0;
  syz:=0;
  szz:=0;
  for i:=low(p)+1 to high(p) do
  begin
    sxx:=sxx+(p[i].x-means.x)*(p[i].x-means.x);
    sxy:=sxy+(p[i].x-means.x)*(p[i].y-means.y);
    sxz:=sxz+(p[i].x-means.x)*(p[i].z-means.z);
    syy:=syy+(p[i].y-means.y)*(p[i].y-means.y);
    syz:=syz+(p[i].y-means.y)*(p[i].z-means.z);
    szz:=szz+(p[i].z-means.z)*(p[i].z-means.z);
  end;

  ax1:=sxz*syy-sxy*syz;
  ay1:=sxx*syz-sxy*sxz;
  az1:=sxy*sxy-sxx*syy;

  ax2:=sxz*syz-sxy*szz;
  ay2:=sxx*szz-sxz*sxz;
  az2:=-ay1;

  ax3:=syy*szz-syz*syz;
  ay3:=ax2;
  az3:=-ax1;

  //az3:=xy_yz-xz_yy;
  //assert(az3=-ax1);
  //az2:=xy_xz-xx_yz;
  //assert(az2=-ay1);
  //ay3:=xz_yz-xy_zz;
  //assert(ax2=ay3);

  result.p:=Normalise3D(a3dpoint(ax1+ax2+ax3,ay1+ay2+ay3,az1+az2+az3));
  result.d:=-DotProduct3D(means,result.p);
end;

const
  SE_CREATE_TOKEN_NAME = 'SeCreateTokenPrivilege';
  SE_ASSIGNPRIMARYTOKEN_NAME = 'SeAssignPrimaryTokenPrivilege';
  SE_LOCK_MEMORY_NAME = 'SeLockMemoryPrivilege';
  SE_INCREASE_QUOTA_NAME = 'SeIncreaseQuotaPrivilege';
  SE_UNSOLICITED_INPUT_NAME = 'SeUnsolicitedInputPrivilege';
  SE_MACHINE_ACCOUNT_NAME = 'SeMachineAccountPrivilege';
  SE_TCB_NAME = 'SeTcbPrivilege';
  SE_SECURITY_NAME = 'SeSecurityPrivilege';
  SE_TAKE_OWNERSHIP_NAME = 'SeTakeOwnershipPrivilege';
  SE_LOAD_DRIVER_NAME = 'SeLoadDriverPrivilege';
  SE_SYSTEM_PROFILE_NAME = 'SeSystemProfilePrivilege';
  SE_SYSTEMTIME_NAME = 'SeSystemtimePrivilege';
  SE_PROF_SINGLE_PROCESS_NAME = 'SeProfileSingleProcessPrivilege';
  SE_INC_BASE_PRIORITY_NAME = 'SeIncreaseBasePriorityPrivilege';
  SE_CREATE_PAGEFILE_NAME = 'SeCreatePagefilePrivilege';
  SE_CREATE_PERMANENT_NAME = 'SeCreatePermanentPrivilege';
  SE_BACKUP_NAME = 'SeBackupPrivilege';
  SE_RESTORE_NAME = 'SeRestorePrivilege';
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
  SE_DEBUG_NAME = 'SeDebugPrivilege';
  SE_AUDIT_NAME = 'SeAuditPrivilege';
  SE_SYSTEM_ENVIRONMENT_NAME = 'SeSystemEnvironmentPrivilege';
  SE_CHANGE_NOTIFY_NAME = 'SeChangeNotifyPrivilege';
  SE_REMOTE_SHUTDOWN_NAME = 'SeRemoteShutdownPrivilege';
  SE_UNDOCK_NAME = 'SeUndockPrivilege';
  SE_SYNC_AGENT_NAME = 'SeSyncAgentPrivilege';
  SE_ENABLE_DELEGATION_NAME = 'SeEnableDelegationPrivilege';
  SE_MANAGE_VOLUME_NAME = 'SeManageVolumePrivilege';

function NTSetPrivilege(sPrivilege: string; bEnabled: Boolean): Boolean;
var
  hToken: THandle;
  TokenPriv: TOKEN_PRIVILEGES;
  PrevTokenPriv: TOKEN_PRIVILEGES;
  ReturnLength: Cardinal;
begin
  Result := True;
  // Only for Windows NT/2000/XP and later.
  if not (Win32Platform = VER_PLATFORM_WIN32_NT) then Exit;
  Result := False;

  // obtain the processes token
  if OpenProcessToken(GetCurrentProcess(),
    TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
  begin
    try
      // Get the locally unique identifier (LUID) .
      if LookupPrivilegeValue(nil, PChar(sPrivilege),
        TokenPriv.Privileges[0].Luid) then
      begin
        TokenPriv.PrivilegeCount := 1; // one privilege to set

        case bEnabled of
          True: TokenPriv.Privileges[0].Attributes  := SE_PRIVILEGE_ENABLED;
          False: TokenPriv.Privileges[0].Attributes := 0;
        end;

        ReturnLength := 0; // replaces a var parameter
        PrevTokenPriv := TokenPriv;

        // enable or disable the privilege

        AdjustTokenPrivileges(hToken, False, TokenPriv, SizeOf(PrevTokenPriv),
          PrevTokenPriv, ReturnLength);
      end;
    finally
      CloseHandle(hToken);
    end;
  end;
  // test the return value of AdjustTokenPrivileges.
  Result := GetLastError = ERROR_SUCCESS;
  if not Result then
    raise Exception.Create(SysErrorMessage(GetLastError));
end;

procedure ShutDownWindows;
begin
  if not NTSetPrivilege(SE_SHUTDOWN_NAME,true) then
    raise Exception.Create('Unable to shut down: SetPrivilege failed');
  if not ExitWindowsEx(EWX_SHUTDOWN,0) then {EWX_POWEROFF}
    ShowErrorMessage('Unable to shut down: '+LastError);
end;

procedure Listbox_CalcLineHeights(AListbox:TListbox);
var
  i, h : integer;
  MeasureItemEvent : TMeasureItemEvent;
begin
  if Assigned(AListbox) and AListbox.HandleAllocated then begin
    with AListbox do begin
      MeasureItemEvent := OnMeasureItem;
      if Assigned(MeasureItemEvent) then begin
        for i:=0 to Items.Count-1 do begin
          MeasureItemEvent(AListbox, i, h);
          SendMessage(Handle, LB_SETITEMHEIGHT, i, h);
        end;
      end;
    end;
  end;
end;

procedure StartTouch(handle: hwnd);
{ Windows will now send WM_TOUCH messages instead of WM_GESTURE messages to your window. }
{ TWF_FINETOUCH Specifies that hWnd prefers noncoalesced touch input.
{ TWF_WANTPALM  Setting this flag disables palm rejection which reduces delays for getting WM_TOUCH messages. This is useful if you want as quick of a response as possible when a user touches your application.
{ By default, palm detection is enabled and some WM_TOUCH messages are prevented from being sent to your application. This is useful if you do not want to receive WM_TOUCH messages that are from palm contact. }
{discussion:   http://the-witness.net/news/2012/10/wm_touch-is-totally-bananas/comment-page-1/}
begin
  RegisterTouchWindow(handle, 0);
end;

function FormExists(fm: TForm): boolean;
var i: integer;
begin
  result:=true;
  for i:=0 to Screen.FormCount-1 do
    if Screen.Forms[i] = fm then
      exit;
  result:=false;
end;

function GetVolumeSerialNumber(const DriveLetter: Char): DWORD;
var
  NotUsed:     DWORD;
  VolumeFlags: DWORD;
  VolumeInfo:  array[0..MAX_PATH] of Char;
  VolumeSerialNumber: DWORD;
begin
  GetVolumeInformation(PChar(DriveLetter + ':\'),
    nil, SizeOf(VolumeInfo), @VolumeSerialNumber, NotUsed,
    VolumeFlags, nil, 0);
  Result := VolumeSerialNumber;
end;

end.
=============================================================



function MapWindowPoints(hWndFrom, hWndTo: HWND; var lpPoints; cPoints: UINT): Integer; stdcall;
{$EXTERNALSYM WindowFromPoint}
function WindowFromPoint(Point: TPoint): HWND; stdcall;
{$EXTERNALSYM ChildWindowFromPoint}
function ChildWindowFromPoint(hWndParent: HWND; Point: TPoint): HWND; stdcall;
function ChildWindowFromPointEx(hWnd: HWND; Point: TPoint; Flags: UINT): HWND; stdcall;
FUNCTION RealChildWindowFromPoint(hwndParent: HWND; ptParentClientCoords: TPoint): HWND; stdcall;

'C:\Delphi 4\Clinasst\Release_217_01\EchoB\Anavals.avl'


