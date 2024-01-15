{_$DEFINE ASCII_output}
unit GifWrite;
     { Gif89Encoder translated from Java }
Interface
{$IFDEF ASCII_output}
uses SysUtils,Classes;
{$ELSE}
uses Classes;
{$ENDIF}


type
 inte=longint;

 pal=array[0..255,1..3] of byte;
 PPAL=^PAL;

Procedure LZWCompress( init_bits:inte; Ins, OutStream:TStream );
     //init_bits : 2-8
Function GIFwr(
 Sor,Dest       :TStream;
 BitsPixel      :inte;   //8
 xsize,ysize    :word;
 COL            :PPAL;  //pointer to color palette
 comment:shortstring;

 Transparency:boolean;
 TransparentColor:inte
 ):boolean;overload;

Function GIFwr(
 Sor,Dest       :TStream;
 BitsPixel      :inte;   //8
 xsize,ysize    :word;
 COL            :PPAL
 ):boolean;overload;


Implementation

  Procedure cl_block( OutStream:TStream );forward;
  Procedure output( code:inte; OutStream:TStream );forward;
  Procedure char_out( c:byte;OutStream:TStream);  forward;
  Procedure flush_char( OutStream:TStream );      forward;

 { // table clear for block compress{}
  const DM_UNDEFINED = 0;

  (* * The animated GIF renderer shall take no display-disposal action.
   * @see Gif89Frame#setDisposalMode
    *)
        DM_LEAVE     = 1;

  (* * The animated GIF renderer shall replace this Gif89Frame's area with the
   *  background color.
   * @see Gif89Frame#setDisposalMode
    *)
   DM_BGCOLOR   = 2;

  (* * The animated GIF renderer shall replace this Gif89Frame's area with the
   *  previous frame's bitmap.
   * @see Gif89Frame#setDisposalMode
    *)
   DM_REVERT    = 3;

{  //// Bitmap variables set in package subclass constructors ////{}
//  theWidth :inte = -1;
//  theHeight :inte = -1;

{  type
   ByteArray=array[0..1] of byte;
   PByteArray=^ByteArray;
  var
   ciPixels:PbyteArray; // byte[]{}

{  //// GIF graphic frame control options ////
//  thePosition:Tpoint;{}
 {
  isInterlaced:boolean;
  csecsDelay:inte;
  const disposalCode:int= DM_LEAVE;
  }
 { //----------------------------------------------------------------------------{}
  (* * Set the position of this frame within a larger animation display space.
   *
   * @param p
   *   Coordinates of the frame's upper left corner in the display space.
   *   (Default: The logical display's origin [0, 0])
   * @see Gif89Encoder#setLogicalDisplay
    *)

{  Procedure setPosition(P:TPoint);
  begin
    thePosition := P;
  end;{}

 { //----------------------------------------------------------------------------{}
  (* * Set or clear the interlace flag.
   *
   * @param b
   *   true if you want interlacing.  (Default: false)
    *)
{  Procedure setInterlaced(b:boolean);
  begin
    isInterlaced := b;
  end;
 }
 { //----------------------------------------------------------------------------{}
  (* * Set the between-frame interval.
   *
   * @param interval
   *   Centiseconds to wait before displaying the subsequent frame.
   *   (Default: 0)
    *)
{  Procedure setDelay(interval:int);
  begin
    csecsDelay := interval;
  end;
 }
 { //----------------------------------------------------------------------------{}
  (* * Setting this option determines (in a cooperative GIF-viewer) what will be
   *  done with this frame's display area before the subsequent frame is
   *  displayed.  For instance, a setting of DM_BGCOLOR can be used for erasure
   *  when redrawing with displacement.
   *
   * @param code
   *   One of the four int constants of the Gif89Frame.DM_* series.
   *  (Default: DM_LEAVE)
    *)
{  Procedure setDisposalMode(code:int);
  begin
    disposalCode := code;
  end;
{
  //----------------------------------------------------------------------------
  Gif89Frame() begin end;  // package-visible default constructor

  //----------------------------------------------------------------------------
  abstract Object getPixelSource();

  //----------------------------------------------------------------------------
  int getWidth() begin  return theWidth; end;

  //----------------------------------------------------------------------------
  int getHeight() begin  return theHeight; end;

  //----------------------------------------------------------------------------
  byte[] getPixelSink() begin  return ciPixels; end;

  //----------------------------------------------------------------------------

  Procedure encode(OutputStream os, boolean epluribus, int color_depth,
              int transparent_index) throws IOException
  begin
    writeGraphicControlExtension(os, epluribus, transparent_index);
    writeImageDescriptor(os);
    new GifPixelsEncoder(
      theWidth, theHeight, ciPixels, isInterlaced, color_depth
    ).encode(os);
  end;

  //----------------------------------------------------------------------------

  private Procedure writeGraphicControlExtension(os:tstream; epluribus:boolean;
                                             itransparent:inte);// throws IOException
  begin
    int transflag := itransparent = -1 ? 0 : 1;
    if (transflag = 1 || epluribus)   // using transparency or animating ?
    begin
      os.write((int) ' not ');             // GIF Extension Introducer
      os.write($f9);                  // Graphic Control Label
      os.write(4);                     // subsequent data block size
      os.write((disposalCode  shl  2) | transflag); // packed fields (1 byte)
      Put.leShort(csecsDelay, os);  // delay field (2 bytes)
      os.write(itransparent);          // transparent index field
      os.write(0);                     // block terminator
    end;
  end;

  //----------------------------------------------------------------------------
  private Procedure writeImageDescriptor(OutputStream os) throws IOException
  begin
    os.write((int) ',');                // Image Separator
    Put.leShort(thePosition.x, os);
    Put.leShort(thePosition.y, os);
    Put.leShort(theWidth, os);
    Put.leShort(theHeight, os);
    os.write(isInterlaced ? $40 : 0);  // packed fields (1 byte)
  end;
end;

//==============================================================================
class GifPixelsEncoder begin
           }
{
var
imgW, imgH:inte;
pixAry:pbyteArray;
wantInterlaced:boolean;
initCodeSize,
  // raster data navigators
     countDown,
    xCur, yCur,
    curPass:inte;

}

 { //----------------------------------------------------------------------------{}
{  GifPixelsEncoder( width, height:inte;
 pixels:PbyteArray; interlaced:boolean ; color_depth:int);
  begin
    imgW := width;
    imgH := height;
    pixAry := pixels;
    wantInterlaced := interlaced;
 //   initCodeSize := Math.max(2, color_depth);
    initCodeSize := Math.max(2, color_depth);
  end;

  //----------------------------------------------------------------------------

  Procedure encode(os:tStream);// throws IOException
  begin
    os.write(initCodeSize,2);         // write "initial code size" byte

    countDown := imgW * imgH;        // reset navigation variables
    compress(initCodeSize + 1, os); // compress and write the pixel data

    os.write(0);                    // write block terminator
  end;

  /(* ***************************************************************************
  // (J.E.) The logic of the next two methods is largely intact from
  // Jef Poskanzer.  Some stylistic changes were made for consistency sake,
  // plus the second method accesses the pixel value from a prefiltered linear
  // array.  That's about it.
  /(* *************************************************************************)

  //----------------------------------------------------------------------------
  // Bump the 'xCur' and 'yCur' to point to the next pixel.
  //----------------------------------------------------------------------------
  private Procedure bumpPosition()
  begin
    // Bump the current X position
    +1 xCur;

    // If we are at the end of a scan line, set xCur back to the beginning
    // If we are interlaced, bump the yCur to the appropriate spot,
    // otherwise, just increment it.
    if (xCur = imgW)
    begin
      xCur := 0;

      if ( not wantInterlaced)
        +1 yCur;
      else
        switch (curPass)
        begin
          case 0:
            yCur += 8;
            if (yCur >= imgH)
            begin
              +1 curPass;
              yCur := 4;
            end;
            break;
          case 1:
            yCur += 8;
            if (yCur >= imgH)
            begin
              +1 curPass;
              yCur := 2;
            end;
            break;
          case 2:
            yCur += 4;
            if (yCur >= imgH)
            begin
              +1 curPass;
              yCur := 1;
            end;
            break;
          case 3:
            yCur += 2;
            break;
        end;
    end;
  end;

  //----------------------------------------------------------------------------
  // Return the next pixel from the image
  //----------------------------------------------------------------------------
  }
   {
  //(* ***************************************************************************
  // (J.E.) I didn't touch Jef Poskanzer's code from this point on.  (Well, OK,
  // I changed the name of the sole OutStreamide method it accesses.)  I figure
  // if I have no idea how something works, I shouldn't play with it :)
  //
  // Despite its unencapsulated structure, this section is actually highly
  // self-contained.  The calling code merely calls compress(), and the present
  // code calls nextPixel() in the caller.  That's the sum total of their
  // communication.  I could have dumped it in a separate class with a callback
  // via an interface, but it didn't seem worth messing with.
  /(* ***************************************************************************

  // GIFCOMPR.C       - GIF Image compression function s
  //
  // Lempel-Ziv compression based on 'compress'.  GIF modifications by
  // David Rowley (mgardi@watdcsu.waterloo.edu)

  // General DEFINEs
 *)
 }
  const
     BITS = 12;
     HSIZE = 5003;            {    // 80% occupancy{}

 {// GIF Image compression - modified 'compress'
  //
  // Based on: compress.c - File compression ala IEEE Computer, June 1984.
  //
  // By Authors:  Spencer W. Thomas      (decvax not harpo not utah-cs not utah-gr not thomas)
  //              Jim McKie              (decvax not mcvax not jim)
  //              Steve Davies           (decvax not vax135 not petsd not peora not srd)
  //              Ken Turkowski          (decvax not decwrl not turtlevax not ken)
  //              James A. Woods         (decvax not ihnp4 not ames not jaw)
  //              Joe Orost              (decvax not vax135 not petsd not joe)
  {}
  var n_bits:inte;              // number of bits/code
  const maxbits = BITS;         // user settable max # bits/code
                                // maximum code, given n_bits
  const maxmaxcode:inte = 1  shl  BITS; {// should NEVER generate this code{}

  var  maxCode:inte;

  function MAX_CODE(n_bits:inte ):inte;
  begin
   max_code:=( 1  shl  n_bits ) - 1;
  end;

  var
  htab : array[0..HSIZE] of inte;
  codetab : array[0..HSIZE] of inte;

 { //int hsize := HSIZE;                // for dynamic table sizing{}

  var
   free_ent:inte;                       { // first unused entry{}

{  // block compression parameters -- after all codes are used up,
  // and compression rate changes, start over.{}
  var clear_flg :boolean;

{  // Algorithm:  use open addressing double hashing (no chaining) on the
  // prefix code / next character combination.  We do a variant of Knuth's
  // algorithm D (vol. 3, sec. 6.4) along with G. Knott's relatively-prime
  // secondary probe.  Here, the modular division first probe is gives way
  // to a faster exclusive-or manipulation.  Also do block compression with
  // an adaptive reset, whereby the code table is cleared when the compression
  // ratio decreases, but after the table fills.  The variable-length output
  // codes are re-sized at this point, and a special CLEAR code is generated
  // for the decompressor.  Late addition:  construct the table according to
  // file size for noticeable speed improvement on small files.  Please direct
  // questions about this implementation to ames not jaw.
 {}
var
  a_count:inte;
  g_init_bits,

  ClearCode,
  EOFCode:inte;

  cur_accum:inte;
  cur_bits :inte;

{// reset code table{}
Procedure cl_hash(hsize:inte);
var i:inte;
Begin
 for i := 0 to hsize-1
  do htab[i] := -1;
End;

Procedure LZWCompress( init_bits:inte; Ins, OutStream:TStream );
{// throws IOException{}
var
 aa,     //PETER
 fcode,
 i, (*  := 0  *)
 c,
 ent,
 disp,
 hsize_reg,
 hshift:inte;
 const EOF=-1;
 label outer_loop;

 const read_bufer_size=2048;
 var
  numRead:inte;
  Rbuf:array [1..read_bufer_size] of byte;
  rdpos:^byte;

Function NextPixel:inte;
  label ex1;
Begin

 if numRead=0 then
 begin
  NumRead:=Ins.size-Ins.position;
  if numRead > read_bufer_size then NumRead:=read_bufer_size;
  if numRead=0 then
   begin
ex1:
    c:=EOF;
    NextPixel:=c; Exit;
   end;
   Ins.Read(Rbuf,numread);// if Ins.status<>stok then goto ex1;
   RdPos:=@rbuf;
 end;

 c:=rdPos^; inc(rdPos); dec(NumRead);{}
{ c:=0; Ins^.Read(c,1); if Ins^.status<>stok then c:=EOF; }
 NextPixel:=c;
End;

Begin {LZWCompress}
  aa:=init_bits-1;         //
  OutStream.Write(aa,1);   // PETER

    numRead:=0; { set buffer index}
  cur_accum:=0;
   cur_bits:=0;
    a_count:=0; { // Set up the 'byte output'{}

{ // Set up the globals:  g_init_bits - initial number of bits{}
  g_init_bits := init_bits;

{ // Set up the necessary values{}
  clear_flg := false;
     n_bits := g_init_bits;
    maxcode := MAX_CODE( n_bits );

  ClearCode := 1  shl (init_bits - 1);
    EOFCode := ClearCode + 1;
   free_ent := ClearCode + 2;

  NextPixel;
  ent:=c;

  hshift := 0;
{// for ( fcode := hsize; fcode < 65536; fcode *= 2 )
// +1 hshift;{}
  fcode := hsize;
  while fcode < 65536 do
  begin
   fcode:=fcode*2;
   hshift:=hshift+1;
  end;

  hshift := 8 - hshift;     {  // set hash code range bound{}
  hsize_reg := hsize;
  Cl_hash( hsize_reg );     {  // clear hash table{}
  Output( ClearCode,OutStream);

outer_loop:
      while nextPixel <> EOF do
        begin
          fcode := ( c  shl  maxbits ) + ent;
          i := (c shl hshift) xor ent;{ // xor hashing{}

          if ( htab[i] = fcode )
          then
           begin
            ent := codetab[i];
            continue;
           end

          else
           if ( htab[i] >= 0 )       {   // non-empty slot{}
           then
             begin
              disp := hsize_reg - i; {   // secondary hash (after G. Knott){}
              if ( i = 0 ) then disp := 1;

              {//while ( htab[i] >= 0 );{}
              repeat{}
            {   // if ( (i -= disp) < 0 ) then  i += hsize_reg;{}
                   i:=i-disp; if i<0 then  i:=i+hsize_reg;

                  if ( htab[i] = fcode )then
                      begin
                       ent := codetab[i];
                       goto outer_loop;
                      end;
            {   end;{}
              until  ( htab[i] < 0 );{}
             { //while ( htab[i] >= 0 );{}
             end;

          Output( ent,OutStream);
          ent := c;
          if ( free_ent < maxmaxcode ) then
          begin
            codetab[i] := free_ent ; {   // code.hashtable{}
            inc(free_ent);
            htab[i] := fcode;
          end
          else  Cl_block( OutStream);
        end;
      { // Put out the final code.{}
      Output( ent,OutStream);
      Output( EOFCode, OutStream);

End;
{ // output
  //
  // Output the given code.
  // Inputs:
  //      code:   A n_bits-bit integer.  If = -1, then EOF.  This assumes
  //              that n_bits =< wordsize - 1.
  // Outputs:
  //      Outputs code to the file.
  // Assumptions:
  //      Chars are 8 bits long.
  // Algorithm:
  //      Maintain a BITS character long buffer (so that 8 codes will
  // fit in it exactly).  Use the VAX insv instruction to insert each
  // code in turn.  When the buffer fills up empty it and start over.
 {}

{const
  masks:array[0..16] of word =
   ($0000,
    $0001, $0003, $0007, $000F,
    $001F, $003F, $007F, $00FF,
    $01FF, $03FF, $07FF, $0FFF,
    $1FFF, $3FFF, $7FFF, $FFFF ); {}

{// table clear for block compress{}
Procedure cl_block( OutStream:TStream );
begin
  cl_hash( hsize );
  free_ent := ClearCode + 2;
  clear_flg := true;
  Output( ClearCode, OutStream );
end;

Procedure Output( code:inte; OutStream:TStream);
 {$IFDEF ASCII_output}
  var s:string; n:word;
Begin
{ s:=IntToStr(code,8);
  OutStream^.Write(s[1],length(s));
  n:=$0A0D; OutStream^.Write(n,2);{}
  write(stout,code,' ');
exit;
  {$ELSE}
Begin
  {$ENDIF}
     cur_accum := cur_accum and (1 shl cur_bits - 1);
   //cur_accum := cur_accum and masks[cur_bits];

      if ( cur_bits > 0 )
       then cur_accum:= cur_accum or ( code  shl  cur_bits )
       else cur_accum := code;

     cur_bits := cur_bits + n_bits;

      while ( cur_bits >= 8 ) do
          begin
           char_out( cur_accum and $ff , OutStream );
           cur_accum:=cur_accum  shr 8;
           dec(cur_bits,8);
          end;

    {  // If the next entry is going to be too big for the code size,
      // then increase it, if possible.{}
     if ( free_ent > maxcode) or clear_flg then
           if clear_flg
           then
              begin
               n_bits:=g_init_bits;
               maxcode := MAX_CODE(n_bits);
               clear_flg := false;
              end
           else
              begin
               inc(n_bits);
               if ( n_bits = maxbits )
                then maxcode := maxmaxcode
                else maxcode := MAX_CODE(n_bits);
              end;

      if ( code = EOFCode ) then
          begin  { // At EOF, write the rest of the buffer.{}
           while ( cur_bits > 0 ) do
              begin
              char_out(cur_accum and $ff , OutStream );
              cur_accum:=cur_accum  shr 8;
              dec(cur_bits,8);
              end;
            flush_char( OutStream );
          end;
  End; {//Output{}

{  // Clear out the hash table
  // GIF Specific function s
  // Number of characters so far in this 'packet'

  // Define the storage for the packet accumulator{}
  var  accum:array[-1..255] of byte;

{  // Add a character to the end of the current packet, and if it is 254
  // characters, flush the packet to disk.{}
  Procedure char_out( c:byte;OutStream:TStream);
  begin
    accum[a_count]:= c;
    inc(a_count);  if ( a_count > 254 ) then  flush_char(OutStream);{}
  end;

 { // Flush the packet to disk, and reset the accumulator{}
  Procedure flush_char( OutStream:TStream );
  Begin
    if ( a_count > 0 )
    then
      begin
        accum[-1]:=a_count;
        OutStream.Write(accum,a_count+1);
        a_count := 0;
      end;
  End;

type

  TGIFHeader = packed Record
    ghSignature: array[1..3] of Char;   { Should be 'GIF' }
    ghVersion: array[1..3] of Char;     { '87a' or '89a' }
  end;

  TScreenDescriptor = packed Record
    sdWidth: Word;
    sdHeight: Word;
    sdInfo: Byte;
    sdBackground: Byte;
    sdAspectRatio: Byte;
  end;

  TRGBColor = packed Record
    Red,
    Green,
    Blue: Byte;
  end;
  TColorTable = array[0..255] of TRGBColor;
  PColorTable = ^TColorTable;

  TImageDescriptor = packed Record
    idSeparator: Byte;                     { Always $2C (idImage) }
    idLeft: Word;
    idTop: Word;
    idWidth: Word;
    idHeight: Word;
    idInfo: Byte;
  end;


Function GIFwr(
 Sor,Dest:TStream;
 bitsPixel:inte;
 xsize,ysize:word;
 COL:PPAL
 ):boolean;
 Begin
  result:=GIFwr(Sor,Dest,bitsPixel,xsize,ysize,COL,'',false,0);
 End;



(*Function GIFwr(
 Sor,Dest:TStream;
 bitsPixel:inte;
 xsize,ysize:word;
 COL:PPAL;
 comment:string
 ):boolean;
  *)

Function GIFwr(
 Sor,Dest       :TStream;
 BitsPixel      :inte;   //8
 xsize,ysize    :word;
 COL            :PPAL;  //pointer to color palette
 comment:shortstring;
 Transparency:boolean;
 TransparentColor:inte
 ):boolean;overload;


type
 mas=array[0..255] of byte;
 pmas=^mas;

var
{BitsPixel :inte;{}
SCD: TScreenDescriptor;
IDes:TImageDescriptor;
  gh:tGifHeader;

trc:array [1..8] of byte;

Begin
 GifWr:=false;
 if (bitsPixel>8)
 or (xsize=0)
 or (ysize=0) then exit;

 with gh do
 begin
   ghSignature:='GIF';
     ghVersion:='89a';
 end;

 Dest.Write(gh,sizeOF(gh));
 with scd do
 begin
   sdWidth      :=xsize;
   sdHeight     :=ysize;
   sdInfo       :=$F0 or (bitsPixel-1) and 7;
   sdBackground :=transparentColor; // orig 0
   sdAspectRatio:=0;
 end;
 Dest.Write(SCD,sizeOf(SCD));

 BitsPixel := (scd.sdInfo And 7) + 1;
 Dest.Write(COL^,(1 shl BitsPixel)*3);

 // idExtension = $21;
 // lblComment = $FE;
  if comment<>'' then
  begin
    if length(comment)>250 then comment:=copy(comment,1,250);
    comment:=#$21 + #$FE + chr(length(comment))
     + comment + #0;
    Dest.Write(comment[1],length(comment));
  end;

 if transparency then
 begin
  trc[1]:=$21; // idExtension
  trc[2]:=$F9; // lblGraphicControl
  trc[3]:=$04; // size = 4 bytes
  trc[4]:=$01; // geUseTransparency
  trc[5]:=$00;
  trc[6]:=$00;
  trc[7]:=transparentColor;
  trc[8]:=$00;
  Dest.Write(trc,SizeOf(trc));
 end;

 with IDes do
  begin
   idSeparator  :=$2C;{// idImage{}
   idLeft       :=0;
   idTop        :=0;
   idWidth      :=XSize;
   idHeight     :=ySize;
   idInfo       :=0; {non interlaced, no transparency}
   if transparency then idInfo:=IdInfo or $01;
  end;

 Dest.Write(IDes,sizeOf(Ides));
 LZWCompress(bitsPixel+1,Sor,Dest);{}

 with IDes do
  begin
   idLeft       :=$3B00;
  end;

 Dest.Write(Ides.idLeft,2);{ write 00 3B }

 GifWr:=true;
End;

End.
