program Mapmaker;

uses
  Forms,
  Mapform in 'Mapform.pas', {Form1}
  Bomj in 'Bomj.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
