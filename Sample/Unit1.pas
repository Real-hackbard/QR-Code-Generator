unit Unit1;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ExtCtrls, StdCtrls, ActnList, JPeg, Menus, ClipBrd, Spin, System.Actions,
  Vcl.ComCtrls, Vcl.Buttons, Printers;
type
  TForm1 = class(TForm)
    ActionList1: TActionList;
    actClose: TAction;
    actSave: TAction;
    actCreate: TAction;
    SaveDialog: TSaveDialog;
    actCopy: TAction;
    Panel1: TPanel;
    Panel2: TPanel;
    StatusBar1: TStatusBar;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Memo1: TMemo;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label2: TLabel;
    edtMargin: TSpinEdit;
    edtSize: TSpinEdit;
    Label3: TLabel;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Edit1: TEdit;
    Label4: TLabel;
    OpenDialog1: TOpenDialog;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    procedure actSaveUpdate(Sender: TObject);
    procedure actCreateUpdate(Sender: TObject);
    procedure actCopyUpdate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure edtSizeChange(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure edtMarginChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateImage;

  public
    { Public declarations }
  end;
var
  Form1: TForm1;
  xPixelsPerInch : integer;

implementation

uses QuricolCode, ShlObj, Unit2;

{$R *.dfm}
function MainDir : string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

PROCEDURE PrintBitmap(Canvas: TCanvas; DestRect: TRect; Bitmap: TBitmap);
  VAR
    BitmapHeader: pBitmapInfo;
    BitmapImage : POINTER;
    HeaderSize  : DWORD;
    ImageSize   : DWORD;
BEGIN
    GetDIBSizes(Bitmap.Handle, HeaderSize, ImageSize);
    GetMem(BitmapHeader, HeaderSize);
    GetMem(BitmapImage, ImageSize);
    TRY
      GetDIB(Bitmap.Handle, Bitmap.Palette, BitmapHeader^, BitmapImage^);
      StretchDIBits(Canvas.Handle,
        DestRect.Left, DestRect.Top,
        DestRect.Right - DestRect.Left,
        DestRect.Bottom - DestRect.Top,
        0, 0,
        Bitmap.Width, Bitmap.Height,
        BitmapImage,
        TBitmapInfo(BitmapHeader^),
        DIB_RGB_COLORS,
        SRCCOPY)
    FINALLY
      FreeMem(BitmapHeader);
      FreeMem(BitmapImage)
    END
END;

procedure normaldruckbitmap(bitmap:tbitmap);
var
  ScaleX,ScaleY:real;
  limog,obmog,lioff,oboff,reoff : Integer;
  R: TRect;

  lidruck, redruck, obdruck : integer;
begin
    lidruck := 10; //Form3.SpinEdit2.Value;
    redruck := 10; //Form3.SpinEdit3.Value;
    obdruck := 10; //Form3.SpinEdit1.Value;

    Printer.BeginDoc;
    with Printer do
      try
        limog:=GetDeviceCaps(Handle, physicaloffsetx);
        lioff:=round(lidruck*GetDeviceCaps(Handle,logPixelsX)/25.4)-limog;
        if lioff<0 then lioff:=0;
        reoff:=round(redruck*GetDeviceCaps(Handle,logPixelsX)/25.4)-limog;
        if reoff<0 then reoff:=0;
        obmog:=GetDeviceCaps(Handle, physicaloffsety);
        oboff:=round(obdruck*GetDeviceCaps(Handle,logPixelsY)/25.4)-obmog;
        if oboff<0 then oboff:=0;
        ScaleX := GetDeviceCaps(Handle, logPixelsX)/xPixelsPerInch;
        ScaleY := GetDeviceCaps(Handle, logPixelsY)/xpixelsPerInch;
        while scalex*bitmap.width>(pagewidth-lioff-reoff) do
        begin
          scalex:=scalex-0.02;
          scaley:=scaley-0.02;
        end;
        if scalex<=0 then scalex:=1;
        if scaley<=0 then scaley:=1;
        R := Rect(lioff, oboff, round(lioff+bitmap.Width * ScaleX),
                  round(oboff+bitmap.Height * ScaleY));
        printbitmap(printer.canvas,R,bitmap)
      finally
        EndDoc;
      end;
end;

function GetMyPicturesFolder : string;
var
  Path : array[0..255] of char;
begin
  SHGetSpecialFolderPath(0, @Path[0], CSIDL_MYPICTURES, true);
  Result := Path;
end;
procedure TForm1.actCopyUpdate(Sender: TObject);
begin
  actCopy.Enabled := (not Image1.Picture.Bitmap.Empty);
end;
procedure TForm1.actCreateUpdate(Sender: TObject);
begin
  actCreate.Enabled := Memo1.Text <> '';
end;
procedure TForm1.actSaveUpdate(Sender: TObject);
begin
  actSave.Enabled := (Memo1.Text <> '') and (not Image1.Picture.Bitmap.Empty);
end;
procedure TForm1.BitBtn1Click(Sender: TObject);
var text : TStringList;
begin
  StatusBar1.SetFocus;

  if Memo1.Lines.Count = 0 then Exit;

  Screen.Cursor := crHourGlass;
  StatusBar1.Panels[5].Text := 'Calculating..';
  if Form2.CheckBox1.Checked = true then begin  // Unicode
    text := TStringList.Create();
    text.Text := Memo1.Text;

    case Form2.RadioGroup1.ItemIndex of
    0 : Text.SaveToFile(MainDir + 'Data\Backup\' + Edit1.Text + '.txt', TEncoding.Default);
    1 : Text.SaveToFile(MainDir + 'Data\Backup\' + Edit1.Text + '.txt', TEncoding.ANSI);
    2 : Text.SaveToFile(MainDir + 'Data\Backup\' + Edit1.Text + '.txt', TEncoding.ASCII);
    3 : Text.SaveToFile(MainDir + 'Data\Backup\' + Edit1.Text + '.txt', TEncoding.Unicode);
    4 : Text.SaveToFile(MainDir + 'Data\Backup\' + Edit1.Text + '.txt', TEncoding.BigEndianUnicode);
    5 : Text.SaveToFile(MainDir + 'Data\Backup\' + Edit1.Text + '.txt', TEncoding.UTF7);
    6 : Text.SaveToFile(MainDir + 'Data\Backup\' + Edit1.Text + '.txt', TEncoding.UTF8);
    end;

  end;

  UpdateImage;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
  Ext : string;
  Jpg : TJPEGImage;
  B : TBitmap;
begin
  StatusBar1.SetFocus;

  if Image1.Picture.Graphic = nil then begin
  Beep;
  MessageDlg('Generate QR-Code..',mtInformation, [mbOK], 0);
  Exit;
  end;


  if SaveDialog.Execute then
   begin
     Ext := ExtractFileExt(SaveDialog.FileName);
     if SameText(ext, '.png') then
       TQRCode.GeneratePngFile(SaveDialog.FileName, Memo1.Text, edtMargin.Value, edtSize.Value)
     else if SameText(ext, '.bmp') then
       TQRCode.GenerateBitmapFile(SaveDialog.FileName, Memo1.Text, edtMargin.Value, edtSize.Value)
     else
       begin
         Jpg := TJPEGImage.Create;
         B := TQRCode.GetBitmapImage(Memo1.Text, edtMargin.Value, edtSize.Value);
         Jpg.Assign(B);
         B.Free;
         Jpg.SaveToFile(SaveDialog.FileName);
         Jpg.Free;
       end;
   end;
end;

procedure TForm1.edtMarginChange(Sender: TObject);
begin
  StatusBar1.Panels[3].Text := IntToStr(edtMargin.Value * 10) + 'px'
end;

procedure TForm1.edtSizeChange(Sender: TObject);
begin
  StatusBar1.Panels[1].Text := IntToStr(edtSize.Value * 29) + 'x' +
                               IntToStr(edtSize.Value * 29) + ' px';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SaveDialog.InitialDir := GetMyPicturesFolder;

  if not FileExists(MainDir + 'Data\Drivers\pdf.dll') then begin
  ShowMessage('Error "pdf.dll" not found, check Drivers Folder !');
  Application.Terminate; end;

  if not FileExists(MainDir + 'Data\Drivers\png.dll') then begin
  ShowMessage('Error "png.dll" not found, check Drivers Folder !');
  Application.Terminate; end;

  if not FileExists(MainDir + 'Data\Drivers\quricol32.dll') then begin
  ShowMessage('Error "quricol32.dll" not found, check Drivers Folder !');
  Application.Terminate; end;

  if not FileExists(MainDir + 'Data\Drivers\quricol64.dll') then begin
  ShowMessage('Error "quricol64.dll" not found, check Drivers Folder !');
  Application.Terminate; end;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Label7.Top := ScrollBox1.Height div 2;
  Label7.Left := (ScrollBox1.Width div 2) -11;

end;

procedure TForm1.FormShow(Sender: TObject);
begin
   edtSize.OnChange(sender);
   edtMargin.OnChange(sender);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
  B : TBitmap;
begin
  B := TQRCode.GetBitmapImage(Memo1.Text, edtMargin.Value, edtSize.Value);
  Clipboard.Assign(B);
  B.Free;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
  Memo1.Clear;
  Image1.Picture.Graphic := nil;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
var
  B, res : TBitmap;
begin
   xPixelsPerInch:=PixelsPerInch;
   if length(memo1.text)>0 then
   begin
   try
     B := TQRCode.GetBitmapImage(Memo1.Text, edtMargin.Value, edtSize.Value);
     normaldruckbitmap(B);
     finally
     B.Free;
     end;
   end;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
  try form2 := TForm2.Create(nil); form2.ShowModal; finally end;
end;

procedure TForm1.UpdateImage;
 var
  B : TBitmap;
begin
  B := TQRCode.GetBitmapImage(Memo1.Text, edtMargin.Value, edtSize.Value);
  try
    Image1.Height := StrToInt(edtSize.Text) * 29;
    Image1.Width := StrToInt(edtSize.Text) * 29;
    Image1.Picture.Bitmap.Assign(B);
  finally
  B.Free;
  end;
  StatusBar1.Panels[5].Text := 'Calculate done.';
  Screen.Cursor := crDefault;
end;

end.
