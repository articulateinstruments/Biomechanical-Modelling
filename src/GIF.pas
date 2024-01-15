  // Delphi5 (object Pascal)
unit GIF;
  //Compilation: P.M.Pavloff, 2002,2003 pmp463@yahoo.com
  //read GIF as Bitmap
  //write Bitmap as GIF
interface

uses Windows, Classes, Graphics,Dialogs,Sysutils,
 GIF24,     //GIF decoder
 GifWrite,  //GIF encoder
 graph42;   //dithering

type

  STC=function(P:pointer):integer of object;

  TGifBitmap = class(TBitmap)
  private
    Fcomment: shortstring;
    FTC: STC;
    procedure Setcomment(const Value: shortstring);
    procedure SetTC(const Value: STC);
    function SelectTransparentColor(COL: pointer): integer;

  published
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;

    property comment:shortstring read Fcomment write Setcomment;
    property TC:STC read FTC write SetTC;

  private
    transparentColor:integer;
  end;


Procedure SaveAsGIF(BMP:TBitmap;FileName:string);

implementation

type
 TBMPStream=class(TStream)     //ok without Write
 private
   fsize,
   fposition:longint;
   BMP:TBitmap;
 protected
   procedure SetSize(NewSize: Longint); override;
 public
   constructor Create(bitmap:TBitmap);
   function Read(var Buffer; Count: Longint): Longint;override;
   function Seek(Offset: Longint; Origin: Word): Longint;override;
   function Write(const Buffer; Count: Longint): Longint; override;
 end;


procedure SaveAsGIF(BMP:TBitmap;FileName:string);
var GIF:TGIFbitmap;
Begin
 GIF:=TGifBitmap.Create;
 try
  Gif.Assign(BMP);
  Gif.SaveToFile(FileName);
 finally
  GIF.Free;
 end;
End;
(* *)

(*
 Procedure SwapRedBLUE(var COL;size:cardinal);
type
 rgbpal=array[0..255,1..3] of byte;
   ppal=^rgbpal;
var i:integer;
 P:PPal;
 temp:byte;
Begin
 P:=@COL;
for i:= 1 to size do
 begin
   temp:=P^[i-1,1];
   P^[i-1,1]:=P^[i-1,3];
   P^[i-1,3]:=temp;
 end;
End;
  (*  *)

 Function hPAL_PAL(hpal: HPALETTE;var COL):word;
type RGB_pal=array[0..255,1..3] of byte;
var
 dm:Array[0..255] of TPaletteEntry;
 //hpal           // handle of logical color palette
 iStartIndex,     // first entry to retrieve
 nEntries:uint;   // number of entries to retrieve
// lppe: PALETTEENTRY; 	// address of array receiving entries
 n:word;
 y:integer;
 COLORS:^RGB_PAL;
Begin
  COLORS:=@COL;

  iStartIndex:=0;	// first entry to retrieve
  nEntries:=256;	// number of entries to retrieve

n:=GetPaletteEntries(
  hpal,	        // handle of logical color palette
  iStartIndex,	// first entry to retrieve
  nEntries,    	// number of entries to retrieve
  dm            // address of array receiving entries
  );

 for y:=0 to n-1 do
 begin
   COLORS[y,1]:=dm[y].peRed;
   COLORS[y,2]:=dm[y].peGreen;
   COLORS[y,3]:=dm[y].peBlue;
 end;
 result:=n;
End;{hPAL_PAL}

procedure TGifBitmap.LoadFromStream(Stream: TStream);
var
 GIFDecoder:TbmpGifDecoder;
begin
  GifDecoder:=TbmpGifDecoder.Create;
  try
   //self.PixelFormat:=pf8bit;
   GifDecoder.LoadAsBitmap(Stream,self);
  finally
   GifDecoder.Free;
  end;
end;

function LastColor(BMP:Tbitmap):integer;
var
P:^byte;
i,j:integer;
max:integer;
Begin
 max:=255;
 case bmp.PixelFormat of
 pf1bit: max:=1;
 pf4bit: max:=15;
 pf8bit:
 begin
  max:=0;
  for i:=0 to bmp.height-1 do
   begin
    P:=BMP.scanline[i];
    for j:=1 to bmp.Width do
    begin
      if max<P^ then max:=P^;
      inc(P);
    end;
   end;//for i
 end;
 end;//case bmp.PixelFormat
 result:=max;
End;

procedure TGifBitmap.SaveToStream(Stream: TStream);
var
 col:array[0..255,1..3] of byte; //color palette
 TempStream:TStream;
 bc,bpp:integer;

Begin //TGifBitmap.SaveToStream
 if (width<1) or (height<1) then exit;
 case pixelFormat of
  pf1bit,pf4bit,pf8bit: begin end;
  else graph42.BMP24_8(self);
  {converts 24-bit RGB to 8-bit 256 indexed colours Floyd-Steinberg dithering}
 end;

 TempStream:=TBMPStream.Create(self);

 try
 bc:=LastColor(self);

  // ShowMessage('TGifBitmap.SaveToStream lastcolor = '+inttostr(bc));
 bpp:=0;
 while bc<>0 do
  begin
   inc(bpp);
   bc:=bc shr 1;
  end; //COMPUTE BITS PER PIXEL

  if bpp<2 then bpp:=2;    //can not write binary GIF yet

 TempStream.Seek(0,soFromBeginning);
 HPAL_PAL(self.palette,col);
 //SwapRedBLUE(col,256);

 transparentColor:=SelectTransparentColor(@COL);

 if transparentColor<>-1
  then GIFwr(TempStream,Stream, bpp,width,height, @COL,comment,true,transparentColor)
  else
   if comment<>''
    then GIFwr(TempStream,Stream, bpp,width,height, @COL,comment,false,transparentColor)
    else GIFwr(TempStream,Stream, bpp,width,height, @COL);

 finally
  TempStream.Free;
 end;

End; //TGifBitmap.SaveToStream


{ TBMPStream }

constructor TBMPStream.Create(bitmap: TBitmap);
begin
 BMP:=bitmap;
 fsize:=bmp.Width*bmp.Height;
 fposition:=0;
end;


Procedure CopyScanLineAsPf8bit(
 sourceLine,dest:pointer;
 width:longint;
 PixelFormat:TPixelFormat);
type
 mas=array[0..1] of byte;
 pmas=^mas;
var
 i,x:integer;
 bt,bb,outbyte:byte;
  LINE:pmas;
   CON:pmas;

  label loop1,loop4;
Begin
 Line:=sourceLine;
 CON:=dest;

 case PixelFormat of
  pf8bit: move(sourceLine^,dest^,width);
  pf1bit:
   begin
      bt:=$80;
      x:=0;
      bb:=Line[x];
      for i:=1 to width do
       begin
        if (bb and bt)<>0 then outbyte:=1 else outbyte:=0;
        CON[i-1]:=outbyte;
        asm
         ROR byte ptr bt,1
         JNC loop1
        end;
        inc(x);
        if i<width then bb:=Line[x];
loop1:
      end; //for i

   end; //case pf1bit

  pf4bit:
   begin
      bt:=$F0;
      x:=0;
      bb:=Line[x];
      for i:=1 to width do
       begin
        if bt=$F0 then outbyte:=bb shr 4 else outbyte:=bb and $0F;
        CON[i-1]:=outbyte;
        asm
         ROR byte ptr bt,4
         JNC loop4
        end;
        inc(x);
        if i<width then bb:=Line[x];
loop4:
       end; //for i
   end; //case pf4bit
 end;//case
END;

function TBMPStream.Read(var Buffer; Count: Integer): Longint;
type
 mas=array[0..1] of byte;
pmas=^mas;
var
 LINE:pmas;
 lineSize:cardinal;

 SOR:pointer;
 PBUF:^byte;

 width,
 row,deltaX,
 len,len2,
 outbytes :longint;

 PixelFormat:TPixelFormat;

 label loop;
Begin
  outbytes:=0;
  PBUF:=@Buffer; //pointer to buffer
  len:=count;
  if (len+fposition)>fsize then len:=fsize-fposition;

  lineSize:=bmp.Width;
  GetMem(LINE,lineSize);

  width:=bmp.Width;
  PixelFormat:=bmp.pixelFormat;

  try
  repeat
   len2:=len;

   row:=fposition div width;  //compute row
   asm
     mov deltaX,edx // deltaX:=position mod bmp.Width;  //compute ofset
   end;

   CopyScanLineAsPf8bit(bmp.ScanLine[row],LINE,width,PixelFormat);
  {$R-}
   Sor:=@LINE^[deltaX];
   {$R+}

   if (deltax+len2)>width then len2:=width-deltax;
   //check for overflow scanLine

   Move(SOR^,PBuf^,len2);
   inc(PBuf,len2);               //inrease buffer poiner
   inc(outbytes,len2);           //inrease outbytes
   fposition:=fposition+len2;    //inrease stream position
   dec(len,len2);                //decrease required bytes
  until len<=0;      //end?

  finally
   FreeMem(LINE,lineSize);
  end;

  result:=outBytes;
End;

function TBMPStream.Seek(Offset: Integer; Origin: Word): Longint;
Begin
 fsize:=bmp.Width*bmp.Height;

 case origin of
  soFromBeginning:     //Offset is from the beginning of the resource.
  // Seek moves to the position Offset. Offset must be >= 0.
       fposition:=offset;

  soFromCurrent:     //Offset is from the current position in the resource.
  // Seek moves to Position + Offset.
        fposition:=fposition+offset;

  soFromEnd: fposition:=fsize+offset

 end;//case

   if fposition>fsize then fposition:=fsize;
   if fposition<0 then fposition:=0;

   result:=fposition;
End;

procedure TBMPStream.SetSize(NewSize: Integer);
begin
  fsize:=newSize;
end;

function TBMPStream.Write(const Buffer; Count: Integer): Longint;
begin
 result:=0;
end;

function TGifBitmap.SelectTransparentColor(COL: pointer): integer;
begin
  if assigned(TC)
    then result:=TC(COL)
    else result:=-1;
end;

procedure TGifBitmap.Setcomment(const Value: shortstring);
begin
  Fcomment := Value;
end;

procedure TGifBitmap.SetTC(const Value: STC);
begin
  FTC := Value;
end;

initialization
  TPicture.RegisterFileFormat('GIF', 'GIF Bitmap', TGifBitmap);
finalization
  TPicture.UnregisterGraphicClass(TGifBitmap);
end.

    {$R-}
    {$R+}

