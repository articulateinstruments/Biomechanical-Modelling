unit graph42;
         {Graph42 is a bitmap encapsulation of graph41 }
interface
uses Windows,Graphics,Dialogs,graph41;

 {Procedure BMP24_8 converts RGB 24-bit pixel format to
 indexed colours 8-bit pixel format }
Procedure BMP24_8(BMP:TBitmap;
 desired_colors:integer; // 2..256
 method:Dither_Method;   // No_dither, FS_dither
 var actual_number_of_colors:integer);overload;


Procedure BMP24_8(BMP:TBitmap);overload;
 //256 colours, Floyd-Steinberg dither


Implementation

Procedure SetHPAL(COL:pointer; BMP:TBitmap);
type RGB_array=array[0..255,1..3] of byte;
var
  pal: PLogPalette;
  hpal: HPALETTE;
  i: Integer;
  CO:^rgb_array;
begin
 //bmp.ReleasePalette;
     CO:=COL;
  pal := nil;
  try
    GetMem(pal, sizeof(TLogPalette) + sizeof(TPaletteEntry) * 255);
    pal.palVersion    := $300;
    pal.palNumEntries := 256;
    for i := 0 to 255 do
    begin
      {$R-}
      pal.palPalEntry[i].peRed   := co[i,3];
      pal.palPalEntry[i].peGreen := co[i,2];
      pal.palPalEntry[i].peBlue  := co[i,1];
      pal.palPalEntry[i].peFlags  := 0;
      {$R+}
    end;
    hpal := CreatePalette(pal^);
    if hpal <> 0
    then  Bmp.Palette := hpal
    else ShowMessage('SetHPAL:Can not assign hpalette!');
  finally
    FreeMem(pal);
  end;
End;{SetHPAL}



Procedure BMP24_8(BMP:tbitmap);overload;
 var actual_number_of_colors:integer;
Begin
 BMP24_8(BMP,256,FS_dither,actual_number_of_colors);
End;

Procedure BMP24_8(
            BMP:tbitmap;
 desired_colors:integer;
         method:Dither_Method;
 var actual_number_of_colors:integer);



var
 IMG:IMG_rec;
 i:integer;

 psize:integer;

 COL:array[0..255,1..3]of byte;
Begin
{$R-}
 if not Assigned(BMP) then exit;
 if (bmp.Width<1) or (bmp.height<1) then exit;

 case bmp.PixelFormat of
  pf1bit,pf4bit,pf8bit: exit;
  else bmp.PixelFormat:=pf24bit;
 end;

 IMG.width:=bmp.Width;
 IMG.height:=bmp.Height;
 IMG.desired_colors:=desired_colors;
 IMG.method:=method;
 IMG.col:=@COL;

 psize:=IMG.height*sizeOf(Pointer); // size of pointer array

 GetMem(IMG.Source_lines,psize); // create array of pointers
 for i:=1 to bmp.Height do       // to bmp.scanLines
  IMG.Source_lines^[i-1]:=bmp.ScanLine[i-1];

 GetMem(IMG.dest_lines,psize);  // create array of pointers
 for i:=1 to bmp.Height do      // to destination lines
  GetMem(IMG.dest_lines^[i-1],bmp.Width); // get memory for new lines

 try
  IMG24_8(IMG); //dither image

 bmp.PixelFormat:=pf8bit; // convert bitmap to 8bit format
 SetHPAL(IMG.COL,bmp); //set color palette
 for i:=1 to bmp.Height do   //copy dithered lines
  move(IMG.dest_lines^[i-1]^,bmp.scanLine[i-1]^,IMG.width);

  actual_number_of_colors:=IMG.actual_number_of_colors;
 finally
  for i:=1 to bmp.Height do
  FreeMem(IMG.dest_lines^[i-1],bmp.Width); // free new lines
  FreeMem(IMG.dest_lines,psize);   //free array of pointers
  FreeMem(IMG.Source_lines,psize); //free array of pointers
 end;
{$R+}
End;




END.
