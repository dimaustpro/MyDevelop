program DataSnapMobileClient;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit3 in 'Unit3.pas' {Form3},
  ClientClassesUnit1 in 'ClientClassesUnit1.pas',
  ClientModuleUnit1 in 'ClientModuleUnit1.pas' {ClientModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  //Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TClientModule1, ClientModule1);
  Application.Run;
end.
