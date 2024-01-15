unit graph41;
          { RGB => indexed colors }
interface

type
 Dither_Method=(No_dither,FS_dither);
 desCol=2..256;

type
  pointer_array=array[0..1] of pointer;
  pp_array=^pointer_array;

  IMG_rec=record
   Source_lines,          { ^array of RGB_scanlines}
   Dest_lines:PP_array;   { ^array of 8bit_scanlines}
   width,height:integer;
   COL:Pointer;           {^colormap}
   desired_colors:desCol; {2..256}
   actual_number_of_colors:integer;
   method:dither_method;
  end;


Procedure IMG24_8(IMG:img_rec); //  RGB => indexed colors


(*****) Implementation (*****)

const
  HIST_C0_BITS = 6;     { bits of precision in R/B histogram }
  HIST_C1_BITS = 6;     { bits of precision in G histogram }
  HIST_C2_BITS = 6;     { bits of precision in B/R histogram }
const
  R_SCALE:integer = 2;{2}       { scale R distances by this much }
  G_SCALE:integer = 3;{3}       { scale G distances by this much }
  B_SCALE:integer = 1;{1}       { and B by this much }

{ Relabel R/G/B as components 0/1/2, respecting the RGB ordering defined
  in jmorecfg.h.  As the code stands, it will do the right thing for R,G,B
  and B,G,R orders.  If you define some other weird order in jmorecfg.h,
  you'll get compile errors until you extend this logic.  In that case
  you'll probably want to tweak the histogram sizes too. }

//Peter's REMARK: If IMG.desired_colors < 32 then R_G_B_scale=1;
//See Main procedure
var
  C0_SCALE:integer;
  C1_SCALE:integer;
  C2_SCALE:integer;




type
  JSAMPLE=byte;                      { Nomssi }
   UINT16=integer;

  RGBptr = ^RGBtype;
  RGBtype = packed record
  r,g,b : JSAMPLE;
  end;

const maxw=1;
type
 RGB_scanline=array[0..maxW] of RGBtype;
 RGB_scanline_ptr=^RGB_scanLine;
 RGB_scanlines=array[0..maxw] of RGB_scanLine_ptr;
 RGB_scanlines_ptr=^RGB_scanlines;

 B_scanLine=array[0..maxw] of JSAMPLE;
 B_scanLine_ptr=^B_scanLine;
 B_scanlines=array[0..maxw] of B_scanline_ptr;
 B_scanlines_ptr=^B_scanlines;


type
  histcell = UINT16;  {word}
             { histogram cell; prefer an unsigned type }

  { Number of elements along histogram axes. }
const
  BITS_IN_JSAMPLE=8;
  CENTERJSAMPLE=128;


  HIST_C0_ELEMS = (1 shl HIST_C0_BITS);
  HIST_C1_ELEMS = (1 shl HIST_C1_BITS);
  HIST_C2_ELEMS = (1 shl HIST_C2_BITS);
const
  C0_SHIFT = (BITS_IN_JSAMPLE-HIST_C0_BITS);
  C1_SHIFT = (BITS_IN_JSAMPLE-HIST_C1_BITS);
  C2_SHIFT = (BITS_IN_JSAMPLE-HIST_C2_BITS);


type
  histptr = ^histcell {FAR};       { for pointers to histogram cells }

type

  hist1d = array[0..HIST_C2_ELEMS-1] of histcell; { typedefs for the array }
  {hist1d_ptr = ^hist1d;}
  hist1d_field = array[0..HIST_C1_ELEMS-1] of hist1d;
                                  { type for the 2nd-level pointers }
  hist2d = ^hist1d_field;
  hist2d_field = array[0..HIST_C0_ELEMS-1] of hist2d;
//  hist3d = ^hist2d_field;	  { type for top-level pointer }

(*          only for Delphi available!
  hist3D = array[
  0..HIST_C0_ELEMS-1,
  0..HIST_C1_ELEMS-1,
  0..HIST_C2_ELEMS-1] of histcell;
*)

//  hist3d_ptr=^hist3D;

    hist3d_ptr = ^hist2d_field;

type
   int = longint;
 int32 = longint;
  long = longint;

  box = record
  { The bounds of the box (inclusive); expressed as histogram indexes }
    c0min, c0max : int;
    c1min, c1max : int;
    c2min, c2max : int;
    { The volume (actually 2-norm) of the box }
    volume : INT32;
    { The number of nonzero histogram cells within this box }
    colorcount : long;
  end;

type
  jBoxList = 0..(MaxInt div SizeOf(box))-1;
  box_field = array[jBoxlist] of box;
  boxlistptr = ^box_field;
  boxptr = ^box;


Procedure ClearHistogram(histogram:hist3d_ptr); // Peter
var i:integer;
const size= HIST_C1_ELEMS*HIST_C2_ELEMS * SIZEOF(histcell);
Begin
  for i:=0 to pred(HIST_C0_ELEMS) do
   FillChar(histogram^[i]^,size,#0);   //clear histogram
End;


Function Prescan_quant(IMG:img_rec; hist:hist3D_ptr):INT32;
 var
  i,x,y,
  num_rows,
  width:integer;
  ptr:RGBptr;
  histp:histptr;
  sum:int32;

Begin

     width:=img.width;
  num_rows:=img.height;

  ClearHistogram(hist);

  for y := 0 to pred(num_rows) do
  begin
    {$R-}
    ptr :=RGBptr(rgb_scanlines_ptr(Img.Source_lines)^[y]);
    {$R+}
    for x := 1 to width do
    begin
     { get pixel value and index into the histogram }

      histp :=@hist^[JSAMPLE(ptr^.r) shr C0_SHIFT]^
                    [JSAMPLE(ptr^.g) shr C1_SHIFT]
		    [JSAMPLE(ptr^.b) shr C2_SHIFT];

     { increment, check for overflow and undo increment if so. }
      Inc(histp^); if (histp^ = 0) then Dec(histp^);
      Inc(ptr);
    end;
  end; //for y

   sum:=0;    //compute unique colours
  for i:=0 to HIST_C0_ELEMS-1 do
   for y:=0 to HIST_C1_ELEMS-1 do
    for x:=0 to HIST_C2_ELEMS-1 do
      if  hist^[i]^ [y][x]<>0 then
       inc(sum);

  result:=sum; // color numbers
End;

Procedure IMG24_8(IMG:img_rec);

var
 hist:hist3D_ptr;
 colormap:array[0..2,0..255] of byte;
 actual_number_of_colors :integer;

{LOCAL}
 function find_biggest_color_pop (boxlist : boxlistptr; numboxes : int) : boxptr;
{ Find the splittable box with the largest color population }
{ Returns NIL if no splittable boxes remain }
var
   boxp : boxptr ; {register}
      i : int;     {register}
   maxc : long;    {register}
  which : boxptr;
Begin
  which := NIL;
  boxp := @(boxlist^[0]);
  maxc := 0;
  for i := 0 to pred(numboxes) do
  begin
    if (boxp^.colorcount > maxc) and (boxp^.volume > 0) then
    begin
      which := boxp;
      maxc := boxp^.colorcount;
    end;
    Inc(boxp);
  end;
  find_biggest_color_pop := which;
End;


{LOCAL}
 function find_biggest_volume (boxlist : boxlistptr; numboxes : int) : boxptr;
{ Find the splittable box with the largest (scaled) volume }
{ Returns NULL if no splittable boxes remain }
var
  {register} boxp : boxptr;
  {register} i : int;
  {register} maxv : INT32;
  which : boxptr;
Begin
  maxv := 0;
  which := NIL;
  boxp := @(boxlist[0]);
  for i := 0 to pred(numboxes) do
  begin
    if (boxp^.volume > maxv) then
    begin
      which := boxp;
      maxv := boxp^.volume;
    end;
    Inc(boxp);
  end;
  find_biggest_volume := which;
End;


{LOCAL}
 procedure update_box ( var boxp : box);
label
  have_c0min, have_c0max,
  have_c1min, have_c1max,
  have_c2min, have_c2max;
{ Shrink the min/max bounds of a box to enclose only nonzero elements, }
{ and recompute its volume and population }
var
//  cquantize : my_cquantize_ptr;
//  histogram : hist3d_ptr;
  histp : histptr;
  c0,c1,c2 : int;
  c0min,c0max,c1min,c1max,c2min,c2max : int;
  dist0,dist1,dist2 : INT32;
  ccount : long;
Begin
 // cquantize := my_cquantize_ptr(cinfo^.cquantize);
//  histogram := hist;

  c0min := boxp.c0min;  c0max := boxp.c0max;
  c1min := boxp.c1min;  c1max := boxp.c1max;
  c2min := boxp.c2min;  c2max := boxp.c2max;

  if (c0max > c0min) then
    for c0 := c0min to c0max do
      for c1 := c1min to c1max do
      begin
	histp := @(hist^[c0][c1][c2min]);
	for c2 := c2min to c2max do
        begin
	  if (histp^ <> 0) then
          begin
            c0min := c0;
	    boxp.c0min := c0min;
	    goto have_c0min;
	  end;
          Inc(histp);
        end;
      end;
 have_c0min:
  if (c0max > c0min) then
    for c0 := c0max downto c0min do
      for c1 := c1min to c1max do
      begin
	histp := @(hist^[c0][c1][c2min]);
	for c2 := c2min to c2max do
        begin
	  if ( histp^ <> 0) then
          begin
            c0max := c0;
	    boxp.c0max := c0;
	    goto have_c0max;
	  end;
          Inc(histp);
        end;
      end;
 have_c0max:
  if (c1max > c1min) then
    for c1 := c1min to c1max do
      for c0 := c0min to c0max do
      begin
	histp := @(hist^[c0][c1][c2min]);
	for c2 := c2min to c2max do
        begin
	  if (histp^ <> 0) then
          begin
            c1min := c1;
	    boxp.c1min := c1;
	    goto have_c1min;
	  end;
          Inc(histp);
        end;
      end;
 have_c1min:
  if (c1max > c1min) then
    for c1 := c1max downto c1min do
      for c0 := c0min to c0max do
      begin
	histp := @(hist^[c0,c1,c2min]);
	for c2 := c2min to c2max do
        begin
	  if (histp^ <> 0) then
          begin
            c1max := c1;
	    boxp.c1max := c1;
	    goto have_c1max;
	  end;
          Inc(histp);
        end;
      end;
 have_c1max:
  if (c2max > c2min) then
    for c2 := c2min to c2max do
      for c0 := c0min to c0max do
      begin
	histp := @(hist^[c0][c1min][c2]);
	for c1 := c1min to c1max do
        begin
	  if (histp^ <> 0) then
          begin
	    c2min := c2;
	    boxp.c2min := c2min;
	    goto have_c2min;
	  end;
          Inc(histp, HIST_C2_ELEMS);
        end;
      end;
 have_c2min:
  if (c2max > c2min) then
    for c2 := c2max downto c2min do
      for c0 := c0min to c0max do
      begin
	histp := @(hist^[c0][c1min][c2]);
	for c1 := c1min to c1max do
        begin
	  if (histp^ <> 0) then
          begin
	    c2max := c2;
	    boxp.c2max := c2max;
	    goto have_c2max;
	  end;
          Inc(histp, HIST_C2_ELEMS);
        end;
      end;
 have_c2max:

  { Update box volume.
    We use 2-norm rather than real volume here; this biases the method
    against making long narrow boxes, and it has the side benefit that
    a box is splittable iff norm > 0.
    Since the differences are expressed in histogram-cell units,
    we have to shift back to JSAMPLE units to get consistent distances;
    after which, we scale according to the selected distance scale factors.}

  dist0 := ((c0max - c0min) shl C0_SHIFT) * C0_SCALE;
  dist1 := ((c1max - c1min) shl C1_SHIFT) * C1_SCALE;
  dist2 := ((c2max - c2min) shl C2_SHIFT) * C2_SCALE;
  boxp.volume := dist0*dist0 + dist1*dist1 + dist2*dist2;

  { Now scan remaining volume of box and compute population }
  ccount := 0;
  for c0 := c0min to c0max do
    for c1 := c1min to c1max do
    begin
      histp := @(hist^[c0,c1,c2min]);
      for c2 := c2min to c2max do
      begin
	if (histp^ <> 0) then
	  Inc(ccount);
        Inc(histp);
      end;
    end;
  boxp.colorcount := ccount;
End;


{LOCAL}
 function median_cut ( boxlist : boxlistptr;
                     numboxes : int; desired_colors : int) : int;
{ Repeatedly select and split the largest box until we have enough boxes }
var
  n,lb : int;
  c0,c1,c2,cmax : int;
  {register} b1,b2 : boxptr;
Begin
  while (numboxes < desired_colors) do
  begin
   { Select box to split.
     Current algorithm: by population for first half, then by volume. }

     if (numboxes*2 <= desired_colors)
     then b1 := find_biggest_color_pop(boxlist, numboxes)
     else b1 := find_biggest_volume(boxlist, numboxes);


    if (b1 = NIL) then          { no splittable boxes left! }
      break;
    b2 := @(boxlist^[numboxes]);	{ where new box will go }
    { Copy the color bounds to the new box. }
    b2^.c0max := b1^.c0max; b2^.c1max := b1^.c1max; b2^.c2max := b1^.c2max;
    b2^.c0min := b1^.c0min; b2^.c1min := b1^.c1min; b2^.c2min := b1^.c2min;
    { Choose which axis to split the box on.
      Current algorithm: longest scaled axis.
      See notes in update_box about scaling distances. }

    c0 := ((b1^.c0max - b1^.c0min) shl C0_SHIFT) * C0_SCALE;
    c1 := ((b1^.c1max - b1^.c1min) shl C1_SHIFT) * C1_SCALE;
    c2 := ((b1^.c2max - b1^.c2min) shl C2_SHIFT) * C2_SCALE;
    { We want to break any ties in favor of green, then red, blue last.
      This code does the right thing for R,G,B or B,G,R color orders only. }

{$ifdef RGB_RED_IS_0}
    cmax := c1; n := 1;
    if (c0 > cmax) then
    begin
      cmax := c0;
      n := 0;
    end;
    if (c2 > cmax) then
      n := 2;
{$else}
    cmax := c1;
    n := 1;
    if (c2 > cmax) then
    begin
      cmax := c2;
      n := 2;
    end;
    if (c0 > cmax) then
      n := 0;
{$endif}
    { Choose split point along selected axis, and update box bounds.
      Current algorithm: split at halfway point.
      (Since the box has been shrunk to minimum volume,
      any split will produce two nonempty subboxes.)
      Note that lb value is max for lower box, so must be < old max. }

    case n of
    0:begin
        lb := (b1^.c0max + b1^.c0min) div 2;
        b1^.c0max := lb;
        b2^.c0min := lb+1;
      end;
    1:begin
        lb := (b1^.c1max + b1^.c1min) div 2;
        b1^.c1max := lb;
        b2^.c1min := lb+1;
      end;
    2:begin
        lb := (b1^.c2max + b1^.c2min) div 2;
        b1^.c2max := lb;
        b2^.c2min := lb+1;
      end;
    end;
    { Update stats for boxes }
    update_box( b1^);
    update_box( b2^);
    Inc(numboxes);
  end;
  median_cut := numboxes;
End;






{LOCAL}
 procedure compute_color ( const boxp : box; icolor : int);
{ Compute representative color for a box, put it in colormap[icolor] }
var
  { Current algorithm: mean weighted by pixels (not colors) }
  { Note it is important to get the rounding correct! }
//  cquantize : my_cquantize_ptr;
//  histogram : hist3d_ptr;
  histp : histptr;
  c0,c1,c2 : int;
  c0min,c0max,c1min,c1max,c2min,c2max : int;
  count : long;
  total : long;
  c0total : long;
  c1total : long;
  c2total : long;
Begin  //compute_color
//cquantize := my_cquantize_ptr(cinfo^.cquantize);
//  histogram := hist;
  total := 0;
  c0total := 0;
  c1total := 0;
  c2total := 0;

  c0min := boxp.c0min;  c0max := boxp.c0max;
  c1min := boxp.c1min;  c1max := boxp.c1max;
  c2min := boxp.c2min;  c2max := boxp.c2max;

  for c0 := c0min to c0max do
    for c1 := c1min to c1max do
    begin
      histp := @(hist^[c0,c1,c2min]);
      for c2 := c2min to c2max do
      begin
	count := histp^;
        Inc(histp);
	if (count <> 0) then
        begin
	  Inc(total, count);
	  Inc(c0total, ((c0 shl C0_SHIFT) + ((1 shl C0_SHIFT) shr 1)) * count);
	  Inc(c1total, ((c1 shl C1_SHIFT) + ((1 shl C1_SHIFT) shr 1)) * count);
	  Inc(c2total, ((c2 shl C2_SHIFT) + ((1 shl C2_SHIFT) shr 1)) * count);
	end;
      end;
    end;

  colormap[0][icolor] := JSAMPLE ((c0total + (total shr 1)) div total);
  colormap[1][icolor] := JSAMPLE ((c1total + (total shr 1)) div total);
  colormap[2][icolor] := JSAMPLE ((c2total + (total shr 1)) div total);

End; //compute_color


{LOCAL}
 procedure compute_color_Peter( const boxp : box; icolor : int);
{ Compute representative color for a box, put it in colormap[icolor] }
var
  c0min,c0max,
  c1min,c1max,
  c2min,c2max : int;
Begin  //compute_color_Peter

  c0min := boxp.c0min;  c0max := boxp.c0max;
  c1min := boxp.c1min;  c1max := boxp.c1max;
  c2min := boxp.c2min;  c2max := boxp.c2max;

  colormap[0][icolor] := JSAMPLE (((c0min+c0max) shl c0_Shift)div 2);
  colormap[1][icolor] := JSAMPLE (((c1min+c1max) shl c1_Shift)div 2);
  colormap[2][icolor] := JSAMPLE (((c2min+c2max) shl c2_Shift)div 2);

End; //compute_color_Peter



{LOCAL}
 procedure select_colors (desired_colors : int);
{ Master routine for color selection }
 const MAXJSAMPLE = 255;
var
  boxlist : boxlistptr;
  numboxes : int;
  i : int;
  boxMem:integer;
Begin
  { Allocate workspace for box list }
//  boxlist := boxlistptr(cinfo^.mem^.alloc_small(
//  j_common_ptr(cinfo), JPOOL_IMAGE, desired_colors * SIZEOF(box)));

 case desired_colors of
       0,1: desired_colors:=2;
    2..256: begin end;
       else desired_colors:=256;
  end;

 boxMem:=desired_colors * SIZEOF(box);
 GetMem(boxlist,boxMem); FillChar(boxlist^,boxmem,#0);

 try
  {Initialize one box containing whole space }
  numboxes := 1;
  boxlist[0].c0min := 0;
  boxlist[0].c0max := MAXJSAMPLE shr C0_SHIFT;
  boxlist[0].c1min := 0;
  boxlist[0].c1max := MAXJSAMPLE shr C1_SHIFT;
  boxlist[0].c2min := 0;
  boxlist[0].c2max := MAXJSAMPLE shr C2_SHIFT;

  { Shrink it to actually-used volume and set its statistics }
  Update_box( boxlist^[0]);

  { Perform median-cut to produce final box list }
  numboxes := Median_cut( boxlist, numboxes, desired_colors);


 if desired_colors<32//Peter
   then  for i := 0 to pred(numboxes) do Compute_color_Peter(boxlist[i], i)
   else


  { Compute the representative color for each box, fill colormap }
  for i := 0 to pred(numboxes) do
    Compute_color( boxlist[i], i);

  actual_number_of_colors := numboxes;
 finally
 FreeMem(boxlist,boxmem);
 end;

// TRACEMS1(j_common_ptr(cinfo), 1, JTRC_QUANT_SELECTED, numboxes);
End;//select_colors

type
  jTSample = 0..(MaxInt div SIZEOF(JSAMPLE))-1;
  JSAMPLE_ARRAY = Array[jTSample] of JSAMPLE;  {far}
  JSAMPROW = ^JSAMPLE_ARRAY;  { ptr to one image row of pixel samples. }

  jTRow = 0..(MaxInt div SIZEOF(JSAMPROW))-1;
  JSAMPROW_ARRAY = Array[jTRow] of JSAMPROW;
  JSAMPARRAY = ^JSAMPROW_ARRAY;  { ptr to some rows (a 2-D sample array) }

  JDIMENSION=cardinal;

  JSAMPLE_PTR = ^JSAMPLE;
  GETJSAMPLE=byte;

  INT32=LONGINT;
  INT32PTR=^INT32;


const
  MAXJSAMPLE=255;
  MAXNUMCOLORS=(MAXJSAMPLE+1);        { maximum size of colormap }

  BOX_C0_LOG = (HIST_C0_BITS-3);
  BOX_C1_LOG = (HIST_C1_BITS-3);
  BOX_C2_LOG = (HIST_C2_BITS-3);

  BOX_C0_ELEMS = (1 shl BOX_C0_LOG); { # of hist cells in update box }
  BOX_C1_ELEMS = (1 shl BOX_C1_LOG);
  BOX_C2_ELEMS = (1 shl BOX_C2_LOG);

  BOX_C0_SHIFT = (C0_SHIFT + BOX_C0_LOG);
  BOX_C1_SHIFT = (C1_SHIFT + BOX_C1_LOG);
  BOX_C2_SHIFT = (C2_SHIFT + BOX_C2_LOG);

{LOCAL}
function find_nearby_colors ( minc0 : int; minc1 : int; minc2 : int;
		             var colorlist : array of JSAMPLE) : int;
{ Locate the colormap entries close enough to an update box to be candidates
  for the nearest entry to some cell(s) in the update box.  The update box
  is specified by the center coordinates of its first cell.  The number of
  candidate colormap entries is returned, and their colormap indexes are
  placed in colorlist[].
  This routine uses Heckbert's "locally sorted search" criterion to select
  the colors that need further consideration. }

var
  numcolors : int;
  maxc0, maxc1, maxc2 : int;
  centerc0, centerc1, centerc2 : int;
  i, x, ncolors : int;
  minmaxdist, min_dist, max_dist, tdist : INT32;
  mindist : array[0..MAXNUMCOLORS-1] of INT32;
  	{ min distance to colormap entry i }
Begin
  numcolors := actual_number_of_colors;

  { Compute true coordinates of update box's upper corner and center.
    Actually we compute the coordinates of the center of the upper-corner
    histogram cell, which are the upper bounds of the volume we care about.
    Note that since ">>" rounds down, the "center" values may be closer to
    min than to max; hence comparisons to them must be "<=", not "<". }

  maxc0 := minc0 + ((1 shl BOX_C0_SHIFT) - (1 shl C0_SHIFT));
  centerc0 := (minc0 + maxc0) shr 1;
  maxc1 := minc1 + ((1 shl BOX_C1_SHIFT) - (1 shl C1_SHIFT));
  centerc1 := (minc1 + maxc1) shr 1;
  maxc2 := minc2 + ((1 shl BOX_C2_SHIFT) - (1 shl C2_SHIFT));
  centerc2 := (minc2 + maxc2) shr 1;

  { For each color in colormap, find:
     1. its minimum squared-distance to any point in the update box
        (zero if color is within update box);
     2. its maximum squared-distance to any point in the update box.
    Both of these can be found by considering only the corners of the box.
    We save the minimum distance for each color in mindist[];
    only the smallest maximum distance is of interest. }

  minmaxdist := long($7FFFFFFF);

  for i := 0 to pred(numcolors) do
  begin
    { We compute the squared-c0-distance term, then add in the other two. }
    x := GETJSAMPLE(colormap[0][i]);
    if (x < minc0) then
    begin
      tdist := (x - minc0) * C0_SCALE;
      min_dist := tdist*tdist;
      tdist := (x - maxc0) * C0_SCALE;
      max_dist := tdist*tdist;
    end
    else
      if (x > maxc0) then
      begin
        tdist := (x - maxc0) * C0_SCALE;
        min_dist := tdist*tdist;
        tdist := (x - minc0) * C0_SCALE;
        max_dist := tdist*tdist;
      end
      else
      begin
        { within cell range so no contribution to min_dist }
        min_dist := 0;
        if (x <= centerc0) then
        begin
          tdist := (x - maxc0) * C0_SCALE;
          max_dist := tdist*tdist;
        end
        else
        begin
          tdist := (x - minc0) * C0_SCALE;
          max_dist := tdist*tdist;
        end;
      end;

    x := GETJSAMPLE(colormap[1][i]);
    if (x < minc1) then
    begin
      tdist := (x - minc1) * C1_SCALE;
      Inc(min_dist, tdist*tdist);
      tdist := (x - maxc1) * C1_SCALE;
      Inc(max_dist, tdist*tdist);
    end
    else
      if (x > maxc1) then
      begin
        tdist := (x - maxc1) * C1_SCALE;
        Inc(min_dist, tdist*tdist);
        tdist := (x - minc1) * C1_SCALE;
        Inc(max_dist, tdist*tdist);
      end
      else
      begin
        { within cell range so no contribution to min_dist }
        if (x <= centerc1) then
        begin
	  tdist := (x - maxc1) * C1_SCALE;
	  Inc(max_dist, tdist*tdist);
        end
        else
        begin
	  tdist := (x - minc1) * C1_SCALE;
	  Inc(max_dist, tdist*tdist);
        end
      end;

    x := GETJSAMPLE(colormap[2][i]);
    if (x < minc2) then
    begin
      tdist := (x - minc2) * C2_SCALE;
      Inc(min_dist, tdist*tdist);
      tdist := (x - maxc2) * C2_SCALE;
      Inc(max_dist, tdist*tdist);
    end
    else
      if (x > maxc2) then
      begin
        tdist := (x - maxc2) * C2_SCALE;
        Inc(min_dist, tdist*tdist);
        tdist := (x - minc2) * C2_SCALE;
        Inc(max_dist, tdist*tdist);
      end
      else
      begin
        { within cell range so no contribution to min_dist }
        if (x <= centerc2) then
        begin
	  tdist := (x - maxc2) * C2_SCALE;
	  Inc(max_dist, tdist*tdist);
        end
        else
        begin
	  tdist := (x - minc2) * C2_SCALE;
	  Inc(max_dist, tdist*tdist);
        end;
      end;

    mindist[i] := min_dist;	{ save away the results }
    if (max_dist < minmaxdist) then
      minmaxdist := max_dist;
  end;

  { Now we know that no cell in the update box is more than minmaxdist
    away from some colormap entry.  Therefore, only colors that are
    within minmaxdist of some part of the box need be considered. }

  ncolors := 0;
  for i := 0 to pred(numcolors) do
  begin
    if (mindist[i] <= minmaxdist) then
    begin
      colorlist[ncolors] := JSAMPLE(i);
      Inc(ncolors);
    end;
  end;
  find_nearby_colors := ncolors;
End;


{LOCAL}
 procedure find_best_colors (
                            minc0 : int; minc1 : int; minc2 : int;
                            numcolors : int;
                            var colorlist : array of JSAMPLE;
                            var bestcolor : array of JSAMPLE);
{ Find the closest colormap entry for each cell in the update box,
  given the list of candidate colors prepared by find_nearby_colors.
  Return the indexes of the closest entries in the bestcolor[] array.
  This routine uses Thomas' incremental distance calculation method to
  find the distance from a colormap entry to successive cells in the box. }
var
  STEP_C0,
  STEP_C1,
  STEP_C2:integer;


var
  ic0, ic1, ic2 : int;
  i, icolor : int;
  {register} bptr : INT32PTR;   { pointer into bestdist[] array }
  cptr : JSAMPLE_PTR;           { pointer into bestcolor[] array }
  dist0, dist1 : INT32;         { initial distance values }
  {register} dist2 : INT32;	{ current distance in inner loop }
  xx0, xx1 : INT32;             { distance increments }
  {register} xx2 : INT32;
  inc0, inc1, inc2 : INT32;	{ initial values for increments }
  { This array holds the distance to the nearest-so-far color for each cell }
  bestdist : array[0..BOX_C0_ELEMS * BOX_C1_ELEMS * BOX_C2_ELEMS-1] of INT32;
begin
  { Nominal steps between cell centers ("x" in Thomas article) }
  STEP_C0 := ((1 shl C0_SHIFT) * C0_SCALE);
  STEP_C1 := ((1 shl C1_SHIFT) * C1_SCALE);
  STEP_C2 := ((1 shl C2_SHIFT) * C2_SCALE);

  { Initialize best-distance for each cell of the update box }
  for i := BOX_C0_ELEMS*BOX_C1_ELEMS*BOX_C2_ELEMS-1 downto 0 do
    bestdist[i] := $7FFFFFFF;

  { For each color selected by find_nearby_colors,
    compute its distance to the center of each cell in the box.
    If that's less than best-so-far, update best distance and color number. }



  for i := 0 to pred(numcolors) do
  begin
    icolor := GETJSAMPLE(colorlist[i]);
    { Compute (square of) distance from minc0/c1/c2 to this color }
    inc0 := (minc0 - GETJSAMPLE(colormap[0][icolor])) * C0_SCALE;
    dist0 := inc0*inc0;
    inc1 := (minc1 - GETJSAMPLE(colormap[1][icolor])) * C1_SCALE;
    Inc(dist0, inc1*inc1);
    inc2 := (minc2 - GETJSAMPLE(colormap[2][icolor])) * C2_SCALE;
    Inc(dist0, inc2*inc2);
    { Form the initial difference increments }
    inc0 := inc0 * (2 * STEP_C0) + STEP_C0 * STEP_C0;
    inc1 := inc1 * (2 * STEP_C1) + STEP_C1 * STEP_C1;
    inc2 := inc2 * (2 * STEP_C2) + STEP_C2 * STEP_C2;
    { Now loop over all cells in box, updating distance per Thomas method }
    bptr := @bestdist[0];
    cptr := @bestcolor[0];
    xx0 := inc0;
    for ic0 := BOX_C0_ELEMS-1 downto 0 do
    begin
      dist1 := dist0;
      xx1 := inc1;
      for ic1 := BOX_C1_ELEMS-1 downto 0 do
      begin
	dist2 := dist1;
	xx2 := inc2;
	for ic2 := BOX_C2_ELEMS-1 downto 0 do
        begin
	  if (dist2 < bptr^) then
          begin
	    bptr^ := dist2;
	    cptr^ := JSAMPLE (icolor);
	  end;
	  Inc(dist2, xx2);
	  Inc(xx2, 2 * STEP_C2 * STEP_C2);
	  Inc(bptr);
	  Inc(cptr);
	end;
	Inc(dist1, xx1);
	Inc(xx1, 2 * STEP_C1 * STEP_C1);
      end;
      Inc(dist0, xx0);
      Inc(xx0, 2 * STEP_C0 * STEP_C0);
    end;
  end;
End;


{LOCAL}
procedure fill_inverse_cmap (c0 : int; c1 : int; c2 : int);
{ Fill the inverse-colormap entries in the update box that contains }
{ histogram cell c0/c1/c2.  (Only that one cell MUST be filled, but }
{ we can fill as many others as we wish.) }
var
 // cquantize : my_cquantize_ptr;
  histogram : hist3d_ptr;
  minc0, minc1, minc2 : int;    { lower left corner of update box }
  ic0, ic1, ic2 : int;
  {register} cptr : JSAMPLE_PTR;	{ pointer into bestcolor[] array }
  {register} cachep : histptr;	{ pointer into main cache array }
  { This array lists the candidate colormap indexes. }
  colorlist : array[0..MAXNUMCOLORS-1] of JSAMPLE;
  numcolors : int;		{ number of candidate colors }
  { This array holds the actually closest colormap index for each cell. }
  bestcolor : array[0..BOX_C0_ELEMS * BOX_C1_ELEMS * BOX_C2_ELEMS-1] of JSAMPLE;
Begin
 // cquantize := my_cquantize_ptr (cinfo^.cquantize);
  histogram := hist;

  { Convert cell coordinates to update box ID }
  c0 := c0 shr BOX_C0_LOG;
  c1 := c1 shr BOX_C1_LOG;
  c2 := c2 shr BOX_C2_LOG;

  { Compute true coordinates of update box's origin corner.
    Actually we compute the coordinates of the center of the corner
    histogram cell, which are the lower bounds of the volume we care about.}

  minc0 := (c0 shl BOX_C0_SHIFT) + ((1 shl C0_SHIFT) shr 1);
  minc1 := (c1 shl BOX_C1_SHIFT) + ((1 shl C1_SHIFT) shr 1);
  minc2 := (c2 shl BOX_C2_SHIFT) + ((1 shl C2_SHIFT) shr 1);

  { Determine which colormap entries are close enough to be candidates
    for the nearest entry to some cell in the update box. }

  numcolors := Find_nearby_colors( minc0, minc1, minc2, colorlist);

  { Determine the actually nearest colors. }
  Find_best_colors( minc0, minc1, minc2, numcolors, colorlist,
		   bestcolor);

  { Save the best color numbers (plus 1) in the main cache array }
  c0 := c0 shl BOX_C0_LOG;		{ convert ID back to base cell indexes }
  c1 := c1 shl BOX_C1_LOG;
  c2 := c2 shl BOX_C2_LOG;
  cptr := @(bestcolor[0]);
  for ic0 := 0 to pred(BOX_C0_ELEMS) do
    for ic1 := 0 to pred(BOX_C1_ELEMS) do
    begin
      cachep := @(histogram^[c0+ic0]^[c1+ic1][c2]);
      for ic2 := 0 to pred(BOX_C2_ELEMS) do
      begin
	cachep^ := histcell (GETJSAMPLE(cptr^) + 1);
        Inc(cachep);
        Inc(cptr);
      end;
    end;
End;




 function NearCOLOR(c0,c1,c2:integer):integer;// Peter
var i,index:integer;
  dist,min:real;
Begin
 min:=$FFFFffff;
 index:=0;

  c0 := c0 shl C0_SHIFT;
  c1 := c1 shl C1_SHIFT;
  c2 := c2 shl C2_SHIFT;

 for i:=0 to 255 do
 begin
   dist:=(
      sqr(c0-colormap[0][i])
    + sqr(c1-colormap[1][i])
    + sqr(c2-colormap[2][i]) );

    if dist<min then
    begin
      index:=i;
      min:=dist;
    end;
 end;
 Result:=index;
End; (*  *)



 procedure pass2_no_dither;
{ This version performs no dithering }
var
//  cquantize : my_cquantize_ptr;

  histogram : hist3d_ptr;
  {register}  inptr : RGBptr;
             outptr : JSAMPLE_ptr;

  {register} cachep : histptr;
  {register} c0, c1, c2 : int;
  row : int;
  col : JDIMENSION;
  width : JDIMENSION;
  num_rows:integer;



Begin //pass2_no_dither;
// cquantize := my_cquantize_ptr (cinfo^.cquantize);
  num_rows:=IMG.height;
  histogram := hist;

  ClearHistogram(hist);

  width := IMG.width;

  for row := 0 to pred(num_rows) do
  begin
    {$R-}
    inptr:=@RGB_scanlines_ptr(IMG.Source_lines)^[row]^;
    outptr :=@b_scanlines_ptr(IMG.dest_lines)^[row]^;
    {$R+}
    for col := 1 to width do
    begin
     {get pixel value and index into the cache }
      c0 := GETJSAMPLE(inptr^.r) shr C0_SHIFT;
      c1 := GETJSAMPLE(inptr^.g) shr C1_SHIFT;
      c2 := GETJSAMPLE(inptr^.b) shr C2_SHIFT;
      Inc(inptr);

      cachep := @(histogram^[c0]^[c1][c2]);

      { If we have not seen this color before, find nearest colormap entry }
      { and update the cache }

  (*  if (cachep^ = 0) then
      begin
         bb:=NearCOLOR(c0,c1,c2); //Peter
         cachep^:=bb+1;
       end;(*  *)

      if (cachep^ = 0) then Fill_inverse_cmap(c0,c1,c2);



  { Now emit the colormap index for this cell }

       outptr^ := JSAMPLE (cachep^ - 1);
      // ShowMessage('Write '+inttostr(JSAMPLE (cachep^ - 1)));
      Inc(outptr);
    end;
  end;
End;//pass2_no_dither;




type
  FSERROR = INT32;      // or smallint
  LOCFSERROR = INT32;           { be sure calculation temps are big enough }
type                            { Nomssi }
  RGB_FSERROR_PTR = ^RGB_FSERROR;
  RGB_FSERROR = packed record
    r,g,b : FSERROR;
  end;
  LOCRGB_FSERROR = packed record
    r,g,b : LOCFSERROR;
  end;



type
  FSERROR_PTR = ^FSERROR;
  jFSError = 0..(MaxInt div SIZEOF(RGB_FSERROR))-1;
  FS_ERROR_FIELD = array[jFSError] of RGB_FSERROR;
  FS_ERROR_FIELD_PTR = ^FS_ERROR_FIELD;{far}
      { pointer to error array (in FAR storage!) }

type
  error_limit_array = array[-MAXJSAMPLE..MAXJSAMPLE] of int;
  { table for clamping the applied error }
  error_limit_ptr = ^error_limit_array;

  range_limit_table = array[-(MAXJSAMPLE+1)..4*(MAXJSAMPLE+1)
                            + CENTERJSAMPLE -1] of JSAMPLE;
  range_limit_table_ptr = ^range_limit_table;



{LOCAL}
 procedure init_error_limit (table : error_limit_ptr);
const
  STEPSIZE = ((MAXJSAMPLE+1) div 16);

{ Allocate and fill in the error_limiter table }
var
//  cquantize : my_cquantize_ptr;

  inp, out : int;
Begin
//  cquantize := my_cquantize_ptr (cinfo^.cquantize);
//  table := error_limit_ptr (cinfo^.mem^.alloc_small
//    (j_common_ptr (cinfo), JPOOL_IMAGE, (MAXJSAMPLE*2+1) * SIZEOF(int)));
  { not needed: Inc(table, MAXJSAMPLE);
                so can index -MAXJSAMPLE .. +MAXJSAMPLE }
//  cquantize^.error_limiter := table;
  { Map errors 1:1 up to +- MAXJSAMPLE/16 }
  out := 0;
  for inp := 0 to pred(STEPSIZE) do
  begin
    table^[inp] := out;
    table^[-inp] := -out;
    Inc(out);
  end;
  { Map errors 1:2 up to +- 3*MAXJSAMPLE/16 }
  inp := STEPSIZE;       { Nomssi: avoid problems with Delphi2 optimizer }
  while (inp < STEPSIZE*3) do
  begin
    table^[inp] := out;
    table^[-inp] := -out;
    Inc(inp);
    if Odd(inp) then
      Inc(out);
  end;
  { Clamp the rest to final out value (which is (MAXJSAMPLE+1)/8) }
  inp := STEPSIZE*3;     { Nomssi: avoid problems with Delphi 2 optimizer }
  while inp <= MAXJSAMPLE do
  begin
    table^[inp] := out;
    table^[-inp] := -out;
    Inc(inp);
  end;
End;



{METHODDEF}
Procedure pass2_fs_dither;    // ne raboti za sega..
{ This version performs Floyd-Steinberg dithering }

var
  fserrors : FS_ERROR_FIELD_PTR;        { accumulated errors }

  num_rows:integer;

//  cquantize : my_cquantize_ptr;
  histogram : hist3d_ptr;
  {register} cur : LOCRGB_FSERROR;	{ current error or pixel value }
  belowerr : LOCRGB_FSERROR; { error for pixel below cur }
  bpreverr : LOCRGB_FSERROR; { error for below/prev col }
  prev_errorptr,
  {register} errorptr : RGB_FSERROR_ptr;	{ => fserrors[] at column before current }
  inptr : RGBptr;		{ => current input pixel }
  outptr : JSAMPLE_PTR;		{ => current output pixel }
  cachep : histptr;
  dir : int;			{ +1 or -1 depending on direction }
  row : int;
  col : JDIMENSION;
  width : JDIMENSION;
//  range_limit : range_limit_table_ptr;
  error_limit : error_limit_array;//_ptr;
  colormap0,
  colormap1,
  colormap2 : array[0..255] of byte;
  {register} pixcode : int;
  {register} bnexterr, delta : LOCFSERROR;
  on_odd_row:boolean;


  i,errSize,bb:integer;

  function range_limit(n:int):int;
  begin
    if n>255 then n:=255;
    if n<0 then n:=0;
    result:=n;
  end;

{  function error_limit(n:int):int;
  const lim=2550;
  begin
    if n>lim then n:=lim;
    if n<-lim then n:=-lim;
    result:=n;
  end;{}

const size= HIST_C1_ELEMS*HIST_C2_ELEMS * SIZEOF(histcell);

Begin

 errSize:=(IMG.width + 2) * (3 * SIZEOF(FSERROR));
 Getmem(fserrors, errSize );FillChar(FSerrors^,errSize,#0);
// on_odd_row := FALSE;

try
//  cquantize := my_cquantize_ptr (cinfo^.cquantize);
  histogram := hist;//cquantize^.histogram;

  ClearHistogram(hist);

//  for i:=0 to pred(HIST_C0_ELEMS) do
//   FillChar(histogram^[i]^,size,#0);   //clear histogram

  width := IMG.width;
  num_rows:=IMG.height;
//  range_limit := sample_range_limit;
//  error_limit := cquantize^.error_limiter;


  init_error_limit(@error_limit);
//  range_limit := @sample_range_limit;

 move(colormap[0], colormap0,256);
 move(colormap[1], colormap1,256);
 move(colormap[2], colormap2,256);

  for row := 0 to pred(num_rows) do
  begin
    {$R-}
    inptr :=@rgb_scanlines_ptr(Img.source_lines)^[row]^;
    outptr :=@b_scanlines_ptr(Img.dest_lines)^[row]^;
    {$R+}
    errorptr := RGB_FSERROR_PTR(fserrors); { => entry before first real column }
    if odd(row) then
    begin
      { work right to left in this row }
      Inc(inptr, (width-1));     { so point to rightmost pixel }
      Inc(outptr, width-1);
      dir := -1;
      Inc(errorptr, (width+1)); { => entry after last column }
   //   on_odd_row := FALSE; { flip for next time }
    end
    else
    begin
      { work left to right in this row }
      dir := 1;
//      on_odd_row := TRUE; { flip for next time }
    end;

    { Preset error values: no error propagated to first pixel from left }
    cur.r := 0;
    cur.g := 0;
    cur.b := 0;
    { and no error propagated to row below yet }
    belowerr.r := 0;
    belowerr.g := 0;
    belowerr.b := 0;
    bpreverr.r := 0;
    bpreverr.g := 0;
    bpreverr.b := 0;

    for col := pred(width) downto 0 do
    begin
      prev_errorptr := errorptr;
      Inc(errorptr, dir);	{ advance errorptr to current column }

      { curN holds the error propagated from the previous pixel on the
        current line.  Add the error propagated from the previous line
        to form the complete error correction term for this pixel, and
        round the error term (which is expressed * 16) to an integer.
        RIGHT_SHIFT rounds towards minus infinity, so adding 8 is correct
        for either sign of the error value.
        Note: prev_errorptr points to *previous* column's array entry. }

      { Nomssi Note: Borland Pascal SHR is unsigned }
      cur.r := (cur.r + errorptr^.r + 8) div 16;
      cur.g := (cur.g + errorptr^.g + 8) div 16;
      cur.b := (cur.b + errorptr^.b + 8) div 16;
      { Limit the error using transfer function set by init_error_limit.
        See comments with init_error_limit for rationale. }

   {Peter 2003 03 14{}
   {
      cur.r := error_limit[cur.r];
      cur.g := error_limit[cur.g];
      cur.b := error_limit[cur.b];
      {}


      { Form pixel value + error, and range-limit to 0..MAXJSAMPLE.
        The maximum error is +- MAXJSAMPLE (or less with error limiting);
        this sets the required size of the range_limit array. }

      Inc(cur.r, GETJSAMPLE(inptr^.r));
      Inc(cur.g, GETJSAMPLE(inptr^.g));
      Inc(cur.b, GETJSAMPLE(inptr^.b));

      cur.r := range_limit(cur.r);
      cur.g := range_limit(cur.g);
      cur.b := range_limit(cur.b);
      { Index into the cache with adjusted pixel value }
      cachep := @(histogram [cur.r shr C0_SHIFT]^
                            [cur.g shr C1_SHIFT]
                            [cur.b shr C2_SHIFT]);
      { If we have not seen this color before, find nearest colormap }
      { entry and update the cache }


      if (cachep^ = 0) then
	fill_inverse_cmap(       cur.r shr C0_SHIFT,
                                 cur.g shr C1_SHIFT,
                                 cur.b shr C2_SHIFT);

    { Now emit the colormap index for this cell }

      pixcode := cachep^ - 1;
      outptr^ := JSAMPLE (pixcode);

      { Compute representation error for this pixel }
      Dec(cur.r, GETJSAMPLE(colormap0[pixcode]));
      Dec(cur.g, GETJSAMPLE(colormap1[pixcode]));
      Dec(cur.b, GETJSAMPLE(colormap2[pixcode]));

      { Compute error fractions to be propagated to adjacent pixels.
        Add these into the running sums, and simultaneously shift the
        next-line error sums left by 1 column. }

      bnexterr := cur.r;	{ Process component 0 }
      delta := cur.r * 2;
      Inc(cur.r, delta);		{ form error * 3 }
      prev_errorptr^.r := FSERROR (bpreverr.r + cur.r);
      Inc(cur.r, delta);		{ form error * 5 }
      bpreverr.r := belowerr.r + cur.r;
      belowerr.r := bnexterr;
      Inc(cur.r, delta);		{ form error * 7 }
      bnexterr := cur.g;	{ Process component 1 }
      delta := cur.g * 2;
      Inc(cur.g, delta);		{ form error * 3 }
      prev_errorptr^.g := FSERROR (bpreverr.g + cur.g);
      Inc(cur.g, delta);		{ form error * 5 }
      bpreverr.g := belowerr.g + cur.g;
      belowerr.g := bnexterr;
      Inc(cur.g, delta);		{ form error * 7 }
      bnexterr := cur.b;	{ Process component 2 }
      delta := cur.b * 2;
      Inc(cur.b, delta);		{ form error * 3 }
      prev_errorptr^.b := FSERROR (bpreverr.b + cur.b);
      Inc(cur.b, delta);		{ form error * 5 }
      bpreverr.b := belowerr.b + cur.b;
      belowerr.b := bnexterr;
      Inc(cur.b, delta);		{ form error * 7 }

      { At this point curN contains the 7/16 error value to be propagated
        to the next pixel on the current line, and all the errors for the
        next line have been shifted over.  We are therefore ready to move on.}

      Inc(inptr, dir);		{ Advance pixel pointers to next column }
      Inc(outptr, dir);
    end;
    { Post-loop cleanup: we must unload the final error values into the
      final fserrors[] entry.  Note we need not unload belowerrN because
      it is for the dummy column before or after the actual array. }

    errorptr^.r := FSERROR (bpreverr.r); { unload prev errs into array }
    errorptr^.g := FSERROR (bpreverr.g);
    errorptr^.b := FSERROR (bpreverr.b);
  end;

 finally
    FreeMem(fserrors, errSize );
 end;
End;







(*type

  hist1d = array[0..HIST_C2_ELEMS-1] of histcell; { typedefs for the array }
  hist1d_field = array[0..HIST_C1_ELEMS-1] of hist1d;
                                  { type for the 2nd-level pointers }
  hist2d = ^hist1d_field;
  hist2d_field = array[0..HIST_C0_ELEMS-1] of hist2d;
  hist3d = ^hist2d_field;	  { type for top-level pointer }
 *)
procedure GetMemHist;
var i:int;
const size= HIST_C1_ELEMS*HIST_C2_ELEMS * SIZEOF(histcell);
Begin
  GetMem(hist,HIST_C0_ELEMS * SIZEOF(hist2d));
  for i:=0 to pred(HIST_C0_ELEMS) do
   begin
      GetMem(hist^[i],size);
    FillChar(hist^[i]^,size,#0);   //clear histogram
   end;
End;


procedure FreeMemHist;
var i:int;
Begin
  for i:=0 to pred(HIST_C0_ELEMS) do
   begin
    FreeMem(hist^[i],HIST_C1_ELEMS*HIST_C2_ELEMS * SIZEOF(histcell));
   end;
   FreeMem(hist,HIST_C0_ELEMS * SIZEOF(hist2d));
End;


procedure Convert256_3(SO,DES:pointer);
type
 S1=array[0..255,0..2] of byte; PS1=^S1;
 S2=array[0..2,0..255] of byte; PS2=^S2;
var
 P1:PS1;
 P2:PS2;
 i:integer;

Begin
 P2:=SO;
 P1:=DES;
 for i:=0 to 255 do
  begin
    P1[i,0]:=P2[0,i];
    P1[i,1]:=P2[1,i];
    P1[i,2]:=P2[2,i];
  end;
End;

var COL:array[0..255,1..3] of byte;
label skip;
label excm;
Begin // IMG24_8

if IMG.desired_colors<32 then
 // за малко на брой цветове, изравнявам тежестта им; 11.04.2003 Peter
 begin
  R_SCALE:=1;
  G_SCALE:=1;
  B_SCALE:=1;
 end;

{$ifdef RGB_RED_IS_0}
  C0_SCALE := R_SCALE;
  C1_SCALE := G_SCALE;
  C2_SCALE := B_SCALE;
{$else}
  C0_SCALE := B_SCALE;
  C1_SCALE := G_SCALE;
  C2_SCALE := R_SCALE;
{$endif}

 FillChar(colormap,SizeOf(colormap),#0);
 GetMemHist; //create histogram

 try

 if Prescan_quant(IMG,hist)<=IMG.desired_colors then
   IMG.method:=No_dither;

  Select_colors (IMG.desired_colors);
  Convert256_3(@colormap,@col);

  move(col,IMG.col^,sizeOf(col));

excm:

 case IMG.method of
 No_dither:Pass2_no_dither;
 FS_dither:pass2_fs_dither;
 end;

 IMG.actual_number_of_colors:=actual_number_of_colors;
skip:
 finally
  FreeMemHist;
 end;

End; //Procedure Bitmap32_8

END.

    {$R-}
    {$R+}

