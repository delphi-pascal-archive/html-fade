program htmlfade;

uses
  Forms,
  Unitmain in 'Unitmain.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
