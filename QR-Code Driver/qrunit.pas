unit qrunit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, printers,
  Dialogs, ExtCtrls, StdCtrls, Menus, Spin, Buttons, ClipBrd, ComCtrls,
  XPMan, Jpeg;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    Panel4: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    S5: TSpeedButton;
    S33: TSpeedButton;
    S11: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Button4: TButton;
    Memo2: TMemo;
    Edit1: TEdit;
    UpDown1: TUpDown;
    StatusBar1: TStatusBar;
    Button1: TButton;
    SaveDialog1: TSaveDialog;
    Panel1: TPanel;
    Image3: TImage;
    ComboBox1: TComboBox;
    Label1: TLabel;
    ComboBox2: TComboBox;
    Label2: TLabel;
    procedure S33Click(Sender: TObject);
    procedure S11Click(Sender: TObject);
    procedure S5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    verzeichnis:string;
    { Private declarations }
  public
    { Public declarations }
  end;

//type
  TErrorCorretion = (QualityLow, QualityMedium, QualityStandard, QualityHigh);

  TQRCode = class
  private
  public
    class function GetBitmapImage(const Text : string;
            Margin : integer = 4;
            PixelSize : integer = 3;
            Level : TErrorCorretion = QualityLow) : TBitmap;
  end;

var
  Form1: TForm1;
  verzeichnis:string;

implementation

{$R *.dfm}
type
   TGetHBitmap = function(Text: PChar;
                  Margin, Size, Level: integer): HBITMAP; stdcall;
var
  DLLHandle: THandle;
  GetHBitmap: TGetHBitmap;
  xPixelsPerInch : integer;

procedure Bmp2Jpeg(const BmpFileName, JpgFileName: string);
var
  Bmp: TBitmap;
  Jpg: TJPEGImage;
begin
  Bmp := TBitmap.Create;
  Jpg := TJPEGImage.Create;
  try
    Bmp.LoadFromFile(BmpFileName);
    Jpg.Assign(Bmp);
    Jpg.SaveToFile(JpgFileName);
  finally
    Jpg.Free;
    Bmp.Free;
  end;
end;

procedure TForm1.S33Click(Sender: TObject);
begin
    if opendialog1.execute then
    begin
      memo2.Lines.LoadFromFile(opendialog1.filename);
    end;
end;

procedure TForm1.S11Click(Sender: TObject);
begin
    Memo2.text:='https://github.com';
    button4click(sender);
end;

procedure TForm1.S5Click(Sender: TObject);
begin
    memo2.clear;
end;

function Irgendwas(Text : PChar;  Margin : integer; Size : integer; Level : integer): HBITMAP;
begin
  if Assigned(GetHBitmap) then
    Result := GetHBitmap(PChar(Text), Margin, Size, ord(Level))
  else
    Result := 0;
end;

{ TQRCode }
class function TQRCode.GetBitmapImage(const Text: string; Margin,
  PixelSize: integer; Level : TErrorCorretion): TBitmap;
var
  Bmp : hBITMAP;
  DIB: TDIBSection;
  ScreenDC : THandle;
  DC : THandle;
begin
  DLLHandle := LoadLibrary(PChar(verzeichnis+'quricol32.dll'));
  try
  if DLLHandle <> 0 then
    GetHBitmap := GetProcAddress(DLLHandle, 'GetHBitmapA');

  Bmp := irgendwas(PChar(Text), Margin, PixelSize, ord(Level));

  GetObject(Bmp, SizeOf(DIB), @DIB);
  Result := TBitmap.Create();
  Result.Width := DIB.dsBmih.biWidth;
  Result.Height := DIB.dsBmih.biHeight;
  Result.PixelFormat := pf32bit;
  ScreenDC := GetDC(0);
  DC := CreateCompatibleDC(ScreenDC);
  SelectObject(DC, Bmp);
  ReleaseDC(0, ScreenDC);
  BitBlt(Result.Canvas.Handle, 0, 0, Result.Width, Result.Height, DC, 0, 0, SRCCOPY);
  DeleteDC(DC);
  DeleteObject(Bmp);
  finally
    if DLLHandle <> 0 then
      FreeLibrary(DLLHandle);
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
 var
  B : TBitmap;
begin
  if length(Memo2.text)>0 then
  begin
    if length(Memo2.text)>1600 then
       Memo2.text := copy(Memo2.text,1,1600);
    try
      // QualityLow, QualityMedium, QualityQuart, QualityHigh, QualityStandard
      case ComboBox1.ItemIndex of
      0 : B := TQRCode.GetBitmapImage(Memo2.Text,
               updown1.position, StrToInt(ComboBox2.Text), QualityStandard);
      1 : B := TQRCode.GetBitmapImage(Memo2.Text,
               updown1.position, StrToInt(ComboBox2.Text), QualityLow);
      2 : B := TQRCode.GetBitmapImage(Memo2.Text,
               updown1.position, StrToInt(ComboBox2.Text), QualityMedium);
      3 : B := TQRCode.GetBitmapImage(Memo2.Text,
               updown1.position, StrToInt(ComboBox2.Text), QualityHigh);
      end;


      StatusBar1.Panels[1].Text := 'X-(' + IntToStr(B.Height) + ') - Y-(' +
                                   IntToStr(B.Width) + ')';

      Image3.picture.bitmap.assign(B);
    finally
      B.Free;
    end;
  end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
var
  B : TBitmap;
begin
    if length(memo2.text)>0 then
    begin
      B := TQRCode.GetBitmapImage(memo2.Text, updown1.position, 4, QualityStandard);
      Clipboard.Assign(B);
      B.Free;
    end;
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
const lidruck=20;
      redruck=20;
      obdruck=20;
var
  ScaleX,ScaleY:real;
  limog,obmog,lioff,oboff,reoff : Integer;
  R: TRect;
begin
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

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
  B : TBitmap;
begin
   xPixelsPerInch:=PixelsPerInch;
   if length(memo2.text)>0 then
   begin
     B := TQRCode.GetBitmapImage(memo2.Text, updown1.position, 4, QualityStandard);
     normaldruckbitmap(b);
     B.Free;
   end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Panel1.DoubleBuffered := true;
  verzeichnis:=IncludeTrailingBackslash(extractfilepath(application.exename));
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    if SaveDialog1.FilterIndex = 1 then
    begin
      Image3.Picture.Bitmap.SaveToFile(SaveDialog1.FileName + '.bmp');
    end;

  end;
end;

procedure TForm1.Memo2Change(Sender: TObject);
begin
  if length(Memo2.text) > 1600 then
  begin
    Beep;
    MessageDlg('Maximal 1600 strings allowd!',mtInformation, [mbOK], 0);
    Exit;
  end;
  StatusBar1.Panels[5].Text := IntToStr(Memo2.Lines.Count);
  Button4.Click;
end;

procedure TForm1.ComboBox2Change(Sender: TObject);
begin
  case ComboBox2.ItemIndex of
  0 : StatusBar1.Panels[1].Text := 'X-(33) - Y-(33)';
  1 : StatusBar1.Panels[1].Text := 'X-(99) - Y-(99)';
  2 : StatusBar1.Panels[1].Text := 'X-(132) - Y-(132)';
  3 : StatusBar1.Panels[1].Text := 'X-(165) - Y-(165)';
  4 : StatusBar1.Panels[1].Text := 'X-(198) - Y-(198)';
  5 : StatusBar1.Panels[1].Text := 'X-(231) - Y-(231)';
  6 : StatusBar1.Panels[1].Text := 'X-(264) - Y-(264)';
  7 : StatusBar1.Panels[1].Text := 'X-(297) - Y-(297)';
  8 : StatusBar1.Panels[1].Text := 'X-(330) - Y-(330)';
  9 : StatusBar1.Panels[1].Text := 'X-(363) - Y-(363)';
  10 : StatusBar1.Panels[1].Text := 'X-(396) - Y-(396)';
  11 : StatusBar1.Panels[1].Text := 'X-(429) - Y-(429)';
  12 : StatusBar1.Panels[1].Text := 'X-(462) - Y-(462)';
  13 : StatusBar1.Panels[1].Text := 'X-(495) - Y-(495)';
  14 : StatusBar1.Panels[1].Text := 'X-(528) - Y-(528)';
  15 : StatusBar1.Panels[1].Text := 'X-(561) - Y-(561)';
  16 : StatusBar1.Panels[1].Text := 'X-(594) - Y-(594)';
  17 : StatusBar1.Panels[1].Text := 'X-(627) - Y-(627)';
  18 : StatusBar1.Panels[1].Text := 'X-(660) - Y-(660)';
  end;

  Button4.Click;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  Button4.Click;
end;

end.
