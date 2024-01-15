unit JpegCalc;

interface

uses
  Windows,ExtCtrls,graphics,jpeg;

type
  TLogicOp = (loAnd,loOr,loXor,loGT,loLT,loMax,loMin);
  T21 = -10..10;
  TConvolution21x21 = array[T21,T21] of integer;
  TConvolution3x3 = array[-1..1,-1..1] of integer;

  TShrink = (shBitBlt,shBlurBitBlt,shMean,shLinear,shBicubic,shNoShrink,shGaussian);
  TColorModel = (cgRGB,cgYUV,cgHSL,cgMaxRGB,cg3R6G1B,cgR,cgG,cgB,cgY,cgU,cgV,cgH,cgS,cgL);
  TPix = record
    Width,Height: integer; {size of image}
    ColorModel: TColorModel;
    Pixels: string;
      { Color true:  Pixels contains the Pixels as three bytes per Pixel}
      { Color false: Pixels contains the monochrome Pixels as one byte per Pixel}
  end;

  T3Color = packed record
    c3Red: Byte;
    c3Green: Byte;
    c3Blue: Byte;
  end;
  P3Color = ^T3Color;

  THistogram = array[0..255] of integer;
  TeqHist = array[0..255] of byte;
  TScanLines = record y0: integer; E: array of array of integer; end;

function BitmapToPix(Source: TBitmap; aColorModel: TColorModel): TPix;
function PixConvertToColorModel(Pix: TPix; NewColorModel: TColorModel): TPix;
procedure PixSplitChannels(Pix: TPix; var pixR,pixG,pixB: TPix);
function PixCombineChannels(pixR,pixG,pixB: TPix): TPix;
function PixToBitmap(Pix: TPix): TBitmap;
function SubPixToBitmap(Pix: TPix; Rect: TRect): TBitmap;
procedure PixToBitmap2(Pix: TPix; Bitmap: TBitmap);
procedure PixToBitmap3(Pix: TPix; BitmapDevice,Bitmap24: TBitmap);
procedure PixToBitmap4(Pix: TPix; Bitmap24: TBitmap);
procedure PixToBitmap6(Pix: TPix; Bitmap: TBitmap; xMin,yMin,xMax,yMax: integer);
function PixToBitmap5(Pix: TPix; xMin,yMin,xMax,yMax: integer): TBitmap;
function PixScanLine(var Source: TPix; y: integer): pointer;
function NegativePix(pix: TPix): TPix;
function GetPixelDepth(aColorModel: TColorModel): integer;
procedure PixToBitmap2Zoom(Pix: TPix; Bitmap: TBitmap; zoom: single);
procedure PixBrightness(var Pix: TPix; Bright: integer);
procedure PixBrightnessContrast(var Pix: TPix; Bright,Cont: integer);
function PixBrightnessContrast2(Pix: TPix; Bright,Cont: integer): TPix;
procedure PixBrightnessRGB(var Pix: TPix; RBright,GBright,BBright: integer);
procedure PixBrightnessContrastRGB(var Pix: TPix; RBright,GBright,BBright,RCont,GCont,BCont: integer);
function PixLoadFromFile(filename: string): TPix;
function JPGLoadFromFile(filename: string): TBitmap;
procedure JPGLoadImageFromFile(image: TImage; filename: string);
procedure JpgSaveToFile(aBitmap: TBitmap; filename: string);
procedure PixSaveToFile(Pix: TPix; filename: string);
procedure PixMinMaxPixel(Pix: TPix; var min,max: TColor);
function PixMaxPixel(Pix: TPix): TColor;
function PixMinPixel(Pix: TPix): TColor;
function PixMaxPixelCoord(Pix: TPix): TPoint;
function PixMinPixelCoord(Pix: TPix): TPoint;
function PixelChannel(var Source: TPix; x,y: integer): TColor;  {result can contain YUV}
function Pixel(var Source: TPix; x,y: integer): TColor;  {result is always RGB}
function Pixel3(var Source: TPix; x,y: integer): T3Color;  {result is always RGB}
function PixelMono(var Source: TPix; x,y: integer): byte;  {must be a monochrome image}
function PixelRed(var Pix: TPix; x,y: integer): byte; {Color is always RGB}
function PixelGreen(var Pix: TPix; x,y: integer): byte; {Color is always RGB}
function PixelBlue(var Pix: TPix; x,y: integer): byte; {Color is always RGB}
function PixelByte(var Source: TPix; x,y: integer): byte;
procedure PixSetPixelChannel(var Pix: TPix; x,y: integer; Color: TColor); {Color can contain YUV}
procedure PixSetPixel(var Pix: TPix; x,y: integer; Color: TColor); {Color is always RGB}
procedure PixSetByte(var Pix: TPix; x,y: integer; b: byte);
procedure PixSetPixelMono(var Pix: TPix; x,y: integer; b: byte); {must be a monochrome image}
procedure PixSetPixelRed(var Pix: TPix; x,y: integer; b: byte); {Color is always RGB}
procedure PixSetPixelGreen(var Pix: TPix; x,y: integer; b: byte); {Color is always RGB}
procedure PixSetPixelBlue(var Pix: TPix; x,y: integer; b: byte); {Color is always RGB}
function pPixel(var Source: TPix; x,y: integer): P3Color;
function pPixelByte(var Source: TPix; x,y: integer): pByte;
procedure PixFillRect(var Pix: TPix; Rect: TRect; col: TColor);
function YUVtoRGB(col: TColor): TColor;
function RGBtoYUV(col: TColor): TColor;
function RGBtoHSL(col: TColor): TColor;
function HSLtoRGB(col: TColor): TColor;
procedure RGBtoHSL2(r, g, b: integer; var hq, sq, lq: byte);
procedure HSLtoRGB2(h, s, l: integer; var rq,gq,bq: byte);
function HSLtoRGBEx(H, S, L: Integer): TColor; {works better}
function HSLtoRGBOld(col: TColor): TColor;
function HSLtoRGBExOld(H, S, L: Integer): TColor; {for backward compatibility - if any}
procedure RGBtoHSLEx(RGB: TColor; out H, S, L: Byte);
function HLStoRGBEx(H, L, S: integer): TColor;
procedure ColToRGB(RGB: TColor; out R, G, B: Byte);
function Red(c: TColor): Byte;
function Green(c: TColor): Byte;
function Blue(c: TColor): Byte;
function Y(c: TColor): Byte;
function U(c: TColor): Byte;
function V(c: TColor): Byte;
function H(c: TColor): Byte;
function S(c: TColor): Byte;
function L(c: TColor): Byte;
function ColToT3Col(RGB: TColor): T3Color;
function T3ColToCol(c: T3Color): TColor;
procedure PixSeedFillToBoundary(var Pix: TPix; X,Y: Integer; FillColor,BoundaryColor: TColor; aColorModel: TColorModel);
function PixSetSize(Width,Height: integer; ColorModel: TColorModel): TPix;
procedure PixFillPixChannel(var Pix: TPix; Color: TColor); {Color can contain YUV}
procedure PixFillPix(var Pix: TPix; Color: TColor); {Color is always RGB}
function PixStretchToFit(Source: TPix; Shrink: TShrink; nBlur,Width,Height: integer): TPix;
function PixMakeSameSize(Source: TPix): TPix;
procedure PixDraw(Canvas: TCanvas; x,y: integer; Pix: TPix);
procedure PixDrawPix(Source: TPix; var Dest: TPix; x,y: integer);
procedure PixStretchDraw(Canvas: TCanvas; Pix: TPix; SourceRect,DestRect: TRect);
function PixDiff(Source1,Source2: TPix): TPix;
function PixAdd(Source1,Source2: TPix): TPix;
function PixAddRandom(Source: TPix; a: integer): TPix;
function PixMaths(Source1,Source2: TPix; Source1Mult,Source2Mult,AddConst,DivConst: integer): TPix;
function PixMult(Source1,Source2: TPix; MultConst,AddConst,DivConst: integer): TPix;
function PixLogic(Source1,Source2: TPix; op: TLogicOp): TPix;
function PixAddOfs(Source1,Source2: TPix; ofs: integer): TPix;
function PixSubOfs(Source1,Source2: TPix; ofs: integer): TPix;
function PixAbs128(Pix: TPix): TPix;
function PixBlur3x3(Pix: TPix): TPix;
function PixBlur21x21(Pix: TPix; n: T21): TPix;
procedure PixPolygonFill(var Pix: TPix; Pts: array of TPoint; col: TColor);
function PolyToScanLines(p: array of TPoint): TScanLines;
function CopyScanlines(var source: TScanLines; BottomMargin,TopMargin: integer): TScanLines;
function UnionScanlines(var scan1,scan2: TScanLines): TScanLines;
procedure DrawScanLines(Canvas: TCanvas; ScanLines: TScanLines; col: TColor);
procedure DrawLinePixChannel(var Pix: TPix; x1,y1,x2,y2: integer; col: TColor); {Color is always RGB}
procedure DrawLinePixChannelDotted(var Pix: TPix; x1,y1,x2,y2: integer; col: TColor; var Dots: integer); {Color is always RGB}
procedure DrawLinePix(var Pix: TPix; x1,y1,x2,y2: integer; col: TColor); {Color can contain YUV}
procedure LightenLinePix(var Pix: TPix; x1,y1,x2,y2: integer; dL: integer); {Color cannot contain YUV}
procedure MirrorPix(var Pix: TPix);
procedure FlipPix(var Pix: TPix);
procedure RotatePixCW(var Pix: TPix);
procedure RotatePixCCW(var Pix: TPix);
procedure RotateBitmapCW(Bitmap: TBitmap);
procedure RotateBitmapCCW(Bitmap: TBitmap);
function PixGetRect(Pix: TPix; Rect: TRect): TPix;
function PixInterpolate(Source1,Source2: TPix; a: double): TPix;
function MeasureBitmapDiff(Source1,Source2: TBitmap): double;
function MeasurePixDiff(Source1,Source2: TPix): double;
function PixIsMonochrome(Source: TPix): boolean;
function PixConvolve21x21(Pix: TPix; aConv: TConvolution21x21): TPix;
function PixConvolve21x21Ex1(Pix: TPix; aConv: TConvolution21x21; add,div_: integer): TPix;
function PixConvolve21x21Ex2(Pix: TPix; aConv: TConvolution21x21; mult,add: integer): TPix;
function CalculateHistogram(Pix: TPix): THistogram;
function CalculateHistogramChannel(Pix: TPix; ColorModel: TColorModel): THistogram;
procedure EqualiseHistogram(var Pix: TPix);
procedure ApplyHistogram(var Pix: TPix; eqHist: TeqHist);
procedure InitHistogram(var eqHist: TeqHist);

const
  PixProgressUpdate: TProgressEvent = nil;
  EmptyPix: TPix = (Width: 0; Height: 0; ColorModel: cgRGB; Pixels: '');

type TMyJPEGImage = class(TJPEGImage)
  public
    property Bitmap;
  end;

implementation

uses
  misc,
  math,
  classes,
  SysUtils;

type TColorMatrix = array[0..2,0..3] of single;
const
  m00=+0.299; m01=+0.587; m02=+0.114; m03=+0;
  m10=-0.169; m11=-0.331; m12=+0.500; m13=+128;
  m20=+0.500; m21=-0.419; m22=-0.081; m23=+128;

  n00=(+m21/m22/m02-m11/m12/m02)/(+m21/m22*m00/m02-m11/m12*m00/m02-m21/m22*m20/m22+m11/m12*m20/m22+m21/m22*m20/m22-m01/m02*m20/m22-m21/m22*m10/m12+m01/m02*m10/m12);
  n01=(+m01/m02/m12-m21/m22/m12)/(+m01/m02*m10/m12-m21/m22*m10/m12-m01/m02*m00/m02+m21/m22*m00/m02+m01/m02*m00/m02-m11/m12*m00/m02-m01/m02*m20/m22+m11/m12*m20/m22);
  n02=(-m01/m02/m22+m11/m12/m22)/(+m01/m02*m10/m12-m21/m22*m10/m12-m01/m02*m00/m02+m21/m22*m00/m02+m01/m02*m00/m02-m11/m12*m00/m02-m01/m02*m20/m22+m11/m12*m20/m22);
  n10=(+m22/m20/m00-m12/m10/m00)/(+m22/m20*m01/m00-m12/m10*m01/m00-m22/m20*m21/m20+m12/m10*m21/m20+m22/m20*m21/m20-m02/m00*m21/m20-m22/m20*m11/m10+m02/m00*m11/m10);
  n11=(+m02/m00/m10-m22/m20/m10)/(+m02/m00*m11/m10-m22/m20*m11/m10-m02/m00*m01/m00+m22/m20*m01/m00+m02/m00*m01/m00-m12/m10*m01/m00-m02/m00*m21/m20+m12/m10*m21/m20);
  n12=(-m02/m00/m20+m12/m10/m20)/(+m02/m00*m11/m10-m22/m20*m11/m10-m02/m00*m01/m00+m22/m20*m01/m00+m02/m00*m01/m00-m12/m10*m01/m00-m02/m00*m21/m20+m12/m10*m21/m20);
  n20=(+m20/m21/m01-m10/m11/m01)/(+m20/m21*m02/m01-m10/m11*m02/m01-m20/m21*m22/m21+m10/m11*m22/m21+m20/m21*m22/m21-m00/m01*m22/m21-m20/m21*m12/m11+m00/m01*m12/m11);
  n21=(+m00/m01/m11-m20/m21/m11)/(+m00/m01*m12/m11-m20/m21*m12/m11-m00/m01*m02/m01+m20/m21*m02/m01+m00/m01*m02/m01-m10/m11*m02/m01-m00/m01*m22/m21+m10/m11*m22/m21);
  n22=(-m00/m01/m21+m10/m11/m21)/(+m00/m01*m12/m11-m20/m21*m12/m11-m00/m01*m02/m01+m20/m21*m02/m01+m00/m01*m02/m01-m10/m11*m02/m01-m00/m01*m22/m21+m10/m11*m22/m21);
  n03=-n00*m03-n01*m13-n02*m23;
  n13=-n10*m03-n11*m13-n12*m23;
  n23=-n20*m03-n21*m13-n22*m23;

  RGBtoYUVMatrix: TColorMatrix =
    ((m00,m01,m02,m03),(m10,m11,m12,m13),(m20,m21,m22,m23));
//   ((+0.299, +0.587, +0.114,  +0),
//    (-0.169, -0.331, +0.500,  +128),
//    (+0.500, -0.419, -0.081,  +128));
  YUVtoRGBMatrix: TColorMatrix =
    ((n00,n01,n02,n03),(n10,n11,n12,n13),(n20,n21,n22,n23));
//   ((+1.000, +0.000, +1.402,  -179),
//    (+1.000, -0.344, -0.714,  -135),
//    (+1.000, +1.772, +0.000,  -267));

procedure StartProgressUpdate;
const R: TRect = (Left:0; Top:0; Right:0; Bottom:0);
begin
  if assigned(PixProgressUpdate) then
    PixProgressUpdate(nil,psStarting,0,true,R,'');
end;

procedure ShowProgressUpdate(i,max: integer);
const R: TRect = (Left:0; Top:0; Right:0; Bottom:0);
const t: integer = 0;
begin
  if assigned(PixProgressUpdate) and (GetTickCount > t+1000) then
  begin
    PixProgressUpdate(nil,psRunning,i*100 div max,true,R,'');
    t:=GetTickCount;
  end;
end;

procedure StopProgressUpdate;
const R: TRect = (Left:0; Top:0; Right:0; Bottom:0);
begin
  if assigned(PixProgressUpdate) then
    PixProgressUpdate(nil,psEnding,100,true,R,'');
end;

function PixSetSize(Width,Height: integer; ColorModel: TColorModel): TPix;
begin
  result.Width:=Width;
  result.Height:=Height;
  result.ColorModel:=ColorModel;
  result.Pixels:='';
  SetLength(result.Pixels,Width*Height*GetPixelDepth(ColorModel));
end;

function PixScanLine(var Source: TPix; y: integer): pointer;
begin
  result:=@Source.Pixels[y*Source.Width*GetPixelDepth(Source.ColorModel)+1];
end;

function BitmapToPix(Source: TBitmap; aColorModel: TColorModel): TPix;
var x,y: integer;
    ps,pd1: pChar;
begin
  case aColorModel of
    cgY: begin result:=BitmapToPix(Source,cgRGB); result:=PixConvertToColorModel(result,cgR); end;
    cgU: begin result:=BitmapToPix(Source,cgRGB); result:=PixConvertToColorModel(result,cgG); end;
    cgV: begin result:=BitmapToPix(Source,cgRGB); result:=PixConvertToColorModel(result,cgB); end;
    cgH: begin result:=BitmapToPix(Source,cgRGB); result:=PixConvertToColorModel(result,cgR); end;
    cgS: begin result:=BitmapToPix(Source,cgRGB); result:=PixConvertToColorModel(result,cgG); end;
    cgL: begin result:=BitmapToPix(Source,cgRGB); result:=PixConvertToColorModel(result,cgB); end;
    else
      with result do
      begin
        Source.PixelFormat:=pf24bit;
        Width:=Source.Width;
        Height:=Source.Height;
        ColorModel:=aColorModel;

        StartProgressUpdate;

        case aColorModel of
          cgRGB,cgYUV,cgHSL:
                  begin
                    SetLength(Pixels,Width*Height*3);
                    for y:=0 to Height-1 do
                    begin
                      ShowProgressUpdate(y,Height-1);
                      move(Source.ScanLine[y]^,Pixels[y*Width*3+1],Width*3);
                    end;
                    ColorModel:=cgRGB;
                    result:=PixConvertToColorModel(result,aColorModel);
                  end;
          else    begin
                    SetLength(Pixels,Width*Height);
                    for y:=0 to Height-1 do
                    begin
                      ShowProgressUpdate(y,Height-1);
                      ps:=Source.ScanLine[y];
                      pd1:=PixScanLine(result,y);
                      for x:=0 to Width-1 do
                      begin
                        case aColorModel of
                          cgMaxRGB: begin
                                      pd1^:=ps[0];
                                      if ps[1] > pd1^ then pd1^:=ps[1];
                                      if ps[2] > pd1^ then pd1^:=ps[2];
                                    end;
                          cg3R6G1B: pd1^:=char((longint(ord(ps[0]))*1+longint(ord(ps[1]))*6+longint(ord(ps[2]))*3) div 10);
                          cgR:      pd1^:=ps[2];
                          cgG:      pd1^:=ps[1];
                          cgB:      pd1^:=ps[0];
                        end;
                        inc(pd1);
                        inc(ps,3);
                      end;
                    end;
                  end;
        end;
        StopProgressUpdate;

        Source.PixelFormat:=pfDevice;
      end;
  end;
end;

function PixToBitmap(Pix: TPix): TBitmap;
begin
  result:=TBitmap.Create;
  PixToBitmap2(Pix,result);
end;

function SubPixToBitmap(Pix: TPix; Rect: TRect): TBitmap;
var x,y: integer;
    pd,ps1: pChar;
    c: char;
begin
  case Pix.ColorModel of
    cgYUV,cgHSL: result:=PixToBitmap(PixConvertToColorModel(PixGetRect(Pix,Rect),cgRGB));
    else
      begin
        Rect.Left:=Intmax([Rect.Left,0]);
        Rect.Right:=Intmin([Rect.Right,Pix.Width]);
        Rect.Top:=Intmax([Rect.Top,0]);
        Rect.Bottom:=Intmin([Rect.Bottom,Pix.Height]);

        if (Rect.Right <= Rect.Left) or (Rect.Bottom <= Rect.Top) then
        begin
          result:=nil;
          exit;
        end;

        result:=TBitmap.Create;
        result.Width:=Rect.Right-Rect.Left;
        result.Height:=Rect.Bottom-Rect.Top;
        result.PixelFormat:=pf24bit;
        StartProgressUpdate;
        case Pix.ColorModel of
          cgRGB:
            begin
              for y:=Rect.Top to Rect.Bottom-1 do
              begin
                ShowProgressUpdate(y-Rect.Top,Rect.Bottom-Rect.Top);
                move(pChar(PixScanLine(Pix,y))[Rect.Left*3],result.ScanLine[y-Rect.Top]^,result.Width*3);
              end;
            end;
          else
            begin
              for y:=Rect.Top to Rect.Bottom-1 do
              begin
                ShowProgressUpdate(y-Rect.Top,Rect.Bottom-Rect.Top);
                pd:=result.ScanLine[y-Rect.Top];
                ps1:=@pChar(PixScanLine(Pix,y))[Rect.Left];
                for x:=0 to result.Width-1 do
                begin
                  c:=ps1^;
                  pd^:=c; inc(pd);  {B}
                  pd^:=c; inc(pd);  {G}
                  pd^:=c; inc(pd);  {R}
                  inc(ps1);
                end;
              end;
            end;
        end;
        StopProgressUpdate;

        result.PixelFormat:=pfDevice;
      end;
  end;
end;

procedure PixToBitmap3(Pix: TPix; BitmapDevice,Bitmap24: TBitmap);
{ much faster than PixToBitmap2 cos it keeps a copy of the user's bitmap in pf24bit format}
{ the user bitmap must have created the bitmaps in the correct format }
{ note the asserts below }
var x,y: integer;
    pd,ps1: pChar;
    c: char;
const executing: boolean = false;
begin
  if not executing then
  with Pix do
  case Pix.ColorModel of
    cgYUV,cgHSL: PixToBitmap3(PixConvertToColorModel(Pix,cgRGB),BitmapDevice,Bitmap24);
    else
      try
        executing:=true;
        assert(BitmapDevice.Width = Width);
        assert(BitmapDevice.Height = Height);
        assert(BitmapDevice.PixelFormat = pfDevice);
        assert(Bitmap24.Width = Width);
        assert(Bitmap24.Height = Height);
        assert(Bitmap24.PixelFormat = pf24bit);

        StartProgressUpdate;
        case ColorModel of
          cgRGB:
            begin
              for y:=0 to Height-1 do
              begin
                ShowProgressUpdate(y,Height-1);
                move(PixScanLine(Pix,y)^,Bitmap24.ScanLine[y]^,Width*3);
              end;
            end;
          else
            begin
              for y:=0 to Height-1 do
              begin
                ShowProgressUpdate(y,Height-1);
                pd:=Bitmap24.ScanLine[y];
                ps1:=PixScanLine(Pix,y);
                for x:=0 to Width-1 do
                begin
                  c:=ps1^;
                  pd^:=c; inc(pd);  {B}
                  pd^:=c; inc(pd);  {G}
                  pd^:=c; inc(pd);  {R}
                  inc(ps1);
                end;
              end;
            end;
        end;
        StopProgressUpdate;

        BitmapDevice.Assign(Bitmap24);
        BitmapDevice.PixelFormat:=pfDevice;
      finally
        executing:=false;
      end;
  end;
end;

procedure PixToBitmap4(Pix: TPix; Bitmap24: TBitmap);
{ much faster than PixToBitmap2 cos it keeps a copy of the user's bitmap in pf24bit format}
{ the user bitmap must have created the bitmaps in the correct format }
{ note the asserts below }
var x,y: integer;
    pd,ps1: pChar;
    c: char;
const executing: boolean = false;
begin
  if not executing then
  with Pix do
  case Pix.ColorModel of
    cgYUV,cgHSL: PixToBitmap4(PixConvertToColorModel(Pix,cgRGB),Bitmap24);
    else
      try
        executing:=true;
        assert(Bitmap24.Width = Width);
        assert(Bitmap24.Height = Height);
        assert(Bitmap24.PixelFormat = pf24bit);

        StartProgressUpdate;
        case ColorModel of
          cgRGB:
            begin
              for y:=0 to Height-1 do
              begin
                ShowProgressUpdate(y,Height-1);
                move(PixScanLine(Pix,y)^,Bitmap24.ScanLine[y]^,Width*3);
              end;
            end;
          else
            begin
              for y:=0 to Height-1 do
              begin
                ShowProgressUpdate(y,Height-1);
                pd:=Bitmap24.ScanLine[y];
                ps1:=PixScanLine(Pix,y);
                for x:=0 to Width-1 do
                begin
                  c:=ps1^;
                  pd^:=c; inc(pd);  {B}
                  pd^:=c; inc(pd);  {G}
                  pd^:=c; inc(pd);  {R}
                  inc(ps1);
                end;
              end;
            end;
        end;
        StopProgressUpdate;
      finally
        executing:=false;
      end;
  end;
end;

procedure PixToBitmap2(Pix: TPix; Bitmap: TBitmap);
var x,y: integer;
    pd,ps1: pChar;
    c: char;
const executing: boolean = false;
begin
  if not executing then
  with Pix do
  case Pix.ColorModel of
    cgYUV,cgHSL: PixToBitmap2(PixConvertToColorModel(Pix,cgRGB),Bitmap);
    else
      try
        executing:=true;
        Bitmap.Width:=Width;
        Bitmap.Height:=Height;
        Bitmap.PixelFormat:=pf24bit;
        StartProgressUpdate;
        case ColorModel of
          cgRGB:
            begin
              for y:=0 to Height-1 do
              begin
                ShowProgressUpdate(y,Height-1);
                move(PixScanLine(Pix,y)^,Bitmap.ScanLine[y]^,Width*3);
              end;
            end;
          else
            begin
              for y:=0 to Height-1 do
              begin
                ShowProgressUpdate(y,Height-1);
                pd:=Bitmap.ScanLine[y];
                ps1:=PixScanLine(Pix,y);
                for x:=0 to Width-1 do
                begin
                  c:=ps1^;
                  pd^:=c; inc(pd);  {B}
                  pd^:=c; inc(pd);  {G}
                  pd^:=c; inc(pd);  {R}
                  inc(ps1);
                end;
              end;
            end;
        end;
        StopProgressUpdate;

        Bitmap.PixelFormat:=pfDevice;
      finally
        executing:=false;
      end;
  end;
end;

function PixToBitmap5(Pix: TPix; xMin,yMin,xMax,yMax: integer): TBitmap;
begin
  if (Pix.Width = 0) or (Pix.Height = 0) then
    result:=nil else
  begin
    result:=TBitmap.Create;
    PixToBitmap6(Pix,result,xMin,yMin,xMax,yMax);
  end;
end;

procedure PixToBitmap2Zoom(Pix: TPix; Bitmap: TBitmap; zoom: single);
{magnification is Zoom}
var x,y,i: integer;
    pd,ps: pChar;
    c: char;
const executing: boolean = false;
begin
  if zoom = 1 then
    PixToBitmap2(Pix,Bitmap) else
  if not executing then
  try
    case Pix.ColorModel of
      cgYUV,cgHSL: PixToBitmap2Zoom(PixConvertToColorModel(Pix,cgRGB),Bitmap,Zoom);
      else
        begin
          executing:=true;
          Bitmap.Width :=trunc(Pix.Width *zoom);
          Bitmap.Height:=trunc(Pix.Height*zoom);
          zoom:=1/zoom;
          Bitmap.PixelFormat:=pf24bit;
          StartProgressUpdate;
          case Pix.ColorModel of
            cgRGB:
              begin
                for y:=0 to Bitmap.Height-1 do
                begin
                  ShowProgressUpdate(y,Bitmap.Height-1);
                  pd:=Bitmap.ScanLine[y];
                  ps:=PixScanLine(Pix,trunc(y*zoom));
                  for x:=0 to Bitmap.Width-1 do
                    for i:=0 to 2 do
                    begin
                      pd^:=ps[trunc(x*zoom)*3+i];
                      inc(pd);
                    end;
                end;
              end;
            else
              begin
                for y:=0 to Bitmap.Height-1 do
                begin
                  ShowProgressUpdate(y,Bitmap.Height-1);
                  pd:=Bitmap.ScanLine[y];
                  ps:=PixScanLine(Pix,trunc(y*zoom));
                  for x:=0 to Bitmap.Width-1 do
                  begin
                    c:=ps[trunc(x*zoom)];
                    pd^:=c; inc(pd);  {B}
                    pd^:=c; inc(pd);  {G}
                    pd^:=c; inc(pd);  {R}
                  end;
                end;
              end;
          end;
          StopProgressUpdate;

          Bitmap.PixelFormat:=pfDevice;
        end;
    end;
  finally
    executing:=false;
  end;
end;

procedure PixToBitmap6(Pix: TPix; Bitmap: TBitmap; xMin,yMin,xMax,yMax: integer);
var zoom: single;
begin
  if (Pix.Width >= xMin) and (Pix.Height >= yMin) and (Pix.Width <= xMax) and (Pix.Height <= yMax) then
    PixToBitmap2(Pix,Bitmap) else
  begin
    Zoom:=1;
    if Pix.Height*Zoom < yMin then
      Zoom:=yMin/Pix.Height;
    if Pix.Width < xMin then
      Zoom:=xMin/Pix.Width;

    if Pix.Width > xMax then
      Zoom:=xMax/Pix.Width;
    if Pix.Height*Zoom > yMax then
      Zoom:=yMax/Pix.Height;

    PixToBitmap2Zoom(Pix,Bitmap,zoom);
  end;
end;

function GetPixelDepth(aColorModel: TColorModel): integer;
begin
  case aColorModel of
    cgRGB,cgYUV,cgHSL: result:=3;
    else result:=1;
  end;
end;

function PixBrightnessContrast2(Pix: TPix; Bright,Cont: integer): TPix;
begin
  PixBrightnessContrast(Pix,Bright,Cont);
  result:=Pix;
end;

procedure PixBrightnessContrast(var Pix: TPix; Bright,Cont: integer);
{cont adjusts the contrast so that 256 means no adjustment; 128 always maps to 128}
{then Bright adjust the Brightness}
var i: integer;
    p: ^Byte;
begin
  if length(Pix.Pixels) = 0 then
    exit;
  Bright:=Bright -128*Cont div 256+128;
  p:=@Pix.Pixels[1];
  StartProgressUpdate;
  for i:=1 to length(Pix.Pixels) do
  begin
    if i mod 1000 = 0 then
      ShowProgressUpdate(i,length(Pix.Pixels));
    p^:=ByteRange(p^*Cont div 256+Bright);
    inc(p);
  end;
  StopProgressUpdate;
end;

procedure PixBrightness(var Pix: TPix; Bright: integer);
var i: integer;
    p: ^Byte;
begin
  p:=@Pix.Pixels[1];
  StartProgressUpdate;
  for i:=1 to length(Pix.Pixels) do
  begin
    if i mod 1000 = 0 then
      ShowProgressUpdate(i,length(Pix.Pixels));
    p^:=ByteRange(p^+Bright);
    inc(p);
  end;
  StopProgressUpdate;
end;

procedure PixBrightnessContrastRGB(var Pix: TPix; RBright,GBright,BBright,RCont,GCont,BCont: integer);
var i: integer;
    p: pbyte;
begin
  rBright:=rBright -128*rCont div 256+128;
  gBright:=gBright -128*gCont div 256+128;
  bBright:=bBright -128*bCont div 256+128;
  p:=@Pix.Pixels[1];
  StartProgressUpdate;
  for i:=1 to length(Pix.Pixels) div 3 do
  begin
    if i mod 1000 = 0 then
      ShowProgressUpdate(i,length(Pix.Pixels));
    p^:=ByteRange(p^*bCont div 256+bBright); inc(p);
    p^:=ByteRange(p^*gCont div 256+gBright); inc(p);
    p^:=ByteRange(p^*rCont div 256+rBright); inc(p);
  end;
  StopProgressUpdate;
end;

procedure PixBrightnessRGB(var Pix: TPix; RBright,GBright,BBright: integer);
var i: integer;
    p: pbyte;
begin
  p:=@Pix.Pixels[1];
  StartProgressUpdate;
  for i:=1 to length(Pix.Pixels) div 3 do
  begin
    if i mod 1000 = 0 then
      ShowProgressUpdate(i,length(Pix.Pixels));
    p^:=ByteRange(p^+bBright); inc(p);
    p^:=ByteRange(p^+gBright); inc(p);
    p^:=ByteRange(p^+rBright); inc(p);
  end;
  StopProgressUpdate;
end;

procedure JPGLoadImageFromFile(image: TImage; filename: string);
var aImage: TImage;
begin
  aImage:=TImage.Create(nil);
  aImage.Picture.LoadFromFile(Filename);
  if aImage.Picture.Graphic is TJPEGImage then
    image.Picture.Assign(TMyJPEGImage(aImage.Picture.Graphic).Bitmap) else
    image.Picture.Assign(aImage.Picture.Bitmap);
  aImage.Free;
end;

function JPGLoadFromFile(filename: string): TBitmap;
var aImage: TImage;
begin
  result:=TBitmap.Create;
  aImage:=TImage.Create(nil);
  aImage.Picture.LoadFromFile(Filename);
  if aImage.Picture.Graphic is TJPEGImage then
    result.Assign(TMyJPEGImage(aImage.Picture.Graphic).Bitmap) else
    result.Assign(aImage.Picture.Bitmap);
  aImage.Free;
end;

procedure JpgSaveToFile(aBitmap: TBitmap; filename: string);
var fStream: TFileStream;
    JPEGImage: TMyJPEGImage;
begin
  try
    fStream:=TFileStream.Create(filename, fmCreate);
    if UpperCase(copy(ExtractFileExt(filename),2,2)) = 'JP' then
    begin
      JPEGImage:=TMyJPEGImage.Create;
      with JPEGImage do
      begin
        Assign(aBitmap);
        Compress;
        SaveToStream(fStream);
        Free;
      end;
    end else
      aBitmap.SaveToStream(fStream);
  finally
    fStream.Free;
  end;
end;

function PixLoadFromFile(filename: string): TPix;
var //aBitmap: TBitmap;
    aImage: TImage;
begin
  aImage:=TImage.Create(nil);
  aImage.Picture.LoadFromFile(Filename);
  if aImage.Picture.Graphic is TJPEGImage then
    result:=BitmapToPix(TMyJPEGImage(aImage.Picture.Graphic).Bitmap, cgRGB) else
    result:=BitmapToPix(aImage.Picture.Bitmap, cgRGB);
  if PixIsMonochrome(result) then
    result:=PixConvertToColorModel(result,cg3R6G1B);
  aImage.Free;
end;

procedure PixSaveToFile(Pix: TPix; filename: string);
var fStream: TFileStream;
    JPEGImage: TMyJPEGImage;
    aBitmap: TBitmap;
begin
  try
    aBitmap:=PixToBitmap(Pix);
    fStream:=TFileStream.Create(filename, fmCreate);
    if UpperCase(copy(ExtractFileExt(filename),2,2)) = 'JP' then
    begin
      JPEGImage:=TMyJPEGImage.Create;
      with JPEGImage do
      begin
        Assign(aBitmap);
//        Grayscale:=not Pix.Colored; //can't write grayscale properly
        Compress;
        SaveToStream(fStream);
        Free;
      end;
    end else
      aBitmap.SaveToStream(fStream);
  finally
    fStream.Free;
    aBitmap.Free;
  end;
end;

procedure PixMinMaxPixel(Pix: TPix; var min,max: TColor);
var i: integer;
    p: ^Byte;
    min3: TRGBTriple absolute min;
    max3: TRGBTriple absolute max;
begin
  p:=@Pix.Pixels[1];
  StartProgressUpdate;
  max3.rgbtRed:=0;    min3.rgbtRed:=255;
  max3.rgbtGreen:=0;  min3.rgbtGreen:=255;
  max3.rgbtBlue:=0;   min3.rgbtBlue:=255;

  case Pix.ColorModel of
    cgRGB,cgYUV,cgHSL:
      begin
        for i:=1 to length(Pix.Pixels) div 3 do
        begin
          if i mod 1000 = 0 then
            ShowProgressUpdate(i,length(Pix.Pixels));
          if p^ > max3.rgbtRed   then max3.rgbtRed:=p^;
          if p^ < min3.rgbtRed   then min3.rgbtRed:=p^;
          inc(p);
          if p^ > max3.rgbtGreen then max3.rgbtGreen:=p^;
          if p^ < min3.rgbtGreen then min3.rgbtGreen:=p^;
          inc(p);
          if p^ > max3.rgbtBlue  then max3.rgbtBlue:=p^;
          if p^ < min3.rgbtBlue  then min3.rgbtBlue:=p^;
          inc(p);
        end;
      end;
    else
      begin
        for i:=1 to length(Pix.Pixels) do
        begin
          if i mod 1000 = 0 then
            ShowProgressUpdate(i,length(Pix.Pixels));
          if p^ > max3.rgbtBlue then max3.rgbtBlue:=p^;
          if p^ < min3.rgbtBlue then min3.rgbtBlue:=p^;
          inc(p);
        end;
        max3.rgbtRed:=max3.rgbtBlue;
        max3.rgbtGreen:=max3.rgbtBlue;
        min3.rgbtRed:=min3.rgbtBlue;
        min3.rgbtGreen:=min3.rgbtBlue;
      end;
  end;
  StopProgressUpdate;
end;

function PixMaxPixel(Pix: TPix): TColor;
var c: TColor;
begin
  PixMinMaxPixel(Pix,c,result);
end;

function PixMinPixel(Pix: TPix): TColor;
var c: TColor;
begin
  PixMinMaxPixel(Pix,result,c);
end;

function PixMinMaxPixelCoord(Pix: TPix; Max: boolean): TPoint;
var i: integer;
    p: pByte;
    p3: P3Color absolute p;
    b,best: integer;
begin
  result:=Point(0,0);
  p:=@Pix.Pixels[1];
  StartProgressUpdate;
  if max then
    best:=0 else
    best:=255;
  case Pix.ColorModel of
    cgRGB,cgYUV,cgHSL: assert(false,'PixMinMaxPixelCoord: Pix must be monochrome');
    else
      begin
        for i:=1 to length(Pix.Pixels) do
        begin
          if i mod 1000 = 0 then
            ShowProgressUpdate(i,length(Pix.Pixels));
          if (p^ > best) = max then
          begin
            best:=p^;
            result.x:=i;
          end;
          inc(p);
        end;
      end;
  end;

  StopProgressUpdate;
  result:=Point((Result.x-1) mod Pix.Width,(Result.x-1) div Pix.Width);
end;

function PixMaxPixelCoord(Pix: TPix): TPoint;
begin
  result:=PixMinMaxPixelCoord(Pix,true);
end;

function PixMinPixelCoord(Pix: TPix): TPoint;
begin
  result:=PixMinMaxPixelCoord(Pix,false);
end;

function Pixel(var Source: TPix; x,y: integer): TColor;
begin
  result:=PixelChannel(Source,x,y);
  case Source.ColorModel of
    cgYUV: result:=YUVtoRGB(result);
    cgHSL: result:=HSLtoRGB(result);
  end;
end;

function PixelMono(var Source: TPix; x,y: integer): byte;  {must be a monochrome image}
begin
  if (x >= 0) and (x < Source.Width) and (y >= 0) and (y < Source.Height) then
    result:=ord(Source.Pixels[y*Source.Width+1+x]) else
    result:=0;
end;

function pPixel(var Source: TPix; x,y: integer): P3Color;
begin
  if (x >= 0) and (x < Source.Width) and (y >= 0) and (y < Source.Height) then
  begin
    case Source.ColorModel of
      cgRGB,cgYUV,cgHSL: result:=@pchar(PixScanLine(Source,y))[x*3];
      else         result:=@pchar(PixScanLine(Source,y))[x+0];
    end;
  end else
    result:=nil;
end;

function Pixel3(var Source: TPix; x,y: integer): T3Color;  {result is always RGB}
var i: integer;
begin
  i:=Pixel(Source,x,y);
  result:=P3Color(@i)^;
end;

function PixelRed(var Pix: TPix; x,y: integer): byte; {Color is always RGB}
begin
  if (x >= 0) and (x < Pix.Width) and (y >= 0) and (y < Pix.Height) then
  case Pix.ColorModel of
    cgRGB,cgYUV,cgHSL: result:=pByteArray(PixScanLine(Pix,y))[x*3+2];
    else result:=ord(pchar(PixScanLine(Pix,y))[x+0]);
  end;
end;

function PixelGreen(var Pix: TPix; x,y: integer): byte; {Color is always RGB}
begin
  if (x >= 0) and (x < Pix.Width) and (y >= 0) and (y < Pix.Height) then
  case Pix.ColorModel of
    cgRGB,cgYUV,cgHSL: result:=pByteArray(PixScanLine(Pix,y))[x*3+1];
    else result:=ord(pchar(PixScanLine(Pix,y))[x+0]);
  end;
end;

function PixelBlue(var Pix: TPix; x,y: integer): byte; {Color is always RGB}
begin
  if (x >= 0) and (x < Pix.Width) and (y >= 0) and (y < Pix.Height) then
  case Pix.ColorModel of
    cgRGB,cgYUV,cgHSL: result:=pByteArray(PixScanLine(Pix,y))[x*3];
    else result:=ord(pchar(PixScanLine(Pix,y))[x+0]);
  end;
end;

function PixelChannel(var Source: TPix; x,y: integer): TColor;
var r: T3Color absolute result;
begin
  result:=0;
  if (x >= 0) and (x < Source.Width) and (y >= 0) and (y < Source.Height) then
  begin
    case Source.ColorModel of
      cgRGB,cgYUV,cgHSL:
        begin
          r.c3Blue :=ord(pchar(PixScanLine(Source,y))[x*3+0]);
          r.c3Green:=ord(pchar(PixScanLine(Source,y))[x*3+1]);
          r.c3Red  :=ord(pchar(PixScanLine(Source,y))[x*3+2]);
        end;
      else
        begin
          r.c3Red  :=ord(pchar(PixScanLine(Source,y))[x+0]);
          r.c3Green:=r.c3Red;
          r.c3Blue :=r.c3Red;
        end;
    end;
  end else
  begin
    r.c3Red:=0;
    r.c3Green:=0;
    r.c3Blue:=0;
  end;
end;

function PixelByte(var Source: TPix; x,y: integer): byte;
begin
  if (x >= 0) and (x < Source.Width) and (y >= 0) and (y < Source.Height) then
  case Source.ColorModel of
    cgRGB,cgYUV,cgHSL: result:=ord(pchar(PixScanLine(Source,y))[x*3]);
    else         result:=ord(pchar(PixScanLine(Source,y))[x]);
  end else
    result:=0;
end;

function pPixelByte(var Source: TPix; x,y: integer): pByte;
begin
  if (x >= 0) and (x < Source.Width) and (y >= 0) and (y < Source.Height) then
  case Source.ColorModel of
    cgRGB,cgYUV,cgHSL: result:=@pchar(PixScanLine(Source,y))[x*3];
    else         result:=@pchar(PixScanLine(Source,y))[x];
  end else
    result:=0;
end;

procedure PixFillRect(var Pix: TPix; Rect: TRect; col: TColor);
var p: pChar;
    c: Char;
    r: T3Color absolute Col;
    x,y: integer;
begin
  case Pix.ColorModel of
    cgYUV: Col:=RGBtoYUV(Col);
    cgHSL: Col:=RGBtoHSL(Col);
  end;
  
  Rect.Left:=max(Rect.Left,0);
  Rect.Top:=max(Rect.Top,0);
  Rect.Bottom:=min(Rect.Bottom,Pix.Height);
  Rect.Right:=min(Rect.Right,Pix.Width);

  if (Rect.Left < Rect.Right) and (Rect.Top < Rect.Bottom) then
  case Pix.ColorModel of
    cgRGB,cgYUV,cgHSL:
      for y:=Rect.Top  to Rect.Bottom-1 do
      begin
        p:=pchar(PixScanLine(Pix,y))+Rect.Left*3;
        for x:=Rect.Left to Rect.Right-1 do
        begin
          p^:=char(r.c3Blue);  inc(p);
          p^:=char(r.c3Green); inc(p);
          p^:=char(r.c3Red);   inc(p);
        end;
      end;
    else
      begin
        case Pix.ColorModel of
          cgMaxRGB: begin
                      c:=char(r.c3Red);
                      if char(r.c3Green) > c then c:=char(r.c3Green);
                      if char(r.c3Blue) > c then c:=char(r.c3Blue);
                    end;
          cg3R6G1B: c:=char((ord(r.c3Red)*1+ord(r.c3Green)*6+ord(r.c3Blue)*3) div 10);
          cgR,cgY,cgH:  c:=char(r.c3Blue);
          cgG,cgU,cgS:  c:=char(r.c3Green);
          cgB,cgV,cgL:  c:=char(r.c3Red);
        end;

        for y:=Rect.Top  to Rect.Bottom-1 do
        begin
          p:=pchar(PixScanLine(Pix,y))+Rect.Left;
          for x:=Rect.Left to Rect.Right-1 do
          begin
            p^:=c;
            inc(p);
          end;
        end;
      end;
  end;
end;

procedure PixSetPixel(var Pix: TPix; x,y: integer; Color: TColor);
begin
  case Pix.ColorModel of
    cgYUV: Color:=RGBtoYUV(Color);
    cgHSL: Color:=RGBtoHSL(Color);
    else
  end;
    
  PixSetPixelChannel(Pix,x,y,Color);
end;

procedure PixSetPixelChannel(var Pix: TPix; x,y: integer; Color: TColor);
var p: pChar;
    c: Char;
    r: T3Color absolute Color;
begin
  if (x >= 0) and (x < Pix.Width) and (y >= 0) and (y < Pix.Height) then
  case Pix.ColorModel of
    cgRGB,cgYUV,cgHSL:
      begin
        p:=pchar(PixScanLine(Pix,y));
        p[x*3+0]:=char(r.c3Blue);
        p[x*3+1]:=char(r.c3Green);
        p[x*3+2]:=char(r.c3Red);
      end;
    else
      begin
        case Pix.ColorModel of
          cgMaxRGB: begin
                      c:=char(r.c3Red);
                      if char(r.c3Green) > c then c:=char(r.c3Green);
                      if char(r.c3Blue) > c then c:=char(r.c3Blue);
                    end;
          cg3R6G1B: c:=char((ord(r.c3Red)*1+ord(r.c3Green)*6+ord(r.c3Blue)*3) div 10);
          cgR,cgY,cgH:  c:=char(r.c3Blue);
          cgG,cgU,cgS:  c:=char(r.c3Green);
          cgB,cgV,cgL:  c:=char(r.c3Red);
        end;
        pchar(PixScanLine(Pix,y))[x]:=c;
      end;
  end;
end;

procedure PixSetPixelMono(var Pix: TPix; x,y: integer; b: byte); {must be a monochrome image}
begin
  if (x >= 0) and (x < Pix.Width) and (y >= 0) and (y < Pix.Height) then
    Pix.Pixels[y*Pix.Width+1+x]:=char(b);
end;

procedure PixSetPixelRed(var Pix: TPix; x,y: integer; b: byte); {Color is always RGB}
begin
  if (x >= 0) and (x < Pix.Width) and (y >= 0) and (y < Pix.Height) then
  case Pix.ColorModel of
    cgRGB,cgYUV,cgHSL: pByteArray(PixScanLine(Pix,y))[x*3+2]:=b;
  end;
end;

procedure PixSetPixelGreen(var Pix: TPix; x,y: integer; b: byte); {Color is always RGB}
begin
  if (x >= 0) and (x < Pix.Width) and (y >= 0) and (y < Pix.Height) then
  case Pix.ColorModel of
    cgRGB,cgYUV,cgHSL: pByteArray(PixScanLine(Pix,y))[x*3+1]:=b;
  end;
end;

procedure PixSetPixelBlue(var Pix: TPix; x,y: integer; b: byte); {Color is always RGB}
begin
  if (x >= 0) and (x < Pix.Width) and (y >= 0) and (y < Pix.Height) then
  case Pix.ColorModel of
    cgRGB,cgYUV,cgHSL: pByteArray(PixScanLine(Pix,y))[x*3]:=b;
  end;
end;

procedure PixSetByte(var Pix: TPix; x,y: integer; b: byte);
var p: pByteArray;
begin
  if (x >= 0) and (x < Pix.Width) and (y >= 0) and (y < Pix.Height) then
  case Pix.ColorModel of
    cgRGB,cgYUV,cgHSL: pByteArray(PixScanLine(Pix,y))[x*3]:=b;
    else         pByteArray(PixScanLine(Pix,y))[x  ]:=b;
  end;
end;

procedure PixFillPix(var Pix: TPix; Color: TColor);
begin
  if (Pix.ColorModel = cgYUV) or (Pix.ColorModel = cgY) or (Pix.ColorModel = cgU) or (Pix.ColorModel = cgV) then
    Color:=RGBtoYUV(Color) else
  if (Pix.ColorModel = cgHSL) or (Pix.ColorModel = cgH) or (Pix.ColorModel = cgS) or (Pix.ColorModel = cgL) then
    Color:=RGBtoHSL(Color);
  PixFillPixChannel(Pix,Color);
end;

procedure PixFillPixChannel(var Pix: TPix; Color: TColor);
var p: pChar;
    c: Char;
    r: T3Color absolute Color;
    i: integer;
begin
  if Pix.Pixels = '' then
    exit;
    
  if (Red(Color) = Green(Color)) and (Red(Color) = Blue(Color)) then
    fillchar(Pix.Pixels[1],length(Pix.Pixels),Red(Color)) else
  case Pix.ColorModel of
    cgRGB,cgYUV,cgHSL:
      begin
        for i:=1 to length(Pix.Pixels) do
          case i mod 3 of
            1:   Pix.Pixels[i]:=char(r.c3Blue);
            2:   Pix.Pixels[i]:=char(r.c3Green);
            else Pix.Pixels[i]:=char(r.c3Red);
          end;
      end;
    else
      begin
        case Pix.ColorModel of
          cgMaxRGB: begin
                      c:=char(r.c3Red);
                      if char(r.c3Green) > c then c:=char(r.c3Green);
                      if char(r.c3Blue) > c then c:=char(r.c3Blue);
                    end;
          cg3R6G1B: c:=char((ord(r.c3Red)*1+ord(r.c3Green)*6+ord(r.c3Blue)*3) div 10);
          cgR,cgY,cgH:  c:=char(r.c3Blue);
          cgG,cgU,cgS:  c:=char(r.c3Green);
          cgB,cgV,cgL:  c:=char(r.c3Red);
        end;
        fillchar(Pix.Pixels[1],length(Pix.Pixels),c);
      end;
  end;
end;

procedure PixSeedFillToBoundary(var Pix: TPix; X,Y: Integer; FillColor,BoundaryColor: TColor; aColorModel: TColorModel);
var sp: integer;
    stack: array[1..1000] of TPoint;
  procedure push(X,Y: integer);
  begin
    inc(sp);
    stack[sp].x:=X;
    stack[sp].y:=Y;
  end;
  procedure pop(var X,Y: integer);
  begin
    X:=stack[sp].x;
    Y:=stack[sp].y;
    dec(sp);
  end;
var bAbove,bBelow: boolean;
    c: TColor;
    r: T3Color absolute c;
    ax,ay: integer;
begin
  with Pix do
  begin
    sp:=0;
    push(x,y);

    while (sp > 0) do
    begin
      pop(x,y);

      c:=PixelChannel(Pix,x,y);
      if (c <> BoundaryColor) and (c <> FillColor) then
      begin
        c:=PixelChannel(Pix,x-1,y);
        while (x > 0) and (c <> BoundaryColor) and (c <> FillColor) do
        begin
          dec(x);
          c:=PixelChannel(Pix,x-1,y);
        end;

        bAbove:=false;
        bBelow:=false;
        repeat
          c:=PixelChannel(Pix,x,y);
          if (c <> BoundaryColor) and (c <> FillColor) then
          begin
            PixSetPixelChannel(Pix,x,y,FillColor);
            if y > 0 then
            begin
              c:=PixelChannel(Pix,x,y-1);
              if (c = BoundaryColor) or (c = FillColor) then
                bAbove:=false else
              if not bAbove then
              begin
                push(x,y-1);
                bAbove:=true;
              end;
            end;

            if y < Height-1 then
            begin
              c:=PixelChannel(Pix,x,y+1);
              if (c = BoundaryColor) or (c = FillColor) then
                bBelow:=false else
              if not bBelow then
              begin
                push(x,y+1);
                bBelow:=true;
              end;
            end;
          end;
          inc(x);

          c:=PixelChannel(Pix,x,y);
        until (x >= Width) or (c = BoundaryColor) or (c = FillColor);
      end;
    end;
  end;
end;

function PixConvolve21x21Ex1(Pix: TPix; aConv: TConvolution21x21; add,div_: integer): TPix;
var PixelDepth: integer;
  function Addr(x,y,k: integer): integer;
  begin
    result:=y*Pix.Width*PixelDepth+x*PixelDepth+k+1;
  end;
var j,k,x,y: integer;
    ix,iy: T21;
    ps,pd: pChar;
    size: integer;
begin
  result:=PixMakeSameSize(Pix);
  PixelDepth:=GetPixelDepth(Pix.ColorModel);

  size:=1;
  for y:=low(TConvolution21x21) to high(TConvolution21x21) do
    for x:=low(TConvolution21x21) to high(TConvolution21x21) do
      if aConv[x,y] <> 0 then
        size:=IntMax([size,abs(x),abs(y)]);

{$R-}
  pd:=@result.Pixels[1];
  for y:=0 to Pix.Height-1 do
  for x:=0 to Pix.Width-1 do
  for k:=0 to PixelDepth-1 do
  begin
    j:=0;
    for iy:=-size to size do
    begin
      ps:=@Pix.Pixels[Addr(x-size,y+iy,k)];
      for ix:=-size to size do
      begin
//        if (x+ix < 0) or (x+ix >= Pix.Width) or (y+iy < 0) or (y+iy >= Pix.Height) then
//          j:=j+ord(Pix.Pixels[Addr(IntRange(x+ix,0,Pix.Width-1),IntRange(y+iy,0,Pix.Height-1),k)])*aConv[ix,iy] else
//          j:=j+ord(ps^)*aConv[ix,iy];
        j:=j+ord(Pix.Pixels[Addr(IntRange(x+ix,0,Pix.Width-1),IntRange(y+iy,0,Pix.Height-1),k)])*aConv[ix,iy]; 
        inc(ps,PixelDepth);
      end;
    end;
    pd^:=char(ClipToByte(j+add div div_));
    inc(pd);
  end;
{$R+}
end;

function PixConvolve21x21Ex2(Pix: TPix; aConv: TConvolution21x21; mult,add: integer): TPix;
var PixelDepth: integer;
  function Addr(x,y,k: integer): integer;
  begin
    result:=y*Pix.Width*PixelDepth+x*PixelDepth+k+1;
  end;
var j,k,x,y: integer;
    ix,iy: T21;
    ps,pd: pChar;
    size: integer;
begin
  result:=PixMakeSameSize(Pix);
  PixelDepth:=GetPixelDepth(Pix.ColorModel);

  size:=1;
  for y:=low(TConvolution21x21) to high(TConvolution21x21) do
    for x:=low(TConvolution21x21) to high(TConvolution21x21) do
      if aConv[x,y] <> 0 then
        size:=IntMax([size,abs(x),abs(y)]);

{$R-}
  pd:=@result.Pixels[1];
  for y:=0 to Pix.Height-1 do
  for x:=0 to Pix.Width-1 do
  for k:=0 to PixelDepth-1 do
  begin
    j:=0;
    for iy:=-size to size do
    begin
      ps:=@Pix.Pixels[Addr(x-size,y+iy,k)];
      for ix:=-size to size do
      begin
        if (x+ix < 0) or (x+ix >= Pix.Width) or (y+iy < 0) or (y+iy >= Pix.Height) then
          j:=j+ord(Pix.Pixels[Addr(IntRange(x+ix,0,Pix.Width-1),IntRange(y+iy,0,Pix.Height-1),k)])*aConv[ix,iy] else
          j:=j+ord(ps^)*aConv[ix,iy];
        inc(ps,PixelDepth);
      end;
    end;
    pd^:=char(ClipToByte(j*mult+add));
    inc(pd);
  end;
{$R+}
end;

function PixConvolve21x21(Pix: TPix; aConv: TConvolution21x21): TPix;
var PixelDepth: integer;
  function Addr(x,y,k: integer): integer;
  begin
    result:=y*Pix.Width*PixelDepth+x*PixelDepth+k+1;
  end;
var n,j,k,x,y: integer;
    ix,iy: T21;
    ps,pd: pChar;
    size: integer;
begin
  result:=PixMakeSameSize(Pix);
  PixelDepth:=GetPixelDepth(Pix.ColorModel);

  size:=1;
  for y:=low(TConvolution21x21) to high(TConvolution21x21) do
    for x:=low(TConvolution21x21) to high(TConvolution21x21) do
      if aConv[x,y] <> 0 then
        size:=IntMax([size,abs(x),abs(y)]);

{$R-}
  pd:=@result.Pixels[1];
  for y:=0 to Pix.Height-1 do
  for x:=0 to Pix.Width-1 do
  for k:=0 to PixelDepth-1 do
  begin
    j:=0;
    n:=0;
    for iy:=-size to size do
    begin
      if y+iy >= 0 then
      if y+iy <= Pix.Height-1 then
      begin
        ps:=@Pix.Pixels[Addr(x-size,y+iy,k)];
        for ix:=-size to size do
        begin
          if x+ix >= 0 then
          if x+ix <= Pix.Width-1 then
          begin
            j:=j+ord(ps^)*aConv[ix,iy];
            n:=n+aConv[ix,iy];
          end;
          inc(ps,PixelDepth);
        end;
      end;
    end;
    if n > 0 then
      pd^:=char(ClipToByte(j div n)) else
      pd^:=#0;
//ps:=@Pix.Pixels[Addr(x,y,k)];
//pd^:=char(ClipToByte(ord(ps^)-ord(pd^)));
//pd^:=char(ClipToByte(ord(ps^)+ord(pd^)));
    inc(pd);
  end;
{$R+}
end;

function PixConvolve3x3(Pix: TPix; aConv: TConvolution3x3): TPix;
var PixelDepth: integer;
  function Addr(x,y,k: integer): integer;
  begin
    result:=y*Pix.Width*PixelDepth+x*PixelDepth+k+1;
  end;
var n,j,k,x,y: integer;
    ix,iy: -1..1;
    ps,pd: pChar;
begin
  result:=PixMakeSameSize(Pix);
  PixelDepth:=GetPixelDepth(Pix.ColorModel);

{$R-}
  pd:=@result.Pixels[1];
  for y:=0 to Pix.Height-1 do
  for x:=0 to Pix.Width-1 do
  for k:=0 to PixelDepth-1 do
  begin
    j:=0;
    n:=0;
    for iy:=-1 to 1 do
    begin
      if y+iy >= 0 then
      if y+iy <= Pix.Height-1 then
      begin
        ps:=@Pix.Pixels[Addr(x-1,y+iy,k)];
        for ix:=-1 to 1 do
        begin
          if x+ix >= 0 then
          if x+ix <= Pix.Width-1 then
          begin
            j:=j+ord(ps^)*aConv[ix,iy];
            n:=n+aConv[ix,iy];
          end;
          inc(ps,PixelDepth);
        end;
      end;
    end;
    if n > 0 then
      pd^:=char(ClipToByte(j div n)) else
      pd^:=#0;
//ps:=@Pix.Pixels[Addr(x,y,k)];
//pd^:=char(ClipToByte(ord(ps^)-ord(pd^)));
//pd^:=char(ClipToByte(ord(ps^)+ord(pd^)));
    inc(pd);
  end;
{$R+}
end;

(*
function PixConvolve3x3(Pix: TPix; aConv: TConvolution3x3): TPix;
var PixelDepth: integer;
  function Addr(x,y,k: integer): integer;
  begin
    result:=y*Pix.Width*PixelDepth+x*PixelDepth+k+1;
  end;
var n,j,k,x,y: integer;
    ix,iy: T21;
    ps,pd: pChar;
begin
  result:=PixMakeSameSize(Pix);
  PixelDepth:=GetPixelDepth(Pix.ColorModel);

{$R-}
  pd:=@result.Pixels[1];
  for y:=0 to Pix.Height-1 do
  for x:=0 to Pix.Width-1 do
  for k:=0 to PixelDepth-1 do
  begin
    j:=0;
    n:=0;
    for iy:=-1 to 1 do
    begin
      if y+iy >= 1 then
      if y+iy <= Pix.Height-1-1 then
      begin
        ps:=@Pix.Pixels[Addr(x-1,y+iy,k)];
        for ix:=-1 to 1 do
        begin
          if x+ix >= 1 then
          if x+ix <= Pix.Width-1-1 then
          begin
            j:=j+ord(ps^)*aConv[ix,iy];
            n:=n+aConv[ix,iy];
          end;
          inc(ps,PixelDepth);
        end;
      end;
    end;
    if n > 0 then
      pd^:=char(ClipToByte(j div n)) else
      pd^:=#0;
    inc(pd);
  end;
{$R+}
end;
*)

function PixBlur3x3(Pix: TPix): TPix;
const Conv: TConvolution3x3 =
  ((0,1,0),
   (1,1,1),
   (0,1,0));
begin
  result:=PixConvolve3x3(Pix,Conv);
end;

function PixBlur21x21(Pix: TPix; n: T21): TPix;
{ if n > 0 then sharpen }
{ if n < 0 then blur }
var Conv: TConvolution21x21;
    a,x,y: integer;
    ps,pd: pbyte;
begin
//  for x:=-abs(n) to abs(n) do
//    for y:=-abs(n) to abs(n) do
//      Conv[x,y]:=  trunc(2*sqr(n)/(sqr(x)+sqr(y)+sqr(n)));

  fillchar(Conv,sizeof(Conv),0);
  for x:=-abs(n) to abs(n) do
    for y:=-abs(n) to abs(n) do
    begin
      a:=abs(n)-trunc(sqrt(sqr(x)+sqr(y)));
      if a > 0 then
        Conv[x,y]:=a else
        Conv[x,y]:=0;
    end;
  result:=PixConvolve21x21(Pix,Conv);

  if n > 0 then
  begin
    ps:=@pix.Pixels[1];
    pd:=@result.Pixels[1];
    for y:=1 to length(pix.Pixels) do
    begin
//      a:=ps^-ord(result.Pixels[y]); if a < 0 then a:=0;
      a:=ps^-pd^; if a < 0 then a:=0;
      a:=ps^+a;   if a > 255 then a:=255;
      pd^:=a;
      inc(ps);
      inc(pd);
    end;
  end;
end;

function PixStretchToFit_BitBlt(Source: TPix; Width,Height: integer): TPix;
var i,x,y: integer;
    x1,y1: integer;
    p1,p4: pChar;
    dx,ax: single;
    PixelDepth: integer;
begin
  result:=PixSetSize(Width,Height,Source.ColorModel);
  dx:=(Source.Width-1);
  PixelDepth:=GetPixelDepth(Source.ColorModel);

  for y:=0 to Height-1 do
  begin
    y1:=IntRange(trunc(y*(Source.Height-1)/(Height-1)),0,Source.Height-1);
    p1:=PixScanLine(Source,y1);
    p4:=PixScanLine(result,y);
    x1:=0;
    ax:=0;

    for x:=0 to Width-1 do
    begin
      while (ax >= (Width-1)) and (x1 < Source.Width-1) do
      begin
        inc(x1);
        inc(p1,PixelDepth);
        ax:=ax-(Width-1);
      end;

      for i:=0 to PixelDepth-1 do
      begin
        p4[0]:=p1[i];
        inc(p4);
      end;

      ax:=ax+dx;
    end;
  end;
end;

function PixStretchToFit_BlurBitBlt(Source: TPix; nBlur,Width,Height: integer): TPix;
var i: integer;
begin
  if Width*Height < Source.Width*Source.Height then
  begin{shrinking}
    for i:=1 to nBlur do
      Source:=PixBlur3x3(Source);
    result:=PixStretchToFit_BitBlt(Source,Width,Height);
  end else
  begin{expanding}
    result:=PixStretchToFit_BitBlt(Source,Width,Height);
    for i:=1 to nBlur do
      result:=PixBlur3x3(result);
  end;
end;

function PixStretchToFit_Gaussian(Source: TPix; nBlur,Width,Height: integer): TPix;
  procedure Convolve(a: array of integer);
  var pix: TPix;
      x,y,i,r,g,b,n: integer;
      c: TColor;
  begin
//    Pix:=Source;

    Pix:=PixMakeSameSize(Source);
    for x:=0 to Source.Width-1 do
    for y:=0 to Source.Height-1 do
    begin
      r:=0;
      g:=0;
      b:=0;
      n:=0;
      for i:=-nBlur div 2 to nBlur div 2 do
        if (x+i >= 0) and (x+i < Source.Width) then
        begin
          inc(r,a[i+nBlur div 2]*RGBQuad(PixelChannel(Source,x+i,y)).rgbRed);
          inc(g,a[i+nBlur div 2]*RGBQuad(PixelChannel(Source,x+i,y)).rgbGreen);
          inc(b,a[i+nBlur div 2]*RGBQuad(PixelChannel(Source,x+i,y)).rgbBlue);

          inc(n,a[i+nBlur div 2]);
        end;
      PixSetPixelChannel(Pix,x,y,rgb(b div n,g div n,r div n));
    end;

    Pix:=PixMakeSameSize(Source);
    for x:=0 to Source.Width-1 do
    for y:=0 to Source.Height-1 do
    begin
      r:=0;
      g:=0;
      b:=0;
      n:=0;
      for i:=-nBlur div 2 to nBlur div 2 do
        if (x+i >= 0) and (x+i < Source.Width) then
        begin
          inc(r,a[i+nBlur div 2]*RGBQuad(PixelChannel(Source,x,y+i)).rgbRed);
          inc(g,a[i+nBlur div 2]*RGBQuad(PixelChannel(Source,x,y+i)).rgbGreen);
          inc(b,a[i+nBlur div 2]*RGBQuad(PixelChannel(Source,x,y+i)).rgbBlue);

          inc(n,a[i+nBlur div 2]);
        end;
      PixSetPixelChannel(Pix,x,y,rgb(b div n,g div n,r div n));
    end;

//result:=Pix;
//exit;

    result:=PixSetSize(Width,Height,Source.ColorModel);
    for x:=0 to Source.Width-1 do
      for y:=0 to Source.Height-1 do
        PixSetPixelChannel(result,x,y,
          PixelChannel(Pix,
            round((x+0.5)*Source.Width/Width)-1,
            round((y+0.5)*Source.Height/Height))-1);
  end;
var i: integer;
const G5a: array[0..5] of integer = (55,  478,  982,  478,  55,$800);
const G5b: array[0..5] of integer = (3527,   30588,   62841, 30588,   3527,$20000);
const G7:  array[0..7] of integer = (3293,    20664,   62206,   89819,   62206,   20664,   3293,$40000);
const G9:  array[0..9] of integer = (1996,  9457,  28727,  55953,   69877,  55953,   28727, 9457,    1996,$40000);
begin
  if (Width > Source.Width) or (Height > Source.Height) then
    raise Exception.Create('PixStretchToFit(shGaussian) an only be used to shrink images');

  case nBlur of
    5: Convolve(G5a);
    7: Convolve(G7);
    9: Convolve(G9);
    else assert(false,'wrong nblur');
  end;
end;

function PixStretchToFit_Mean(Source: TPix; Width,Height: integer): TPix;
var r,g,b,i,x,y,x1,y1: integer;
    p2,p4: pChar;
    PixelDepth: integer;
begin
  PixelDepth:=GetPixelDepth(Source.ColorModel);

//  if Width*Height < Source.Width*Source.Height then
//  begin{shrinking}
    result:=PixSetSize(Width,Height,Source.ColorModel);

    for y:=0 to Height-1 do
    begin
      p4:=PixScanLine(result,y);

      for x:=0 to Width-1 do
      begin
        i:=0;
        r:=0;
        g:=0;
        b:=0;

        for y1:=y*Source.Height div Height to (y+1)*Source.Height div Height-1 do
        begin
          p2:=@pchar(PixScanLine(Source,y1))[(x*Source.Width div Width)*PixelDepth+0];
          p2:=@pchar(PixScanLine(Source,y1))[(x*Source.Width div Width)*PixelDepth+0];

          for x1:=x*Source.Width div Width to (x+1)*Source.Width div Width-1 do
          begin
            inc(r,ord(p2[0]));
            if PixelDepth = 3 then
            begin
              inc(g,ord(p2[1]));
              inc(b,ord(p2[2]));
            end;

            inc(p2,PixelDepth);
            inc(i);
          end;
        end;

        if PixelDepth = 3 then
        begin
          if i = 0 then
          begin
            p4[0]:=p2[0];
            p4[1]:=p2[1];
            p4[1]:=p2[2];
          end else
          begin
            p4[0]:=char(r div i);
            p4[1]:=char(g div i);
            p4[2]:=char(b div i);
          end;
        end else
        begin
          if i = 0 then
            p4[0]:=p2^ else
            p4[0]:=char(r div i);
        end;
        inc(p4,PixelDepth);
      end;
    end;
//  end else
//  begin{expanding - don't use this option}
//    result:=PixStretchToFit_BitBlt(Source,Width,Height);
//  end;
end;

function PixStretchToFit_Linear(Source: TPix; Width,Height: integer): TPix;
var i,x,y,v: integer;
    x1,x2,y1,y2: integer;
    p1,p2,p4: pChar;
    dx,dy,a,b,c,d,h,ax,ay: single;
    PixelDepth,r1,g1,b1,r2,g2,b2,r3,g3,b3,r4,g4,b4: integer;
begin
  result:=PixSetSize(Width,Height,Source.ColorModel);
  dx:=Source.Width/Width;
  PixelDepth:=GetPixelDepth(Source.ColorModel);

//if false then
  if (Width > Source.Width) and (Height > Source.Height) then
  begin
//    dx:=(Source.Width-1)/(Width-1);
//    dy:=(Source.Height-1)/(Height-1);
    dx:=Source.Width/Width;
    dy:=Source.Height/Height;
    for y:=0 to Height-1 do
      for x:=0 to Width-1 do
      begin
        ax:=(x)*dx-0.5;
        ay:=(y)*dy-0.5;

        x1:=IntRange(trunc(ax),0,Source.Width-1);
        y1:=IntRange(trunc(ay),0,Source.Height-1);
        x2:=IntRange(trunc(ax+1),0,Source.Width-1);
        y2:=IntRange(trunc(ay+1),0,Source.Height-1);

        r1:=RGBQuad(PixelChannel(Source,x1,y1)).rgbRed;
        g1:=RGBQuad(PixelChannel(Source,x1,y1)).rgbGreen;
        b1:=RGBQuad(PixelChannel(Source,x1,y1)).rgbBlue;
        r2:=RGBQuad(PixelChannel(Source,x2,y1)).rgbRed;
        g2:=RGBQuad(PixelChannel(Source,x2,y1)).rgbGreen;
        b2:=RGBQuad(PixelChannel(Source,x2,y1)).rgbBlue;
        r3:=RGBQuad(PixelChannel(Source,x1,y2)).rgbRed;
        g3:=RGBQuad(PixelChannel(Source,x1,y2)).rgbGreen;
        b3:=RGBQuad(PixelChannel(Source,x1,y2)).rgbBlue;
        r4:=RGBQuad(PixelChannel(Source,x2,y2)).rgbRed;
        g4:=RGBQuad(PixelChannel(Source,x2,y2)).rgbGreen;
        b4:=RGBQuad(PixelChannel(Source,x2,y2)).rgbBlue;

        ax:=frac(ax);
        ay:=frac(ay);

        PixSetPixelChannel(result,x,y,rgb(
          round((b1*(1-ax)+b2*ax)*(1-ay)+(b3*(1-ax)+b4*ax)*ay),
          round((g1*(1-ax)+g2*ax)*(1-ay)+(g3*(1-ax)+g4*ax)*ay),
          round((r1*(1-ax)+r2*ax)*(1-ay)+(r3*(1-ax)+r4*ax)*ay)));
      end;
    exit;
  end;

  for y:=0 to Height-1 do
  begin
    y1:=IntRange(trunc(y*(Source.Height-1)/(Height-1)),0,Source.Height-1);
    y2:=IntRange(y1+1,0,Source.Height-1);
    ay:=frac(y*(Source.Height-1)/(Height-1));
    p1:=PixScanLine(Source,y1);
    p2:=PixScanLine(Source,y2);
    p4:=PixScanLine(result,y);
    x1:=0;
    ax:=0;

    for x:=0 to Width-1 do
    begin
      while ax >= 0.999 do
      begin
        if x1 < Source.Width-1 then
        begin
          inc(x1);
          inc(p1,PixelDepth);
          inc(p2,PixelDepth);
        end;
        ax:=ax-1;
      end;

      for i:=0 to PixelDepth-1 do
      begin
        if x1 < Source.Width-1 then
          begin a:=ord(p1[0]); c:=ord(p2[0]); b:=ord(p1[PixelDepth]); d:=ord(p2[PixelDepth]); end else
          begin a:=ord(p1[0]); c:=ord(p2[0]); b:=ord(p1[0]);          d:=ord(p2[0]);          end;
        h:=a+(c-a)*ay+((d-b-c+a)*ay+(b-a))*ax;
        v:=trunc(h);

        p4[0]:=char(v);
        inc(p4);
        inc(p1);
        inc(p2);
      end;
      dec(p1,PixelDepth);
      dec(p2,PixelDepth);

      ax:=ax+dx;
    end;
  end;
end;

function PixStretchToFit_Bicubic(Source: TPix; Width,Height: integer): TPix;
type TIndex = -1..2;
     TBicubicArray = array[TIndex,TIndex] of integer;
  function CubicInterp(ym,y0,y1,y2,x: single): single;
  {interpolate between y0 and y1; x in range 0..1}
  var a,b,c,d: single;
  begin
    a:=-ym+y0*3-y1*3+y2;
    b:=+ym*3-y0*6+y1*3;
    c:=+y1*6-y0*3-ym*2-y2;
    d:=+y0*6;
    result:=(((a*x+b)*x+c)*x+d)/6;
  end;
var i,x,y: integer;
    j,k: TIndex;
    p: array[TIndex] of pChar;
    xi: integer;
    yi: array[TIndex] of integer;
    pd: pChar;
    ax,ay,bx: single;
    PixelDepth: integer;
    a: array[0..3,-1..2] of char;
begin
  result:=PixSetSize(Width,Height,Source.ColorModel);
  PixelDepth:=GetPixelDepth(Source.ColorModel);

  for y:=0 to Height-1 do
  begin
    ay:=y*(Source.Height-1)/(Height-1);

    yi[ 0]:=IntRange(trunc(ay),0,Source.Height-1);
    yi[-1]:=IntRange(yi[0]-1,0,Source.Height-1);
    yi[ 1]:=IntRange(yi[0]+1,0,Source.Height-1);
    yi[ 2]:=IntRange(yi[0]+2,0,Source.Height-1);

    ay:=frac(ay);

    p[ 0]:=PixScanLine(Source,yi[ 0]);
    p[-1]:=PixScanLine(Source,yi[-1]);
    p[ 1]:=PixScanLine(Source,yi[ 1]);
    p[ 2]:=PixScanLine(Source,yi[ 2]);

    pd:=PixScanLine(result,y);

    for i:=0 to PixelDepth-1 do
    begin
      a[i,0]:=char(ClipToByte(trunc(CubicInterp(
          ord(p[-1][i]),
          ord(p[ 0][i]),
          ord(p[ 1][i]),
          ord(p[ 2][i]),
          ay))));
      a[i,-1]:=a[i,0];
      if 1 <= Source.Width-1 then
        a[i,1]:=char(ClipToByte(trunc(CubicInterp(
          ord(p[-1][1*PixelDepth+i]),
          ord(p[ 0][1*PixelDepth+i]),
          ord(p[ 1][1*PixelDepth+i]),
          ord(p[ 2][1*PixelDepth+i]),
          ay)))) else
        a[i,1]:=a[i,0];
      if 2 <= Source.Width-1 then
        a[i,2]:=char(ClipToByte(trunc(CubicInterp(
          ord(p[-1][2*PixelDepth+i]),
          ord(p[ 0][2*PixelDepth+i]),
          ord(p[ 1][2*PixelDepth+i]),
          ord(p[ 2][2*PixelDepth+i]),
          ay)))) else
        a[i,2]:=a[i,1];
    end;

    xi:=IntRange(2,0,Source.Width-1)*PixelDepth;
    bx:=(Source.Width-1)/(Width-1);
    ax:=-bx;

    for x:=0 to Width-1 do
    begin
      ax:=ax+bx;

      while ax > 1 do
      begin
        if xi div PixelDepth < Source.Width-1 then
          xi:=xi+PixelDepth;
        ax:=ax-1;
        for i:=0 to PixelDepth-1 do
        begin
          for j:=-1 to 1 do
            a[i,j]:=a[i,j+1];
          a[i,2]:=char(ClipToByte(trunc(CubicInterp(
              ord(p[-1][xi+i]),
              ord(p[ 0][xi+i]),
              ord(p[ 1][xi+i]),
              ord(p[ 2][xi+i]),
              ay))));
        end;
      end;

      for i:=0 to PixelDepth-1 do
      begin
        pd[0]:=char(ClipToByte(trunc(CubicInterp(
          ord(a[i,-1]),
          ord(a[i, 0]),
          ord(a[i, 1]),
          ord(a[i, 2]),
          frac(ax)))));
        inc(pd);
      end;
    end;
  end;
end;

function PixStretchToFit(Source: TPix; Shrink: TShrink; nBlur,Width,Height: integer): TPix;
begin
  if (Width = Source.Width) and (Height = Source.Height) then
    result:=source else
  case Shrink of
    shBlurBitBlt:     result:=PixStretchToFit_BlurBitBlt(Source,nBlur,Width,Height);
    shGaussian:       result:=PixStretchToFit_Gaussian(Source,nBlur,Width,Height);
    shMean:           result:=PixStretchToFit_Mean(Source,Width,Height);
    shLinear:         result:=PixStretchToFit_Linear(Source,Width,Height);
    shBicubic:        result:=PixStretchToFit_Bicubic(Source,Width,Height);
    shNoShrink:       result:=Source;
    else              result:=PixStretchToFit_BitBlt(Source,Width,Height);
  end;
end;

function PixMakeSameSize(Source: TPix): TPix;
begin
  result:=PixSetSize(Source.Width,Source.Height,Source.ColorModel);
end;

procedure PixDraw(Canvas: TCanvas; x,y: integer; Pix: TPix);
var temp: TBitmap;
begin
  temp:=PixToBitmap(Pix);
  Canvas.Draw(x,y,temp);
  temp.Free;
end;

procedure PixStretchDraw(Canvas: TCanvas; Pix: TPix; SourceRect,DestRect: TRect);
var temp: TBitmap;
begin
  if DestRect.Left < 0 then
  begin
    SourceRect.Left:=SourceRect.Left-DestRect.Left*(SourceRect.Right-SourceRect.Left) div (DestRect.Right-DestRect.Left);
    DestRect.Left:=0;
  end;
  if DestRect.Top < 0 then
  begin
    SourceRect.Top:=SourceRect.Top-DestRect.Top*(SourceRect.Bottom-SourceRect.Top) div (DestRect.Bottom-DestRect.Top);
    DestRect.Top:=0;
  end;

  if (SourceRect.Left >= SourceRect.Right) or
     (SourceRect.Top  >= SourceRect.Bottom) or
     (DestRect.Left >= DestRect.Right) or
     (DestRect.Top  >= DestRect.Bottom) then
    exit;

  temp:=SubPixToBitmap(pix,sourceRect);
  Canvas.StretchDraw(DestRect,temp);
  temp.Free;
end;

function PixAbs128(Pix: TPix): TPix;
var i: integer;
begin
  result:=PixSetSize(Pix.Width,Pix.Height,Pix.ColorModel);
  for i:=1 to length(result.Pixels) do
    result.Pixels[i]:=char(ClipToByte(abs(ord(Pix.Pixels[i])-128)));
end;

function PixMaths(Source1,Source2: TPix; Source1Mult,Source2Mult,AddConst,DivConst: integer): TPix;
var i: integer;
begin
  result:=PixSetSize(Source1.Width,Source1.Height,Source1.ColorModel);
  for i:=1 to length(result.Pixels) do
    result.Pixels[i]:=char(ClipToByte((ord(Source1.Pixels[i])*Source1Mult+ord(Source2.Pixels[i])*Source2Mult+AddConst) div DivConst));
end;

function PixMult(Source1,Source2: TPix; MultConst,AddConst,DivConst: integer): TPix;
var i: integer;
begin
  result:=PixSetSize(Source1.Width,Source1.Height,Source1.ColorModel);
  for i:=1 to length(result.Pixels) do
    result.Pixels[i]:=char(ClipToByte((ord(Source1.Pixels[i])*ord(Source2.Pixels[i])*MultConst+AddConst) div DivConst));
end;

function PixLogic(Source1,Source2: TPix; op: TLogicOp): TPix;
var i: integer;
begin
  result:=PixSetSize(Source1.Width,Source1.Height,Source1.ColorModel);
  case op of
    loAnd: for i:=1 to length(result.Pixels) do result.Pixels[i]:=char(ord(Source1.Pixels[i]) and ord(Source2.Pixels[i]));
    loOr:  for i:=1 to length(result.Pixels) do result.Pixels[i]:=char(ord(Source1.Pixels[i]) or  ord(Source2.Pixels[i]));
    loXor: for i:=1 to length(result.Pixels) do result.Pixels[i]:=char(ord(Source1.Pixels[i]) xor ord(Source2.Pixels[i]));
    loGT:  for i:=1 to length(result.Pixels) do result.Pixels[i]:=char((ord(Source1.Pixels[i]) >   ord(Source2.Pixels[i])*255));
    loLT:  for i:=1 to length(result.Pixels) do result.Pixels[i]:=char((ord(Source1.Pixels[i]) <   ord(Source2.Pixels[i])*255));
    loMax: for i:=1 to length(result.Pixels) do result.Pixels[i]:=char(max(ord(Source1.Pixels[i]),ord(Source2.Pixels[i])));
    loMin: for i:=1 to length(result.Pixels) do result.Pixels[i]:=char(max(ord(Source1.Pixels[i]),ord(Source2.Pixels[i])));
  end;
end;

function PixAdd(Source1,Source2: TPix): TPix;
begin
  result:=PixAddOfs(Source1,Source2,-128);
end;

function PixAddRandom(Source: TPix; a: integer): TPix;
var i,b: integer;
begin
  b:=a div 2;
  result:=Source;
  for i:=1 to length(result.Pixels) do
    result.Pixels[i]:=char(ClipToByte(ord(Source.Pixels[i])+random(a)-b));
end;

function PixAddOfs(Source1,Source2: TPix; ofs: integer): TPix;
var i: integer;
begin
  result:=PixSetSize(Source1.Width,Source1.Height,Source1.ColorModel);
  for i:=1 to length(result.Pixels) do
    result.Pixels[i]:=char(ClipToByte(ord(Source1.Pixels[i])+ord(Source2.Pixels[i])+ofs));
end;

function PixSubOfs(Source1,Source2: TPix; ofs: integer): TPix;
var i: integer;
begin
  result:=PixSetSize(Source1.Width,Source1.Height,Source1.ColorModel);
  for i:=1 to length(result.Pixels) do
    result.Pixels[i]:=char(ClipToByte(ord(Source1.Pixels[i])-ord(Source2.Pixels[i])+ofs));
end;

function PixDiff(Source1,Source2: TPix): TPix;
var x,i,j: integer;
begin
  if GetPixelDepth(Source1.ColorModel) > GetPixelDepth(Source2.ColorModel) then
    Source2:=PixConvertToColorModel(Source2,Source1.ColorModel) else
  if GetPixelDepth(Source2.ColorModel) > GetPixelDepth(Source1.ColorModel) then
    Source1:=PixConvertToColorModel(Source1,Source2.ColorModel) else
  if Source2.ColorModel <> Source1.ColorModel then
    Source2:=PixConvertToColorModel(Source2,Source1.ColorModel);
  result:=PixMakeSameSize(Source1);

  for x:=1 to length(result.Pixels) do
  begin
    i:=ord(Source1.Pixels[x]);
    j:=ord(Source2.Pixels[x]);
    result.Pixels[x]:=char(ClipToByte(i-j+128));
  end;
end;

procedure PixPolygonFill(var Pix: TPix; Pts: array of TPoint; col: TColor);
var Edges: array of array of integer;
const Dots: integer = -1;
  procedure AddLine(x1,y1,x2,y2: integer);
  var bx,by: integer;
  begin
    DrawLinePixChannelDotted(Pix,x1,y1,x2,y2,col,Dots);

    if y1 <> y2 then
    for by:=IntMin([y1,y2]) to IntMax([y1,y2])-1 do
    if (by >= low(Edges)) and (by <= high(Edges)) then
    begin
      SetLength(Edges[by],Length(Edges[by])+1);
      if y2-y1 = 0 then
        Edges[by][Length(Edges[by])-1]:=x1 else
        Edges[by][Length(Edges[by])-1]:=round((by-y1)*(x2-x1)/(y2-y1)+x1);
    end;
  end;
var ax,ay,bx,by,i,j: integer;
    more: boolean;
begin
  case Pix.ColorModel of
    cgYUV: Col:=RGBtoYUV(Col);
    cgHSL: Col:=RGBtoHSL(Col);
  end;
  SetLength(Edges,Pix.Height);
  fillchar(Edges[0],sizeof(Edges),0);

  for i:=low(Pts) to high(Pts)-1 do
    AddLine(Pts[i].x,Pts[i].y,Pts[i+1].x,Pts[i+1].y);
  AddLine(Pts[high(Pts)].x,Pts[high(Pts)].y,Pts[low(Pts)].x,Pts[low(Pts)].y);

  for by:=low(Edges) to high(Edges) do
  begin
    repeat
      more:=false;
      for i:=low(Edges[by]) to high(Edges[by])-1 do
        if Edges[by][i] > Edges[by][i+1] then
        begin
          j:=Edges[by][i];
          Edges[by][i]:=Edges[by][i+1];
          Edges[by][i+1]:=j;
          more:=true;
        end;
    until not more;

    for i:=low(Edges[by]) to high(Edges[by])-1 do
    if not odd(i) then
      DrawLinePixChannelDotted(Pix,Edges[by][i],by,Edges[by][i+1]+1,by,col,Dots);
  end;
end;

procedure LightenLinePix(var Pix: TPix; x1,y1,x2,y2: integer; dL: integer); {Color cannot contain YUV}
  procedure LightenPixel(x,y: integer);
  begin
    if GetPixelDepth(Pix.ColorModel) = 1 then
      PixSetPixelChannel(Pix,x,y,ClipToByte(Pixel(Pix,x,y)+dL)) else
      PixSetPixelChannel(Pix,x,y,ClipRGB(PixelRed(Pix,x,y)+dL,PixelGreen(Pix,x,y)+dL,PixelBlue(Pix,x,y)+dL));
  end;
  procedure DrawLine;
  var dx,dy,c,ly,lx: integer;
  begin
    if x2 > x1 then dx:=+1 else dx:=-1;
    if y2 > y1 then dy:=+1 else dy:=-1;
    lx:=abs(x2-x1);
    ly:=abs(y2-y1);

    if lx > ly then
    begin
      c:=lx div 2;
      while x1 <> x2 do
      begin
        LightenPixel(x1,y1);
        inc(x1,dx);
        c:=c+ly;
        if c > lx then
        begin
          inc(y1,dy);
          c:=c-lx;
        end;
      end;
    end else
    begin
      c:=ly div 2;
      while y1 <> y2 do
      begin
        LightenPixel(x1,y1);
        inc(y1,dy);
        c:=c+lx;
        if c > ly then
        begin
          inc(x1,dx);
          c:=c-ly;
        end;
      end;
    end;
  end;
  procedure DrawLinePtr;
  {uses pointer arithmetic so is faster but less safe}
  var i,dx,dy,c,ly,lx,depth: integer;
      p: pByte;
      p3: ^T3Color absolute p;
  const cc3: T3Color = (c3Red:255;c3Green:255;c3Blue:0);
  begin
    if x2 > x1 then dx:=+1 else dx:=-1;
    if y2 > y1 then dy:=+1 else dy:=-1;
    lx:=abs(x2-x1);
    ly:=abs(y2-y1);

    depth:=GetPixelDepth(Pix.ColorModel);

    p:=PixScanLine(Pix,y1);
    inc(p,depth*x1);
    dy:=dy*depth*Pix.Width;
    dx:=dx*depth;

    if lx > ly then
    begin
      c:=lx div 2;
      for i:=1 to lx do
      begin
        if depth = 1 then
          p^:=ClipToByte(p^+dL) else
        begin
          p3.c3Red:=ClipToByte(p3.c3Red+dL);
          p3.c3Green:=ClipToByte(p3.c3Green+dL);
          p3.c3Blue:=ClipToByte(p3.c3Blue+dL);
        end;
        inc(p,dx);
        c:=c+ly;
        if c > lx then
        begin
          inc(p,dy);
          c:=c-lx;
        end;
      end;
    end else
    begin
      c:=ly div 2;
      for i:=1 to ly do
      begin
        if depth = 1 then
          p^:=ClipToByte(p^+dL) else
        begin
          p3.c3Red:=ClipToByte(p3.c3Red+dL);
          p3.c3Green:=ClipToByte(p3.c3Green+dL);
          p3.c3Blue:=ClipToByte(p3.c3Blue+dL);
        end;
        inc(p,dy);
        c:=c+lx;
        if c > ly then
        begin
          inc(p,dx);
          c:=c-ly;
        end;
      end;
    end;
  end;
var LastPixel: boolean;
begin
  case Pix.ColorModel of
    cgYUV,cgHSL: exit;
  end;

  LastPixel:=false;
  if x1 < 0           then begin if x2 < 0           then exit; y1:=(0-x1)*(y2-y1) div (x2-x1)+y1;            x1:=0;            end;
  if x1 < 0           then begin if x2 < 0           then exit; y2:=(0-x2)*(y1-y2) div (x1-x2)+y2;            x2:=0;            LastPixel:=true; end;
  if x1 >= Pix.Width  then begin if x2 >= Pix.Width  then exit; y1:=(Pix.Width-1-x1)*(y2-y1) div (x2-x1)+y1;  x1:=Pix.Width-1;  end;
  if x2 < 0           then begin if x1 < 0           then exit; y2:=(0-x2)*(y1-y2) div (x1-x2)+y2;            x2:=0;            LastPixel:=true; end;
  if x2 >= Pix.Width  then begin if x1 >= Pix.Width  then exit; y2:=(Pix.Width-1-x2)*(y1-y2) div (x1-x2)+y2;  x2:=Pix.Width-1;  LastPixel:=true; end;
  if y1 < 0           then begin if y2 < 0           then exit; x1:=(0-y1)*(x2-x1) div (y2-y1)+x1;            y1:=0;            end;
  if y1 >= Pix.Height then begin if y2 >= Pix.Height then exit; x1:=(Pix.Height-1-y1)*(x2-x1) div (y2-y1)+x1; y1:=Pix.Height-1; end;
  if y2 < 0           then begin if y1 < 0           then exit; x2:=(0-y2)*(x1-x2) div (y1-y2)+x2;            y2:=0;            LastPixel:=true; end;
  if y2 >= Pix.Height then begin if y2 >= Pix.Height then exit; x2:=(Pix.Height-1-y2)*(x1-x2) div (y1-y2)+x2; y2:=Pix.Height-1; LastPixel:=true; end;

  DrawLinePtr;

  if LastPixel and (x2 >= 0) and (x2 < Pix.Width) and (y2 >= 0) and (y2 < Pix.Height) then
    LightenPixel(x2,y2);
end;

procedure DrawLinePix(var Pix: TPix; x1,y1,x2,y2: integer; col: TColor);
const Dots: integer = -1;
begin
  case Pix.ColorModel of
    cgYUV: Col:=RGBtoYUV(Col);
    cgHSL: Col:=RGBtoHSL(Col);
  end;
  DrawLinePixChannelDotted(Pix,x1,y1,x2,y2,col,Dots);
end;

procedure DrawLinePixChannel(var Pix: TPix; x1,y1,x2,y2: integer; col: TColor);
const Dots: integer = -1;
begin
  DrawLinePixChannelDotted(Pix,x1,y1,x2,y2,col,Dots);
end;

procedure DrawLinePixChannelDotted(var Pix: TPix; x1,y1,x2,y2: integer; col: TColor; var Dots: integer); {Color is always RGB}
var c3: TRGBTriple absolute col;
  function ColorToMono(ColorModel: TColorModel; col: TColor): byte;
  var c: TRGBTriple absolute col;
  begin
    case ColorModel of
      cgRGB,cgYUV,cgHSL: assert(false,'Cannot convert to monochrome');
      cgMaxRGB: begin
                  result:=c.rgbtBlue;
                  if c.rgbtGreen > result then result:=c.rgbtGreen;
                  if c.rgbtRed > result then result:=c.rgbtRed;
                end;
      cg3R6G1B: result:=(c.rgbtBlue*1+c.rgbtGreen*6+c.rgbtRed*3) div 10;
      cgR,cgY,cgH:  result:=c.rgbtRed;
      cgG,cgU,cgS:  result:=c.rgbtGreen;
      cgB,cgV,cgL:  result:=c.rgbtBlue;
    end;
  end;
  procedure DrawLine;
  var dx,dy,c,ly,lx: integer;
  begin
    if x2 > x1 then dx:=+1 else dx:=-1;
    if y2 > y1 then dy:=+1 else dy:=-1;
    lx:=abs(x2-x1);
    ly:=abs(y2-y1);

    if lx > ly then
    begin
      c:=lx div 2;
      while x1 <> x2 do
      begin
        PixSetPixelChannel(Pix,x1,y1,col);
        inc(x1,dx);
        c:=c+ly;
        if c > lx then
        begin
          inc(y1,dy);
          c:=c-lx;
        end;
      end;
    end else
    begin
      c:=ly div 2;
      while y1 <> y2 do
      begin
        PixSetPixelChannel(Pix,x1,y1,col);
        inc(y1,dy);
        c:=c+lx;
        if c > ly then
        begin
          inc(x1,dx);
          c:=c-ly;
        end;
      end;
    end;
  end;
  procedure DrawLinePtr;
  {uses pointer arithmetic so is faster but less safe}
  var i,dx,dy,c,ly,lx,depth: integer;
      col1: byte;
      p: pChar;
      p3: ^T3Color absolute p;
      col3: T3Color;
  const cc3: T3Color = (c3Red:255;c3Green:255;c3Blue:0);
  begin
    if x2 > x1 then dx:=+1 else dx:=-1;
    if y2 > y1 then dy:=+1 else dy:=-1;
    lx:=abs(x2-x1);
    ly:=abs(y2-y1);

    depth:=GetPixelDepth(Pix.ColorModel);
    if depth = 3 then
      begin col3.c3Blue:=c3.rgbtBlue; col3.c3Green:=c3.rgbtGreen; col3.c3Red:=c3.rgbtRed; end else
      col1:=ColorToMono(Pix.ColorModel,col);

    p:=PixScanLine(Pix,y1);
    inc(p,depth*x1);
    dy:=dy*depth*Pix.Width;
    dx:=dx*depth;

    if lx > ly then
    begin
      c:=lx div 2;
      for i:=1 to lx do
      begin
        if Dots = -1 then
        begin
          if depth = 1 then p[0]:=char(col1) else p3^:=col3;
        end else
        begin
          Dots:=(Dots shl 1)+(Dots shr 31);
          if odd(Dots) then
            if depth = 1 then p[0]:=char(col1) else p3^:=col3;
        end;
        inc(p,dx);
        c:=c+ly;
        if c > lx then
        begin
          inc(p,dy);
          c:=c-lx;
        end;
      end;
    end else
    begin
      c:=ly div 2;
      for i:=1 to ly do
      begin
        if Dots = -1 then
        begin
          if depth = 1 then p[0]:=char(col1) else p3^:=col3;
        end else
        begin
          Dots:=(Dots shl 1)+(Dots shr 31);
          if odd(Dots) then
            if depth = 1 then p[0]:=char(col1) else p3^:=col3;
        end;
        inc(p,dy);
        c:=c+lx;
        if c > ly then
        begin
          inc(p,dx);
          c:=c-ly;
        end;
      end;
    end;
  end;
var LastPixel: boolean;
begin
  LastPixel:=false;
  if x1 < 0           then begin if x2 < 0           then exit; y1:=(0-x1)*(y2-y1) div (x2-x1)+y1;            x1:=0;            end;
  if x1 < 0           then begin if x2 < 0           then exit; y2:=(0-x2)*(y1-y2) div (x1-x2)+y2;            x2:=0;            LastPixel:=true; end;
  if x1 >= Pix.Width  then begin if x2 >= Pix.Width  then exit; y1:=(Pix.Width-1-x1)*(y2-y1) div (x2-x1)+y1;  x1:=Pix.Width-1;  end;
  if x2 < 0           then begin if x1 < 0           then exit; y2:=(0-x2)*(y1-y2) div (x1-x2)+y2;            x2:=0;            LastPixel:=true; end;
  if x2 >= Pix.Width  then begin if x1 >= Pix.Width  then exit; y2:=(Pix.Width-1-x2)*(y1-y2) div (x1-x2)+y2;  x2:=Pix.Width-1;  LastPixel:=true; end;
  if y1 < 0           then begin if y2 < 0           then exit; x1:=(0-y1)*(x2-x1) div (y2-y1)+x1;            y1:=0;            end;
  if y1 >= Pix.Height then begin if y2 >= Pix.Height then exit; x1:=(Pix.Height-1-y1)*(x2-x1) div (y2-y1)+x1; y1:=Pix.Height-1; end;
  if y2 < 0           then begin if y1 < 0           then exit; x2:=(0-y2)*(x1-x2) div (y1-y2)+x2;            y2:=0;            LastPixel:=true; end;
  if y2 >= Pix.Height then begin if y2 >= Pix.Height then exit; x2:=(Pix.Height-1-y2)*(x1-x2) div (y1-y2)+x2; y2:=Pix.Height-1; LastPixel:=true; end;

//  DrawLine;
  DrawLinePtr;

  if LastPixel and (x2 >= 0) and (x2 < Pix.Width) and (y2 >= 0) and (y2 < Pix.Height) then
    PixSetPixelChannel(Pix,x2,y2,col);
end;

function PixGetRect(Pix: TPix; Rect: TRect): TPix;
  function Addr(Pix: TPix; x,y: integer): integer;
  begin
    result:=(y*Pix.Width+x)*GetPixelDepth(Pix.ColorModel)+1;
  end;
var y: integer;
begin
  Rect.Left  :=IntRange(Rect.Left,  0,Pix.Width);
  Rect.Right :=IntRange(Rect.Right, 0,Pix.Width);
  Rect.Top   :=IntRange(Rect.Top,   0,Pix.Height);
  Rect.Bottom:=IntRange(Rect.Bottom,0,Pix.Height);
  if (Rect.Right-Rect.Left)*(Rect.Bottom-Rect.Top) = 0 then
  begin
    result:=PixSetSize(0,0,Pix.ColorModel);
  end else
  begin
    result:=PixSetSize(Rect.Right-Rect.Left,Rect.Bottom-Rect.Top,Pix.ColorModel);
    for y:=0 to result.Height-1 do
      move(
        Pix.Pixels[Addr(Pix,Rect.Left,y+Rect.Top)],
        result.Pixels[Addr(result,0,y)],
        (Rect.Right-Rect.Left)*GetPixelDepth(Pix.ColorModel));
  end;
end;

procedure PixDrawPix(Source: TPix; var Dest: TPix; x,y: integer);
  function Addr(Pix: TPix; x,y: integer): integer;
  begin
    result:=(y*Pix.Width+x)*GetPixelDepth(Pix.ColorModel)+1;
  end;
var x1s,y1s,x2d,y2d,ay: integer;
begin
  x2d:=min(x+Source.Width-1,Dest.Width-1);
  y2d:=min(y+Source.Height-1,Dest.Height-1);
  if x < 0 then begin x1s:=-x; x:=0; end else x1s:=0;
  if y < 0 then begin y1s:=-y; y:=0; end else y1s:=0;

  if x2d-x+1 > 0 then
    for ay:=0 to y2d-y do
      move(
        Source.Pixels[Addr(Source,x1s,ay-y1s)],
        Dest  .Pixels[Addr(Dest  ,x,ay+y)],
        (x2d-x+1)*GetPixelDepth(Source.ColorModel));
end;

function PixInterpolate(Source1,Source2: TPix; a: double): TPix;
{  if a = 0 the dest:=source1 else }
{  if a = 1 the dest:=source2 else }
{    dest:=linear interpolation between source1 and source2 }
var i,ia,ib,x: integer;
begin
  result:=PixMakeSameSize(Source1);

  ia:=trunc(256*a);
  ib:=256-ia;

  for x:=1 to length(result.pixels) do
  begin
    i:=ord(Source1.pixels[x])*ib+ord(Source2.pixels[x])*ia;
    result.pixels[x]:=char(HiByte(LoWord(i)));
  end;
end;

function MeasureBitmapDiff(Source1,Source2: TBitmap): double;
{ mean difference between Pixels }
var i,x,y: integer;
    pSource1,pSource2: pByteArray;
begin
  Source1.PixelFormat:=pf24bit;
  Source2.PixelFormat:=pf24bit;

  result:=0;
  for y:=0 to Source1.Height-1 do
  begin
    pSource1:=Source1.ScanLine[y];
    pSource2:=Source2.ScanLine[y];
    for x:=0 to Source1.Width*3-1 do
    begin
      i:=pSource1[0];
      i:=i-pSource2[0];
      result:=result+i*i;
      inc(pbyte(pSource1));
      inc(pbyte(pSource2));
    end;
  end;
  result:=result / (Source1.Height*Source1.Width*3);

  Source1.PixelFormat:=pfDevice;
  Source2.PixelFormat:=pfDevice;
end;

function MeasurePixDiff(Source1,Source2: TPix): double;
var n: integer;
  procedure Compare(var s1,s2: string);
  var i,x: integer;
      pSource1,pSource2: pByteArray;
  begin
    pSource1:=@s1[1];
    pSource2:=@s2[1];
    for x:=1 to length(s1) do
    begin
      i:=pSource1[0];
      i:=i-pSource2[0];
      result:=result+i*i;
      inc(pbyte(pSource1));
      inc(pbyte(pSource2));
    end;
    inc(n,length(s1));
  end;
{ mean difference between Pixels }
begin
  assert(Source1.ColorModel = Source2.ColorModel);
  assert(Source1.Width = Source2.Width);
  assert(Source1.Height = Source2.Height);

  result:=0;
  n:=0;
  Compare(Source1.Pixels,Source2.Pixels);
  result:=result / n;
end;

function PixConvertToColorModel(Pix: TPix; NewColorModel: TColorModel): TPix;
  procedure MonoToColor;
  var i: integer;
  begin
    case Pix.ColorModel of
      cgR,cgG,cgB: PixFillPixChannel(result,0);
      cgY,cgU,cgV: PixFillPixChannel(result,rgb(128,128,128));
      cgH,cgS,cgL: PixFillPixChannel(result,rgb(0,0,128));
    end;

    for i:=0 to length(result.Pixels)-1 do
    begin
      ShowProgressUpdate(i,length(result.Pixels)-1);
      case Pix.ColorModel of
        cgR,cgY,cgH: if i mod 3 = 2 then result.Pixels[i+1]:=Pix.Pixels[i div 3+1];
        cgG,cgU,cgS: if i mod 3 = 1 then result.Pixels[i+1]:=Pix.Pixels[i div 3+1];
        cgB,cgV,cgL: if i mod 3 = 0 then result.Pixels[i+1]:=Pix.Pixels[i div 3+1];
        else                         result.Pixels[i+1]:=Pix.Pixels[i div 3+1];
      end;
    end;
  end;
  procedure ColorToMono;
  var x,y: integer;
      ps,pd1: pChar;
  begin
    with result do
    for y:=0 to Height-1 do
    begin
      ShowProgressUpdate(y,Height-1);
      ps:=PixScanLine(Pix,y);
      pd1:=PixScanLine(result,y);
      for x:=0 to Width-1 do
      begin
        case NewColorModel of
          cgMaxRGB: begin
                      pd1^:=ps[0];
                      if ps[1] > pd1^ then pd1^:=ps[1];
                      if ps[2] > pd1^ then pd1^:=ps[2];
                    end;
          cg3R6G1B: pd1^:=char((longint(ord(ps[0]))*1+longint(ord(ps[1]))*6+longint(ord(ps[2]))*3) div 10);
          cgR,cgY,cgH:  pd1^:=ps[2];
          cgG,cgU,cgS:  pd1^:=ps[1];
          cgB,cgV,cgL:  pd1^:=ps[0];
        end;
        inc(pd1);
        inc(ps,3);
      end;
    end;
  end;
  function CovertRGBtoHSL(Pix: TPix): TPix;
  var i: integer;
      R,G,B: byte;
      col: TColor;
      c: T3Color absolute col;
  begin
    result:=PixSetSize(Pix.Width,Pix.Height,NewColorModel);
    for i:=0 to length(result.Pixels)-1 do
    if i mod 3 = 0 then
    begin
      ShowProgressUpdate(i,length(result.Pixels)-1);
      col:=0;
      c.c3Blue :=ord(Pix.Pixels[i+1+0]);
      c.c3Green:=ord(Pix.Pixels[i+1+1]);
      c.c3Red  :=ord(Pix.Pixels[i+1+2]);
      col:=RGBtoHSL(Col);
      result.Pixels[i+1+0]:=char(c.c3Blue);
      result.Pixels[i+1+1]:=char(c.c3Green);
      result.Pixels[i+1+2]:=char(c.c3Red);

{
      R:=ord(Pix.Pixels[i+1+2]);
      G:=ord(Pix.Pixels[i+1+1]);
      B:=ord(Pix.Pixels[i+1+0]);
//      col:=RGBtoHSL(rgb(R,G,B)); result.Pixels[i+1+2]:=char(Red(Col)); result.Pixels[i+1+1]:=char(Green(Col)); result.Pixels[i+1+0]:=char(Blue(Col));
      col:=RGBtoHSL(rgb(B,G,R)); result.Pixels[i+1+2]:=char(Red(Col)); result.Pixels[i+1+1]:=char(Green(Col)); result.Pixels[i+1+0]:=char(Blue(Col));
//      col:=RGBtoHSL(rgb(R,G,B)); result.Pixels[i+1+2]:=char(Blue(Col)); result.Pixels[i+1+1]:=char(Green(Col)); result.Pixels[i+1+0]:=char(Red(Col));
//      col:=RGBtoHSL(rgb(B,G,R)); result.Pixels[i+1+2]:=char(Blue(Col)); result.Pixels[i+1+1]:=char(Green(Col)); result.Pixels[i+1+0]:=char(Red(Col));
}
    end;
  end;
  function CovertHSLtoRGB(Pix: TPix): TPix;
  var i: integer;
      R,G,B: byte;
      col: TColor;
      c: T3Color absolute col;
  begin
    result:=PixSetSize(Pix.Width,Pix.Height,NewColorModel);
    for i:=0 to length(result.Pixels)-1 do
    if i mod 3 = 0 then
    begin
      ShowProgressUpdate(i,length(result.Pixels)-1);
      col:=0;
      c.c3Blue :=ord(Pix.Pixels[i+1+0]);
      c.c3Green:=ord(Pix.Pixels[i+1+1]);
      c.c3Red  :=ord(Pix.Pixels[i+1+2]);
      col:=HSLtoRGB(Col);
      result.Pixels[i+1+0]:=char(c.c3Blue);
      result.Pixels[i+1+1]:=char(c.c3Green);
      result.Pixels[i+1+2]:=char(c.c3Red);

{
      R:=ord(Pix.Pixels[i+1+2]);
      G:=ord(Pix.Pixels[i+1+1]);
      B:=ord(Pix.Pixels[i+1+0]);
//      col:=HSLtoRGB(rgb(R,G,B)); result.Pixels[i+1+2]:=char(Red(Col)); result.Pixels[i+1+1]:=char(Green(Col)); result.Pixels[i+1+0]:=char(Blue(Col));
      col:=HSLtoRGB(rgb(B,G,R)); result.Pixels[i+1+2]:=char(Red(Col)); result.Pixels[i+1+1]:=char(Green(Col)); result.Pixels[i+1+0]:=char(Blue(Col));
//      col:=HSLtoRGB(rgb(R,G,B)); result.Pixels[i+1+2]:=char(Blue(Col)); result.Pixels[i+1+1]:=char(Green(Col)); result.Pixels[i+1+0]:=char(Red(Col));
//      col:=HSLtoRGB(rgb(B,G,R)); result.Pixels[i+1+2]:=char(Blue(Col)); result.Pixels[i+1+1]:=char(Green(Col)); result.Pixels[i+1+0]:=char(Red(Col));
}
    end;
  end;
  function ColorToColor(Pix: TPix; OldColorModel,NewColorModel: TColorModel): TPix;
  var i: integer;
      ColorMatrix: TColorMatrix;
      R,G,B: single;
  begin
    case OldColorModel of
      cgRGB:
        Case NewColorModel of
          cgYUV: ColorMatrix:=RGBtoYUVMatrix;
          cgRGB: assert(false);
          cgHSL: begin result:=CovertRGBtoHSL(Pix); exit; end;
        end;
      cgYUV:
        Case NewColorModel of
          cgRGB: ColorMatrix:=YUVtoRGBMatrix;
          cgYUV: assert(false);
          cgHSL: begin result:=ColorToColor(result,cgYUV,cgRGB); result:=CovertRGBtoHSL(result); exit; end;
        end;
      cgHSL:
        Case NewColorModel of
          cgRGB:  begin result:=CovertHSLtoRGB(Pix); exit; end;
          cgYUV:  begin result:=CovertHSLtoRGB(Pix); result:=ColorToColor(result,cgRGB,cgYUV); exit; end;
          cgHSL: assert(false);
        end;
    end;

    result:=PixSetSize(Pix.Width,Pix.Height,NewColorModel);

    for i:=0 to length(result.Pixels)-1 do
    if i mod 3 = 0 then
    begin
      ShowProgressUpdate(i,length(result.Pixels)-1);
      R:=ord(Pix.Pixels[i+1+2]);
      G:=ord(Pix.Pixels[i+1+1]);
      B:=ord(Pix.Pixels[i+1+0]);
      result.Pixels[i+1+2]:=char(ByteRange(round(ColorMatrix[0,0]*R +ColorMatrix[0,1]*G +ColorMatrix[0,2]*B+ColorMatrix[0,3])));
      result.Pixels[i+1+1]:=char(ByteRange(round(ColorMatrix[1,0]*R +ColorMatrix[1,1]*G +ColorMatrix[1,2]*B+ColorMatrix[1,3])));
      result.Pixels[i+1+0]:=char(ByteRange(round(ColorMatrix[2,0]*R +ColorMatrix[2,1]*G +ColorMatrix[2,2]*B+ColorMatrix[2,3])));
    end;
  end;
  procedure MonoChannelToMonoChannel;
  begin
    if Pix.ColorModel = NewColorModel then
      result:=Pix else
    begin
      result:=PixSetSize(Pix.Width,Pix.Height,NewColorModel);
      case NewColorModel of
        cgY,cgU,cgV: PixFillPixChannel(result,rgb(128,128,128));
        cgH,cgS,cgL: PixFillPixChannel(result,rgb(0,0,128));
        else         PixFillPixChannel(result,0);
      end;
    end;
  end;
var i,x,y: integer;
    ps,pd1: pChar;
begin
  if Pix.ColorModel = NewColorModel then
    result:=Pix else
  begin
    StartProgressUpdate;
    case Pix.ColorModel of
      cgRGB,cgYUV,cgHSL:
        case NewColorModel of
          cgY,cgU,cgV:    { RGB -> Y    convert to YUV; extract chan 1 }
            begin         { YUV -> Y    convert to YUV; extract chan 1 }
              Pix:=PixConvertToColorModel(Pix,cgYUV);
              result:=PixSetSize(Pix.Width,Pix.Height,NewColorModel);
              ColorToMono;
            end;
          cgH,cgS,cgL:    { RGB -> Y    convert to YUV; extract chan 1 }
            begin         { YUV -> Y    convert to YUV; extract chan 1 }
              Pix:=PixConvertToColorModel(Pix,cgHSL);
              result:=PixSetSize(Pix.Width,Pix.Height,NewColorModel);
              ColorToMono;
            end;
          cgRGB,cgYUV,cgHSL:    { RGB -> YUV  convert to YUV }
            begin         { YUV -> RGB  convert to RGB }
              result:=ColorToColor(Pix,Pix.ColorModel,NewColorModel);
            end;
          else            { RGB -> R    convert to RGB; extract chan 1 }
            begin         { YUV -> R    convert to RGB; extract chan 1 }
              Pix:=PixConvertToColorModel(Pix,cgRGB);
              result:=PixSetSize(Pix.Width,Pix.Height,NewColorModel);
              ColorToMono;
            end;
        end;

      cgR,cgG,cgB,cgMaxRGB,cg3R6G1B:
        case NewColorModel of
          cgY,cgU,cgV:    { R -> Y  convert to YUV; extract chan 1 }
            begin
              Pix:=PixConvertToColorModel(Pix,cgYUV);
              result:=PixSetSize(Pix.Width,Pix.Height,NewColorModel);
              ColorToMono;
            end;
          cgH,cgS,cgL:    { R -> Y  convert to YUV; extract chan 1 }
            begin
              Pix:=PixConvertToColorModel(Pix,cgHSL);
              result:=PixSetSize(Pix.Width,Pix.Height,NewColorModel);
              ColorToMono;
            end;
          cgRGB,cgYUV,cgHSL:    { R -> RGB    make RGB; merge chan 1; convert to RGB }
            begin         { R -> YUV    make RGB; merge chan 1; convert to YUV }
              result:=PixSetSize(Pix.Width,Pix.Height,cgRGB);
              MonoToColor;
              result:=PixConvertToColorModel(result,NewColorModel);
            end;
          cgMaxRGB,cg3R6G1B:
            begin         { R -> Mono    make RGB; convert to mono }
              Pix:=PixConvertToColorModel(Pix,cgRGB);
              result:=PixSetSize(Pix.Width,Pix.Height,cgRGB);
              MonoToColor;
              result:=PixConvertToColorModel(result,NewColorModel);
            end;
          else            { R -> G  if same chan then 0 else copy }
            MonoChannelToMonoChannel;
        end;

      cgY,cgU,cgV,cgH,cgS,cgL:
        case NewColorModel of
          cgY,cgU,cgV,cgH,cgS,cgL:    { Y -> U  if same chan then 0 else copy }
            MonoChannelToMonoChannel;
          cgRGB,cgYUV,cgHSL:    { Y -> RGB    make YUV; merge chan 1; convert to RGB }
            begin         { Y -> YUV    make YUV; merge chan 1; convert to YUV }
              result:=PixSetSize(Pix.Width,Pix.Height,cgYUV);
              MonoToColor;
              result:=PixConvertToColorModel(result,NewColorModel);
            end;
          else            { Y -> R  convert to RGB; extract chan 1 }
            begin         { Y -> Mono    convert to RGB; convert to mono }
              Pix:=PixConvertToColorModel(Pix,cgRGB);
              result:=PixSetSize(Pix.Width,Pix.Height,NewColorModel);
              ColorToMono;
            end;
        end;
    end;
    StopProgressUpdate;
  end;
end;

procedure PixSplitChannels(Pix: TPix; var pixR,pixG,pixB: TPix);
  procedure SplitToColor;
  begin
    case Pix.ColorModel of
      cgRGB:
        begin
          pixR:=PixConvertToColorModel(Pix,cgR);
          pixG:=PixConvertToColorModel(Pix,cgG);
          pixB:=PixConvertToColorModel(Pix,cgB);
        end;
      cgYUV:
        begin
          pixR:=PixConvertToColorModel(Pix,cgY);
          pixG:=PixConvertToColorModel(Pix,cgU);
          pixB:=PixConvertToColorModel(Pix,cgV);
        end;
      cgHSL:
        begin
          pixR:=PixConvertToColorModel(Pix,cgH);
          pixG:=PixConvertToColorModel(Pix,cgS);
          pixB:=PixConvertToColorModel(Pix,cgL);
        end;
      cgR:
        begin
          pixR:=Pix;
          pixG:=PixSetSize(Pix.Width,Pix.Height,cgG); PixFillPixChannel(pixG,0);
          pixB:=pixG;
        end;
      cgG:
        begin
          pixR:=PixSetSize(Pix.Width,Pix.Height,cgR); PixFillPixChannel(pixR,0);
          pixG:=Pix;
          pixB:=pixR;
        end;
      cgB:
        begin
          pixR:=PixSetSize(Pix.Width,Pix.Height,cgR); PixFillPixChannel(pixR,0);
          pixG:=pixR;
          pixB:=Pix;
        end;
      cgY:
        begin
          pixR:=Pix;
          pixG:=PixSetSize(Pix.Width,Pix.Height,cgU); PixFillPixChannel(pixG,128);
          pixB:=pixG;
        end;
      cgU:
        begin
          pixR:=PixSetSize(Pix.Width,Pix.Height,cgY); PixFillPixChannel(pixR,128);
          pixG:=Pix;
          pixB:=pixR;
        end;
      cgV:
        begin
          pixR:=PixSetSize(Pix.Width,Pix.Height,cgY); PixFillPixChannel(pixR,128);
          pixG:=pixR;
          pixB:=Pix;
        end;
      cgH:
        begin
          pixR:=Pix;
          pixG:=PixSetSize(Pix.Width,Pix.Height,cgS); PixFillPixChannel(pixG,128);
          pixB:=pixG;
        end;
      cgS:
        begin
          pixR:=PixSetSize(Pix.Width,Pix.Height,cgH); PixFillPixChannel(pixR,128);
          pixG:=Pix;
          pixB:=pixR;
        end;
      cgL:
        begin
          pixR:=PixSetSize(Pix.Width,Pix.Height,cgH); PixFillPixChannel(pixR,128);
          pixG:=pixR; 
          pixB:=Pix;
        end;
      else
        begin
          pixR:=Pix;
          pixG:=Pix;
          pixB:=Pix;
        end;
    end;
  end;
begin
  StartProgressUpdate;
  case Pix.ColorModel of
    cgRGB,cgYUV,cgHSL:
      SplitToColor;
    cgR: begin pixR:=Pix; pixG:=PixMakeSameSize(PixR); PixFillPixChannel(pixG,0); pixB:=pixG; end;
    cgG: begin pixG:=Pix; pixR:=PixMakeSameSize(PixG); PixFillPixChannel(pixR,0); pixB:=pixR; end;
    cgB: begin pixB:=Pix; pixR:=PixMakeSameSize(PixB); PixFillPixChannel(pixR,0); pixG:=pixR; end;
    cgY: begin pixR:=Pix; pixG:=PixMakeSameSize(PixR); PixFillPixChannel(pixG,rgb(128,128,128)); pixB:=pixG; end;
    cgU: begin pixG:=Pix; pixR:=PixMakeSameSize(PixG); PixFillPixChannel(pixR,rgb(128,128,128)); pixB:=pixR; end;
    cgV: begin pixB:=Pix; pixR:=PixMakeSameSize(PixB); PixFillPixChannel(pixR,rgb(128,128,128)); pixG:=pixR; end;
    cgH: begin pixR:=Pix; pixG:=PixMakeSameSize(PixR); PixFillPixChannel(pixG,rgb(0,0,128)); pixB:=pixG; end;
    cgS: begin pixG:=Pix; pixR:=PixMakeSameSize(PixG); PixFillPixChannel(pixR,rgb(0,0,128)); pixB:=pixR; end;
    cgL: begin pixB:=Pix; pixR:=PixMakeSameSize(PixB); PixFillPixChannel(pixR,rgb(0,0,128)); pixG:=pixR; end;
    else
      begin
        pixR:=Pix;
        pixG:=Pix;
        pixB:=Pix;
      end;
  end;
  case Pix.ColorModel of
    cgYUV,cgY,cgU,cgV: begin pixR.ColorModel:=cgY; pixG.ColorModel:=cgU; pixB.ColorModel:=cgV; end;
    cgHSL,cgH,cgS,cgL: begin pixR.ColorModel:=cgH; pixG.ColorModel:=cgS; pixB.ColorModel:=cgL; end;
    else                   begin pixR.ColorModel:=cgR; pixG.ColorModel:=cgG; pixB.ColorModel:=cgB; end;
  end;
  StopProgressUpdate;
end;

function PixCombineChannels(pixR,pixG,pixB: TPix): TPix;
var i,x,y: integer;
    ps,pd1: pChar;
    R,G,B: single;
begin
  if (GetPixelDepth(PixR.ColorModel) <> 1) or
     (GetPixelDepth(PixG.ColorModel) <> 1) or
     (GetPixelDepth(PixB.ColorModel) <> 1) then
    raise Exception.Create('PixCombineChannels: Only monochrome pictures can be combined');
  if (PixR.Height <> PixB.Height) or
     (PixR.Height <> PixG.Height) or
     (PixR.Width <> PixB.Width) or
     (PixR.Width <> PixG.Width) then
    raise Exception.Create('PixCombineChannels: pictures must be same size');

  case PixR.ColorModel of
    cgY,cgU,cgV: result:=PixSetSize(PixR.Width,PixR.Height,cgYUV);
    cgH,cgS,cgL: result:=PixSetSize(PixR.Width,PixR.Height,cgHSL);
    else         result:=PixSetSize(PixR.Width,PixR.Height,cgRGB);
  end;

  StartProgressUpdate;
  for i:=0 to length(PixR.Pixels)-1 do
  begin
    ShowProgressUpdate(i,length(PixR.Pixels)-1);
    result.Pixels[i*3+1+2]:=PixR.Pixels[i+1];
    result.Pixels[i*3+1+1]:=PixG.Pixels[i+1];
    result.Pixels[i*3+1+0]:=PixB.Pixels[i+1];
  end;
  StopProgressUpdate;
end;
             
function oldYUVtoRGB(col: TColor): TColor;
var c1: TRGBTriple absolute col;
    c2: TRGBTriple;
begin
  c2.rgbtRed  :=ByteRange(round(YUVtoRGBMatrix[0,0]*c1.rgbtRed +YUVtoRGBMatrix[0,1]*c1.rgbtGreen +YUVtoRGBMatrix[0,2]*c1.rgbtBlue+YUVtoRGBMatrix[0,3]));
  c2.rgbtGreen:=ByteRange(round(YUVtoRGBMatrix[1,0]*c1.rgbtRed +YUVtoRGBMatrix[1,1]*c1.rgbtGreen +YUVtoRGBMatrix[1,2]*c1.rgbtBlue+YUVtoRGBMatrix[1,3]));
  c2.rgbtBlue :=ByteRange(round(YUVtoRGBMatrix[2,0]*c1.rgbtRed +YUVtoRGBMatrix[2,1]*c1.rgbtGreen +YUVtoRGBMatrix[2,2]*c1.rgbtBlue+YUVtoRGBMatrix[2,3]));
  c1:=c2;
  result:=col;
end;

function oldRGBtoYUV(col: TColor): TColor;
var c1: TRGBTriple absolute col;
    c2: TRGBTriple;
begin
  c2.rgbtRed  :=ByteRange(round(RGBtoYUVMatrix[0,0]*c1.rgbtRed +RGBtoYUVMatrix[0,1]*c1.rgbtGreen +RGBtoYUVMatrix[0,2]*c1.rgbtBlue+RGBtoYUVMatrix[0,3]));
  c2.rgbtGreen:=ByteRange(round(RGBtoYUVMatrix[1,0]*c1.rgbtRed +RGBtoYUVMatrix[1,1]*c1.rgbtGreen +RGBtoYUVMatrix[1,2]*c1.rgbtBlue+RGBtoYUVMatrix[1,3]));
  c2.rgbtBlue :=ByteRange(round(RGBtoYUVMatrix[2,0]*c1.rgbtRed +RGBtoYUVMatrix[2,1]*c1.rgbtGreen +RGBtoYUVMatrix[2,2]*c1.rgbtBlue+RGBtoYUVMatrix[2,3]));
  c1:=c2;
  result:=col;
end;

function RGBtoYUV(col: TColor): TColor;
var c1: TRGBTriple absolute col;
    c2: TRGBTriple;
begin
  c2.rgbtBlue :=ByteRange(round(RGBtoYUVMatrix[0,0]*c1.rgbtBlue +RGBtoYUVMatrix[0,1]*c1.rgbtGreen +RGBtoYUVMatrix[0,2]*c1.rgbtRed+RGBtoYUVMatrix[0,3]));
  c2.rgbtGreen:=ByteRange(round(RGBtoYUVMatrix[1,0]*c1.rgbtBlue +RGBtoYUVMatrix[1,1]*c1.rgbtGreen +RGBtoYUVMatrix[1,2]*c1.rgbtRed+RGBtoYUVMatrix[1,3]));
  c2.rgbtRed  :=ByteRange(round(RGBtoYUVMatrix[2,0]*c1.rgbtBlue +RGBtoYUVMatrix[2,1]*c1.rgbtGreen +RGBtoYUVMatrix[2,2]*c1.rgbtRed+RGBtoYUVMatrix[2,3]));
  c1:=c2;
  result:=col;
end;

function YUVtoRGB(col: TColor): TColor;
var c1: TRGBTriple absolute col;
    c2: TRGBTriple;
begin
  c2.rgbtBlue :=ByteRange(round(YUVtoRGBMatrix[0,0]*c1.rgbtBlue +YUVtoRGBMatrix[0,1]*c1.rgbtGreen +YUVtoRGBMatrix[0,2]*c1.rgbtRed+YUVtoRGBMatrix[0,3]));
  c2.rgbtGreen:=ByteRange(round(YUVtoRGBMatrix[1,0]*c1.rgbtBlue +YUVtoRGBMatrix[1,1]*c1.rgbtGreen +YUVtoRGBMatrix[1,2]*c1.rgbtRed+YUVtoRGBMatrix[1,3]));
  c2.rgbtRed  :=ByteRange(round(YUVtoRGBMatrix[2,0]*c1.rgbtBlue +YUVtoRGBMatrix[2,1]*c1.rgbtGreen +YUVtoRGBMatrix[2,2]*c1.rgbtRed+YUVtoRGBMatrix[2,3]));
  c1:=c2;
  result:=col;
end;

function HSLtoRGBEx(H, S, L: Integer): TColor;
{H,S should be in the range 0..240}
{L should be in the range 0..255}
var m,n,k: Integer;
begin
  Result:=0;

  if s = 0 then
    result:=Cliprgb(L,L,L) else
  begin
    m:=L*(240-S) div 240;
    n:=L*(240-S*(h mod 40) div 40) div 240;
    k:=L*(240-S*(40-(h mod 40)) div 40) div 240;
    case h div 40 of
      0: result:=ClipRGB(L,k,m);
      1: result:=ClipRGB(n,L,m);
      2: result:=ClipRGB(m,L,k);
      3: result:=ClipRGB(m,n,L);
      4: result:=ClipRGB(k,m,L);
      5: result:=ClipRGB(L,m,n);
    end;
  end;
end;

(*
function HSLtoRGBEx(H, S, L: Integer): TColor;
{H,S,L should be in the range 0..240}
var m,n,k: Integer;
begin
  Result:=0;

  if s = 0 then
    result:=Cliprgb(L*255 div 240,L*255 div 240,L*255 div 240) else
  begin
    m:=L*(240-S) div 240;
    n:=L*(240-S*(h mod 40) div 40) div 240;
    k:=L*(240-S*(40-(h mod 40)) div 40) div 240;
    L:=L*255 div 240;
    k:=k*255 div 240;
    m:=m*255 div 240;
    n:=n*255 div 240;
    case h div 40 of
      0: result:=ClipRGB(L,k,m);
      1: result:=ClipRGB(n,L,m);
      2: result:=ClipRGB(m,L,k);
      3: result:=ClipRGB(m,n,L);
      4: result:=ClipRGB(k,m,L);
      5: result:=ClipRGB(L,m,n);
    end;
  end;
end;

*)

function HSLtoRGBExOld(H, S, L: Integer): TColor;
var
  a,d,e,f,V: Integer;
begin
  Result:=0;
  H:=IntRange(H*256 div 240,0,255);
  S:=IntRange(S*256 div 240,0,255);
  L:=IntRange(L*256 div 240,0,255);

{$R-}
  if L <= $7F then
    V:=L * (256 + S) shr 8
  else
    V:=L + S - L * S shr 8;
  if V > 0 then
  begin
    a:=V-(f);
    d:=a*((85-H)*6 and $ff) shr 8;
    e:=a*((213-H)*6 and $ff) shr 8;
    f:=L*2-V;
    case H of
      0..42:    Result:=ClipRGB(V,V-d,f);
      43..85:   Result:=ClipRGB(f+d,V,f);
      86..127:  Result:=ClipRGB(f,V,V-d);
      128..170: Result:=ClipRGB(f,f+d,V);
      171..213: Result:=ClipRGB(V-e,f,V);
      else      Result:=ClipRGB(V,f,f+e);
    end;
  end;
{$R+}
end;

function HLStoRGBEx(H, L, S: integer): TColor;
var r,g,b: single;
    OffsetLightness,OffsetSaturation: integer;
begin
  if (H < 0)  then
    H:=(240-H) mod 240 else
    H:=     H  mod 240;

  if (H <  80)  then
    R:=Min(255, 255 * (80-H)  / 40) else
  if (H > 160)  then
    R:=Min(255, 255 * (H-160) / 40);

  if (H < 160)  then
    G:=Min(255, 255 * (80-Abs(H- 80)) / 40);
  if (H >  80)  then
    B:=Min(255, 255 * (80-Abs(H-160)) / 40);

  if (S < 240) then
  begin
    r:=r* (S / 240);
    g:=g* (S / 240);
    b:=b* (S / 240);
    OffsetSaturation:=128 * (240-S) div 240;
    R:=R+OffsetSaturation;
    G:=G+OffsetSaturation;
    B:=B+OffsetSaturation;
  end;

  L:=Min(240, L);
  r:=r* ((120-Abs(L-120)) / 120);
  g:=g* ((120-Abs(L-120)) / 120);
  b:=b* ((120-Abs(L-120)) / 120);

  if (L > 120) then
  begin
    OffsetLightness:=256 * (L-120) div 120;
    R:=R+OffsetLightness;
    G:=G+OffsetLightness;
    B:=B+OffsetLightness;
  end;

  result:=ClipRGB(round(r),round(g),round(b));
end;

(*
const HLSMAX = 240;
const RGBMAX = 255;
 
 
final simulated function float HueToRGB(float n1, float n2, float hue)
{
        if ( hue < 0 ) hue += HLSMAX;
        if ( hue > HLSMAX ) hue -= HLSMAX;
 
        /* return r,g, or b value from this tridrant */
        if ( hue < (HLSMAX/6) )
                return ( n1 + (((n2-n1)*hue + (HLSMAX/12))/(HLSMAX/6)) );
        if ( hue < (HLSMAX/2) )
                return n2;
        if ( hue < ((HLSMAX*2)/3) )
                return ( n1 + (((n2-n1)*(((HLSMAX*2)/3)-hue) + (HLSMAX/12))/(HLSMAX/6)) );
        else
                return n1;
}


final simulated function Color hlsTorgb(byte hue, byte lum, byte sat)
{
        local Color C;
        local float Magic1, Magic2;
        local int R,G,B;

        if ( sat==0)
        {     /* achromatic case */
                C.R = (lum*RGBMAX) / HLSMAX;
                C.G = C.R;
                C.B = C.R;

                /* Small fix */
                R = C.R;
                G = C.G;
                B = C.B;
        }
        else
        {       /* chromatic case */
                /* set up magic numbers */
                if (lum <= (HLSMAX/2))
                        Magic2 = (lum*(HLSMAX+sat)+(HLSMAX/2)) / HLSMAX;
                else
                        Magic2 = lum+sat - ((lum*sat)+(HLSMAX/2)) / HLSMAX;
 
                Magic1 = 2*lum - Magic2;
 
                /* get RGB, change units from HLSMAX to RGBMAX */
                R = (HueToRGB(Magic1, Magic2, hue+(HLSMAX/3))
                                * RGBMAX + (HLSMAX/2)) / HLSMAX;
                G = (HueToRGB(Magic1, Magic2, hue)
                                * RGBMAX + (HLSMAX/2)) / HLSMAX;
                B = (HueToRGB(Magic1, Magic2, hue-(HLSMAX/3))
                                * RGBMAX + (HLSMAX/2)) / HLSMAX;
        }
 
        C.R = R;
        C.G = G;
        C.B = B;
        C.A = 255;
        return C;
}
*)

function Red(c: TColor): Byte;   begin result:=TRGBQuad(c).rgbRed; end;
function Green(c: TColor): Byte; begin result:=TRGBQuad(c).rgbGreen; end;
function Blue(c: TColor): Byte;  begin result:=TRGBQuad(c).rgbBlue; end;
function V(c: TColor): Byte;     begin result:=TRGBQuad(c).rgbBlue; end;
function U(c: TColor): Byte;     begin result:=TRGBQuad(c).rgbGreen; end;
function Y(c: TColor): Byte;     begin result:=TRGBQuad(c).rgbRed; end;
function H(c: TColor): Byte;     begin result:=TRGBQuad(c).rgbRed; end;
function S(c: TColor): Byte;     begin result:=TRGBQuad(c).rgbGreen; end;
function L(c: TColor): Byte;     begin result:=TRGBQuad(c).rgbBlue; end;

procedure ColToRGB(RGB: TColor; out R, G, B: Byte);
begin
  B:=(RGB shr 16) and $ff;
  G:=(RGB shr 8) and $ff;
  R:=RGB and $ff;
end;

function ColToT3Col(RGB: TColor): T3Color;
var k3: T3Color absolute RGB;
begin
  result:=k3;
end;

function T3ColToCol(c: T3Color): TColor;
var k3: T3Color absolute result;
begin
  result:=0;
  k3:=c;
end;

procedure RGBtoHSLEx(RGB: TColor; out H, S, L: Byte);
var
  bR, bG, bB: byte;
  R, G, B,D, Cmax, Cmin, HL: Integer;
begin
  ColToRGB(RGB,bR, bG, bB);

  r:=br*240 div 255;
  g:=bg*240 div 255;
  b:=bb*240 div 255;

  Cmax:=IntMax([R, G, B]);
  Cmin:=IntMin([R, G, B]);
  L:=IntRange((Cmax + Cmin) div 2,0,255{});

  if Cmax = Cmin then
  begin
    H:=0;
    S:=0
  end
  else
  begin
    D:=(Cmax - Cmin) * 240{};     
    if L <= 120 then
      S:=IntRange(D div (Cmax + Cmin),0,240)
    else
      S:=IntRange(D div (240{} * 2 - Cmax - Cmin),0,240{});

    D:=D * 6;
    if R = Cmax then
      HL:=(G - B) * 240{} * 240{} div D
    else if G = Cmax then
      HL:=240{} * 2 div 6 + (B - R) * 240{} * 240{} div D
    else
      HL:=240{} * 4 div 6 + (R - G) * 240{} * 240{} div D;

    if HL < 0 then HL:=HL + 240;
    h:=hl;
  end;
end;

(*
procedure RGBtoHSLEx(RGB: TColor; out H, S, L: Byte);
var
  R, G, B: byte;
  D, Cmax, Cmin, HL: Integer;
  cr,cg,cb: single;
begin
  ColToRGB(RGB,R, G, B);

  Cmax:=IntMax([R, G, B]);
  Cmin:=IntMin([R, G, B]);
  L:=IntRange((Cmax + Cmin) div 2,0,255);

  if Cmax = Cmin then
  begin
    H:=0;
    S:=0
  end
  else
  begin
    D:=(Cmax - Cmin) * 255;
    if L <= $7F then
      S:=IntRange(D div (Cmax + Cmin),0,255)
    else
      S:=IntRange(D div (255 * 2 - Cmax + Cmin),0,255);

    cr:=(Cmax-R)/(Cmax-Cmin);
    cG:=(Cmax-G)/(Cmax-Cmin);
    cB:=(Cmax-b)/(Cmax-Cmin);

    if R = Cmax then
      HL:=round((CB-CG)*256) else
    if G = Cmax then
      HL:=round((2+Cr-Cb)*256) else
      HL:=round((4+Cg-Cr)*256);
    if HL < 0 then
      HL:=HL+256;

    H:=IntRange(HL,0,255);
  end;
end;
*)

function RGBtoHSL(col: TColor): TColor;
var c1: TRGBTriple absolute col;
    h,s,l: byte;
//var r,g,b: byte;
begin
  RGBtoHSL2(c1.rgbtRed, c1.rgbtGreen, c1.rgbtBlue,h,s,l);
  c1.rgbtRed:=h;
  c1.rgbtGreen:=s;
  c1.rgbtBlue:=l;
  result:=col;

//  RGBtoHSLEx(col,b,g,r);
//  result:=rgb(r,g,b);
end;

function HSLtoRGB(col: TColor): TColor;
var c1: TRGBTriple absolute col;
    r,g,b: byte;
begin
  HSLtoRGB2(c1.rgbtRed, c1.rgbtGreen, c1.rgbtBlue,r,g,b);
  c1.rgbtRed:=r;
  c1.rgbtGreen:=g;
  c1.rgbtBlue:=b;
  result:=col;

//  result:=HSLtoRGBEx(c1.rgbtRed, c1.rgbtGreen, c1.rgbtBlue);
end;

function HSLtoRGBOld(col: TColor): TColor;
var c1: TRGBTriple absolute col;
begin
  result:=HSLtoRGBExOld(c1.rgbtRed, c1.rgbtGreen, c1.rgbtBlue);
end;

function PixIsMonochrome(Source: TPix): boolean;
var x,y: integer;
    p1: pChar;
begin
  with Source do
  case ColorModel of
    cgRGB,cgYUV,cgHSL:
      begin
        result:=false;
        for y:=0 to Height-1 do
        begin
          p1:=PixScanLine(Source,y);
          for x:=0 to Width-1 do
          begin
            if (p1[0] <> p1[1]) or (p1[0] <> p1[2]) then
              exit;
            inc(p1,3);
          end;
        end;
        result:=true;
      end;
    else
      result:=true;
  end;
end;

function CalculateHistogram(Pix: TPix): THistogram;
var i: integer;
    p: ^Byte;
    Depth: integer;
begin
  if Pix.Pixels <> '' then
    p:=@Pix.Pixels[1];
  StartProgressUpdate;
  fillchar(result,sizeof(result),0);
  Depth:=GetPixelDepth(Pix.ColorModel);
  for i:=1 to length(Pix.Pixels) div depth do
  begin
    inc(result[p^]);
    inc(p,depth);
  end;
  StopProgressUpdate;
end;

function CalculateHistogramChannel(Pix: TPix; ColorModel: TColorModel): THistogram;
begin
  result:=CalculateHistogram(PixConvertToColorModel(Pix,ColorModel));
end;

procedure ApplyHistogram(var Pix: TPix; eqHist: TeqHist);
var i: integer;
    p: ^Byte;
    p1,p2,p3: TPix;
begin
  assert(GetPixelDepth(Pix.ColorModel) = 1);
  p1:=Pix;

  StartProgressUpdate;

  p:=@p1.Pixels[1];
  for i:=1 to length(p1.Pixels) do
  begin
    p^:=eqHist[p^];
    inc(p);
  end;

  Pix:=p1;
  StopProgressUpdate;
end;

procedure EqualiseHistogram(var Pix: TPix);
var Histogram: THistogram;
    eqHist: TeqHist;
    i: integer;
    p: ^Byte;
    p1,p2,p3: TPix;
    Depth: integer;
    ColorModel: TColorModel;
begin
  ColorModel:=Pix.ColorModel;
  Depth:=GetPixelDepth(Pix.ColorModel);
  if depth = 1 then
    p1:=Pix else
  begin
    p1:=PixConvertToColorModel(Pix,cgY);
    p2:=PixConvertToColorModel(Pix,cgU);
    p3:=PixConvertToColorModel(Pix,cgV);
  end;

  Histogram:=CalculateHistogram(p1);

  StartProgressUpdate;

  For i:=1 to 255 do
    inc(Histogram[i],Histogram[i-1]);
  For i:=1 to 255 do
    eqHist[i]:=Histogram[i]*255 div Histogram[255];

  ApplyHistogram(p1,eqHist);

  if depth = 1 then
    Pix:=p1 else
    Pix:=PixCombineChannels(p1,p2,p3);
  StopProgressUpdate;

  Pix:=PixConvertToColorModel(Pix,ColorModel);
end;

procedure InitHistogram(var eqHist: TeqHist);
var i: integer;
begin
  for i:=0 to 255 do
    eqHist[i]:=i;
end;

procedure MirrorPix(var Pix: TPix);
var k,x,y: integer;
begin
  for y:=0 to Pix.Height-1 do
  for x:=0 to (Pix.Width-1) div 2 do
  begin
    k:=Pixel(Pix,x,y);
    PixSetPixel(Pix,x,y,Pixel(Pix,Pix.Width-1-x,y));
    PixSetPixel(Pix,Pix.Width-1-x,y,k);
  end;
end;

procedure FlipPix(var Pix: TPix);
var k,x,y: integer;
begin
assert(false,'this has not been tested');
  for y:=0 to (Pix.Height-1) div 2 do
  for x:=0 to Pix.Width-1 do
  begin
    k:=Pixel(Pix,x,y);
    PixSetPixel(Pix,x,y,Pixel(Pix,x,Pix.Height-1-y));
    PixSetPixel(Pix,x,Pix.Height-1-y,k);
  end;
end;

function NegativePix(pix: TPix): TPix;
var i: integer;
begin
  result:=PixSetSize(Pix.Width,Pix.Height,Pix.ColorModel);
  for i:=1 to length(result.Pixels) do
    result.Pixels[i]:=char(255-ord(Pix.Pixels[i]));
end;

procedure RotatePixCCW(var Pix: TPix);
var x,y: integer;
    Pix2: TPix;
begin
  Pix2:=PixSetSize(Pix.Height,Pix.Width,Pix.ColorModel);
  for y:=0 to Pix.Height-1 do
    for x:=0 to Pix.Width-1 do
      PixSetPixel(Pix2,y,x,Pixel(Pix,Pix.Width-1-x,y));
  Pix:=Pix2;
end;

procedure RotatePixCW(var Pix: TPix);
var x,y: integer;
    Pix2: TPix;
begin
  Pix2:=PixSetSize(Pix.Height,Pix.Width,Pix.ColorModel);
  for y:=0 to Pix.Height-1 do
    for x:=0 to Pix.Width-1 do
      PixSetPixel(Pix2,y,x,Pixel(Pix,x,Pix.Height-1-y));
  Pix:=Pix2;
end;

procedure RotateBitmapCW(Bitmap: TBitmap);
var pix: TPix;
    aBitmap: TBitmap;
begin
  aBitmap:=TBitmap.Create;
  pix:=BitmapToPix(Bitmap,cgRGB);
  RotatePixCW(pix);
  aBitmap:=PixToBitmap(pix);
  Bitmap.Assign(aBitmap);
  aBitmap.Free;
end;

procedure RotateBitmapCCW(Bitmap: TBitmap);
var pix: TPix;
    aBitmap: TBitmap;
begin
  aBitmap:=TBitmap.Create;
  pix:=BitmapToPix(Bitmap,cgRGB);
  RotatePixCCW(pix);
  aBitmap:=PixToBitmap(pix);
  Bitmap.Assign(aBitmap);
  aBitmap.Free;
end;

procedure SortEdges(var ScanLines: TScanLines);
var more: boolean;
    i,by: integer;
begin
  for by:=0 to high(ScanLines.e) do
  begin
    repeat
      more:=false;
      for i:=0 to high(ScanLines.e[by])-1 do
        if ScanLines.e[by][i] > ScanLines.e[by][i+1] then
        begin
          swap(ScanLines.e[by][i],ScanLines.e[by][i+1]);
          more:=true;
        end;
    until not more;
  end;
end;

function PolyToScanLines(p: array of TPoint): TScanLines;
  procedure AddLine(x1,y1,x2,y2: integer);
  var ay,by: integer;
  begin
    if y1 <> y2 then
    for by:=IntMin([y1,y2]) to IntMax([y1,y2])-1 do
    begin
      ay:=by-result.y0;
      SetLength(result.e[ay],Length(result.e[ay])+1);
      if y2 = y1 then
        result.e[ay][high(result.e[ay])]:=x1 else
        result.e[ay][high(result.e[ay])]:=round((by-y1)*(x2-x1)/(y2-y1)+x1);
    end;
  end;
var i,ymin,ymax: integer;
begin
  SetLength(result.e,0);

  SetLength(result.e,0);
  result.y0:=0;
  if length(p) = 0  then
    exit;

  ymin:=maxint;
  ymax:=-maxint;
  for i:=low(p) to high(p) do
    SetMinMax(p[i].y,ymin,ymax);

  result.y0:=ymin;
  SetLength(result.e,ymax-ymin+1);
  fillchar(result.e[0],sizeof(result.e),0);

  for i:=0 to high(p)-1 do
    AddLine(p[i].x,p[i].y,p[i+1].x,p[i+1].y);
  AddLine(p[high(p)].x,p[high(p)].y,p[0].x,p[0].y);

  SortEdges(result);
end;

function CopyScanlines(var source: TScanLines; BottomMargin,TopMargin: integer): TScanLines;
{if margin +ve then insert margin lines before the start or after the end}
var i,j: integer;
begin
  SetLength(result.e,0);
  SetLength(result.e,max(0,length(source.e)+BottomMargin+TopMargin));
  result.y0:=source.y0-BottomMargin;

  for i:=0 to high(source.e) do
  begin
    SetLength(result.e[i+BottomMargin],length(source.e[i]));
    for j:=0 to high(source.e[i]) do
      result.e[i+BottomMargin][j]:=source.e[i][j];
  end;

  result.y0:=source.y0-BottomMargin;
end;

function UnionScanlines(var scan1,scan2: TScanLines): TScanLines;
  procedure DeleteDual(var s: TScanLines; by,i: integer);
  var j: integer;
  begin
    for j:=i to high(s.e[by])-2 do
      s.e[by][j]:=s.e[by][j+2];
    SetLength(s.e[by],Length(s.e[by])-2);
  end;
var by,i,j: integer;
    scan: TScanLines;
    more: boolean;
    ymin,ymax: integer;
begin
  if length(scan1.e) = 0 then
  begin
    result:=CopyScanlines(scan2,0,0);
    exit;
  end else
  if length(scan2.e) = 0 then
  begin
    result:=CopyScanlines(scan1,0,0);
    exit;
  end;

  ymin:=min(scan1.y0,scan2.y0);
  ymax:=max(scan1.y0+length(scan1.e),scan2.y0+length(scan2.e));
//  result:=CopyScanlines(scan1,max(0,scan1.y0-scan2.y0),max(0,scan2.y0-scan1.y0));
//  scan:=CopyScanlines(scan2,max(0,scan2.y0-scan1.y0),max(0,scan1.y0-scan2.y0));
  result:=CopyScanlines(scan1,scan1.y0-ymin,ymax-(scan1.y0+length(scan1.e)));
  scan:=CopyScanlines(scan2,scan2.y0-ymin,ymax-(scan2.y0+length(scan2.e)));
//  scan:=CopyScanlines(scan2,max(0,scan2.y0-scan1.y0),max(0,scan1.y0-scan2.y0));


  for by:=low(result.e) to high(result.e) do
  begin
    repeat
      more:=false;
      for i:=high(result.e[by])-1 downto low(result.e[by]) do
      if not more then
      if not odd(i) then
      for j:=high(scan.e[by])-1 downto low(scan.e[by]) do
      if not more then
      if not odd(j) then
      if InRange(scan.e[by][j],result.e[by][i],result.e[by][i+1]-1) then
      begin
        if InRange(scan.e[by][j+1],result.e[by][i],result.e[by][i+1]) then
        begin
          DeleteDual(scan,by,j);                    {result    +----------+        +----------+        +----------+        +----------+ }
          more:=true;                               {scan          +--+            +------+                +------+        +----------+ }
        end else
        begin
          scan.e[by][j]:=result.e[by][i+1];         {result    +-------+           +-------+    }
          more:=true;                               {scan          +------+        +----------+ }
        end;
      end else
      if InRange(result.e[by][i],scan.e[by][j],scan.e[by][j+1]-1) then
      begin
        if InRange(result.e[by][i+1],scan.e[by][j],scan.e[by][j+1]) then
        begin
          DeleteDual(result,by,i);                  {result        +--+            +------+                +------+        +----------+ }
          more:=true;                               {scan      +----------+        +----------+        +----------+        +----------+ }
        end else
        begin
          result.e[by][i]:=scan.e[by][j+1];         {result        +------+        +----------+ }
          more:=true;                               {scan      +-------+           +-------+    }
        end;
      end;
    until not more;

randseed:=scan.y0;
randseed:=length(scan.e);
randseed:=result.y0;
randseed:=length(result.e);

    for j:=low(scan.e[by]) to high(scan.e[by]) do
    begin
      SetLength(result.e[by],Length(result.e[by])+1);
      result.e[by][high(result.e[by])]:=scan.e[by][j];
    end;
    scan.e[by]:=nil;
    SortEdges(result);

    for i:=high(result.e[by])-2 downto low(result.e[by]) do
      if odd(i) then
        if result.e[by][i] = result.e[by][i+1] then
          DeleteDual(result,by,i);
    if length(result.e[by]) = 1 then
      result.e[by]:=nil;
  end;
end;

procedure DrawScanLines(Canvas: TCanvas; ScanLines: TScanLines; col: TColor);
{fill ScanLines with Pen.Color}
var i,by: integer;
begin
  with Canvas do
  begin
    pen.color:=col;
    for by:=0 to high(ScanLines.e) do
      for i:=low(ScanLines.e[by]) to high(ScanLines.e[by])-1 do
        if not odd(i) then
        begin
          moveto(ScanLines.e[by][i],by+ScanLines.y0);
          Lineto(ScanLines.e[by][i+1],by+ScanLines.y0);
        end;
  end;
end;

function iff(b: boolean; x,y: single): single;
begin
  if b then result:=x else result:=y;
end;

// * Converts an HSL color value to RGB. Conversion formula
// * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
// * Assumes h, s, and l are contained in the set [0, 255] and
// * returns r, g, and b in the set [0, 255].
procedure HSLtoRGB2(h, s, l: integer; var rq,gq,bq: byte);
  function hue2rgb(p, q, t: integer): integer;
  begin
    if t < 0 then t :=t+ 255;
    if t > 255 then t :=t- 255;

    if 6*t < 255 then
      result:=p+(q-p)*6*t div 255 else
    if 2*t < 255 then
      result:=q else
    if 3*t < 255*2 then
      result:=p+(q-p)*(4*255-t*6) div 255 else
      result:=p;
  end;
var r,g,b,q,p: integer;
begin
  if(s = 0)then
  begin
    r:=l;//achromatic
    g:=l;//achromatic
    b:=l;//achromatic
  end else
  begin
    if l < 128 then
      q:=l*(255+s) div 255 else
      q:=l+s-l*s div 255;
    p:=2*l-q;
    r:=hue2rgb(p,q,h+255 div 3);
    g:=hue2rgb(p,q,h);
    b:=hue2rgb(p,q,h-255 div 3);
  end;

  rq:=ByteRange(r);
  gq:=ByteRange(g);
  bq:=ByteRange(b);
end;

///**
// * Converts an RGB color value to HSL. Conversion formula
// * adapted from http://en.wikipedia.org/wiki/HSL_color_space.
// * Assumes r, g, and b are contained in the set [0, 255] and
// * returns h, s, and l in the set [0, 255].
procedure RGBtoHSL2(r, g, b: integer; var hq, sq, lq: byte);
var h,s,l,d,max, min: integer;
begin
  max := Math.max(r, Math.max(g, b));
  min := Math.min(r, Math.min(g, b));
  l := (max + min) div 2;

  if(max = min)then
  begin
    h:=0;
    s:=0;//achromatic
  end else
  begin
    d:=max-min;
    if l > 127 then
      s:=round(255*d/(2*255-max-min)) else
      s:=round(255*d/(max+min));

    if max = r then
    begin
      if g < b then
        h:=(g-b) div d+255*6 else
        h:=(g-b) div d+0;
    end else
    if max = g then
      h:=(255*(b-r) div d+255*2) else
      h:=(255*(r-g) div d+255*4);

    h:=h div 6;
  end;

  hq:=ByteRange(round(h));
  sq:=ByteRange(s);
  lq:=ByteRange(round(l));
end;

end.


procedure ColToCYMK(a: TColor; var C,Y,M,K: byte);
begin
  K:=min(min(255-TRGBQuad(a).rgbRed,255-TRGBQuad(a).rgbGreen),255-TRGBQuad(a).rgbBlue);
  if K = 255 then
  begin
    C:=0;
    M:=0;
    Y:=0;
  end else
  begin
//    C:=round(255*(255-TRGBQuad(a).rgbRed  -K)/(255-K));
//    M:=round(255*(255-TRGBQuad(a).rgbGreen-K)/(255-K));
//    Y:=round(255*(255-TRGBQuad(a).rgbBlue -K)/(255-K));
    C:=round((255-TRGBQuad(a).rgbRed  )*(255-K)/255);
    M:=round((255-TRGBQuad(a).rgbGreen)*(255-K)/255);
    Y:=round((255-TRGBQuad(a).rgbBlue )*(255-K)/255);
//var R=Math.round((1-C)*(1-K)*255);
//var B=Math.round((1-Y)*(1-K)*255);
//var G=Math.round((1-M)*(1-K)*255);
  end;
end;

function CYMKToCol(C,Y,M,K: byte): TColor;
begin
  TRGBQuad(result).rgbRed  :=255-min(255,C*(255-K)+K);
  TRGBQuad(result).rgbGreen:=255-min(255,M*(255-K)+K);
  TRGBQuad(result).rgbBlue :=255-min(255,Y*(255-K)+K);
end;
*)

procedure ColToCYMK(a: TColor; var C,Y,M,K: byte);
begin
  C:=255-TRGBQuad(a).rgbRed;
  M:=255-TRGBQuad(a).rgbGreen;
  Y:=255-TRGBQuad(a).rgbBlue;
  K:=Min(Min(C,M),Y);
  C:=C-K;
  M:=M-K;
  Y:=Y-K;
end;

function CYMKToCol(C,Y,M,K: byte): TColor;
begin
  C:=C+K;
  M:=M+K;
  Y:=Y+K;
  TRGBQuad(result).rgbRed:=255-C;
  TRGBQuad(result).rgbGreen:=255-M;
  TRGBQuad(result).rgbBlue:=255-Y;
end;

===============================================================================================
HSL to RGB:

HSL to RGB:

