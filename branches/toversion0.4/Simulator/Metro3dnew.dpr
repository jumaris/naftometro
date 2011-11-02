program Metro3dnew;

{$APPTYPE CONSOLE}

uses
  Forms,
  Unitm3dn in 'Unitm3dn.pas' {MainForm},
  Useful in 'Useful.pas',
  Bomj in 'Bomj.pas',
  Gamer in 'Gamer.pas',
  Painter in 'Painter.pas',
  Physer in 'Physer.pas',
  ObjectContainer in 'ObjectContainer.pas',
  ReallyUseful in 'ReallyUseful.pas',
  MapUnit in 'MapUnit.pas',
  ObjectContainer1 in 'ObjectContainer1.pas',
  tests in 'tests.pas';

{$R *.res}
procedure runAll;
var
  mainForm:TMainForm;
begin
  Application.Initialize;
  Application.Title := 'Naftometro';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end;

begin
  runAll;
end.
