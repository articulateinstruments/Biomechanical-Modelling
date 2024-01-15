unit GIF24;  // GIF decoder
INTERFACE
uses Windows,Graphics,Classes;

const
 readBufferSize=2048;{512..2048}
    maxCodeSize=12;
       Code4095=(1 shl maxCodeSize)-1;
         maxOut=Code4095;
type
    integer2=integer;
       word2=integer;
        long=longint;

  byteZArray=Array[0..$7FFF] of byte;
    zArr4096=Array[0..code4095] of integer2;
    zArr1024=Array[0..maxOut] of integer2;

 RGB_Palette=array[0..255,1..3] of byte;
 PGifDecoder=^TGifDecoder;

TGifDecoder=class
public
  signature,                     {GIF}
  version: array[1..3] of char;  {87a/89a/..}

  COL:RGB_Palette;

  TotalX, TotalY,
  BitsPixel,
  XLength,
  YLength,
  infoByte,
  color_res:integer2;

  localcolorTable,
  globalColorTable,
  interlaced:boolean;

  numcolors,
  BackGround: integer2;
  sdAspectRatio:integer2;
  Function DecodeGIF(ST:TStream):integer2;
protected
  Procedure InitImage(
           PAL:RGB_palette;
   xsize,ysize:integer;
        numCOL:integer);virtual;abstract;

  Procedure PutALine(
          Line:pointer;
        length:word2;    //in bytes
     yPosition:integer2);virtual;abstract;
  {Put 1 Line somewhere}

private
  procedure GetCode;
  procedure PutLineSomewhere;
  Function RDByte:byte;
  Function RDWord:word2;

private
  X, Y,dy,
  yPos:integer2;

  XStart, YStart, XEnd, YEnd:integer2;
  end_of_file:wordbool;
  InputStream:TStream;
  Address:word2;
  RdBUFFER:array[1..readBufferSize] of byte;
  NumRead:long;
  LineBUFF:^byteZArray; // buffer for 1 line of GIF Image
  Prefix,Suffix:zArr4096;
  OutCode:zArr1024;

  restBits:word2;

  CodeSize,
  ClearCode,
  EOFCode, FirstFree,
  InitCodeSize,MaxCode,
  BitMask, FreeCode, BlockLength, Num,
  OutCount,
  CurCode, OldCode,
  FinChar, InCode,
  CodeMask,
  buffLen:integer2;

  Code,TempChar:long;

  BB,ByteBuffer: byte;
end; //TGifDecoder

TBmpGifDecoder=class(TGifDecoder)
 public
 BMP:TBitmap;
 Procedure LoadAsBitmap(STR:TStream;Bitmap:TBitmap);
 protected
 procedure PutALine(Line:pointer;length:word2; yPosition:integer2);override;
 Procedure InitImage(
          PAL:RGB_palette;
  xsize,ysize:integer;
       numCOL:integer);override;
end;

Implementation
//const GIF_Error_Message='Error in GIF file';
type
  TGraphicExtension = packed Record
    geSize: Byte;                          { Always 4 }
    geInfo: Byte;
    geDelay: Word;                         { In 100ths of a second }
    geTransparentColor: Byte;
    geTerminator: Byte;                    { 0 }
  end;

const
  idExtension = $21;
  idImage = $2C;
  idTrailer = $3B;

  lblPlainText = $01;
  lblGraphicControl = $F9;
  lblComment = $FE;
  lblApplication = $FF;

  sdGlobalColorTable = $80;
  sdColorResolution = $70;
  sdSorted = $08;
  sdColorTableSize = $07;

  idLocalColorTable = $80;
  idInterlaced = $40;
  idSorted = $20;
  idReserved = $0C;
  idColorTableSize = $07;

  geReserved = $E0;
  geDisposalMethod = $1C;
  geUserInput = $02;
  geUseTransparency = $01;


Function TGifDecoder.RDByte:byte; {read byte from buffer}
Begin
 If Address > NumRead then
 begin
   numread:=InputStream.Read(RDBuffer, readBufferSize);
   Address := 1;
   end_of_file:=(numRead=0);
 end;
 result := RdBuffer[Address]; inc(Address);{}
End;

Function TGifDecoder.RDWord:word2; {read word2}
var w:integer2;
Begin
 w:=RDByte;
 result:=w + RDByte*256;
End;

procedure TGifDecoder.PutLineSomewhere;
Begin
  if interlaced
  then
   begin
    if dy=16
     then inc(yPos,8)
     else inc(yPos,dy);
    if yPos>=ylength then
     begin
         dy:=dy shr 1;
       ypos:=dy shr 1;
     end;
   end

  else yPos:=y;

  PutALine(LineBUFF,xlength,yPos);{somewhere}
  inc(y);
End;

Procedure TGifDecoder.GetCode;
label loop1;
var temp:integer2;
Begin
  while restbits<codeSize do
  begin
loop1:
   inc(Num);
   temp:=RDbyte;
   if Num = BlockLength then
    begin
     BlockLength := temp + 1;
     Num := 0;
    goto loop1;
    end;
   tempChar:=tempChar or (temp shl restBits);
   inc(restBits,8);
  end;
  code:=tempChar and codeMask;
  {<=> code:=tempChar and((1 shl codesize )- 1); {}
  tempChar:=tempChar shr codeSize;
  dec(restBits,codeSize);
End;{Get Code}


Function TGifDecoder.DecodeGIF;
label LOP1,ErrExit2,ende;
var
  a: integer2;
 linesCount:integer2;

label loop1,loop2,GC,CC;
Begin {TGIFdecoder.DecGIF}
  result:=-1;
  InputStream:=ST;

  end_of_file:=false;
   interlaced:=false; dy:=16 ;yPos:=-8;

   oldCode:=0;
   FinChar:=0;
  restBits:=0; { rest bits in tempChar }
  tempchar:=0;
   numRead:=0;
   Address:=readBufferSize+1;

  for a:=1 to 3 do byte(signature[a]):=RDbyte;
  for a:=1 to 3 do byte(  version[a]):=RDbyte;
  If 'GIF'<>signature then Exit;
  TotalX:=RDword;
  TotalY:=RDword;

 { if (totalX*totalY)>16000000 then
  begin
    Raise Exception.Create('GIF file is too big!');
  end;{}

  infoByte:= RDbyte;
  color_res:= (infoByte shr 4) and 7 + 1;
  BitsPixel := (infoByte And 7) + 1;
  globalColorTable:=(infoByte and $80)<>0;

  BackGround := RDbyte;
  sdAspectRatio:=RDbyte;  //  sdAspectRatio: Byte;

  if globalColorTable then
  begin
   numcolors:= 1 shl BitsPixel;
   for a:=0 to numColors-1 do
   begin
    COL[a,3]:=RDbyte;
    COL[a,2]:=RDbyte;
    COL[a,1]:=RDbyte;
   end;
  end;

 repeat
LOP1:
 ByteBuffer:=RDbyte;
 case byteBuffer of
   $21:
    begin
     ByteBuffer:=RDbyte;
     case byteBuffer of
       lblApplication:
        begin
          ByteBuffer:=RDbyte;
          for a:=1  to ByteBuffer do
          begin
            ByteBuffer:=RDbyte;
          end;

          ByteBuffer:=RDbyte;
          for a:=1  to ByteBuffer do
          begin
            ByteBuffer:=RDbyte;
          end;

        end;
       lblGraphicControl:
         begin
           for a:=1 to SizeOf(TGraphicExtension) do
           begin
            ByteBuffer:=RDbyte;
           end;
         end;
       lblComment:
         begin
          repeat ByteBuffer:=RDbyte;
          until (byteBuffer=0) or end_of_file;
           if end_of_file then Exit;
         end;//lblComment

        lblPlainText: {Skip it}
           begin
           end;

       else
        begin // ShowMessage('GIF: unknown extension!');
        end;

     end;
    end;//case $21

   idImage:

 Begin
  linescount:=0;

    XStart:=RDword;
    YStart:=RDword;
   XLength:=RDword;
   YLength:=RDword;

   if (Xlength > totalX)
   or (Ylength > totalY)
    then
     begin
       totalx:=Xlength;    //PETER 2003 05 11
       totalY:=Ylength;
     end;

   XEnd :=XStart + XLength - 1;
   YEnd :=YStart + YLength - 1;

   BB:=RDbyte;

    interlaced:=(bb and idInterlaced)<>0;
    localColorTable:=(bb and idLocalColorTable)<>0;

    if localColorTable then
    begin
     numcolors:= 1 shl ((bb and $7)+1);
     for a:=0 to numcolors-1 do
     begin
      COL[a,3]:=RDbyte;
      COL[a,2]:=RDbyte;
      COL[a,1]:=RDbyte;
     end;
    end;

  InitImage(COL,TotalX,TotalY,numColors);

      CodeSize := RDbyte;
     ClearCode := 1 shl CodeSize;
       BitMask := ClearCode - 1;
       EOFCode := ClearCode + 1;
     FirstFree := ClearCode + 2;
      FreeCode := FirstFree;
      CodeSize := CodeSize + 1; CodeMask :=(1 shl codesize) - 1;
  InitCodeSize := CodeSize;
       MaxCode := 4 shl (CodeSize - 2);

  BB:=RDbyte;
  BlockLength := BB + 1;

       Num := 0;
  OutCount := 0;
         X := XStart;
         Y := YStart;

  bufflen:=TotalX;
  GetMem(LineBUFF,buffLen);

 try
  Repeat
    GETCODE;
    If Code <> EOFCode Then
    Begin
     If Code = ClearCode Then
      Begin

       CodeSize:=InitCodeSize; CodeMask:=(1 shl codesize) - 1;
       MaxCode:=4 shl (CodeSize - 2);

       FreeCode:= FirstFree;
       GETCODE;
       OldCode:=Code;
       FinChar:=Code and BitMask;{}
       LineBUFF^[x]:=FinChar;
       inc(x); If x > XEnd then
         begin
          PutLineSomewhere;
          x := xStart;
          Inc(LinesCount);
          if linescount>YEnd then goto ende;
         end;
      End

      Else
      Begin
       CurCode := Code;
       InCode := Code;
       If Code >= FreeCode Then
        Begin
         CurCode := OldCode;
         OutCode[OutCount] := FinChar;
         inc(OutCount);
         if OutCOUNT>maxOut then goto ende;
        End;

       while CurCode > BitMask do
       begin
        OutCode[OutCount] := Suffix[CurCode];
        inc(OutCount);
        If OutCOUNT>maxOut then goto ende;
        CurCode := PreFix[CurCode];
       end;

       FinChar := CurCode And BitMask;
       OutCode[OutCount] := FinChar;

       For A := OutCount downTo 0 do
       Begin
       LineBUFF^[x]:=OutCode[A];
       inc(x); If x > XEnd then
         begin
          PutLineSomewhere;
          x:=xStart;
          Inc(LinesCount);
          if linesCount>YEnd then goto ende;
         end;
       End;

       OutCount := 0;
       PreFix[FreeCode] := OldCode;
       Suffix[FreeCode] := FinChar;
       OldCode := InCode;
       inc(FreeCode);
       If (CodeSize < maxCodeSize) and (FreeCode >= MaxCode) then
       Begin
        inc(CodeSize); codeMask:=(1 shl codesize) - 1;
        MaxCode := MaxCode*2;
       End;
      End;
    End;

  Until (Code = EOFCode) or end_of_file;
ende:

 finally
  FreeMem(LineBUFF,buffLen);
 end;//try


 exit;
End;//case IdImage

 end;//case
 until (byteBuffer = idTrailer) or end_of_file;

 result:=0;
End; {DecGIF}

{ TBmpGifDecoder }

Procedure TBmpGifDecoder.LoadAsBitmap(STR:Tstream;Bitmap:Tbitmap);
Begin
  BMP:=Bitmap;
  DecodeGIF(STR);
End;

Procedure TBmpGifDecoder.PutALine(Line:pointer; length:word2; yPosition:integer2);
var
 P:^byte;
 B:^byte;
 x:integer2;
 n,i:integer2;
 c:byte;
 label skip;
Begin//TbmpGifDecoder.PUT
 if not Assigned(BMP) then exit;

 B:=Line;
 if (yposition < BMP.Height) then
 begin
  P := BMP.ScanLine[yPosition];
  case  bmp.PixelFormat of
   pf1bit:
    begin
      c:=$80;
      i:=0;
      for x:=0 to length-1 do
      begin
       if B^<>0 then i:=i or c;
       inc(B);
       asm
         ROR c,1   { bit 7->6 ; bit 0->7 ; bit 0->C }
         JNC skip
       end;
      (* c:=c shr 1; if c<>0 then goto skip;
         c:=$80;
       *)
       P^:=i;
       i:=0;
       inc(P);
skip:
      end;
      if c<>$80 then P^:=i;
    end;

   pf4bit:
    begin
     n:=0;
     for x:= 1 to length do
      begin
        if odd(x)
         then
          begin
           n:=B^ shl 4;
          end
         else
          begin
           P^:=n or B^;
           Inc(P);
          end;
        inc(B);
      end;//for x
      if odd(length) then P^:=n;
    end;

   pf8bit: move(B^,P^,length);

   pf24bit:
    begin
    for x := 1 to length do
     begin
     n:=B^; inc(B);
     P^:=COL[n,1]; inc(P);
     P^:=COL[n,2]; inc(P);
     P^:=COL[n,3]; inc(P);
     end;{}
    end;
  end;//case
 end;//if

// BMP.OnProgress(Self,psRunning,50,true,rect(0,0,Totalx,ypos),'');
End;//TBmpGifDecoder.PUT

Procedure SetHPAL(COL:RGB_Palette; BMP:TBitmap);
var
  pal: PLogPalette;
  hpal: HPALETTE;
  i,size: Integer;
Begin
{$R-}
  size:= sizeof(TLogPalette) + sizeof(TPaletteEntry) * 255;
  GetMem(pal, size);
  try
    pal.palVersion    := $300;
    pal.palNumEntries := 256;
    for i := 0 to 255 do
    begin
      pal.palPalEntry[i].peRed   :=COL[i,3];
      pal.palPalEntry[i].peGreen :=COL[i,2];
      pal.palPalEntry[i].peBlue  :=COL[i,1];
      pal.palPalEntry[i].peFlags :=0;
    end;
    hpal := CreatePalette(pal^);
    if hpal <> 0  then Bmp.Palette := hpal;

  finally
    FreeMem(pal,size);
  end;
{$R+}
End;{SetHPAL}

Procedure TBmpGifDecoder.InitImage(
 PAL:RGB_palette;
 xsize,ysize:integer;
 numCOL:integer);

Begin

  if not assigned(bmp) then exit;
  case numCOL of
           2: BMP.PixelFormat:=pf1bit;
      4,8,16: BMP.PixelFormat:=pf4bit;
         else BMP.PixelFormat:=pf8bit;
  end;//case numcolors

  BMP.Width :=xsize;
  BMP.Height:=ysize;
  SetHPal(PAL,bmp);
//  BMP.OnProgress(self,psStarting,1,true,rect(0,0,0,0),'');
End;

{ last mod: 2004-07-03}
END.
