program Metro3dnew;

uses
  Forms,
  Unitm3dn in 'Unitm3dn.pas' {MainForm},
  Useful in 'Useful.pas',
  Bomj in 'Bomj.pas',
  MyKeyConsts in 'MyKeyConsts.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Naftometro';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
