{
this is slow
  pen.color:=dlgOptions.pnlColorForces.Color;

--------------------------------------------
make so significance is per muscle
  not all are on/off                                                                                                                    

inSaveRestoreKeyframesMusclePos(Save,All: boolean);
  why isn't signif taken into account

in-betweening of atoms for movies ??

----------------------------------

Double click to create atom
  doesn't work after zoom/scroll

it lost the Polygons
  probably during an Undo
  when do Undo loses all polyhedra

undo stack isn't deep enough

when drag a symmetry-plane atom
  other selected atoms go crazy

Export ultrasonics frames from AAA

maybe OK
  when have selected atoms, shouldn't allow add Roof points
  when have selected Roof points, shouldn't allow add atoms

calc gas const of "solve" v slow

add Coeff to muscl dependency of a strut
  Coeff = 0..1
  depends on how vertical the strut is when at rest

done---------------

to do---------------

resize images
  when importing? easier?
  when drawing

undo
  doesn't seem to work backwards past a Run
  doesn't seem to work undo polgon color change
  seems to need to be clicked lots of times
  not very deep
  when undo wheel-rotate
    should undo to before first rotate - not last one

split sheet
  select an atom
  extend along X-lines
  extend along Y-lines
  now have a sheet of atoms
  click Split Sheet
    every atom A gets a partner B in same place
    sheet B has struts which duplicate struts of sheet A
    struts not in sheet attached to A must decide whether they're now attached to B or A
      depends on which side of the mean Plane of A they are
    A and B atoms now move apart in direction
      direction is
        if there are >1 struts attached to A then
          normal to mean Plane through those struts
          else normal to mean Plane through sheets
      D is value given in dialog
        or maybe is 1 3 dist between A and sheets on either side? hard?
        B and A are both moved D/2 in opposite directions
    if A1,A2,A3,A4 form a Polygon then make a Polygon B1,B2,B3,B4
      if option checked then
        A1,A2,B2,B1 make a Polygon
        A2,A3,B3,B2 make a Polygon
        etc.
        cross brace all Polygons
        if option checked then
          make a polyhedron

Draw using
  Binary space partitioning

VisibleSide
  should have
    positive
    negative
    always
    never

makegrid
  VisibleSide should be set correctly
  but what is correct
    maybe
      internal is Never
      external is one-sided
    but then what if delete some of grid?

when make new keyframe in run mode
  then return to Edit
    then loses new keyfram
  but is OK if make new keyframe in Edit mode
  maybe fixed - test it

should options be stored in s3d file?
  probably

make pressure work
  not strong enough
  if make stronger then is unstable

if have no file loaded then there must be one keyframe

sort out
  if rbIntegrate.Checked then
    procedure CalcOneIntervalIntegrate;
    procedure CalcOneIntervalSolve;
      weighted mean
        weight = elasticity??

keyframe red pos and white pos
  should be a fraction of width of panel
  not abs position on panel

done-----------

}
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Dialogs, Menus,
  ExtCtrls, SizePos, StdCtrls, ComCtrls, Buttons, Controls, Forms,
  jpegCalc,
  Optionsdlg,
  misc, Spin, ExtDlgs;

type
  FPnumber = single;
  TMode = (tiEdit,tiRun);
  TAtomNum = 1..20000;
  TAtomRef = 0..high(TAtomNum);
  TAtomRefEx = 0..maxint; {can be an atom or a Roof point}
  TStrutNum = 1..40000;
  TStrutRef = 0..high(TStrutNum);
  TAxes = (plXY,plXZ,plYZ,pl3D);
  TRoofAxes = (raZPos,raYPos,raXNeg,raXPos,raZNeg,raYNeg);
  TAxis = (axX,axY,axZ,axNone);
  TMouseMode = (mmNone,mmSelecting,mmMakingStrut,mmMovingSection,mmScrolling,mmRotating,mmZooming);
  TAtomBoolArray = array[TAtomNum] of boolean;
  TAtomIntArray = array[TAtomNum] of integer;
  TAtomRealArray = array[TAtomNum] of single;
  TStrutBoolArray = array[TStrutNum] of boolean;
  TStrutRealArray = array[TStrutNum] of single;
  TFixing = (chFree,chStatic,chSym);

  TAtom = record
    AtomName: string[15];
    p: T3DPoint;
    v: T3DPoint;
    f: T3DPoint;
    af: T3DPoint;
    Mass: FPnumber;
    Selected: boolean;
    neglect: boolean;
    Fixing: TFixing;
    Rigid: TArrayofInteger;
    pOriginal: T3DPoint; {for rigidity}
    gap: single; {for EPG display}
    EMA: integer; {temporary value while drawing; -1:unused; 0:used; 1+:used with phi,theta}
    impNum: integer; {temporary value of ANSYS node index during import - refnum used in imported file}
  end;
  TAtomArray = array[TAtomNum] of TAtom;

  TStrut = record
    StrutName: string[50];
    Atom1,Atom2: TAtomNum;
    RestLength: FPnumber;  //slider control length
    PrevLen: FPnumber;  //length of strut at last iteration
    ElasticityR: FPnumber;
    ElasticityC: FPnumber;
    Selected: boolean;
    musc: integer;
    Coeff: single;
    Axis: TAxis;
    Color: integer;
    PenWidth: integer;
    impNum: array[1..20] of integer; {temporary value of ANSYS element index during import - refnum used in imported file  allows strut to belong to up to 10 elements }
  end;
  TStrutArray = array[TStrutNum] of TStrut;
  Tmuscle = record
    TrackBar: TTrackBar;
    Label1: TLabel;
  end;
  TRoof = record
    h: single;
    Selected: boolean;
  end;
  TKeyframe = record
    TLTime: integer;
    posq: array of record p:integer; Significant: boolean; end;
    jpgBGXY,jpgBGXZ,jpgBGYZ: string;                           
  end;
  TPolygon = record
    a: array[1..4] of TAtomRef; {a[4] may be 0}
    VisibleSide: single; {if zero then both sides}
    Area: single;
    Col: TColor;
  end;
  TPolyhedron = record
    PosFace,NegFace: Tarrayofinteger; {index into Polygon array}
    Volume,pressure: single;
  end;
  TTetrahedron = record
    a: array[1..4] of TAtomRef;
    Volume: single;
  end;
  TSpheroid = record R,C: T3DPoint; end;

  TForm1 = class(TForm)
    Panel1: TPanel;
    pnlYZ: TPanel;
    Panel3: TPanel;
    pnl3D: TPanel;
    Panel20: TPanel;
    pnlXY: TPanel;
    Panel7: TPanel;
    pnlXZ: TPanel;
    Panel9: TPanel;
    Panel11: TPanel;
    pbYZ: TPaintBox;
    pbXY: TPaintBox;
    pbXZ: TPaintBox;
    pb3D: TPaintBox;
    SizePos1: TSizePos;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N2: TMenuItem;
    SaveAs1: TMenuItem;
    Save1: TMenuItem;
    Open1: TMenuItem;
    New1: TMenuItem;
    Options1: TMenuItem;
    Options2: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Panel10: TPanel;
    Edit1: TMenuItem;
    Paste1: TMenuItem;
    Copy1: TMenuItem;
    Cut1: TMenuItem;
    N4: TMenuItem;
    Undo1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Contents1: TMenuItem;
    Panel12: TPanel;
    OpenDialog2: TOpenDialog;
    SaveDialog2: TSaveDialog;
    Delete2: TMenuItem;
    N9: TMenuItem;
    CopyTo2: TMenuItem;
    PasteFrom2: TMenuItem;
    N10: TMenuItem;
    Expand2: TMenuItem;
    Timer1: TTimer;
    imgYZ: TImage;
    imgXY: TImage;
    imgXZ: TImage;
    img3D: TImage;
    Movie1: TMenuItem;
    Points1: TMenuItem;
    Fixing1: TMenuItem;
    Static1: TMenuItem;
    Normal1: TMenuItem;
    Mass1: TMenuItem;
    Struts1: TMenuItem;
    N13: TMenuItem;
    DeleteDuplicates1: TMenuItem;
    Edit3: TMenuItem;
    Objects1: TMenuItem;
    ClearColours1: TMenuItem;
    ColourTriangles1: TMenuItem;
    N14: TMenuItem;
    SelectAll1: TMenuItem;
    HideOthers1: TMenuItem;
    N15: TMenuItem;
    Walker1: TMenuItem;
    Wheel1: TMenuItem;
    Ball1: TMenuItem;
    Box1: TMenuItem;
    N18: TMenuItem;
    Mirrorx1: TMenuItem;
    Mirrorz1: TMenuItem;
    Mirrory1: TMenuItem;
    N3: TMenuItem;
    MakeGrid1: TMenuItem;
    Addtocurrentmuscle1: TMenuItem;
    Removefromallmuscles1: TMenuItem;
    pnlTimeline3: TPanel;
    pnlTimeline1: TPanel;
    pbTimeline: TPaintBox;
    pnlTimeline2: TPanel;
    pnlTimelineRed: TPanel;
    pnlTimeline4: TPanel;
    sbTimeline: TSpeedButton;
    puTimeline1: TPopupMenu;
    NewKeyframe1: TMenuItem;
    puTimeline2: TPopupMenu;
    DeleteKeyframe1: TMenuItem;
    puMuscles: TPopupMenu;
    Delete3: TMenuItem;
    MenuItem1: TMenuItem;
    NewMuscle1: TMenuItem;
    tmrKeyframe: TTimer;
    Memo1: TMemo;
    test1: TMenuItem;
    Polygon1: TMenuItem;
    Add1: TMenuItem;
    Remove1: TMenuItem;
    Colour1: TMenuItem;
    ColorDialog1: TColorDialog;
    N1: TMenuItem;
    ImportImages1: TMenuItem;
    View1: TMenuItem;
    ShowPolygonsRun1: TMenuItem;
    ShowPolygonsEdit1: TMenuItem;
    ShowAtomNums1: TMenuItem;
    N6: TMenuItem;
    NoSection1: TMenuItem;
    XYSection1: TMenuItem;
    YZSection1: TMenuItem;
    XZSection1: TMenuItem;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Selection1: TMenuItem;
    N7: TMenuItem;
    N19: TMenuItem;
    muSubselectOther: TMenuItem;
    muSubselect: TMenuItem;
    muSubselectXlines: TMenuItem;
    muSubselectYlines: TMenuItem;
    muSubselectZlines: TMenuItem;
    muCurrentmuscle: TMenuItem;
    muAnymuscle: TMenuItem;
    muDeselect: TMenuItem;
    muDeselectXlines: TMenuItem;
    muDeselectYlines: TMenuItem;
    muDeselectZlines: TMenuItem;
    muDeselectOther: TMenuItem;
    muDeselectCurrentmuscle: TMenuItem;
    muDeselectAnymuscle: TMenuItem;
    muExtendAtoms: TMenuItem;
    muExtendAtomsXlines: TMenuItem;
    muExtendAtomsYlines: TMenuItem;
    muExtendAtomsZlines: TMenuItem;
    muExtendStruts: TMenuItem;
    muExtendStrutsXlines: TMenuItem;
    muExtendStrutsYlines: TMenuItem;
    muExtendStrutsZlines: TMenuItem;
    N12: TMenuItem;
    Atoms1: TMenuItem;
    Struts2: TMenuItem;
    N20: TMenuItem;
    Atoms2: TMenuItem;
    Struts3: TMenuItem;
    N21: TMenuItem;
    ToAtoms1: TMenuItem;
    N22: TMenuItem;
    ToStruts1: TMenuItem;
    ToAllStruts1: TMenuItem;
    Sectiontobackground1: TMenuItem;
    Merge1: TMenuItem;
    CloseSelected1: TMenuItem;
    AllSelected1: TMenuItem;
    Rename1: TMenuItem;
    MakeGridB1: TMenuItem;
    SymmetryAxes1: TMenuItem;
    Timer3: TTimer;
    AddLayer1: TMenuItem;
    Allclose1: TMenuItem;
    HeedAll1: TMenuItem;
    Run1: TMenuItem;
    N24: TMenuItem;
    Edit2: TMenuItem;
    ShowSymmetryRun1: TMenuItem;
    ShowSymmetryEdit1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Rotate1: TMenuItem;
    Zoom2: TMenuItem;
    Panel2: TPanel;
    OpenButton: TSpeedButton;
    SaveButton: TSpeedButton;
    UndoButton: TSpeedButton;
    tcMode: TTabControl;
    sbCentre: TSpeedButton;
    pnlRecordingMovie: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    SpinEdit2: TSpinEdit;
    Button1: TButton;
    Button2: TButton;
    pnlVolume: TPanel;
    MakeGridC1: TMenuItem;
    InvertSelection1: TMenuItem;
    test21: TMenuItem;
    prism1: TMenuItem;
    make1tet1: TMenuItem;
    JPEGSection1: TMenuItem;
    XZSection2: TMenuItem;
    YZSection2: TMenuItem;
    XYSection2: TMenuItem;
    BlankSection1: TMenuItem;
    Xgrain1: TMenuItem;
    YGrain1: TMenuItem;
    ZGrain1: TMenuItem;
    KeyframeImage1: TMenuItem;
    XY1: TMenuItem;
    XZ1: TMenuItem;
    YZ1: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    ZPos1: TMenuItem;
    N5: TMenuItem;
    Roof2: TMenuItem;
    N8: TMenuItem;
    Roof3: TMenuItem;
    ZPos4: TMenuItem;
    Rigidbody1: TMenuItem;
    ShowClosure1: TMenuItem;
    SymmetrySlice1: TMenuItem;
    SymmetrySlice2: TMenuItem;
    Constraints1: TMenuItem;
    YPos1: TMenuItem;
    XNeg1: TMenuItem;
    XPos1: TMenuItem;
    Constraints2: TMenuItem;
    XNeg2: TMenuItem;
    YPos2: TMenuItem;
    pnlMuscles1: TScrollBox;
    EMA1: TMenuItem;
    Add2: TMenuItem;
    Options3: TMenuItem;
    Delete4: TMenuItem;
    N11: TMenuItem;
    AddAllMuscles1: TMenuItem;
    DeleteAllMuscles1: TMenuItem;
    CopyKeyframe1: TMenuItem;
    PasteKeyframe1: TMenuItem;
    PasteKeyframe2: TMenuItem;
    ImportKeyframes1: TMenuItem;
    OpenDialog3: TOpenDialog;
    DeleteAll1: TMenuItem;
    N16: TMenuItem;
    Imagetobackground1: TMenuItem;
    ImagetoXY1: TMenuItem;
    ImagetoYZ1: TMenuItem;
    ImagetoXZ1: TMenuItem;
    XPos2: TMenuItem;
    ZNeg4: TMenuItem;
    ZNeg1: TMenuItem;
    YNeg1: TMenuItem;
    YNeg2: TMenuItem;
    LockKeyframes1: TMenuItem;
    Significant1: TMenuItem;
    N17: TMenuItem;
    Movie2: TMenuItem;
    MovieXY1: TMenuItem;
    MovieXZ1: TMenuItem;
    MovieYZ1: TMenuItem;
    Movie3D1: TMenuItem;
    pnlMuscleChart: TPanel;
    Splitter1: TSplitter;
    pbMuscleChart: TPaintBox;
    MuscleChart1: TMenuItem;
    CurrentMuscleSignificant1: TMenuItem;
    AllSignificant1: TMenuItem;
    NoneSignificant1: TMenuItem;
    N23: TMenuItem;
    StrutName1: TMenuItem;
    N25: TMenuItem;
    StrutName2: TMenuItem;
    SpeedButton4: TSpeedButton;
    test2: TMenuItem;
    SelectAll2: TMenuItem;
    Show3Datoms1: TMenuItem;
    Show3Datoms2: TMenuItem;
    ImportANSYS1: TMenuItem;
    Showcloseatoms1: TMenuItem;
    ImportANSYS2: TMenuItem;
    ExportANSYS1: TMenuItem;
    SaveDialog3: TSaveDialog;
    NeglectSelected1: TMenuItem;
    NeglectNotSelected1: TMenuItem;
    procedure muSubselectXlinesClick(Sender: TObject);
    procedure muSubselectYlinesClick(Sender: TObject);
    procedure muSubselectZlinesClick(Sender: TObject);
    procedure muCurrentmuscleClick(Sender: TObject);
    procedure muAnymuscleClick(Sender: TObject);
    procedure muDeselectXlinesClick(Sender: TObject);
    procedure muDeselectYlinesClick(Sender: TObject);
    procedure muDeselectZlinesClick(Sender: TObject);
    procedure muDeselectOtherClick(Sender: TObject);
    procedure muDeselectCurrentmuscleClick(Sender: TObject);
    procedure muDeselectAnymuscleClick(Sender: TObject);
    procedure muExtendAtomsXlinesClick(Sender: TObject);
    procedure muExtendAtomsYlinesClick(Sender: TObject);
    procedure muExtendAtomsZlinesClick(Sender: TObject);
    procedure muExtendStrutsXlinesClick(Sender: TObject);
    procedure muExtendStrutsYlinesClick(Sender: TObject);
    procedure muExtendStrutsZlinesClick(Sender: TObject);

    procedure Panel3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel9MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure pbXYPaint(Sender: TObject);
    procedure pbXZPaint(Sender: TObject);
    procedure pbYZPaint(Sender: TObject);
    procedure pbXYMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbXYMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbXYMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbXZMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbXZMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbXZMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Options2Click(Sender: TObject);
    procedure pbYZMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbYZMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbYZMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pb3DPaint(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure pb3DMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pb3DMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure Contents1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Panel12MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure tcModeChange(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure pb3DMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure Mass1Click(Sender: TObject);
    procedure Edit3Click(Sender: TObject);
    procedure DeleteDuplicates1Click(Sender: TObject);
    procedure Mirrorx1Click(Sender: TObject);
    procedure Mirrorz1Click(Sender: TObject);
    procedure Mirrory1Click(Sender: TObject);
    procedure Static1Click(Sender: TObject);
    procedure MakeGrid1Click(Sender: TObject);
    procedure Addtocurrentmuscle1Click(Sender: TObject);
    procedure Removefromallmuscles1Click(Sender: TObject);
    procedure pbTimelineMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbTimelineMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbTimelineMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbTimelinePaint(Sender: TObject);
    procedure pnlTimelineRedMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure pnlTimelineRedMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbTimelineClick(Sender: TObject);
    procedure NewKeyframe1Click(Sender: TObject);
    procedure DeleteKeyframe1Click(Sender: TObject);
    procedure puMusclesPopup(Sender: TObject);
    procedure Delete3Click(Sender: TObject);
    procedure NewMuscle1Click(Sender: TObject);
    procedure tmrKeyframeTimer(Sender: TObject);
    procedure Objects1Click(Sender: TObject);
    procedure test1Click(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure Remove1Click(Sender: TObject);
    procedure Colour1Click(Sender: TObject);
    procedure ImportImages1Click(Sender: TObject);
    procedure ShowAtomNums1Click(Sender: TObject);
    procedure XZSection1Click(Sender: TObject);
    procedure View1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure muSubselectOtherClick(Sender: TObject);
    procedure Atoms1Click(Sender: TObject);
    procedure Struts2Click(Sender: TObject);
    procedure ToAtoms1Click(Sender: TObject);
    procedure ToStruts1Click(Sender: TObject);
    procedure ToAllStruts1Click(Sender: TObject);
    procedure Sectiontobackground1Click(Sender: TObject);
    procedure CloseSelected1Click(Sender: TObject);
    procedure Rename1Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SymmetryAxes1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure sb3DXChange(Sender: TObject);
    procedure sbCentreClick(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure AddLayer1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure HeedAll1Click(Sender: TObject);
    procedure Zoom2Click(Sender: TObject);
    procedure Rotate1Click(Sender: TObject);
    procedure InvertSelection1Click(Sender: TObject);
    procedure prism1Click(Sender: TObject);
    procedure make1tet1Click(Sender: TObject);
    procedure Xgrain1Click(Sender: TObject);
    procedure YGrain1Click(Sender: TObject);
    procedure ZGrain1Click(Sender: TObject);
    procedure Panel4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure XY1Click(Sender: TObject);
    procedure XZ1Click(Sender: TObject);
    procedure YZ1Click(Sender: TObject);
    procedure puTimeline2Popup(Sender: TObject);
    procedure ZPos1Click(Sender: TObject);
    procedure ZPos4Click(Sender: TObject);
    procedure Rigidbody1Click(Sender: TObject);
    procedure ShowClosure1Click(Sender: TObject);
    procedure YPos1Click(Sender: TObject);
    procedure XNeg1Click(Sender: TObject);
    procedure XPos1Click(Sender: TObject);
    procedure YPos2Click(Sender: TObject);
    procedure XNeg2Click(Sender: TObject);
    procedure XPos2Click(Sender: TObject);
    procedure Add2Click(Sender: TObject);
    procedure Delete4Click(Sender: TObject);
    procedure Options3Click(Sender: TObject);
    procedure AddAllMuscles1Click(Sender: TObject);
    procedure DeleteAllMuscles1Click(Sender: TObject);
    procedure CopyKeyframe1Click(Sender: TObject);
    procedure PasteKeyframe1Click(Sender: TObject);
    procedure ImportKeyframes1Click(Sender: TObject);
    procedure DeleteAll1Click(Sender: TObject);
    procedure Imagetobackground1Click(Sender: TObject);
    procedure ZNeg1Click(Sender: TObject);
    procedure ZNeg4Click(Sender: TObject);
    procedure YNeg1Click(Sender: TObject);
    procedure YNeg2Click(Sender: TObject);
    procedure LockKeyframes1Click(Sender: TObject);
    procedure Significant1Click(Sender: TObject);
    procedure puTimeline1Popup(Sender: TObject);
    procedure MovieYZ1Click(Sender: TObject);
    procedure Movie1Click(Sender: TObject);
    procedure pbMuscleChartPaint(Sender: TObject);
    procedure MuscleChart1Click(Sender: TObject);
    procedure CurrentMuscleSignificant1Click(Sender: TObject);
    procedure AllSignificant1Click(Sender: TObject);
    procedure NoneSignificant1Click(Sender: TObject);
    procedure StrutName1Click(Sender: TObject);
    procedure ImportANSYS1Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure test2Click(Sender: TObject);
    procedure SelectAll2Click(Sender: TObject);
    procedure ExportANSYS1Click(Sender: TObject);
    procedure NeglectSelected1Click(Sender: TObject);
    procedure NeglectNotSelected1Click(Sender: TObject);
  private
    { Private declarations }
    fNumStruts: TStrutRef;
    fNumAtoms: TAtomRef;
    Modified: boolean;
    Yaw,Pitch,sinyaw,cosyaw,sinpitch,cospitch: FPnumber;
    pMousePrev: TPoint;
    pMouseDown: TPoint;
    ZoomRot: integer;
    SelectRect: TRect;
    MouseMode: TMouseMode;
    MouseModeAxes: TAxes;
    CurAtom: TAtomRefEx;
    CurMode: TMode;
    SavedPosition: string;
    sPaste: string;
    Undo: Tstringlist;
    MovingAtom: TAtomRef;
    RubberBand: TPoint;
    T: array of record l: array[1..3] of integer; a1,a2,a3: integer; area: single; end;
    Steps: integer;
    CurMuscle: integer;
    Keyframe: array of TKeyframe;
    CurKeyframe: integer;
    Polygons: array of TPolygon;
    Polyhedron: array of TPolyhedron;
    Tetrahedra: array of TTetrahedron;
    PixsIndex: single;
    CurSection: TAxes;
    ShowSectionJPG: boolean;
    bmpBGXYr,bmpBGXZr,bmpBGYZr: TBitmap;
    bmpBGXYe,bmpBGXZe,bmpBGYZe: TBitmap;
    sbmpBGXY,sbmpBGXZ,sbmpBGYZ: string;
    SymmetryAxes: TAxes;
    SymmetryCoord: single;
    bOfs2DX: integer;
    aOfs2DY: integer;
    aOfs2DZ: integer;
    Ofs3DX: integer;
    Ofs3DY: integer;
    AllImagesRead: boolean;
    Spheroids: array of TSpheroid;
    fTimelineCurTime: integer;
    Roof: array[TRoofAxes,-20..20,-20..20] of TRoof;
    HasConstraint: array[TRoofAxes] of boolean;
    ClipboardKeyframe: TKeyframe;
    MuscleList: TStringList; {temporary ANSYS muscle name during import}

    function cOfs2DX: integer;
    function cOfs2DZ: integer;
    function bOfs2DY: integer;
    function Running: boolean;
    procedure DeleteStrut(Strut: TStrutNum);
    procedure EditStrut;
    function xSnapToGrid(x: integer; Axes: TAxes): integer;
    function ySnapToGrid(y: integer; Axes: TAxes): integer;
    procedure ProcessFormMessages(var Msg : tMsg; var Handled: Boolean);
    procedure pbYZInvalidate;
    procedure pbXYInvalidate;
    procedure pbXZInvalidate;
    procedure pb3DInvalidate;
    procedure CalcPosition(timestep: FPnumber; last: boolean);
    procedure IncClock;
    function NearestAtom(x,y: FPnumber; Axes: TAxes): TAtomRef;
    function NearestStrut(x,y: integer; Axes: TAxes): TStrutRef;
    function Proj3D(xyz: T3DPoint; var p: TSinglePoint): FPnumber;
    function Proj3DZoom(xyz: T3DPoint; var p: TPoint): FPnumber;
    function Proj2D(xyz: T3DPoint; Axes: TAxes): TSinglePoint;
    function Proj2DZoom(xyz: T3DPoint; Axes: TAxes): TPoint;
    function UnProj2D(x,y: integer; Axes: TAxes): T3DPoint;
    function Horizon: integer;
    procedure DrawLine3D(pa,pb: T3DPoint);
    function FindAtom(ax,ay,dist: Integer; Axes: TAxes; bRoof: boolean): TAtomRefEx;
    function FindStrutXY(ax,ay,dist: Integer; Axes: TAxes): TAtomRef;
    procedure LoadSaveIniFile(Load: Boolean);
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure PaintBoxPaint(aControl: TControl; aCanvas: TCanvas; Axes: TAxes);
    procedure PaintBoxMouseDown(xs,ys: Integer; Axes: TAxes);
    procedure PaintBoxMouseMove(xs,ys: Integer; Axes: TAxes);
    procedure PaintBoxMouseUp(xs,ys: Integer; Axes: TAxes);
    procedure SelectInRect;
    function NumSelectedAtoms: integer;
    function NumSelectedStruts: integer;
    function StrutSelected(b: TStrutNum): boolean;
    function StrutColor(b: TStrutNum): TColor;
    procedure SetCursor;
    function pb3DCanvas: TCanvas;
    function AtomsToString(All: boolean): string;
    procedure StringToAtoms(s: string; LoadOptions,LoadCaption,RetainKeyframes: boolean);
    procedure DeleteSingleAtoms;
    procedure SelectAtom(Atom: TAtomRefEx; Add: boolean);
    procedure UnSelectAtom(Atom: TAtomRefEx);
    procedure SelectStrut(Strut: TStrutRef; XorSel: boolean);
    procedure SetUndo;
    procedure SetupStruts;
    procedure StopAllAtoms(OnlySelected: boolean);
    procedure SetNumStruts(value: integer);
    procedure SetNumAtoms(value: integer);
    procedure CheckNumAtoms;
    function NewAtom(x,y,z,Mass: FPnumber): TAtomNum;
    function NewStrut(Atom1,Atom2: TAtomNum; RestLength: FPnumber; ElasticityR,ElasticityC: FPnumber;
      QueryDups: boolean; aAxis: TAxis): TStrutNum;
    function FindStrut(a1,a2: TAtomRef): TStrutRef;
    function MinRestLen(a: FPnumber): FPnumber;
    function Distance(Atom1,Atom2: TAtomNum): FPnumber;
    function LoadFile(const filename: string): Boolean;
    function FirstSelectedAtom: integer;
    function FirstSelectedStrut: integer;
    procedure SetMainFilename(filename: string);
    procedure DeleteSelectedAtoms;
    procedure DeleteSelectedStruts;
    procedure DeleteAtoms(AtomBoolArray: TAtomBoolArray);
    procedure DeleteStruts(StrutBoolArray: TStrutBoolArray);
    procedure DeletePolygon(pg: integer);
    procedure DeletePolyhedron(ph: integer);
    procedure CalcVisibility(pg: integer);
    procedure InvalidateAll;
    function SaveIfModified(Query: Boolean): Boolean;
    function SaveFile(filename: string): Boolean;
    function SaveAsFile: Boolean;
    procedure OpenProjectFile(filename: string);
    function SaveObjsToFile(filename: string): Boolean;
    procedure ImportANSYS(filename: string; bMakePolygons,bMakePolyhedra,bReadMuscles,bMergeLeftRightMuscles: Boolean; Scale: integer);
    procedure IsLoaded;
    procedure SetPanelSizes(WL,HT: integer);
    procedure RotateSelectedAtoms(Angle: single);
    procedure RotateSelectedAtomsEx(Angle: single; About: TPoint; Axes: TAxes);
    procedure ZoomInOut(aSign: single);
    procedure ZoomInOutEx(aSign: single; About: TPoint; Axes: TAxes);
    procedure CalcStrutRestLength;
    procedure SetPrevStrutLength;
    function AtomsSelectedCount: integer;
    function StrutsSelectedCount: integer;
    procedure CalcOneIntervalIntegrate;
    procedure CalcOneIntervalSolve;
    procedure NewMuscleInKeyframes;
    procedure SaveRestoreKeyframesMusclePos(Save,All: boolean);
    function SharedAtom(b1,b2: TStrutRef): TAtomRef;
    property NumStruts: TStrutRef read fNumStruts;
    procedure DeleteMuscle(n: integer);
    function IsAtKeyframe: integer;
    procedure SetCurMuscle(im: integer);
    procedure DeleteMuscleInKeyframes(n: integer);
    function NewMuscle(s: string; IgnoreDups: boolean): integer;
    procedure CheckAllKeyframes;
    procedure DeleteKeyframe(n: integer);
    procedure SortKeyframes;
    procedure TrackBarChange(Sender: TObject);
    procedure TrackBarEnter(Sender: TObject);
    procedure LoadSaveKeyframe(Load: boolean; k: integer);
    procedure MusclePanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MusclePanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CalcAllVolumes;
    procedure CalcAllAreas;
    procedure LoadTrackbars;
    procedure Run;
    procedure Stop;
    function NewPolygon(a1,a2,a3,a4: TAtomRef; VisibleSide: single): integer;
    function NewPolyhedron(PosFace,NegFace: array of integer): integer;
    function NewTetrahedron(a1,a2,a3,a4: TAtomRef): integer;
    function PolyhedronVolume(ph: integer): single;
    function PolygonArea(pg: integer): single;
    function TetrahedronVolume(th: integer): single;
    procedure temp;
    procedure ClearAll(RetainKeyframes: boolean);
    procedure SaveScreenShot(name: string; {PhotoFormat: TPhotoFormat; }AddNumber: boolean);
    procedure SetTrackBarPosition(m,i: integer);
    function uPixsCoord(Axes: TAxes): integer;
    function vPixsCoord(Axes: TAxes): integer;
    function uPixsCoordZoom(Axes: TAxes): integer;
    function vPixsCoordZoom(Axes: TAxes): integer;
    function GetXYPixImage(i: single): TPix;
    function GetXZPixImage(i: single): TPix;
    function GetYZPixImage(i: single): TPix;
    function SectionRect(Axes: TAxes): TRect;
    procedure PixsIndexChange;
    function XSectionCoord: single;
    function YSectionCoord: single;
    function ZSectionCoord: single;
    function AtomNearCurSection(a: TAtomRef): boolean;
    function RoofNearCurSection(RoofAxes: TRoofAxes; i,j: integer): boolean;
    procedure ExtendAtomslines(aAxis: TAxis);
    procedure ExtendStrutslines(aAxis: TAxis);
    procedure MakeSymmetrical;
    procedure ChkPoly;
    procedure CheckClearSym;
    function ZoomScroll(x,y: single; Axes: TAxes): TPoint;
    function UnZoomScroll(x,y: integer; Axes: TAxes): TSinglePoint;
    procedure MoveTo2D(Canvas: TCanvas; xyz: T3DPoint; Axes: TAxes);
    procedure LineTo2D(Canvas: TCanvas; xyz: T3DPoint; Axes: TAxes);
    procedure MoveToZoom(Canvas: TCanvas; x,y: Single; Axes: TAxes);
    procedure LineToZoom(Canvas: TCanvas; x,y: Single; Axes: TAxes);
    procedure RectangleZoom(Canvas: TCanvas; Left,Top,Right,Bottom: Single; Axes: TAxes);
    procedure FillRectZoom(Canvas: TCanvas; Left,Top,Right,Bottom: Single; Axes: TAxes);
    procedure TextOutZoom(Canvas: TCanvas; x,y: Single; s: string; Axes: TAxes);
    procedure DrawZoom(Canvas: TCanvas; x,y: Single; bmp: TBitmap; Axes: TAxes);
    function TextHeightZoom(Canvas: TCanvas; s: string; Axes: TAxes): single;
    procedure PolygonZoom(Canvas: TCanvas; Points: array of TSinglePoint; Axes: TAxes);
    procedure PixDrawZoom(Canvas: TCanvas; x,y: integer; Pix: TPix; Axes: TAxes);
    procedure FixSymmetryAtoms;
    function CalcPolgonArea(pg: integer): single;
    function PolgonNormal(pg: integer): T3DPoint;
    procedure SetTimelineCurTime(t: integer);
    procedure MakeConstraintsSymmetrical;
    property TimelineCurTime: integer read fTimelineCurTime write SetTimelineCurTime;
    function TLTimeToX(t: integer): integer;
    function XToTLTime(x: integer): integer;
    procedure LoadKeyframeImages;
    function MeshPoint3D(RoofAxes: TRoofAxes; i,j: integer): T3DPoint;
    function MeshPoint2D(RoofAxes: TRoofAxes; i,j: integer; Axes: TAxes): TPoint;
    function RoofPos(RoofAxes: TRoofAxes; x,y: single): single;
    function RoofPosZPos(x,y: single): single;
    function RoofPosZNeg(x,y: single): single;
    function RoofPosYPos(x,z: single): single;
    function RoofPosYNeg(x,z: single): single;
    function RoofPosXNeg(y,z: single): single;
    function RoofPosXPos(y,z: single): single;
    function RoofSelected(Atom: TAtomRefEx): boolean;
    procedure ApplyRigity;
    procedure EditRoof(RoofAxes: TRoofAxes);
    function PolygonNeglected(var Polygon: TPolygon): boolean;
    procedure FillEMA;
    function MaxTime: integer;
    procedure Keyframe0Significant;
    procedure NewKeyframe(Sort,signif: boolean);
    function HasCloseAtoms: boolean;
    procedure OpenFibresFile(filename: string; bMergeLeftRightMuscles: Boolean);
  public
    { Public declarations }
    Atoms: TAtomArray;
    Struts: TStrutArray;
    muscle: array of Tmuscle;
    property NumAtoms: TAtomRef read fNumAtoms;
  end;

var
  Form1: TForm1;

implementation

uses
  IniIO,
  GIF,
  GIFImage,
  FTGifAnimate,
  ShellAPI,
  math,
  Clipbrd,
  Mass, EditStrut, MovieDlg, ImportImagesdlg, HelpFm, Roofdlg,
  EMAdlg,
  pngimage, ImportNodesDlg;

{$R *.DFM}
{$R RES.res}

const
  Ver = 1;
  VerSub = 1;
  RunBgCol = $FFFFC0;
  EditBgCol = $C0FFFF;
  clSelected: integer = $FF8080;
  clUnSelected: integer = $808080;
  colUnSelected: integer = 0;
  clDefault: integer = 0;
//  clSelectedSub = $C00000;
  clMuscle: integer = $0000C0;
  clCurMuscle: integer = clRed;
  clSectionGrid = $0080FF;
  clSymmetryGrid = $80FF00;
  curPOINT = 1;
  curHANDCLOSED = 2;
  curHANDOPEN = 3;
  curMakeSTRUT = 4;
  curPASTE = 5;
  curPLUS = 6;
  curColorTrian0 = 7;
  curColorTrian1 = 8;
  curColorTrian2 = 9;
  curMinus = 10;
  curMakeATOM = 11;
  MinRestLength = 8;
  FloorHeight = 1;
  GridSize = 8;
  szBase = 200;
  DefaultMass = 10;
  CaptureDist = 6;
  vk_Plus = vk_Shift;
  vk_Minus = vk_Control;
  vk_MakeStrut = ord('S');
  vk_MakeAtom = ord('A');
  vk_ScrollViewA = vk_Shift;
  vk_ScrollViewB = vk_Control;
  vk_Rotate = vk_Control; {with mouse wheel}
  zoom: single = 1;
  RoofMeshsize: array[TRoofAxes] of integer = (30,30,30,30,30,30);
  RoofN: array[TRoofAxes] of integer = (4,4,4,4,4,4);
  RoofColor: array[TRoofAxes] of TColor = ($8080FF,$8080FF,$8080FF,$8080FF,$8080FF,$8080FF);

var
  SymmetrySliceOnly: boolean;

function TForm1.PolygonNeglected(var Polygon: TPolygon): boolean;
begin
  with Polygon do
    if a[4] > 0 then
      result:=Atoms[a[1]].neglect or Atoms[a[2]].neglect or Atoms[a[3]].neglect or Atoms[a[4]].neglect else
      result:=Atoms[a[1]].neglect or Atoms[a[2]].neglect or Atoms[a[3]].neglect;
end;

procedure TForm1.SetPanelSizes(WL,HT: integer);
begin
  HT:=IntRange(HT,8,ClientHeight-12-Panel10.Height);
  WL:=IntRange(WL,8,ClientWidth-12-Panel9.Width);

  Panel12.Top:=HT;
  pnlXZ.Height:=HT;
  pnl3D.Height:=HT;
  Panel1.Width:=WL;

  pbYZ.Width:=pnlYZ.Width-2;
  pbYZ.Height:=pnlYZ.Height-2;
  pbXY.Width:=pnlXY.Width-2;
  pbXY.Height:=pnlXY.Height-2;
  pbXZ.Width:=pnlXZ.Width-2;
  pbXZ.Height:=pnlXZ.Height-2;
  pb3D.Width:=pnl3D.Width-2;
  pb3D.Height:=pnl3D.Height-2;

  imgYZ.Picture.Bitmap.Width:=pbYZ.ClientWidth;
  imgYZ.Picture.Bitmap.Height:=pbYZ.ClientHeight;
  imgYZ.ClientWidth:=pbYZ.ClientWidth;
  imgYZ.ClientHeight:=pbYZ.ClientHeight;

  imgXY.Picture.Bitmap.Width:=pbXY.ClientWidth;
  imgXY.Picture.Bitmap.Height:=pbXY.ClientHeight;
  imgXY.ClientWidth:=pbXY.ClientWidth;
  imgXY.ClientHeight:=pbXY.ClientHeight;

  imgXZ.Picture.Bitmap.Width:=pbXZ.ClientWidth;
  imgXZ.Picture.Bitmap.Height:=pbXZ.ClientHeight;
  imgXZ.ClientWidth:=pbXZ.ClientWidth;
  imgXZ.ClientHeight:=pbXZ.ClientHeight;

  img3D.Picture.Bitmap.Width:=pb3D.ClientWidth;
  img3D.Picture.Bitmap.Height:=pb3D.ClientHeight;
  img3D.ClientWidth:=pb3D.ClientWidth;
  img3D.ClientHeight:=pb3D.ClientHeight;
end;

procedure TForm1.Panel3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if ssLeft in Shift then
    SetPanelSizes(Panel1.Width,pnl3D.Height-y+3);
end;

procedure TForm1.Panel12MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if ssLeft in Shift then
    SetPanelSizes(Panel1.Width+x-3,Panel12.Top-y+3);
end;

procedure TForm1.Panel9MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if ssLeft in Shift then
    SetPanelSizes(Panel1.Width+x-3,pnl3D.Height);
end;

procedure TForm1.FormCreate(Sender: TObject);
var i,j: integer;
begin
  Undo:=Tstringlist.Create;
  bmpBGXYr:=TBitmap.Create;
  bmpBGXZr:=TBitmap.Create;
  bmpBGYZr:=TBitmap.Create;
  bmpBGXYe:=TBitmap.Create;
  bmpBGXZe:=TBitmap.Create;
  bmpBGYZe:=TBitmap.Create;
  sbmpBGXY:='';
  sbmpBGXZ:='';
  sbmpBGYZ:='';
  CurSection:=pl3D;
  OpenDialog1.InitialDir:=ExtractFilePath(ParamStr(0));
  SaveDialog1.InitialDir:=OpenDialog1.InitialDir;
  SaveDialog3.InitialDir:=OpenDialog1.InitialDir;
  OpenPictureDialog1.InitialDir:=OpenDialog1.InitialDir;
  SetMainFilename('');
  LoadSaveIniFile(true);
  Application.HelpFile:=ChangeFileExt(Paramstr(0),'.hlp');
  MouseMode:=mmNone;
  Application.OnMessage:=ProcessFormMessages;
  CurKeyframe:=-1;
  TimelineCurTime:=0;
  PixsIndex:=0.45;
  Modified:=false;
  AllImagesRead:=false;
  Yaw:=4;
  Pitch:=pi/16;
  SymmetryAxes:=pl3D;
  bOfs2DX:=0;
  aOfs2DY:=0;
  aOfs2DZ:=0;
  Ofs3DX:=0;
  Ofs3DY:=0;

  Screen.Cursors[curPOINT]:=LoadCursor(HInstance, 'POINT');
  Screen.Cursors[curPASTE]:=LoadCursor(HInstance, 'PASTE');
  Screen.Cursors[curHANDCLOSED]:=LoadCursor(HInstance, 'HANDCLOSED');
  Screen.Cursors[curHANDOPEN]:=LoadCursor(HInstance, 'HANDOPEN');
  Screen.Cursors[curMakeSTRUT]:=LoadCursor(HInstance, 'STRUT');
  Screen.Cursors[curMakeATOM]:=LoadCursor(HInstance, 'ATOM');
  Screen.Cursors[curPLUS]:=LoadCursor(HInstance, 'PLUS');
  Screen.Cursors[curMinus]:=LoadCursor(HInstance, 'MINUS');
  Screen.Cursors[curColorTrian0]:=LoadCursor(HInstance, 'CURCOLORTRIAN0');
  Screen.Cursors[curColorTrian1]:=LoadCursor(HInstance, 'CURCOLORTRIAN1');
  Screen.Cursors[curColorTrian2]:=LoadCursor(HInstance, 'CURCOLORTRIAN2');
  ClipboardKeyframe.TLTime:=-1;

//    SetLength(Spheroids,2);
//    with Spheroids[0] do begin R.x:=89; R.y:=89; R.z:=89; C.x:=0; C.y:=0; C.z:=90; end;
//    with Spheroids[1] do begin R.x:=50; R.y:=50; R.z:=100; C.x:=0; C.y:=0; C.z:=190; end;

  New1Click(nil);

  for i:=-RoofN[raZPos] to RoofN[raZPos] do
  for j:=-RoofN[raZPos] to RoofN[raZPos] do
  begin
    Roof[raZPos   ,i,j].h:=  400-i*i*2-j*j*2;
    Roof[raYPos ,i,j].h:=  250-i*i*2-j*j*2;
    Roof[raXNeg  ,i,j].h:=-(250-i*i*2-j*j*2);
    Roof[raXPos ,i,j].h:=  250-i*i*2-j*j*2;
    Roof[raZNeg,i,j].h:=  -20+i*i*2+j*j*2;
    Roof[raYNeg ,i,j].h:=-(250-i*i*2-j*j*2);
  end;

  OpenDialog1.InitialDir:=ExtractFileDir(paramstr(0));
  SaveDialog1.InitialDir:=ExtractFileDir(paramstr(0));
  LoadSaveIniFile(true);
  IsAtKeyframe;
end;

function TForm1.Proj2D(xyz: T3DPoint; Axes: TAxes): TSinglePoint;
begin
  case Axes of
    plXY: result:=SinglePoint(xyz.x+imgXY.Width/2,imgXY.Height/2 - xyz.y);
    plXZ: result:=SinglePoint(xyz.x+imgXZ.Width/2,imgXZ.Height-1-xyz.z);
    plYZ: result:=SinglePoint(xyz.y+imgYZ.Width/2,imgYZ.Height-1-xyz.z);
    pl3D: if Proj3D(xyz,result) <= 0 then result:=SinglePoint(maxint,maxint);
  end;
end;

function TForm1.Proj2DZoom(xyz: T3DPoint; Axes: TAxes): TPoint;
begin
  with Proj2D(xyz,Axes) do
    result:=ZoomScroll(x,y,Axes);
end;

function TForm1.UnProj2D(x,y: integer; Axes: TAxes): T3DPoint;
var d: FPnumber;
    z: integer;
begin
  if Axes = CurSection then
    z:=1 else
    z:=0;
  case Axes of
    plXY: result:=a3DPoint(x-imgXY.Width div 2,imgXY.Height div 2-y,z*ZSectionCoord);
    plXZ: result:=a3DPoint(x-imgXZ.Width div 2,z*YSectionCoord,imgXZ.Height-1-y);
    plYZ: result:=a3DPoint(z*XSectionCoord,x-imgYZ.Width div 2,imgYZ.Height-1-y);
    pl3D: assert(false);
  end;
end;

function TForm1.StrutColor(b: TStrutNum): TColor;
begin
  with Struts[b] do
  begin
    if Struts[b].Selected then
      result:=clSelected else
//    if StrutSelected(b) then
//      result:=clSelectedSub else
    if (musc = CurMuscle) and (musc >= 0) then
      result:=clCurMuscle else
    if Color > 0 then
      result:=Color else
    if Color > 0 then
      result:=clDefault else
    if musc < 0 then
      result:=colUnSelected else
      result:=clMuscle;
  end;
end;

procedure TForm1.PaintBoxPaint(aControl: TControl; aCanvas: TCanvas; Axes: TAxes);
var ShowForces: boolean;
  procedure DrawRubberBand;
  begin
    if (CurMode = tiEdit) and (MouseMode = mmMakingStrut) and (MovingAtom > 0) then
    with aControl,aCanvas do
    begin
      Pen.Color:=clSelected;
      MoveTo2D(aCanvas,Atoms[MovingAtom].p,Axes);
      with RubberBand do
        LineTo(x,y);
      Pen.Color:=clBlack;
    end;
  end;
  procedure DrawSelectionBox;
  begin
    with aControl,aCanvas do
    begin
      Pen.Color:=clBlack;
      with SelectRect do
      if Right <> Left then
      begin
        Pen.Style:=psDot;
        Brush.Style:=bsClear;
        Rectangle(Left,Top,Right,Bottom);
        Brush.Style:=bsSolid;
        Pen.Style:=psSolid;
      end;
    end;
  end;
  procedure DrawCentreAxes;
  begin
    with aControl,aCanvas do
    begin
      case Axes of
        plXZ: begin
                Pen.Color:=clSilver;
                MoveToZoom(aCanvas,aControl.Width div 2,0,Axes);
                LineToZoom(aCanvas,aControl.Width div 2,aControl.Height,Axes);
              end;
        plXY: begin
                Pen.Color:=clSilver;
                MoveToZoom(aCanvas,aControl.Width div 2,0,Axes);
                LineToZoom(aCanvas,aControl.Width div 2,aControl.Height,Axes);
                MoveToZoom(aCanvas,0,aControl.Height div 2,Axes);
                LineToZoom(aCanvas,aControl.Width,aControl.Height div 2,Axes);
              end;
        plYZ: begin
                Pen.Color:=clSilver;
                MoveToZoom(aCanvas,aControl.Width div 2,0,Axes);
                LineToZoom(aCanvas,aControl.Width div 2,aControl.Height,Axes);
              end;
      end;
    end;
  end;
  function DrawingSection: boolean;
  begin
    result:=false;
//    if CurMode = tiEdit then
    case Axes of
      plXZ: if CurSection = plXZ then result:=true;
      plXY: if CurSection = plXY then result:=true;
      plYZ: if CurSection = plYZ then result:=true;
    end;
  end;
  procedure DrawOneAtom(a: TAtomRef; outlined: boolean);
  var d: integer;
  begin
    with aControl,aCanvas do
    begin
      with Atoms[a] do
      if not neglect then
      with Proj2DZoom(p,Axes) do
      if not SymmetrySliceOnly or (Fixing = chSym) then
      begin
        if outlined then
        begin
          if ShowSectionJPG then
            Brush.Color:=clWhite else
            Brush.Color:=clBlack;
          d:=1;
          FillRect(rect(x-d-1,y-d-1,x+d+2,y+d+2));
        end else
          d:=2;
        if Selected then
          Brush.Color:=clSelected else
          Brush.Color:=colUnSelected;
        FillRect(rect(x-d,y-d,x+d+1,y+d+1));

        if EMA >= 0 then
        begin
          Pen.Width:=1;
          if not Selected then
            Brush.Color:=clMagenta;
          Pen.Color:=Brush.Color;
          ellipse(x-d-2,y-d-2,x+d+3,y+d+3);
          if InRange(EMA,1,NumAtoms) then
          begin
            Pen.Width:=3;
            MoveTo2D(aCanvas,p,Axes);
            LineTo2D(aCanvas,Scale3D(Add3D(p,Atoms[EMA].p),0.5),Axes);
            Pen.Width:=1;
          end;
        end;

        if ShowForces then
        begin
          Brush.Style:=bsClear;
          TextOut(x+2,y+2,inttostr(a));
          Brush.Style:=bsSolid;
        end;
        Brush.Color:=clBtnFace;
      end;
    end;
  end;
  procedure DrawAtoms;
  var a: TAtomRef;
      i: integer;
  begin
    FillEMA;
    if (CurMode = tiEdit) or ShowForces then
      for a:=1 to NumAtoms do
        DrawOneAtom(a,false);
  end;
  procedure DrawEPGTop;
  const sz = 5;
        gain = 5;
  var gaps: array[low(Roof[raZPos])*sz..high(Roof[raZPos])*sz,low(Roof[raZPos])*sz..high(Roof[raZPos])*sz] of single;
    procedure AddGap(x1,y1,g1,x2,y2,g2,x3,y3,g3: single);
    var i,j: integer;
        p,p1,p2,p3: TsinglePoint;
        q,px,py,d,g: single;
    begin
//      p1:=PointToSinglePoint(Proj2DZoom(a3DPoint(x1,y1,0),Axes));
      p1:=SinglePoint(x1,y1);
//      p2:=PointToSinglePoint(Proj2DZoom(a3DPoint(x2,y2,0),Axes));
      p2:=SinglePoint(x2,y2);
//      p3:=PointToSinglePoint(Proj2DZoom(a3DPoint(x3,y3,0),Axes));
      p3:=SinglePoint(x3,y3);
      g1:=g1*gain;
      g2:=g2*gain;
      g3:=g3*gain;
//      if (g1 < 255) or (g2 < 255) or (g3 < 255) then
      begin
        q:=(p3.y*(p1.x-p2.x))+(p2.y*(p3.x-p1.x))+(p1.y*(p2.x-p3.x));
        if q <> 0 then
        begin
          px:=((p2.y*(g3-g1))+(p1.y*(g2-g3))+(p3.y*(g1-g2)))/q;
          py:=((p1.x*(g3-g2))+(p2.x*(g1-g3))+(p3.x*(g2-g1)))/q;
          d:=g1-px*p1.x-py*p1.y;

          for i:=-RoofN[raZPos]*sz to RoofN[raZPos]*sz do
          for j:=-RoofN[raZPos]*sz to RoofN[raZPos]*sz do
          begin
//            p:=PointToSinglePoint(Proj2DZoom(a3DPoint(i*RoofMeshsize[raZPos]/sz,j*RoofMeshsize[raZPos]/sz,0),Axes));
            p:=SinglePoint(i*RoofMeshsize[raZPos]/sz,j*RoofMeshsize[raZPos]/sz);
            if PointInsideTriangleSingle(p,p1,p2,p3) then
              gaps[i,j]:=min(gaps[i,j],px*p.x + py*p.y + d);
          end;
        end;
      end;
    end;
    procedure DrawGaps;
    var i,j,k: integer;
        p: TPoint;
    begin
      with aCanvas do
      begin
        k:=round(zoom*RoofMeshsize[raZPos]/sz/2);
        for i:=-RoofN[raZPos]*sz to RoofN[raZPos]*sz do
        for j:=-RoofN[raZPos]*sz to RoofN[raZPos]*sz do
        if gaps[i,j] < 1000000 then
        begin
          pen.color:=round(RealRange(gaps[i,j],0,255))*$10101;
          p:=Proj2DZoom(a3DPoint(i*RoofMeshsize[raZPos]/sz,j*RoofMeshsize[raZPos]/sz,0),Axes);
          DrawSquareFilled(aCanvas,p.x,p.y,k);

          case SymmetryAxes of
            plYZ:
              begin
                p:=Proj2DZoom(a3DPoint(
                2*SymmetryCoord/RoofMeshsize[raZPos]-i*RoofMeshsize[raZPos]/sz,
                j*RoofMeshsize[raZPos]/sz,0),Axes);
                DrawSquareFilled(aCanvas,p.x,p.y,k);
              end;
            plXZ:
              begin
                p:=Proj2DZoom(a3DPoint(
                i*RoofMeshsize[raZPos]/sz,
                2*SymmetryCoord/RoofMeshsize[raZPos]-j*RoofMeshsize[raZPos]/sz,0),Axes);
                DrawSquareFilled(aCanvas,p.x,p.y,k);
              end;
          end;
        end;
      end;
    end;
  var a: TAtomRef;
  var pg,i,j: integer;
      p1,p2: TPoint;
  begin
    if ShowClosure1.Checked then
    if CurMode <> tiEdit then
    if HasConstraint[raZPos] then
    if Axes = plXY then
    begin
      for i:=-RoofN[raZPos]*sz to RoofN[raZPos]*sz do
        for j:=-RoofN[raZPos]*sz to RoofN[raZPos]*sz do
          gaps[i,j]:=maxint;

      for a:=1 to NumAtoms do
        with Atoms[a],p do
          gap:=RoofPosZPos(x,y)-z;

      for pg:=0 to high(Polygons) do
      with Polygons[pg] do
      begin
        AddGap(Atoms[a[1]].p.x,Atoms[a[1]].p.y,Atoms[a[1]].gap,Atoms[a[2]].p.x,Atoms[a[2]].p.y,Atoms[a[2]].gap,Atoms[a[3]].p.x,Atoms[a[3]].p.y,Atoms[a[3]].gap);
        if a[4] > 0 then
          AddGap(Atoms[a[1]].p.x,Atoms[a[1]].p.y,Atoms[a[1]].gap,Atoms[a[4]].p.x,Atoms[a[4]].p.y,Atoms[a[4]].gap,Atoms[a[3]].p.x,Atoms[a[3]].p.y,Atoms[a[3]].gap);
      end;

      DrawGaps;
    end;
  end;
  procedure DrawOneRoofPoint(RoofAxes: TRoofAxes; i,j: integer);
  begin
    with aControl,aCanvas do
      with MeshPoint2D(RoofAxes,i,j,Axes) do
      begin
        if Roof[RoofAxes,i,j].Selected then
          Brush.Color:=clSelected else
          Brush.Color:=RoofColor[RoofAxes];
        FillRect(rect(x-1-1,y-1-1,x+1+2,y+1+2));
        Brush.Color:=clBtnFace;
      end;
  end;
  procedure DrawRoof(RoofAxes: TRoofAxes);
  var i,j: integer;
  begin
    with aControl,aCanvas do
    begin
      Pen.Color:=RoofColor[RoofAxes];
      for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
      for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
      begin
        MoveTo2D(aCanvas,MeshPoint3D(RoofAxes,i,j),Axes);
        if i < RoofN[RoofAxes] then
          LineTo2D(aCanvas,MeshPoint3D(RoofAxes,i+1,j),Axes);
        MoveTo2D(aCanvas,MeshPoint3D(RoofAxes,i,j),Axes);
        if j < RoofN[RoofAxes] then
          LineTo2D(aCanvas,MeshPoint3D(RoofAxes,i,j+1),Axes);
        DrawOneRoofPoint(RoofAxes,i,j);
      end;
    end;
  end;
  procedure DrawStruts;
  var b: TStrutRef;
  begin
    with aControl,aCanvas do
    begin
      for b:=1 to NumStruts do
      with Struts[b] do
      if not SymmetrySliceOnly or ((Atoms[Atom1].Fixing = chSym) and (Atoms[Atom2].Fixing = chSym)) then
      if not Atoms[Atom1].neglect and not Atoms[Atom2].neglect then
      begin
        Pen.Color:=StrutColor(b);
        MoveTo2D(aCanvas,Atoms[Atom1].p,Axes);
        LineTo2D(aCanvas,Atoms[Atom2].p,Axes);
      end;
    end;
  end;
  procedure DrawSpheroids;
  var i,j,s: integer;
      h: single;
      p1,p2: TPoint;
  begin
    with aControl,aCanvas do
    begin
      Pen.Color:=clmagenta;
      Pen.Width:=2;
      for s:=low(Spheroids) to high(Spheroids) do
      with Spheroids[s] do
      begin
        case Axes of
          plXY: begin p1:=Proj2DZoom(a3DPoint(C.x+R.x,C.y+R.y,0),Axes); p2:=Proj2DZoom(a3DPoint(C.x-R.x,C.y-R.y,0),Axes); end;
          plXZ: begin p1:=Proj2DZoom(a3DPoint(C.X+R.X,0,C.Z+R.Z),Axes); p2:=Proj2DZoom(a3DPoint(C.x-R.x,0,C.Z-R.Z),Axes); end;
          plYZ: begin p1:=Proj2DZoom(a3DPoint(0,C.Y+R.Y,C.Z+R.Z),Axes); p2:=Proj2DZoom(a3DPoint(0,C.y-R.y,C.Z-R.Z),Axes); end;
        end;
        Brush.Style:=bsClear;
        ellipse(p1.x,p1.y,p2.x,p2.y);
        Brush.Style:=bsSolid;
      end;
      Pen.Color:=clBlack;
      Pen.Width:=1;
    end;
  end;
  procedure DrawPolygons(Axes: TAxes; dPlane: single);
  var lines: array[1..20] of record L1,L2: T3dPoint; end;
      force: T3dPoint;
      nlines: integer;
    procedure DrawIntesectLines(a1,a2,a3: TAtomNum);
      function DistPointToPlane(p: T3DPoint): single;
      begin
        case Axes of
          plXY: result:=p.z-dPlane;
          plXZ: result:=p.y-dPlane;
          plYZ: result:=p.x-dPlane;
        end;
      end;
      function IntersectionOfLineAndPlane(p1,p2: T3DPoint): T3DPoint;
      begin
        case Axes of
          plXY: result:=a3DPoint(((p2.x*(p1.z - dPlane)) + (p1.x*(dPlane - p2.z)))/(p1.z - p2.z), ((p2.y*(p1.z - dPlane)) + (p1.y*(dPlane - p2.z)))/(p1.z - p2.z), dPlane                                                         );
          plXZ: result:=a3DPoint(((p2.x*(p1.y - dPlane)) + (p1.x*(dPlane - p2.y)))/(p1.y - p2.y), dPlane,                                                          ((p2.z*(p1.y - dPlane)) + (p1.z*(dPlane - p2.y)))/(p1.y - p2.y));
          plYZ: result:=a3DPoint(dPlane,                                                          ((p2.y*(p1.x - dPlane)) + (p1.y*(dPlane - p2.x)))/(p1.x - p2.x), ((p2.z*(p1.x - dPlane)) + (p1.z*(dPlane - p2.x)))/(p1.x - p2.x));
        end;
      end;
    var a,b: T3DPoint;
        p1,p2,p3: T3DPoint;
        d2: single;
    begin
      p1:=Atoms[a1].p;
      p2:=Atoms[a2].p;
      p3:=Atoms[a3].p;
      d2:=DistPointToPlane(p2);

      if d2 <> 0 then
      if (DistPointToPlane(p1)*d2 <= 0) and (DistPointToPlane(p3)*d2 <= 0) then
      begin
        a:=IntersectionOfLineAndPlane(p1,p2);
        b:=IntersectionOfLineAndPlane(p3,p2);
        MoveTo2D(aCanvas,a,Axes);
        LineTo2D(aCanvas,b,Axes);
        inc(nlines);
        lines[nlines].L1:=a;
        lines[nlines].L2:=b;
      end;
    end;
    procedure DrawIntersectTriangle(a1,a2,a3: integer);
    begin
      DrawIntesectLines(a1,a2,a3);
      DrawIntesectLines(a2,a3,a1);
      DrawIntesectLines(a3,a1,a2);
    end;
    procedure AddForce(a: TAtomNum);
    begin
      force:=Add3D(force,Atoms[a].af);
    end;
    procedure DrawPolygon(pg: integer);
    var e: integer;
    begin
      with Polygons[pg] do
      if not PolygonNeglected(Polygons[pg]) then
      begin
        if a[4] = 0 then
        begin
          DrawIntersectTriangle(a[1],a[2],a[3]);
        end else
        begin
          for e:=low(a) to high(a)-2 do
            DrawIntersectTriangle(a[low(a)],a[e+1],a[e+2]);
        end;
      end;
    end;
    procedure PolygonForces(pg: integer);
    var e: integer;
    begin
      with Polygons[pg] do
      if not PolygonNeglected(Polygons[pg]) then
      begin
        if a[4] = 0 then
        begin
          AddForce(a[1]);
          AddForce(a[2]);
          AddForce(a[3]);
        end else
        begin
          AddForce(a[1]);
          AddForce(a[2]);
          AddForce(a[3]);
          AddForce(a[4]);
        end;
      end;
    end;
    procedure OutlinePolygons;
    var e,pg: integer;
    begin
      for pg:=0 to high(Polygons) do
      begin
        force:=Zero3DPoint;
        nlines:=0;
        if not PolygonNeglected(Polygons[pg]) then
          DrawPolygon(pg);
      end;
    end;
    procedure FillPolyhedra(bFill: boolean);
    var ph: integer;
      procedure Periphery(force: T3dPoint; forceScale,pressure,PressureMax: single);
      var i: integer;
          Poly1: array of TPoint;
          ch,cl: TColor;
      begin
        with aControl,aCanvas do
        begin
          for i:=1 to nlines-1 do
            if Dist3D(lines[i].L2,lines[i+1].L1) > 0.1 then
              exit;
          if Dist3D(lines[nlines].L2,lines[1].L1) > 0.1 then
            exit;

          Setlength(Poly1,nlines);
          for i:=1 to nlines do
            Poly1[i-1]:=Proj2DZoom(lines[i].L1,Axes);
          if dlgOptions.cbDisplayPressure.Checked then
          begin
            ch:=dlgOptions.pnlColorPressureHigh.Color;
            cl:=dlgOptions.pnlColorPressureLow.Color;
            Brush.Color:=RGB(
              round((Red  (ch)-Red  (cl))*RealRange(pressure/PressureMax,0,1)+Red  (cl)),
              round((Green(ch)-Green(cl))*RealRange(pressure/PressureMax,0,1)+Green(cl)),
              round((Blue (ch)-Blue (cl))*RealRange(pressure/PressureMax,0,1)+Blue (cl)));

            if bFill then
              FillPoly(aCanvas,Poly1);

            MoveTo2D(aCanvas,lines[nlines].L1,Axes);
            for i:=1 to nlines do
              LineTo2D(aCanvas,lines[i].L1,Axes);
          end;

          if not bFill then
          if dlgOptions.cbDisplayForces.Checked then
          begin
            pen.color:=dlgOptions.pnlColorForces.Color;
            with CoGPoly(Poly1) do
            begin
              DrawCircleFilled(aCanvas,round(x),round(y),3);
              MoveTo(round(x),round(y));
              case Axes of
                plXY: LineTo(round(x+force.x*forceScale),round(y-force.y*forceScale));
                plXZ: LineTo(round(x+force.x*forceScale),round(y-force.z*forceScale));
                plYZ: LineTo(round(x+force.y*forceScale),round(y-force.z*forceScale));
              end;
            end;
            pen.color:=clBlack;
          end;
        end;
      end;
    var f,i,j,phz: integer;
        a: T3dPoint;
        PressureMax: single;
        ForcesScale: single;
    begin
      PressureMax:=dlgOptions.sePressureMax.Value;
      ForcesScale:=dlgOptions.seForcesScale.Value;

      for ph:=0 to high(Polyhedron) do
      begin
//if ph = 17 then
//randseed:=randseed;
        force:=Zero3DPoint;
        nlines:=0;
        for f:=0 to high(Polyhedron[ph].PosFace) do
        begin
          DrawPolygon(Polyhedron[ph].PosFace[f]);
          PolygonForces(Polyhedron[ph].PosFace[f]);
        end;
        for f:=0 to high(Polyhedron[ph].NegFace) do
        begin
          DrawPolygon(Polyhedron[ph].NegFace[f]);
          PolygonForces(Polyhedron[ph].NegFace[f]);
        end;
        if nlines > 2 then
        begin
          for i:=1 to nlines-1 do
          begin
            for j:=i+1 to nlines do
            begin
              if Dist3D(lines[i].L2,lines[j].L2) < Dist3D(lines[i].L2,lines[j].L1) then
              begin
                a:=lines[j].L2;
                lines[j].L2:=lines[j].L1;
                lines[j].L1:=a;
              end;

              if Dist3D(lines[i].L2,lines[j].L1) < Dist3D(lines[i].L2,lines[i+1].L1) then
              begin
                a:=lines[j].L1;
                lines[j].L1:=lines[i+1].L1;
                lines[i+1].L1:=a;
                a:=lines[j].L2;
                lines[j].L2:=lines[i+1].L2;
                lines[i+1].L2:=a;
              end;
            end;
          end;

          Periphery(force,ForcesScale,Polyhedron[ph].pressure,PressureMax);
        end;
      end;
    end;
    procedure DrawStrutForces;
    var ForcesScale: single;
      procedure DrawForce(a1,a2: TAtomRef; v: single);
      var p: TPoint;
          f: T3DPoint;
      begin
        with aControl,aCanvas do
        begin
          p:=Proj2DZoom(Add3D(Scale3D(Sub3D(Atoms[a2].p,Atoms[a1].p),v),Atoms[a1].p),Axes);
          f:=Scale3D(Add3D(Scale3D(Sub3D(Atoms[a2].af,Atoms[a1].af),v),Atoms[a1].af),forcesScale);
          if InRealRange(v,0.2,0.8) then
            DrawCircleFilled(aCanvas,p.x,p.y,3);
          pen.color:=dlgOptions.pnlColorForces.Color;

          MoveTo(p.x,p.y);
          case Axes of
            plXY: LineTo(round(p.x+f.x),round(p.y-f.y));
            plXZ: LineTo(round(p.x+f.x),round(p.y-f.z));
            plYZ: LineTo(round(p.x+f.y),round(p.y-f.z));
          end;
        end;
      end;
{
      procedure DrawAtomForces(v,z1,z2: single; a1,a2: TAtomRef);
      begin
        if AtomNearCurSection(a1) then
//        if v = z1 then
          DrawForce(a1,a1,0);
        if AtomNearCurSection(a2) then
//        if v = z2 then
          DrawForce(a2,a2,0);
        if (v > z1) and (v < z2) then
          DrawForce(a1,a2,(v-z1)/(z2-z1));
        if (v > z2) and (v < z1) then
          DrawForce(a2,a1,(v-z2)/(z1-z2));
      end;
}
      procedure DrawAtomForces(v,z1,z2: single; a1,a2: TAtomRef);
      begin
        if AtomNearCurSection(a1) then
          DrawForce(a1,a1,0);
        if AtomNearCurSection(a2) then
          DrawForce(a2,a2,0);
//        if not AtomNearCurSection(a1) and not AtomNearCurSection(a2) then
        begin
          if (v > z1) and (v < z2) then
            DrawForce(a1,a2,(v-z1)/(z2-z1));
          if (v > z2) and (v < z1) then
            DrawForce(a2,a1,(v-z2)/(z1-z2));
        end;
      end;
    var b: TStrutRef;
    begin
      ForcesScale:=dlgOptions.seForcesScale.Value;
      for b:=1 to NumStruts do
      with Struts[b] do
      if not Atoms[Atom1].neglect and not Atoms[Atom2].neglect then
      if Axis <> axNone then
      case Axes of
        plXZ: DrawAtomForces(dPlane,Atoms[Atom1].p.y,Atoms[Atom2].p.y,Atom1,Atom2);
        plXY: DrawAtomForces(dPlane,Atoms[Atom1].p.z,Atoms[Atom2].p.z,Atom1,Atom2);
        plYZ: DrawAtomForces(dPlane,Atoms[Atom1].p.x,Atoms[Atom2].p.x,Atom1,Atom2);
      end;
    end;
  var ph,pg,f,e: integer;
      a: TAtomRef;
  begin
    if (CurMode = tiRun) and (dlgOptions.cbDisplayForces.Checked or dlgOptions.cbDisplayPressure.Checked) then
    begin
      if dlgOptions.cbDisplayPressure.Checked then
        FillPolyhedra(true);
      if dlgOptions.cbDisplayForces.Checked then
//          FillPolyhedra(false);
        DrawStrutForces;
    end else
      OutlinePolygons;

    for a:=1 to NumAtoms do
      if AtomNearCurSection(a) then
        DrawOneAtom(a,true);
  end;
  procedure DrawRoofSection(Axes: TAxes; RoofAxes: TRoofAxes; dPlane: single);
    function DrawTrianContour2(p1,p2,p3: T3DPoint): boolean;
    var qa,qb: T3DPoint;
    begin
      qa.z:=zSectionCoord;
      qb.z:=zSectionCoord;
      result:=((p1.z >= qa.z) and (p2.z < qa.z) and (p3.z < qa.z)) or
              ((p1.z <= qa.z) and (p2.z > qa.z) and (p3.z > qa.z));
      if result then
      begin
        qa.x:=(qa.z-p1.z)/(p2.z-p1.z)*(p2.x-p1.x)+p1.x;
        qa.y:=(qa.z-p1.z)/(p2.z-p1.z)*(p2.y-p1.y)+p1.y;
        qb.x:=(qb.z-p1.z)/(p3.z-p1.z)*(p3.x-p1.x)+p1.x;
        qb.y:=(qb.z-p1.z)/(p3.z-p1.z)*(p3.y-p1.y)+p1.y;
        MoveTo2D(aCanvas,qa,Axes);
        LineTo2D(aCanvas,qb,Axes);
      end else
    end;
    procedure DrawTrianContour(p1,p2,p3: T3DPoint);
    begin
      if p1.z = zSectionCoord then p1.z:=p1.z+0.001;
      if p2.z = zSectionCoord then p2.z:=p2.z+0.001;
      if p3.z = zSectionCoord then p3.z:=p3.z+0.001;
      if DrawTrianContour2(p1,p2,p3) or
         DrawTrianContour2(p2,p3,p1) or
         DrawTrianContour2(p3,p1,p2) then ;
    end;
  var pg,e,i,j: integer;
      a,ax,bx: single;
      p1,p2,p3,p4,p5: T3DPoint;
  begin
    with aControl,aCanvas do
    begin
      case CurSection of
        plXY:
          begin
            for i:=-RoofN[RoofAxes] to RoofN[RoofAxes]-1 do
            for j:=-RoofN[RoofAxes] to RoofN[RoofAxes]-1 do
            begin
              p1:=MeshPoint3D(RoofAxes,i,j);
              p2:=MeshPoint3D(RoofAxes,i,j+1);
              p3:=MeshPoint3D(RoofAxes,i+1,j+1);
              p4:=MeshPoint3D(RoofAxes,i+1,j);
              p5:=a3DPoint((p1.x+p2.x+p3.x+p4.x)/4,(p1.y+p2.y+p3.y+p4.y)/4,(p1.z+p2.z+p3.z+p4.z)/4);
              DrawTrianContour(p1,p2,p5);
              DrawTrianContour(p2,p3,p5);
              DrawTrianContour(p3,p4,p5);
              DrawTrianContour(p4,p1,p5);
            end;
          end;
        plXZ:
          begin
            for j:=-RoofN[RoofAxes] to RoofN[RoofAxes]-1 do
            if (ySectionCoord >= j*RoofMeshsize[RoofAxes]) and (ySectionCoord <= (j+1)*RoofMeshsize[RoofAxes]) then
            begin
              ax:=j*RoofMeshsize[RoofAxes];
              bx:=(j+1)*RoofMeshsize[RoofAxes];
              a:=(ySectionCoord-ax)/(bx-ax);
              for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
                if i = -RoofN[RoofAxes] then
                  MoveTo2D(aCanvas,a3DPoint(i*RoofMeshsize[RoofAxes],ax,Roof[RoofAxes,i,j].h+(Roof[RoofAxes,i,j+1].h-Roof[RoofAxes,i,j].h)*a),Axes) else
                  LineTo2D(aCanvas,a3DPoint(i*RoofMeshsize[RoofAxes],ax,Roof[RoofAxes,i,j].h+(Roof[RoofAxes,i,j+1].h-Roof[RoofAxes,i,j].h)*a),Axes);
            end;
          end;
        plYZ:
          begin
            for i:=-RoofN[RoofAxes] to RoofN[RoofAxes]-1 do
            if (xSectionCoord >= i*RoofMeshsize[RoofAxes]) and (xSectionCoord <= (i+1)*RoofMeshsize[RoofAxes]) then
            begin
              ax:=i*RoofMeshsize[RoofAxes];
              bx:=(i+1)*RoofMeshsize[RoofAxes];
              a:=(xSectionCoord-ax)/(bx-ax);
              for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
                if j = -RoofN[RoofAxes] then
                  MoveTo2D(aCanvas,a3DPoint(ax,j*RoofMeshsize[RoofAxes],Roof[RoofAxes,i,j].h+(Roof[RoofAxes,i+1,j].h-Roof[RoofAxes,i,j].h)*a),Axes) else
                  LineTo2D(aCanvas,a3DPoint(ax,j*RoofMeshsize[RoofAxes],Roof[RoofAxes,i,j].h+(Roof[RoofAxes,i+1,j].h-Roof[RoofAxes,i,j].h)*a),Axes);
            end;
          end;
      end;
      for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
        for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
          if RoofNearCurSection(RoofAxes,i,j) then
            DrawOneRoofPoint(RoofAxes,i,j);
    end;
  end;
  procedure DrawSymmetry;
  begin
    with aControl,aCanvas do
    begin
      pen.Color:=clSymmetryGrid;
      brush.Color:=clWhite;
      pen.style:=psDash;
      Brush.Style:=bsClear;
      case Axes of
        plXZ: case SymmetryAxes of
                plXY:
                  begin
                    MoveTo2D(aCanvas,a3DPoint(-szBase,0,SymmetryCoord),Axes);
                    LineTo2D(aCanvas,a3DPoint(+szBase,0,SymmetryCoord),Axes);
                  end;
                plYZ:
                  begin
                    MoveTo2D(aCanvas,a3DPoint(SymmetryCoord,0,0),Axes);
                    LineTo2D(aCanvas,a3DPoint(SymmetryCoord,0,2*szBase),Axes);
                  end;
              end;
        plXY: case SymmetryAxes of
                plXZ:
                  begin
                    MoveTo2D(aCanvas,a3DPoint(-szBase,SymmetryCoord,0),Axes);
                    LineTo2D(aCanvas,a3DPoint(+szBase,SymmetryCoord,0),Axes);
                  end;
                plYZ:
                  begin
                    MoveTo2D(aCanvas,a3DPoint(SymmetryCoord,-szBase,0),Axes);
                    LineTo2D(aCanvas,a3DPoint(SymmetryCoord,+szBase,0),Axes);
                  end;
              end;
        plYZ: case SymmetryAxes of
                plXY:
                  begin
                    MoveTo2D(aCanvas,a3DPoint(0,-szBase,SymmetryCoord),Axes);
                    LineTo2D(aCanvas,a3DPoint(0,+szBase,SymmetryCoord),Axes);
                  end;
                plXZ:
                  begin
                    MoveTo2D(aCanvas,a3DPoint(0,SymmetryCoord,-szBase),Axes);
                    LineTo2D(aCanvas,a3DPoint(0,SymmetryCoord,+szBase),Axes);
                  end;
              end;
      end;
      pen.Color:=clBlack;
      brush.Color:=clWhite;
      pen.style:=psSolid;
      Brush.Style:=bsSolid;
    end;
  end;
  procedure DrawSectionBG(DrawSection: boolean);
  var aRect: TRect;
      pix: TPix;
  begin
    with aControl,aCanvas do
    begin
      Pen.Color:=clBlack;
      Brush.Color:=DarkenColorEx(pnlYZ.Color,10);

      if (CurSection <> pl3D) and ShowSectionJPG and not AllImagesRead then
      if dlgImportImages <> nil then
      begin
        AllImagesRead:=true;
        dlgImportImages.ReadAllImageFiles;
      end;

      aRect:=SectionRect(Axes);
      if dlgImportImages <> nil then
      with dlgImportImages do
      case Axes of
        plXZ: case CurSection of
                plXY:
                  begin
                    if DrawSection then
                      FillRectZoom(aCanvas,aRect.Left,aRect.Top,aRect.Right,aRect.Bottom,Axes);
                    if CurMode = tiEdit then
                      DrawZoom(aCanvas,aRect.Left,aRect.Top,bmpBGXZe,Axes) else
                      DrawZoom(aCanvas,aRect.Left,aRect.Top,bmpBGXZr,Axes);
                    DrawCentreAxes;
                    pen.Color:=clSectionGrid;
                    aCanvas.brush.Color:=clWhite;
                    pen.style:=psDash;
                    aCanvas.Brush.Style:=bsSolid;
                    MoveToZoom(aCanvas,aRect.Left,vPixsCoord(Axes),Axes);
                    LineToZoom(aCanvas,aRect.Right,vPixsCoord(Axes),Axes);
                  end;
                plXZ:
                  if ShowSectionJPG then
                  if length(dlgImportImages.Pixs) > 0 then
                  if DrawSection then
                  begin
                    Pix:=GetXZPixImage(PixsIndex);
                    PixDrawZoom(aCanvas,(aControl.Width-Pix.Width) div 2,aControl.Height-Pix.Height,Pix,Axes);
                  end;
                plYZ:
                  begin
                    if DrawSection then
                      FillRectZoom(aCanvas,aRect.Left,aRect.Top,aRect.Right,aRect.Bottom,Axes);
                    if CurMode = tiEdit then
                      DrawZoom(aCanvas,aRect.Left,aRect.Top,bmpBGXZe,Axes) else
                      DrawZoom(aCanvas,aRect.Left,aRect.Top,bmpBGXZr,Axes);
                    DrawCentreAxes;
                    pen.Color:=clSectionGrid;
                    aCanvas.brush.Color:=clWhite;
                    pen.style:=psDash;
                    aCanvas.Brush.Style:=bsSolid;
                    MoveToZoom(aCanvas,uPixsCoord(Axes),aRect.Top,Axes);
                    LineToZoom(aCanvas,uPixsCoord(Axes),aRect.Bottom,Axes);
                  end
                else
                  begin
                    if CurMode = tiEdit then
                      DrawZoom(aCanvas,aRect.Left,aRect.Top,bmpBGXZe,Axes) else
                      DrawZoom(aCanvas,aRect.Left,aRect.Top,bmpBGXZr,Axes);
                    DrawCentreAxes;
                  end;
              end;
        plXY: case CurSection of
                plXY:
                  if ShowSectionJPG then
                  if length(dlgImportImages.Pixs) > 0 then
                  if DrawSection then
                  begin
                    Pix:=GetXYPixImage(PixsIndex);
                    PixDrawZoom(aCanvas,(aControl.width-Pix.width) div 2,(aControl.Height-Pix.Height) div 2,Pix,Axes);
                  end;
                plXZ:
                  begin
                    if DrawSection then
                      FillRectZoom(aCanvas,aRect.Left,aRect.Top,aRect.Right,aRect.Bottom,Axes);
                    if CurMode = tiEdit then
                      DrawZoom(aCanvas,aRect.Left,aRect.Top,bmpBGXYe,Axes) else
                      DrawZoom(aCanvas,aRect.Left,aRect.Top,bmpBGXYr,Axes);
                    DrawCentreAxes;
                    pen.Color:=clSectionGrid;
                    aCanvas.brush.Color:=clWhite;
                    pen.style:=psDash;
                    MoveToZoom(aCanvas,aRect.Left,vPixsCoord(Axes),Axes);
                    LineToZoom(aCanvas,aRect.Right,vPixsCoord(Axes),Axes);
                  end;
                plYZ:
                  begin
                    if DrawSection then
                      FillRectZoom(aCanvas,aRect.Left,aRect.Top,aRect.Right,aRect.Bottom,Axes);
                    if CurMode = tiEdit then
                      DrawZoom(aCanvas,aRect.Left,aRect.Top,bmpBGXYe,Axes) else
                      DrawZoom(aCanvas,aRect.Left,aRect.Top,bmpBGXYr,Axes);
                    DrawCentreAxes;
                    pen.Color:=clSectionGrid;
                    aCanvas.Brush.Color:=clWhite;
                    pen.style:=psDash;
                    MoveToZoom(aCanvas,uPixsCoord(Axes),aRect.Top,Axes);
                    LineToZoom(aCanvas,uPixsCoord(Axes),aRect.Bottom,Axes);
                  end
                else
                  begin
                    if CurMode = tiEdit then
                      DrawZoom(aCanvas,aRect.Left,aRect.Top,bmpBGXYe,Axes) else
                      DrawZoom(aCanvas,aRect.Left,aRect.Top,bmpBGXYr,Axes);
                    DrawCentreAxes;
                  end;
              end;
        plYZ: case CurSection of
                plXY:
                  begin
                    if DrawSection then
                      FillRectZoom(aCanvas,aRect.Left,aRect.Top,aRect.Right,aRect.Bottom,Axes);
                    if CurMode = tiEdit then
                      DrawZoom(aCanvas,aRect.Left,aRect.Top,bmpBGYZe,Axes) else
                      DrawZoom(aCanvas,aRect.Left,aRect.Top,bmpBGYZr,Axes);
                    DrawCentreAxes;
                    pen.Color:=clSectionGrid;
                    aCanvas.Brush.Color:=clWhite;
                    pen.style:=psDash;
                    aCanvas.Brush.style:=bsSolid;
                    MoveToZoom(aCanvas,aRect.Left,vPixsCoord(Axes),Axes);
                    LineToZoom(aCanvas,aRect.Right,vPixsCoord(Axes),Axes);
                  end;
                plXZ:
                  begin
                    if DrawSection then
                      FillRectZoom(aCanvas,aRect.Left,aRect.Top,aRect.Right,aRect.Bottom,Axes);
                    if CurMode = tiEdit then
                      DrawZoom(aCanvas,aRect.Left,aRect.Top,bmpBGYZe,Axes) else
                      DrawZoom(aCanvas,aRect.Left,aRect.Top,bmpBGYZr,Axes);
                    DrawCentreAxes;
                    pen.Color:=clSectionGrid;
                    aCanvas.Brush.Color:=clWhite;
                    pen.style:=psDash;
                    aCanvas.Brush.style:=bsSolid;
                    MoveToZoom(aCanvas,uPixsCoord(Axes),aRect.Top,Axes);
                    LineToZoom(aCanvas,uPixsCoord(Axes),aRect.Bottom,Axes);
                  end;
                plYZ:
                  if ShowSectionJPG then
                  if length(dlgImportImages.Pixs) > 0 then
                  if DrawSection then
                  begin
                    Pix:=GetYZPixImage(PixsIndex);
                    PixDrawZoom(aCanvas,(aControl.width-Pix.width) div 2,aControl.Height-Pix.Height,Pix,Axes);
                  end;
                else
                  begin
                    if CurMode = tiEdit then
                      DrawZoom(aCanvas,aRect.Left,aRect.Top,bmpBGYZe,Axes) else
                      DrawZoom(aCanvas,aRect.Left,aRect.Top,bmpBGYZr,Axes);
                    DrawCentreAxes;
                  end;
              end;
      end;
    end;
  end;
  procedure DrawZoomRotate;
  begin
    with aControl,aCanvas do
    begin
      Pen.Color:=clGray;
      if Axes = MouseModeAxes then
      case MouseMode of
        mmRotating:
          with pMouseDown do
          begin
            Moveto(x-30,y);
            Lineto(x+30,y);
            Moveto(x,y-30);
            Lineto(x,y+30);
            Brush.Style:=bsClear;
            Ellipse(x-15,y-15,x+15,y+15); 
            Pen.Style:=psSolid;
          end;
        mmZooming:
          begin
            DrawArrow(aCanvas,pMouseDown.x,pMouseDown.y,pMouseDown.x-20,pMouseDown.y-20,5,5);
            DrawArrow(aCanvas,pMouseDown.x,pMouseDown.y,pMouseDown.x-20,pMouseDown.y+20,5,5);
            DrawArrow(aCanvas,pMouseDown.x,pMouseDown.y,pMouseDown.x+20,pMouseDown.y-20,5,5);
            DrawArrow(aCanvas,pMouseDown.x,pMouseDown.y,pMouseDown.x+20,pMouseDown.y+20,5,5);
          end;
      end;
    end;
  end;
var x,y,i,j: integer;
    a: TAtomRef;
    b: TStrutRef;
    RoofAxes: TRoofAxes;
begin
  ShowForces:=ShowAtomNums1.Checked;

  with aControl,aCanvas do
  if (Width > 16) and (Height > 16) then
  begin
    if dlgOptions <> nil then
    begin
      clSelected:=dlgOptions.pnlColorSelect.Color;
      clUnSelected:=dlgOptions.pnlColorUnselect.Color;
      clDefault:=dlgOptions.pnlColorDefault.Color;
      clMuscle:=dlgOptions.pnlColorMuscle.Color;
      clCurMuscle:=dlgOptions.pnlColorSelMuscle.Color;
      if NumSelectedAtoms+NumSelectedStruts > 0 then
        colUnSelected:=clUnSelected else
        colUnSelected:=clDefault;
    end;

    Brush.Color:=pnlYZ.Color;
    FillRect(ClientRect);

    DrawSectionBG(CurMode = tiEdit);
    if CurMode = tiEdit then
    begin
      DrawSymmetry;
    end;
    Pen.Color:=clBlack;
    pen.style:=psSolid;

    if CurMode = tiEdit then
    begin
      Pen.Color:=clBlack;
      if (dlgOptions <> nil) and dlgOptions.cbSnap.Checked then
      begin
        for i:=-100 to +100 do
        for j:=-100 to +100 do
        begin
          case Axes of
            plXZ: begin
                    x:=round(zoom*(aControl.Width div 2+GridSize*i))+cOfs2DX;
                    y:=round(zoom*(aControl.Height-GridSize*j-1))+cOfs2DZ;
                  end;
            plXY: begin
                    x:=round(zoom*(aControl.Width div 2+GridSize*i))+bOfs2DX;
                    y:=round(zoom*(aControl.Height div 2-GridSize*j))+bOfs2DY;
                  end;
            plYZ: begin
                    x:=round(zoom*(aControl.Width div 2+GridSize*i))+aOfs2DY;
                    y:=round(zoom*(aControl.Height-GridSize*j-1))+aOfs2DZ;
                  end;
          end;
          Pixels[x,y]:=clBlack;
        end;
      end;
    end;

    if CurMode = tiEdit then
    begin
      Font.Color:=clGray;
      Pen.Color:=clGray;
      Brush.Style:=bsClear;
      case Axes of
        plXY:
          begin
            MoveTo(4,Height-1-20);
            LineTo(4,Height-1-4);
            LineTo(20+1,Height-1-4);
            TextOut(20+1,Height-TextHeight('X'),'x');
            TextOut(2,Height-20-2-TextHeight('X'),'y');
          end;
        plXZ:
          begin
            MoveTo(4,Height-1-20);
            LineTo(4,Height-1-4);
            LineTo(20+1,Height-1-4);
            TextOut(20+1,Height-TextHeight('X'),'x');
            TextOut(2,Height-1-20-1-TextHeight('X'),'z');
          end;
        plYZ:
          begin
            MoveTo(4,Height-1-20);
            LineTo(4,Height-1-4);
            LineTo(20+1,Height-1-4);
            TextOut(20+1,Height-TextHeight('X'),'y');
            TextOut(2,Height-1-20-1-TextHeight('X'),'z');
          end;
      end;
      Font.Color:=clBlack;
      Pen.Color:=clBlack;
      Brush.Style:=bsSolid;
    end;

    if (MouseMode = mmSelecting) and (MouseModeAxes = Axes) then
      DrawSelectionBox;

    DrawRubberBand;

    MoveTo2D(aCanvas,a3DPoint(-max(Height,width),-max(Height,width),0),Axes);
    if Axes <> plXY then
      LineTo2D(aCanvas,a3DPoint(max(Height,width),max(Height,width),0),Axes);

    if DrawingSection then
    begin
      case CurSection of
        plXY: DrawPolygons(CurSection,ZSectionCoord);{z}
        plXZ: DrawPolygons(CurSection,YSectionCoord);{y}
        plYZ: DrawPolygons(CurSection,XSectionCoord);{x}
      end;

      for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
      if Roof3.Checked and HasConstraint[RoofAxes] then
      case CurSection of
        plXY: DrawRoofSection(CurSection,RoofAxes,ZSectionCoord);{z}
        plXZ: DrawRoofSection(CurSection,RoofAxes,YSectionCoord);{y}
        plYZ: DrawRoofSection(CurSection,RoofAxes,XSectionCoord);{x}
      end;
    end else
    begin
      for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
        if ((CurMode = tiRun) and Roof2.Checked and HasConstraint[RoofAxes]) or ((CurMode = tiEdit) and Roof3.Checked and HasConstraint[RoofAxes]) then
          DrawRoof(RoofAxes);
      if CurMode = tiEdit then
        DrawSpheroids;
      SymmetrySliceOnly:=(SymmetryAxes = axes) and (((CurMode = tiEdit) and SymmetrySlice2.Checked) or ((CurMode <> tiEdit) and SymmetrySlice1.Checked));
      DrawStruts;
      DrawAtoms;
    end;

//    DrawEPG;
    DrawEPGTop;
    DrawZoomRotate;

    colUnSelected:=clDefault;
    Brush.Color:=pnlXY.Color;
    Pen.Color:=clBlack;
    Pen.Width:=1;
  end;
end;

procedure TForm1.pbXYPaint(Sender: TObject);
begin
  PaintBoxPaint(pbXY,pbXY.Canvas,plXY);
end;

procedure TForm1.pbXZPaint(Sender: TObject);
begin
  PaintBoxPaint(pbXZ,pbXZ.Canvas,plXZ);
end;

procedure TForm1.pbYZPaint(Sender: TObject);
const first: boolean = true;
begin
  if first then
  begin
    first:=false;
    IsLoaded;
  end;

  PaintBoxPaint(pbYZ,pbYZ.Canvas,plYZ);
end;

function RoofAtomNum(RoofAxes: TRoofAxes; i,j: integer): integer;
begin
  result:=(ord(RoofAxes)+1)*1000000+i*100+j;
end;

function TForm1.FindAtom(ax,ay,dist: Integer; Axes: TAxes; bRoof: boolean): TAtomRefEx;
var a: TAtomRef;
    d: FPnumber;
    pass,i,j: integer;
    RoofAxes: TRoofAxes;
begin
  for pass:=1 to 2 do
  begin
    d:=maxint;
    if bRoof then
      for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
        for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
          for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
            if (pass = 2) or Roof[RoofAxes,i,j].Selected then
              if (CurSection = pl3D) or (CurSection <> MouseModeAxes) or RoofNearCurSection(RoofAxes,i,j) then
                with MeshPoint2D(RoofAxes,i,j,Axes) do
                  if abs(x-ax)+abs(y-ay) < d then
                  begin
                    result:=RoofAtomNum(RoofAxes,i,j);
                    d:=abs(x-ax)+abs(y-ay);
                  end;

    for a:=1 to NumAtoms do
      if (pass = 2) or Atoms[a].Selected then
      if (CurSection = pl3D) or (CurSection <> MouseModeAxes) or AtomNearCurSection(a) then
      with Proj2DZoom(Atoms[a].p,Axes) do
        if abs(x-ax)+abs(y-ay) < d then
        begin
          result:=a;
          d:=abs(x-ax)+abs(y-ay);
        end;

    if d <= dist then
      exit;
  end;
  result:=0;
end;

function TForm1.FindStrutXY(ax,ay,dist: Integer; Axes: TAxes): TAtomRef;
var b: TStrutRef;
    d: FPnumber;
    pa,pb: TPoint;
begin
  result:=NumStruts;
  d:=maxint;
  for b:=1 to NumStruts do
  begin
    pa:=Proj2DZoom(Atoms[Struts[b].Atom1].p,Axes);
    pb:=Proj2DZoom(Atoms[Struts[b].Atom2].p,Axes);
    if DistPointToLine(Point(ax,ay),Proj2DZoom(Atoms[Struts[b].Atom1].p,Axes),Proj2DZoom(Atoms[Struts[b].Atom2].p,Axes)) < d then
    begin
      result:=b;
      d:=DistPointToLine(Point(ax,ay),Proj2DZoom(Atoms[Struts[b].Atom1].p,Axes),Proj2DZoom(Atoms[Struts[b].Atom2].p,Axes));
    end;
  end;

  if (NumAtoms = 0) or (d > dist) then
    result:=0;
end;

procedure TForm1.CalcStrutRestLength;
var b: TStrutRef;
begin
  for b:=1 to NumStruts do
    with Struts[b] do
    begin
      if not inrange(musc,0,high(muscle)) then
        musc:=-1;
      if musc >= 0 then
        RestLength:=MinRestLen(Distance(Atom1,Atom2)*100/muscle[musc].TrackBar.Position) else
        RestLength:=MinRestLen(Distance(Atom1,Atom2));
    end
end;

procedure TForm1.SetPrevStrutLength;
var il: TStrutRef;
begin
  for il:=1 to NumStruts do
    with Struts[il] do
      prevLen:=distance(atom1,atom2);//+(0.5-random)/100000;
end;

procedure TForm1.PaintBoxMouseDown(xs,ys: Integer; Axes: TAxes);
var p2,l1,l2: integer;
    aStrut: TStrutRef;
    b: TStrutRef;
const PrevTime: integer = 0;
begin
  if GetKeyState(vk_RButton) < 0 then
  begin
    if (MouseMode = mmRotating) or (MouseMode = mmZooming) then
    begin
      MouseMode:=mmNone;
      InvalidateAll;
    end else
    begin
      SetUndo;
      MouseModeAxes:=Axes;
      pMousePrev.x:=xs;
      pMousePrev.y:=ys;
      pMouseDown.x:=xs;
      pMouseDown.y:=ys;
      ZoomRot:=0;
      Rotate1.Enabled:=true;
      PopupMenu1.Popup(mouse.CursorPos.x,mouse.CursorPos.y);
    end;
  end else
  begin
    if (GetKeyState(vk_ScrollViewA) < 0) and (GetKeyState(vk_ScrollViewB) < 0) then
    begin
      MouseMode:=mmScrolling;
      MouseModeAxes:=Axes;
      pMousePrev.x:=xs;
      pMousePrev.y:=ys;
      pMouseDown.x:=xs;
      pMouseDown.y:=ys;
      exit;
    end;

    Stop;
    SetUndo;

    if ((GetTickCount < PrevTime+GetDoubleClickTime) or (GetKeyState(vk_MakeStrut) < 0)) then
      if FindAtom(xs,ys,CaptureDist,Axes,false) > 0 then
        MouseMode:=mmMakingStrut else
    if (GetTickCount < PrevTime+GetDoubleClickTime) then
      with UnProj2D(xSnapToGrid(xs,Axes),ySnapToGrid(ys,Axes),Axes) do
        NewAtom(x,y,z,DefaultMass);

    MouseModeAxes:=Axes;

    if (MouseMode = mmMakingStrut) then
    begin
      MovingAtom:=FindAtom(xs,ys,CaptureDist,Axes,false);
      if (MovingAtom > 0) and (pythag(xs-Proj2DZoom(Atoms[MovingAtom].p,Axes).x,ys-Proj2DZoom(Atoms[MovingAtom].p,Axes).y) < CaptureDist) then
        PaintBoxMouseMove(xs,ys,Axes) else
        MovingAtom:=0;
      if MovingAtom = 0 then
      begin
        SelectAtom(0,false);
        SelectStrut(NearestStrut(xs,ys,Axes),false);
      end;
    end else
    if GetKeyState(vk_MakeAtom) < 0 then
    begin
      with UnProj2D(xSnapToGrid(xs,Axes),ySnapToGrid(ys,Axes),Axes) do
        NewAtom(x,y,z,DefaultMass);
      InvalidateAll;
    end else
    begin
      CurAtom:=FindAtom(xs,ys,CaptureDist,Axes,true);
      SelectRect:=Rect(xs,ys,xs,ys);
      if CurAtom = 0 then
      begin
        l1:=FindStrutXY(xs,ys,CaptureDist,Axes);
        if l1 = 0 then
        begin
          if (abs(ys-vPixsCoordZoom(Axes)) < CaptureDist) or (abs(xs-uPixsCoordZoom(Axes)) < CaptureDist) then
          begin
            MouseMode:=mmMovingSection;
            MouseModeAxes:=Axes;
          end else
          begin
            MouseMode:=mmSelecting;
            MouseModeAxes:=Axes;
            SelectInRect;
          end;
        end else
        begin
          for l2:=1 to NumStruts do
            Struts[l2].Selected:=(l1 = l2) or (Struts[l2].Selected and (GetKeyState(vk_Plus) < 0));
          InvalidateAll;
        end;
      end else
      if CurAtom > 500000 then 
      begin {is a Roof point}
        if GetKeyState(vk_Minus) < 0 then
          UnSelectAtom(CurAtom) else
        if GetKeyState(vk_Plus) < 0 then
          SelectAtom(CurAtom,true) else
//        if not RoofSelected(CurAtom) then
          SelectAtom(CurAtom,RoofSelected(CurAtom));
      end else
      begin {is an atom}
        if GetKeyState(vk_Minus) < 0 then
        begin
          UnSelectAtom(CurAtom);
        end else
        if GetKeyState(vk_Plus) < 0 then
        begin
          SelectAtom(CurAtom,true);
        end else
        if not Atoms[CurAtom].Selected then
        begin
          SelectAtom(CurAtom,false);
          for b:=1 to NumStruts do
            Struts[b].Selected:=false;
        end;

        InvalidateAll;
      end;
    end;

  ChkPoly;
    PrevTime:=GetTickCount;
    SetCursor;
  end;
end;

procedure TForm1.PaintBoxMouseMove(xs,ys: Integer; Axes: TAxes);
  function Dist(Atom1,Atom2: TAtomNum): FPnumber;
  begin
    case Axes of
      plXY: result:=Pythag(
              Atoms[Atom1].p.x-Atoms[Atom2].p.x,
              Atoms[Atom1].p.y-Atoms[Atom2].p.y);
      plXZ: result:=Pythag(
              Atoms[Atom1].p.x-Atoms[Atom2].p.x,
              Atoms[Atom1].p.z-Atoms[Atom2].p.z);
      plYZ: result:=Pythag(
              Atoms[Atom1].p.y-Atoms[Atom2].p.y,
              Atoms[Atom1].p.z-Atoms[Atom2].p.z);
      pl3D: result:=Pythag3d(
              Atoms[Atom1].p.x-Atoms[Atom2].p.x,
              Atoms[Atom1].p.y-Atoms[Atom2].p.y,
              Atoms[Atom1].p.z-Atoms[Atom2].p.z);
    end;
  end;
  function Furthest: Integer;
  var a: TAtomRef;
  begin
    result:=CurAtom;
    if (GetKeyState(ord('C')) < 0) and (NumSelectedAtoms > 0) then
      for a:=1 to NumAtoms do
        if Atoms[a].Selected then
          if Dist(a,CurAtom) > Dist(result,CurAtom) then
            result:=a;
  end;
var a: TAtomRef;
    d: T3DPoint;
    d1: TPoint;
    p: TSinglePoint;
    i,j,i1,j1: integer;
    su,sv: single;
    RoofAxes: TRoofAxes;
    FurthestAtom: integer;
    e,f: FPNumber;
begin
  if MouseMode = mmScrolling then
  begin
    case MouseModeAxes of
      plXY: begin bOfs2DX:=bOfs2DX+xs-pMousePrev.x; aOfs2DY:=aOfs2DY+ys-pMousePrev.y; InvalidateAll; pbXY.Update; end;
      plXZ: begin bOfs2DX:=bOfs2DX+xs-pMousePrev.x; aOfs2DZ:=aOfs2DZ+ys-pMousePrev.y; InvalidateAll; pbXZ.Update; end;
      plYZ: begin aOfs2DY:=aOfs2DY+xs-pMousePrev.x; aOfs2DZ:=aOfs2DZ+ys-pMousePrev.y; InvalidateAll; pbYZ.Update; end;
    end;
    pMousePrev.x:=xs;
    pMousePrev.y:=ys;
  end else
  if MouseMode = mmZooming then
  begin
    while (pMouseDown.x-xs) div 8 > ZoomRot do
    begin
      ZoomInOutEx(+1,pMouseDown,MouseModeAxes);
      inc(ZoomRot);
      InvalidateAll;
    end;
    while (pMouseDown.x-xs) div 8 < ZoomRot do
    begin
      ZoomInOutEx(-1,pMouseDown,MouseModeAxes);
      dec(ZoomRot);
      InvalidateAll;
    end;
  end else
  if CurMode = tiEdit then
  begin
    if MouseMode = mmRotating then
    begin
      while (pMouseDown.x-xs) div 8 > ZoomRot do
      begin
        RotateSelectedAtomsEx(+pi/180,pMouseDown,MouseModeAxes);
        inc(ZoomRot);
        InvalidateAll;
      end;
      while (pMouseDown.x-xs) div 8 < ZoomRot do
      begin
        RotateSelectedAtomsEx(-pi/180,pMouseDown,MouseModeAxes);
        dec(ZoomRot);
        InvalidateAll;
      end;
    end else
    if GetKeyState(vk_LButton) < 0 then
    begin
      if (MouseMode = mmSelecting) and (MouseModeAxes = Axes) then
      begin
        SelectRect:=Rect(SelectRect.Left,SelectRect.Top,xs,ys);
        SelectInRect;
        case Axes of
          plXY: pbXYInvalidate;
          plXZ: pbXZInvalidate;
          plYZ: pbYZInvalidate;
        end;
      end else
      if (MouseMode = mmMovingSection) and (MouseModeAxes = Axes) then
      begin
        if ((Axes = plXY) and (CurSection = plYZ)) or
           ((Axes = plXZ) and (CurSection = plYZ)) or
           ((Axes = plYZ) and (CurSection = plXZ)) then
          PixsIndex:=RealRange((xs-ZoomScroll(SectionRect(Axes).Left,0,Axes).x)/(ZoomScroll(SectionRect(Axes).Right,0,Axes).x-ZoomScroll(SectionRect(Axes).Left,0,Axes).x),0,1)else
          PixsIndex:=RealRange(1-(ys-ZoomScroll(0,SectionRect(Axes).Top,Axes).y)/(ZoomScroll(0,SectionRect(Axes).Bottom,Axes).y-ZoomScroll(0,SectionRect(Axes).Top,Axes).y),0,1);
        PixsIndexChange;
      end else
      case Axes of
        plXY:
          if (MouseMode = mmMakingStrut) and (MouseModeAxes = Axes) then
          begin
            a:=NearestAtom(xs,ys,Axes);
            if pythag(xs-Proj2DZoom(Atoms[a].p,Axes).x,ys-Proj2DZoom(Atoms[a].p,Axes).y) < 8 then
              RubberBand:=Proj2DZoom(Atoms[a].p,Axes) else
              RubberBand:=Point(xs,ys);
            pbXYInvalidate;
            Modified:=true;
          end else
          if CurAtom > 500000 then
          begin
//            ys:=ySnapToGrid(ys,Axes);
            su:=0;
            sv:=0;
            for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
              for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
                for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
                  if RoofAtomNum(RoofAxes,i,j) = CurAtom then
                    with MeshPoint2D(RoofAxes,i,j,Axes) do
                    begin
                      su:=(xs-x)/Zoom;
                      sv:=(y-ys)/Zoom;
                    end;

            for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
              for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
                for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
                  if Roof[RoofAxes,i,j].Selected then
                  case RoofAxes of
                    raYNeg,raYPos:
                      begin
                        Roof[RoofAxes,i,j].h:=Roof[RoofAxes,i,j].h+sv;
                        i1:=round(2*SymmetryCoord/RoofMeshsize[RoofAxes]-i);
                        j1:=round(2*SymmetryCoord/RoofMeshsize[RoofAxes]-j);
                        case SymmetryAxes of
                          plYZ: if InRange(i1,-RoofN[RoofAxes],RoofN[RoofAxes]) and not Roof[RoofAxes,i1,j].Selected then
                                  Roof[RoofAxes,i1,j].h:=Roof[RoofAxes,i,j].h;
                          plXZ: if InRange(j1,-RoofN[RoofAxes],RoofN[RoofAxes]) and not Roof[RoofAxes,i,j1].Selected then
                                  Roof[RoofAxes,i,j1].h:=Roof[RoofAxes,i,j].h;
                        end;
                      end;
                    raXNeg,raXPos:
                      begin
                        Roof[RoofAxes,i,j].h:=Roof[RoofAxes,i,j].h+su;
                        i1:=round(2*SymmetryCoord/RoofMeshsize[RoofAxes]-i);
                        case SymmetryAxes of
                          plYZ: Roof[RoofAxes,i,j].h:=-Roof[RoofAxes,i,j].h;
                          plXZ: if InRange(i1,-RoofN[RoofAxes],RoofN[RoofAxes]) and not Roof[RoofAxes,i1,j].Selected then
                                  Roof[RoofAxes,i1,j].h:=Roof[RoofAxes,i,j].h;
                        end;
                      end;
                  end;
            MakeConstraintsSymmetrical;

            Modified:=true;
            InvalidateAll;
            pbXZ.Update;
          end else
          if CurAtom <> 0 then
          begin
            xs:=xSnapToGrid(xs,Axes);
            ys:=ySnapToGrid(ys,Axes);
            d1:=SubPoints(Point(xs,ys),Proj2DZoom(Atoms[CurAtom].p,Axes));
            FurthestAtom:=Furthest;
            f:=Dist(FurthestAtom,CurAtom);
            if CurAtom <> FurthestAtom then
            begin
              for a:=1 to NumAtoms do
              if Atoms[a].Selected and (a <> CurAtom) then
              begin
                e:=Dist(a,FurthestAtom)/Dist(FurthestAtom,CurAtom);
                Atoms[a].p:=a3DPoint(Atoms[a].p.x+e*d1.x/zoom,Atoms[a].p.y-e*d1.y/zoom,Atoms[a].p.z);
              end;
              Atoms[CurAtom].p:=a3DPoint(Atoms[CurAtom].p.x+d1.x/zoom,Atoms[CurAtom].p.y-d1.y/zoom,Atoms[CurAtom].p.z);
            end else
            begin
              for a:=1 to NumAtoms do
                if Atoms[a].Selected then
                  Atoms[a].p:=a3DPoint(Atoms[a].p.x+d1.x/zoom,Atoms[a].p.y-d1.y/zoom,Atoms[a].p.z);
            end;
            FixSymmetryAtoms;

            CalcStrutRestLength;

            if NumSelectedAtoms > 0 then
            begin
              Modified:=true;
              InvalidateAll;
              pbXY.Update;
            end;
          end;
        plXZ:
          if (MouseMode = mmMakingStrut) and (MouseModeAxes = Axes) then
          begin
            a:=NearestAtom(xs,ys,Axes);
            if pythag(xs-Proj2DZoom(Atoms[a].p,Axes).x,ys-Proj2DZoom(Atoms[a].p,Axes).y) < 8 then
              RubberBand:=Proj2DZoom(Atoms[a].p,Axes) else
              RubberBand:=Point(xs,ys);
            pbXZInvalidate;
            Modified:=true;
          end else
          if CurAtom > 500000 then
          begin
//            ys:=ySnapToGrid(ys,Axes);
            su:=0;
            sv:=0;
            for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
              for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
                for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
                  if RoofAtomNum(RoofAxes,i,j) = CurAtom then
                    with MeshPoint2D(RoofAxes,i,j,Axes) do
                    begin
                      su:=(xs-x)/Zoom;
                      sv:=(y-ys)/Zoom;
                    end;

            for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
              for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
                for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
                  if Roof[RoofAxes,i,j].Selected then
                  case RoofAxes of
                    raZPos,raZNeg:
                      begin
                        Roof[RoofAxes,i,j].h:=Roof[RoofAxes,i,j].h+sv;
                        i1:=round(2*SymmetryCoord/RoofMeshsize[RoofAxes]-i);
                        j1:=round(2*SymmetryCoord/RoofMeshsize[RoofAxes]-j);
                        case SymmetryAxes of
                          plYZ: if InRange(i1,-RoofN[RoofAxes],RoofN[RoofAxes]) and not Roof[RoofAxes,i1,j].Selected then
                                  Roof[RoofAxes,i1,j].h:=Roof[RoofAxes,i,j].h;
                          plXZ: if InRange(j1,-RoofN[RoofAxes],RoofN[RoofAxes]) and not Roof[RoofAxes,i,j1].Selected then
                                  Roof[RoofAxes,i,j1].h:=Roof[RoofAxes,i,j].h;
                        end;
                      end;
                    raXNeg,raXPos:
                      begin
                        Roof[RoofAxes,i,j].h:=Roof[RoofAxes,i,j].h+su;
                        case SymmetryAxes of
                          plYZ: Roof[RoofAxes,i,j].h:=-Roof[RoofAxes,i,j].h;
                        end;
                      end;
                  end;
            MakeConstraintsSymmetrical;

            Modified:=true;
            InvalidateAll;
            pbXZ.Update;
          end else
          if CurAtom <> 0 then
          begin
            xs:=xSnapToGrid(xs,Axes);
            ys:=ySnapToGrid(ys,Axes);
            d1:=SubPoints(Point(xs,ys),Proj2DZoom(Atoms[CurAtom].p,Axes));
            FurthestAtom:=Furthest;
            f:=Dist(FurthestAtom,CurAtom);
            if CurAtom <> FurthestAtom then
            begin                          
              for a:=1 to NumAtoms do
              if Atoms[a].Selected and (a <> CurAtom) then
              begin
                e:=Dist(a,FurthestAtom)/Dist(FurthestAtom,CurAtom); 
                Atoms[a].p:=a3DPoint(Atoms[a].p.x+e*d1.x/zoom,Atoms[a].p.y,Atoms[a].p.z-e*d1.y/zoom);
              end;
                Atoms[CurAtom].p:=a3DPoint(Atoms[CurAtom].p.x+d1.x/zoom,Atoms[CurAtom].p.y,Atoms[CurAtom].p.z-d1.y/zoom);
            end else
            begin
              for a:=1 to NumAtoms do
                if Atoms[a].Selected then
                  Atoms[a].p:=a3DPoint(Atoms[a].p.x+d1.x/zoom,Atoms[a].p.y,Atoms[a].p.z-d1.y/zoom);
            end;
            FixSymmetryAtoms;

            CalcStrutRestLength;

            if NumSelectedAtoms > 0 then
            begin
              Modified:=true;
              InvalidateAll;
              pbXY.Update;
            end;
          end;
        plYZ:
          if (MouseMode = mmMakingStrut) and (MouseModeAxes = Axes) then
          begin
            a:=NearestAtom(xs,ys,Axes);
            if pythag(xs-Proj2DZoom(Atoms[a].p,Axes).x,ys-Proj2DZoom(Atoms[a].p,Axes).y) < 8 then
              RubberBand:=Proj2DZoom(Atoms[a].p,Axes) else
              RubberBand:=Point(xs,ys);
            pbYZInvalidate;
            Modified:=true;
          end else
          if CurAtom > 500000 then
          begin
//            ys:=ySnapToGrid(ys,Axes);
            su:=0;
            sv:=0;
            for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
              for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
                for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
                  if RoofAtomNum(RoofAxes,i,j) = CurAtom then
                    with MeshPoint2D(RoofAxes,i,j,Axes) do
                    begin
                      su:=(xs-x)/Zoom;
                      sv:=(y-ys)/Zoom;
                    end;

            for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
              for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
                for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
                  if Roof[RoofAxes,i,j].Selected then
                  case RoofAxes of
                    raZNeg,raZPos:
                      begin
                        Roof[RoofAxes,i,j].h:=Roof[RoofAxes,i,j].h+sv;
                        i1:=round(2*SymmetryCoord/RoofMeshsize[RoofAxes]-i);
                        j1:=round(2*SymmetryCoord/RoofMeshsize[RoofAxes]-j);
                        case SymmetryAxes of
                          plYZ: if InRange(i1,-RoofN[RoofAxes],RoofN[RoofAxes]) and not Roof[RoofAxes,i1,j].Selected then
                                  Roof[RoofAxes,i1,j].h:=Roof[RoofAxes,i,j].h;
                          plXZ: if InRange(j1,-RoofN[RoofAxes],RoofN[RoofAxes]) and not Roof[RoofAxes,i,j1].Selected then
                                  Roof[RoofAxes,i,j1].h:=Roof[RoofAxes,i,j].h;
                        end;
                      end;
                    raYPos,raYNeg:
                      begin
                        Roof[RoofAxes,i,j].h:=Roof[RoofAxes,i,j].h+su;
//                        case SymmetryAxes of
//                          plYZ: Roof[RoofAxes,i,j].h:=-Roof[RoofAxes,i,j].h;
//                        end;
                      end;
                  end;


            MakeConstraintsSymmetrical;

            Modified:=true;
            InvalidateAll;
            pbYZ.Update;
          end else
          if CurAtom > 0 then
          begin
            xs:=xSnapToGrid(xs,Axes);
            ys:=ySnapToGrid(ys,Axes);

            d1:=SubPoints(Point(xs,ys),Proj2DZoom(Atoms[CurAtom].p,Axes));
            FurthestAtom:=Furthest;
            f:=Dist(FurthestAtom,CurAtom);
            if CurAtom <> FurthestAtom then
            begin
              for a:=1 to NumAtoms do
              if Atoms[a].Selected and (a <> CurAtom) then
              begin
                e:=Dist(a,FurthestAtom)/Dist(FurthestAtom,CurAtom);
                Atoms[a].p:=a3DPoint(Atoms[a].p.x,Atoms[a].p.y+e*d1.x/zoom,Atoms[a].p.z-e*d1.y/zoom);
              end;
                Atoms[CurAtom].p:=a3DPoint(Atoms[CurAtom].p.x,Atoms[CurAtom].p.y+d1.x/zoom,Atoms[CurAtom].p.z-d1.y/zoom);
            end else
            begin
              for a:=1 to NumAtoms do
                if Atoms[a].Selected then
                  Atoms[a].p:=a3DPoint(Atoms[a].p.x,Atoms[a].p.y+d1.x/zoom,Atoms[a].p.z-d1.y/zoom);
            end;
            FixSymmetryAtoms;

            CalcStrutRestLength;

            if NumSelectedAtoms > 0 then
            begin
              Modified:=true;
              InvalidateAll;
              pbYZ.Update;
            end;
          end;
      end;
    end;
  ChkPoly;
  end;
end;

procedure TForm1.PaintBoxMouseUp(xs,ys: Integer; Axes: TAxes);
var a: TAtomNum;
    b: TStrutNum;
    i1,j1: integer;
    RoofAxes1: TRoofAxes;
    i2,j2: integer;
    RoofAxes2: TRoofAxes;
begin
  if CurMode = tiEdit then
  begin
    if (MouseMode = mmMakingStrut) and (MovingAtom > 0) then
    begin
      a:=NearestAtom(xs,ys,Axes);
      if pythag(xs-Proj2DZoom(Atoms[a].p,Axes).x,ys-Proj2DZoom(Atoms[a].p,Axes).y) < 8 then
      if MovingAtom <> a then
      begin
        NewStrut(MovingAtom,a,Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
        SetupStruts;
        SelectStrut(NumStruts,false);
      end;
      InvalidateAll;
      MouseMode:=mmNone;
    end else
    if MouseMode <> mmNone then
    begin
      for RoofAxes1:=low(RoofAxes1) to high(RoofAxes1) do
      for i1:=-RoofN[RoofAxes1] to RoofN[RoofAxes1] do
      for j1:=-RoofN[RoofAxes1] to RoofN[RoofAxes1] do
      begin
        if not HasConstraint[RoofAxes1] then
          Roof[RoofAxes1,i1,j1].Selected:=false;
        if Roof[RoofAxes1,i1,j1].Selected then
          for RoofAxes2:=low(RoofAxes2) to high(RoofAxes2) do
            if RoofAxes1 <> RoofAxes2 then
              for i2:=-RoofN[RoofAxes2] to RoofN[RoofAxes2] do
                for j2:=-RoofN[RoofAxes2] to RoofN[RoofAxes2] do
                  Roof[RoofAxes2,i2,j2].Selected:=false;
      end;
      InvalidateAll;
      MouseMode:=mmNone;
    end;
  end;
  MouseMode:=mmNone;
  SetCursor;
ChkPoly;
end;

procedure TForm1.pbXYMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PaintBoxMouseDown(x,y,plXY);
end;

procedure TForm1.pbXYMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  PaintBoxMouseMove(x,y,plXY);
  imgXY.Update;
  pbXY.Update;
end;

procedure TForm1.pbXYMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PaintBoxMouseUp(x,y,plXY);
end;

procedure TForm1.pbXZMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PaintBoxMouseDown(x,y,plXZ);
end;

procedure TForm1.pbXZMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  PaintBoxMouseMove(x,y,plXZ);
  imgXZ.Update;
  pbXZ.Update;
end;

procedure TForm1.pbXZMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PaintBoxMouseUp(x,y,plXZ);
end;

procedure TForm1.Options2Click(Sender: TObject);
begin
  dlgOptions.Label4.Caption:='Atoms = '+inttostr(NumAtoms);
  dlgOptions.Label8.Caption:='Struts = '+inttostr(NumStruts);
  dlgOptions.Label9.Caption:='Polyhedron = '+inttostr(length(Polyhedron));
  dlgOptions.Label10.Caption:='Polygons = '+inttostr(length(Polygons));
  dlgOptions.ShowModal;
ChkPoly;
  LoadTrackbars;
  InvalidateAll;
end;

procedure TForm1.pbYZMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PaintBoxMouseDown(x,y,plYZ);
end;

procedure TForm1.pbYZMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  PaintBoxMouseMove(x,y,plYZ);
  imgYZ.Update;
  pbYZ.Update;
end;

procedure TForm1.pbYZMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  PaintBoxMouseUp(x,y,plYZ);
end;

{
procedure TForm1.pbYZMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; x, Y: Integer);
begin
    PaintBoxMouseDown(x,y,x-imgYZ.Width div 2,y-imgYZ.Height div 2,plYZ);
    PaintBoxMouseDown(x,y,x-imgYZ.Width div 2,imgYZ.Height div 2-y,plYZ);
  PaintBoxMouseDown(x,y,x-imgYZ.Width div 2,y-imgYZ.Height div 2,plYZ);
end;

procedure TForm1.pbYZMouseMove(Sender: TObject; Shift: TShiftState; x,
  Y: Integer);
begin
    PaintBoxMouseMove(x,y,x-imgYZ.Width div 2,y-imgYZ.Height div 2,plYZ);
    PaintBoxMouseMove(x,y,x-imgYZ.Width div 2,imgYZ.Height div 2-y,plYZ);
  PaintBoxMouseMove(x,y,x-imgYZ.Width div 2,y-imgYZ.Height div 2,plYZ);
  imgYZ.Update;
  pbYZ.Update;
end;

procedure TForm1.pbYZMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; x, Y: Integer);
begin
    PaintBoxMouseUp(x,y,x-imgYZ.Width div 2,y-imgYZ.Height div 2,plYZ);
    PaintBoxMouseUp(x,y,x-imgYZ.Width div 2,imgYZ.Height div 2-y,plYZ);
  PaintBoxMouseUp(x,y,x-imgYZ.Width div 2,y-imgYZ.Height div 2,plYZ);
end;
}

const
  elevation = 0.8;

function TForm1.Proj3D(xyz: T3DPoint; var p: TSinglePoint): FPnumber;
{ vector (-sinyaw*cospitch,-cosyaw*cospitch,sinpitch) points at camera}
var ax,ay,az: FPnumber;
begin
  with pb3D do
  begin
    ax:=xyz.x*cosyaw-xyz.y*sinyaw;
    ay:=xyz.x*sinyaw+xyz.y*cosyaw;
    az:=xyz.z;

    xyz.y:=ay*cospitch-az*sinpitch;
    xyz.z:=ay*sinpitch+az*cospitch;
    xyz.x:=ax;

    if Vudist > 0 then
    begin
      xyz.x:=xyz.x*VuDist/(xyz.y+VuDist);
      xyz.z:=xyz.z*VuDist/(xyz.y+VuDist);

      p.x:=ClientWidth    div 2 + round(xyz.x);
      p.y:=round(ClientHeight*elevation - xyz.z);

      result:=VUDIST+xyz.y;
    end else
    begin
      p.x:=ClientWidth    div 2 + round(xyz.x);
      p.y:=round(ClientHeight*elevation - xyz.z);
      result:=10000+xyz.y;
    end;
  end;
end;

function TForm1.Proj3DZoom(xyz: T3DPoint; var p: TPoint): FPnumber;
var p1: TSinglePoint;
begin
  result:=Proj3D(xyz,p1);
  p:=ZoomScroll(p1.x,p1.y,pl3D);
end;

function TForm1.Horizon: integer;
begin
  with pb3D do
  begin
    if Vudist <= 0 then
      result:=-ClientHeight*4 else
    if cospitch < 0.0001 then
      result:=-ClientHeight*4 else
      result:=round(ClientHeight*elevation - sinpitch*VuDist/cospitch);
  end;
end;

procedure TForm1.pb3DPaint(Sender: TObject);
var ShowForces: boolean;
  procedure DrawRubberBand;
  var p1: TPoint;
  begin
    if (CurMode = tiEdit) and (MouseMode = mmMakingStrut) and (MovingAtom > 0) then
    with pb3D,pb3DCanvas do
    begin
      Pen.Color:=clSelected;
      if Proj3DZoom(Atoms[MovingAtom].p,p1) > 0 then
      begin
        MoveTo(p1.x,p1.y);
        LineTo(RubberBand.x,RubberBand.y);
      end;
    end;
  end;
  procedure DrawSelectionBox;
  begin
    with pb3D,pb3DCanvas do
    begin
      Pen.Color:=clBlack;
      with SelectRect do
      if Right <> Left then
      begin
        Pen.Style:=psDot;
        Brush.Style:=bsClear;
        RectangleZoom(pb3DCanvas,Left,Top,Right,Bottom,pl3D);
        Brush.Style:=bsSolid;
        Pen.Style:=psSolid;
      end;
    end;
  end;
  procedure DrawAtoms;
  var a: TAtomRef;
      p1: TPoint;
  begin
    FillEMA;

    with pb3D,pb3DCanvas do
    begin
      if ShowForces or (CurMode = tiEdit) then
      for a:=1 to NumAtoms do
      with Atoms[a] do
      begin
        if Selected then
          Brush.Color:=clSelected else
          Brush.Color:=colUnSelected;
        if Proj3DZoom(p,p1) > 0 then
        if not neglect then
        begin
          FillRect(rect(p1.x-2,p1.y-2,p1.x+3,p1.y+3));

          if EMA >= 0 then
          begin
            Pen.Width:=1;
            if not Selected then
              Brush.Color:=clMagenta;
            Pen.Color:=Brush.Color;
            ellipse(p1.x-3,p1.y-3,p1.x+4,p1.y+4);
            if InRange(EMA,1,NumAtoms-1) then
            with Struts[EMA] do
            begin
              Pen.Width:=3;
              MoveTo2D(pb3DCanvas,p,pl3D);
              LineTo2D(pb3DCanvas,Scale3D(Add3D(p,Atoms[EMA].p),0.5),pl3D);
              Pen.Width:=1;
            end;
          end;

          if ShowForces then
          begin
            Brush.Style:=bsClear;
            TextOut(p1.x+2,p1.y+2,inttostr(a));
            Brush.Style:=bsSolid;
          end;
          Brush.Color:=clBtnFace;
        end;
      end;
    end;
  end;
  procedure DrawRoof(RoofAxes: TRoofAxes);
  var i,j: integer;
      p1: TPoint;
  begin
    with pb3D,pb3DCanvas do
    begin
      Pen.Color:=RoofColor[RoofAxes];
      for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
      for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
      begin
        if Roof[RoofAxes,i,j].Selected then
          Brush.Color:=clSelected else
          Brush.Color:=RoofColor[RoofAxes];
        if i < RoofN[RoofAxes] then
          DrawLine3D(MeshPoint3D(RoofAxes,i,j),MeshPoint3D(RoofAxes,i+1,j));
        if j < RoofN[RoofAxes] then
          DrawLine3D(MeshPoint3D(RoofAxes,i,j),MeshPoint3D(RoofAxes,i,j+1));
        if Proj3DZoom(MeshPoint3D(RoofAxes,i,j),p1) > 0 then
          FillRect(rect(p1.x-2,p1.y-2,p1.x+3,p1.y+3));
      end;
      Brush.Color:=clBtnFace;
    end;
  end;
  procedure DrawLine3DSym(pa,pb: T3DPoint);
  var p1,p2: TPoint;
  begin
    DrawLine3D(pa,pb);
    if ((CurMode = tiEdit) and ShowSymmetryEdit1.Checked) or ((CurMode = tiRun) and ShowSymmetryRun1.Checked) then
    case SymmetryAxes of
      plXY: DrawLine3D(a3DPoint(pa.x,pa.y,2*SymmetryCoord-pa.z),a3DPoint(pb.x,pb.y,2*SymmetryCoord-pb.z));
      plXZ: DrawLine3D(a3DPoint(pa.x,2*SymmetryCoord-pa.y,pa.z),a3DPoint(pb.x,2*SymmetryCoord-pb.y,pb.z));
      plYZ: DrawLine3D(a3DPoint(2*SymmetryCoord-pa.x,pa.y,pa.z),a3DPoint(2*SymmetryCoord-pb.x,pb.y,pb.z));
    end;
  end;
  procedure DrawStruts;
  var b: TStrutRef;
  begin
    with pb3D,pb3DCanvas do
    begin
      if NumStruts > 0 then
      for b:=1 to NumStruts do
      with Struts[b] do
      if not Atoms[Atom1].neglect and not Atoms[Atom2].neglect then
      begin
        Pen.Color:=StrutColor(b);
if Pen.Color = clSelected then
Pen.Width:=3;
        DrawLine3DSym(Atoms[Struts[b].Atom1].p,Atoms[Struts[b].Atom2].p);
Pen.Width:=1;
      end;
    end;
  end;
  procedure DrawSpheroids;
  var i,j,s: integer;
      h: single;
  const N = 40;
  begin
    with pb3D,pb3DCanvas do
    begin
      Pen.Color:=clmagenta;
      Pen.Width:=2;
      for s:=low(Spheroids) to high(Spheroids) do
      with Spheroids[s] do
      begin
        for j:=-1 to +1 do
        begin
          if j = 0 then
            h:=1 else
            h:=sqrt(1-sqr(0.5));

          for i:=1 to N do
          begin
            DrawLine3DSym(a3DPoint(
              C.x+h*R.x*sin(i*2*pi/N),
              C.y+h*R.y*cos(i*2*pi/N),
              C.z+R.z*j/2)
              ,
              a3DPoint(C.x+h*R.x*sin((i-1)*2*pi/N),
              C.y+h*R.y*cos((i-1)*2*pi/N),
              C.z+R.z*j/2)
              );
            DrawLine3DSym(a3DPoint(
              C.x+h*R.x*sin(i*2*pi/N),
              C.y+R.y*j/2,
              C.z+h*R.z*cos(i*2*pi/N))
              ,
              a3DPoint(C.x+h*R.x*sin((i-1)*2*pi/N),
              C.y+R.y*j/2,
              C.z+h*R.z*cos((i-1)*2*pi/N))
              );
            DrawLine3DSym(a3DPoint(
              C.x+R.x*j/2,
              C.y+h*R.y*sin(i*2*pi/N),
              C.z+h*R.z*cos(i*2*pi/N))
              ,
              a3DPoint(C.x+R.x*j/2,
              C.y+h*R.y*sin((i-1)*2*pi/N),
              C.z+h*R.z*cos((i-1)*2*pi/N))
              );
          end;
        end;
      end;
      Pen.Color:=clBlack;
      Pen.Width:=1;
    end;
  end;
  procedure DrawPolygons(DrawOnePolyhedron,DrawOnePolygon: integer);
  const vv: array of record
            a: array[1..4] of T3DPoint;
            VisibleSide: single; {if zero then both sides}
            Colq: TColor; {if < 0 then not visible}
            vctr,vmin,vmax,dp: single;
            centre: T3DPoint;
            Plane: TPlane;
            neglect: boolean;
          end = nil;
{
    procedure DrawEdges(pg: integer);
    var e,e2,b: integer;
        pt1,pt2: TPoint;
    begin
      with pb3D,pb3DCanvas do
      begin
        if ShowForces or (CurMode = tiEdit) then
          for e:=low(vv[pg].a) to high(vv[pg].a) do
          begin
            if Atoms[vv[pg].aa[e]].Selected then
              Brush.Color:=clSelected else
              Brush.Color:=clBlack;
            pt1:=Proj2DZoom(vv[pg].a[e],pl3D);
            if not Atoms[vv[pg].aa[e]].neglect then
              FillRect(rect(pt1.x-2,pt1.y-2,pt1.x+3,pt1.y+3));
            if ShowForces then
            begin
              Brush.Style:=bsClear;
              TextOutZoom(pb3DCanvas,pt1.x+2,pt1.y+2,inttostr(vv[pg].aa[e]),pl3D);
              Brush.Style:=bsSolid;
            end;
            Brush.Color:=clWhite;
            if e = high(vv[pg].a) then
              e2:=low(vv[pg].a) else
              e2:=e+1;
            b:=FindStrut(vv[pg].aa[e2],vv[pg].aa[e]);
            if b > 0 then
            begin
              pt2:=Proj2DZoom(vv[pg].a[e2],pl3D);
              pen.Color:=StrutColor(b);
              MoveTo(pt1.x,pt1.y);
              LineTo(pt2.x,pt2.y);
            end;
            pen.Color:=clBlack;
          end;
      end;
    end;
}
    procedure SetPolygonColor(pg: integer);
    var d1,d2: single;
    const ColorTable: array[0..5] of TColor = ($4040FF,$40FF40,$FF4040,$40FFFF,$FFFF40,$FF40FF);
    begin
      with pb3D,pb3DCanvas do
      begin
        Brush.Color:=vv[pg].Colq;
        d1:=DotProduct3D(Normalise3D(CrossProduct3D(
          Sub3D(vv[pg].a[1],vv[pg].a[3]),
          Sub3D(vv[pg].a[2],vv[pg].a[3]))),
          a3DPoint(cosyaw-sinyaw,-cosyaw-sinyaw,0));
        d1:=abs(d1);

        d2:=Normalise3D(CrossProduct3D(
          Sub3D(vv[pg].a[1],vv[pg].a[3]),
          Sub3D(vv[pg].a[2],vv[pg].a[3]))).z;

        if vv[pg].VisibleSide < 0 then
          d2:=-d2 else
        if vv[pg].VisibleSide = 0 then
          d2:=abs(d2);

        d1:=d1+2*d2+8;
        d1:=RealRange(d1/10,0,1);

        if (DrawOnePolyhedron < 0) and (DrawOnePolygon < 0) then
          Brush.Color:=RGB(round(Red(vv[pg].Colq)*d1),round(Green(vv[pg].Colq)*d1),round(Blue(vv[pg].Colq)*d1)) else
        begin
          randseed:=pg;
          Brush.Color:=random($1000000);
          Brush.Color:=(Brush.Color and $F0F0F0) + (Brush.Color and $F0F0F)*$10;
//          Brush.Color:=RGB(round(Red(ColorTable[pg mod 6])*d1),round(Green(ColorTable[pg mod 6])*d1),round(Blue(ColorTable[pg mod 6])*d1));
        end;
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
              ipivot: integer;          { pivot index}
          function LT(a,b: integer): boolean;
          begin
                result:=vv[arr[a]].vctr > vv[arr[b]].vctr;
{
                result:=vv[arr[a]].centre.x > vv[arr[b]].centre.x;
}
{
            if (vv[arr[a]].vmin > vv[arr[b]].vmin) and (vv[arr[a]].vmax > vv[arr[b]].vmax) then
              result:=DistPointToPlane(vv[arr[a]].centre,vv[arr[b]].Plane)*vv[arr[b]].dp < 0 else
                result:=vv[arr[a]].vctr > vv[arr[b]].vctr;


            if vv[arr[a]].vmin = vv[arr[b]].vmin then
            begin
              if vv[arr[a]].vmax = vv[arr[b]].vmax then
              begin
                result:=vv[arr[a]].vctr > vv[arr[b]].vctr;
              end else
                result:=vv[arr[a]].vmax > vv[arr[b]].vmax;
            end else
            begin
              result:=vv[arr[a]].vmin > vv[arr[b]].vmin;
            end;
{}
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
          ipivot := start;
          left := start + 1;
          right := stop;

          { look for pairs out of place and swap 'em. }
          while left <= right do begin
            while (left <= stop) and LT(left,ipivot) do
              left := left + 1;
            while (right > start) and not LT(right,ipivot) do
              right := right - 1;
            if left < right then
              swap(arr[left], arr[right]);
          end;

          { put the pivot between the halves. }
          swap(arr[start], arr[right]);

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
    function PolygonInPolyhedron(pg,ph: integer): boolean;
    var f: integer;
    begin
      result:=true;
      if inrange(ph,0,high(Polyhedron)) then
        for f:=0 to high(Polyhedron[ph].PosFace) do
          if pg = Polyhedron[ph].PosFace[f] then
            exit;
      if inrange(ph,0,high(Polyhedron)) then
        for f:=0 to high(Polyhedron[ph].NegFace) do
          if pg = Polyhedron[ph].NegFace[f] then
            exit;
      result:=false;
    end;
    procedure MakePolygons;
    var pg,i: integer;
    begin
      if length(vv) <> length(Polygons) then
        setlength(vv,length(Polygons));
      for pg:=0 to high(Polygons) do
        with vv[pg] do
        begin
          a[1]:=Atoms[Polygons[pg].a[1]].p;
          a[2]:=Atoms[Polygons[pg].a[2]].p;
          a[3]:=Atoms[Polygons[pg].a[3]].p;
          if Polygons[pg].a[4] = 0 then
            a[4]:=Atoms[Polygons[pg].a[3]].p else
            a[4]:=Atoms[Polygons[pg].a[4]].p;
          VisibleSide:=Polygons[pg].VisibleSide;
          Neglect:=PolygonNeglected(Polygons[pg]);
          Colq:=Polygons[pg].Col;
        end;
    end;
    procedure MakePolygonsSym;
    var pg,i: integer;
    begin
      if length(vv) <> length(Polygons)*2 then
        setlength(vv,length(Polygons)*2);
      for pg:=0 to high(Polygons) do
      begin
        with vv[pg*2] do
        begin
          a[1]:=Atoms[Polygons[pg].a[1]].p;
          a[2]:=Atoms[Polygons[pg].a[2]].p;
          a[3]:=Atoms[Polygons[pg].a[3]].p;
          if Polygons[pg].a[4] = 0 then
            a[4]:=Atoms[Polygons[pg].a[3]].p else
            a[4]:=Atoms[Polygons[pg].a[4]].p;
          VisibleSide:=Polygons[pg].VisibleSide;
          Neglect:=PolygonNeglected(Polygons[pg]);
          Colq:=Polygons[pg].Col;
        end;

        with vv[pg*2+1] do
        begin
          a[1]:=Atoms[Polygons[pg].a[1]].p;
          a[2]:=Atoms[Polygons[pg].a[2]].p;
          a[3]:=Atoms[Polygons[pg].a[3]].p;
          if Polygons[pg].a[4] = 0 then
            a[4]:=Atoms[Polygons[pg].a[3]].p else
            a[4]:=Atoms[Polygons[pg].a[4]].p;
          VisibleSide:=-Polygons[pg].VisibleSide;
          Colq:=Polygons[pg].Col;
          Neglect:=PolygonNeglected(Polygons[pg]);

          for i:=1 to 4 do
          case SymmetryAxes of
            plXY: a[i].z:=2*SymmetryCoord-a[i].z;
            plXZ: a[i].y:=2*SymmetryCoord-a[i].y;
            plYZ: a[i].x:=2*SymmetryCoord-a[i].x;
          end;
        end;
      end;
    end;
  var pg,e,i: integer;
      p: TSinglePoint;
      ind: array of integer;
  begin
    with pb3D,pb3DCanvas do
    begin
      if ((CurMode = tiEdit) and ShowSymmetryEdit1.Checked) or ((CurMode = tiRun) and ShowSymmetryRun1.Checked) then
        MakePolygonsSym else
        MakePolygons;
      setlength(ind,length(vv));

      Brush.Color:=clWhite;
      Pen.Color:=clDefault;
      i:=0;
      for pg:=0 to high(vv) do
      begin
        vv[pg].vctr:=Proj3D(Scale3D(Add3D(Add3D(Add3D(vv[pg].a[1],vv[pg].a[2]),vv[pg].a[3]),vv[pg].a[4]),1/4),p);
        vv[pg].vmin:=min(min(min(Proj3D(vv[pg].a[1],p),Proj3D(vv[pg].a[2],p)),Proj3D(vv[pg].a[3],p)),Proj3D(vv[pg].a[4],p));
        vv[pg].vmax:=max(max(max(Proj3D(vv[pg].a[1],p),Proj3D(vv[pg].a[2],p)),Proj3D(vv[pg].a[3],p)),Proj3D(vv[pg].a[4],p));
        vv[pg].Plane:=PlaneThroughThreePoints(vv[pg].a[1],vv[pg].a[2],vv[pg].a[3]);
        vv[pg].dp:=DotProduct3D(a3DPoint(-sinyaw,-cosyaw,sinpitch/cospitch),vv[pg].Plane.p);

        if vv[pg].VisibleSide*
              AreaSingle([
                Proj2D(vv[pg].a[1],pl3D),
                Proj2D(vv[pg].a[2],pl3D),
                Proj2D(vv[pg].a[3],pl3D),
                Proj2D(vv[pg].a[4],pl3D)]) >= 0 then
        begin
          ind[i]:=pg;
          inc(i);
          vv[pg].centre:=Scale3D(Add3D(Add3D(Add3D(
            vv[pg].a[1],
            vv[pg].a[2]),
            vv[pg].a[3]),
            vv[pg].a[4]),1/4);
        end;
      end;
      setlength(ind,i);

      Quicksort(ind);

      for i:=0 to high(ind) do
      begin
        SetPolygonColor(ind[i]);

        if not vv[ind[i]].Neglect then
        if ((DrawOnePolyhedron < 0) and (DrawOnePolygon < 0)) or (DrawOnePolygon = ind[i]) or PolygonInPolyhedron(ind[i],DrawOnePolyhedron) then
        begin
          PolygonZoom(pb3DCanvas,[
            Proj2D(vv[ind[i]].a[1],pl3D),
            Proj2D(vv[ind[i]].a[2],pl3D),
            Proj2D(vv[ind[i]].a[3],pl3D),
            Proj2D(vv[ind[i]].a[4],pl3D)],pl3D);
        end;
        Pen.Style:=psSolid;
//        DrawEdges(ind[i]);
      end;
    end;
  end;
  procedure DrawBase;
  begin
    with pb3D,pb3DCanvas do
    begin
      Pen.Color:=clBlack;
      MoveTo2D(pb3DCanvas,a3DPoint(-szBase,-szBase,0),pl3D);
      LineTo2D(pb3DCanvas,a3DPoint(+szBase,-szBase,0),pl3D);
      LineTo2D(pb3DCanvas,a3DPoint(+szBase,+szBase,0),pl3D);
      LineTo2D(pb3DCanvas,a3DPoint(-szBase,+szBase,0),pl3D);
      LineTo2D(pb3DCanvas,a3DPoint(-szBase,-szBase,0),pl3D);
    end;
  end;
  procedure DrawSection;
  var TL,BR: T3DPoint;
      i: integer;
  const n = 7;
  begin
    if ShowSectionJPG and (length(dlgImportImages.Pixs) > 0) then
    case CurSection of
      plXY: begin
              TL:=a3DPoint(-length(dlgImportImages.Pixs)/2,-dlgImportImages.Pixs[0].Width/2,ZSectionCoord);
              BR:=a3DPoint(+length(dlgImportImages.Pixs)/2,+dlgImportImages.Pixs[0].Width/2,ZSectionCoord);
            end;
      plXZ: begin
              TL:=a3DPoint(-length(dlgImportImages.Pixs)/2,dlgImportImages.Pixs[0].Width*PixsIndex-dlgImportImages.Pixs[0].Width/2,dlgImportImages.Pixs[0].Height);
              BR:=a3DPoint(+length(dlgImportImages.Pixs)/2,dlgImportImages.Pixs[0].Width*PixsIndex-dlgImportImages.Pixs[0].Width/2,0);
            end;
      plYZ: begin
              TL:=a3DPoint(length(dlgImportImages.Pixs)*PixsIndex-length(dlgImportImages.Pixs)/2,-dlgImportImages.Pixs[0].Width/2,dlgImportImages.Pixs[0].Height);
              BR:=a3DPoint(length(dlgImportImages.Pixs)*PixsIndex-length(dlgImportImages.Pixs)/2,+dlgImportImages.Pixs[0].Width/2,0);
            end;
    end else
    begin
      TL:=Zero3DPoint;
      BR:=Zero3DPoint;
    end;

    with pb3D,pb3DCanvas do
    begin
      Pen.Color:=clSectionGrid;
      for i:=0 to n do
      case CurSection of
        plXY:
          begin                                                                    
            MoveTo2D(pb3DCanvas,a3DPoint(TL.x+(BR.x-TL.x)*i/n,TL.y,TL.z),pl3D);
            LineTo2D(pb3DCanvas,a3DPoint(TL.x+(BR.x-TL.x)*i/n,BR.y,TL.z),pl3D);
            MoveTo2D(pb3DCanvas,a3DPoint(TL.x,TL.y+(BR.y-TL.y)*i/n,TL.z),pl3D);
            LineTo2D(pb3DCanvas,a3DPoint(BR.x,TL.y+(BR.y-TL.y)*i/n,TL.z),pl3D);
          end;
        plXZ:
          begin
            MoveTo2D(pb3DCanvas,a3DPoint(TL.x+(BR.x-TL.x)*i/n,TL.y,TL.z),pl3D);
            LineTo2D(pb3DCanvas,a3DPoint(TL.x+(BR.x-TL.x)*i/n,TL.y,BR.z),pl3D);
            MoveTo2D(pb3DCanvas,a3DPoint(TL.x,TL.y,TL.z+(BR.z-TL.z)*i/n),pl3D);
            LineTo2D(pb3DCanvas,a3DPoint(BR.x,TL.y,TL.z+(BR.z-TL.z)*i/n),pl3D);
          end;
        plYZ:
          begin
            MoveTo2D(pb3DCanvas,a3DPoint(TL.x,TL.y+(BR.y-TL.y)*i/n,TL.z),pl3D);
            LineTo2D(pb3DCanvas,a3DPoint(TL.x,TL.y+(BR.y-TL.y)*i/n,BR.z),pl3D);
            MoveTo2D(pb3DCanvas,a3DPoint(TL.x,TL.y,TL.z+(BR.z-TL.z)*i/n),pl3D);
            LineTo2D(pb3DCanvas,a3DPoint(TL.x,BR.y,TL.z+(BR.z-TL.z)*i/n),pl3D);
          end;
      end;
    end;
  end;
  procedure DrawSymmetry;
  var TL,BR: T3DPoint;
      i: integer;
  const n = 7;
  begin
    case SymmetryAxes of
      plXY: begin
              TL:=a3DPoint(-szBase,-szBase,SymmetryCoord);
              BR:=a3DPoint(+szBase,+szBase,SymmetryCoord);
            end;
      plXZ: begin
              TL:=a3DPoint(-szBase,SymmetryCoord,szBase*2);
              BR:=a3DPoint(+szBase,SymmetryCoord,0);
            end;
      plYZ: begin
              TL:=a3DPoint(SymmetryCoord,-szBase,szBase*2);
              BR:=a3DPoint(SymmetryCoord,+szBase,0);
            end;
    end;

    with pb3D,pb3DCanvas do
    begin
      Pen.Color:=clSymmetryGrid;
      for i:=0 to n do
      case SymmetryAxes of
        plXY:
          begin
            MoveTo2D(pb3DCanvas,a3DPoint(-szBase+szBase*2*i/n,-szBase,SymmetryCoord),pl3D);
            LineTo2D(pb3DCanvas,a3DPoint(-szBase+szBase*2*i/n,+szBase,SymmetryCoord),pl3D);
            MoveTo2D(pb3DCanvas,a3DPoint(-szBase,-szBase+szBase*2*i/n,SymmetryCoord),pl3D);
            LineTo2D(pb3DCanvas,a3DPoint(+szBase,-szBase+szBase*2*i/n,SymmetryCoord),pl3D);
          end;
        plXZ:
          begin
            MoveTo2D(pb3DCanvas,a3DPoint(-szBase+szBase*2*i/n,SymmetryCoord,0),pl3D);
            LineTo2D(pb3DCanvas,a3DPoint(-szBase+szBase*2*i/n,SymmetryCoord,+szBase*2),pl3D);
            MoveTo2D(pb3DCanvas,a3DPoint(-szBase,SymmetryCoord,szBase*2*i/n),pl3D);
            LineTo2D(pb3DCanvas,a3DPoint(+szBase,SymmetryCoord,szBase*2*i/n),pl3D);
          end;
        plYZ:
          begin                                                                          
            MoveTo2D(pb3DCanvas,a3DPoint(SymmetryCoord,-szBase+szBase*2*i/n,0),pl3D);
            LineTo2D(pb3DCanvas,a3DPoint(SymmetryCoord,-szBase+szBase*2*i/n,+szBase*2),pl3D);
            MoveTo2D(pb3DCanvas,a3DPoint(SymmetryCoord,-szBase,szBase*2*i/n),pl3D);
            LineTo2D(pb3DCanvas,a3DPoint(SymmetryCoord,+szBase,szBase*2*i/n),pl3D);
          end;
      end;
    end;
  end;
  procedure DrawAxes;
  begin
    with pb3D,pb3DCanvas do
    begin
      Font.Color:=clGray;
      Pen.Color:=clGray;
      Brush.Style:=bsClear;
      MoveTo2D(pb3DCanvas,a3DPoint(-szBase+40,-szBase+8, 0),pl3D);
      LineTo2D(pb3DCanvas,a3DPoint(-szBase+8, -szBase+8, 0),pl3D);
      LineTo2D(pb3DCanvas,a3DPoint(-szBase+8, -szBase+40,0),pl3D);
      MoveTo2D(pb3DCanvas,a3DPoint(-szBase+8, -szBase+8, 0),pl3D);
      LineTo2D(pb3DCanvas,a3DPoint(-szBase+8, -szBase+8,40),pl3D);
      with Proj2DZoom(a3DPoint(-szBase+40+4,-szBase+8, 0),pl3D) do TextOut(x-3,y-TextHeight('X'),'x');
      with Proj2DZoom(a3DPoint(-szBase+8, -szBase+40+4,0),pl3D) do TextOut(x-3,y-TextHeight('X'),'y');
      with Proj2DZoom(a3DPoint(-szBase+8, -szBase+8,40+4),pl3D) do TextOut(x-3,y-TextHeight('X'),'z');
      Font.Color:=clBlack;
      Pen.Color:=clBlack;
      Brush.Style:=bsSolid;
    end;
  end;
  procedure DrawZoomRotate;
  begin
    with pb3D,pb3DCanvas do
    begin
      Pen.Color:=clGray;
      case MouseMode of
        mmZooming:
          begin
            DrawArrow(pb3DCanvas,pMouseDown.x,pMouseDown.y,pMouseDown.x-20,pMouseDown.y-20,5,5);
            DrawArrow(pb3DCanvas,pMouseDown.x,pMouseDown.y,pMouseDown.x-20,pMouseDown.y+20,5,5);
            DrawArrow(pb3DCanvas,pMouseDown.x,pMouseDown.y,pMouseDown.x+20,pMouseDown.y-20,5,5);
            DrawArrow(pb3DCanvas,pMouseDown.x,pMouseDown.y,pMouseDown.x+20,pMouseDown.y+20,5,5);
          end;
      end;
    end;
  end;
var a: TAtomRef;
    b: TStrutRef;
    p: integer;
    aRect: TRect;
    p1: TPoint;
    d: FPnumber;
    RoofAxes: TRoofAxes;
au,av,aw,
    cp3,cp4: T3DPoint;
    a1,a2,a3,a4: TAtomRef;
begin
  ShowForces:=ShowAtomNums1.Checked;
  sinyaw:=sin(yaw);
  cosyaw:=cos(yaw);
  sinpitch:=sin(pitch);
  cospitch:=cos(pitch);

  clSelected:=dlgOptions.pnlColorSelect.Color;
  clUnSelected:=dlgOptions.pnlColorUnselect.Color;
  clDefault:=dlgOptions.pnlColorDefault.Color;
  clMuscle:=dlgOptions.pnlColorMuscle.Color;
  clCurMuscle:=dlgOptions.pnlColorSelMuscle.Color;
  if NumSelectedAtoms+NumSelectedStruts > 0 then
    colUnSelected:=clUnSelected else
    colUnSelected:=clDefault;

  with pb3D,pb3DCanvas do
  if (Width > 16) and (Height > 16) then
  begin
    if Vudist <= 0 then
    begin
      aRect:=ClientRect;
      Brush.Color:=clBtnFace;
      FillRect(aRect);
    end else
    begin
      aRect:=ClientRect;
  //    ARect.Bottom:=round(zoom*Horizon);
      ARect.Bottom:=ZoomScroll(0,Horizon,pl3D).y;
      Brush.Color:=RGB(240,240,255);
      FillRect(aRect);
      aRect:=ClientRect;
  //  ARect.Top:=round(zoom*Horizon);
      ARect.Top:=ZoomScroll(0,Horizon,pl3D).y;
      Brush.Color:=clBtnFace;
      FillRect(aRect);
    end;

    DrawBase;
    if CurMode = tiEdit then
    begin
      if not ShowPolygonsEdit1.Checked then
      begin
        DrawSection;
        DrawSymmetry;
      end;
      DrawAxes;
    end;
    if ((CurMode = tiEdit) and ShowPolygonsEdit1.Checked) or ((CurMode = tiRun) and ShowPolygonsRun1.Checked) then
    begin
      DrawPolygons(-1,-1);
    end else
    begin
      if InRange(SpinEdit1.Value,0,high(Polyhedron)) then
      begin
        DrawPolygons(SpinEdit1.Value,-1);
        Label1.Caption:='Vol='+inttostr(round(PolyhedronVolume(SpinEdit1.Value)));
      end else
      if InRange(SpinEdit2.Value,0,high(Polygons)) then
      begin
        DrawPolygons(-1,SpinEdit2.Value);
      end else
      begin
        DrawSpheroids;
        DrawStruts;
      end;
    end;
    if ((CurMode = tiRun) and Show3Datoms1.Checked) or ((CurMode = tiEdit) and Show3Datoms2.Checked) then
      DrawAtoms;
    for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
      if ((CurMode = tiRun) and Roof2.Checked and HasConstraint[RoofAxes]) or ((CurMode = tiEdit) and Roof3.Checked and HasConstraint[RoofAxes]) then
        DrawRoof(RoofAxes);
    DrawRubberBand;
    DrawZoomRotate;
    if (MouseMode = mmSelecting) and (MouseModeAxes = pl3D) then
      DrawSelectionBox;
    if pnlRecordingMovie.Visible and not sbTimeline.Down then
      SaveScreenShot('Mov',true);
  end;
  colUnSelected:=clBlack;
end;

procedure TForm1.ScrollBar2Change(Sender: TObject);
begin
  pb3DInvalidate;
end;

procedure TForm1.DrawLine3D(pa,pb: T3DPoint);
var p1,p2: TPoint;
begin
  if Proj3DZoom(pa,p1) > 0 then
  if Proj3DZoom(pb,p2) > 0 then
  with pb3D,pb3DCanvas do
  begin
    MoveTo(p1.x,p1.y);
    LineTo(p2.x,p2.y);
  end;
end;

procedure TForm1.pb3DMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var p2,l1,l2: integer;
const PrevTime: integer = 0;
begin
  if GetKeyState(vk_RButton) < 0 then
  begin
    if (MouseMode = mmRotating) or (MouseMode = mmZooming) then
    begin
      MouseMode:=mmNone;
      InvalidateAll;
    end else
    begin
      SetUndo;
      MouseModeAxes:=pl3D;
      pMousePrev.x:=x;
      pMousePrev.y:=y;
      pMouseDown.x:=x;
      pMouseDown.y:=y;
      ZoomRot:=0;
      Rotate1.Enabled:=false;
      PopupMenu1.Popup(mouse.CursorPos.x,mouse.CursorPos.y);
    end;
  end else
  begin
//    SetUndo;
    pMousePrev.x:=x;
    pMousePrev.y:=y;
    pMouseDown.x:=x;
    pMouseDown.y:=y;
    MouseMode:=mmNone;

    if (GetKeyState(vk_ScrollViewA) < 0) and (GetKeyState(vk_ScrollViewB) < 0) then
    begin
      MouseMode:=mmScrolling;
      MouseModeAxes:=pl3D;
    end else
    if CurMode = tiEdit then
    begin
      MouseMode:=mmNone;

      if ((GetTickCount < PrevTime+GetDoubleClickTime) and (NumSelectedAtoms = 1)) or (GetKeyState(vk_MakeStrut) < 0) then
        if FindAtom(x,y,CaptureDist,pl3D,false) > 0 then
          MouseMode:=mmMakingStrut;
      MouseModeAxes:=pl3D;

      if (MouseMode = mmMakingStrut) then
      begin
        MovingAtom:=NearestAtom(x,y,pl3D);
        if (MovingAtom > 0) and (pythag(x-Proj2D(Atoms[MovingAtom].p,pl3D).x,y-Proj2D(Atoms[MovingAtom].p,pl3D).y) < CaptureDist) then
          pb3DMouseMove(Sender,Shift,X,Y) else
          MovingAtom:=0;
        if MovingAtom = 0 then
        begin
          SelectAtom(0,false);
          SelectStrut(NearestStrut(x,y,pl3D),false);
        end;
      end else
      if MouseMode = mmSelecting then
      begin
        SelectRect:=Rect(x,y,x,y);
        MouseModeAxes:=pl3D;
        SelectInRect;
      end else
      begin
        CurAtom:=FindAtom(x,y,CaptureDist,pl3D,true);
        if CurAtom = 0 then
        begin
          l1:=FindStrutXY(x,y,CaptureDist,pl3D);
          if (l1 <> 0) then
          begin
            if GetKeyState(vk_Minus) < 0 then
              Struts[l1].Selected:=false else
            if GetKeyState(vk_Plus) < 0 then
              Struts[l1].Selected:=true else
              for l2:=1 to NumStruts do
                Struts[l2].Selected:=(l1 = l2);
            InvalidateAll;
          end;
        end else
        begin
          if GetKeyState(vk_Minus) < 0 then
            UnSelectAtom(CurAtom) else
          if GetKeyState(vk_Plus) < 0 then
            SelectAtom(CurAtom,true) else
            SelectAtom(CurAtom,false);
          InvalidateAll;
        end;
      end;
    end;
    PrevTime:=GetTickCount;
  ChkPoly;
  end;
end;

procedure TForm1.pb3DMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var a: TAtomNum;
begin
  if MouseMode = mmZooming then
  begin
    while (pMouseDown.x-x) div 8 > ZoomRot do
    begin
      ZoomInOutEx(+1,pMouseDown,MouseModeAxes);
      inc(ZoomRot);
      InvalidateAll;
    end;
    while (pMouseDown.x-x) div 8 < ZoomRot do
    begin
      ZoomInOutEx(-1,pMouseDown,MouseModeAxes);
      dec(ZoomRot);
      InvalidateAll;
    end;
  end else
  if ssLeft in Shift then
  begin
    if MouseMode = mmScrolling then
    begin
      Ofs3DX:=Ofs3DX+x-pMousePrev.x;
      Ofs3DY:=Ofs3DY+y-pMousePrev.y;
      pMousePrev.x:=x;
      pMousePrev.y:=y;
      pb3DInvalidate;
      pb3D.Update;
    end else
    if MouseMode = mmMakingStrut then
    begin
      a:=NearestAtom(x,y,pl3D);
      if pythag(x-Proj2D(Atoms[a].p,pl3D).x,y-Proj2D(Atoms[a].p,pl3D).y) < 8 then
        RubberBand:=Proj2DZoom(Atoms[a].p,pl3D) else
        RubberBand:=Point(x,y);
      pb3DInvalidate;
      Modified:=true;
    end else
    if MouseMode = mmSelecting then
    begin
      SelectRect:=Rect(SelectRect.Left,SelectRect.Top,x,y);
      SelectInRect;
      pb3DInvalidate;
      pb3D.Update;
    end else
    begin
      Yaw:=Yaw+(x-pMousePrev.x)/200*pi;
      if Yaw < 0 then Yaw:=Yaw+2*pi;
      if Yaw > 2*pi then Yaw:=Yaw-2*pi;
      Pitch:=Pitch+(y-pMousePrev.y)/400*pi;
      Pitch:=RealRange(Pitch,0,pi/2);
      pMousePrev.x:=x;
      pMousePrev.y:=y;
      pb3DInvalidate;
      pb3D.Update;
//      pb3D.Cursor:=crHandPoint;
    end;
  end;
end;

procedure TForm1.pb3DMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var a: TAtomNum;
begin
  pMouseDown.x:=x;
  pMouseDown.y:=y;

  if (MouseMode = mmMakingStrut) and (MovingAtom > 0) then
  begin
    a:=NearestAtom(x,y,pl3D);
    if pythag(x-Proj2D(Atoms[a].p,pl3D).x,y-Proj2D(Atoms[a].p,pl3D).y) < 8 then
    if MovingAtom <> a then
    begin
      NewStrut(MovingAtom,a,Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
      SetupStruts;
      SelectStrut(NumStruts,false);
    end;
  end;
  MouseMode:=mmNone;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  LoadSaveIniFile(false);
end;

procedure TForm1.LoadSaveIniFile(Load: Boolean);
var RoofAxes: TRoofAxes;
begin
  OpenDialog1.FileName:=LoadSaveMyIniFileString(Load,'General','FileName',OpenDialog1.FileName,OpenDialog1.FileName);
  pnl3D.Height:=LoadSaveMyIniFileInt(Load,'Layout','pnl3D.Height',pnl3D.Height,pnl3D.Height);
  pnlXZ.Height:=pnl3D.Height;
  Panel12.Top:=pnl3D.Height;
  Panel1.Width:=LoadSaveMyIniFileInt(Load,'Layout','Panel1.Width',Panel1.Width,Panel1.Width);
  ShowPolygonsRun1.Checked:=LoadSaveMyIniFileBool(Load,'General','ShowPolygonsRun1.Checked',ShowPolygonsRun1.Checked,ShowPolygonsRun1.Checked);
  ShowPolygonsEdit1.Checked:=LoadSaveMyIniFileBool(Load,'General','ShowPolygonsEdit1.Checked',ShowPolygonsEdit1.Checked,ShowPolygonsEdit1.Checked);
  ShowSymmetryRun1.Checked:=LoadSaveMyIniFileBool(Load,'General','ShowSymmetryRun1.Checked',ShowSymmetryRun1.Checked,ShowSymmetryRun1.Checked);
  ShowSymmetryEdit1.Checked:=LoadSaveMyIniFileBool(Load,'General','ShowSymmetryEdit1.Checked',ShowSymmetryEdit1.Checked,ShowSymmetryEdit1.Checked);
  ShowAtomNums1.Checked:=LoadSaveMyIniFileBool(Load,'General','ShowAtomNums1.Checked',ShowAtomNums1.Checked,ShowAtomNums1.Checked);
  CurSection:=TAxes(LoadSaveMyIniFileInt(Load,'Layout','CurSection',ord(CurSection),ord(CurSection)));
  ShowSectionJPG:=LoadSaveMyIniFileBool(Load,'General','ShowSectionJPG',ShowSectionJPG,ShowSectionJPG);
  PixsIndex:=LoadSaveMyIniFileDouble(Load,'Layout','PixsIndex',PixsIndex,PixsIndex);
  Roof2.Checked:=LoadSaveMyIniFileBool(Load,'General','Roof2.Checked',Roof2.Checked,Roof2.Checked);
  Roof3.Checked:=LoadSaveMyIniFileBool(Load,'General','Roof3.Checked',Roof3.Checked,Roof3.Checked);
  ShowClosure1.Checked:=LoadSaveMyIniFileBool(Load,'General','ShowClosure1.Checked',ShowClosure1.Checked,ShowClosure1.Checked);
  LockKeyframes1.Checked:=LoadSaveMyIniFileBool(Load,'General','LockKeyframes1.Checked',LockKeyframes1.Checked,LockKeyframes1.Checked);
  pnlMuscleChart.Visible:=LoadSaveMyIniFileBool(Load,'General','pnlMuscleChart.Visible',pnlMuscleChart.Visible,pnlMuscleChart.Visible);
  Splitter1.Visible:=pnlMuscleChart.Visible;
  for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
    RoofColor[RoofAxes]:=LoadSaveMyIniFileInt(Load,'Layout','RoofColor['+inttostr(ord(RoofAxes))+']',RoofColor[RoofAxes],RoofColor[RoofAxes]);
end;

procedure TForm1.Contents1Click(Sender: TObject);
begin
    Application.HelpContext(1);
  fmHelp.ShowModal;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=SaveIfModified(true);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  DragAcceptFiles(Handle, True);
end;

procedure TForm1.WMDropFiles(var Msg: TWMDropFiles);
var
  CFileName: array[0..MAX_PATH] of Char;
begin
  try
    if DragQueryFile(Msg.Drop, 0, CFileName, MAX_PATH) > 0 then
    begin
      if not SaveIfModified(true) then
        exit;
      OpenProjectFile(CFileName);
      Msg.Result:=0;
    end;
  finally
    DragFinish(Msg.Drop);
  end;
end;

procedure TForm1.ClearAll(RetainKeyframes: boolean);
begin
  SetNumAtoms(0);
  SetNumStruts(0);
  Polyhedron:=nil;
  Polygons:=nil;
  if not RetainKeyframes then
  begin
    while length(muscle) > 0 do
      DeleteMuscle(0);
    While length(Keyframe) > 1 do
      DeleteKeyframe(1);
    setlength(Keyframe,1);
    setlength(Keyframe[0].posq,0);
    Keyframe[0].jpgBGXY:='';
    Keyframe[0].jpgBGXZ:='';
    Keyframe[0].jpgBGYZ:='';
  end;
  SymmetryAxes:=pl3D;
  Undo.Clear;
end;

procedure TForm1.New1Click(Sender: TObject);
begin
  if not SaveIfModified(true) then exit;
  TimelineCurTime:=0;
  IsAtKeyframe;
  Stop;
  ClearAll(false);

  SetUndo;
  SetMainFilename('');
//  DllNewFilename('');
//  dlgOptions.rgViewFollows.ItemIndex:=ord(AutoScrollIfOffScreen);
  Modified:=False;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
  Stop;
  if SaveIfModified(true) then
    if OpenDialog1.Execute then
      OpenProjectFile(OpenDialog1.Filename);
end;

procedure TForm1.Save1Click(Sender: TObject);
begin
  SaveFile(OpenDialog1.Filename);
end;

procedure TForm1.SaveAs1Click(Sender: TObject);
begin
  with SaveDialog1 do
  if Execute then
  begin
    if ExtractFileExt(FileName) = '' then filename:=filename+'.s3d';
    if CanOverwrite(Filename) then
    begin
      SaveFile(Filename);
      SetMainFilename(Filename);
//      DllNewFilename(Filename);
    end;
  end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  SetPanelSizes(Panel1.Width,pnl3D.Height);
  pnlTimeline2.Width:=pnlTimeline1.Width;
end;

function TForm1.AtomNearCurSection(a: TAtomRef): boolean;
begin
  result:=false;
  case CurSection of
    plXY: result:=abs(Atoms[a].p.z - ZSectionCoord) < CaptureDist;
    plXZ: result:=abs(Atoms[a].p.y - YSectionCoord) < CaptureDist;
    plYZ: result:=abs(Atoms[a].p.x - XSectionCoord) < CaptureDist;
  end;
end;

function TForm1.RoofNearCurSection(RoofAxes: TRoofAxes; i,j: integer): boolean;
begin
  result:=false;
  with MeshPoint3D(RoofAxes,i,j) do
  case CurSection of
    plXY: result:=abs(z - ZSectionCoord) < CaptureDist;
    plXZ: result:=abs(y - YSectionCoord) < CaptureDist;
    plYZ: result:=abs(x - XSectionCoord) < CaptureDist;
  end;
end;

procedure TForm1.SelectInRect;
  function AtomInRect(a: TAtomRef): boolean;
  begin
    with Proj2DZoom(Atoms[a].p,MouseModeAxes) do
      result:=
        InRealRange(x,IntMin([SelectRect.Left,SelectRect.Right]),IntMax([SelectRect.Left,SelectRect.Right])) and
        InRealRange(y,IntMin([SelectRect.Top,SelectRect.Bottom]),IntMax([SelectRect.Top,SelectRect.Bottom]));

    if result and (MouseModeAxes = CurSection) then
      result:=AtomNearCurSection(a);
  end;
  function RoofInRect(RoofAxes: TRoofAxes; i,j: integer): boolean;
  begin
    with MeshPoint2D(RoofAxes,i,j,MouseModeAxes) do
      result:=
        InRealRange(x,IntMin([SelectRect.Left,SelectRect.Right]),IntMax([SelectRect.Left,SelectRect.Right])) and
        InRealRange(y,IntMin([SelectRect.Top,SelectRect.Bottom]),IntMax([SelectRect.Top,SelectRect.Bottom]));

    if result and (MouseModeAxes = CurSection) then
      result:=RoofNearCurSection(RoofAxes,i,j);
  end;
  function StrutCrossesSection(b: TStrutNum): boolean;
  begin
    result:=false;
    case CurSection of
      plXY: result:=(Atoms[Struts[b].Atom1].p.z - ZSectionCoord) *
                    (Atoms[Struts[b].Atom2].p.z - ZSectionCoord) <= 0;
      plXZ: result:=(Atoms[Struts[b].Atom1].p.y - YSectionCoord) *
                    (Atoms[Struts[b].Atom2].p.y - YSectionCoord) <= 0;
      plYZ: result:=(Atoms[Struts[b].Atom1].p.x - XSectionCoord) *
                    (Atoms[Struts[b].Atom2].p.x - XSectionCoord) <= 0;
    end;
  end;
  function StrutCrossesVert(b: TStrutNum; x,y1,y2: integer): boolean;
  var y: FPnumber;
      pa,pb: TPoint;
  begin
    with Struts[b] do
    begin
      pa:=Proj2DZoom(Atoms[Atom1].p,MouseModeAxes);
      pb:=Proj2DZoom(Atoms[Atom2].p,MouseModeAxes);
    end;

    if abs(pa.x-pb.x) < 0.1 then
      result:=false else
    begin
      y:=(x-pa.x)*(pb.y-pa.y)/(pb.x-pa.x)+pa.y;
      result:=InRange(trunc(y),IntMin([y1,y2]),IntMax([y1,y2])) and
              InRange(trunc(x),IntMin([round(pa.x),round(pb.x)]),IntMax([round(pa.x),round(pb.x)]));
    end;

    if result and (CurSection = MouseModeAxes) then
//    if result and (CurSection <> pl3D) and (CurSection <> MouseModeAxes) then
      result:=StrutCrossesSection(b);
  end;
  function StrutCrossesHorz(b: TStrutNum; x1,x2,y: integer): boolean;
  var x: FPnumber;
      pa,pb: TPoint;
  begin
    with Struts[b] do
    begin
      pa:=Proj2DZoom(Atoms[Atom1].p,MouseModeAxes);
      pb:=Proj2DZoom(Atoms[Atom2].p,MouseModeAxes);
    end;

    if abs(pb.y-pa.y) < 0.1 then
      result:=false else
    begin
      x:=(y-pa.y)*(pb.x-pa.x)/(pb.y-pa.y)+pa.x;
      result:=InRange(trunc(x),IntMin([x1,x2]),IntMax([x1,x2])) and
              InRange(trunc(y),IntMin([round(pa.y),round(pb.y)]),IntMax([round(pa.y),round(pb.y)]));
    end;

    if result and (CurSection = MouseModeAxes) then
//    if result and (CurSection <> pl3D) and (CurSection <> MouseModeAxes) then
      result:=StrutCrossesSection(b);
  end;
  function StrutInRect(b: TStrutNum): boolean;
  begin
    with Struts[b],SelectRect do
      result:=
          AtomInRect(Atom1) or
          AtomInRect(Atom2) or
          StrutCrossesVert(b,Left,Bottom,Top) or
          StrutCrossesVert(b,Right,Bottom,Top) or
          StrutCrossesHorz(b,Left,Right,Bottom) or
          StrutCrossesHorz(b,Left,Right,Top);
  end;
var a: TAtomRef;
    b: TStrutRef;
    RoofAxes: TRoofAxes;
var i,j: integer;
begin
  if GetKeyState(vk_Minus) < 0 then
  begin
    for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
      if Roof3.Checked and HasConstraint[RoofAxes] then
        for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
          for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
            if RoofInRect(RoofAxes,i,j) then
              UnSelectAtom(RoofAtomNum(RoofAxes,i,j));

    for a:=1 to NumAtoms do
      if AtomInRect(a) then
        UnSelectAtom(a);
    for b:=1 to NumStruts do
      with Struts[b],SelectRect do
        Selected:=Selected and not StrutInRect(b);
  end else
  if GetKeyState(vk_Plus) < 0 then
  begin
    for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
      if Roof3.Checked and HasConstraint[RoofAxes] then
        for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
          for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
            if RoofInRect(RoofAxes,i,j) then
              SelectAtom(RoofAtomNum(RoofAxes,i,j),true);

    for a:=1 to NumAtoms do
      if AtomInRect(a) then
        SelectAtom(a,true);
    for b:=1 to NumStruts do
      with Struts[b],SelectRect do
        Selected:=Selected or StrutInRect(b);
  end else
  begin
    for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
      if Roof3.Checked and HasConstraint[RoofAxes] then
        for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
          for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
            UnSelectAtom(RoofAtomNum(RoofAxes,i,j));
    for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
      if Roof3.Checked and HasConstraint[RoofAxes] then
        for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
          for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
            if RoofInRect(RoofAxes,i,j) then
              SelectAtom(RoofAtomNum(RoofAxes,i,j),true);

    for a:=1 to NumAtoms do
      UnSelectAtom(a);
    for a:=1 to NumAtoms do
      if AtomInRect(a) then
        SelectAtom(a,true);
    for b:=1 to NumStruts do
      with Struts[b],SelectRect do
        Selected:=StrutInRect(b);
  end;
end;

function TForm1.NumSelectedAtoms: integer;
var a: TAtomRef;
begin
  result:=0;

  for a:=1 to NumAtoms do
    with Atoms[a] do
     if Selected then
       inc(result);
end;

function TForm1.NumSelectedStruts: integer;
var b: TStrutRef;
begin
  result:=0;
  for b:=1 to NumStruts do
    with Struts[b] do
     if StrutSelected(b) then
       inc(result);
end;

function TForm1.StrutSelected(b: TStrutNum): boolean;
begin
  with Struts[b] do
//    result:=Selected or Atoms[Atom1].Selected or Atoms[Atom2].Selected;
    result:=Selected;
end;

procedure TForm1.tcModeChange(Sender: TObject);
  procedure CheckRigid;
  var a: integer;
  begin
    for a:=1 to NumAtoms do
    begin
      Atoms[a].pOriginal:=Atoms[a].p;
      if Atoms[a].Rigid <> nil then
        if SymmetryAxes = pl3D then
        begin
          ShowWarningMessage('Rigid bodies can only work when there is a symmetry plane');
          exit;
        end;
    end;
  end;
var i: integer;
    m: integer;
var ia: integer;
    oldModified: boolean;
begin
{  if (TMode(tcMode.Tabindex) = tiRun) and HasCloseAtoms then
  begin
    ShowCloseAtoms1.Checked:=true;
    ShowErrorMessage('Has Close Atoms. Cannot run simulation');
    tcMode.Tabindex:=ord(tiEdit);
    exit;
  end;           }

  if Running then
  begin
    Zoom:=LoadSaveMyIniFileDouble(false,'Layout','RunZoom',Zoom,Zoom);
    bOfs2DX:=LoadSaveMyIniFileInt(false,'Layout','RunOfs2DX',bOfs2DX,bOfs2DX);
    aOfs2DY:=LoadSaveMyIniFileInt(false,'Layout','RunOfs2DY',aOfs2DY,aOfs2DY);
    aOfs2DZ:=LoadSaveMyIniFileInt(false,'Layout','RunOfs2DZ',aOfs2DZ,aOfs2DZ);
    Ofs3DX:=LoadSaveMyIniFileInt(false,'Layout','RunOfs3DX',Ofs3DX,Ofs3DX);
    Ofs3DY:=LoadSaveMyIniFileInt(false,'Layout','RunOfs3DY',Ofs3DY,Ofs3DY);
  end else
  begin
    Zoom:=LoadSaveMyIniFileDouble(false,'Layout','EditZoom',Zoom,Zoom);
    bOfs2DX:=LoadSaveMyIniFileInt(false,'Layout','EditOfs2DX',bOfs2DX,bOfs2DX);
    aOfs2DY:=LoadSaveMyIniFileInt(false,'Layout','EditOfs2DY',aOfs2DY,aOfs2DY);
    aOfs2DZ:=LoadSaveMyIniFileInt(false,'Layout','EditOfs2DZ',aOfs2DZ,aOfs2DZ);
    Ofs3DX:=LoadSaveMyIniFileInt(false,'Layout','EditOfs3DX',Ofs3DX,Ofs3DX);
    Ofs3DY:=LoadSaveMyIniFileInt(false,'Layout','EditOfs3DY',Ofs3DY,Ofs3DY);
  end;

  CurMode:=TMode(tcMode.Tabindex);

   if running then
   for ia:=1 to NumAtoms do             //moved from within the solve loop so they are set only once
    begin
      Atoms[ia].f:=Zero3DPoint;
      Atoms[ia].af:=Zero3DPoint;
    end;


  imgYZ.Visible:=CurMode <> tiEdit;
  imgXY.Visible:=CurMode <> tiEdit;
  imgXZ.Visible:=CurMode <> tiEdit;
  img3D.Visible:=CurMode <> tiEdit;
  pbYZ.Visible:=CurMode = tiEdit;
  pbXY.Visible:=CurMode = tiEdit;
  pbXZ.Visible:=CurMode = tiEdit;
  pb3D.Visible:=CurMode = tiEdit;
//  SpeedButton1.Visible:=CurMode = tiEdit;
//  SpeedButton2.Visible:=CurMode = tiEdit;
//  SpeedButton3.Visible:=CurMode = tiEdit;
  SpeedButton1.Down:=SpeedButton1.Tag = ord(CurSection);
  SpeedButton2.Down:=SpeedButton2.Tag = ord(CurSection);
  SpeedButton3.Down:=SpeedButton3.Tag = ord(CurSection);
  pnlVolume.Visible:=CurMode <> tiEdit;
//  sbCentreClick(Sender);
  Timer1.enabled:=true;

//  SlowStart:=0;
//  ZeroAllPhaseOffset;
  MouseMode:=mmNone;
  SetCursor;
//  dlgTriangle.Close;
//  pnlTriangle.Visible:=false;

  if CurMode = tiEdit then
    pnlXZ.Color:=EditBgCol else
    pnlXZ.Color:=RunBgCol;
  pnlYZ.Color:=pnlXZ.Color;
  pnlXY.Color:=pnlXZ.Color;

  if Running then
  begin
    SavedPosition:=AtomsToString(true);
//    MakeSymmetrical;
    CalcStrutRestLength;
    SetPrevStrutLength;
    CalcAllVolumes;
    CalcAllAreas;
    Zoom:=LoadSaveMyIniFileDouble(true,'Layout','RunZoom',Zoom,Zoom);
//    Ofs2DX:=LoadSaveMyIniFileInt(true,'Layout','RunOfs2DX',Ofs2DX,Ofs2DX);
//    Ofs2DY:=LoadSaveMyIniFileInt(true,'Layout','RunOfs2DY',Ofs2DY,Ofs2DY);
//    Ofs2DZ:=LoadSaveMyIniFileInt(true,'Layout','RunOfs2DZ',Ofs2DZ,Ofs2DZ);
    Ofs3DX:=LoadSaveMyIniFileInt(true,'Layout','RunOfs3DX',Ofs3DX,Ofs3DX);
    Ofs3DY:=LoadSaveMyIniFileInt(true,'Layout','RunOfs3DY',Ofs3DY,Ofs3DY);

    CheckRigid;
  end else
  begin
    dlgEMA.ExportEMAFinish;
    tmrKeyframe.enabled:=false;
    sbTimeline.Down:=false;
    for m:=0 to high(muscle) do
      SetTrackBarPosition(m,100);

    oldModified:=Modified;
    if SavedPosition <> '' then
      StringToAtoms(SavedPosition,false,true,true);
    Modified:=oldModified;
    Zoom:=LoadSaveMyIniFileDouble(true,'Layout','EditZoom',Zoom,Zoom);
//    Ofs2DX:=LoadSaveMyIniFileInt(true,'Layout','EditOfs2DX',Ofs2DX,Ofs2DX);
//    Ofs2DY:=LoadSaveMyIniFileInt(true,'Layout','EditOfs2DY',Ofs2DY,Ofs2DY);
//    Ofs2DZ:=LoadSaveMyIniFileInt(true,'Layout','EditOfs2DZ',Ofs2DZ,Ofs2DZ);
    Ofs3DX:=LoadSaveMyIniFileInt(true,'Layout','EditOfs3DX',Ofs3DX,Ofs3DX);
    Ofs3DY:=LoadSaveMyIniFileInt(true,'Layout','EditOfs3DY',Ofs3DY,Ofs3DY);
  end;

//  SetSpinneretSlowStart;

//  if Running then
//    HideAllExcept:=StringToTName('');

  if Running then
  begin
    oldModified:=Modified;
//    DeleteFPnumberAtoms;
    DeleteSingleAtoms;
    Modified:=oldModified;
  end;

  if Running then
    img3D.cursor:=crSizeAll else
    img3D.cursor:=crDefault;
  pb3D.cursor:=img3D.cursor;

  SetupStruts;
  SelectAtom(0,false);
  SelectStrut(0,false);
  InvalidateAll;
  UndoButton.enabled:=CurMode = tiEdit;
//  ZPos1.enabled:=CurMode = tiEdit;
  Delete3.enabled:=CurMode = tiEdit;
  NewMuscle1.enabled:=CurMode = tiEdit;


//  Muscles1.enabled:=Running;
//  Edit1.enabled:=CurMode = tiEdit;
//  pnlMuscles.Visible:=Muscles1.Checked or (CurMode = tiEdit);
//  pnlPhysics.Visible:=Physics1.Checked;
//  Panel16.Visible:=Period1.Checked;
//  pnlHint.Visible:=CurMode = tiEdit;
  Paste1.Checked:=false;
  sPaste:='';
  SetUndo;
  Steps:=0;
  SetupStruts;
  StopAllAtoms(false);

  TimelineCurTime:=0;
  IsAtKeyframe;

ChkPoly;
  Timer1.enabled:=true;
end;

procedure TForm1.SetTrackBarPosition(m,i: integer);
begin
  with muscle[m] do
  begin
    if TrackBar.position>i then
    begin
      TrackBar.selend:=TrackBar.position;
      TrackBar.selStart:=i;
    end else if TrackBar.position<i then
    begin
      TrackBar.selstart:=TrackBar.position;
      TrackBar.selend:=i;
    end;
    TrackBar.position:=i;
    Label1.Caption:=Before(Label1.Caption,'=')+'='+inttostr(i)+'%';

  end;
end;

procedure TForm1.SetCursor;
var cur: TCursor;
    s,t: string;
begin
  if sPaste <> '' then
    cur:=curPASTE else
  if ((GetKeyState(vk_ScrollViewA) < 0) and (GetKeyState(vk_ScrollViewB) < 0)) or (MouseMode = mmScrolling) then
    cur:=crHandPoint else
  if CurMode = tiEdit then
  begin
    if (GetKeyState(vk_MakeStrut)  < 0) or (MouseMode = mmMakingStrut) then
      cur:=curMakeSTRUT else
    if (GetKeyState(vk_MakeAtom)  < 0) then
      cur:=curMakeATOM else
    if GetKeyState(vk_Plus) < 0 then
      cur:=curPLUS else
    if GetKeyState(vk_Minus) < 0 then
      cur:=curMinus else
      cur:=curPOINT;
  end else
    cur:=curPOINT;

  if cur <> pbYZ.Cursor then
  begin
    Screen.Cursor:=crDrag;
    pbYZ.Cursor:=cur;
//    imgYZ.Cursor:=cur;
    Screen.Cursor:=crDefault;
  end;
  if cur <> pbXY.Cursor then
  begin
    Screen.Cursor:=crDrag;
    pbXY.Cursor:=cur;
//    imgXY.Cursor:=cur;
    Screen.Cursor:=crDefault;
  end;
  if cur <> pbXZ.Cursor then
  begin
    Screen.Cursor:=crDrag;
    pbXZ.Cursor:=cur;
//    imgXZ.Cursor:=cur;
    Screen.Cursor:=crDefault;
  end;
end;

function TForm1.StrutsSelectedCount: integer;
var b: TStrutRef;
begin
  result:=0;
  for b:=1 to NumStruts do
    if StrutSelected(b) then
      inc(result);
end;

function TForm1.AtomsSelectedCount: integer;
var a: TAtomRef;
begin
  result:=0;
  for a:=1 to NumAtoms do
    if Atoms[a].Selected then
      inc(result);
end;

function RigidToString(r: array of integer; c: char): string;
var i: integer;
begin
  result:='';
  for i:=0 to high(r) do
    result:=result+c+inttostr(R[i]);
  result:=copy(result,2,10000000);
end;

procedure StringToRigid(var s: string; var r: tarrayofinteger; c: char);
var i: integer;
begin
  setlength(r,0);
  while NextIsNumber(s,i) do
  begin
    SetLength(r,Length(r)+1);
    r[high(r)]:=i;
    NextIs(s,c);
  end;
end;

function TForm1.AtomsToString(All: boolean): string;
var resultlen: integer;
  procedure AddToResult(s: string);
  begin
    if length(s)+resultlen > length(result) then
      setlength(result,length(result)+10000);
    move(s[1],result[resultlen+1],length(s));
    inc(resultlen,length(s));
  end;
  procedure SwapAtom(a: TAtomRef);
  var b: TStrutRef;
      Atom: TAtom;
  begin
    Atom:=Atoms[a];
    Atoms[a]:=Atoms[a+1];
    Atoms[a+1]:=Atom;
    for b:=1 to NumStruts do
    with Struts[b] do
    begin
      if Atom1 = a then Atom1:=a+1 else
      if Atom1 = a+1 then Atom1:=a;
      if Atom2 = a then Atom2:=a+1 else
      if Atom2 = a+1 then Atom2:=a;
    end;
  end;
  procedure SwapStrut(a: TStrutRef);
  var Strut: TStrut;
      b: TStrutRef;
  begin
    Strut:=Struts[a];
    Struts[a]:=Struts[a+1];
    Struts[a+1]:=Strut;
  end;
  function HasSelectedStrut(a: TAtomNum): boolean;
  var b: TStrutRef;
  begin
    result:=true;
    for b:=1 to NumStruts do
      with Struts[b] do
        if Selected and ((Atom1 = a) or (Atom2 = a)) then
          exit;
    result:=false;
  end;
  function AtomSelected(a: TAtomNum; HasAtomsSelected: boolean): boolean;
  begin
    if All then
      result:=true else
    if not HasAtomsSelected then
      result:=HasSelectedStrut(a) else
      result:=Atoms[a].Selected;
  end;
  function StrutSelected(b: TStrutNum; HasAtomsSelected: boolean): boolean;
  begin
    if All then
      result:=true else
    if not HasAtomsSelected then
      result:=Struts[b].Selected else
      result:=Atoms[Struts[b].Atom1].Selected and Atoms[Struts[b].Atom2].Selected;
  end;
  procedure Sort(HasAtomsSelected: boolean);
  var a: TAtomRef;
      b: TStrutRef;
  begin
    a:=1;
    while a < NumAtoms do
      if not AtomSelected(a,HasAtomsSelected) and AtomSelected(a+1,HasAtomsSelected) then
      begin
        SwapAtom(a);
        a:=1;
      end else
        inc(a);

    b:=1;
    while b < NumStruts do
      if not StrutSelected(b,HasAtomsSelected) and StrutSelected(b+1,HasAtomsSelected) then
      begin
        SwapStrut(b);
        b:=1;
      end else
        inc(b);
  end;
  function DataToString(Prefix,Data: string): string;
    function GoodLine: boolean;
    var i,n: integer;
    begin
      result:=false;
      n:=pos(#13#10,Data);
      if n = 0 then
        exit;
      if n > 64 then
        exit;

      for i:=1 to n-1 do
      case Data[i] of
        ' '..#127,char(vk_Tab): ;
        else exit;
      end;
      result:=true;
    end;
  begin
    result:='';
{
    while length(Data) > 32 do
    begin
      result:=result+Prefix+StrToHexDigits2(copy(Data,1,32))+#13#10;
      delete(Data,1,32);
    end;
    if Data <> '' then
      result:=result+Prefix+StrToHexDigits2(Data)+#13#10;
}
    while Data <> '' do
      if GoodLine then
      begin
        AddToResult(Prefix+''''+Before(Data,#13#10)+''''#13#10);
        Data:=After(Data,#13#10);
      end else
      begin
        AddToResult(Prefix+StrToHexDigits2(copy(Data,1,32))+#13#10);
        delete(Data,1,32);
      end;
  end;
  procedure WriteAtoms(HasAtomsSelected: boolean);
  var a: TAtomRef;
  begin
    for a:=1 to NumAtoms do
      with Atoms[a] do
        if AtomSelected(a,HasAtomsSelected) then
          AddToResult('P'+Inttostr(a)+':'+
            AtomName+','+
            FixedPointStr(p.x,2)+','+
            FixedPointStr(p.y,2)+','+
            FixedPointStr(p.z,2)+','+
            FixedPointStr(Mass,2)+','+
            inttostr(ord(Fixing))+','+
            RigidToString(Rigid,':')+
            #13#10);
  end;
  procedure WriteStruts(HasAtomsSelected: boolean);
  var b: TStrutRef;
  begin
    for b:=1 to NumStruts do
      with Struts[b] do
        if StrutSelected(b,HasAtomsSelected) then
          AddToResult(
            'S'+Inttostr(b)+':'+
            StrutName+','+
            Inttostr(Atom1)+','+Inttostr(Atom2)+','+
            FixedPointStr(RestLength,2)+','+
            FixedPointStr(ElasticityR,2)+','+
            FixedPointStr(ElasticityC,2)+','+
            Inttostr(ord(Axis))+','+
            Inttostr(musc)+','+
            Inttostr(Color)+','+
            Inttostr(PenWidth)+
            #13#10);
  end;
  procedure WriteMuscles;
  var m: integer;
  begin
    for m:=0 to high(muscle) do
      AddToResult(
        'M'+Inttostr(m)+':'+
        Inttostr(0)+','+ ///<<<<<<<<<dummy
        Inttostr(TPanel(muscle[m].TrackBar.Parent).Top)+','+
        Before(muscle[m].Label1.Caption,'=')+
        #13#10);
  end;
  procedure WriteKeyframes;
  var k,m: integer;
  begin
    for k:=0 to high(Keyframe) do
    begin
      AddToResult(
        'K'+Inttostr(k)+':'+
        Inttostr(Keyframe[k].TLTime)+','+
        '"'+Keyframe[k].jpgBGXY+'",'+
        '"'+Keyframe[k].jpgBGXZ+'",'+
        '"'+Keyframe[k].jpgBGYZ+'"');
      AddToResult(',2'); {0=all signif; 1=all not signif; 2=list follows}
      for m:=0 to high(muscle) do
      begin
        AddToResult(','+Inttostr(Keyframe[k].posq[m].p));
        AddToResult(','+Inttostr(ord(Keyframe[k].posq[m].Significant)));
      end;
      AddToResult(#13#10);
    end;
  end;
  procedure WriteRoof;
  var i,j: integer;
      RoofAxes: TRoofAxes;
  begin
    for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
    for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
    for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
    begin
      AddToResult(
        'R:'+Inttostr(ord(RoofAxes))+'='+Inttostr(i)+','+Inttostr(j)+':'+
        Inttostr(RoofN[RoofAxes])+','+
        FixedPointStr(Roof[RoofAxes,i,j].h,3)+','+
        Inttostr(ord(HasConstraint[RoofAxes])));
      AddToResult(#13#10);
    end;
  end;
  procedure WritePolygons;
  var pg,e: integer;
  begin
    for pg:=0 to high(Polygons) do
    begin
      AddToResult(
        'G'+Inttostr(pg)+':'+
        Inttostr(length(Polygons[pg].a)));
      for e:=low(Polygons[pg].a) to high(Polygons[pg].a) do
        AddToResult(','+Inttostr(Polygons[pg].a[e]));
      AddToResult(','+FixedPointStr(Polygons[pg].VisibleSide,3));
      AddToResult(','+Inttostr(Polygons[pg].Col));
      AddToResult(#13#10);
    end;
  end;
  procedure WritePolyhedrons;
  var ph,f: integer;
  begin
    for ph:=0 to high(Polyhedron) do
    begin
      AddToResult(
        'H'+Inttostr(ph)+':'+
        Inttostr(length(Polyhedron[ph].PosFace)));
      for f:=low(Polyhedron[ph].PosFace) to high(Polyhedron[ph].PosFace) do
        AddToResult(','+Inttostr(Polyhedron[ph].PosFace[f]));
      AddToResult(','+Inttostr(length(Polyhedron[ph].NegFace)));
      for f:=low(Polyhedron[ph].NegFace) to high(Polyhedron[ph].NegFace) do
        AddToResult(','+Inttostr(Polyhedron[ph].NegFace[f]));
      AddToResult(#13#10);
    end;
  end;
  procedure WriteSymmetry;
  begin
    AddToResult(
      'Y'+':'+
        Inttostr(ord(SymmetryAxes))+','+
        FixedPointStr(SymmetryCoord,2)+
      #13#10);
  end;
var HasAtomsSelected: boolean;
begin
  try
    Screen.Cursor:=crHourglass;
    result:='';
    resultlen:=0;
    AddToResult('Ver Sim3D '+inttostr(Ver*100+VerSub)+#13#10);
                                       
    HasAtomsSelected:=AtomsSelectedCount > 0;

    if not All then
    begin
      Sort(HasAtomsSelected);
      SetupStruts;
    end;

    if dlgOptions <> nil then
    begin
      AddToResult('O:'+
        #13#10);
    end;

    WriteAtoms(HasAtomsSelected);
    WriteStruts(HasAtomsSelected);
    WriteMuscles;
    WriteKeyframes;
    WritePolygons;
    WritePolyhedrons;
    WriteSymmetry;
    WriteRoof;

    setlength(result,resultlen);
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TForm1.StringToAtoms(s: string; LoadOptions,LoadCaption,RetainKeyframes: boolean);
  function ReadAtoms: integer;
  {returns version number of file}
  var StringList: TStringList;
      line: string;
    procedure ZeroEverything;
    var m: integer;
    begin
      SetNumAtoms(0);
      SetNumStruts(0);
      setlength(Polygons,0);
      setlength(Polyhedron,0);

      if not RetainKeyframes then
      begin
        while length(muscle) > 0 do
          DeleteMuscle(0);
        While length(Keyframe) > 1 do
          DeleteKeyframe(1);
        setlength(Keyframe,1);
        setlength(Keyframe[0].posq,0);
      end;

      if LoadOptions then
      begin
      end;
    end;
    procedure ReadVer100(ver: integer);
    var TopMusc: array[0..300] of integer;
      procedure FixupMuscles;
      var i,m,y: integer;
          b: TStrutRef;
          s: string;
      begin
{
        for i:=1 to 20 do
        begin
          y:=i*40;
            for m:=0 to high(muscle) do
              with TPanel(muscle[m].TrackBar.Parent) do
                if TopMusc[m] > y then
                  Top:=10000;
        end;
}
        for m:=0 to high(muscle) do
          with TPanel(muscle[m].TrackBar.Parent) do
            Top:=TopMusc[m]-1;
        for b:=1 to NumStruts do
          with Struts[b] do
            if not inrange(musc,0,high(muscle)) then
              musc:=-1;
      end;
      procedure LoadAtom;
      var a: TAtomRef;
          i: integer;
      begin
        NextIsFixed(line,'P');
        a:=NextNumber(line);
        Mustbe(line,':');
        if a > NumAtoms then SetNumAtoms(a);
        with Atoms[a] do
        begin
          AtomName:=Before(line,','); line:=After(line,',');
          p.x:=    MustbeSignedDouble(line);        Mustbe(line,',');
          p.y:=    MustbeSignedDouble(line);        Mustbe(line,',');
          p.z:=    MustbeSignedDouble(line);        Mustbe(line,',');
          Mass:=   MustbeSignedDouble(line);
          if Nextis(line,',') then
            Fixing:=TFixing(NextNumber(line)) else
            Fixing:=chFree;
          if Nextis(line,',') then
          begin
            if NextIsString(line,s) then
            begin
              if s <> '' then
              begin
                SetLength(rigid,1);
                rigid[0]:=0;
                for i:=1 to length(s) do
                  rigid[0]:=(rigid[0]*1234+ord(s[i])) mod 255;
              end else
                rigid:=nil;
            end else
            begin
              StringToRigid(line,rigid,':');
            end;
          end else
            rigid:=nil;
          v.x:=0;
          v.y:=0;
          v.z:=0;
          Selected:=false;
        end;
      end;
      procedure LoadStrut;
      var b: TStrutRef;
      begin {Sb:Atom1,Atom2,RestLength,Elasticity,sMusclePos}
        NextIsFixed(line,'S');
        b:=NextNumber(line);
        Mustbe(line,':');
        if b > NumStruts then SetNumStruts(b);
        with Struts[b] do
        begin
          StrutName:=      Before(line,','); line:=After(line,',');
          Atom1:=          NextNumber(line); Mustbe(line,',');
          Atom2:=          NextNumber(line); Mustbe(line,',');
          RestLength:=     MustbeSignedDouble(line); Mustbe(line,',');
          ElasticityR:=    MustbeSignedDouble(line); Mustbe(line,',');
          if ver > 100 then
          begin
            ElasticityC:=  MustbeSignedDouble(line); Mustbe(line,',');
          end else
            ElasticityC:=ElasticityR;
          Axis:=           TAxis(NextNumber(line)); Mustbe(line,',');
          musc:=           NextNumber(line); Mustbe(line,',');
coeff:=1;
          Color:=          round(MustbeSignedDouble(line)); Mustbe(line,',');
          PenWidth:=       round(MustbeSignedDouble(line));
          Selected:=       false;
        end;
      end;
      procedure LoadMuscle;
      var m: integer;
      begin
        NextIsFixed(line,'M');
        m:=NextNumber(line);
        Mustbe(line,':');
        while m >= Length(muscle) do
          NewMuscle('',false);
        with muscle[m] do
        begin
          NextNumber(line); Mustbe(line,','); ///<<<<<<<<<dummy
          TopMusc[m]:=NextNumber(line); Mustbe(line,',');
          muscle[m].Label1.Caption:=line;
        end;
      end;
      procedure LoadKeyframe;
      var i,k,m,sig: integer;
          s: string;
      begin
        NextIsFixed(line,'K');
        k:=NextNumber(line);
        Mustbe(line,':');
        if not RetainKeyframes then
          while k >= Length(Keyframe) do
            NewKeyframe(false,true);
        with Keyframe[k] do
        begin
          i:=NextNumber(line); Mustbe(line,',');
          if not RetainKeyframes then
            Keyframe[k].TLTime:=i;
          if NextIsString(line,s) then
          begin
            if not RetainKeyframes then
              Keyframe[k].jpgBGXY:=s;
            Mustbe(line,',');
            s:=MustbeString(line);
            if not RetainKeyframes then
              Keyframe[k].jpgBGXZ:=s;
            Mustbe(line,',');
            s:=MustbeString(line);
            if not RetainKeyframes then
              Keyframe[k].jpgBGYZ:=s;
            Mustbe(line,',');
          end;

          if not RetainKeyframes then
            Sig:=NextNumber(line); {0=all signif; 1=all not signif; 2=list follows}
          m:=0;
          while nextis(line,',') do
          begin
            case sig of
              2: begin
                  i:=NextNumber(line);
                  if not RetainKeyframes then
                  begin
                    Keyframe[k].posq[m].p:=i;
                    mustbe(line,',');
                    i:=NextNumber(line);
                    Keyframe[k].posq[m].Significant:=i <> 0;
                  end;
                end;
              else begin
                  i:=NextNumber(line);
                  if not RetainKeyframes then
                  begin
                    Keyframe[k].posq[m].p:=i;
                    Keyframe[k].posq[m].Significant:=sig = 0;
                  end;
                end;
            end;
            inc(m);
          end;
          dlgOptions.fseNormalAnimPeriod.value:=max(MaxTime,Keyframe[k].TLTime+20)/1000;
        end;
        pbTimeline.Invalidate;
      end;
      procedure LoadRoof;
      var i,j: integer;
          RoofAxes: TRoofAxes;
      begin
        NextIsFixed(line,'R:');
        RoofAxes:=raZPos;
        i:=NextNumber(line);
        if NextIs(line,'=') then
        begin
          RoofAxes:=TRoofAxes(i);
          i:=NextNumber(line);
        end;
        Mustbe(line,',');
        j:=NextNumber(line);
        Mustbe(line,':');
        RoofN[RoofAxes]:=NextNumber(line);
        Mustbe(line,',');
        Roof[RoofAxes,i,j].h:=MustbeSignedDouble(line);
        if NextIs(line,',') then
          HasConstraint[RoofAxes]:=NextNumber(line) <> 0 else
          HasConstraint[RoofAxes]:=false;
      end;
      procedure LoadPolygon;
      var pg,e,n: integer;
      begin
        NextIsFixed(line,'G');
        pg:=NextNumber(line);
        Mustbe(line,':');
        while pg >= Length(Polygons) do
          NewPolygon(0,0,0,0,0);
        n:=NextNumber(line);
        for e:=1 to n do
        begin
          Mustbe(line,',');
          Polygons[pg].a[e]:=NextNumber(line);
        end;

        if NextIs(line,',') then
          Polygons[pg].VisibleSide:=MustbeSignedDouble(line);
        if NextIs(line,',') then
          Polygons[pg].Col:=NextNumber(line);
        Polygons[pg].Area:=PolygonArea(pg);
      end;
      procedure LoadPolyhedron;
      var ph,f: integer;
      begin
        NextIsFixed(line,'H');
        ph:=NextNumber(line);
        Mustbe(line,':');
        while ph >= Length(Polyhedron) do
          NewPolyhedron([],[]);

        setlength(Polyhedron[ph].PosFace,NextNumber(line));
        for f:=0 to high(Polyhedron[ph].PosFace) do
        begin
          Mustbe(line,',');
          Polyhedron[ph].PosFace[f]:=NextNumber(line);
        end;

        Mustbe(line,',');
        setlength(Polyhedron[ph].NegFace,NextNumber(line));
        for f:=0 to high(Polyhedron[ph].NegFace) do
        begin
          Mustbe(line,',');
          Polyhedron[ph].NegFace[f]:=NextNumber(line);
        end;

        Polyhedron[ph].Volume:=PolyhedronVolume(ph);
      end;
      procedure LoadOptions;
      begin
        Mustbe(line,'O:');
      end;
      procedure LoadSymmetry;
      begin
        NextIs(line,'Y');
        Mustbe(line,':');
        SymmetryAxes:=TAxes(NextNumber(line));
        Mustbe(line,',');
        SymmetryCoord:=MustbeSignedDouble(line);
      end;
    var i,j: integer;
        t: string;
    begin
      ZeroEverything;
      StringList.Text:=s;
      for i:=0 to StringList.Count-1 do
      if StringList[i] <> '' then
      try
        line:=StringList[i];
        case line[1] of
          'P': LoadAtom;
          'S': LoadStrut;
          'M': LoadMuscle;
          'O': LoadOptions;
          'K': LoadKeyframe;
          'R': LoadRoof;
          'G': LoadPolygon;
          'H': LoadPolyhedron;
          'Y': LoadSymmetry;
        end;
      except
        if not YesNoBox('Error in line('+inttostr(i)+'):'#13#10+StringList[i]+#13#10'Continue?') then
          exit;
      end;
      FixupMuscles;
    end;
  begin
    try
      try
        StringList:=TStringList.Create;
        StringList.Text:=s;
        if pos('Ver Sim3D ',StringList[0]) <> 1 then
          ShowErrorMessage('Not a Sim3D text') else
        begin
          result:=StrToInt(After(StringList[0],'Ver Sim3D '));
          dlgOptions.fseNormalAnimPeriod.value:=1;

          case result of
            100:  ReadVer100(result);
            101:  ReadVer100(result);
            else  if YesNoBox('Cannot read this version - please upgrade to Ver'+inttostr(result div 100)+'.'+inttostr(result mod 100)+
                      #13#10'Shall I try reading it?') then
                    ReadVer100(result);
          end;
        end;
      finally
        CheckNumAtoms;
        IsAtKeyframe;
        StringList.Free;
      end;
    except
      CheckNumAtoms;
      ShowErrorMessage('Error in Sim3D text');
    end;
  end;
  procedure MoveNewAtoms;
  var xmin,ymax,zmax: FPnumber;
      a: TAtomRef;
  begin
    xmin:=Maxint;
    ymax:=-Maxint;
    zmax:=-Maxint;
    for a:=1 to NumAtoms do
    with Atoms[a] do
    begin
      if p.x < xmin then xmin:=p.x;
      if p.y > ymax then ymax:=p.y;
      if p.z > zmax then zmax:=p.z;
    end;

  end;
var fileVer: integer;
begin
  try
    Screen.Cursor:=crHourglass;
    ClearAll(RetainKeyframes);
    fileVer:=ReadAtoms;
    SetupStruts;
    FixSymmetryAtoms;
    CheckAllKeyframes;
    Keyframe0Significant;
    ChkPoly;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TForm1.SetNumStruts(value: integer);
begin
  if value > high(NumStruts) then
    if CurMode = tiEdit then
      ShowErrorMessage('Too many Struts');
  fNumStruts:=value;
end;

procedure TForm1.SetNumAtoms(value: integer);
begin
  if value > high(NumAtoms) then
    if CurMode = tiEdit then
      ShowErrorMessage('Too many Atoms');
  fNumAtoms:=value;
end;

procedure TForm1.SelectAtom(Atom: TAtomRefEx; Add: boolean);
var a: TAtomRef;
var i,j: integer;
    RoofAxes: TRoofAxes;
begin
  if Atom > 500000 then
  begin
    for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
      for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
        for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
          if Add then
            Roof[RoofAxes,i,j].Selected:=Roof[RoofAxes,i,j].Selected or (RoofAtomNum(RoofAxes,i,j) = Atom) else
            Roof[RoofAxes,i,j].Selected:=RoofAtomNum(RoofAxes,i,j) = Atom;
    SelectStrut(0,false);
    for a:=1 to NumAtoms do
      Atoms[a].Selected:=false;
  end else
  begin
    for a:=1 to NumAtoms do
      if Add then
        Atoms[a].Selected:=Atoms[a].Selected or ((a = Atom) and not Atoms[a].neglect) else
        Atoms[a].Selected:=(a = Atom) and not Atoms[a].neglect;
    if (Atom <> 0) and not Add then
      SelectStrut(0,false);
    for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
      for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
        for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
          Roof[RoofAxes,i,j].Selected:=false;
  end;

  InvalidateAll;
ChkPoly;
end;

procedure TForm1.UnSelectAtom(Atom: TAtomRefEx);
var a: TAtomRef;
var i,j: integer;
    RoofAxes: TRoofAxes;
begin
  if Atom > 500000 then
  begin
    for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
      for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
        for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
          if RoofAtomNum(RoofAxes,i,j) = Atom then
            Roof[RoofAxes,i,j].Selected:=false;
    SelectStrut(0,false);
    for a:=1 to NumAtoms do
      Atoms[a].Selected:=false;
  end else
  begin
    for a:=1 to NumAtoms do
      if Atoms[a].neglect or (Atoms[a].Selected and (a = Atom)) then
        Atoms[a].Selected:=false;
    if Atom <> 0 then
      SelectStrut(0,false);
  end;
  InvalidateAll;
ChkPoly;
end;

function TForm1.RoofSelected(Atom: TAtomRefEx): boolean;
var i,j: integer;
    RoofAxes: TRoofAxes;
begin
  result:=true;
  for RoofAxes:=low(RoofAxes) to high(RoofAxes) do
    for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
      for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
        if RoofAtomNum(RoofAxes,i,j) = Atom then
          if Roof[RoofAxes,i,j].Selected then
            exit;
  result:=false;
end;

procedure TForm1.SelectStrut(Strut: TStrutRef; XorSel: boolean);
var b: TStrutRef;
begin
  for b:=1 to NumStruts do
    if XorSel then
    begin
      if b = Strut then
        Struts[b].Selected:=not Struts[b].Selected;
    end else
      Struts[b].Selected:=b = Strut;
  if Strut <> 0 then
    SelectAtom(0,false);
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.SetUndo;
var i: integer;
    s: string;
begin
  if CurMode <> tiEdit then
    exit;
    
  s:=AtomsToString(true);
  if (Undo.Count = 0) or (Undo[Undo.Count-1] <> s) then
  begin
    Undo.Add(s);
    if Undo.Count > 50 then
      Undo.Delete(0);
  end;
end;

procedure TForm1.Undo1Click(Sender: TObject);
var i: integer;
begin
  if Undo.Count > 0 then
    StringToAtoms(Undo[Undo.Count-1],true,true,false);
  if Undo.Count > 1 then
    Undo.Delete(Undo.Count-1);
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.SetupStruts;
begin
end;

procedure TForm1.StopAllAtoms(OnlySelected: boolean);
var a: TAtomRef;
begin
  { Stop all atoms }
  for a:=1 to NumAtoms do
  with Atoms[a] do
  if Selected or not OnlySelected then
  begin
    v.x:=0;
    v.y:=0;
    v.z:=0;
  end;
end;

procedure TForm1.CheckNumAtoms;
begin
  if NumAtoms >= high(TAtomNum) then
    ShowErrorMessage('The number of Points exceeds the maximum allowed') else
  if NumStruts >= high(TStrutNum) then
    ShowErrorMessage('The number of Struts exceeds the maximum allowed') else
//  if NumTrians >= high(NumTrians) then
//    ShowErrorMessage('The number of Triangles exceeds the maximum allowed') else
end;

function TForm1.NewAtom(x,y,z,Mass: FPnumber): TAtomNum;
begin
  CheckNumAtoms;
  SetNumAtoms(NumAtoms+1);
  Atoms[NumAtoms].p:=a3DPoint(x,y,z);
  Atoms[NumAtoms].v:=Zero3DPoint;
  Atoms[NumAtoms].Mass:=Mass;
  Atoms[NumAtoms].Selected:=false;
  Atoms[NumAtoms].neglect:=false;
  Atoms[NumAtoms].Fixing:=chFree;
  Atoms[NumAtoms].rigid:=nil;
  Atoms[NumAtoms].pOriginal:=a3DPoint(x,y,z);

  result:=NumAtoms;
  Modified:=true;
//  PhaseMarks:=[];
end;

function TForm1.NewStrut(Atom1,Atom2: TAtomNum; RestLength: FPnumber; ElasticityR,ElasticityC: FPnumber;
      QueryDups: boolean; aAxis: TAxis): TStrutNum;
  function HasDup: boolean;
  begin
    result:=FindStrut(Atom1,Atom2) <> 0;
    if result and dlgOptions.cbWarnDuplicateStruts.Checked then
//      result:=MessageDlg('A strut between these two points already exists.'#13#10'Create a duplicate?',mtConfirmation, [mbYes,mbNo], 0) = mrNo;
      result:=not YesNoBox('A strut between these two points already exists.'#13#10'Create a duplicate?');
  end;
begin
  CheckNumAtoms;

  if QueryDups and HasDup then
    exit;

  SetNumStruts(NumStruts+1);
  Fillchar(Struts[NumStruts],sizeof(Struts[NumStruts]),0);

  Struts[NumStruts].Atom1:=Atom1;
  Struts[NumStruts].Atom2:=Atom2;
  if RestLength > maxint/2 then
    Struts[NumStruts].RestLength:=MinRestLen(Distance(Atom1,Atom2)) else
    Struts[NumStruts].RestLength:=MinRestLen(RestLength);
//  Struts[NumStruts].MuscleLength:=Struts[NumStruts].RestLength;
  Struts[NumStruts].ElasticityR:=ElasticityR;
  Struts[NumStruts].ElasticityC:=ElasticityC;
//  Struts[NumStruts].BreakForce:=BreakForce;
//  Struts[NumStruts].sMusclePos:=sMusclePos;
  Struts[NumStruts].musc:=-1;
  Struts[NumStruts].Coeff:=1;
  Struts[NumStruts].Color:=clBlack;
  Struts[NumStruts].PenWidth:=1;
  Struts[NumStruts].Axis:=aAxis;
//  Struts[NumStruts].IsControlled:=false;
//  Struts[NumStruts].DllName:=DllName;
//  Struts[NumStruts].Color:=clBlack;
//  if StrutName.n = 0 then
//    Struts[NumStruts].StrutName:=MakeUniqueName(StringToTName('Strut1')) else
//    Struts[NumStruts].StrutName:=StrutName;
//  Struts[NumStruts].phaseOffset:=0;
//  Struts[NumStruts].phaseRate:=PhaseRate;
//  Struts[NumStruts].Spinneret.enabled:=false;
//  Struts[NumStruts].Spinneret.Strut:=0;
//  Struts[NumStruts].Spinneret.SlowStart:=1;
  fillchar(Struts[NumStruts].impNum,sizeof(Struts[NumStruts].impNum),0);
  Modified:=true;
  result:=NumStruts;
//  PhaseMarks:=[];
end;

function TForm1.FindStrut(a1,a2: TAtomRef): TStrutRef;
begin
  for result:=1 to NumStruts do
    with Struts[result] do
      if ((Atom1 = a1) and (Atom2 = a2)) or
         ((Atom1 = a2) and (Atom2 = a1)) then
        exit;
  result:=0;
end;

function TForm1.MinRestLen(a: FPnumber): FPnumber;
begin
  if a < MinRestLength then
    result:=MinRestLength else
    result:=a;
end;

function TForm1.Distance(Atom1,Atom2: TAtomNum): FPnumber;
begin
  result:=Pythag3d(
    Atoms[Atom1].p.x-Atoms[Atom2].p.x,
    Atoms[Atom1].p.y-Atoms[Atom2].p.y,
    Atoms[Atom1].p.z-Atoms[Atom2].p.z);
end;

function TForm1.LoadFile(const filename: string): Boolean;
begin
  ClearAll(false);
  try
    Screen.Cursor:=crHourglass;
    try
//      HideAllExcept:=StringToTName('');
      result:=false;
      StringToAtoms(LoadFromFileString(FileName),true,true,false);
      StopAllAtoms(false);
      result:=true;
    except
      ShowErrorMessage('Error while reading file: '+filename);
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
  SavedPosition:=AtomsToString(true);
  SetMainFilename(Filename);
//  DllNewFilename(Filename);
  tcModeChange(Self);
  InvalidateAll;
ChkPoly;
  Modified:=false;
end;

procedure TForm1.Delete1Click(Sender: TObject);
begin
  if CurMode = tiEdit then
  begin
    SetUndo;
    DeleteSelectedStruts;
    DeleteSelectedAtoms;
    SetupStruts;
ChkPoly;
  end;
end;

function TForm1.FirstSelectedAtom: integer;
var a: TAtomRef;
begin
  result:=0;
  for a:=1 to NumAtoms do
    with Atoms[a] do
     if Selected then
       result:=a;
end;

function TForm1.FirstSelectedStrut: integer;
var b: TStrutRef;
begin
  result:=0;
  for b:=1 to NumStruts do
    with Struts[b] do
     if StrutSelected(b) then
       result:=b;
end;

procedure TForm1.SetMainFilename(filename: string);
const Curfilename: string = #1;
begin
  OpenDialog1.Filename:=Filename;
  if Filename = '' then
    Caption:='GGSim3D' else
    Caption:='GGSim3D - '+ExtractFilename(Filename);
  CurFilename:=Filename;
end;

procedure TForm1.DeleteSelectedAtoms;
var a: TAtomRef;
    AtomBoolArray: TAtomBoolArray;
begin
  for a:=1 to NumAtoms do
    AtomBoolArray[a]:=Atoms[a].Selected;
  DeleteAtoms(AtomBoolArray);
  SetupStruts;
  CheckClearSym;
end;

procedure TForm1.DeleteSelectedStruts;
var b: TStrutRef;
    StrutBoolArray: TStrutBoolArray;
begin
  for b:=NumStruts downto 1 do
    if StrutSelected(b) then
      DeleteStrut(b);

  for b:=NumStruts downto 1 do
    StrutBoolArray[b]:=StrutSelected(b);
  DeleteStruts(StrutBoolArray);
end;

procedure TForm1.DeleteAtoms(AtomBoolArray: TAtomBoolArray);
var StrutBoolArray: TStrutBoolArray;
  procedure MarkStruts(Atom: TAtomNum);
  var b1,b2: TStrutRef;
  begin
    for b1:=1 to NumStruts do
    with Struts[b1] do
    if (Atom1 = Atom) or (Atom2 = Atom) then
    begin
      StrutBoolArray[b1]:=true;
    end else
    begin
      if Atom1 > Atom then
        Dec(Atom1);
      if Atom2 > Atom then
        Dec(Atom2);
    end;
  end;
  procedure DeleteAtoms2;
  var a1,a2: TAtomRef;
  begin
    a2:=1;
    for a1:=1 to NumAtoms do
    begin
      if not AtomBoolArray[a1] then
      begin
        if a1 <> a2 then
          Atoms[a2]:=Atoms[a1];
        inc(a2);
      end else
        Modified:=true;
    end;
    SetNumAtoms(a2-1);
  end;
  procedure DeletePolygonContainingAtom(a: TAtomRef);
    function DelAtomInPolygon(a: TAtomRef; pg: integer): boolean;
    var e: integer;
    begin
      result:=false;
      for e:=low(Polygons[pg].a) to high(Polygons[pg].a) do
        if Polygons[pg].a[e] > 0 then
          if Polygons[pg].a[e] = a then
            result:=true else
          if Polygons[pg].a[e] > a then
            dec(Polygons[pg].a[e]);
    end;      
  var pg: integer;
  begin
    for pg:=high(Polygons) downto 0 do
      if DelAtomInPolygon(a,pg) then
        DeletePolygon(pg);
  end;
var a,a1,a2: TAtomRef;
    m: integer;
begin
  fillchar(StrutBoolArray,sizeof(StrutBoolArray),0);

  for a:=NumAtoms downto 1 do
    if AtomBoolArray[a] then
      DeletePolygonContainingAtom(a);
  SetCurMuscle(IntRange(CurMuscle,0,high(muscle)));

  for a:=NumAtoms downto 1 do
    if AtomBoolArray[a] then
      MarkStruts(a);

  DeleteStruts(StrutBoolArray);
  DeleteAtoms2;
  SetupStruts;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.DeleteStruts(StrutBoolArray: TStrutBoolArray);
var b1,b2: TStrutRef;
begin
  b2:=1;
  for b1:=1 to NumStruts do
  begin
    if not StrutBoolArray[b1] then
    begin
      if b1 <> b2 then
        Struts[b2]:=Struts[b1];
      inc(b2);
    end else
    begin
//      DLLStrutDeleted(ObjNameToDLLName(Atoms[Struts[b1].Atom1].ObjectName),Struts[b1].StrutName);
      Modified:=true;
    end;
  end;
  SetNumStruts(b2-1);

//  SetupStruts;
//  StopAllAtoms(false);
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.InvalidateAll;
begin
  pbYZInvalidate;
  pbXYInvalidate;
  pbXZInvalidate;
  pb3DInvalidate;
  pbMuscleChart.Invalidate;
  pbTimeline.Invalidate;
end;

function TForm1.SaveIfModified(Query: Boolean): Boolean;
begin
  SaveIfModified:=true;
  if Modified {or DLLObjectModified }then
    if Query then
      case MessageDlg('File has been Modified - Save?',mtConfirmation,
            [mbYes,mbNo,mbCancel],0) of
        mrYes:    SaveIfModified:=SaveFile(OpenDialog1.Filename);
        mrCancel: SaveIfModified:=false;
      end
    else
      SaveFile(OpenDialog1.Filename);
end;

function AddRoot(filename: string): string;
begin
  if ExtractFilePath(Filename) = '' then
    result:=ChangeToExePath(Filename) else
    result:=Filename;
end;

function TForm1.SaveFile(filename: string): Boolean;
begin
  result:=false;
  if Running then
    Stop;

  if Filename = '' then
    result:=SaveAsFile else
    result:=SaveObjsToFile(AddRoot(Filename));
end;

function TForm1.SaveAsFile: Boolean;
begin
  result:=false;
  with SaveDialog1 do
  if Execute then
  begin
    if ExtractFileExt(FileName) = '' then filename:=filename+'.s3d';
    if FileExists(filename) and
      not YesNoBox('File already exists: '+filename+' - Overwrite?') then exit;
    result:=SaveObjsToFile(filename);
    if not result then
      ShowErrorMessage('Error while writing file: '+filename);
  end;
end;

procedure TForm1.OpenProjectFile(filename: string);
begin
  if FileExists(Filename) then
  begin
    LoadFile(filename);
    SetUndo;
  end else
    New1Click(Self);
  SetMainFilename(Filename);
//  DllNewFilename(Filename);
  Refresh;
  Show;
end;

function TForm1.SaveObjsToFile(filename: string): Boolean;
begin
{$ifdef UsesShareware}
  if IsRegisteredDlg('File Save') then;/
{$endif}

  if (UpperCase(ExtractFileExt(filename)) <> '.S3D') then
  case YesNoCancelBox('It is recommended that PlaniSim files are saved with the extension .s3d'#13#10+
          'Change Filename to"'+ExtractFilename(ChangeFileExt(filename,'.s3d'))+'"?') of
    mrYes: begin
             oldEraseFile(Filename);
             Filename:=ChangeFileExt(filename,'.s3d');
           end;
    mrCancel: exit;
  end;


  try
    Screen.Cursor:=crHourglass;
    try
      result:=false;
      SaveToFileString(FileName,AtomsToString(true));
      SetMainFilename(Filename);
//      DllNewFilename(Filename);
      Modified:=false;
      result:=true;
    except
      ShowErrorMessage('File write error: '+Filename);
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TForm1.IsLoaded;
begin
  tcModeChange(Self);

  with OpenDialog1 do
  begin
    if (ParamStr(1) <> '') and (ParamStr(1)[1] <> '/') then
      filename:=ParamStr(1);
    if (filename <> '') and FileExists(filename) then
      OpenProjectFile(Filename)else
      filename:='';
    SetupStruts;
    StopAllAtoms(false);
//    if NumAtoms > 0 then
//      Run else
      Stop;
  end;
  Refresh;
  Timer1.enabled:=true;
end;

function TForm1.NearestAtom(x,y: FPnumber; Axes: TAxes): TAtomRef;
var a: TAtomRef;
begin
  result:=NumAtoms;
  for a:=1 to NumAtoms do
    if pythag(x-Proj2DZoom(Atoms[result].p,Axes).x,y-Proj2DZoom(Atoms[result].p,Axes).y) >
       pythag(x-Proj2DZoom(Atoms[a     ].p,Axes).x,y-Proj2DZoom(Atoms[a     ].p,Axes).y) then
      result:=a;
end;

function TForm1.NearestStrut(x,y: integer; Axes: TAxes): TStrutRef;
var b: TStrutRef;
begin
  result:=NumStruts;
  for b:=1 to NumStruts do
    if pythag(x-(Proj2D(Atoms[Struts[b     ].Atom1].p,Axes).x+Proj2D(Atoms[Struts[b     ].Atom2].p,Axes).x)/2,
              y-(Proj2D(Atoms[Struts[b     ].Atom1].p,Axes).y+Proj2D(Atoms[Struts[b     ].Atom2].p,Axes).y)/2) >=
       pythag(x-(Proj2D(Atoms[Struts[result].Atom1].p,Axes).x+Proj2D(Atoms[Struts[result].Atom2].p,Axes).x)/2,
              y-(Proj2D(Atoms[Struts[result].Atom1].p,Axes).y+Proj2D(Atoms[Struts[result].Atom2].p,Axes).y)/2) then
      result:=b;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
const executing: boolean = false;
begin
  if csDestroying in ComponentState then
    exit;

  try
    if not executing then
    try
      executing:=true;
      if Running then
      begin
        if dlgOptions.rbSolve.Checked then
        begin
          CalcOneIntervalSolve;
        end else
          CalcOneIntervalIntegrate;
        if Running {or cbRunClock.Checked} then
          InvalidateAll;
//  ChkPoly;
      end;
    finally
      executing:=false;
    end;
  except
    on e:Exception do
    begin
      Stop;
      ShowMessage(e.Message);
    end;
  end;
end;

procedure TForm1.CalcOneIntervalIntegrate;
{integrates all the forces acting on an atom to give the velocity of the atom
{integrates the velocity to give the position of the atom}
var i: integer;
const n: integer = 0;
begin
  try
    for i:=1 to dlgOptions.seIntegrate.value do
    begin
      if odd(i) then
        IncClock;
      ApplyRigity;
      CalcPosition(1/dlgOptions.seIntegrate.value,i=dlgOptions.seIntegrate.value);
    end;
  except
    Stop;
  end;
end;

function TForm1.PolgonNormal(pg: integer): T3DPoint;
begin
  with Polygons[pg] do
  begin
    result:=CrossProduct3D(Sub3D(Atoms[a[1]].p,Atoms[a[3]].p),Sub3D(Atoms[a[2]].p,Atoms[a[3]].p));
    if a[4] > 0 then
      result:=add3d(result,CrossProduct3D(Sub3D(Atoms[a[4]].p,Atoms[a[3]].p),Sub3D(Atoms[a[1]].p,Atoms[a[3]].p)));
  end;
end;

function TForm1.CalcPolgonArea(pg: integer): single;
begin
  result:=Length3D(PolgonNormal(pg));
end;

procedure TForm1.CalcOneIntervalSolve;
{"solves" the conflicting forces acting on an atom by trying to find the x,y,z where they sum to zero
{does so using the Netwon-Raphson method.}
var TotalVolumeC,TotalVolumeT,TotalForceT,GasConst,GasConstArea,ClipGas,expansion: single;
    MinRoofPosZPos: Single;
    MaxRoofPosZNeg: Single;
    MinRoofPosYPos: Single;
    MaxRoofPosYNeg: Single;
    MaxRoofPosXNeg: Single;
    MinRoofPosXPos: Single;
    cbf: Tcbf;

  function polygonSurfaceArea(ph: integer): single;
  var f: T3DPoint;
      i: integer;

  begin
    result  :=0;
    for i:=0 to high(Polyhedron[ph].PosFace) do
    begin
      f:=PolgonNormal(Polyhedron[ph].PosFace[i]);
      result:=result+Length3D(f)/2;
    end;
    for i:=0 to high(Polyhedron[ph].NegFace) do
    begin
      f:=PolgonNormal(Polyhedron[ph].PosFace[i]);
      result:=result+Length3D(f)/2;
    end;
  end;
  procedure AddFacePressure(pg: integer; Pressure,volume,Totalsurfacearea: single);
  {if pressure is 10% too big then
    pressure=0.1
    should move face by
      dist = vol*pressure/6/area}
  var f: T3DPoint;
      area,d: double;
      e: integer;
      Face: TPolygon;
  begin
    face:=Polygons[pg];
    {this line only works for quads; otherwise use Area3D code for vector}
{
    f:=CrossProduct3D(Sub3D(Atoms[Face.a[1]].p,Atoms[Face.a[3]].p),Sub3D(Atoms[Face.a[2]].p,Atoms[Face.a[3]].p));
    if Face.a[4] > 0 then
      f:=add3d(f,CrossProduct3D(Sub3D(Atoms[Face.a[4]].p,Atoms[Face.a[3]].p),Sub3D(Atoms[Face.a[1]].p,Atoms[Face.a[3]].p)));
}
    f:=PolgonNormal(pg);
    area:=Length3D(f)/2;
//    d:=volume*pressure*(area/Totalsurfacearea)/area;
//    d:=volume*pressure/6/area; {6 because it's usually a cube}
    if Face.a[4] > 0 then
      d:=pressure*area/250/4 else
      d:=pressure*area/250/3;
    d:=RealRange(d,-ClipGas,+ClipGas);
    d:=d/1000;
    f:=scale3D(Normalise3D(f),d);
    for e:=low(Face.a) to high(Face.a) do
      if Face.a[e] > 0 then
      begin
        Atoms[Face.a[e]].f:=Add3D(Atoms[Face.a[e]].f,f);
        if cbf = cbfPressure then
          Atoms[Face.a[e]].af:=Add3D(Atoms[Face.a[e]].af,f);
      end;
  end;
  procedure AddPressureBrick(ph: integer);
  var f: integer;
      v,TotalSurfaceArea: single;
  begin
    if Polyhedron[ph].Volume < 1 then
      exit;
//if ph = 17 then
//randseed:=randseed;
    v:=PolyhedronVolume(ph);
    TotalVolumeC:=TotalVolumeC+v;
    totalSurfaceArea := PolygonSurfaceArea(ph);
    Polyhedron[ph].Pressure:=GasConst*(Polyhedron[ph].Volume-v)/Polyhedron[ph].Volume;

    for f:=0 to high(Polyhedron[ph].PosFace) do
      AddFacePressure(Polyhedron[ph].PosFace[f],-Polyhedron[ph].pressure,Polyhedron[ph].Volume,TotalSurfaceArea);
    for f:=0 to high(Polyhedron[ph].NegFace) do
      AddFacePressure(Polyhedron[ph].NegFace[f],+Polyhedron[ph].pressure,Polyhedron[ph].Volume,TotalSurfaceArea);
  end;
  procedure AddPressureFace(pg: integer);
    procedure AddLine(a1,a2: integer; Pressure: single);
    var f: single;
    begin
      f:=(Atoms[a1].p.x-Atoms[a2].p.x)*Pressure;
      Atoms[a1].f.x:=Atoms[a1].f.x+f;
      Atoms[a2].f.x:=Atoms[a2].f.x-f;
      if cbf = cbfPressure then
      begin
        Atoms[a1].af.x:=Atoms[a1].af.x+f;
        Atoms[a2].af.x:=Atoms[a2].af.x-f;
      end;

      f:=(Atoms[a1].p.y-Atoms[a2].p.y)*Pressure;
      Atoms[a1].f.y:=Atoms[a1].f.y+f;
      Atoms[a2].f.y:=Atoms[a2].f.y-f;
      if cbf = cbfPressure then
      begin
        Atoms[a1].af.y:=Atoms[a1].af.y+f;
        Atoms[a2].af.y:=Atoms[a2].af.y-f;
      end;

      f:=(Atoms[a1].p.z-Atoms[a2].p.z)*Pressure;
      Atoms[a1].f.z:=Atoms[a1].f.z+f;
      Atoms[a2].f.z:=Atoms[a2].f.z-f;
      if cbf = cbfPressure then
      begin
        Atoms[a1].af.z:=Atoms[a1].af.z+f;
        Atoms[a2].af.z:=Atoms[a2].af.z-f;
      end;
    end;
  var f: integer;
      p,Pressure: single;
  begin
    with Polygons[pg] do
    begin
      if Area < 1 then
        exit;
      p:=(1-PolygonArea(pg)/Area);
//      p:=RealRange(p,-0.001,0.001);
      p:=GasConstArea*p/1000;
      if a[4] = 0 then
      begin
        AddLine(a[1],a[2],p);
        AddLine(a[2],a[3],p);
        AddLine(a[3],a[1],p);
      end else
      begin
        AddLine(a[1],a[2],p);
        AddLine(a[2],a[3],p);
        AddLine(a[3],a[4],p);
        AddLine(a[4],a[1],p);
      end;
    end;
  end;
  procedure AddPressureTet(th: integer);
    function CalcCornerPressure2(var p1,p2,p3,p4: T3DPoint; press: single): T3DPoint;
    var pl: TPlane;
        v,d,area: single;
        pd,cp: T3DPoint;
    begin
      pl:=PlaneThroughThreePoints(p2,p3,p4);
      pd:=NearestPointOnPlaneToPoint(p1,pl);
      result:=Scale3D(CrossProduct3D(Sub3D(p3,p4),Sub3D(p2,p4)),1-press);
    end;
    procedure AddCornerPressure(th,a1,a2,a3,a4: integer; press: single);
    var f: T3DPoint;
    begin
      f:=CalcCornerPressure2(
          Atoms[Tetrahedra[th].a[a1]].p,
          Atoms[Tetrahedra[th].a[a2]].p,
          Atoms[Tetrahedra[th].a[a3]].p,
          Atoms[Tetrahedra[th].a[a4]].p,
          press);
      Atoms[a1].f:=Add3D(Atoms[a1].f,f);
      if cbf = cbfPressure then
        Atoms[a1].af:=Add3D(Atoms[a1].af,f);
    end;
    function CalcEdgePressure2(p1,p2: T3DPoint; press: single): T3DPoint;
    var pd: T3DPoint;
    begin
      pd:=Sub3D(p1,p2);
      result:=Scale3D(pd,press);
    end;
    procedure AddEdgePressure(th,a1,a2: integer; press: single);
    var f: T3DPoint;
    begin
      f:=CalcEdgePressure2(
          Atoms[Tetrahedra[th].a[a1]].p,
          Atoms[Tetrahedra[th].a[a2]].p,
          press);
      Atoms[a1].f:=Add3D(Atoms[a1].f,f);
      Atoms[a2].f:=Sub3D(Atoms[a2].f,f);
      if cbf = cbfPressure then
      begin
        Atoms[a1].af:=Add3D(Atoms[a1].af,f);
        Atoms[a2].af:=Sub3D(Atoms[a2].af,f);
      end;
    end;
  var f: integer;
      v,Pressure,p2: single;
  begin
{
    if Tetrahedra[th].Volume < 1 then
      exit;
    v:=TetrahedronVolume(th);
    TotalVolume:=TotalVolume+v;
//    Pressure:=(Tetrahedra[th].Volume-v)/Tetrahedra[th].Volume;
    Pressure:=Tetrahedra[th].Volume/v;

    Pressure:=(Pressure-1)*GasConst/4/1000+1;
    AddCornerPressure(th,1,2,3,4,pressure);
    AddCornerPressure(th,2,3,1,4,pressure);
    AddCornerPressure(th,3,4,1,2,pressure);
    AddCornerPressure(th,4,1,3,2,pressure);
}
    if Tetrahedra[th].Volume < 1 then
      exit;
    v:=TetrahedronVolume(th);
    TotalVolumeT:=TotalVolumeT+v;
    Pressure:=(Tetrahedra[th].Volume-v)/Tetrahedra[th].Volume;
    if InRealRange(Pressure,-0.2,+0.2) then
    begin
      Pressure:=Pressure*GasConst/1000;
      AddEdgePressure(th,1,2,pressure);
      AddEdgePressure(th,1,3,pressure);
      AddEdgePressure(th,1,4,pressure);
      AddEdgePressure(th,2,3,pressure);
      AddEdgePressure(th,2,4,pressure);
      AddEdgePressure(th,3,4,pressure);
    end;
  end;
  procedure InflateAll;
  var c: T3DPoint;
      th: integer;
      t: single;
      a: TAtomRef;
  begin
    if NumAtoms = 0 then
      exit;

    for th:=0 to high(Tetrahedra) do
    begin
      TotalVolumeT:=TotalVolumeT+TetrahedronVolume(th);
      t:=t+Tetrahedra[th].Volume;
    end;
    if TotalVolumeT = 0 then
      expansion:=0 else
      expansion:=TotalVolumeT/t;

    c:=Zero3DPoint;
    for a:=1 to NumAtoms do
      c:=add3d(c,Atoms[a].p);
    c:=Scale3D(c,1/NumAtoms);

    for a:=1 to NumAtoms do
    with Atoms[a].p do
    if Atoms[a].Fixing = chFree then
    begin
      x:=(x-c.x)*expansion+c.x;
      y:=(y-c.y)*expansion+c.y;
      z:=(z-c.z)*expansion+c.z;
    end;
  end;
  procedure CalcExpansion;
  var c: T3DPoint;
      th: integer;
      t: single;
      a: TAtomRef;
  begin
    if NumAtoms = 0 then
      exit;

    TotalVolumeT:=0;
    t:=0;
    for th:=0 to high(Tetrahedra) do
    begin
      TotalVolumeT:=TotalVolumeT+TetrahedronVolume(th);
      t:=t+Tetrahedra[th].Volume;
    end;
    if (TotalVolumeT = 0) or (t = 0) then
      expansion:=1 else
      expansion:=t/TotalVolumeT;
//      expansion:=TotalVolumeT/t;
//    expansion:=pwr(expansion,1/3);
//    expansion:=(expansion-1)/3+1;
  end;
  procedure ApplyConstraints;
  var ia: integer;
  const MaxCorrection = 4;
  begin
    if HasConstraint[raZPos] then
      for ia:=1 to NumAtoms do
        if Atoms[ia].Fixing <> chStatic then
          with Atoms[ia].p do
            if z > MinRoofPosZPos then
              z:=min(z,RealRange(RoofPosZPos(x,y),z-MaxCorrection,z+MaxCorrection));

    if HasConstraint[raZNeg] then
      for ia:=1 to NumAtoms do
        if Atoms[ia].Fixing <> chStatic then
          with Atoms[ia].p do
            if z < MaxRoofPosZNeg then
              z:=max(z,RealRange(RoofPosZNeg(x,y),z-MaxCorrection,z+MaxCorrection));

    if HasConstraint[raXPos] then
      for ia:=1 to NumAtoms do
        if Atoms[ia].Fixing <> chStatic then
          with Atoms[ia].p do
            if x > MinRoofPosXPos then
              x:=min(x,RealRange(RoofPosXPos(y,z),z-MaxCorrection,z+MaxCorrection));

    if HasConstraint[raXNeg] then
      for ia:=1 to NumAtoms do
        if Atoms[ia].Fixing <> chStatic then
          with Atoms[ia].p do
//            if x < MaxRoofPosLeft then
              x:=max(x,RealRange(RoofPosXNeg(y,z),z-MaxCorrection,z+MaxCorrection));

    if HasConstraint[raYPos] then
      for ia:=1 to NumAtoms do
        if Atoms[ia].Fixing <> chStatic then
          with Atoms[ia].p do
            if y > MinRoofPosYPos then
              y:=min(y,RealRange(RoofPosYPos(x,z),z-MaxCorrection,z+MaxCorrection));

    if HasConstraint[raYNeg] then
      for ia:=1 to NumAtoms do
        if Atoms[ia].Fixing <> chStatic then
          with Atoms[ia].p do
            if y > MaxRoofPosYNeg then
              y:=max(y,RealRange(RoofPosYNeg(x,z),z-MaxCorrection,z+MaxCorrection));
  end;
var pass,i,j,ia,il,it,t: integer;
    s,b,v,dArea,d1,R,af,dL: Single;
    vect1,vect2: T3DPoint;
    wgt: TAtomRealArray;
    cnt: TAtomIntArray;
    th,ph,pg: integer;
    Elasticity,TargLen,PrevTargLen: TStrutRealArray;
begin
  cbf:=Tcbf(dlgOptions.cbForceKind.ItemIndex);
  GasConst:=dlgOptions.seGasConst.Value;
  GasConstArea:=dlgOptions.seGasConstArea.Value;
  ClipGas:=dlgOptions.seClipForce.Value;
  t:=GetTickCount;
  MinRoofPosZPos:=maxint;
  MaxRoofPosZNeg:=-maxint;
  MinRoofPosYPos:=maxint;
  MaxRoofPosYNeg:=-maxint;
  MaxRoofPosXNeg:=-maxint;
  MinRoofPosXPos:=maxint;
  for i:=-RoofN[raZPos] to RoofN[raZPos] do
    for j:=-RoofN[raZPos] to RoofN[raZPos] do
      MinRoofPosZPos:=min(MinRoofPosZPos,Roof[raZPos,i,j].h);
  for i:=-RoofN[raZNeg] to RoofN[raZNeg] do
    for j:=-RoofN[raZNeg] to RoofN[raZNeg] do
      MaxRoofPosZNeg:=max(MaxRoofPosZNeg,Roof[raZNeg,i,j].h);
  for i:=-RoofN[raYPos] to RoofN[raYPos] do
    for j:=-RoofN[raYPos] to RoofN[raYPos] do
      MinRoofPosYPos:=min(MinRoofPosYPos,Roof[raYPos,i,j].h);
  for i:=-RoofN[raYNeg] to RoofN[raYNeg] do
    for j:=-RoofN[raYNeg] to RoofN[raYNeg] do
      MaxRoofPosYNeg:=min(MaxRoofPosYNeg,Roof[raYNeg,i,j].h);
  for i:=-RoofN[raXNeg] to RoofN[raXNeg] do
    for j:=-RoofN[raXNeg] to RoofN[raXNeg] do
      MaxRoofPosXNeg:=max(MaxRoofPosXNeg,Roof[raXNeg,i,j].h);
  for i:=-RoofN[raXPos] to RoofN[raXPos] do
    for j:=-RoofN[raXPos] to RoofN[raXPos] do
      MinRoofPosXPos:=min(MinRoofPosXPos,Roof[raXPos,i,j].h);

  for pass:=1 to dlgOptions.seSolve.value do
  try
//    ApplyRigity;
//    CalcExpansion;
  //  Expansion:=1;
    TotalForceT := 0;
//for i:=0 to high(muscle)-1 do
//  il:=muscle[i].TrackBar.Position;

    for il:=1 to NumStruts do
    with Struts[il] do
    begin
      R:=RestLength;//*Expansion;   //expansion is always 1 so R = restlength  Rest length is startlength*trackbarposition/100
      if musc >= 0 then    //if strut assigned to a muscle then
      begin
      if   dlgOptions.rbMuscleInterpolate.itemindex = 1 then
        TargLen[il]:=0.998*(PrevTargLen[il]-max(R*muscle[musc].TrackBar.Position/100,1))+max(R*muscle[musc].TrackBar.Position/100,1)  // TargLen = threshold strut length at which no force applies
      else
        TargLen[il]:=0.0*(PrevTargLen[il]-max(R*muscle[musc].TrackBar.Position/100,1))+max(R*muscle[musc].TrackBar.Position/100,1);  // TargLen = threshold strut length at which no force applies
        PrevTargLen[il]:=TargLen[il];//max(R*muscle[musc].TrackBar.selEnd/100,1);  // TargLen = threshold strut length at which no force applies
//        TargLen[il]:=(TargLen[il]-R)*Coeff+R;
//        Elasticity[il]:=(ElasticityR-ElasticityC)*TargLen[il]/R+ElasticityC;  //sets strut elasticity to be a linear proportion of max-min elasticity according to threshold strut length.
      end else
      begin
        TargLen[il]:=R;
        PrevTargLen[il]:=R;
//        TargLen[il]:=max(R,1);
//        Elasticity[il]:=ElasticityR;
      end;

      if dlgOptions.cbDependsonlength.Checked then
        Elasticity[il]:=Elasticity[il]*50/R;
    end;

//  for pass:=1 to dlgOptions.seSolve.value do
//  try

//    TotalVolumeT:=0;
//    if GasConst > 0 then
//      for th:=0 to high(Tetrahedra) do
//        AddPressureTet(th);

    for ia:=1 to NumAtoms do             //Every iteration atom forces are zeroed
    begin
      wgt[ia]:=0;
//      cnt[ia]:=0;
      Atoms[ia].f:=Zero3DPoint;
      Atoms[ia].af:=Zero3DPoint;
    end;

    for il:=1 to NumStruts do
    with Struts[il] do
    begin
      vect1:=Sub3D(Atoms[Atom1].p,Atoms[Atom2].p);     //
//      d1:=Length3D(vect1);
      d1:= distance(Atom1,Atom2);    // distance gives slightly different answer to length3d      and we are using distance elsewhere
//      if prevlength-d1 >20 then
//         d1:=prevlength+20;
      if d1 > 0 then
      begin
//        b:=(d1-TargLen[il])/d1;  //d1 is current length while TargLen is target length
        b:=(d1-TargLen[il])/restlength;  //d1 is current length while TargLen is target length
        if b > 0 then        //if current length is different from the set length then calculate forces >>>> is this right? Should be <> ???
        begin
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
  //        b:=b/2;
//          if v-b >0 then  // if positive velocity  of delta L
//            b:=b*(1-v);
//            b:=b*(1-ElasticityR*v/100);
//        if PrevTargLen[il]-TargLen[il] > 0 then
//        begin
          if (prevlen-d1 >= -0.1) and (d1 -Targlen[il] > 0) then
//          if (prevlen-d1 >= 0) and (prevlen -Targlen[il] > 0) then
            v:=(prevlen-d1)/(d1-Targlen[il])
          else v:=0;
//        end else
//          v:= 0;
          v:=1-sqrt(ElasticityC)*v;
          if v <= 1 then v:=1;
//          prevlen-b
//          prevLen:=b;
          b:=sqrt(ElasticityC)*b;//*v;
          vect2:=Scale3D(vect1,b);
//          Elasticity[il] := (prevlength-TargLen[il])/restlength;;                      //
           Elasticity[il] := abs(b);  // this makes force negative if b is negative
          vect2:=Scale3D(vect2,Elasticity[il]);     //    force = stiffness constant *(L-l)(L-l)
          R:=restlength;
  //        dL:=Length3D(vect2);
          prevLen:=d1;
//          af:=0;
//          if musc >= 0 then
//            af :=ElasticityC*(exp(-((d1-R)/R)*((d1-R)/R)/1.50));         //defines active force/length function
//          elasticity[il] := af + ElasticityC*30000*exp(6*(d1-3.2*R)/R);    // even if not active force add passive force/length function
          Atoms[Atom1].f:=Sub3D(Atoms[Atom1].f, vect2);      //Add the negative force vector to atom1
          if cbf = cbfStrutElastic then
            Atoms[Atom1].af:=Sub3D(Atoms[Atom1].af, vect2);
          wgt[Atom1]:=wgt[Atom1]+ElasticityC/2;             // half the force for each atom
//          cnt[Atom1] :=cnt[Atom1]+1;
          Atoms[Atom2].f:=Add3D(Atoms[Atom2].f, vect2);
          if cbf = cbfStrutElastic then
            Atoms[Atom2].af:=Add3D(Atoms[Atom2].af, vect2);   // add the force vector to atom2
          wgt[Atom2]:=wgt[Atom2]+ElasticityC/2;
//          cnt[Atom2]:=cnt[Atom2]+1;
        end;
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
{        b:=(RestLength-TargLen[il])/d1;
        if b <> 0 then        //if current length is different from the set length then calculate forces >>>> is this right? Should be <> ???
        begin
          b:=b/2;
          vect2:=Scale3D(vect1,b);
          vect2:=Scale3D(vect2,Elasticity[il]);
          if cbf = cbfMuscle then
          begin
            Atoms[Atom1].af:=Sub3D(Atoms[Atom1].af, vect2);
            Atoms[Atom2].af:=Add3D(Atoms[Atom2].af, vect2);
          end;
        end;   }
      end;
    end;

    for ia:=1 to NumAtoms do
    if wgt[ia] <> 0 then
    begin
      dL := Length3D(Atoms[ia].f);
      if (dL <> 0) then                                             // force=k(L-l)(L-l)
        Atoms[ia].f:=Scale3D(Atoms[ia].f,(sqrt(dL/sqrt(wgt[ia]{/cnt[ia]}))/dL))      // sum force vector leads to
      else Atoms[ia].f:= Zero3DPoint;
      if cbf = cbfStrutElastic then
        if dL <>0 then
          Atoms[ia].af:=Scale3D(Atoms[ia].af,(sqrt(dL/sqrt(wgt[ia]{/cnt[ia]}))/dL))
        else Atoms[ia].f:= Zero3DPoint;
      if cbf = cbfMuscle then
        Atoms[ia].af:=Scale3D(Atoms[ia].af,1/wgt[ia]);
      TotalForceT := TotalForceT + Length3D(Atoms[ia].f);
    end;

    TotalVolumeC:=0;
    if GasConst > 0 then
    begin
      for ph:=0 to high(Polyhedron) do
        AddPressureBrick(ph);
    end else
    begin
      for ph:=0 to high(Polyhedron) do
        TotalVolumeC:=TotalVolumeC+PolyhedronVolume(ph);
    end;

//    if GasConstArea > 0 then
//      for pg:=0 to high(Polygons) do
//        AddPressureFace(pg);

//    SetPrevStrutLength;   //save the old strut positions before updating them

    for ia:=1 to NumAtoms do
    case Atoms[ia].Fixing of
      chFree:
        begin
          Atoms[ia].p:=Add3D(Atoms[ia].p,Atoms[ia].f);
          case SymmetryAxes of
            plXY: Atoms[ia].p.z:=max(Atoms[ia].p.z,SymmetryCoord+1);
            plXZ: Atoms[ia].p.y:=min(Atoms[ia].p.y,SymmetryCoord-1);
            plYZ: Atoms[ia].p.x:=min(Atoms[ia].p.x,SymmetryCoord-1);
          end;
        end;
      chSym:
        begin
          case SymmetryAxes of
            plXY: begin Atoms[ia].p.x:=Atoms[ia].p.x+Atoms[ia].f.x; Atoms[ia].p.y:=Atoms[ia].p.y+Atoms[ia].f.y; end;
            plXZ: begin Atoms[ia].p.x:=Atoms[ia].p.x+Atoms[ia].f.x; Atoms[ia].p.z:=Atoms[ia].p.z+Atoms[ia].f.z; end;
            plYZ: begin Atoms[ia].p.y:=Atoms[ia].p.y+Atoms[ia].f.y; Atoms[ia].p.z:=Atoms[ia].p.z+Atoms[ia].f.z; end;
            pl3D: Atoms[ia].p:=Add3D(Atoms[ia].p,Atoms[ia].f);
          end;
        end;
    end;

    ApplyConstraints;
    ApplyRigity;
    ApplyConstraints;
    ApplyRigity;
  except
    on e:Exception do
    begin
      Stop;
      ShowMessage(e.Message);
      exit;
    end;
  end;
  pnlVolume.Caption:=' Time='+inttostr(GetTickCount-t)+' Vol='+FixedPointStr((TotalVolumeC+TotalVolumeT)/100000,0)+' F ='+FixedPointStr(TotalForceT,0);
end;

procedure TForm1.CalcPosition(timestep: FPnumber; last: boolean);     //Not used anymore
var TotalVolume,TotalForce, GasConst: single;
    cbf: Tcbf;
  procedure AddFacePressure(pg: integer; Pressure: single);
  var p,f: T3DPoint;
      area: single;
      e: integer;
      Face: TPolygon;
  begin
    face:=Polygons[pg];
    {this line only works for quads; otherwise use Area3D code for vector}
{
    if Face.a[4] = 0 then
      p:=CrossProduct3D(Sub3D(Atoms[Face.a[1]].p,Atoms[Face.a[3]].p),Sub3D(Atoms[Face.a[2]].p,Atoms[Face.a[3]].p)) else
      p:=CrossProduct3D(Sub3D(Atoms[Face.a[1]].p,Atoms[Face.a[3]].p),Sub3D(Atoms[Face.a[2]].p,Atoms[Face.a[4]].p));
}
    p:=PolgonNormal(pg);
    f:=scale3D(p,GasConst*Pressure/length(Face.a));
    for e:=low(Face.a) to high(Face.a) do
      if Face.a[e] > 0 then
      begin
        Atoms[Face.a[e]].f:=Add3D(Atoms[Face.a[e]].f,f);
        if cbf = cbfPressure then
          Atoms[Face.a[e]].af:=Add3D(Atoms[Face.a[e]].af,f);
      end;
  end;
  procedure AddPressure(ph: integer);
  var f: integer;
      v,Pressure: single;
  begin
    if Polyhedron[ph].Volume < 1 then
      exit;
    v:=PolyhedronVolume(ph);
    TotalVolume:=TotalVolume+v;
    Pressure:=(Polyhedron[ph].Volume-v)/Polyhedron[ph].Volume;

    for f:=0 to high(Polyhedron[ph].PosFace) do
      AddFacePressure(Polyhedron[ph].PosFace[f],-pressure);
    for f:=0 to high(Polyhedron[ph].NegFace) do
      AddFacePressure(Polyhedron[ph].NegFace[f],+pressure);
  end;
var accRoll,accPitch,accYaw: FPnumber;
    accCog: T3DPoint;
var a: TAtomRef;
    force: T3DPoint;
    q: T3DPoint;
    b: TStrutRef;
    dLen,d2: single;
    StrutDamping: single;
    Elasticity: FPnumber;
    ph: integer;
begin
  cbf:=Tcbf(dlgOptions.cbForceKind.ItemIndex);
  StrutDamping:=dlgOptions.seStrutDamping.Value/10;
  GasConst:=dlgOptions.seGasConst.Value;
  TotalVolume:=0;
  TotalForce:=0;
  {initialise}
  for a:=1 to NumAtoms do
  begin
    Atoms[a].f:=Zero3DPoint;
    Atoms[a].af:=Zero3DPoint;
  end;

(*
  {initialise and gravity}
  for a:=1 to NumAtoms do
    Atoms[a].f`.z:=Atoms[a].f`.z-Atoms[a].mass*Gravity;

  {hit floor}
  {AboveCeiling}
  for a:=1 to NumAtoms do
    if Atoms[a].p.z < 0 then
    begin
      Atoms[a].f`.z:=Atoms[a].f`.z-Atoms[a].p.z*100;
      Atoms[a].v.z:=Atoms[a].v.z*0.8;
      Atoms[a].f`.x:=Atoms[a].f`.x-Atoms[a].v.z*Friction;
      Atoms[a].f`.y:=Atoms[a].f`.y-Atoms[a].v.z*Friction;
    end else
    if Atoms[a].p.z > pbYZ.Height+20 then
      if Atoms[a].v.z > 0 then
        Atoms[a].v.z:=Atoms[a].v.z*0.99;
*)

  {damping}
  for a:=1 to NumAtoms do
    Atoms[a].f:=Add3D(Atoms[a].f,Scale3D(Atoms[a].v,-StrutDamping));

  for b:=1 to NumStruts do
  with Struts[b] do
  begin
    {strut length}
    if musc >= 0 then
    begin
      d2:=RestLength*muscle[musc].TrackBar.Position/100;
d2:=(d2-RestLength)*Coeff+RestLength;
      Elasticity:=(ElasticityR-ElasticityC)*d2/RestLength+ElasticityC;
    end else
    begin
      d2:=RestLength;
      Elasticity:=ElasticityR;
    end;

    if dlgOptions.cbDependsonlength.Checked then
      Elasticity:=Elasticity*50/RestLength;

    dLen:=Dist3D(Atoms[Atom1].p,Atoms[Atom2].p)-d2;
    force:=Scale3D(Normalise3D(Sub3D(Atoms[Atom1].p,Atoms[Atom2].p)),-dLen*Elasticity);
//    TotalForce := TotalForce+ force;
    Atoms[Atom1].f:=Add3D(Atoms[Atom1].f,force);
    Atoms[Atom2].f:=Sub3D(Atoms[Atom2].f,force);
    if cbf = cbfStrutElastic then
    begin
      Atoms[Atom1].af:=Add3D(Atoms[Atom1].af,force);
      Atoms[Atom2].af:=Sub3D(Atoms[Atom2].af,force);
    end;

    if cbf = cbfMuscle then
    begin
      dLen:=RestLength-d2;
      force:=Scale3D(Normalise3D(Sub3D(Atoms[Atom1].p,Atoms[Atom2].p)),-dLen*Elasticity);
      Atoms[Atom1].af:=Add3D(Atoms[Atom1].af,force);
      Atoms[Atom2].af:=Sub3D(Atoms[Atom2].af,force);
    end;

    {strut damping}
{
    dLen:=Dist3D(Atoms[Atom1].v,Atoms[Atom2].v);
    force:=Scale3D(Normalise3D(Sub3D(Atoms[Atom1].p,Atoms[Atom2].p)),dLen*StrutDamping);
    Atoms[Atom1].f:=Add3D(Atoms[Atom1].f,force);
    Atoms[Atom2].f:=Sub3D(Atoms[Atom2].f,force);
}
  end;

  for ph:=0 to high(Polyhedron) do
    AddPressure(ph);

  for a:=1 to NumAtoms do
  begin
    Atoms[a].v:=Add3D(Atoms[a].v,Scale3D(Atoms[a].f,timestep/Atoms[a].mass));
    if (Atoms[a].p.z < 0) and (Length3D(Atoms[a].v) < 3) then
      Atoms[a].v:=a3DPoint( 0, 0, 0);
    case Atoms[a].Fixing of
      chFree:
        Atoms[a].p:=Add3D(Atoms[a].p,Scale3D(Atoms[a].v,timestep));
      chSym:
        case SymmetryAxes of
          plXY: begin Atoms[a].p.x:=Atoms[a].p.x+Atoms[a].v.x/timestep; Atoms[a].p.y:=Atoms[a].p.y+Atoms[a].v.y/timestep; end;
          plXZ: begin Atoms[a].p.x:=Atoms[a].p.x+Atoms[a].v.x/timestep; Atoms[a].p.z:=Atoms[a].p.z+Atoms[a].v.z/timestep; end;
          plYZ: begin Atoms[a].p.y:=Atoms[a].p.y+Atoms[a].v.y/timestep; Atoms[a].p.z:=Atoms[a].p.z+Atoms[a].v.z/timestep; end;
          pl3D: Atoms[a].p:=Add3D(Atoms[a].p,Scale3D(Atoms[a].v,timestep));
        end;
    end;
  end;

  pnlVolume.Caption:=' Vol = '+FixedPointStr(TotalVolume,0);
{
  for a:=1 to NumAtoms do
  if Atoms[a].Fixing = chFree then
  begin
    Atoms[a].v:=Add3D(Atoms[a].v,Scale3D(Atoms[a].f,timestep/Atoms[a].mass));
    if (Atoms[a].p.z < 0) and (Length3D(Atoms[a].v) < 3) then
      Atoms[a].v:=a3DPoint( 0, 0, 0);
    Atoms[a].p:=Add3D(Atoms[a].p,Scale3D(Atoms[a].v,timestep));
  end;
}
end;

procedure TForm1.IncClock;
begin
  inc(Steps);
end;

procedure TForm1.pbYZInvalidate;
begin
  if pbYZ.Visible then
    pbYZ.Invalidate else
    PaintBoxPaint(imgYZ,imgYZ.Canvas,plYZ);
end;

procedure TForm1.pbXYInvalidate;
begin
  if pbXY.Visible then
    pbXY.Invalidate else
    PaintBoxPaint(imgXY,imgXY.Canvas,plXY);
end;

procedure TForm1.pbXZInvalidate;
begin
  if pbXZ.Visible then
    pbXZ.Invalidate else
    PaintBoxPaint(imgXZ,imgXZ.Canvas,plXZ);
end;

procedure TForm1.pb3DInvalidate;
begin
  if pb3D.Visible then
    pb3D.Invalidate else
    pb3DPaint(Self);
end;

function TForm1.pb3DCanvas: TCanvas;
begin
  if pb3D.Visible then
    result:=pb3D.Canvas else
    result:=img3D.Canvas;
end;

procedure TForm1.ProcessFormMessages(var Msg : tMsg; var Handled: Boolean);
var d: integer;
var lpMsg: TMsg;
var MessageMouseWheel: TWMMouseWheel absolute Msg;
begin
  if Msg.Message = WM_MOUSEWHEEL then
  begin
//    if (CurMode = tiEdit) then
//      if GetKeyState(vk_Rotate) < 0 then
    if (CurMode = tiEdit) and (GetKeyState(vk_Rotate) < 0) then
        RotateSelectedAtoms(sign(Msg.wparam)*pi/180) else
        ZoomInOut(sign(Msg.wparam));
    Handled:=true;
  end;

  case Msg.Message of
    WM_KEYDOWN:
      if Active then
      begin
        case Msg.wParam of
          ord('e'):     begin Stop; Handled:=True; End;
          ord('R'):     begin Run; Handled:=True; End;
          vk_MakeStrut: begin SetCursor; Handled:=True; End;
          vk_MakeAtom:  begin SetCursor; Handled:=True; End;
          vk_Shift:     begin SetCursor; Handled:=True; End;
          vk_Control:   begin SetCursor; Handled:=True; End;
          vk_Escape:    if (MouseMode = mmRotating) or (MouseMode = mmZooming) then
                        begin
                          MouseMode:=mmNone;
                          InvalidateAll;
                        end;
        End;
      end;
    WM_KEYUp:
      if Active then
      begin
//        Msg.wParam:=DLLKeyUp(Msg.wParam);
        case Msg.wParam of
          vk_MakeStrut: begin SetCursor; Handled:=True; End;
          vk_MakeAtom:  begin SetCursor; Handled:=True; End;
          vk_Shift:     begin SetCursor; Handled:=True; End;
          vk_Control:   begin SetCursor; Handled:=True; End;
        End;
      End;
  end;
end;

procedure TForm1.Mass1Click(Sender: TObject);
var a: TAtomRef;
begin
  for a:=1 to NumAtoms do
    with Atoms[a] do
      if Selected then
      begin
        dlgMass.seMass.Value:=abs(Mass);
        dlgMass.CheckBox1.Checked:=Mass < 0;
      end;

  if dlgMass.ShowModal = mrOK then
    for a:=1 to NumAtoms do
      with Atoms[a] do
        if Selected then
          begin
            Mass:=dlgMass.seMass.Value;
            if dlgMass.CheckBox1.Checked then
              Mass:=-Mass;
            Modified:=true;
          end;
end;

procedure TForm1.Edit3Click(Sender: TObject);
begin
  EditStrut;
end;

procedure TForm1.DeleteDuplicates1Click(Sender: TObject);
var b1,b2: TStrutRef;
    StrutBoolArray: TStrutBoolArray;
    b,n: integer;
begin
  fillchar(StrutBoolArray,sizeof(StrutBoolArray),0);

  for b:=1 to NumStruts do
    StrutBoolArray[b]:=Struts[b].Atom1 = Struts[b].Atom2;

  n:=0;
  for b1:=1 to NumStruts do
  for b2:=b1+1 to NumStruts do
  if ((Struts[b1].Atom1 = Struts[b2].Atom1) and (Struts[b1].Atom2 = Struts[b2].Atom2)) or
     ((Struts[b1].Atom1 = Struts[b2].Atom2) and (Struts[b1].Atom2 = Struts[b2].Atom1)) then
  begin
    b:=b1;
    if not StrutBoolArray[b] then
      inc(n);
    StrutBoolArray[b]:=true;
  end;

  if n = 0 then
    ShowInformationMessage('No duplicates') else
  if YesNoBox(inttostr(n)+' duplicate strut(s). Remove duplicates?') then
  begin
    DeleteStruts(StrutBoolArray);
    SetupStruts;
  end;
end;

procedure TForm1.DeleteStrut(Strut: TStrutNum);
var b: TStrutRef;
begin
  for b:=Strut to NumStruts-1 do
    Struts[b]:=Struts[b+1];
  SetNumStruts(NumStruts-1);
  SetupStruts;
  InvalidateAll;
ChkPoly;
  Modified:=true;
end;

procedure TForm1.EditStrut;
{Find=0 don't find; Find=1 find first; Find=2 find next}
var b: TStrutRef;
begin
  with dlgEditStrut do
  begin
    for b:=1 to NumStruts do
      with Struts[b] do
        if StrutSelected(b) then
        begin
          fsElasticityR.Value:=round(ElasticityR);
          fsElasticityC.Value:=round(ElasticityC);
          Edit1.Text:=StrutName;
          Edit1.ReadOnly:=NumSelectedStruts <> 1;
          sePenWidth.Value:=PenWidth;
          if Color < 0 then
            Panel1.Color:=clBtnFace else
            Panel1.Color:=Color;
          ComboBox1.ItemIndex:=ord(Axis);
        end;
    ceName.Checked:=false;
    cePen.Checked:=false;
    ceColor.Checked:=false;
    ceAxis.Checked:=false;
    ceRelaxed.Checked:=false;
    ceContracted.Checked:=false;

    if ShowModal = mrOK then
    begin
      for b:=1 to NumStruts do
      if StrutSelected(b) then
      begin
        if ceContracted.Checked then
          Struts[b].ElasticityC:=fsElasticityC.Value;
        if ceRelaxed.Checked then
          Struts[b].ElasticityR:=fsElasticityR.Value;
        if ceName.Checked then
          Struts[b].StrutName:=Edit1.Text;
        if cePen.Checked then
          Struts[b].PenWidth:=sePenWidth.Value;
        if ceColor.Checked then
          if Panel1.Color = clBtnFace then
            Struts[b].Color:=-1 else
            Struts[b].Color:=Panel1.Color;
        if ceAxis.Checked then
          Struts[b].Axis:=TAxis(ComboBox1.ItemIndex);
      end;

      Modified:=true;
      InvalidateAll;
ChkPoly;
    end;
  end;
end;

function TForm1.SharedAtom(b1,b2: TStrutRef): TAtomRef;
begin
  if ((Struts[b1].Atom1 = Struts[b2].Atom1) and (Struts[b1].Atom2 <> Struts[b2].Atom2)) then result:=Struts[b1].Atom1 else
  if ((Struts[b1].Atom1 = Struts[b2].Atom2) and (Struts[b1].Atom2 <> Struts[b2].Atom1)) then result:=Struts[b1].Atom1 else
  if ((Struts[b1].Atom2 = Struts[b2].Atom1) and (Struts[b1].Atom1 <> Struts[b2].Atom2)) then result:=Struts[b1].Atom2 else
  if ((Struts[b1].Atom2 = Struts[b2].Atom2) and (Struts[b1].Atom1 <> Struts[b2].Atom1)) then result:=Struts[b1].Atom2 else
       result:=0;
end;

function TForm1.xSnapToGrid(x: integer; Axes: TAxes): integer;
begin
  if dlgOptions.cbSnap.Checked then
  case Axes of
    plXZ: begin x:=round(((x-cOfs2DX)/zoom-imgXZ.Width div 2)/GridSize); x:=round(zoom*(imgXZ.Width div 2+GridSize*x))+cOfs2DX; end;
    plXY: begin x:=round(((x-bOfs2DX)/zoom-imgXY.Width div 2)/GridSize); x:=round(zoom*(imgXY.Width div 2+GridSize*x))+bOfs2DX; end;
    plYZ: begin x:=round(((x-aOfs2DY)/zoom-imgYZ.Width div 2)/GridSize); x:=round(zoom*(imgYZ.Width div 2+GridSize*x))+aOfs2DY; end;
  end;
  result:=x;
end;

function TForm1.ySnapToGrid(y: integer; Axes: TAxes): integer;
var ay: single;
begin
  if dlgOptions.cbSnap.Checked then
  case Axes of
    plXZ: begin y:=round((imgXZ.Height-(y-cOfs2DZ)/zoom)/GridSize); y:=round(zoom*(imgXZ.Height-GridSize*y-1))+cOfs2DZ; end;
    plXY: begin y:=round((imgXY.Height div 2-(y-bOfs2DY)/zoom)/GridSize); y:=round(zoom*(imgXY.Height div 2-GridSize*y))+bOfs2DY; end;
    plYZ: begin y:=round((imgYZ.Height-(y-aOfs2DZ)/zoom)/GridSize); y:=round(zoom*(imgYZ.Height-GridSize*y-1))+aOfs2DZ; end;
  end;
  result:=y;
end;

procedure TForm1.DeleteSingleAtoms;
var a: TAtomRef;
    AtomBoolArray: TAtomBoolArray;
    b: TStrutRef;
begin
  for a:=1 to NumAtoms do
    AtomBoolArray[a]:=true;

  for b:=1 to NumStruts do
    with Struts[b] do
    begin
      AtomBoolArray[Atom1]:=not true;
      AtomBoolArray[Atom2]:=not true;
    end;

  DeleteAtoms(AtomBoolArray);
end;

procedure TForm1.Mirrorx1Click(Sender: TObject);
var a: TAtomRef;
    d: FPnumber;
begin
  if NumSelectedAtoms = 0 then exit;

  d:=0;
  for a:=1 to NumAtoms do
    with Atoms[a] do
      if Selected then
        d:=d+Atoms[a].p.x;
  d:=d/NumSelectedAtoms;

  for a:=1 to NumAtoms do
    with Atoms[a] do
      if Selected then
        Atoms[a].p.x:=2*d-Atoms[a].p.x;
  Modified:=true;
  FixSymmetryAtoms;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.Mirrorz1Click(Sender: TObject);
var a: TAtomRef;
    d: FPnumber;
begin
  if NumSelectedAtoms = 0 then exit;

  d:=0;
  for a:=1 to NumAtoms do
    with Atoms[a] do
      if Selected then
        d:=d+Atoms[a].p.z;
  d:=d/NumSelectedAtoms;

  for a:=1 to NumAtoms do
    with Atoms[a] do
      if Selected then
        Atoms[a].p.z:=2*d-Atoms[a].p.z;
  Modified:=true;
  FixSymmetryAtoms;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.Mirrory1Click(Sender: TObject);
var a: TAtomRef;
    d: FPnumber;
begin
  if NumSelectedAtoms = 0 then exit;

  d:=0;
  for a:=1 to NumAtoms do
    with Atoms[a] do
      if Selected then
        d:=d+Atoms[a].p.y;
  d:=d/NumSelectedAtoms;

  for a:=1 to NumAtoms do
    with Atoms[a] do
      if Selected then
        Atoms[a].p.y:=2*d-Atoms[a].p.y;
  Modified:=true;
  FixSymmetryAtoms;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.Static1Click(Sender: TObject);
var a: TAtomRef;
begin
  Modified:=true;
  SetUndo;
  Normal1.Checked:=Sender = Normal1;
  Static1.Checked:=Sender = Static1;
  SymmetryAxes1.Checked:=Sender = SymmetryAxes1;

  for a:=1 to NumAtoms do
    with Atoms[a] do
     if Selected then
       Fixing:=TFixing(TControl(Sender).Tag);

  CheckClearSym;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.CheckClearSym;
var a: TAtomRef;
begin
  for a:=1 to NumAtoms do
    with Atoms[a] do
      if Fixing = chSym then
        exit;

  SymmetryAxes:=pl3D;
  InvalidateAll;
end;

procedure TForm1.MakeGrid1Click(Sender: TObject);
var x,y,z: integer;
    a: array[0..30,0..30,0..30] of integer;
    p: array[0..30,0..30,0..30,plXY..plYZ] of integer;
    x0,y0,z0: single;
    a1: TAtomRef;
const aValuex: integer = 3;
      aValuey: integer = 3;
      aValuez: integer = 3;
      aValuew: integer = 40;
begin
  SetUndo;
  Modified:=true;
  if InputNumberQuery4('Make Grid','x-count','y-count','z-count','Size',aValuex,aValuey,aValuez,aValuew,1,50) then
  begin
    x0:=(-aValuex/2)*aValuew;
    y0:=(-aValuey/2)*aValuew;
    z0:=0;

    if dlgOptions.cbSnap.Checked then
    begin
      x0:=round(x0/GridSize)*GridSize;
      y0:=round(y0/GridSize)*GridSize;
      z0:=round(z0/GridSize)*GridSize;
    end;

    for x:=0 to aValuex do
      for y:=0 to aValuey do
        for z:=0 to aValuez do
          a[x,y,z]:=NewAtom(x*aValuew+x0,y*aValuew+y0,z*aValuew+z0,DefaultMass);

    for x:=0 to aValuex do
    for y:=0 to aValuey do
    for z:=0 to aValuez do
    begin
      if x > 0 then
        NewStrut(a[x-1,y,z],a[x,y,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axX);
      if y > 0 then
        NewStrut(a[x,y-1,z],a[x,y,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axY);
      if z > 0 then
        NewStrut(a[x,y,z-1],a[x,y,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axZ);

      if Sender = MakeGridC1 then
      begin
        {single diagonal }
        if (x > 0) and (y > 0) then
          if odd(x+y+z) then
            NewStrut(a[x-1,y,z],a[x,y-1,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone) else
            NewStrut(a[x-1,y-1,z],a[x,y,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
        if (x > 0) and (z > 0) then
          if odd(x+y+z) then
            NewStrut(a[x-1,y,z],a[x,y,z-1],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone) else
            NewStrut(a[x-1,y,z-1],a[x,y,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
        if (y > 0) and (z > 0) then
          if odd(x+y+z) then
            NewStrut(a[x,y-1,z],a[x,y,z-1],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone) else
            NewStrut(a[x,y-1,z-1],a[x,y,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
      end else
      if Sender = MakeGridB1 then
      begin
        {Major diagonals}
        if (x > 0) and (y > 0) and (z > 0) then
        begin
  {
          NewStrut(a[x,y,z],a[x-1,y-1,z-1],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
          NewStrut(a[x-1,y,z],a[x,y-1,z-1],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
          NewStrut(a[x,y-1,z],a[x-1,y,z-1],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
          NewStrut(a[x,y,z-1],a[x-1,y-1,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
  }
          a1:=NewAtom((x-0.5)*aValuew+x0,(y-0.5)*aValuew+y0,(z-0.5)*aValuew+z0,DefaultMass);
          NewStrut(a1,a[x,y,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
          NewStrut(a1,a[x-1,y,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
          NewStrut(a1,a[x,y-1,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
          NewStrut(a1,a[x,y,z-1],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);

          NewStrut(a1,a[x-1,y-1,z-1],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
          NewStrut(a1,a[x,y-1,z-1],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
          NewStrut(a1,a[x-1,y,z-1],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
          NewStrut(a1,a[x-1,y-1,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
        end;
      end else
      begin
        {double diagonal}
        if (x > 0) and (y > 0) then
        begin
          NewStrut(a[x-1,y,z],a[x,y-1,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
          NewStrut(a[x-1,y-1,z],a[x,y,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
        end;
        if (x > 0) and (z > 0) then
        begin
          NewStrut(a[x-1,y,z],a[x,y,z-1],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
          NewStrut(a[x-1,y,z-1],a[x,y,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
        end;
        if (y > 0) and (z > 0) then
        begin
          NewStrut(a[x,y-1,z],a[x,y,z-1],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
          NewStrut(a[x,y-1,z-1],a[x,y,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
        end;
      end;

      if (x > 0) and (y > 0) then
        p[x,y,z,plXY]:=NewPolygon(a[x-1,y-1,z],a[x,y-1,z],a[x,y,z],a[x-1,y,z],0);
      if (x > 0) and (z > 0) then
        p[x,y,z,plXZ]:=NewPolygon(a[x-1,y,z-1],a[x,y,z-1],a[x,y,z],a[x-1,y,z],0);
      if (y > 0) and (z > 0) then
        p[x,y,z,plYZ]:=NewPolygon(a[x,y-1,z-1],a[x,y,z-1],a[x,y,z],a[x,y-1,z],0);
      if (x > 0) and (y > 0) and (z > 0) then
        NewPolyhedron([p[x+0,y+0,z-1,plXY],p[x+0,y+0,z+0,plXZ],p[x-1,y+0,z+0,plYZ]],[p[x+0,y+0,z+0,plXY],p[x+0,y-1,z+0,plXZ],p[x+0,y+0,z+0,plYZ]]);
    end;

ChkPoly;
    InvalidateAll;
  end;
end;

procedure TForm1.ZoomInOutEx(aSign: single; About: TPoint; Axes: TAxes);
var p: TSinglePoint;
    p2: TPoint;
begin
  p:=UnZoomScroll(About.x,About.y,Axes);
  if aSign > 0 then
    Zoom:=Zoom*1.1 else
    Zoom:=Zoom/1.1;
  p2:=ZoomScroll(p.x,p.y,Axes);
  case Axes of
    plXY: begin bOfs2DX:=bOfs2DX-p2.x+About.x; aOfs2DY:=aOfs2DY-p2.y+About.y; end;
    plXZ: begin bOfs2DX:=bOfs2DX-p2.x+About.x; aOfs2DZ:=aOfs2DZ-p2.y+About.y; end;
    plYZ: begin aOfs2DY:=aOfs2DY-p2.x+About.x; aOfs2DZ:=aOfs2DZ-p2.y+About.y; end;
    pl3D: begin Ofs3DX:=Ofs3DX-p2.x+About.x; Ofs3DY:=Ofs3DY-p2.y+About.y; end;
  end;
  InvalidateAll;
end;

procedure TForm1.ZoomInOut(aSign: single);
var p: TSinglePoint;
    p1,p2: TPoint;
begin
  if (MouseMode = mmRotating) or (MouseMode = mmZooming) then
  begin
    MouseMode:=mmNone;
    InvalidateAll;
  end;

  if IsCursorInControl(pnlXY) then
  begin
    p1:=CursorInControl(pnlXY);
    p:=UnZoomScroll(p1.x,p1.y,plXY);
    if aSign > 0 then
      Zoom:=Zoom*1.1 else
      Zoom:=Zoom/1.1;
    p2:=ZoomScroll(p.x,p.y,plXY);
    bOfs2DX:=bOfs2DX-p2.x+p1.x;
    aOfs2DY:=aOfs2DY-p2.y+p1.y;
  end else
  if IsCursorInControl(pnlXZ) then
  begin
    p1:=CursorInControl(pnlXZ);
    p:=UnZoomScroll(p1.x,p1.y,plXZ);
    if aSign > 0 then
      Zoom:=Zoom*1.1 else
      Zoom:=Zoom/1.1;
    p2:=ZoomScroll(p.x,p.y,plXZ);
    bOfs2DX:=bOfs2DX-p2.x+p1.x;
    aOfs2DZ:=aOfs2DZ-p2.y+p1.y;
  end else
  if IsCursorInControl(pnlYZ) then
  begin
    p1:=CursorInControl(pnlYZ);
    p:=UnZoomScroll(p1.x,p1.y,plYZ);
    if aSign > 0 then
      Zoom:=Zoom*1.1 else
      Zoom:=Zoom/1.1;
    p2:=ZoomScroll(p.x,p.y,plYZ);
    aOfs2DY:=aOfs2DY-p2.x+p1.x;
    aOfs2DZ:=aOfs2DZ-p2.y+p1.y;
  end else
  if IsCursorInControl(pnl3D) then
  begin
    p1:=CursorInControl(pnl3D);
    p:=UnZoomScroll(p1.x,p1.y,pl3D);
    if aSign > 0 then
      Zoom:=Zoom*1.1 else
      Zoom:=Zoom/1.1;
    p2:=ZoomScroll(p.x,p.y,pl3D);
    Ofs3DX:=Ofs3DX-p2.x+p1.x;
    Ofs3DY:=Ofs3DY-p2.y+p1.y;
  end else
  begin
    if aSign > 0 then
      Zoom:=Zoom*1.1 else
      Zoom:=Zoom/1.1;
  end;
  InvalidateAll;
end;

procedure TForm1.RotateSelectedAtomsEx(Angle: single; About: TPoint; Axes: TAxes);
var a: TAtomRef;
    b: TStrutRef;
    n: integer;
    t: T3DPoint;
begin
  with About,UnZoomScroll(x,y,MouseModeAxes),UnProj2D(round(x),round(y),Axes) do
  for a:=1 to NumAtoms do
  with Atoms[a] do
  if Selected then
  case Axes of
    plXY: rotateXY2(angle,p.x,p.y,x,y,p.x,p.y);
    plXZ: rotateXY2(angle,p.x,p.Z,x,Z,p.x,p.Z);
    plYZ: rotateXY2(angle,p.Y,p.Z,Y,Z,p.Y,p.Z);
  end;
  CalcStrutRestLength;
  Modified:=true;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.RotateSelectedAtoms(Angle: single);
var a: TAtomRef;
    b: TStrutRef;
    n: integer;
    t: T3DPoint;
begin
  for a:=1 to NumAtoms do
  with Atoms[a] do
  if Selected then
  begin
    if IsCursorInControl(imgXY) then
      with CursorInControl(imgXY),UnZoomScroll(x,y,plXY),UnProj2D(round(x),round(y),plXY) do
        rotateXY2(angle,p.x,p.y,x,y,p.x,p.y) else
    if IsCursorInControl(imgXZ) then
      with CursorInControl(imgXZ),UnZoomScroll(x,y,plXZ),UnProj2D(round(x),round(y),plXZ) do
        rotateXY2(angle,p.x,p.Z,x,Z,p.x,p.Z) else
    if IsCursorInControl(imgYZ) then
      with CursorInControl(imgYZ),UnZoomScroll(x,y,plYZ),UnProj2D(round(x),round(y),plYZ) do
        rotateXY2(angle,p.Y,p.Z,Y,Z,p.Y,p.Z);
  end;

  CalcStrutRestLength;
  Modified:=true;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.Removefromallmuscles1Click(Sender: TObject);
var b: TStrutRef;
begin
  SetUndo;

  for b:=1 to NumStruts do
    if StrutSelected(b) then
    begin
      Modified:=true;
      Struts[b].musc:=-1;
    end;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.Addtocurrentmuscle1Click(Sender: TObject);
var b: TStrutRef;
begin
  if length(muscle) = 0 then
    exit;
  SetUndo;

  for b:=1 to NumStruts do
    with Struts[b] do
      if StrutSelected(b) then
      begin
        musc:=CurMuscle;
        coeff:=1;
        Modified:=true;
      end;

  InvalidateAll;
ChkPoly;
end;

procedure SetImg(img: TBitmap; Pix: TPix; mono: boolean);
begin
  img.Width:=Pix.Width;
  img.Height:=Pix.Height;
  if mono then
    PixDraw(img.Canvas,0,0,PixBrightnessContrast2(PixConvertToColorModel(Pix,cg3R6G1B),96,64)) else
    PixDraw(img.Canvas,0,0,Pix);
end;

procedure SetImgFile(img: TBitmap; filename: string; mono: boolean);
var Pix: TPix;
begin
  if (filename <> '') and FileExists(filename) then
  begin
    if uppercase(ExtractFileExt(FileName)) = '.PNG' then 
    begin
      LoadBmpFromPNG(img,filename);
    end else
    begin
      Pix:=PixLoadFromFile(filename);
      SetImg(img,Pix,mono);
    end;
  end else
  begin
    img.Width:=0;
    img.Height:=0;
  end;
end;

procedure TForm1.pbTimelineMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var k: integer;
begin
  CurKeyframe:=-1;
  if y < pbTimeline.height div 2 then
    for k:=0 to high(Keyframe) do
      if InRange(x,TLTimeToX(Keyframe[K].TLTime),TLTimeToX(Keyframe[K].TLTime)+pnlTimelineRed.Width) then
        CurKeyframe:=k;

  case Button of
    mbLeft:
      begin
        pbTimelineMouseMove(nil,Shift,X,Y);
        IsAtKeyframe;
      end;
    mbRight:
      with pbTimeline.ClientToScreen(Point(x,y)) do
        puTimeline2.Popup(x,y);
  end;
end;

procedure TForm1.pbTimelineMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if not (ssLeft in Shift) then
    CurKeyframe:=-1;
  if CurKeyframe >= 0 then
  begin
    Run;
    if CurKeyframe > 0 then
    begin
      if LockKeyframes1.Checked then
      begin
        TimelineCurTime:=Keyframe[CurKeyframe].TLTime;
      end else
      begin
        TimelineCurTime:=XToTLTime(x-pnlTimelineRed.Width div 2);
        Keyframe[CurKeyframe].TLTime:=IntRange(TimelineCurTime,0,MaxTime);
      end;
    end else
      TimelineCurTime:=0;

    pbTimeline.Invalidate;
    pbTimeline.Update;
    LoadTrackbars;
  end;
end;

procedure TForm1.pbTimelineMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SortKeyframes;
  IsAtKeyframe;
  CurKeyframe:=-1;
end;

procedure TForm1.pbTimelinePaint(Sender: TObject);
var k: integer;
begin
  with pbTimeline,Canvas do
  begin
    if Sender = nil then
    begin
      Brush.Color:=clBlue;
      FillRect(ClientRect);
      pbTimeline.Update;
      Sleep(50);
      Brush.Color:=clBtnFace;
    end;
    FillRect(ClientRect);

    TextOut(width-TextWidth(FixedPointStr(MaxTime/1000,3))-2,13,FixedPointStr(MaxTime/1000,3));
//   TextOut(width-TextWidth(FixedPointStr(TimelineCurTime/1000,3))-2,13,FixedPointStr(TimelineCurTime/1000,3));
    if pnlTimelineRed.Left < ClientWidth div 2 then
      TextOut(pnlTimelineRed.Left+pnlTimelineRed.Width+2,13,FixedPointStr(TimelineCurTime/1000,3)) else
      TextOut(pnlTimelineRed.Left-TextWidth(FixedPointStr(TimelineCurTime/1000,3))-2,13,FixedPointStr(TimelineCurTime/1000,3));

    for k:=0 to high(Keyframe) do
    begin
      if Keyframe[k].TLTime = TimelineCurTime then
        Brush.Color:=clBlue else
      if InRange(CurMuscle,0,high(muscle)) and not Keyframe[k].posq[CurMuscle].Significant then
        Brush.Color:=clSilver else
        Brush.Color:=clWhite;
      if LockKeyframes1.Checked then
        Pen.Color:=clRed else
        Pen.Color:=clBlack;
      Rectangle(TLTimeToX(Keyframe[K].TLTime),0,TLTimeToX(Keyframe[K].TLTime)+pnlTimelineRed.Width,Height div 2);
    end;

    Brush.Color:=clBtnFace;
    Pen.Color:=clBlack;
    pbMuscleChart.Invalidate;
  end;
end;

procedure TForm1.pnlTimelineRedMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
begin
  if ssLeft in Shift then
  begin
//    TimelineCurTime:=IntRange(XToTLTime(CursorInControl(pnlTimeline1).x),0,MaxTime-pnlTimelineRed.Width div 2);
    TimelineCurTime:=XToTLTime(CursorInControl(pnlTimeline1).x);
    Run;
    LoadTrackbars;
    IsAtKeyframe;
  end;
end;

procedure TForm1.pnlTimelineRedMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IsAtKeyframe;
  CurKeyframe:=-1;
end;

procedure TForm1.sbTimelineClick(Sender: TObject);
begin
  if TimelineCurTime >= MaxTime then
    TimelineCurTime:=0;
  if sbTimeline.Down then
  begin
    Run;
    dlgEMA.ExportEMAStart;
  end;
  if sbTimeline.Down then
    tmrKeyframeTimer(nil) else
  begin
    tmrKeyframe.enabled:=false;
    dlgEMA.ExportEMAFinish;
  end;
end;

procedure TForm1.NewKeyframe1Click(Sender: TObject);
begin
  NewKeyframe(true,true);
end;

procedure TForm1.NewKeyframe(Sort,signif: boolean);
var m: integer;
begin
  SetUndo;
  Modified:=true;

  SaveRestoreKeyframesMusclePos(true,false);
  setlength(Keyframe,Length(Keyframe)+1);
  Keyframe[high(Keyframe)].TLTime:=TimelineCurTime;

  setlength(Keyframe[high(Keyframe)].posq,length(muscle));
  for m:=0 to high(muscle) do
  begin
    Keyframe[high(Keyframe)].posq[m].p:=muscle[m].TrackBar.Position;
    Keyframe[high(Keyframe)].posq[m].Significant:= true;
  end;

  if sort then
  begin
    SortKeyframes;
    CurKeyframe:=IsAtKeyframe;
    if Running then
    begin
      SaveRestoreKeyframesMusclePos(false,false);
      LoadSaveKeyframe(false,IsAtKeyframe);
    end;

    pbTimeline.Invalidate;
    Modified:=true;
CheckAllKeyframes;
  end;
end;

procedure TForm1.DeleteKeyframe1Click(Sender: TObject);
begin
  SetUndo;
  Modified:=true;
  Stop;
  DeleteKeyframe(CurKeyframe);
  pbTimeline.Invalidate;
  CurKeyframe:=-1;
end;

procedure TForm1.puMusclesPopup(Sender: TObject);
begin
  Delete3.enabled:=(puMuscles.PopupComponent <> pnlMuscles1) and not Running;
  Rename1.enabled:=(puMuscles.PopupComponent <> pnlMuscles1) and not Running;
  NewMuscle1.enabled:=not Running;

  if puMuscles.PopupComponent <> pnlMuscles1 then
    SetCurMuscle(puMuscles.PopupComponent.Tag);

//    ActiveControl:=muscle[puMuscles.PopupComponent.Tag].TrackBar;
end;

procedure TForm1.Delete3Click(Sender: TObject);
var b: TStrutRef;
begin
  SetUndo;

  DeleteMuscle(puMuscles.PopupComponent.Tag);
  if length(muscle) > 0 then
    SetCurMuscle(IntRange(puMuscles.PopupComponent.Tag,0,high(muscle)));
  Modified:=true;
end;

procedure TForm1.NewMuscle1Click(Sender: TObject);
const Value: string = 'Muscle';
begin
  Stop;

  SetUndo;
  if InputQuery('New Muscle','Name',Value) then
  begin
    NewMuscle(Value,false);
    Addtocurrentmuscle1Click(Sender);
  end;
  Modified:=true;
end;

procedure TForm1.DeleteMuscle(n: integer);
var m: integer;
var b: TStrutRef;
begin
  muscle[n].TrackBar.Parent.Free;

  for m:=n to high(muscle)-1 do
  begin
    muscle[m]:=muscle[m+1];
    if muscle[m].TrackBar.Tag > n then
    begin
      muscle[m].TrackBar.Tag:=muscle[m].TrackBar.Tag-1;
      muscle[m].TrackBar.Parent.Tag:=muscle[m].TrackBar.Parent.Tag-1;
      muscle[m].Label1.Tag:=muscle[m].Label1.Tag-1;
    end;
  end;
  setlength(muscle,length(muscle)-1);

  for b:=1 to NumStruts do
    if Struts[b].musc = n then
      Struts[b].musc:=-1 else
    if Struts[b].musc > n then
      dec(Struts[b].musc);

  SetCurMuscle(IntRange(CurMuscle,0,high(muscle)));
  DeleteMuscleInKeyframes(n);
end;

procedure TForm1.SetCurMuscle(im: integer);
var m: integer;
begin
  CurMuscle:=im;

  for m:=0 to high(muscle) do
    if m = im then
      TPanel(muscle[m].TrackBar.Parent).BevelOuter:=bvLowered else
      TPanel(muscle[m].TrackBar.Parent).BevelOuter:=bvRaised;

  if InRange(im,0,high(muscle)) then
    if pnlMuscles1.Enabled then
      SetFocusedControl(muscle[im].TrackBar);
  InvalidateAll;
  Invalidate;
end;

function TForm1.IsAtKeyframe: integer;
var m,k: integer;
begin
CheckAllKeyframes;
  result:=-1;
  for k:=0 to high(Keyframe) do
    if Keyframe[k].TLTime = TimelineCurTime then
      result:=k;

  if pnlMuscles1.Enabled <> (result >= 0) then
  begin
    pnlMuscles1.Enabled:=result >= 0;
    Edit1.enabled:=result >= 0;
    Selection1.enabled:=result >= 0;
    Points1.enabled:=result >= 0;
    Struts1.enabled:=result >= 0;
    Polygon1.enabled:=result >= 0;
    View1.enabled:=result >= 0;

//    Form2.Point1.enabled:=result >= 0;
//    Form2.Links1.enabled:=result >= 0;

    for m:=0 to high(muscle) do
      with muscle[m] do
        if pnlMuscles1.Enabled then
          TrackBar.TickStyle:=tsAuto else
          TrackBar.TickStyle:=tsNone;
  end;
end;

procedure TForm1.DeleteMuscleInKeyframes(n: integer);
var k,m: integer;
begin
  for k:=0 to high(Keyframe) do
  begin
    for m:=n to high(Keyframe[k].posq)-1 do
      Keyframe[k].posq[m]:=Keyframe[k].posq[m+1];
    setlength(Keyframe[k].posq,max(length(Keyframe[k].posq)-1,0));
  end;
CheckAllKeyframes;
end;

function TForm1.NewMuscle(s: string; IgnoreDups: boolean): integer;
var aPanel: TPanel;
begin
  if IgnoreDups then
    for result:=0 to high(muscle) do
      if uppercase(Before(muscle[result].Label1.Caption,'=')) = s then
        exit;

  setlength(muscle,length(muscle)+1);
  result:=high(muscle);

  aPanel:=TPanel.Create(Self);
  with aPanel do
  begin
    Visible:=true;
    Parent:=pnlMuscles1;
    Tag:=high(muscle);
    Left:=2;
    Top:=100000;
    Width:=181;
    Height:=47;
    Align:=alTop;
//    BevelOuter:=bvNone;
    Caption:=' ';
    TabOrder:=0;
    OnMouseDown:=MusclePanelMouseDown;
    OnMouseMove:=MusclePanelMouseMove;
    PopupMenu:=puMuscles;

    muscle[high(muscle)].Label1:=TLabel.Create(Self);
    with muscle[high(muscle)].Label1 do
    begin
      Visible:=true;
      Parent:=aPanel;
      Tag:=high(muscle);
      Left:=4;
      Top:=1;
      Width:=63;
      Height:=13;
      Caption:=s+'=100%';
      OnMouseDown:=MusclePanelMouseDown;
      OnMouseMove:=MusclePanelMouseMove;
    end;

    muscle[high(muscle)].TrackBar:=TTrackBar.Create(Self);
    with muscle[high(muscle)].TrackBar do
    begin
      Visible:=true;
      Parent:=aPanel;
      Tag:=high(muscle);
      Left:=8;
      Top:=14;
      Width:=aPanel.Width-Left-14;
      Height:=27;
      Max:=100;
      Min:=30;
      Frequency:=5;
      Orientation:=trHorizontal;
      position:=100;
      selend:=100;    //use selend to remember previous position
      SelEnd:=0;
      SelStart:=0;
      TabOrder:=0;
      ThumbLength:=20;
      TickMarks:=tmBottomRight;
      TickStyle:=tsAuto;
      OnChange:=TrackBarChange;
      OnEnter:=TrackBarEnter;
    end;
    SetCurMuscle(high(muscle));
  end;

  NewMuscleInKeyframes;
  Modified:=true;
end;

procedure TForm1.NewMuscleInKeyframes;
{add muscle [high(muscle)] to all keyframes}
var k: integer;
begin
  for k:=0 to high(Keyframe) do
  begin
    setlength(Keyframe[k].posq,length(Keyframe[k].posq)+1);
    assert(length(Keyframe[k].posq) = length(muscle));
    Keyframe[k].posq[high(muscle)].p:=100;
  end;
CheckAllKeyframes;
end;

procedure TForm1.DeleteKeyframe(n: integer);
var k: integer;
begin
  for k:=n to high(Keyframe)-1 do
    Keyframe[k]:=Keyframe[k+1];
  setlength(Keyframe,length(Keyframe)-1);
  SortKeyframes;
  Modified:=true;
CheckAllKeyframes;
end;

procedure TForm1.CheckAllKeyframes;
var m,k: integer;
begin
  for k:=0 to high(Keyframe)-1 do
    assert(Keyframe[k].TLTime <= Keyframe[k+1].TLTime);
end;

procedure TForm1.SortKeyframes;
var k: integer;
    aKeyframe: TKeyframe;
begin
  for k:=0 to high(Keyframe)-1 do
  begin
    if Keyframe[k].TLTime > Keyframe[k+1].TLTime then
    begin
      aKeyframe:=Keyframe[k+1];
      Keyframe[k+1]:=Keyframe[k];
      Keyframe[k]:=aKeyframe;
      SortKeyframes;
      exit;
    end;
  end;
  Keyframe0Significant;
CheckAllKeyframes;
end;

procedure TForm1.TrackBarChange(Sender: TObject);
begin
  Run;
  with TTrackBar(Sender),muscle[Tag] do
    Label1.Caption:=Before(Label1.Caption,'=')+'='+inttostr(Position)+'%';
  LoadSaveKeyframe(false,IsAtKeyframe);
end;

procedure TForm1.TrackBarEnter(Sender: TObject);
begin
  SetCurMuscle(TTrackBar(Sender).Tag);
end;

procedure TForm1.LoadSaveKeyframe(Load: boolean; k: integer);
var m: integer;
const executing: boolean = false;
begin
CheckAllKeyframes;
  if k >= 0 then
  if not executing then
  try
    executing:=true;
    if Load then
    begin
      for m:=0 to high(Keyframe[k].posq) do
        SetTrackBarPosition(m,Keyframe[k].posq[m].p);
    end else
    begin
      for m:=0 to high(Keyframe[k].posq) do
        Keyframe[k].posq[m].p:=muscle[m].TrackBar.Position;
    end;
  finally
    executing:=false;
  end;
end;

procedure TForm1.MusclePanelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetFocusedControl(muscle[TControl(Sender).Tag].TrackBar);
end;

procedure TForm1.MusclePanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
begin
  if ssLeft in Shift then
  if not running then
  with TPanel(muscle[TControl(Sender).Tag].TrackBar.Parent) do
    if y < -10 then
    begin
      Top:=max(Top-Height-1,10);
      Modified:=true;
    end else
    if y > Height+10 then
    begin
      Top:=Top+Height+1;
      Modified:=true;
    end;
end;

procedure TForm1.LoadTrackbars;
  function Interpolate(t,h0,h1,h2,h3: single; k: integer): integer;
  var a,b,c,d,b1,b2: single;
  begin
    a:=h1;
    c:=(h0+h2)/2-h1;
    d:=(h1-c*2-2*h2+h3)/6;
    b:=a-h0+c-d;

    b1:=b;
    b2:=b+2*c+3*d;

    if k = 0 then
      b1:=0;
    if k = high(Keyframe) then
      b2:=0;

    a:=h1;
    b:=b1;
    c:=3*(h2-h1)-2*b1-b2;
    d:=2*(h1-h2)+b1+b2;

    result:=round(a+b*t+c*t*t+d*t*t*t);
  end;
  function NextK(k,m: integer): integer;
  var k2: integer;
  begin
    result:=k;
    for k2:=k+1 to high(Keyframe) do
      if Keyframe[k2].posq[m].Significant then
      begin
        result:=k2;
        exit;
      end;
  end;
  function PrevK(k,m: integer): integer;
  var k2: integer;
  begin
    result:=k;
    for k2:=k-1 downto 0 do
      if Keyframe[k2].posq[m].Significant then
      begin
        result:=k2;
        exit;
      end;
  end;
var m,k,k2: integer;
    t: single;
begin
  if CurKeyframe = 0 then
  begin
    TimelineCurTime:=0;
  end else
  begin
    for m:=0 to high(muscle) do
    begin
      k:=0;
      for k2:=0 to high(Keyframe) do
        if (Keyframe[k2].TLTime <= TimelineCurTime) and Keyframe[k2].posq[m].Significant then
          k:=k2;

      if (k >= NextK(k,m)) or (dlgOptions.rbMuscleInterpolate.ItemIndex > 0) then
      begin
          SetTrackBarPosition(m,Keyframe[k].posq[m].p);
      end else
      begin
        t:=(TimelineCurTime-Keyframe[k].TLTime)/(Keyframe[NextK(k,m)].TLTime-Keyframe[k].TLTime);
        SetTrackBarPosition(m,Interpolate(t,
            Keyframe[PrevK(k,m)].posq[m].p,
            Keyframe[k].posq[m].p,
            Keyframe[NextK(k,m)].posq[m].p,
            Keyframe[NextK(NextK(k,m),m)].posq[m].p,
            k));
      end;
    end;
  end;
end;

procedure TForm1.tmrKeyframeTimer(Sender: TObject);
const b: single = 0;
begin
  if not Running then
    exit;
  if Sender = nil then
  begin
    b:=1000/dlgOptions.seCalculateFPS.value;
    if pnlRecordingMovie.Visible then
      SaveScreenShot('Mov',true);
    dlgEMA.ExportEMAStart;
    tmrKeyframe.enabled:=true;
  end else
  begin
    if not sbTimeline.Down then
      exit;
    if pnlRecordingMovie.Visible then
    begin
      SaveScreenShot('Mov',true);
      pbTimelinePaint(nil);
    end;
    TimelineCurTime:=IntRange(round(TimelineCurTime+b),0,MaxTime);
    IsAtKeyframe;
    LoadTrackbars;
    tmrKeyframe.enabled:=TimelineCurTime < MaxTime;
    sbTimeline.Down:=tmrKeyframe.enabled;
    if not tmrKeyframe.enabled then
      dlgEMA.ExportEMAFinish;
  end;
end;

procedure TForm1.Run;
begin
  if CurMode <> tiRun then
  begin
    tcMode.Tabindex:=ord(tiRun);
    tcModeChange(Self);
  end;
end;

procedure TForm1.Stop;
begin
  if CurMode <> tiEdit then
  begin
    tcMode.Tabindex:=ord(tiEdit);  
    tcModeChange(Self);
  end;
end;

function TForm1.Running: boolean;
begin
  result:=CurMode <> tiEdit;
end;

procedure TForm1.Objects1Click(Sender: TObject);
var a: TAtomRef;
    b: TStrutRef;
    i: integer;
begin
  Stop;
  i:=0;
  for a:=1 to NumAtoms do
  with Atoms[a] do
  if Selected then
  begin
    case Fixing of
      chStatic:  i:=i or 4;
      chSym:     i:=i or 8;
      else       i:=i or 2;
    end;
  end;

  Edit3.enabled:=StrutsSelectedCount > 0;

  muSubselectXlines.enabled:=StrutsSelectedCount > 0;
  muSubselectYlines.enabled:=StrutsSelectedCount > 0;
  muSubselectZlines.enabled:=StrutsSelectedCount > 0;
  muSubselectOther.enabled:=StrutsSelectedCount > 0;
  muCurrentmuscle.enabled:=StrutsSelectedCount > 0;
  muAnymuscle.enabled:=StrutsSelectedCount > 0;
  muDeselectXlines.enabled:=StrutsSelectedCount > 0;
  muDeselectYlines.enabled:=StrutsSelectedCount > 0;
  muDeselectZlines.enabled:=StrutsSelectedCount > 0;
  muDeselectOther.enabled:=StrutsSelectedCount > 0;
  muDeselectCurrentmuscle.enabled:=StrutsSelectedCount > 0;
  muDeselectAnymuscle.enabled:=StrutsSelectedCount > 0;

  Addtocurrentmuscle1.enabled:=(StrutsSelectedCount > 0) and InRange(CurMuscle,0,high(muscle));
  Removefromallmuscles1.enabled:=(StrutsSelectedCount > 0) and InRange(CurMuscle,0,high(muscle));
  Add1.enabled:=StrutsSelectedCount = 2;

  Mass1.enabled:=AtomsSelectedCount > 0;
  Fixing1.enabled:=AtomsSelectedCount > 0;
  Rigidbody1.enabled:=AtomsSelectedCount > 0;
//  Merge1.enabled:=AtomsSelectedCount > 1;

  Normal1.Checked:=i = 2;
  Static1.Checked:=i = 4;
  SymmetryAxes1.Checked:=i = 8;
end;

function TForm1.NewPolygon(a1,a2,a3,a4: TAtomRef; VisibleSide: single): integer;
begin
  setlength(Polygons,length(Polygons)+1);
  result:=high(Polygons);
  Polygons[result].a[1]:=a1;
  Polygons[result].a[2]:=a2;
  Polygons[result].a[3]:=a3;
  Polygons[result].a[4]:=a4;
  Polygons[result].VisibleSide:=VisibleSide;
  Polygons[result].Col:=$FFFFFF;
  Polygons[result].Area:=PolygonArea(result);
end;

{
function TForm1.NewPolyhedron(PosFace,NegFace: array of integer): integer;
var f: integer;
begin
  setlength(Polyhedron,length(Polyhedron)+1);
  result:=high(Polyhedron);

  setlength(Polyhedron[result].PosFace,length(PosFace));
  for f:=0 to high(PosFace) do
    Polyhedron[result].PosFace[f]:=PosFace[f];

  setlength(Polyhedron[result].NegFace,length(NegFace));
  for f:=0 to high(NegFace) do
    Polyhedron[result].NegFace[f]:=NegFace[f];

  Polyhedron[result].Volume:=PolyhedronVolume(result);
//  memo1.lines.add('NewPolyhedron='+FixedPointStr(Polyhedron[result].Volume,2));
end;
}

function TForm1.NewPolyhedron(PosFace,NegFace: array of integer): integer;
var f: integer;
begin
  setlength(Polyhedron,length(Polyhedron)+1);
  result:=high(Polyhedron);

  Polyhedron[result].PosFace:=nil;
  for f:=0 to high(PosFace) do
  if PosFace[f] >= 0 then
  begin
    setlength(Polyhedron[result].PosFace,length(Polyhedron[result].PosFace)+1);
    Polyhedron[result].PosFace[high(Polyhedron[result].PosFace)]:=PosFace[f];
  end;

  Polyhedron[result].NegFace:=nil;
  for f:=0 to high(NegFace) do
  if NegFace[f] >= 0 then
  begin
    setlength(Polyhedron[result].NegFace,length(Polyhedron[result].NegFace)+1);
    Polyhedron[result].NegFace[high(Polyhedron[result].NegFace)]:=NegFace[f];
  end;

  Polyhedron[result].Volume:=PolyhedronVolume(result);
//  memo1.lines.add('NewPolyhedron='+FixedPointStr(Polyhedron[result].Volume,2));
end;

function TForm1.NewTetrahedron(a1,a2,a3,a4: TAtomRef): integer;
var f: integer;
begin
  setlength(Tetrahedra,length(Tetrahedra)+1);
  result:=high(Tetrahedra);
  Tetrahedra[result].a[1]:=a1;
  Tetrahedra[result].a[2]:=a2;
  Tetrahedra[result].a[3]:=a3;
  Tetrahedra[result].a[4]:=a4;
  Tetrahedra[result].Volume:=TetrahedronVolume(result);
  if Tetrahedra[result].Volume < 0 then
  begin
    Tetrahedra[result].a[1]:=a2;
    Tetrahedra[result].a[2]:=a1;
    Tetrahedra[result].Volume:=TetrahedronVolume(result);
  end;
end;

function TForm1.CalcAllVolumes;
var ph: integer;
begin
  for ph:=0 to high(Polyhedron) do
    Polyhedron[ph].Volume:=PolyhedronVolume(ph);
end;

function TForm1.CalcAllAreas;
var pg: integer;
begin
  for pg:=0 to high(Polygons) do
    Polygons[pg].Area:=PolygonArea(pg);
end;

function TForm1.PolygonArea(pg: integer): single;
begin
  with Polygons[pg] do
  if a[1] > 0 then
  begin
    result:=AreaTriangle3D(Atoms[a[1]].p,Atoms[a[2]].p,Atoms[a[3]].p);
    if Polygons[pg].a[4] > 0 then
      result:=result+AreaTriangle3D(Atoms[a[1]].p,Atoms[a[3]].p,Atoms[a[4]].p);
  end;
end;

function TForm1.PolyhedronVolume(ph: integer): single;
  function PolygonVolume(pg: integer): single;
  var j: integer;
  begin
    result:=0;
    for j:=3 to high(Polygons[pg].a) do
      if Polygons[pg].a[j-0] > 0 then
        result:=result+TetrahedronVolumeP(Zero3DPoint,
          Atoms[Polygons[pg].a[j-2]].p,
          Atoms[Polygons[pg].a[j-1]].p,
          Atoms[Polygons[pg].a[j-0]].p);
  end;
  function PolygonVolume3(pg: integer): single;
  var i: integer;
      h: single;
  begin
    if Polygons[pg].a[4] = 0 then
    begin
      result:=0;
      h:=0;
      for i:=1 to 3 do
      begin
        result:=result+
          (Atoms[Polygons[pg].a[i mod 3+1]].p.x-Atoms[Polygons[pg].a[i]].p.x)*
          (Atoms[Polygons[pg].a[i mod 3+1]].p.y+Atoms[Polygons[pg].a[i]].p.y);
        h:=h+Atoms[Polygons[pg].a[i]].p.z;
      end;
      result:=h/3*result/2;
    end else
    begin
      result:=0;
      h:=0;
      for i:=1 to 4 do
      begin
        result:=result+
          (Atoms[Polygons[pg].a[i mod 4+1]].p.x-Atoms[Polygons[pg].a[i]].p.x)*
          (Atoms[Polygons[pg].a[i mod 4+1]].p.y+Atoms[Polygons[pg].a[i]].p.y);
        h:=h+Atoms[Polygons[pg].a[i]].p.z;
      end;
      result:=h/4*result/2;
    end;
  end;
var f: integer;
begin
  result:=0;

  for f:=0 to high(Polyhedron[ph].PosFace) do
    result:=result+PolygonVolume3(Polyhedron[ph].PosFace[f]);

  for f:=0 to high(Polyhedron[ph].NegFace) do
    result:=result-PolygonVolume3(Polyhedron[ph].NegFace[f]);
end;

function TForm1.TetrahedronVolume(th: integer): single;
begin
  with Tetrahedra[th] do
    result:=TetrahedronVolumeP(Atoms[a[1]].p,Atoms[a[2]].p,Atoms[a[3]].p,Atoms[a[4]].p);
{
randseed:=round(result);

  with Tetrahedra[th] do
    result:=TetrahedronVolumeP(Atoms[a[2]].p,Atoms[a[3]].p,Atoms[a[1]].p,Atoms[a[4]].p);
randseed:=round(result);

  with Tetrahedra[th] do
    result:=TetrahedronVolumeP(Atoms[a[3]].p,Atoms[a[4]].p,Atoms[a[1]].p,Atoms[a[2]].p);
randseed:=round(result);

  with Tetrahedra[th] do
    result:=TetrahedronVolumeP(Atoms[a[4]].p,Atoms[a[1]].p,Atoms[a[3]].p,Atoms[a[2]].p);
randseed:=round(result);
}
end;

procedure TForm1.temp;
var p1,p2,p3,p4,p5,p6: T3DPoint;
begin
exit;
  p1:=Zero3DPoint;
  p2:=a3DPoint(0,0,1);
  p3:=a3DPoint(0,1,0);
  p4:=a3DPoint(0,1,1);
  memo1.lines.add('AreaTriangle3D='+FixedPointStr(AreaTriangle3D(p1,p2,p3),4));
  memo1.lines.add('Area3D='+FixedPointStr(Area3D([p1,p2,p4,p3]),4));
  p1:=Zero3DPoint;
  p2:=a3DPoint(1,0,1);
  p3:=a3DPoint(0,1,1);
  p4:=a3DPoint(1,1,2);
  memo1.lines.add('Area3D='+FixedPointStr(Area3D([p1,p2,p4,p3]),4));
  p1:=Zero3DPoint;
  p2:=a3DPoint(2,0,2);
  p3:=a3DPoint(0,2,2);
  p4:=a3DPoint(2,2,4);
  memo1.lines.add('Area3D='+FixedPointStr(Area3D([p1,p2,p4,p3]),4));
  memo1.lines.add('AreaQuad3D='+FixedPointStr(AreaQuad3D(p1,p2,p4,p3),4));

exit;

  p1:=Zero3DPoint;
  p2:=a3DPoint(1,0,0);
  p3:=a3DPoint(0,1,0);
  p4:=a3DPoint(0,0,1);
  memo1.lines.add('vol='+FixedPointStr(TetrahedronVolumeP(p1,p2,p3,p4),4));

  SetNumAtoms(0);
  NewAtom(50+000,50+000,50+000,50+100); {1}
  NewAtom(50+000,50+100,50+000,50+100); {2}
  NewAtom(50+100,50+000,50+000,50+100); {3}
  NewAtom(50+100,50+100,50+000,50+100); {4}
  NewAtom(50+000,50+000,50+100,50+100); {5}
  NewAtom(50+000,50+100,50+100,50+100); {6}
  NewAtom(50+100,50+000,50+100,50+100); {7}
  NewAtom(50+100,50+100,50+100,50+100); {8}

  SetNumStruts(0);
  NewStrut(1,3,Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
  NewStrut(2,4,Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
  NewStrut(5,7,Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
  NewStrut(6,8,Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
  NewStrut(1,5,Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
  NewStrut(3,7,Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
  NewStrut(2,6,Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
  NewStrut(4,8,Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
  NewStrut(1,2,Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
  NewStrut(3,4,Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
  NewStrut(5,6,Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
  NewStrut(7,8,Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);

  Polygons:=nil;
  NewPolygon(1,2,6,5,0); {0}
  NewPolygon(1,3,4,2,0); {1}
  NewPolygon(1,5,7,3,0); {3}
  NewPolygon(8,6,2,4,0); {2}
  NewPolygon(8,7,5,6,0); {4}
  NewPolygon(8,4,3,7,0); {5}

  Polyhedron:=nil;
  NewPolyhedron([0,1,2,3,4,5],[]);

//  SetNumAtoms(0);
//  Polyhedron:=nil;
//  Polygons:=nil;
end;

procedure TForm1.DeletePolygon(pg: integer);
  procedure DeletePolyhedronsContainingPolygon(pg: integer);
    function PolygonInPolyhedron(pg: integer; ph: integer): boolean;
    var f: integer;
    begin
      result:=false;
      for f:=low(Polyhedron[ph].PosFace) to high(Polyhedron[ph].PosFace) do
        if Polyhedron[ph].PosFace[f] = pg then
          result:=true else
        if Polyhedron[ph].PosFace[f] > pg then
          dec(Polyhedron[ph].PosFace[f]);

      for f:=low(Polyhedron[ph].NegFace) to high(Polyhedron[ph].NegFace) do
        if Polyhedron[ph].NegFace[f] = pg then
          result:=true else
        if Polyhedron[ph].NegFace[f] > pg then
          dec(Polyhedron[ph].NegFace[f]);
    end;
  var ph: integer;
  begin
    for ph:=high(Polyhedron) downto 0 do
      if PolygonInPolyhedron(pg,ph) then
        DeletePolyhedron(ph);
  end;
var p: integer;
begin
  DeletePolyhedronsContainingPolygon(pg);
  for p:=pg to high(Polygons)-1 do
    Polygons[p]:=Polygons[p+1];
  setlength(Polygons,Length(Polygons)-1);
end;

procedure TForm1.DeletePolyhedron(ph: integer);
var p: integer;
begin
  for p:=ph to high(Polyhedron)-1 do
    Polyhedron[p]:=Polyhedron[p+1];
  setlength(Polyhedron,Length(Polyhedron)-1);
end;

procedure TForm1.Add1Click(Sender: TObject);
var b1,b2,b: TStrutRef;
begin
  SetUndo;
  Modified:=true;

  b1:=0;
  b2:=0;
  for b:=1 to NumStruts do
    with Struts[b] do
      if StrutSelected(b) then
      begin
        b1:=b2;
        b2:=b;
      end;
  if b1 = 0 then
    exit;
  if Struts[b1].Atom1 = Struts[b2].Atom1 then
    NewPolygon(Struts[b1].Atom1,Struts[b1].Atom2,Struts[b2].Atom2,0,0) else
  if Struts[b1].Atom2 = Struts[b2].Atom1 then
    NewPolygon(Struts[b1].Atom2,Struts[b1].Atom1,Struts[b2].Atom2,0,0) else
  if Struts[b1].Atom1 = Struts[b2].Atom2 then
    NewPolygon(Struts[b1].Atom1,Struts[b1].Atom2,Struts[b2].Atom1,0,0) else
  if Struts[b1].Atom2 = Struts[b2].Atom2 then
    NewPolygon(Struts[b1].Atom2,Struts[b1].Atom1,Struts[b2].Atom1,0,0) else
  if Struts[b1].Atom2 = Struts[b2].Atom2 then
    NewPolygon(Struts[b1].Atom2,Struts[b1].Atom1,Struts[b2].Atom1,0,0) else
  if DotProduct3D(Sub3D(Atoms[Struts[b1].Atom1].p,Atoms[Struts[b1].Atom2].p),Sub3D(Atoms[Struts[b2].Atom1].p,Atoms[Struts[b2].Atom2].p)) < 0 then
    NewPolygon(Struts[b1].Atom1,Struts[b1].Atom2,Struts[b2].Atom1,Struts[b2].Atom2,0) else
    NewPolygon(Struts[b1].Atom2,Struts[b1].Atom1,Struts[b2].Atom1,Struts[b2].Atom2,0);
  if not YesNoBox('Polgon visible from both sides?') then
    CalcVisibility(high(Polygons));

ChkPoly;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.Remove1Click(Sender: TObject);
  function AtomInPolygon(a: TAtomRef; pg: integer): boolean;
  var e: integer;
  begin
    result:=true;
    for e:=low(Polygons[pg].a) to high(Polygons[pg].a) do
      if Polygons[pg].a[e] = a then
        exit;
    result:=false;
  end;
var b: TStrutRef;
var pg: integer;
begin
  SetUndo;
  Modified:=true;

  for b:=1 to NumStruts do
  with Struts[b] do
  if StrutSelected(b) then
  begin
    for pg:=high(Polygons) downto 0 do
      if AtomInPolygon(Struts[b].Atom1,pg) and AtomInPolygon(Struts[b].Atom2,pg) then
        DeletePolygon(pg);
  end;
ChkPoly;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.CalcVisibility(pg: integer);
begin
  if Polygons[pg].a[4] = 0 then
    Polygons[pg].VisibleSide:=
              AreaSingle([
                Proj2D(Atoms[Polygons[pg].a[1]].p,pl3D),
                Proj2D(Atoms[Polygons[pg].a[2]].p,pl3D),
                Proj2D(Atoms[Polygons[pg].a[3]].p,pl3D)]) else
    Polygons[pg].VisibleSide:=
              AreaSingle([
                Proj2D(Atoms[Polygons[pg].a[1]].p,pl3D),
                Proj2D(Atoms[Polygons[pg].a[2]].p,pl3D),
                Proj2D(Atoms[Polygons[pg].a[3]].p,pl3D),
                Proj2D(Atoms[Polygons[pg].a[4]].p,pl3D)]);
end;

procedure TForm1.SaveScreenShot(name: string; {PhotoFormat: TPhotoFormat; }AddNumber: boolean);
const n: integer = 1;
  procedure Findname(ext: string);
  begin
    while FileExists(ChangeToExePath(name+inttostr(n)+ext)) do
      inc(n);
    if AddNumber then
      name:=name+inttostr(n);
    name:=ChangeToExePath(name+ext);
  end;
  procedure SaveBMP(Image: TImage);
  begin
    Findname('.bmp');
    Image.Picture.SaveToFile(name);
    dlgMovie.MovieBMPs.Add(name);
  end;
  procedure SaveGIF(Image: TImage);
  var GIF1:TGifBitmap;
  begin
    GIF1:=TGifBitmap.Create;
    try
      Findname('.gif');
      GIF1.Width:=Image.Picture.Graphic.Width;
      GIF1.Height:=Image.Picture.Graphic.Height;
      GIF1.Canvas.Draw(0,0,Image.Picture.Graphic);
//       GIF1.Assign(Image1.Picture.Graphic);
      GIF1.SaveToFile(name);
      dlgMovie.MovieBMPs.Add(name);
    finally
      GIF1.Free;
    end;
  end;
{
  procedure SaveJPG(Image: TImage);
  var fStream: TFileStream;
      JPEGImage: TMyJPEGImage;
  begin
    try
      Findname('.jpg');
      fStream:=TFileStream.Create(name, fmCreate);
      JPEGImage:=TMyJPEGImage.Create;
      with JPEGImage do
      begin
        JPEGImage.Assign(Image.Picture.Graphic);
        Compress;
        SaveToStream(fStream);
      end;
    finally
      JPEGImage.Free;
      fStream.Free;
    end;
  end;
}
var Image: TImage;
    x,y: integer;
    pix: TPix;
begin
  Image:=TImage.Create(Self);
  if MovieXY1.Checked then Image.Picture.Assign(imgXY.Picture) else
  if MovieXZ1.Checked then Image.Picture.Assign(imgXZ.Picture) else
  if MovieYZ1.Checked then Image.Picture.Assign(imgYZ.Picture) else
                           Image.Picture.Assign(img3D.Picture); 
  SaveGIF(Image);

  Image.Free;

  dlgEMA.ExportEMAFrame;
end;

procedure TForm1.Colour1Click(Sender: TObject);
  function AtomInPolygon(a: TAtomRef; pg: integer): boolean;
  var e: integer;
  begin
    result:=true;
    for e:=low(Polygons[pg].a) to high(Polygons[pg].a) do
      if Polygons[pg].a[e] = a then
        exit;
    result:=false;
  end;
var b: TStrutRef;
    pg: integer;
    first: boolean;
begin
  SetUndo;
  Modified:=true;
  first:=true;

  for b:=1 to NumStruts do
  with Struts[b] do
    if StrutSelected(b) then
        for pg:=high(Polygons) downto 0 do
          if AtomInPolygon(Struts[b].Atom1,pg) and AtomInPolygon(Struts[b].Atom2,pg) then
          if not Atoms[Struts[b].Atom1].neglect and not Atoms[Struts[b].Atom2].neglect then
          begin
            if first then
            begin
              first:=false;
              ColorDialog1.Color:=Polygons[pg].Col;
              if not ColorDialog1.Execute then
                exit;
            end;
            Polygons[pg].Col:=ColorDialog1.color;
          end;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.ImportImages1Click(Sender: TObject);
begin
  dlgImportImages.ShowModal;
end;

procedure TForm1.PixsIndexChange;
begin
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.ShowAtomNums1Click(Sender: TObject);
begin
  TMenuItem(Sender).Checked:=not TMenuItem(Sender).Checked;
  InvalidateAll;
ChkPoly;
end;

function TForm1.uPixsCoord(Axes: TAxes): integer;
var i: integer;
begin
  result:=-100;
  i:=round(SectionRect(Axes).Left+(SectionRect(Axes).Right-SectionRect(Axes).Left)*PixsIndex);
  case Axes of
    plXY: if CurSection = plYZ then result:=i;
    plXZ: if CurSection = plYZ then result:=i;
    plYZ: if CurSection = plXZ then result:=i;
  end;
end;

function TForm1.vPixsCoord(Axes: TAxes): integer;
var i: integer;
begin
  result:=-100;
  i:=round(SectionRect(Axes).Top + (SectionRect(Axes).Bottom-SectionRect(Axes).Top)*(1-PixsIndex));
  case Axes of
    plXY: if CurSection = plXZ then result:=i;
    plXZ: if CurSection = plXY then result:=i;
    plYZ: if CurSection = plXY then result:=i;
  end;
end;

function TForm1.uPixsCoordZoom(Axes: TAxes): integer;
var i: integer;
begin
  result:=-100;
  i:=round(SectionRect(Axes).Left+(SectionRect(Axes).Right-SectionRect(Axes).Left)*PixsIndex);
  case Axes of
    plXY: if CurSection = plYZ then result:=ZoomScroll(i,i,Axes).x;
    plXZ: if CurSection = plYZ then result:=ZoomScroll(i,i,Axes).x;
    plYZ: if CurSection = plXZ then result:=ZoomScroll(i,i,Axes).x;
  end;
end;

function TForm1.vPixsCoordZoom(Axes: TAxes): integer;
var i: integer;
begin
  result:=-100;
  i:=round(SectionRect(Axes).Top + (SectionRect(Axes).Bottom-SectionRect(Axes).Top)*(1-PixsIndex));
  case Axes of
    plXY: if CurSection = plXZ then result:=ZoomScroll(i,i,Axes).y;
    plXZ: if CurSection = plXY then result:=ZoomScroll(i,i,Axes).y;
    plYZ: if CurSection = plXY then result:=ZoomScroll(i,i,Axes).y;
  end;
end;

procedure TForm1.XZSection1Click(Sender: TObject);
begin
  CurSection:=TAxes(TMenuItem(Sender).Tag mod 10);
  ShowSectionJPG:=TMenuItem(Sender).Tag >= 10;
  InvalidateAll;
ChkPoly;
end;

function TForm1.SectionRect(Axes: TAxes): TRect;
var bmpXY,bmpXZ,bmpYZ: TBitmap;
begin
  if CurMode = tiEdit then
  begin
    bmpXZ:=bmpBGXZe;
    bmpXY:=bmpBGXYe;
    bmpYZ:=bmpBGYZe;
  end else
  begin
    bmpXZ:=bmpBGXZr;
    bmpXY:=bmpBGXYr;
    bmpYZ:=bmpBGYZr;
  end;

  if ShowSectionJPG then
  begin
    result:=Rect(0,0,1,1);
    if (dlgImportImages <> nil) and (length(dlgImportImages.Pixs) > 0) then
    case Axes of
      plXZ: result:=Rect((pbXZ.Width-length(dlgImportImages.Pixs)) div 2,pbXZ.Height-dlgImportImages.Pixs[0].Height,(pbXZ.Width-length(dlgImportImages.Pixs)) div 2+length(dlgImportImages.Pixs),pbXZ.Height);
      plXY: result:=Rect((pbXY.Width-length(dlgImportImages.Pixs)) div 2,(pbXY.Height-dlgImportImages.Pixs[0].Width) div 2,(pbXY.Width-length(dlgImportImages.Pixs)) div 2+length(dlgImportImages.Pixs),(pbXY.Height-dlgImportImages.Pixs[0].Width) div 2 + dlgImportImages.Pixs[0].Width);
      plYZ: result:=Rect((pbYZ.width-dlgImportImages.Pixs[0].Width) div 2,pbYZ.Height-dlgImportImages.Pixs[0].Height,(pbYZ.width-dlgImportImages.Pixs[0].Width) div 2+dlgImportImages.Pixs[0].Width,pbYZ.Height);
    end else
    case Axes of
      plXZ: if bmpXZ.Width > 0 then result:=Rect((pbXZ.Width-bmpXZ.Width) div 2,pbXZ.Height-dlgImportImages.Pixs[0].Height,(pbXZ.Width-bmpXZ.Width) div 2+bmpXZ.Width,pbXZ.Height);
      plXY: if bmpXZ.Width > 0 then result:=Rect((pbXY.Width-bmpXY.Width) div 2,(pbXY.Height-bmpXY.Height) div 2,(pbXY.Width-bmpXY.Width) div 2+bmpXY.Width,(pbXY.Height-bmpXY.Height) div 2 + bmpXY.Height);
      plYZ: if bmpYZ.Width > 0 then result:=Rect((pbYZ.width-bmpXY.Width) div 2,pbYZ.Height-bmpXY.Height,(pbYZ.width-bmpXY.Width) div 2+bmpXY.Width,pbYZ.Height);
    end;
  end else
  begin
    case Axes of
      plXZ: if bmpXZ.Width > 0 then
              result:=Rect(
                (pbXZ.Width-bmpXZ.Width) div 2,
                pbXZ.Height-bmpXZ.Height,
                (pbXZ.Width-bmpXZ.Width) div 2+bmpXZ.Width,
                pbXZ.Height) else
              result:=Rect(
                (pbXZ.Width-1000) div 2,
                pbXZ.Height-1000,
                (pbXZ.Width-1000) div 2+1000,
                pbXZ.Height);


      plXY: if bmpXY.Width > 0 then
              result:=Rect(
                (pbXY.Width-bmpXY.Width) div 2,
                (pbXY.Height-bmpXY.Height) div 2,
                (pbXY.Width-bmpXY.Width) div 2+bmpXY.Width,
                (pbXY.Height-bmpXY.Height) div 2 + bmpXY.Height) else
              result:=Rect(
                (pbXY.Width-1000) div 2,
                (pbXY.Height-1000) div 2,
                (pbXY.Width-1000) div 2+1000,
                (pbXY.Height-1000) div 2 + 1000);

      plYZ: if bmpYZ.Width > 0 then
              result:=Rect(
                (pbYZ.width-bmpYZ.Width) div 2,
                pbYZ.Height-bmpYZ.Height,
                (pbYZ.width-bmpYZ.Width) div 2+bmpYZ.Width,
                pbYZ.Height) else
              result:=Rect(
                (pbYZ.width-1000) div 2,
                pbYZ.Height-1000,
                (pbYZ.width-1000) div 2+1000,
                pbYZ.Height);
    end;
  end;
end;

function TForm1.GetYZPixImage(i: single): TPix;
begin
  result:=dlgImportImages.Pixs[round(i*high(dlgImportImages.Pixs))];
end;

function TForm1.GetXYPixImage(i: single): TPix;
  function GetPix(x,y,z: integer): TColor;
  begin
    result:=Pixel(dlgImportImages.Pixs[x],y,z);
  end;
var u,v: integer;
const Pix: TPix = (Width:0);
const prev: integer = -1;
begin
  if i <> prev then
  begin
    Pix:=PixSetSize(length(dlgImportImages.Pixs),dlgImportImages.Pixs[0].width,cgRGB);
    for u:=0 to Pix.width-1 do
      for v:=0 to Pix.height-1 do
        PixSetPixelChannel(Pix,u,v,GetPix(u,Pix.height-1-v,round((1-i)*dlgImportImages.Pixs[0].Height)));
  end;
  result:=Pix;
end;

function TForm1.GetXZPixImage(i: single): TPix;
  function GetPix(x,y,z: integer): TColor;
  begin
    result:=Pixel(dlgImportImages.Pixs[x],y,z);
  end;
var u,v: integer;
const Pix: TPix = (Width:0);
const prev: integer = -1;
begin
  if i <> prev then
  begin
    Pix:=PixSetSize(length(dlgImportImages.Pixs),dlgImportImages.Pixs[0].Height,cgRGB);
    for u:=0 to Pix.width-1 do
      for v:=0 to Pix.height-1 do
        PixSetPixelChannel(Pix,u,v,GetPix(u,round(i*dlgImportImages.Pixs[0].width),v));
  end;
  result:=Pix;
end;

procedure TForm1.View1Click(Sender: TObject);
begin
  NoSection1.Checked:=(CurSection = pl3D);
  XYSection1.Checked:=(CurSection = plXY) and ShowSectionJPG;
  XZSection1.Checked:=(CurSection = plXZ) and ShowSectionJPG;
  YZSection1.Checked:=(CurSection = plYZ) and ShowSectionJPG;
  XYSection2.Checked:=(CurSection = plXY) and not ShowSectionJPG;
  XZSection2.Checked:=(CurSection = plXZ) and not ShowSectionJPG;
  YZSection2.Checked:=(CurSection = plYZ) and not ShowSectionJPG;
  JPEGSection1.Checked:=(CurSection in [plXY,plXZ,plYZ]) and ShowSectionJPG;
  BlankSection1.Checked:=(CurSection in [plXY,plXZ,plYZ]) and not ShowSectionJPG;
  MuscleChart1.Checked:=pnlMuscleChart.Visible;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if TSpeedButton(Sender).down then
  begin
    SpeedButton1.Down:=SpeedButton1 = Sender;
    SpeedButton2.Down:=SpeedButton2 = Sender;
    SpeedButton3.Down:=SpeedButton3 = Sender;
    CurSection:=TAxes(TSpeedButton(Sender).Tag);
  end else
    CurSection:=pl3D;
  InvalidateAll;
ChkPoly;
end;

function TForm1.XSectionCoord: single;
begin
  if (CurSection <> pl3D) and not ShowSectionJPG then
    result:=1000*PixsIndex-1000/2 else
  if (CurSection <> pl3D) and (dlgImportImages <> nil) then
    result:=length(dlgImportImages.Pixs)*PixsIndex-length( dlgImportImages.Pixs)/2 else
    result:=0;
end;

function TForm1.YSectionCoord: single;
begin
  if (CurSection <> pl3D) and not ShowSectionJPG then
    result:=1000*PixsIndex- 1000/2 else
  if (CurSection <> pl3D) and (dlgImportImages <> nil) then
    result:=dlgImportImages.Pixs[0].Width*PixsIndex- dlgImportImages.Pixs[0].Width/2 else
    result:=0;
end;

function TForm1.ZSectionCoord: single;
begin
  if (CurSection <> pl3D) and not ShowSectionJPG then
    result:=1000* PixsIndex else
  if (CurSection <> pl3D) and (dlgImportImages <> nil) then
    result:=dlgImportImages.Pixs[0].Height* PixsIndex else
    result:=0;
end;

procedure TForm1.muSubselectXlinesClick(Sender: TObject);
var b: TStrutRef;
var a: TAtomRef;
begin
  for b:=1 to NumStruts do
    with Struts[b] do
      Selected:=StrutSelected(b) and (Axis = axX);
  for a:=1 to NumAtoms do
    Atoms[a].Selected:=false;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.muSubselectYlinesClick(Sender: TObject);
var b: TStrutRef;
var a: TAtomRef;
begin
  for b:=1 to NumStruts do
    with Struts[b] do
      Selected:=StrutSelected(b) and (Axis = axY);
  for a:=1 to NumAtoms do
    Atoms[a].Selected:=false;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.muSubselectZlinesClick(Sender: TObject);
var b: TStrutRef;
var a: TAtomRef;
begin
  for b:=1 to NumStruts do
    with Struts[b] do
      Selected:=StrutSelected(b) and (Axis = axZ);
  for a:=1 to NumAtoms do
    Atoms[a].Selected:=false;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.muSubselectOtherClick(Sender: TObject);
var b: TStrutRef;
var a: TAtomRef;
begin
  for b:=1 to NumStruts do
    with Struts[b] do
      Selected:=StrutSelected(b) and (Axis <> axX) and (Axis <> axY) and (Axis <> axZ);
  for a:=1 to NumAtoms do
    Atoms[a].Selected:=false;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.muCurrentmuscleClick(Sender: TObject);
var b: TStrutRef;
var a: TAtomRef;
begin
  for b:=1 to NumStruts do
    with Struts[b] do
      Selected:=StrutSelected(b) and (musc = CurMuscle);
  for a:=1 to NumAtoms do
    Atoms[a].Selected:=false;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.muAnymuscleClick(Sender: TObject);
var b: TStrutRef;
var a: TAtomRef;
begin
  for b:=1 to NumStruts do
    with Struts[b] do
      Selected:=StrutSelected(b) and (musc >= 0);
  for a:=1 to NumAtoms do
    Atoms[a].Selected:=false;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.muDeselectXlinesClick(Sender: TObject);
var b: TStrutRef;
begin
  for b:=1 to NumStruts do
    with Struts[b] do
      Selected:=StrutSelected(b) and not (Axis = axX);
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.muDeselectYlinesClick(Sender: TObject);
var b: TStrutRef;
begin
  for b:=1 to NumStruts do
    with Struts[b] do
      Selected:=StrutSelected(b) and not (Axis = axY);
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.muDeselectZlinesClick(Sender: TObject);
var b: TStrutRef;
begin
  for b:=1 to NumStruts do
    with Struts[b] do
      Selected:=StrutSelected(b) and not (Axis = axY);
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.muDeselectOtherClick(Sender: TObject);
var b: TStrutRef;
begin
  for b:=1 to NumStruts do
    with Struts[b] do
      Selected:=StrutSelected(b) and not((Axis <> axX) and (Axis <> axY) and (Axis <> axZ));
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.muDeselectCurrentmuscleClick(Sender: TObject);
var b: TStrutRef;
begin
  if length(muscle) = 0 then
    exit;

  for b:=1 to NumStruts do
    with Struts[b] do
      if musc = CurMuscle then
        Selected:=false;

  InvalidateAll;
ChkPoly;
end;

procedure TForm1.muDeselectAnymuscleClick(Sender: TObject);
var b: TStrutRef;
begin
  if length(muscle) = 0 then
    exit;

  for b:=1 to NumStruts do
    with Struts[b] do
      if musc >= 0 then
        Selected:=false;

  InvalidateAll;
ChkPoly;
end;

procedure TForm1.ExtendAtomslines(aAxis: TAxis);
  procedure Extend(a: TAtomNum);
  var b: TStrutRef;
  begin
    for b:=1 to NumStruts do
      with Struts[b] do
        if Axis = aAxis then
        begin
          if (Atom1 = a) and not Atoms[Atom2].Selected then
          begin
            Atoms[Atom2].Selected:=not Atoms[Atom2].neglect;
            IF Atoms[Atom2].Selected THEN Extend(Atom2);         //IF THEN ADDED AAW 270815
          end else
          if (Atom2 = a) and not Atoms[Atom1].Selected then
          begin
            Atoms[Atom1].Selected:=not Atoms[Atom1].neglect;
            IF Atoms[Atom1].Selected THEN Extend(Atom1);         //IF THEN ADDED AAW 270815
          end;
        end;
  end;
var a: TAtomRef;
begin
  for a:=1 to NumAtoms do
    if Atoms[a].Selected then
      Extend(a);
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.muExtendAtomsXlinesClick(Sender: TObject);
begin
  ExtendAtomslines(axX);
end;

procedure TForm1.muExtendAtomsYlinesClick(Sender: TObject);
begin
  ExtendAtomslines(axY);
end;

procedure TForm1.muExtendAtomsZlinesClick(Sender: TObject);
begin
  ExtendAtomslines(axZ);
end;

procedure TForm1.ExtendStrutslines(aAxis: TAxis);
  procedure ExtendOnAxis(a: TAtomNum);
  var b: TStrutRef;
  begin
    for b:=1 to NumStruts do
      with Struts[b] do
        if not Selected then
        if Axis = aAxis then
        if (Atom1 = a) or (Atom2 = a) then
        begin
          Selected:=true;
          ExtendOnAxis(Atom1);
          ExtendOnAxis(Atom2);
        end;
  end;
  procedure ExtendOffAxis(b1: TStrutRef);
  var b2,b3,b4: TStrutRef;
      a1,a2: TAtomNum;
  begin
    Struts[b1].Selected:=true;
    for a1:=1 to NumAtoms do
    for a2:=1 to NumAtoms do
    begin
      b2:=FindStrut(Struts[b1].Atom1,a1);
      b3:=FindStrut(Struts[b1].Atom2,a2);
      b4:=FindStrut(a1,a2);
      if (b2 <> 0) and
         (b3 <> 0) and
         (b4 <> 0) and
         (Struts[b2].Axis = aAxis) and
         (Struts[b3].Axis = aAxis) and
         (Struts[b4].Axis <> aAxis) and
         not Struts[b4].Selected then
       ExtendOffAxis(b4);
    end;
  end;
var b: TStrutRef;
begin
  for b:=1 to NumStruts do
    with Struts[b] do
     if Selected then
        if Axis = aAxis then
        begin
          ExtendOnAxis(Atom1);
          ExtendOnAxis(Atom2);
        end else
          ExtendOffAxis(b);
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.muExtendStrutsXlinesClick(Sender: TObject);
begin
  ExtendStrutslines(axX);
end;

procedure TForm1.muExtendStrutsYlinesClick(Sender: TObject);
begin
  ExtendStrutslines(axY);
end;

procedure TForm1.muExtendStrutsZlinesClick(Sender: TObject);
begin
  ExtendStrutslines(axZ);
end;

procedure TForm1.Atoms1Click(Sender: TObject);
var b: TStrutRef;
begin
  for b:=1 to NumStruts do
    Struts[b].Selected:=false;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.Struts2Click(Sender: TObject);
var a: TAtomRef;
begin
  for a:=1 to NumAtoms do
    Atoms[a].Selected:=false;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.ToAtoms1Click(Sender: TObject);
var b: TStrutRef;
begin
  for b:=1 to NumStruts do
    with Struts[b] do
     if Selected then
     begin
       Atoms[Atom1].Selected:=not Atoms[Atom1].neglect;
       Atoms[Atom2].Selected:=not Atoms[Atom2].neglect;
     end;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.ToStruts1Click(Sender: TObject);
var b: TStrutRef;
begin
  for b:=1 to NumStruts do
    with Struts[b] do
     if Atoms[Atom1].Selected and Atoms[Atom2].Selected then
       Selected:=true;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.ToAllStruts1Click(Sender: TObject);
var b: TStrutRef;
begin
  for b:=1 to NumStruts do
    with Struts[b] do
     if Atoms[Atom1].Selected or Atoms[Atom2].Selected then
       Selected:=true;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.Sectiontobackground1Click(Sender: TObject);
begin
  bmpBGXYe.Width:=0; bmpBGXYr.Width:=0;
  bmpBGXZe.Width:=0; bmpBGXZr.Width:=0;
  bmpBGYZe.Width:=0; bmpBGYZr.Width:=0;

  if ShowSectionJPG then
  begin
    case CurSection of
      plXY: begin SetImg(bmpBGXYe,GetXYPixImage(PixsIndex),true); SetImg(bmpBGXYr,GetXYPixImage(PixsIndex),true); end;
      plXZ: begin SetImg(bmpBGXZe,GetXZPixImage(PixsIndex),true); SetImg(bmpBGXZr,GetXZPixImage(PixsIndex),true); end;
      plYZ: begin SetImg(bmpBGYZe,GetYZPixImage(PixsIndex),true); SetImg(bmpBGYZr,GetYZPixImage(PixsIndex),true); end;
    end;
  end;

  CurSection:=pl3D;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.CloseSelected1Click(Sender: TObject);
  procedure MergeStruts(b1,b2: TStrutRef);
    procedure CopyStrut(b1,b2: TStrutRef);
    begin
      Struts[b2].StrutName:=Struts[b1].StrutName;
      Struts[b2].musc:=Struts[b1].musc;
      Struts[b2].Coeff:=Struts[b1].Coeff;
      Struts[b2].ElasticityR:=Struts[b1].ElasticityR;
      Struts[b2].ElasticityC:=Struts[b1].ElasticityC;
      Struts[b2].Axis:=Struts[b1].Axis;
      Struts[b2].Color:=Struts[b1].Color;
      Struts[b2].PenWidth:=Struts[b1].PenWidth;
    end;
  begin
    if (Struts[b2].musc < 0) and (Struts[b1].musc >= 0) then
      CopyStrut(b1,b2) else
    if (Struts[b2].musc >= 0) and (Struts[b1].musc < 0) then
    begin
    end else
    if (Struts[b2].Axis = axNone) then
      CopyStrut(b1,b2);
    DeleteStrut(b1);
  end;
var a1,a2: TAtomRef;
    b: TStrutRef;
    pg,e,f,i,n: integer;
    ph: integer;
    AtomBoolArray: TAtomBoolArray;
    p: T3DPoint;
begin
  try
    Screen.Cursor:=crHourglass;
    fillchar(AtomBoolArray,sizeof(AtomBoolArray),0);

    for a1:=1 to NumAtoms do
    if not Atoms[a1].neglect then
    if Atoms[a1].Selected or (Sender = Allclose1) then
    begin
      n:=1;
      p:=Atoms[a1].p;
      for a2:=a1+1 to NumAtoms do
      if not Atoms[a2].neglect then
      if Atoms[a2].Selected or (Sender = Allclose1) then
      begin
        inc(n);
        p:=Add3D(p,Atoms[a2].p);
      end;

      for a2:=a1+1 to NumAtoms do
      if not Atoms[a2].neglect then
      if (Atoms[a2].Selected or (Sender = Allclose1)) and ((Distance(a1,a2) < MinRestLength) or (Sender = AllSelected1)) then
      begin
        if Sender = AllSelected1 then
          Atoms[a1].p:=Scale3D(p,1/n);
      
        for b:=NumStruts downto 1 do
        with Struts[b] do
        if not Atoms[Atom1].neglect and not Atoms[Atom2].neglect then
        begin
          if Atom1 = a2 then
          begin
            if findStrut(Atom2,a1) > 0 then
              MergeStruts(b,findStrut(Atom2,a1)) else
              Atom1:=a1;
          end else
          if Atom2 = a2 then
          begin
            if findStrut(Atom1,a1) > 0 then
              MergeStruts(b,findStrut(Atom1,a1)) else
              Atom2:=a1;
          end;
          if Atom1 = Atom2 then
            DeleteStrut(b);
        end;

        for pg:=0 to high(Polygons) do
          for e:=low(Polygons[pg].a) to high(Polygons[pg].a) do
            if Polygons[pg].a[e] = a2 then
              Polygons[pg].a[e]:=a1;

        AtomBoolArray[a2]:=true;
      end;
    end;

    DeleteAtoms(AtomBoolArray);
    CheckClearSym;

    for pg:=high(Polygons) downto 0 do
    begin
      for e:=high(Polygons[pg].a) downto low(Polygons[pg].a) do
        if (Polygons[pg].a[e] = Polygons[pg].a[e mod 4 +1]) then
        begin
          for f:=e to high(Polygons[pg].a)-1 do
            Polygons[pg].a[f]:=Polygons[pg].a[f+1];
          Polygons[pg].a[high(Polygons[pg].a)]:=0;
        end;
      if Polygons[pg].a[3] = 0 then
        DeletePolygon(pg);
    end;
    FixSymmetryAtoms;
  ChkPoly;
  finally
    Screen.Cursor:=crDefault;
  end;
end;

procedure TForm1.Rename1Click(Sender: TObject);
begin
  with muscle[puMuscles.PopupComponent.Tag].Label1 do
    Caption:=InputBox('GGSim3D','Muscle name',Before(Caption,'='))+'=100%';
  Modified:=true;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.MakeConstraintsSymmetrical;
var a1,a2,a3: TAtomRef;
    p,d,t,r: T3DPoint;
    n,i,j: integer;
    s: single;
    AtomBoolArray: TAtomBoolArray;
begin
  s:=1;
  case SymmetryAxes of
    plYZ:
      begin
        for i:=-RoofN[raZPos] to RoofN[raZPos] do
          for j:=-RoofN[raZPos] to RoofN[raZPos] do
            if (i*RoofMeshsize[raZPos]-SymmetryCoord)*s < 0 then
              Roof[raZPos,i,j].h:=Roof[raZPos,IntRange(round(2*SymmetryCoord/RoofMeshsize[raZPos]-i),-RoofN[raZPos],RoofN[raZPos]),j].h;
        for i:=-RoofN[raZNeg] to RoofN[raZNeg] do
          for j:=-RoofN[raZNeg] to RoofN[raZNeg] do
            if (i*RoofMeshsize[raZNeg]-SymmetryCoord)*s < 0 then
              Roof[raZNeg,i,j].h:=Roof[raZNeg,IntRange(round(2*SymmetryCoord/RoofMeshsize[raZNeg]-i),-RoofN[raZNeg],RoofN[raZNeg]),j].h;
        for i:=-RoofN[raYPos] to RoofN[raYPos] do
          for j:=-RoofN[raYPos] to RoofN[raYPos] do
            if (i*RoofMeshsize[raYPos]-SymmetryCoord)*s < 0 then
              Roof[raYPos,i,j].h:=Roof[raYPos,IntRange(round(2*SymmetryCoord/RoofMeshsize[raYPos]-i),-RoofN[raYPos],RoofN[raYPos]),j].h;
        for i:=-RoofN[raYNeg] to RoofN[raYNeg] do
          for j:=-RoofN[raYNeg] to RoofN[raYNeg] do
            if (i*RoofMeshsize[raYNeg]-SymmetryCoord)*s < 0 then
              Roof[raYNeg,i,j].h:=Roof[raYNeg,IntRange(round(2*SymmetryCoord/RoofMeshsize[raYNeg]-i),-RoofN[raYNeg],RoofN[raYNeg]),j].h;
      end;
    plXZ:
      begin
        for i:=-RoofN[raZPos] to RoofN[raZPos] do
          for j:=-RoofN[raZPos] to RoofN[raZPos] do
            if (j*RoofMeshsize[raZPos]-SymmetryCoord)*s < 0 then
              Roof[raZPos,i,j].h:=Roof[raZPos,i,IntRange(round(2*SymmetryCoord/RoofMeshsize[raZPos]-j),-RoofN[raZPos],RoofN[raZPos])].h;
        for i:=-RoofN[raZNeg] to RoofN[raZNeg] do
          for j:=-RoofN[raZNeg] to RoofN[raZNeg] do
            if (j*RoofMeshsize[raZNeg]-SymmetryCoord)*s < 0 then
              Roof[raZNeg,i,j].h:=Roof[raZNeg,i,IntRange(round(2*SymmetryCoord/RoofMeshsize[raZNeg]-j),-RoofN[raZNeg],RoofN[raZNeg])].h;
        for i:=-RoofN[raXNeg] to RoofN[raXNeg] do
          for j:=-RoofN[raXNeg] to RoofN[raXNeg] do
            if (i*RoofMeshsize[raXNeg]-SymmetryCoord)*s < 0 then
              Roof[raXNeg,i,j].h:=Roof[raXNeg,IntRange(round(2*SymmetryCoord/RoofMeshsize[raXNeg]-i),-RoofN[raXNeg],RoofN[raXNeg]),j].h;
      end;
  end;
end;

procedure TForm1.SymmetryAxes1Click(Sender: TObject);
var a1,a2,a3: TAtomRef;
    p,d,t,r: T3DPoint;
    n,i,j: integer;
    s: single;
    AtomBoolArray: TAtomBoolArray;
begin
  SetUndo;
  Modified:=true;

  if SymmetryAxes = pl3D then
  begin
    d:=Zero3DPoint;
    t:=Zero3DPoint;
    r:=Zero3DPoint;
    n:=0;

    for a1:=1 to NumAtoms do
    begin
      r:=Add3D(r,Atoms[a1].p);
      if Atoms[a1].Selected then
      begin
        inc(n);
        t:=Add3D(t,Atoms[a1].p);
        for a2:=a1+1 to NumAtoms do
        if Atoms[a2].Selected then
        for a3:=a2+1 to NumAtoms do
        if Atoms[a3].Selected then
        begin
          p:=CrossProduct3D(Sub3D(Atoms[a2].p,Atoms[a1].p),Sub3D(Atoms[a3].p,Atoms[a1].p));
          if DotProduct3D(p,d) >= 0 then
            d:=Add3D(d,p) else
            d:=Sub3D(d,p);
        end;
      end;
    end;

    if n = 0 then
      exit;

    fillchar(AtomBoolArray,sizeof(AtomBoolArray),0);
    if (abs(d.x) >= abs(d.y)) and (abs(d.x) >= abs(d.z)) then
    begin
      SymmetryAxes:=plYZ;
      SymmetryCoord:=t.x/n;
      s:=(r.x/NumAtoms-SymmetryCoord);
      if s = 0 then
        s:=1;
      for a1:=1 to NumAtoms do
        if Atoms[a1].Selected then
        begin
          Atoms[a1].p.x:=SymmetryCoord;
          Atoms[a1].Fixing:=chSym;
        end else
          AtomBoolArray[a1]:=(Atoms[a1].p.x-SymmetryCoord)*s < 0;
      MakeConstraintsSymmetrical;
    end else
    if (abs(d.y) >= abs(d.x)) and (abs(d.y) >= abs(d.z)) then
    begin
      SymmetryAxes:=plXZ;
      SymmetryCoord:=t.y/n;
      s:=(r.y/NumAtoms-SymmetryCoord);
      if s = 0 then
        s:=1;
      for a1:=1 to NumAtoms do
        if Atoms[a1].Selected then
        begin
          Atoms[a1].p.y:=SymmetryCoord;
          Atoms[a1].Fixing:=chSym;
        end else
          AtomBoolArray[a1]:=(Atoms[a1].p.y-SymmetryCoord)*s < 0;
      MakeConstraintsSymmetrical;
    end else
    begin
      SymmetryAxes:=plXY;
      SymmetryCoord:=t.z/n;
      s:=(r.z/NumAtoms-SymmetryCoord);
      if s = 0 then
        s:=1;
      for a1:=1 to NumAtoms do
        if Atoms[a1].Selected then
        begin
          Atoms[a1].p.z:=SymmetryCoord;
          Atoms[a1].Fixing:=chSym;
        end else
          AtomBoolArray[a1]:=(Atoms[a1].p.z-SymmetryCoord)*s < 0;
    end;
    DeleteAtoms(AtomBoolArray);
  end else
  begin
    for a1:=1 to NumAtoms do
      if Atoms[a1].Selected then
        Atoms[a1].Fixing:=chSym;
  end;

  FixSymmetryAtoms;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.MakeSymmetrical;
var mPolygons,mAtoms: array of integer;
    mStruts,mPolyhedrons: array of TPoint;
    a,a1: TAtomRef;
    b,b1: TStrutRef;
    i,n,pg,ph,pg1,ph1: integer;
    oldModified: boolean;
begin
  if SymmetryAxes = pl3D then
    exit;
  SetUndo;

  oldModified:=Modified;

  setlength(mAtoms,NumAtoms+1);
  for a:=1 to NumAtoms do
  if Atoms[a].Fixing = chSym then
  begin
    mAtoms[a]:=a;
  end else
  begin
    a1:=NewAtom(0,0,0,0);
    Atoms[a1]:=Atoms[a];
    mAtoms[a]:=a1;

    case SymmetryAxes of
      plXY: Atoms[a1].p.z:=2*SymmetryCoord-Atoms[a].p.z;
      plXZ: Atoms[a1].p.y:=2*SymmetryCoord-Atoms[a].p.y;
      plYZ: Atoms[a1].p.x:=2*SymmetryCoord-Atoms[a].p.x;
    end;
  end;

  setlength(mStruts,NumStruts+1);
  for b:=1 to NumStruts do
  begin
    b1:=NewStrut(1,1,1,1,1,false,axX);
    Struts[b1]:=Struts[b];
    Struts[b1].Atom1:=mAtoms[Struts[b1].Atom1];
    Struts[b1].Atom2:=mAtoms[Struts[b1].Atom2];
  end;

  setlength(mPolygons,length(Polygons));
  n:=high(Polygons);
  for pg:=0 to n do
  begin
    pg1:=NewPolygon(1,1,1,1,1);
    Polygons[pg1]:=Polygons[pg];
    mPolygons[pg]:=pg1;

    for i:=1 to 4 do
      if Polygons[pg1].a[i] > 0 then
        Polygons[pg1].a[i]:=mAtoms[Polygons[pg].a[i]];
    Polygons[pg1].VisibleSide:=-Polygons[pg].VisibleSide;
  end;

  setlength(mPolyhedrons,length(Polyhedron));
  for ph:=0 to high(Polyhedron) do
  begin
    ph1:=NewPolyhedron([],[]);
    setlength(Polyhedron[ph1].PosFace,length(Polyhedron[ph].NegFace));
    for i:=0 to high(Polyhedron[ph].NegFace) do
      Polyhedron[ph1].PosFace[i]:=mPolygons[Polyhedron[ph].NegFace[i]];
    setlength(Polyhedron[ph1].NegFace,length(Polyhedron[ph].PosFace));
    for i:=0 to high(Polyhedron[ph].PosFace) do
      Polyhedron[ph1].NegFace[i]:=mPolygons[Polyhedron[ph].PosFace[i]];
  end;

ChkPoly;
  Modified:=oldModified;
  FixSymmetryAtoms;
  InvalidateAll;
ChkPoly;
end;

procedure TForm1.ChkPoly;
var b: TStrutRef;
var pg: integer;
var ph,f: integer;
begin
  for b:=1 to NumStruts do
  with Struts[b] do
  begin
    if not InRange(Atom1,1,numAtoms) then
      assert(InRange(Atom1,1,numAtoms));
    if not InRange(Atom2,1,numAtoms) then
      assert(InRange(Atom2,1,numAtoms));
  end;

  for pg:=0 to high(Polygons) do
  with Polygons[pg] do
  begin
    if not InRange(a[1],1,numAtoms) then
      assert(InRange(a[1],1,numAtoms));
    if not InRange(a[3],1,numAtoms) then
      assert(InRange(a[3],1,numAtoms));
    if not InRange(a[2],1,numAtoms) then
      assert(InRange(a[2],1,numAtoms));
    if not InRange(a[4],0,numAtoms) then
      assert(InRange(a[4],0,numAtoms));
  end;

  for ph:=0 to high(Polyhedron) do
  begin
    for f:=low(Polyhedron[ph].PosFace) to high(Polyhedron[ph].PosFace) do
      if not InRange(Polyhedron[ph].PosFace[f],0,high(Polygons)) then
        assert(InRange(Polyhedron[ph].PosFace[f],0,high(Polygons)));
    for f:=low(Polyhedron[ph].NegFace) to high(Polyhedron[ph].NegFace) do
      if not InRange(Polyhedron[ph].NegFace[f],0,high(Polygons)) then
        assert(InRange(Polyhedron[ph].NegFace[f],0,high(Polygons)));
  end;
end;

function TForm1.ZoomScroll(x,y: single; Axes: TAxes): TPoint;
begin
  result.x:=SafeRound(zoom*x,30000);
  result.y:=SafeRound(zoom*y,30000);
  case Axes of
    plXY: begin result.x:=result.x+bOfs2DX; result.y:=result.y+bOfs2DY; end;
    plXZ: begin result.x:=result.x+cOfs2DX; result.y:=result.y+cOfs2DZ; end;
    plYZ: begin result.x:=result.x+aOfs2DY; result.y:=result.y+aOfs2DZ; end;
    pl3D: begin result.x:=result.x+Ofs3DX; result.y:=result.y+Ofs3DY; end;
  end;
end;

function TForm1.UnZoomScroll(x,y: integer; Axes: TAxes): TSinglePoint;
begin
  case Axes of
    plXY: begin result.x:=(x-bOfs2DX)/zoom; result.y:=(y-bOfs2DY)/zoom; end;
    plXZ: begin result.x:=(x-cOfs2DX)/zoom; result.y:=(y-cOfs2DZ)/zoom; end;
    plYZ: begin result.x:=(x-aOfs2DY)/zoom; result.y:=(y-aOfs2DZ)/zoom; end;
    pl3D: begin result.x:=(x-Ofs3DX)/zoom; result.y:=(y-Ofs3DY)/zoom; end;
  end;
end;

procedure TForm1.MoveToZoom(Canvas: TCanvas; x,y: Single; Axes: TAxes);
begin
  with ZoomScroll(x,y,Axes) do Canvas.MoveTo(x,y);
end;

procedure TForm1.LineToZoom(Canvas: TCanvas; x,y: Single; Axes: TAxes);
begin
  with ZoomScroll(x,y,Axes) do Canvas.LineTo(x,y);
end;

procedure TForm1.RectangleZoom(Canvas: TCanvas; Left,Top,Right,Bottom: Single; Axes: TAxes);
var p: TPoint;
begin
  p:=ZoomScroll(Left,Top,Axes);
  with ZoomScroll(Right,Bottom,Axes) do
    Canvas.Rectangle(p.x,p.y,x,y);
end;

procedure TForm1.FillRectZoom(Canvas: TCanvas; Left,Top,Right,Bottom: Single; Axes: TAxes);
var p: TPoint;
begin
  p:=ZoomScroll(Left,Top,Axes);
  with ZoomScroll(Right,Bottom,Axes) do
  Canvas.FillRect(rect(p.x,p.y,x,y));
end;

procedure TForm1.TextOutZoom(Canvas: TCanvas; x,y: Single; s: string; Axes: TAxes);
begin
  with ZoomScroll(x,y,Axes) do Canvas.TextOut(x,y,s);
end;

procedure TForm1.DrawZoom(Canvas: TCanvas; x,y: Single; bmp: TBitmap; Axes: TAxes);
var x1,y1: integer;
begin
  if bmp <> nil then
  with ZoomScroll(x,y,Axes) do
  begin
    x1:=round(zoom*bmp.width);
    y1:=round(zoom*bmp.height);
    Canvas.StretchDraw(rect(x,y,x+x1,y+y1),bmp);
  end;
end;

function TForm1.TextHeightZoom(Canvas: TCanvas; s: string; Axes: TAxes): single;
begin
  result:=round(zoom*Canvas.TextHeight(s));
end;

procedure TForm1.PolygonZoom(Canvas: TCanvas; Points: array of TSinglePoint; Axes: TAxes);
var iPoints: array of TPoint;
    i: integer;
begin
  setlength(iPoints,length(Points));
  for i:=0 to high(iPoints) do
    iPoints[i]:=ZoomScroll(Points[i].x,Points[i].y,Axes);
  Canvas.Polygon(iPoints);
end;

procedure TForm1.sb3DXChange(Sender: TObject);
begin
  InvalidateAll;
end;

procedure TForm1.MoveTo2D(Canvas: TCanvas; xyz: T3DPoint; Axes: TAxes);
begin
  with Proj2DZoom(xyz,Axes) do
    Canvas.MoveTo(x,y);
end;

procedure TForm1.LineTo2D(Canvas: TCanvas; xyz: T3DPoint; Axes: TAxes);
begin
  with Proj2DZoom(xyz,Axes) do
    Canvas.LineTo(x,y);
end;

procedure TForm1.PixDrawZoom(Canvas: TCanvas; x,y: integer; Pix: TPix; Axes: TAxes);
begin
  with ZoomScroll(x,y,Axes) do
    PixStretchDraw(Canvas,Pix,
      rect(0,0,Pix.Width,Pix.Height),
      rect(x,y,x+round(zoom*Pix.Width),y+round(zoom*Pix.Height)));
end;

procedure TForm1.sbCentreClick(Sender: TObject);
begin
  MouseMode:=mmNone;
  bOfs2DX:=0;
  aOfs2DY:=0;
  aOfs2DZ:=0;
  Ofs3DX:=0;
  Ofs3DY:=0;
  Zoom:=1;
  InvalidateAll;
end;

procedure TForm1.Timer3Timer(Sender: TObject);
const c: TColor = 0;
  procedure Paint(aCanvas: TCanvas; Axes: TAxes);
  var b: TStrutRef;
  begin
    for b:=1 to NumStruts do
    with Struts[b],aCanvas do
    if RestLength <= MinRestLength then
    begin
      Pen.Width:=5;
      Pen.Color:=c;
      MoveTo2D(aCanvas,Atoms[Atom1].p,Axes);
      LineTo2D(aCanvas,Atoms[Atom2].p,Axes);
      Pen.Width:=1;
    end;
  end;
begin
  if (CurMode = tiEdit) and ShowCloseAtoms1.Checked then
  begin
    c:=c xor $FF;
    CalcStrutRestLength;
    Paint(pbXY.Canvas,plXY);
    Paint(pbXZ.Canvas,plXZ);
    Paint(pbYZ.Canvas,plYZ);
    Paint(pb3D.Canvas,pl3D);
  end;
end;

procedure TForm1.AddLayer1Click(Sender: TObject);
  function PolygonSelected(pg: integer): boolean;
  begin
    result:=
      Atoms[Polygons[pg].a[1]].Selected and
      Atoms[Polygons[pg].a[2]].Selected and
      Atoms[Polygons[pg].a[3]].Selected and
      ((Polygons[pg].a[4] = 0) or Atoms[Polygons[pg].a[4]].Selected);
  end;
  function FindPolygon(Face: array of integer): integer;
    function InArray(pg: integer): boolean;
    var i,j: integer;
        b: boolean;
    begin
      result:=true;
      for i:=0 to high(face) do
      begin
        b:=false;
        for j:=1 to 4 do
          b:=b or (Polygons[pg].a[j] = face[i]);
        result:=result and b;
      end;
    end;
  begin
    for result:=0 to high(Polygons) do
      if InArray(result) then
        exit;
    assert(false);
  end;
  procedure AddFace(ph,pg: integer; cog: T3DPoint);
  var f,d: T3DPoint;
      area: single;
  begin
    d:=Scale3D(Add3D(Atoms[Polygons[pg].a[1]].p,Add3D(Atoms[Polygons[pg].a[2]].p,Atoms[Polygons[pg].a[3]].p)),1/3);

    f:=PolgonNormal(pg);
    if Polygons[pg].a[4] > 0 then
    begin
      d:=Scale3D(d,3);
      d:=Add3D(d,Atoms[Polygons[pg].a[4]].p);
      d:=Scale3D(d,1/4);
    end;

    if DotProduct3D(f,Sub3D(d,cog)) < 0 then
    begin
      setlength(Polyhedron[ph].PosFace,length(Polyhedron[ph].PosFace)+1);
      Polyhedron[ph].PosFace[high(Polyhedron[ph].PosFace)]:=pg;
    end else
    begin
      setlength(Polyhedron[ph].NegFace,length(Polyhedron[ph].NegFace)+1);
      Polyhedron[ph].NegFace[high(Polyhedron[ph].NegFace)]:=pg;
    end;
  end;
var a,a1: TAtomRef;
    d,cog: T3DPoint;
    b,b1: TStrutRef;
    mAtoms: array of integer;
    sax: set of TAxis;
    ax: TAxis;
    i,pg,pg1,ph: integer;
begin
  Modified:=true;
  SetUndo;

  d:=Zero3DPoint;
  sax:=[];
  i:=0;
  for b:=1 to NumStruts do
    if Atoms[Struts[b].Atom1].Selected and not Atoms[Struts[b].Atom2].Selected then
    begin
      d:=Add3D(d,Sub3D(Atoms[Struts[b].Atom1].p,Atoms[Struts[b].Atom2].p));
      inc(i);
    end else
    if Atoms[Struts[b].Atom2].Selected and not Atoms[Struts[b].Atom1].Selected then
    begin
      d:=Add3D(d,Sub3D(Atoms[Struts[b].Atom2].p,Atoms[Struts[b].Atom1].p)); 
      inc(i);
    end else
    if Atoms[Struts[b].Atom1].Selected and Atoms[Struts[b].Atom2].Selected then
      sax:=sax+[Struts[b].Axis];

  if Length3D(d) = 0 then
    exit;

//  d:=Scale3D(Normalise3D(d),16);
  d:=Scale3D(d,1/i);

  if not (axX in sax) then ax:=axX else
  if not (axY in sax) then ax:=axY else
  if not (axZ in sax) then ax:=axZ else
    ax:=axNone;

  setlength(mAtoms,NumAtoms+1);
  for a:=1 to NumAtoms do
  if Atoms[a].Selected then
  begin
    a1:=NewAtom(0,0,0,0);
    Atoms[a1]:=Atoms[a];
    Atoms[a1].Selected:=false;
    mAtoms[a]:=a1;
    Atoms[a1].p:=Add3D(Atoms[a1].p,d);

    b:=NewStrut(a,a1,Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,ax);
  end;
  FixSymmetryAtoms;

  for b:=1 to NumStruts do
    Struts[b].Selected:=false;

  for pg:=0 to high(Polygons) do
    if PolygonSelected(pg) then
      for i:=1 to 4 do
        if FindStrut(Polygons[pg].a[i],Polygons[pg].a[i mod 4 +1]) > 0 then
          Struts[FindStrut(Polygons[pg].a[i],Polygons[pg].a[i mod 4 +1])].Selected:=true;

  for b:=NumStruts downto 1 do
  if Atoms[Struts[b].Atom1].Selected and Atoms[Struts[b].Atom2].Selected then
  begin
    b1:=NewStrut(1,1,1,1,1,false,axX);
    Struts[b1]:=Struts[b];
    Struts[b1].Atom1:=mAtoms[Struts[b].Atom1];
    Struts[b1].Atom2:=mAtoms[Struts[b].Atom2];
    if Struts[b].Selected then
    begin
      pg1:=NewPolygon(Struts[b].Atom1,Struts[b].Atom2,Struts[b1].Atom2,Struts[b1].Atom1,0);
      NewStrut(Struts[b].Atom1,Struts[b1].Atom2,maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
      NewStrut(Struts[b].Atom2,Struts[b1].Atom1,maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
    end;
  end;

  for pg:=high(Polygons) downto 0 do
  if PolygonSelected(pg) then
  begin
    pg1:=NewPolygon(1,1,1,1,1);
    Polygons[pg1]:=Polygons[pg];

    cog:=Zero3DPoint;
    for i:=1 to 4 do
    if Polygons[pg1].a[i] > 0 then
    begin
      Polygons[pg1].a[i]:=mAtoms[Polygons[pg].a[i]];
      cog:=Add3D(cog,Atoms[Polygons[pg].a[i]].p);
      cog:=Add3D(cog,Atoms[Polygons[pg1].a[i]].p);
    end;
    if Polygons[pg1].a[4] > 0 then
      cog:=Scale3D(cog,1/8) else
      cog:=Scale3D(cog,1/6);
//NewAtom(cog.x,cog.y,cog.z,1);

    ph:=NewPolyhedron([],[]);
    AddFace(ph,pg,cog);
    AddFace(ph,pg1,cog);

    if Polygons[pg1].a[4] > 0 then
    begin
      AddFace(ph,FindPolygon([Polygons[pg].a[1],Polygons[pg].a[2],Polygons[pg1].a[1],Polygons[pg1].a[2]]),cog);
      AddFace(ph,FindPolygon([Polygons[pg].a[2],Polygons[pg].a[3],Polygons[pg1].a[2],Polygons[pg1].a[3]]),cog);
      AddFace(ph,FindPolygon([Polygons[pg].a[3],Polygons[pg].a[4],Polygons[pg1].a[3],Polygons[pg1].a[4]]),cog);
      AddFace(ph,FindPolygon([Polygons[pg].a[4],Polygons[pg].a[1],Polygons[pg1].a[4],Polygons[pg1].a[1]]),cog);
    end else
    begin
      AddFace(ph,FindPolygon([Polygons[pg].a[1],Polygons[pg].a[2],Polygons[pg1].a[1],Polygons[pg1].a[2]]),cog);
      AddFace(ph,FindPolygon([Polygons[pg].a[2],Polygons[pg].a[3],Polygons[pg1].a[2],Polygons[pg1].a[3]]),cog);
      AddFace(ph,FindPolygon([Polygons[pg].a[3],Polygons[pg].a[1],Polygons[pg1].a[3],Polygons[pg1].a[1]]),cog);
    end;
  end;

  for a:=NumAtoms downto 1 do
  if Atoms[a].Selected then
  begin
    Atoms[mAtoms[a]].Selected:=true;
    Atoms[a].Selected:=false;
  end;
  for b:=NumStruts downto 1 do
    Struts[b].Selected:=Atoms[Struts[b].Atom1].Selected or Atoms[Struts[b].Atom2].Selected;

ChkPoly;
  InvalidateAll;
end;

procedure TForm1.FixSymmetryAtoms;
var a: TAtomRef;
begin
  for a:=1 to NumAtoms do
  if Atoms[a].Fixing = chSym then
  case SymmetryAxes of
    plXY: Atoms[a].p.z:=SymmetryCoord;
    plXZ: Atoms[a].p.y:=SymmetryCoord;
    plYZ: Atoms[a].p.x:=SymmetryCoord;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var a: TAtomRef;
begin
  for a:=1 to NumAtoms do
  begin
    Atoms[a].p.x:=round(Atoms[a].p.x/8)*8;
    Atoms[a].p.y:=round(Atoms[a].p.y/8)*8;
    Atoms[a].p.z:=round(Atoms[a].p.z/8)*8;
  end;
  SymmetryCoord:=round(SymmetryCoord/8)*8;
  InvalidateAll;
end;

procedure TForm1.NeglectSelected1Click(Sender: TObject);
var a: TAtomRef;
begin
  SetUndo;
  for a:=1 to NumAtoms do
  begin
    Atoms[a].neglect:=Atoms[a].neglect or Atoms[a].Selected;
    Atoms[a].Selected:=false;
  end;
  InvalidateAll;
end;

procedure TForm1.NeglectNotSelected1Click(Sender: TObject);
var a: TAtomRef;
begin
  SetUndo;
  for a:=1 to NumAtoms do
    Atoms[a].neglect:=Atoms[a].neglect or not Atoms[a].Selected;
  InvalidateAll;
end;

procedure TForm1.HeedAll1Click(Sender: TObject);
var a: TAtomRef;
begin
  SetUndo;
  for a:=1 to NumAtoms do
    Atoms[a].neglect:=false;
  InvalidateAll;
end;

procedure TForm1.Zoom2Click(Sender: TObject);
begin
  MouseMode:=mmZooming;
  case MouseModeAxes of
    plXY: mouse.CursorPos:=pbXY.ClientToScreen(pMouseDown);
    plXZ: mouse.CursorPos:=pbXZ.ClientToScreen(pMouseDown);
    plYZ: mouse.CursorPos:=pbYZ.ClientToScreen(pMouseDown);
    pl3D: mouse.CursorPos:=pb3D.ClientToScreen(pMouseDown);
  end;
  InvalidateAll;
end;

procedure TForm1.Rotate1Click(Sender: TObject);
begin
  MouseMode:=mmRotating;
  SetUndo;
  case MouseModeAxes of
    plXY: mouse.CursorPos:=pbXY.ClientToScreen(pMouseDown);
    plXZ: mouse.CursorPos:=pbXZ.ClientToScreen(pMouseDown);
    plYZ: mouse.CursorPos:=pbYZ.ClientToScreen(pMouseDown);
    pl3D: mouse.CursorPos:=pb3D.ClientToScreen(pMouseDown);
  end;
  InvalidateAll;
end;

procedure TForm1.test1Click(Sender: TObject);
const aValuex: integer = 6;
      aValuey: integer = 6;
      aValuez: integer = 12;
      aValuew: integer = 30;
  procedure MakeSurface;
    function InsideSphere(p,c,r: T3DPoint): boolean;
    begin
      p.x:=p.x/r.x; p.y:=p.y/r.y; p.z:=p.z/r.z;
      c.x:=c.x/r.x; c.y:=c.y/r.y; c.z:=c.z/r.z;
      result:=Dist3D(p,c) <= 1;
    end;
    function OutsideSurface(p: T3DPoint): boolean;
    var i: integer;
    begin
      result:=true;
      for i:=low(Spheroids) to high(Spheroids) do
        result:=result and not InsideSphere(p,Spheroids[i].C,Spheroids[i].R);
    end;
    function MoveToShpere(p,c,r: T3DPoint): T3DPoint;
    begin
      p:=Sub3D(p,c);
      p.x:=p.x/r.x; p.y:=p.y/r.y; p.z:=p.z/r.z;
      p:=Normalise3D(p);
      p.x:=p.x*r.x; p.y:=p.y*r.y; p.z:=p.z*r.z;
      p:=Add3D(p,c);
      result:=p;
    end;
    procedure MoveToSurface(a: TAtomNum);
    var p: T3DPoint;
        i: integer;
        amin: single;
    begin
      amin:=maxint;
      for i:=low(Spheroids) to high(Spheroids) do
      begin
        p:=MoveToShpere(Atoms[a].p,Spheroids[i].C,Spheroids[i].R);
        amin:=min(amin,Dist3D(Atoms[a].p,p));
      end;

      for i:=low(Spheroids) to high(Spheroids) do
      begin
        p:=MoveToShpere(Atoms[a].p,Spheroids[i].C,Spheroids[i].R);
        if amin = Dist3D(Atoms[a].p,p) then
          Atoms[a].p:=p;
      end;
    end;
  var i,j,n: integer;
      a: TAtomRef;
      b: TStrutRef;
      AtomBoolArray: TAtomBoolArray;
      p: T3DPoint;
  begin
    for a:=1 to NumAtoms do
      Atoms[a].Selected:=false;
    fillchar(AtomBoolArray,sizeof(AtomBoolArray),0);

    for b:=1 to NumStruts do
    with Struts[b] do
    begin
      if OutsideSurface(Atoms[Atom1].p) and OutsideSurface(Atoms[Atom2].p) then
      begin
        AtomBoolarray[Atom1]:=true;
        AtomBoolarray[Atom2]:=true;
      end;
    end;

    for b:=1 to NumStruts do
    with Struts[b] do
    begin
      if OutsideSurface(Atoms[Atom1].p) and not OutsideSurface(Atoms[Atom2].p) then
      begin
        Atoms[Atom1].Selected:=true;
        AtomBoolarray[Atom1]:=false;
      end else
      if not OutsideSurface(Atoms[Atom1].p) and OutsideSurface(Atoms[Atom2].p) then
      begin
        Atoms[Atom2].Selected:=true;
        AtomBoolarray[Atom2]:=false;
      end;
    end;

    for a:=1 to NumAtoms do
      if Atoms[a].Selected then
//      if not InsideSphere(Atoms[a].p,R,R-1) then
        MoveToSurface(a);

    DeleteAtoms(AtomBoolArray);

    for j:=2 to 2 do
    for i:=1 to 100 do
    for a:=1 to NumAtoms do
    if Atoms[a].Selected = (j=1) then
    begin
      n:=0;
      p:=Zero3DPoint;
      for b:=1 to NumStruts do
      with Struts[b] do
      begin
        if Atom1 = a then
        begin
          p:=Add3D(p,Atoms[Atom2].p);
          inc(n);
        end else
        if Atom2 = a then
        begin
          p:=Add3D(p,Atoms[Atom1].p);
          inc(n);
        end;
        if n > 0 then
          Atoms[a].p:=Scale3D(p,1/n);
        if Atoms[a].Selected then
          MoveToSurface(a);
      end;
    end;
{}

    Polygons:=nil;
    Polyhedron:=nil;

    for b:=1 to NumStruts do
    with Struts[b] do
    if Atoms[Atom1].Selected then
    if Atoms[Atom2].Selected then
      for a:=1 to NumAtoms do
      if Atoms[a].Selected then
      if a <> Atom1 then
      if a <> Atom2 then
      if FindStrut(a,Atom1) > 0 then
      if FindStrut(a,Atom2) > 0 then
        NewPolygon(a,Atom1,Atom2,0,0);
  end;
  procedure MakeTetGrid;
  var x,y,z: integer;
    a: array[0..50,0..50,0..50] of integer;
    p: array[0..20,0..20,0..20,plXY..plYZ] of integer;
    x0,y0,z0: single;
    x1,y1,z1: single;
    x2,y2,z2: single;
  begin
    x0:=(-aValuex/2)*aValuew;
    y0:=(-aValuey/2)*aValuew;
    z0:=0;

    if dlgOptions.cbSnap.Checked then
    begin
      x0:=round(x0/GridSize)*GridSize;
      y0:=round(y0/GridSize)*GridSize;
      z0:=round(z0/GridSize)*GridSize;
    end;

    for x:=0 to aValuex do
      for y:=0 to aValuey do
        for z:=0 to aValuez do
          a[x,y,z]:=NewAtom(x*aValuew+x0,y*aValuew+y0,z*aValuew+z0,DefaultMass);

    for x:=0 to aValuex do
    for y:=0 to aValuey do
    for z:=0 to aValuez do
    begin
      if x > 0 then
        NewStrut(a[x-1,y,z],a[x,y,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axX);
      if y > 0 then
        NewStrut(a[x,y-1,z],a[x,y,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axY);
      if z > 0 then
        NewStrut(a[x,y,z-1],a[x,y,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axZ);

      begin
        {single diagonal }
        if (x > 0) and (y > 0) then
          if odd(x+y+z) then
            NewStrut(a[x-1,y,z],a[x,y-1,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone) else
            NewStrut(a[x-1,y-1,z],a[x,y,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
        if (x > 0) and (z > 0) then
          if odd(x+y+z) then
            NewStrut(a[x-1,y,z],a[x,y,z-1],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone) else
            NewStrut(a[x-1,y,z-1],a[x,y,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
        if (y > 0) and (z > 0) then
          if odd(x+y+z) then
            NewStrut(a[x,y-1,z],a[x,y,z-1],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone) else
            NewStrut(a[x,y-1,z-1],a[x,y,z],Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
      end;

      if (x > 0) and (y > 0) then
        p[x,y,z,plXY]:=NewPolygon(a[x-1,y-1,z],a[x,y-1,z],a[x,y,z],a[x-1,y,z],0);
      if (x > 0) and (z > 0) then
        p[x,y,z,plXZ]:=NewPolygon(a[x-1,y,z-1],a[x,y,z-1],a[x,y,z],a[x-1,y,z],0);
      if (y > 0) and (z > 0) then
        p[x,y,z,plYZ]:=NewPolygon(a[x,y-1,z-1],a[x,y,z-1],a[x,y,z],a[x,y-1,z],0);
      if (x > 0) and (y > 0) and (z > 0) then
        NewPolyhedron([p[x+0,y+0,z-1,plXY],p[x+0,y+0,z+0,plXZ],p[x-1,y+0,z+0,plYZ]],[p[x+0,y+0,z+0,plXY],p[x+0,y-1,z+0,plXZ],p[x+0,y+0,z+0,plYZ]]);
    end;
  end;
  procedure MakeTets;
  var b1,b2: TStrutRef;
  begin
    Tetrahedra:=nil;
    for b1:=1 to NumStruts do
    for b2:=b1+1 to NumStruts do
    if (FindStrut(Struts[b1].Atom1,Struts[b2].Atom1) > 0) and
       (FindStrut(Struts[b1].Atom1,Struts[b2].Atom2) > 0) and
       (FindStrut(Struts[b1].Atom2,Struts[b2].Atom1) > 0) and
       (FindStrut(Struts[b1].Atom2,Struts[b2].Atom2) > 0) then
    begin
assert(Struts[b1].Atom1 <> Struts[b1].Atom2);
assert(Struts[b1].Atom1 <> Struts[b2].Atom1);
assert(Struts[b1].Atom1 <> Struts[b2].Atom2);
assert(Struts[b1].Atom2 <> Struts[b2].Atom1);
assert(Struts[b1].Atom2 <> Struts[b2].Atom2);
assert(Struts[b2].Atom1 <> Struts[b2].Atom2);
        NewTetrahedron(
          Struts[b1].Atom1,
          Struts[b2].Atom1,
          Struts[b1].Atom2,
          Struts[b2].Atom2);
    end;
  end;
begin
  New1Click(Sender);
//  SetUndo;
//  Modified:=true;
//  if InputNumberQuery4('Make Grid','x-count','y-count','z-count','Size',aValuex,aValuey,aValuez,aValuew,1,50) then
  begin
    SetLength(Spheroids,2);
    with Spheroids[0] do begin R.x:=89; R.y:=89; R.z:=89; C.x:=0; C.y:=0; C.z:=90; end;
    with Spheroids[1] do begin R.x:=50; R.y:=50; R.z:=100; C.x:=0; C.y:=0; C.z:=190; end;

    prism1Click(Sender);
//    MakeTetGrid;
    MakeSurface;
    MakeTets;
    InvalidateAll;
  end;
end;

procedure TForm1.InvertSelection1Click(Sender: TObject);
var a: TAtomRef;
begin
  for a:=1 to NumAtoms do
    Atoms[a].Selected:=not Atoms[a].Selected;
  InvalidateAll;
end;

procedure TForm1.prism1Click(Sender: TObject);
  function NewAt(x,y,z: single): integer;
  begin
    for result:=1 to numatoms do
      with Atoms[result] do
        if (abs(p.x-x) < 1) and (abs(p.y-y) < 1) and (abs(p.z-z) < 1) then
          exit;
    result:=NewAtom(x,y,z,DefaultMass);
  end;
  function NewSt(a1,a2: TAtomRef): TStrutRef;
  begin
    result:=FindStrut(a1,a2);
    if result = 0 then
      result:=NewStrut(a1,a2,Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,true,axNone);
  end;
  procedure NewTet(p1,p2,p3,p4: t3dpoint);
  var a1,a2,a3,a4: integer;
  begin
    a1:=NewAt(p1.x,p1.y,p1.z);
    a2:=NewAt(p2.x,p2.y,p2.z);
    a3:=NewAt(p3.x,p3.y,p3.z);
    a4:=NewAt(p4.x,p4.y,p4.z);
    NewSt(a1,a2);
    NewSt(a2,a3);
    NewSt(a3,a1);
    NewSt(a1,a4);
    NewSt(a2,a4);
    NewSt(a3,a4);

    NewPolygon(a1,a2,a3,0,0);
    NewPolygon(a2,a3,a4,0,0);
    NewPolygon(a1,a3,a4,0,0);
    NewPolygon(a1,a2,a4,0,0);

    NewTetrahedron(a1,a2,a3,a4);
  end;
  procedure flipx(var p: t3dpoint; x: single);
  begin
    p.x:=x-(p.x-x);
  end;
  procedure flipy(var p: t3dpoint; y: single);
  begin
    p.y:=y-(p.y-y);
  end;
  procedure shift(var p: t3dpoint; x,y: single);
  begin
    p.x:=p.x+x;
    p.y:=p.y+y;
  end;
var d: single;
var ix,iy,iz,j1,j2,k: integer;
    p: array[1..100] of t3dpoint;
const t = 30;
      q = t/3;
      h = q*2;
begin
  New1Click(Sender);
  d:=sqrt(sqr(t)-sqr(t/2));

  for ix:=-2 to 3 do
  for iy:=-2 to 3 do
  for j1:=1 to 2 do
  for j2:=1 to 3 do
  for iz:=-1 to 7 do
  begin
    p[1]:=a3DPoint(d, t/2, h-q          +iz*4*q);
    p[2]:=a3DPoint(0, 0,   h-q*2        +iz*4*q);
    p[3]:=a3DPoint(0, t,   h+q          +iz*4*q);
    p[4]:=a3DPoint(d, t/2, h-q+4*q      +iz*4*q);
    p[5]:=a3DPoint(0, 0,   h-q*2+4*q    +iz*4*q);
    p[6]:=a3DPoint(0, t,   h+q+4*q      +iz*4*q);

    for k:=1 to 6 do
    begin
      if j1 = 1 then
        p[k].x:=-p[k].x;
      if j2 = 2 then
      begin
        rotateXY2(-pi/3,p[k].x,p[k].y,0,0,p[k].x,p[k].y);
        p[k].y:=-p[k].y;
      end;
      if j2 = 3 then
      begin
        rotateXY2(+pi/3,p[k].x,p[k].y,0,0,p[k].x,p[k].y);
        p[k].y:=-p[k].y;
      end;
      if odd(ix) then
        shift(p[k],d,ix*t*3/2) else
        shift(p[k],0,ix*t*3/2);
      shift(p[k],iy*2*d,0);
    end;

    NewTet(p[1],p[2],p[3],p[5]);
    NewTet(p[1],p[3],p[4],p[5]);
    NewTet(p[3],p[5],p[4],p[6]);
  end;

  InvalidateAll;
end;

procedure TForm1.make1tet1Click(Sender: TObject);
var a,a1,a2,a3,a4: TAtomRef;
begin
  if NumSelectedAtoms = 4 then
  begin
    for a:=1 to NumAtoms do
    if Atoms[a].Selected then
    begin
      a1:=a2;
      a2:=a3;
      a3:=a4;
      a4:=a;
    end;

    NewTetrahedron(a1,a2,a3,a4);
    NewPolygon(a1,a2,a3,0,0);
    NewPolygon(a1,a2,a4,0,0);
    NewPolygon(a1,a3,a4,0,0);
    NewPolygon(a2,a3,a4,0,0);
  end;
end;

procedure TForm1.Xgrain1Click(Sender: TObject);
var b: TStrutRef;
begin
  for b:=1 to NumStruts do
    with Struts[b] do
      if Selected then
        coeff:=abs(Normalise3D(Sub3D(Atoms[Atom1].p,Atoms[Atom2].p)).x);
end;

procedure TForm1.YGrain1Click(Sender: TObject);
var b: TStrutRef;
begin
  for b:=1 to NumStruts do
    with Struts[b] do
      if Selected then
        coeff:=abs(Normalise3D(Sub3D(Atoms[Atom1].p,Atoms[Atom2].p)).y);
end;

procedure TForm1.ZGrain1Click(Sender: TObject);
var b: TStrutRef;
begin
  for b:=1 to NumStruts do
    with Struts[b] do
      if Selected then
        coeff:=abs(Normalise3D(Sub3D(Atoms[Atom1].p,Atoms[Atom2].p)).z);
end;

procedure TForm1.SetTimelineCurTime(t: integer);
var k,k2: integer;
const prev: integer = maxint;
begin
  t:=max(t,0);
  if fTimelineCurTime = t then
    exit;

  fTimelineCurTime:=t;
  pnlTimelineRed.Left:=IntRange(TLTimeToX(t),0,pbTimeline.Width-pnlTimelineRed.Width);

  k2:=-1;
  for k:=0 to high(Keyframe) do
    if Keyframe[k].TLTime = TimelineCurTime then
      k2:=k;

  if k2 <> prev then
    pbTimelinePaint(self);
  LoadKeyframeImages;
end;

function TForm1.TLTimeToX(t: integer): integer;
begin
  result:=round(t*(pbTimeline.Width-pnlTimelineRed.Width)/MaxTime);
end;

function TForm1.XToTLTime(x: integer): integer;
begin
  result:=IntRange(round(x*MaxTime/(pbTimeline.Width-pnlTimelineRed.Width)),0,MaxTime);
end;

procedure TForm1.XY1Click(Sender: TObject);
begin
  if CurKeyframe >= 0 then
  begin
    if OpenPictureDialog1.Execute then
      Keyframe[CurKeyframe].jpgBGXY:=OpenPictureDialog1.filename else
      Keyframe[CurKeyframe].jpgBGXY:='';
    CurKeyframe:=-1;
    LoadKeyframeImages;
  end;
end;

procedure TForm1.XZ1Click(Sender: TObject);
begin
  if CurKeyframe >= 0 then
  begin
    if OpenPictureDialog1.Execute then
      Keyframe[CurKeyframe].jpgBGXZ:=OpenPictureDialog1.filename else
      Keyframe[CurKeyframe].jpgBGXZ:='';
    CurKeyframe:=-1;
    LoadKeyframeImages;
  end;
end;

procedure TForm1.YZ1Click(Sender: TObject);
begin
  if CurKeyframe >= 0 then
  begin
    if OpenPictureDialog1.Execute then
      Keyframe[CurKeyframe].jpgBGYZ:=OpenPictureDialog1.filename else
      Keyframe[CurKeyframe].jpgBGYZ:='';
    CurKeyframe:=-1;
    LoadKeyframeImages;
  end;
end;

procedure TForm1.LoadKeyframeImages;
var k,k2: integer;
begin
  k2:=0;
  for k:=0 to high(Keyframe) do
    if Keyframe[k].TLTime <= TimelineCurTime then
      k2:=k;

  if Keyframe[k2].jpgBGXY <> sbmpBGXY then SetImgFile(bmpBGXYr,Keyframe[k2].jpgBGXY,false);
  if Keyframe[k2].jpgBGXZ <> sbmpBGXZ then SetImgFile(bmpBGXZr,Keyframe[k2].jpgBGXZ,false);
  if Keyframe[k2].jpgBGYZ <> sbmpBGYZ then SetImgFile(bmpBGYZr,Keyframe[k2].jpgBGYZ,false);
  sbmpBGXY:=Keyframe[k2].jpgBGXY;
  sbmpBGXZ:=Keyframe[k2].jpgBGXZ;
  sbmpBGYZ:=Keyframe[k2].jpgBGYZ;
end;

procedure TForm1.puTimeline1Popup(Sender: TObject);
begin
  NewKeyframe1.enabled:=(not LockKeyframes1.Checked) and (CurMode = tiEdit);
  PasteKeyframe1.enabled:=not LockKeyframes1.Checked;
end;

procedure TForm1.puTimeline2Popup(Sender: TObject);
var m: integer;
begin
  DeleteKeyframe1.enabled:=(not LockKeyframes1.Checked) and (CurMode = tiEdit);
  DeleteAll1.enabled:=(not LockKeyframes1.Checked) and (CurMode = tiEdit);
  CurrentMuscleSignificant1.enabled:=InRange(CurMuscle,0,high(muscle));

  DeleteKeyframe1.Visible:=CurKeyframe >= 0;
  KeyframeImage1.Visible:=CurKeyframe >= 0;
  CopyKeyframe1.Visible:=CurKeyframe >= 0;
  PasteKeyframe2.Visible:=CurKeyframe >= 0;
  Imagetobackground1.Visible:=CurKeyframe >= 0;
  Significant1.Visible:=CurKeyframe >= 0;
  N17.Visible:=CurKeyframe >= 0;

  CurrentMuscleSignificant1.Checked:=(CurKeyframe >= 0) and InRange(CurMuscle,0,high(muscle)) and Keyframe[CurKeyframe].posq[CurMuscle].Significant;
  AllSignificant1.Checked:=true;
  NoneSignificant1.Checked:=true;
  if CurKeyframe >= 0 then
    for m:=0 to high(muscle) do
      if Keyframe[CurKeyframe].posq[m].Significant then
        NoneSignificant1.Checked:=false else
        AllSignificant1.Checked:=false;
end;

function TForm1.MeshPoint3D(RoofAxes: TRoofAxes; i,j: integer): T3DPoint;
begin
  case RoofAxes of
    raZPos,raZNeg:  result:=a3DPoint(i*RoofMeshsize[RoofAxes],j*RoofMeshsize[RoofAxes],Roof[RoofAxes,i,j].h);
    raYPos,raYNeg:  result:=a3DPoint(i*RoofMeshsize[RoofAxes],Roof[RoofAxes,i,j].h,(j+RoofN[RoofAxes])*RoofMeshsize[RoofAxes]);
    raXNeg,raXPos:  result:=a3DPoint(Roof[RoofAxes,i,j].h,i*RoofMeshsize[RoofAxes],(j+RoofN[RoofAxes])*RoofMeshsize[RoofAxes]);
  end;
end;

function TForm1.MeshPoint2D(RoofAxes: TRoofAxes; i,j: integer; Axes: TAxes): TPoint;
begin
  result:=Proj2DZoom(MeshPoint3D(RoofAxes,i,j),Axes);
end;

procedure TForm1.Rigidbody1Click(Sender: TObject);
var a: integer;
    s,t: string;
begin
  if SymmetryAxes = pl3D then
    ShowWarningMessage('Rigid bodies can only work when there is a symmetry plane');

  s:='';
//  for a:=1 to NumAtoms do
//    if Atoms[a].Rigid <> nil then
//      s:=RigidToString(Atoms[a].Rigid[0],',');
  for a:=1 to NumAtoms do
    if Atoms[a].Selected then
      if Atoms[a].Rigid <> nil then
        s:=RigidToString(Atoms[a].Rigid,',');

  if InputQuery('Rigid body','Rigid body NUMBERS separated by commas',s) then
    for a:=1 to NumAtoms do
      if Atoms[a].Selected then
      begin
        t:=s;
        StringToRigid(t,Atoms[a].rigid,',');
      end;
end;

procedure TForm1.ApplyRigity;
var c1,c2: T3DPoint;
  function InRigid(r: Integer; Rigid: TArrayofInteger): boolean;
  var i: integer;
  begin
    result:=true;
    for i:=0 to high(Rigid) do
      if r = Rigid[i] then
        exit;
    result:=false;
  end;
  procedure PivotPoint(r,aFixed: Integer);
  var a,n: integer;
  begin
    if aFixed > 0 then
    with Atoms[aFixed] do
    begin
      c1:=pOriginal;
      c2:=p;
      exit;
    end;

    c1:=Zero3DPoint;
    c2:=Zero3DPoint;
    n:=0;
    for a:=1 to NumAtoms do
    with Atoms[a] do
    if InRigid(r,Rigid) then
    begin
      c1:=Add3D(c1,pOriginal);
      c2:=Add3D(c2,p);
      inc(n);
    end;
    c1:=Scale3D(c1,1/n);
    c2:=Scale3D(c2,1/n);
  end;
  procedure ApplyXY(r,aFixed: Integer);
  var a: integer;
      c,s,Sc,Ss,b: single;
  begin
    Ss:=0;
    Sc:=0;
    for a:=1 to NumAtoms do
    with Atoms[a] do
    if InRigid(r,Rigid) then
    begin
      Ss:=Ss+(pOriginal.y-c1.y)*(p.x-c2.x)-(pOriginal.x-c1.x)*(p.y-c2.y);
      Sc:=Sc+(pOriginal.x-c1.x)*(p.x-c2.x)+(pOriginal.y-c1.y)*(p.y-c2.y);
    end;

    if (Ss <> 0) or (Sc <> 0) then
      b:=arctan2(Ss,Sc) else
      b:=0;
    c:=cos(b);
    s:=sin(b);

    for a:=1 to NumAtoms do
      with Atoms[a] do
        if InRigid(r,Rigid) then
            p:=a3Dpoint(
               (pOriginal.x-c1.x)*c
              +(pOriginal.y-c1.y)*s
              +c2.x,
               (pOriginal.y-c1.y)*c
              -(pOriginal.x-c1.x)*s
              +c2.y,
              pOriginal.z);
  end;
  procedure ApplyXZ(r,aFixed: Integer);
  var a: integer;
      c,s,Sc,Ss,b: single;
  begin
    Ss:=0;
    Sc:=0;
    for a:=1 to NumAtoms do
    with Atoms[a] do
    if InRigid(r,Rigid) then
    begin
      Ss:=Ss+(pOriginal.z-c1.z)*(p.x-c2.x)-(pOriginal.x-c1.x)*(p.z-c2.z);
      Sc:=Sc+(pOriginal.x-c1.x)*(p.x-c2.x)+(pOriginal.z-c1.z)*(p.z-c2.z);
    end;

    if (Ss <> 0) or (Sc <> 0) then
      b:=arctan2(Ss,Sc) else
      b:=0;
    c:=cos(b);
    s:=sin(b);

    for a:=1 to NumAtoms do
      with Atoms[a] do
        if Fixing <> chStatic then
        if InRigid(r,Rigid) then
            p:=a3Dpoint(
               (pOriginal.x-c1.x)*c
              +(pOriginal.z-c1.z)*s
              +c2.x,
               pOriginal.y,
               (pOriginal.z-c1.z)*c
              -(pOriginal.x-c1.x)*s
              +c2.z);
  end;
  procedure ApplyYZ(r,aFixed: Integer);
  var a: integer;
      c,s,Sc,Ss,b: single;
  begin
    Ss:=0;
    Sc:=0;
    for a:=1 to NumAtoms do
    with Atoms[a] do
    if InRigid(r,Rigid) then
    begin
      Ss:=Ss+(pOriginal.z-c1.z)*(p.y-c2.y)-(pOriginal.y-c1.y)*(p.z-c2.z);
      Sc:=Sc+(pOriginal.y-c1.y)*(p.y-c2.y)+(pOriginal.z-c1.z)*(p.z-c2.z);
    end;

    if (Ss <> 0) or (Sc <> 0) then
      b:=arctan2(Ss,Sc) else
      b:=0;
    c:=cos(b);
    s:=sin(b);

    for a:=1 to NumAtoms do
      with Atoms[a] do
        if InRigid(r,Rigid) then
            p:=a3Dpoint(
               pOriginal.x,
               (pOriginal.y-c1.y)*c
              +(pOriginal.z-c1.z)*s
              +c2.y,
               (pOriginal.z-c1.z)*c
              -(pOriginal.y-c1.y)*s
              +c2.z);
  end;
  procedure ApplyXYZ(r,aFixed: Integer);
  begin
    PivotPoint(r,aFixed);

    case SymmetryAxes of
      plXY: ApplyXY(r,aFixed);
      plXZ: ApplyXZ(r,aFixed);
      plYZ: ApplyYZ(r,aFixed);
    end;
  end;
var a,i,j: integer;
    all,done: set of 0..255;
    more: boolean;
begin
  if SymmetryAxes = pl3D then
    exit;

  all:=[];
  done:=[];

  for a:=1 to NumAtoms do
    for i:=0 to high(Atoms[a].Rigid) do
      all:=all+[Atoms[a].Rigid[i]];
  if All = [] then
    exit;

  for a:=1 to NumAtoms do
  if Atoms[a].Fixing = chStatic then   {do rigid that has a static first}
  for i:=0 to high(Atoms[a].Rigid) do
  begin
    if not(Atoms[a].Rigid[i] in done) then
    begin
      done:=done+[Atoms[a].Rigid[i]];
      ApplyXYZ(Atoms[a].Rigid[i],a);
    end;
  end;

  repeat
    repeat
      more:=false;
      for a:=1 to NumAtoms do
      begin
        for i:=0 to high(Atoms[a].Rigid) do
        if not(Atoms[a].Rigid[i] in done) then
        for j:=0 to high(Atoms[a].Rigid) do
        if Atoms[a].Rigid[j] in done then {choose one that's attached to one that is done}
        begin
          done:=done+[Atoms[a].Rigid[i]];
          ApplyXYZ(Atoms[a].Rigid[i],a);
          more:=true;
        end;
      end;
    until not more;

    more:=false;
    for a:=1 to NumAtoms do
    if not more then
    begin
      for i:=0 to high(Atoms[a].Rigid) do
      if not(Atoms[a].Rigid[i] in done) then {choose any that we haven't done yet}
      begin
        done:=done+[Atoms[a].Rigid[i]];
        ApplyXYZ(Atoms[a].Rigid[i],0);
        more:=true;
      end;
    end;
  until All = Done;
end;

procedure TForm1.ShowClosure1Click(Sender: TObject);
begin
  ShowClosure1.Checked:=not ShowClosure1.Checked;
end;

procedure TForm1.EditRoof(RoofAxes: TRoofAxes);
var i,j: integer;
begin
  with dlgRoof do
  begin
    seMeshsize.Value:=RoofMeshsize[RoofAxes];
    seHeight.Value:=round(Roof[RoofAxes,0,0].h);
    pnlPoints.Tag:=RoofN[RoofAxes];
    pnlColor.Color:=RoofColor[RoofAxes];
    case RoofAxes of
      raZPos: GroupBox1.Caption:='Top';
      raZNeg: GroupBox1.Caption:='Bottom';
      raYPos: GroupBox1.Caption:='Front';
      raYNeg: GroupBox1.Caption:='Back';
      raXNeg: GroupBox1.Caption:='Left';
      raXPos: GroupBox1.Caption:='Right';
    end;
    case RoofAxes of
      raZPos: Label3.Caption:='Z-Value';
      raZNeg: Label3.Caption:='Z-Value';
      raYPos: Label3.Caption:='Y-Value';
      raYNeg: Label3.Caption:='Y-Value';
      raXNeg: Label3.Caption:='X-Value';
      raXPos: Label3.Caption:='X-Value';
    end;
    cbRoofConstraint.Checked:=HasConstraint[RoofAxes];

    if ShowModal = mrOK then
    begin
      RoofMeshsize[RoofAxes]:=seMeshsize.Value;
      if (seHeight.Value <> round(Roof[RoofAxes,0,0].h)) or (RoofN[RoofAxes] <> pnlPoints.Tag) then
      begin
        RoofN[RoofAxes]:=pnlPoints.Tag;
        for i:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
        for j:=-RoofN[RoofAxes] to RoofN[RoofAxes] do
        case RoofAxes of
          raZPos: Roof[RoofAxes,i,j].h:=abs(seHeight.Value)-i*i*2-j*j*2;
          raZNeg: Roof[RoofAxes,i,j].h:=seHeight.Value+i*i*2+j*j*2;
          raYPos: Roof[RoofAxes,i,j].h:=abs(seHeight.Value)-i*i*2-j*j*2;
          raYNeg: Roof[RoofAxes,i,j].h:=-(abs(seHeight.Value)-i*i*2-j*j*2);
          raXNeg: Roof[RoofAxes,i,j].h:=-(abs(seHeight.Value)-i*i*2-j*j*2);
          raXPos: Roof[RoofAxes,i,j].h:=abs(seHeight.Value)-i*i*2-j*j*2;
        end;
      end;
      RoofColor[RoofAxes]:=pnlColor.Color;
      HasConstraint[RoofAxes]:=cbRoofConstraint.Checked;
      Roof2.Checked:=HasConstraint[RoofAxes];
      MakeConstraintsSymmetrical;
      InvalidateAll;
      Modified:=true;
    end;
  end;
end;

procedure TForm1.ZPos1Click(Sender: TObject);
begin
  EditRoof(raZPos);
end;

procedure TForm1.ZNeg1Click(Sender: TObject);
begin
  EditRoof(raZNeg);
end;

procedure TForm1.YPos1Click(Sender: TObject);
begin
  EditRoof(raYPos);
end;

procedure TForm1.YNeg1Click(Sender: TObject);
begin
  EditRoof(raYNeg);
end;

procedure TForm1.XNeg1Click(Sender: TObject);
begin
  EditRoof(raXNeg);
end;

procedure TForm1.XPos1Click(Sender: TObject);
begin
  EditRoof(raXPos);
end;

procedure TForm1.ZPos4Click(Sender: TObject);
var i,j: integer;
begin
  for i:=-RoofN[raZPos] to RoofN[raZPos] do
    for j:=-RoofN[raZPos] to RoofN[raZPos] do
      Roof[raZPos,i,j].Selected:=true;
  InvalidateAll;
end;

procedure TForm1.ZNeg4Click(Sender: TObject);
var i,j: integer;
begin
  for i:=-RoofN[raZNeg] to RoofN[raZNeg] do
    for j:=-RoofN[raZNeg] to RoofN[raZNeg] do
      Roof[raZNeg,i,j].Selected:=true;
  InvalidateAll;
end;

procedure TForm1.YPos2Click(Sender: TObject);
var i,j: integer;
begin
  for i:=-RoofN[raYPos] to RoofN[raYPos] do
    for j:=-RoofN[raYPos] to RoofN[raYPos] do
      Roof[raYPos,i,j].Selected:=true;
  InvalidateAll;
end;

procedure TForm1.YNeg2Click(Sender: TObject);
var i,j: integer;
begin
  for i:=-RoofN[raYNeg] to RoofN[raYNeg] do
    for j:=-RoofN[raYNeg] to RoofN[raYNeg] do
      Roof[raYNeg,i,j].Selected:=true;
  InvalidateAll;
end;

procedure TForm1.XNeg2Click(Sender: TObject);
var i,j: integer;
begin
  for i:=-RoofN[raXNeg] to RoofN[raXNeg] do
    for j:=-RoofN[raXNeg] to RoofN[raXNeg] do
      Roof[raXNeg,i,j].Selected:=true;
  InvalidateAll;
end;

procedure TForm1.XPos2Click(Sender: TObject);
var i,j: integer;
begin
  for i:=-RoofN[raXPos] to RoofN[raXPos] do
    for j:=-RoofN[raXPos] to RoofN[raXPos] do
      Roof[raXPos,i,j].Selected:=true;
  InvalidateAll;
end;

procedure TForm1.Button1Click(Sender: TObject);
var i,j: integer;
begin
  for i:=1 to 1000 do
  with Atoms[NewAtom(random(800)-400,random(800)-400,random(800),DefaultMass)],p do
  begin
    x:=RoofPosXNeg(y,z);
    if x < -1000 then
    begin
      x:=0;
      y:=0;
      z:=0;
    end;
  end;
{}

  InvalidateAll;
end;

function TForm1.RoofPosZPos(x,y: single): single;
begin
  result:=RoofPos(raZPos,x/RoofMeshsize[raZPos],y/RoofMeshsize[raZPos]);
end;

function TForm1.RoofPosZNeg(x,y: single): single;
begin
  result:=RoofPos(raZNeg,x/RoofMeshsize[raZNeg],y/RoofMeshsize[raZNeg]);
end;

function TForm1.RoofPosYPos(x,z: single): single;
begin
  result:=RoofPos(raYPos,x/RoofMeshsize[raYPos],z/RoofMeshsize[raYPos]-RoofN[raYPos]);
end;

function TForm1.RoofPosYNeg(x,z: single): single;
begin
  result:=RoofPos(raYNeg,x/RoofMeshsize[raYNeg],z/RoofMeshsize[raYNeg]-RoofN[raYNeg]);
end;

function TForm1.RoofPosXNeg(y,z: single): single;
begin
  result:=RoofPos(raXNeg,y/RoofMeshsize[raXNeg],z/RoofMeshsize[raXNeg]-RoofN[raXNeg]);
end;

function TForm1.RoofPosXPos(y,z: single): single;
begin
  result:=RoofPos(raXPos,y/RoofMeshsize[raXPos],z/RoofMeshsize[raXPos]-RoofN[raXPos]);
end;

function TForm1.RoofPos(RoofAxes: TRoofAxes; x,y: single): single;
var i,j: integer;
    ah,bh: single;
    h1,h2,h3,h4: single;
begin
  i:=floor(x);
  j:=floor(y);
  if InRange(i,-RoofN[RoofAxes],RoofN[RoofAxes]-1) and InRange(j,-RoofN[RoofAxes],RoofN[RoofAxes]-1) then
  begin
    x:=x-i;
    y:=y-j;
    h1:=Roof[RoofAxes,i,j].h;
    h2:=Roof[RoofAxes,i+1,j].h;
    h3:=Roof[RoofAxes,i,j+1].h;
    h4:=Roof[RoofAxes,i+1,j+1].h;

    ah:=h1+y*(h3-h1);
    bh:=h2+y*(h4-h2);
    result:=ah+x*(bh-ah);
  end else
  if RoofAxes = raXNeg then
    result:=-1000000 else
    result:=1000000;
end;

procedure TForm1.Add2Click(Sender: TObject);
var b: TStrutRef;
    a: TAtomRef;
    ok: boolean;
begin
  if (dlgEMA.cbtheta.ItemIndex <> 0) or (dlgEMA.cbphi.ItemIndex <> 0) then
  begin
    if AtomsSelectedCount <> StrutsSelectedCount then
    begin
      ShowErrorMessage('Each selected Atom should have one selected strut and vice versa');
      exit;
    end;
    for b:=1 to NumStruts do
    if Struts[b].Selected then
    if (not (Atoms[Struts[b].Atom1].Selected or Atoms[Struts[b].Atom2].Selected)) or
       (Atoms[Struts[b].Atom1].Selected and Atoms[Struts[b].Atom2].Selected) then
    begin
      ShowErrorMessage('Each selected Atom should have one selected strut and vice versa');
      exit;
    end;

    for a:=1 to NumAtoms do
    if Atoms[a].Selected then
    begin
      ok:=false;
      for b:=1 to NumStruts do
        if Struts[b].Selected then
          if (Struts[b].Atom1 = a) or (Struts[b].Atom2 = a) then
            ok:=true;
      if not ok then
      begin
        ShowErrorMessage('Each selected Atom should have one selected strut and vice versa');
        exit;
      end;
    end;
    for a:=1 to NumAtoms do
      if Atoms[a].Selected then
        for b:=1 to NumStruts do
          if Struts[b].Selected then
            if Struts[b].Atom2 = a then
              dlgEMA.AddAtom(a,Struts[b].Atom1) else
            if Struts[b].Atom1 = a then
              dlgEMA.AddAtom(a,Struts[b].Atom2);
  end else
  begin
    for a:=1 to NumAtoms do
      if Atoms[a].Selected then
        dlgEMA.AddAtom(a,0);
  end;
  InvalidateAll;
end;

procedure TForm1.Delete4Click(Sender: TObject);
var a: TAtomRef;
begin
  for a:=1 to NumAtoms do
    if Atoms[a].Selected then
      dlgEMA.DeleteAtom(a);
  InvalidateAll;
end;

procedure TForm1.Options3Click(Sender: TObject);
begin
  dlgEMA.ShowModal;
  InvalidateAll;
end;

procedure TForm1.FillEMA;
var a: TAtomRef;
    i: integer;
begin
  for a:=1 to NumAtoms do
    Atoms[a].EMA:=-1;
  if dlgEMA <> nil then
    with dlgEMA do
      for i:=0 to ListBox1.Items.Count-1 do
        if InRange(loword(integer(ListBox1.Items.Objects[i])),1,Form1.NumAtoms) then
          if (cbtheta.ItemIndex <> 0) or (dlgEMA.cbphi.ItemIndex <> 0) then
            Atoms[loword(integer(ListBox1.Items.Objects[i]))].EMA:=hiword(integer(ListBox1.Items.Objects[i])) else
            Atoms[loword(integer(ListBox1.Items.Objects[i]))].EMA:=0;
end;

procedure TForm1.AddAllMuscles1Click(Sender: TObject);
begin
  dlgEMA.AddMuscles(length(muscle));
end;

procedure TForm1.DeleteAllMuscles1Click(Sender: TObject);
begin
  dlgEMA.DeleteMuscles;
end;

procedure TForm1.CopyKeyframe1Click(Sender: TObject);
begin
  if CurKeyframe >= 0 then
  begin
    ClipboardKeyframe.TLTime:=Keyframe[CurKeyframe].TLTime;
    ClipboardKeyframe.posq:=Copy(Keyframe[CurKeyframe].posq);
    ClipboardKeyframe.jpgBGXY:=Keyframe[CurKeyframe].jpgBGXY;
    ClipboardKeyframe.jpgBGXZ:=Keyframe[CurKeyframe].jpgBGXZ;
    ClipboardKeyframe.jpgBGYZ:=Keyframe[CurKeyframe].jpgBGYZ;
    Keyframe0Significant;
  end;
end;

procedure TForm1.PasteKeyframe1Click(Sender: TObject);
begin
  if ClipboardKeyframe.TLTime >= 0 then
  begin
    if Sender <> PasteKeyframe2 then
    begin
      CurKeyframe:=IsAtKeyframe;
      if CurKeyframe < 0 then
        NewKeyframe(true,true);
    end;
    Keyframe[CurKeyframe].posq:=Copy(ClipboardKeyframe.posq);
//    Keyframe[CurKeyframe].jpgBGXY:=ClipboardKeyframe.jpgBGXY;
//    Keyframe[CurKeyframe].jpgBGXZ:=ClipboardKeyframe.jpgBGXZ;
//    Keyframe[CurKeyframe].jpgBGYZ:=ClipboardKeyframe.jpgBGYZ;
    pbTimeline.Invalidate;
  end;
end;

procedure TForm1.ImportKeyframes1Click(Sender: TObject);
var i: integer;
    s: TStringList;
    t: string;
    a: single;
begin
  Stop;
  if OpenDialog3.Execute then
  begin
    s:=TStringList.Create;
    s.LoadFromFile(OpenDialog3.filename);
    for i:=0 to s.count-1 do
    begin
      t:=s[i];
      a:=MustbeSignedDouble(t);
      nextis(t,',');
      t:=before(t,',');
      if fileexists(t) then
      begin
        NewKeyframe(false,false);
        Keyframe[high(Keyframe)].TLTime:=round(a*1000);
        dlgOptions.fseNormalAnimPeriod.value:=max(MaxTime,Keyframe[high(Keyframe)].TLTime+20)/1000;
        if Sender = ImagetoXY1 then Keyframe[high(Keyframe)].jpgBGXY:=t else
        if Sender = ImagetoYZ1 then Keyframe[high(Keyframe)].jpgBGYZ:=t else
                                    Keyframe[high(Keyframe)].jpgBGXZ:=t; 
      end else
      if not YesNoBox('File "'+t+'" does not exist'#13#10'Continue?') then
        exit;
    end;
    SortKeyframes;
    pbTimeline.Invalidate;
    s.Free;
  end;
end;

procedure TForm1.DeleteAll1Click(Sender: TObject);
begin
  if not YesNoBox('Delete all keyframes?') then
    exit;
  Setlength(Keyframe,1);
  pbTimeline.Invalidate;
end;

procedure TForm1.Imagetobackground1Click(Sender: TObject);
begin
  if CurKeyframe >= 0 then
  begin
    if Keyframe[CurKeyframe].jpgBGXY <> '' then SetImgFile(bmpBGXYe,Keyframe[CurKeyframe].jpgBGXY,false);
    if Keyframe[CurKeyframe].jpgBGXZ <> '' then SetImgFile(bmpBGXZe,Keyframe[CurKeyframe].jpgBGXZ,false);
    if Keyframe[CurKeyframe].jpgBGYZ <> '' then SetImgFile(bmpBGYZe,Keyframe[CurKeyframe].jpgBGYZ,false);
  end;

  InvalidateAll;
end;

function TForm1.MaxTime: integer;
begin
  result:=round(dlgOptions.fseNormalAnimPeriod.value*1000);
end;

procedure TForm1.LockKeyframes1Click(Sender: TObject);
begin
  LockKeyframes1.Checked:=not LockKeyframes1.Checked;
  pbTimeline.Invalidate;
end;

procedure TForm1.Significant1Click(Sender: TObject);
begin
//  Keyframe[CurKeyframe].Significant:=not Keyframe[CurKeyframe].Significant;
//  Keyframe0Significant;
//  Modified:=true;
//  pbTimeline.Invalidate;
//  LoadTrackbars;
end;

procedure TForm1.SaveRestoreKeyframesMusclePos(Save,All: boolean);
const TempKeyframes: array of record Left: integer; posq: array [0..100] of record p:integer; Significant: boolean; end; end = nil;
var m,k: integer;
begin
  setlength(TempKeyframes,length(Keyframe));
  if All then
  begin
    for k:=0 to high(Keyframe) do
    if Save then
    begin
      TempKeyframes[k].Left:=Keyframe[k].TLTime;
      for m:=0 to high(Keyframe[k].posq) do
      begin
        TempKeyframes[k].posq[m].p:=Keyframe[k].posq[m].p;
        TempKeyframes[k].posq[m].Significant:=Keyframe[k].posq[m].Significant;
      end;
    end else
    begin
      Keyframe[k].TLTime:=TempKeyframes[k].Left;
      for m:=0 to high(Keyframe[k].posq) do
      begin
        Keyframe[k].posq[m].p:=TempKeyframes[k].posq[m].p;
        Keyframe[k].posq[m].Significant:=TempKeyframes[k].posq[m].Significant;
      end;
    end;
  end else
  begin
    if Save then
    begin
      for m:=0 to high(Keyframe[0].posq) do
        TempKeyframes[0].posq[m].p:=muscle[m].TrackBar.Position;
    end else
    begin
      for m:=0 to high(Keyframe[0].posq) do
        SetTrackBarPosition(m,TempKeyframes[0].posq[m].p);
    end;
  end;
end;

procedure TForm1.MovieYZ1Click(Sender: TObject);
begin
  Movie1.Visible:=true;
  Movie2.Visible:=False;
  TMenuItem(Sender).Checked:=true;
  dlgMovie.MovieBMPs.Clear;
  pnlRecordingMovie.Visible:=true;
end;

procedure TForm1.Movie1Click(Sender: TObject);
begin
  if pnlRecordingMovie.Visible then
    Panel4MouseDown(Sender,mbLeft,[],0,0);
end;

procedure TForm1.Panel4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  procedure WriteAnimatedGIFFile(filename: string; BMPs: TStrings; FramesPerSec: integer);
  var Image: TImage;
      i: integer;
      GIFImage: TGIFImage;
      Stream: TFileStream;
  begin
    try
      Image:=TImage.Create(Self);
      GifAnimateBegin;
      for i:=0 to BMPs.Count-1 do
      begin
        Image.Picture.LoadFromFile(BMPs[i]);
        GifAnimateAddImage(Image.Picture.Graphic,false,1000 div FramesPerSec);
      end;
      GIFImage:=GifAnimateEndGif;
      Stream:=TFileStream.Create(filename, fmCreate);
      GIFImage.SaveToStream(Stream);
    finally
      Stream.Free;
      Image.Free;
      GIFImage.Free;
    end;
  end;
const n: integer = 1;
var i: integer;
    BMPs: TStringList;
begin
  if pnlRecordingMovie.Visible then
  begin
    MovieXY1.Checked:=false;
    MovieXZ1.Checked:=false;
    MovieYZ1.Checked:=false;
    Movie3D1.Checked:=false;
    pnlRecordingMovie.Visible:=false;
    Movie1.Visible:=False;
    Movie2.Visible:=true;

    BMPs:=TStringList.Create;
    BMPs.Assign(dlgMovie.MovieBMPs);
    if (dlgMovie.MovieBMPs.Count > 0) and (dlgMovie.ShowModal = mrYes) then
    try
      Screen.Cursor:=crHourglass;
      while FileExists(ChangeToExePath('Mov'+inttostr(n)+'.avi')) or
            FileExists(ChangeToExePath('Mov'+inttostr(n)+'.gif')) do
        inc(n);
      WriteAnimatedGifFile(ChangeToExePath('Mov'+inttostr(n)+'.gif'),dlgMovie.MovieBMPs,dlgOptions.sePlaybackFPS.value);
      for i:=0 to BMPs.Count-1 do
        oldEraseFile(BMPs[i]);
    finally
      Screen.Cursor:=crDefault;
    end else
    begin
      if YesNoBox('Erase unused movie images?') then
        for i:=0 to BMPs.Count-1 do
          oldEraseFile(BMPs[i]);
    end;
    BMPs.Free;
  end;
end;

procedure TForm1.pbMuscleChartPaint(Sender: TObject);
var k,y: integer;
begin
  with pbMuscleChart,Canvas do
  begin
    if pnlMuscleChart.top < Splitter1.top then
      pnlMuscleChart.top:=10000;
    if Splitter1.top < pnlTimeline3.top then
      Splitter1.top:=10000;

    Brush.Color:=clWhite;
    FillRect(ClientRect);

    if InRange(CurMuscle,0,high(muscle)) then
    begin
      y:=(Height-1)*(Keyframe[0].posq[CurMuscle].p-muscle[CurMuscle].TrackBar.min) div (muscle[CurMuscle].TrackBar.max-muscle[CurMuscle].TrackBar.min);
      MoveTo(0,y);
      for k:=0 to high(Keyframe) do
        if Keyframe[k].posq[CurMuscle].Significant then
        begin
          LineTo(TLTimeToX(Keyframe[K].TLTime)+pnlTimelineRed.Width div 2,y);
          y:=(Height-1)*(Keyframe[k].posq[CurMuscle].p-muscle[CurMuscle].TrackBar.min) div (muscle[CurMuscle].TrackBar.max-muscle[CurMuscle].TrackBar.min);
          LineTo(TLTimeToX(Keyframe[K].TLTime)+pnlTimelineRed.Width div 2,y);
        end;
      LineTo(width,y);
    end;
  end;
end;

procedure TForm1.MuscleChart1Click(Sender: TObject);
begin
  pnlMuscleChart.Visible:=not pnlMuscleChart.Visible;
  Splitter1.Visible:=pnlMuscleChart.Visible;
end;

procedure TForm1.Keyframe0Significant;
var m: integer;
begin
  for m:=0 to high(muscle) do
    Keyframe[0].posq[m].Significant:= true;
end;

procedure TForm1.CurrentMuscleSignificant1Click(Sender: TObject);
begin
  if (CurKeyframe >= 0) and InRange(CurMuscle,0,high(muscle)) then
    Keyframe[CurKeyframe].posq[CurMuscle].Significant:=not Keyframe[CurKeyframe].posq[CurMuscle].Significant;
  Keyframe0Significant;
  Modified:=true;
  LoadTrackbars;
  pbTimeline.Invalidate;
  pbMuscleChart.Invalidate;
end;

procedure TForm1.AllSignificant1Click(Sender: TObject);
var m: integer;
begin
  if CurKeyframe >= 0 then
    for m:=0 to high(muscle) do
      Keyframe[CurKeyframe].posq[m].Significant:=true;
  Keyframe0Significant;
  Modified:=true;
  LoadTrackbars;
  pbTimeline.Invalidate;
  pbMuscleChart.Invalidate;
end;

procedure TForm1.NoneSignificant1Click(Sender: TObject);
var m: integer;
begin
  if CurKeyframe >= 0 then
    for m:=0 to high(muscle) do
      Keyframe[CurKeyframe].posq[m].Significant:=false;
  Keyframe0Significant;
  Modified:=true;
  LoadTrackbars;
  pbTimeline.Invalidate;
  pbMuscleChart.Invalidate;
end;

procedure TForm1.StrutName1Click(Sender: TObject);
var b: TStrutRef;
    a: TAtomRef;
    s: string;
    t: TstringList;
const sValue: string = '';
begin
  try
    t:=TstringList.Create;
    for b:=1 to NumStruts do
      with Struts[b] do
      begin
        s:=uppercase(StrutName);
        while s <> '' do
        begin
          AddUnique(t,Before(s,'/'),false);
          s:=After(s,'/');
        end;
        AddUnique(t,s,false);
      end;

    if not InputComboQueryEx('Sim3D','Strut name',t.text,sValue,csDropDownList,true) then
      exit;

    if Sender = StrutName1 then
    begin
      for b:=1 to NumStruts do
        with Struts[b] do
          Selected:=StrutSelected(b) and (pos(uppercase('/'+sValue+'/'),uppercase('/'+StrutName+'/')) <> 0);
      for a:=1 to NumAtoms do
        Atoms[a].Selected:=false;
    end else
    begin
      for b:=1 to NumStruts do
        with Struts[b] do
          if pos(uppercase('/'+sValue+'/'),uppercase('/'+StrutName+'/')) <> 0 then
            Selected:=false;
    end;

    InvalidateAll;
  ChkPoly;
  finally
    t.free;
  end;
end;

procedure TForm1.ImportANSYS1Click(Sender: TObject);
begin
  Stop;
  if SaveIfModified(true) then
  if dlgImportNodes.ShowModal = mrOK then
  begin
    if FileExists(dlgImportNodes.Edit1.Text) then
      ImportANSYS(dlgImportNodes.Edit1.Text,dlgImportNodes.cbMakePolygons.Checked,
        dlgImportNodes.cbMakePolyhedra.Checked,dlgImportNodes.cbReadMuscles.Checked,dlgImportNodes.cbMergeLeftRightMuscles.Checked,dlgImportNodes.SpinEdit1.Value);
    if FileExists(dlgImportNodes.Edit2.Text) then
      OpenFibresFile(dlgImportNodes.Edit2.Text,dlgImportNodes.cbMergeLeftRightMuscles.Checked);
  end;
end;

procedure TForm1.ImportANSYS(filename: string; bMakePolygons,bMakePolyhedra,bReadMuscles,bMergeLeftRightMuscles: Boolean; Scale: integer);
  function MyAtomNum(refnum: integer): integer;
  begin
    for result:=1 to NumAtoms do
      with Atoms[result] do
        if refnum = impNum then
          exit;
    result:=0;
  end;
  procedure ReadAtoms;
  var i,j: integer;
      ax,ay,az: double;
      s: string;
      StringList: TStringList;
      a: TAtomRef;
      xmin,ymin,zmin: single;
      xmax,ymax,zmax: single;
  begin
    StringList:=TStringList.Create;
    StringList.LoadfromFile(ChangeFileExt(filename,'.node'));

    for i:=0 to StringList.count-1 do
//if i < 946 then
    begin
      s:=StringList[i];
      if NextIsNumber(s,j) then
      if NextIsSignedDouble(s,ax) then
      if NextIsSignedDouble(s,ay) then
      if NextIsSignedDouble(s,az) then
      with Atoms[NewAtom(scale*ay,-scale*ax,scale*az,DefaultMass)] do
      begin
//        impNum:=i+1;
        impNum:=j;
      end;
    end;
    StringList.Free;

    {centralise}
    xmax:=-maxint;
    ymax:=-maxint;
    zmax:=-maxint;
    xmin:=maxint;
    ymin:=maxint;
    zmin:=maxint;
    for a:=1 to NumAtoms do
    begin
      xmin:=min(xmin,Atoms[a].p.x);
      xmax:=max(xmax,Atoms[a].p.x);
      ymin:=min(ymin,Atoms[a].p.y);
      ymax:=max(ymax,Atoms[a].p.y);
      zmin:=min(zmin,Atoms[a].p.z);
      zmax:=max(zmax,Atoms[a].p.z);
    end;
    for a:=1 to NumAtoms do
    begin
//      Atoms[a].p.x:=Atoms[a].p.x-(xmax+xmin)/2;
      Atoms[a].p.y:=Atoms[a].p.y-(ymax+ymin)/2;
      Atoms[a].p.z:=Atoms[a].p.z-zmin;
    end;
  end;
  procedure ReadStruts;
    procedure AddLine(a1,a2: integer; {col: TColor; }aAxis: TAxis; refnum: integer; aname: string);
    var i,j,k: integer;
    begin
      if a1 = a2 then
        exit;
      if a1 = 0 then
        exit;
      if a2 = 0 then
        exit;
      a1:=MyAtomNum(a1);
      a2:=MyAtomNum(a2);
      i:=FindStrut(a1,a2);
      if i <> 0 then    //if strut has already been assigned to an element then
      with Struts[i] do
      begin
        for j:=1 to  high(struts[i].impNum) do               //look through all the elements assigned to this strut
          if  refnum = impNum[j] then                        //is it an element that has already been assigned
            exit;                                            //if yes then exit
        for j:=1 to  high(struts[i].impNum) do
          if  impNum[j] = 0 then
          begin
            impNum[j]:=refnum;
            exit;
          end;
        assert(false,'impNum array has been exceeded');
      end else
      with Struts[NewStrut(A1,A2,Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,false,aAxis)] do
      begin
        impNum[1]:=refnum;      //but strut can be assigned to lots of elements.
        strutName:=aname;
      end;
    end;
    function MakePoly(a1,a2,a3,a4: TAtomRef): integer;
    begin
      result:=-1;
      if ord(a1 <> 0)+ord(a2 <> 0)+ord(a3 <> 0)+ord(a4 <> 0) < 3 then exit;
      if a1 = 0  then begin a1:=a2; a2:=a3; a3:=a4; a4:=0; end;
      if a2 = 0  then begin         a2:=a3; a3:=a4; a4:=0; end;
      if a3 = 0  then begin                 a3:=a4; a4:=0; end;
      if a1 = a2 then begin         a2:=a3; a3:=a4; a4:=0; end;
      if a1 = a3 then begin                 a3:=a4; a4:=0; end;
      if a1 = a4 then begin                         a4:=0; end;
      if a2 = a3 then begin                 a3:=a4; a4:=0; end;
      if a2 = a4 then begin                         a4:=0; end;
      if a3 = a4 then begin                         a4:=0; end;
      if a3 = 0  then exit;

      a1:=MyAtomNum(a1);
      a2:=MyAtomNum(a2);
      a3:=MyAtomNum(a3);
      a4:=MyAtomNum(a4);
      result:=NewPolygon(a1,a2,a3,a4,0);
    end;
  var i,j,k,a1,a2,a3,a4,a5,a6,a7,a8,a9,aA,aB,aC,aD,aE,c: integer;
      aname,s: string;
      StringList: TStringList;
      poly1,poly2,poly3,poly4,poly5,poly6,polyh: integer;
  begin
    StringList:=TStringList.Create;
    StringList.LoadfromFile(ChangeFileExt(filename,'.elem'));
    for i:=0 to StringList.count-1 do
    begin
      s:=StringList[i];
      if NextIsNumber(s,a1) then
      if NextIsNumber(s,a2) then
      if NextIsNumber(s,a3) then
      if NextIsNumber(s,a4) then
      if NextIsNumber(s,a5) then
      if NextIsNumber(s,a6) then
      if NextIsNumber(s,a7) then
      if NextIsNumber(s,a8) then
      if NextIsNumber(s,a9) then
      if NextIsNumber(s,aA) then
      if NextIsNumber(s,aB) then
      if NextIsNumber(s,aC) then
      if NextIsNumber(s,aD) then
      if NextIsNumber(s,aE) then
      begin
        s:='';
        case a1 of 0: s:=s+'0'; 1: s:=s+'1'; 911: s:=s+'a'; 912: s:=s+'b'; 913: s:=s+'c'; 921: s:=s+'d'; 932: s:=s+'e'; 931: s:=s+'f'; 933: s:=s+'g'; 951: s:=s+'h'; 941: s:=s+'i'; else s:=s+'n'; end;
        case a2 of 0: s:=s+'0'; 1: s:=s+'1'; 911: s:=s+'a'; 912: s:=s+'b'; 913: s:=s+'c'; 921: s:=s+'d'; 932: s:=s+'e'; 931: s:=s+'f'; 933: s:=s+'g'; 951: s:=s+'h'; 941: s:=s+'i'; else s:=s+'n'; end;
        case a3 of 0: s:=s+'0'; 1: s:=s+'1'; 911: s:=s+'a'; 912: s:=s+'b'; 913: s:=s+'c'; 921: s:=s+'d'; 932: s:=s+'e'; 931: s:=s+'f'; 933: s:=s+'g'; 951: s:=s+'h'; 941: s:=s+'i'; else s:=s+'n'; end;
        case a4 of 0: s:=s+'0'; 1: s:=s+'1'; 911: s:=s+'a'; 912: s:=s+'b'; 913: s:=s+'c'; 921: s:=s+'d'; 932: s:=s+'e'; 931: s:=s+'f'; 933: s:=s+'g'; 951: s:=s+'h'; 941: s:=s+'i'; else s:=s+'n'; end;
        case a5 of 0: s:=s+'0'; 1: s:=s+'1'; 911: s:=s+'a'; 912: s:=s+'b'; 913: s:=s+'c'; 921: s:=s+'d'; 932: s:=s+'e'; 931: s:=s+'f'; 933: s:=s+'g'; 951: s:=s+'h'; 941: s:=s+'i'; else s:=s+'n'; end;
        case a6 of 0: s:=s+'0'; 1: s:=s+'1'; 911: s:=s+'a'; 912: s:=s+'b'; 913: s:=s+'c'; 921: s:=s+'d'; 932: s:=s+'e'; 931: s:=s+'f'; 933: s:=s+'g'; 951: s:=s+'h'; 941: s:=s+'i'; else s:=s+'n'; end;
        case a7 of 0: s:=s+'0'; 1: s:=s+'1'; 911: s:=s+'a'; 912: s:=s+'b'; 913: s:=s+'c'; 921: s:=s+'d'; 932: s:=s+'e'; 931: s:=s+'f'; 933: s:=s+'g'; 951: s:=s+'h'; 941: s:=s+'i'; else s:=s+'n'; end;
        case a8 of 0: s:=s+'0'; 1: s:=s+'1'; 911: s:=s+'a'; 912: s:=s+'b'; 913: s:=s+'c'; 921: s:=s+'d'; 932: s:=s+'e'; 931: s:=s+'f'; 933: s:=s+'g'; 951: s:=s+'h'; 941: s:=s+'i'; else s:=s+'n'; end;
        case a9 of 0: s:=s+'0'; 1: s:=s+'1'; 911: s:=s+'a'; 912: s:=s+'b'; 913: s:=s+'c'; 921: s:=s+'d'; 932: s:=s+'e'; 931: s:=s+'f'; 933: s:=s+'g'; 951: s:=s+'h'; 941: s:=s+'i'; else s:=s+'n'; end;
        case aA of 0: s:=s+'0'; 1: s:=s+'1'; 911: s:=s+'a'; 912: s:=s+'b'; 913: s:=s+'c'; 921: s:=s+'d'; 932: s:=s+'e'; 931: s:=s+'f'; 933: s:=s+'g'; 951: s:=s+'h'; 941: s:=s+'i'; else s:=s+'n'; end;
        case aB of 0: s:=s+'0'; 1: s:=s+'1'; 911: s:=s+'a'; 912: s:=s+'b'; 913: s:=s+'c'; 921: s:=s+'d'; 932: s:=s+'e'; 931: s:=s+'f'; 933: s:=s+'g'; 951: s:=s+'h'; 941: s:=s+'i'; else s:=s+'n'; end;
        case aC of 0: s:=s+'0'; 1: s:=s+'1'; 911: s:=s+'a'; 912: s:=s+'b'; 913: s:=s+'c'; 921: s:=s+'d'; 932: s:=s+'e'; 931: s:=s+'f'; 933: s:=s+'g'; 951: s:=s+'h'; 941: s:=s+'i'; else s:=s+'n'; end;

        aname:='default';
        if copy(s,5,8) = '0000dda1' then aname:='palate';
        if copy(s,5,8) = '0000efe1' then aname:='pharynx';
        if copy(s,5,8) = '0000gfg1' then aname:='jaw';
        if copy(s,1,12) = 'nnnnnnnnh1h1'       then aname:='hyoid';
        if copy(s,9,4) = '1111'       then aname:='tongue';

        AddLine(a1,a2,axX,aE,aname);
        AddLine(a3,a4,axX,aE,aname);
        AddLine(a5,a6,axX,aE,aname);
        AddLine(a7,a8,axX,aE,aname);

        AddLine(a1,a5,axX,aE,aname);
        AddLine(a2,a6,axX,aE,aname);
        AddLine(a3,a7,axX,aE,aname);
        AddLine(a4,a8,axX,aE,aname);

        AddLine(a1,a4,axX,aE,aname);
        AddLine(a2,a3,axX,aE,aname);
        AddLine(a5,a8,axX,aE,aname);
        AddLine(a6,a7,axX,aE,aname);

        if bMakePolygons then
        begin
          poly1:=MakePoly(a1,a2,a6,a5);
          poly2:=MakePoly(a4,a8,a7,a3);
          poly3:=MakePoly(a1,a5,a8,a4);
          poly4:=MakePoly(a2,a3,a7,a6);
          poly5:=MakePoly(a4,a3,a2,a1);
          poly6:=MakePoly(a5,a6,a7,a8);
        end;
        if a7 <> 0 then
        begin
          AddLine(a1,a6,axNone,aE,'');
          AddLine(a2,a5,axNone,aE,'');
          AddLine(a4,a7,axNone,aE,'');
          AddLine(a3,a8,axNone,aE,'');

          AddLine(a1,a3,axNone,aE,'');
          AddLine(a2,a4,axNone,aE,'');
          AddLine(a5,a7,axNone,aE,'');
          AddLine(a6,a8,axNone,aE,'');

          AddLine(a1,a8,axNone,aE,'');
          AddLine(a4,a5,axNone,aE,'');
          AddLine(a2,a7,axNone,aE,'');
          AddLine(a3,a6,axNone,aE,'');
          if bMakePolygons and bMakePolyhedra and (aname = 'tongue') then
          begin
            polyh:=NewPolyhedron([poly1,poly2,poly3,poly4,poly5,poly6],[]);
            if Polyhedron[polyh].Volume < 0 then
            begin
              SetLength(Polyhedron,length(Polyhedron)-1);
              polyh:=NewPolyhedron([],[poly1,poly2,poly3,poly4,poly5,poly6]);
            end else
            if Polyhedron[polyh].Volume = 0 then
            begin
              SetLength(Polyhedron,length(Polyhedron)-1);
            end;
          end;
        end;
      end;
    end;
    StringList.Free;
  end;
  procedure ReadMuscles;
    procedure SetName(i: integer; s: string);
    var j,k: integer;
    begin
      for j:=1 to NumStruts do
        with Struts[j] do
          for k:=1 to high(impNum) do
            if i = impNum[k] then     //strut can belong to up to 4 elements of the same muscle  but don't want to assign the name more than once
              if pos(uppercase('/'+s+'/'),uppercase('/'+StrutName+'/')) = 0 then
              begin
                StrutName:=StrutName+'/'+s;
                assert(length(StrutName) <= sizeof(StrutName)-1,'length of StrutName has been exceeded');
              end;
    end;
    procedure ChangeNames(s1,s2: string);
    var b: TStrutRef;
    begin
      for b:=1 to NumStruts do
        with Struts[b] do
          StrutName:=StrReplace(StrutName,s1,s2,true);
    end;
  var i,j,j1,j2,incj: integer;
      s: string;
      StringList: TStringList;
      first: boolean;
      b: TStrutRef;
  begin
    StringList:=TStringList.Create;
    StringList.LoadfromFile(ChangeFileExt(filename,'.mac'));
    MuscleList.Free;
    MuscleList:=TStringList.Create;
    for i:=0 to StringList.count-1 do
    begin
      s:=StringList[i];
      first:=false;
      if NextIs(s,'ESEL') then
      if NextIs(s,',') then
      begin
        if NextIs(s,'S') then
          first:=true else
          NextIs(s,'A');

        if NextIs(s,',') then
        if NextIs(s,'ELEM') then
        if NextIs(s,',') then
        if NextIs(s,',') then
        if NextIsNumber(s,j1) then
        begin
          j2:=j1;
          if NextIs(s,',') then
            NextIsNumber(s,j2);
          incj:=1;
          if NextIs(s,',') then
            NextIsNumber(s,incj);
          j:=j1;
          while j <= j2 do
          begin
            SetName(j,#1);
            j:=j+incj;
          end;
        end;
      end;

      if NextIs(s,'CM') then
      if NextIs(s,',') then
      begin
        ChangeNames(#1,'X_'+Before(s,','));
      end;

      if NextIs(s,'muscleName') then
      if NextIs(s,'(') then
      if NextIsNumber(s,j) then
      if NextIs(s,')') then
      if NextIs(s,'=') then
      if NextIs(s,'''') then
      begin
        while MuscleList.Count <= j do
          MuscleList.Add('muscle'+Inttostr(MuscleList.Count));
        s:=Before(s,'''');
        MuscleList[j]:=s;
        s:=uppercase(s);
        if bMergeLeftRightMuscles then
        begin
          if copy(s,length(s)-1,2) = '_L' then
            delete(s,length(s)-1,2);
          if copy(s,length(s)-1,2) = '_R' then
            delete(s,length(s)-1,2);
        end;
        NewMuscle(s,true);
      end;
    end;

    for b:=1 to NumStruts do
      with Struts[b] do
        if copy(StrutName,1,1) = '/' then
          delete(StrutName,1,1);
    StringList.Free;
  end;
begin
  Assert(FileExists(ChangeFileExt(filename,'.node')));
  Assert(FileExists(ChangeFileExt(filename,'.elem')));
//  Assert(FileExists(ChangeFileExt(filename,'.mac')));

  ClearAll(false);
  try
    Screen.Cursor:=crHourglass;
    try
      ClearAll(false);

      ReadAtoms;
      ReadStruts;
      if bReadMuscles and FileExists(ChangeFileExt(filename,'.mac')) then
        ReadMuscles;

      SetupStruts;
      FixSymmetryAtoms;
      CheckAllKeyframes;
      Keyframe0Significant;
      ChkPoly;
      StopAllAtoms(false);
    except
      ShowErrorMessage('Error while reading file: '+filename);
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
  SavedPosition:=AtomsToString(true);
  SetMainFilename(ChangeFileExt(filename,'.s3d'));
  tcModeChange(Self);
  SpeedButton4Click(nil);
  InvalidateAll;
ChkPoly;
  Modified:=true;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
var xmin,ymin,zmin: single;
    xmax,ymax,zmax: single;
var imin,jmin,imax,jmax: integer;
{
  function GetMin(Axes: TAxes; minx,miny: integer): TPoint;
  begin
    result:=Proj2DZoom(a3DPoint(xmin,ymin,zmin),Axes);
    result.x:=min(result.x,minx);
    result.y:=min(result.y,miny);
  end;
  function GetMax(Axes: TAxes; maxx,maxy: integer): TPoint;
  begin
    result:=Proj2DZoom(a3DPoint(xmax,ymax,zmax),Axes);
    result.x:=max(result.x,maxx);
    result.y:=max(result.y,maxy);
  end;
}
var min2d,max2d,zero2d: TPoint;
    a: TAtomRef;
    p1,p2: TPoint;
    z1,z2,z3,z4,z5,z6,z7: single;
begin
  MouseMode:=mmNone;
  xmax:=-maxint;
  ymax:=-maxint;
  zmax:=-maxint;
  xmin:=maxint;
  ymin:=maxint;
  zmin:=maxint;
  for a:=1 to NumAtoms do
  begin
    xmin:=min(xmin,Atoms[a].p.x);
    xmax:=max(xmax,Atoms[a].p.x);
    ymin:=min(ymin,Atoms[a].p.y);
    ymax:=max(ymax,Atoms[a].p.y);
    zmin:=min(zmin,Atoms[a].p.z);
    zmax:=max(zmax,Atoms[a].p.z);
  end;

  Zoom:=1;
  bOfs2DX:=0;
  aOfs2DY:=0;
  aOfs2DZ:=0;
  min2d:=Proj2DZoom(a3DPoint(xmin,ymin,zmin),plYZ);
  max2d:=Proj2DZoom(a3DPoint(xmax,ymax,zmax),plYZ);
  zero2d:=Proj2DZoom(a3DPoint(0,0,0),plYZ);
  z1:=imgYZ.Width/2/max(zero2d.x-min2d.x,max2d.x-zero2d.x);
  z2:=imgYZ.Height/(zero2d.y-max2d.y);

  min2d:=Proj2DZoom(a3DPoint(xmin,ymin,zmin),plXY);
  max2d:=Proj2DZoom(a3DPoint(xmax,ymax,zmax),plXY);
  zero2d:=Proj2DZoom(a3DPoint(0,0,0),plXY);
  z3:=imgXY.Height/2/max(zero2d.y-max2d.y,min2d.y-zero2d.y);
  z4:=imgXY.Width/2/max(zero2d.x-min2d.x,max2d.x-zero2d.x);

  min2d:=Proj2DZoom(a3DPoint(xmin,ymin,zmin),plXZ);
  max2d:=Proj2DZoom(a3DPoint(xmax,ymax,zmax),plXZ);
  zero2d:=Proj2DZoom(a3DPoint(0,0,0),plXZ);
  z5:=imgXZ.Width/2/max(zero2d.x-min2d.x,max2d.x-zero2d.x);
  z6:=imgXZ.Height/(zero2d.y-max2d.y);

  Ofs3DX:=0;
  Ofs3DY:=0;
  Proj3DZoom(a3DPoint(0,0,0),p2);
  imin:=p2.x;
  jmin:=p2.x+1;
  imax:=p2.y;
  jmax:=p2.y+1;

  Proj3DZoom(a3DPoint(xmax,ymax,zmax),p1); SetMinMax(p1.x,imin,imax);SetMinMax(p1.y,jmin,jmax);
  Proj3DZoom(a3DPoint(xmax,ymax,zmin),p1); SetMinMax(p1.x,imin,imax);SetMinMax(p1.y,jmin,jmax);
  Proj3DZoom(a3DPoint(xmax,ymin,zmax),p1); SetMinMax(p1.x,imin,imax);SetMinMax(p1.y,jmin,jmax);
  Proj3DZoom(a3DPoint(xmax,ymin,zmin),p1); SetMinMax(p1.x,imin,imax);SetMinMax(p1.y,jmin,jmax);
  Proj3DZoom(a3DPoint(xmin,ymax,zmax),p1); SetMinMax(p1.x,imin,imax);SetMinMax(p1.y,jmin,jmax);
  Proj3DZoom(a3DPoint(xmin,ymax,zmin),p1); SetMinMax(p1.x,imin,imax);SetMinMax(p1.y,jmin,jmax);
  Proj3DZoom(a3DPoint(xmin,ymin,zmax),p1); SetMinMax(p1.x,imin,imax);SetMinMax(p1.y,jmin,jmax);
  Proj3DZoom(a3DPoint(xmin,ymin,zmin),p1); SetMinMax(p1.x,imin,imax);SetMinMax(p1.y,jmin,jmax);
  z7:=0.9*min(img3D.Width/(imax-imin),img3D.Height/(jmax-jmin));

  Zoom:=0.95*min(min(min(min(min(min(z2,z1),z3),z4),z5),z6),z7);

  zero2d:=Proj2DZoom(a3DPoint(0,0,0),plYZ);
  aOfs2DY:=-round(zero2d.x-imgYZ.Width/2);
  aOfs2DZ:=-round(zero2d.y-imgYZ.Height)-1;

  zero2d:=Proj2DZoom(a3DPoint(0,0,0),plXY);
  bOfs2DX:=-round(zero2d.x-imgXY.Width/2);

  Ofs3DX:=0;
  Ofs3DY:=0;
  Proj3DZoom(a3DPoint((xmax+xmin)/2,(ymax+ymin)/2,(zmax+zmin)/2),p1);
  with p1 do
  begin
    Ofs3DX:=img3D.Width div 2-x;
    Ofs3DY:=img3D.Height div 2-y;
  end;
  InvalidateAll;
end;

procedure TForm1.test2Click(Sender: TObject);
begin
  Stop;
  if SaveIfModified(true) then
  begin
    dlgImportNodes.OpenDialog4.Filename:='C:\Delphi 4\Clinasst\Import artisynth\mesh3\tongueIcp.3.node';
    ImportANSYS(dlgImportNodes.OpenDialog4.Filename,true,true,true,true,6000);
    dlgImportNodes.OpenDialog1.Filename:='C:\Delphi 4\Clinasst\Import artisynth\mesh3\Fibers.mac';
    OpenFibresFile(dlgImportNodes.OpenDialog1.Filename,true);
  end;
end;

procedure TForm1.SelectAll2Click(Sender: TObject);
var a: TAtomRef;
var b: TStrutRef;
begin
  for a:=1 to NumAtoms do
    with Atoms[a] do
      Selected:=not neglect;
  for b:=1 to NumStruts do
    with Struts[b] do
      Selected:=not Atoms[Atom1].neglect and not Atoms[Atom2].neglect;
  InvalidateAll;
ChkPoly;
end;

function TForm1.HasCloseAtoms: boolean;
var b: TStrutRef;
begin
  result:=true;
  for b:=1 to NumStruts do
    if Struts[b].RestLength <= MinRestLength then
      exit;
  result:=false;
end;

procedure TForm1.OpenFibresFile(filename: string; bMergeLeftRightMuscles: Boolean);
  function MyAtomNum(refnum: integer): integer;
  begin
    for result:=1 to NumAtoms do
      with Atoms[result] do
        if refnum = impNum then
          exit;
    result:=0;
  end;
  procedure AssignMuscle(a1,a2,m: integer);
    procedure AddToMusc(b: TStrutRef; s: string);
    var m1: integer;
    begin
      s:=uppercase(MuscleList[m]);
      if bMergeLeftRightMuscles then
      begin
        if copy(s,length(s)-1,2) = '_L' then
          delete(s,length(s)-1,2);
        if copy(s,length(s)-1,2) = '_R' then
          delete(s,length(s)-1,2);
      end;
      for m1:=0 to high(muscle) do
        if uppercase(Before(muscle[m1].Label1.Caption,'=')) = s then
          Struts[b].musc:=m1;
    end;
  var i,m1: integer;
      s: string;
  begin
    a1:=MyAtomNum(a1);
    a2:=MyAtomNum(a2);
    i:=FindStrut(a1,a2);
    if i <> 0 then
    with Struts[i] do
    begin
      while MuscleList.Count <= m do
        MuscleList.Add('muscle'+Inttostr(MuscleList.Count));
      if pos(uppercase('/'+MuscleList[m]+'/'),uppercase('/'+StrutName+'/')) = 0 then
      begin
        StrutName:=StrutName+'/'+MuscleList[m];
        if copy(StrutName,1,1) = '/' then
          delete(StrutName,1,1);
        AddToMusc(i,MuscleList[m]);
      end;
    end else
    begin
      i:=NewStrut(A1,A2,Maxint,dlgOptions.seStrutElasticityR.Value,dlgOptions.seStrutElasticityC.Value,false,axX);
      with Struts[i] do
      begin
        while MuscleList.Count <= m do
          MuscleList.Add('muscle'+Inttostr(MuscleList.Count));
        strutName:=MuscleList[m];
        AddToMusc(i,MuscleList[m]);
      end;
    end;
  end;
var i,j1,j2,j3,j4,j1prev,j2prev,j3prev,j4prev: integer;
    s: string;
    StringList: TStringList;
    b: TStrutRef;
begin
  try
    Screen.Cursor:=crHourglass;
    try
      StringList:=TStringList.Create;
      StringList.LoadfromFile(filename);
      SelectStrut(0,false);
      j1prev:=-1;
      j2prev:=-1;
      j3prev:=-1;
      j4prev:=-1;
      for i:=0 to StringList.count-1 do
      begin
        s:=StringList[i];

        if NextIs(s,'Fiber') and NextIs(s,'(') then
        begin
          if NextIsNumber(s,j1) then
          if NextIs(s,',') then
          if NextIsNumber(s,j2) then
          if NextIs(s,',') then
          if NextIsNumber(s,j3) then
          if NextIs(s,')') then
          if NextIs(s,'=') then
          if NextIsNumber(s,j4) then
          begin
            if (j1 = j1prev+1) and (j2 = j2prev) then
              AssignMuscle(j4,j4prev,j3);
            j1prev:=j1;
            j2prev:=j2;
            j3prev:=j3;
            j4prev:=j4;
          end;
        end;
      end;

      SetupStruts;
      FixSymmetryAtoms;
      CheckAllKeyframes;
      Keyframe0Significant;
      ChkPoly;
      StopAllAtoms(false);
    except
      ShowErrorMessage('Error while reading file: '+filename);
    end;
  finally
    Screen.Cursor:=crDefault;
  end;
  SavedPosition:=AtomsToString(true);
  tcModeChange(Self);
  SpeedButton4Click(nil);
  InvalidateAll;
ChkPoly;
  Modified:=true;
end;

procedure TForm1.ExportANSYS1Click(Sender: TObject);
  procedure WriteNodes(filename: string);
  var Scale: single;
      a: TAtomRef;
      s: TStringList;
  begin
    try
      s:=TStringList.Create;

      scale:=0;
      for a:=1 to NumAtoms do
      with Atoms[a] do
      begin
        scale:=max(scale,+p.x);
        scale:=max(scale,-p.x);
        scale:=max(scale,+p.y);
        scale:=max(scale,-p.y);
        scale:=max(scale,+p.z);
        scale:=max(scale,-p.z);
      end;

      for a:=1 to NumAtoms do
        with Atoms[a] do
          s.Add(
            lpad(inttostr(a),8)+' '+
            lpad(FixedPointStr(p.x/scale,6),20)+' '+
            lpad(FixedPointStr(p.y/scale,6),20)+' '+
            lpad(FixedPointStr(p.z/scale,6),20));

      s.SaveToFile(filename);
    finally
      s.Free;
    end;
  end;
  procedure WriteElems(filename: string);
  var fa: array[1..8] of integer;
      spare: array[1..4] of integer;
    procedure AddFace(a,b,c,d: integer);
    begin
      if d = 0 then
        d:=c;

      if fa[1] = 0 then
      begin
        fa[1]:=a;
        fa[2]:=b;
        fa[3]:=c;
        fa[4]:=d;
      end else
      if (a = fa[2]) and (b = fa[1]) then begin fa[5]:=c; fa[6]:=d; end else
      if (b = fa[2]) and (c = fa[1]) then begin fa[5]:=d; fa[6]:=a; end else
      if (c = fa[2]) and (d = fa[1]) then begin fa[5]:=a; fa[6]:=b; end else
      if (d = fa[2]) and (a = fa[1]) then begin fa[5]:=b; fa[6]:=c; end else

      if (a = fa[3]) and (b = fa[2]) then begin fa[6]:=c; fa[7]:=d; end else
      if (b = fa[3]) and (c = fa[2]) then begin fa[6]:=d; fa[7]:=a; end else
      if (c = fa[3]) and (d = fa[2]) then begin fa[6]:=a; fa[7]:=b; end else
      if (d = fa[3]) and (a = fa[2]) then begin fa[6]:=b; fa[7]:=c; end else

      if (a = fa[4]) and (b = fa[3]) then begin fa[7]:=c; fa[8]:=d; end else
      if (b = fa[4]) and (c = fa[3]) then begin fa[7]:=d; fa[8]:=a; end else
      if (c = fa[4]) and (d = fa[3]) then begin fa[7]:=a; fa[8]:=b; end else
      if (d = fa[4]) and (a = fa[3]) then begin fa[7]:=b; fa[8]:=c; end else

      if (a = fa[1]) and (b = fa[4]) then begin fa[8]:=c; fa[5]:=d; end else
      if (b = fa[1]) and (c = fa[4]) then begin fa[8]:=d; fa[5]:=a; end else
      if (c = fa[1]) and (d = fa[4]) then begin fa[8]:=a; fa[5]:=b; end else
      if (d = fa[1]) and (a = fa[4]) then begin fa[8]:=b; fa[5]:=c; end else
      begin
        spare[1]:=a;
        spare[2]:=b;
        spare[3]:=c;
        spare[4]:=d;
      end; 
    end;
    procedure TryFace(Face: Tarrayofinteger; IsPos: boolean);
    var i,f: integer;
        b: TStrutRef;
    begin
      for f:=low(Face) to high(Face) do
        with Polygons[Face[f]] do
          if IsPos then
            AddFace(a[1],a[2],a[3],a[4]) else
            AddFace(a[4],a[3],a[2],a[1]);
      if spare[1] <> 0 then
        AddFace(spare[1],spare[2],spare[3],spare[4]);
    end;
  var s: TStringList;
      ph: integer;
  begin
    try
      s:=TStringList.Create;
      for ph:=0 to high(Polyhedron) do
      begin
        Fillchar(fa,sizeof(fa),0);
        Fillchar(spare,sizeof(spare),0);

        TryFace(Polyhedron[ph].PosFace,true);
        TryFace(Polyhedron[ph].NegFace,false);

        s.Add(
          lpad(inttostr(fa[1]),6)+
          lpad(inttostr(fa[2]),6)+
          lpad(inttostr(fa[3]),6)+
          lpad(inttostr(fa[4]),6)+
          lpad(inttostr(fa[5]),6)+
          lpad(inttostr(fa[6]),6)+
          lpad(inttostr(fa[7]),6)+
          lpad(inttostr(fa[8]),6)+
          '     1     1     1     1     0'+
          lpad(inttostr(ph+1),6));
      end;

      s.SaveToFile(filename);
    finally
      s.Free;
    end;
  end;
  procedure WriteMAC(filename: string);
    function TryFace(Face: array of integer; m: integer): integer;
    var i,f: integer;
        b: TStrutRef;
    begin
      result:=0;
      for f:=low(Face) to high(Face) do
        with Polygons[Face[f]] do
        begin
          for i:=1 to 4 do
          begin
            b:=FindStrut(a[i mod 4 +1],a[(i+1) mod 4 +1]);
            if (b <> 0) and (struts[b].musc = m) then
              inc(result);
          end;
        end;
    end;
  var s: TStringList;
      m: integer;
      c: char;
      ph: integer;
  begin
    try
      s:=TStringList.Create;
      s.Add('! -------------------------------------------------------------------');
      s.Add('! From 3DsimGG');
      s.Add('');
      s.Add('nb_muscles = '+inttostr(high(muscle)+1));
      s.Add('');

      s.Add('! Array for muscles names');
      s.Add('*DIM, muscleName, CHAR, nb_muscles');
      for m:=0 to high(muscle) do
        s.Add('muscleName('+inttostr(m+1)+') = '''+Before(muscle[m].Label1.Caption,'=')+'''');

      c:='S';
      for m:=0 to high(muscle) do
      begin
        s.Add('');
        s.Add('!_________________________________________');
        s.Add('! Description of '+Before(muscle[m].Label1.Caption,'='));

        for ph:=0 to high(Polyhedron) do
        begin
          if TryFace(Polyhedron[ph].PosFace,m)+TryFace(Polyhedron[ph].NegFace,m) > 2 then
            s.Add('ESEL,'+c+',ELEM,,'+inttostr(ph+1));
          c:='A';
        end;

        s.Add('CM,'+Before(muscle[m].Label1.Caption,'=')+',ELEM');
      end;

      s.SaveToFile(filename);
    finally
      s.Free;
    end;
  end;
  procedure WriteFibres(filename: string);
  var a: TAtomRef;
      s1,s2,s3,s4: TStringList;
      b: TStrutRef;
      m,n,nmax: integer;
  begin
    try
      s1:=TStringList.Create;
      s2:=TStringList.Create;
      s3:=TStringList.Create;
      s4:=TStringList.Create;

      s3.Add('');
      s3.Add('! number of nodes per fiber for every muscle');
      s3.Add('*DIM,NB_NODES_FIBER,,nb_max_fibres,nb_muscles');

      s4.Add('');
      s4.Add('! number of fibers per muscle');
      s4.Add('*DIM,NB_FIBERS,,nb_muscles');

      nmax:=0;
      for m:=0 to high(muscle) do
      begin
        n:=0;
        for b:=1 to NumStruts do
        with Struts[b] do
        begin
          if musc = m then
          begin
            inc(n);
            nmax:=max(nmax,n);
            s2.Add('FIBER(1,'+inttostr(n)+','+inttostr(m+1)+')='+inttostr(atom1));
            s2.Add('FIBER(2,'+inttostr(n)+','+inttostr(m+1)+')='+inttostr(atom2));
            if n > 0 then
              s3.Add('NB_NODES_FIBER('+inttostr(n)+','+inttostr(m+1)+')=2');
          end;
        end;
        if n > 0 then
          s4.Add('NB_FIBERS('+inttostr(m+1)+')='+inttostr(n));
      end;

      s1.Add('! -------------------------------------------------------------------');
      s1.Add('! From 3DsimGG');
      s1.Add('');
      s1.Add('/NOPR');
      s1.Add('');
      s1.Add('! Some constants');
      s1.Add('nb_max_fibres = '+inttostr(nmax)+' ! max number of fibers per muscle');
      s1.Add('nb_max_nodes = 2 ! max number of nodes per fiber');
      s1.Add('nb_muscles = '+inttostr(high(muscle)+1)+' ! number of muscles');
      s1.Add('');
      s1.Add('! Fibers definition');
      s1.Add('*DIM,FIBER,,nb_max_nodes,nb_max_fibres,nb_muscles');
      s1.Add('');

      s1.AddStrings(s2);
      s1.AddStrings(s3);
      s1.AddStrings(s4);
      s1.SaveToFile(filename);
    finally
      s1.Free;
      s2.Free;
      s3.Free;
      s4.Free;
    end;
  end;
begin
  if NumAtoms > 0 then
  with SaveDialog3 do
  if Execute then
  try
    Screen.Cursor:=crHourglass;
    WriteNodes(ChangeFileExt(filename,'.node'));
    WriteElems(ChangeFileExt(filename,'.elem'));
    WriteMAC(ChangeFileExt(filename,'.mac'));
    WriteFibres(ChangeFileExt(filename,'')+'_fibers.mac');
  finally
    Screen.Cursor:=crDefault;
  end;
end;

function TForm1.cOfs2DX: integer;
begin
  result:=bOfs2DX;
end;

function TForm1.cOfs2DZ: integer;
begin
  result:=round(aOfs2DZ-(imgXZ.Height-imgYZ.height)*(zoom-1));
end;

function TForm1.bOfs2DY: integer;
begin
  result:=round(aOfs2DY-(imgXY.Height-imgYZ.Width)*(zoom-1)/2);
end;

end.
==============================================================================================
C:\Delphi 4\Clinasst\Import artisynth\mesh3\tongueIcp.3.node
C:\Delphi 4\Clinasst\Import artisynth\mesh3\Fibers.mac


  dlgOptions.sePressureMax.Value
  dlgOptions.pnlColorPressureHigh.Color
  dlgOptions.pnlColorPressureLow.Color


  dlgOptions.sePressureMax.Value
  dlgOptions.pnlColorPressureHigh.Color
  dlgOptions.pnlColorPressureLow.Color
  dlgOptions.cbForceKind.ItemIndex
    var cbf: Tcbf;
type Tcbf = (cbfStrutElastic,cbfMuscle,cbfPressure);
      cbf:=Tcbf(dlgOptions.cbForceKind.ItemIndex);

      force:=Add3D(force,Atoms[a].af`);
Atoms[a].af[cbfStrutElastic]
Atoms[a].af[cbfMuscle]
Atoms[a].af[cbfPressure]

afq[cbfStrutElastic]
afq[cbfPressure]

      if cbf = cbfStrutElastic then
      begin
      end;
      if cbf = cbfMuscle then
      begin
      end;
      if cbf = cbfPressure then
      begin
      end;
    end;
    var f,i,j,phz: integer;
        a: T3dPoint;
        ForcesScale: single;
        PressureMax: single;
    begin
    ForcesScale: single;
      ForcesScale:=dlgOptions.seForcesScale.Value;


{
      case Axes of
        plXZ: case CurSection of
                plXY: DrawAtomForces(vPixsCoord(Axes),Atoms[Atom1].p.y,Atoms[Atom2].p.y,Atom1,Atom2);
                plYZ: DrawAtomForces(vPixsCoord(Axes),Atoms[Atom1].p.y,Atoms[Atom2].p.y,Atom1,Atom2);
              end;
        plXY: case CurSection of
                plXZ: DrawAtomForces(vPixsCoord(Axes),Atoms[Atom1].p.z,Atoms[Atom2].p.z,Atom1,Atom2);
                plYZ: DrawAtomForces(vPixsCoord(Axes),Atoms[Atom1].p.z,Atoms[Atom2].p.z,Atom1,Atom2);
              end;
        plYZ: case CurSection of
                plXY: DrawAtomForces(vPixsCoord(Axes),Atoms[Atom1].p.x,Atoms[Atom2].p.x,Atom1,Atom2);
                plXZ: DrawAtomForces(vPixsCoord(Axes),Atoms[Atom1].p.x,Atoms[Atom2].p.x,Atom1,Atom2);
              end;
      end;
}
{
            case ph of
//              10:     Brush.Color:=clLightRed;
//              11:     Brush.Color:=clLightGreen;
//              12:     Brush.Color:=clLightYellow;
//              13:     Brush.Color:=clLightBlue;
//              14:     Brush.Color:=clLightCyan;
//              15:     Brush.Color:=clLightMagenta;
//              16:     Brush.Color:=clLightGray;
              17:     Brush.Color:=clDarkGray;
//              18:     Brush.Color:=clDarkRed;
//              19:     Brush.Color:=clDarkGreen;
            end;

  dlgOptions.sePressureMax.Value
  dlgOptions.pnlColorPressureHigh.Color
  dlgOptions.pnlColorPressureLow.Color
  dlgOptions.cbForceKind.ItemIndex
    var cbf: Tcbf;
type Tcbf = (cbfStrutElastic,cbfMuscle,cbfPressure);
}
; DrawBlob: boolean
