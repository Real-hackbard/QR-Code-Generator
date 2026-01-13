unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  IniFiles, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Samples.Spin, Vcl.ComCtrls,
  Vcl.Buttons;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    Bevel1: TBevel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    RadioGroup1: TRadioGroup;
    GroupBox2: TGroupBox;
    CheckBox1: TCheckBox;
    BitBtn1: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure WriteOptions;
    procedure ReadOptions;
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;
  TIF : TIniFile;

implementation

{$R *.dfm}
function MainDir : string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

procedure TForm2.WriteOptions;    // ################### Options Write
var OPT :string;
begin
   OPT := 'Options';

   if not DirectoryExists(MainDir + 'Data\Options\')
   then ForceDirectories(MainDir + 'Data\Options\');

   TIF := TIniFile.Create(MainDir + 'Data\Options\PrinterOptions.ini');
   with TIF do
   begin

   WriteInteger(OPT,'Top',SpinEdit1.Value);
   WriteInteger(OPT,'Left',SpinEdit2.Value);
   WriteInteger(OPT,'Right',SpinEdit3.Value);
   WriteBool(OPT,'Backup',CheckBox1.Checked);
   WriteInteger(OPT,'Unicode',RadioGroup1.ItemIndex);
   {
   WriteBool(OPT,'Backup',CheckBox1.Checked);
   WriteInteger(OPT,'Unicode',RadioGroup1.ItemIndex);
   WriteBool(OPT,'Trz',CheckBox2.Checked);
    }
   //WriteBool(OPT,'SaveOptions',CheckBox1.Checked);
   //WriteInteger(OPT,'Compress',Combobox1.ItemIndex);
   //WriteInteger(OPT,'Overlay',RadioGroup1.ItemIndex);
   Free;
   end;
end;

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
  Close();
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WriteOptions;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  ReadOptions;
end;

procedure TForm2.ReadOptions;    // ################### Options Read
var OPT:string;
begin
  OPT := 'Options';
  if FileExists(MainDir + 'Data\Options\PrinterOptions.ini') then
  begin
  TIF:=TIniFile.Create(MainDir + 'Data\Options\PrinterOptions.ini');
  with TIF do
  begin

  SpinEdit1.Value:=ReadInteger(OPT,'Top',SpinEdit1.Value);
  SpinEdit2.Value:=ReadInteger(OPT,'Left',SpinEdit2.Value);
  SpinEdit3.Value:=ReadInteger(OPT,'Right',SpinEdit3.Value);
  CheckBox1.Checked:=ReadBool(OPT,'Backup',CheckBox1.Checked);
  RadioGroup1.ItemIndex:=ReadInteger(OPT,'Unicode',RadioGroup1.ItemIndex);

  {
  CheckBox1.Checked:=ReadBool(OPT,'Backup',CheckBox1.Checked);
  RadioGroup1.ItemIndex:=ReadInteger(OPT,'Unicode',RadioGroup1.ItemIndex);
  CheckBox2.Checked:=ReadBool(OPT,'Trz',CheckBox2.Checked);
   }
  //CheckBox1.Checked:=ReadBool(OPT,'SaveOptions',CheckBox1.Checked);
  //Combobox1.ItemIndex:=ReadInteger(OPT,'Compress',combobox1.ItemIndex);
  //RadioGroup1.ItemIndex:=ReadInteger(OPT,'Overlay',RadioGroup1.ItemIndex);
  Free;
  end;
  end;
end;

end.
