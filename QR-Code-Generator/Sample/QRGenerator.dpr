program QRGenerator;
uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  QuricolCode in '..\Source\QuricolCode.pas',
  QuricolAPI in '..\Source\QuricolAPI.pas',
  Vcl.Themes,
  Vcl.Styles,
  Unit2 in 'Unit2.pas' {Form2};

{$R *.res}
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'QR Code generator';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
