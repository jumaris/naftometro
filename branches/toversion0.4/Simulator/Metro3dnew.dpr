program Metro3dnew;

uses
  Forms,
  Unitm3dn in 'Unitm3dn.pas' {MainForm},
  Useful in 'Useful.pas',
  Bomj in 'Bomj.pas',
  Gamer in 'Gamer.pas';

{$R *.res}

var
  mainForm:TMainForm;

begin
  Application.Initialize;
  Application.Title := 'Naftometro';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
