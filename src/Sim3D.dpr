program Sim3D;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Optionsdlg in 'Optionsdlg.pas' {dlgOptions},
  Mass in 'Mass.pas' {dlgMass},
  EditStrut in 'EditStrut.pas' {dlgEditStrut},
  MovieDlg in 'MovieDlg.pas' {dlgMovie},
  JpegCalc in 'jpegcalc.pas',
  ImportImagesdlg in 'ImportImagesdlg.pas' {dlgImportImages},
  HelpFm in 'HelpFm.pas' {fmHelp},
  Roofdlg in 'Roofdlg.pas' {dlgRoof},
  EMAdlg in 'EMAdlg.pas' {dlgEMA},
  pngimage in 'pngimage.pas',
  zlibpas in 'zlibpas.pas',
  pnglang in 'pnglang.pas',
  ImportNodesDlg in 'ImportNodesDlg.pas' {dlgImportNodes},
  BGShiftDlg in 'BGShiftDlg.pas' {dlgBGShift};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TdlgOptions, dlgOptions);
  Application.CreateForm(TdlgMass, dlgMass);
  Application.CreateForm(TdlgEditStrut, dlgEditStrut);
  Application.CreateForm(TdlgMovie, dlgMovie);
  Application.CreateForm(TdlgImportImages, dlgImportImages);
  Application.CreateForm(TfmHelp, fmHelp);
  Application.CreateForm(TdlgRoof, dlgRoof);
  Application.CreateForm(TdlgEMA, dlgEMA);
  Application.CreateForm(TdlgImportNodes, dlgImportNodes);
  Application.CreateForm(TdlgBGShift, dlgBGShift);
  Application.Run;
end.
