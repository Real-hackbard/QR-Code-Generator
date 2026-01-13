{$I Quricol.inc}

unit QuricolCode;

interface

uses
  Windows, SysUtils, Classes, Graphics, QuricolAPI;

type

  TQRCode = class
  private
    class function  GetBgColor : TColor; static;
    class procedure SetBgColor(Value : TColor); static;
    class function  GetFgColor : TColor; static;
    class procedure SetFgColor(Value : TColor); static;
  public

    class property BackgroundColor : TColor read GetBgColor write SetBgColor;
    class property ForegroundColor : TColor read GetFgColor write SetFgColor;
    class procedure GenerateBitmapFile(const FileName : string; const Text : string; Margin : integer = 4; PixelSize : integer = 3; Level : TErrorCorretion = QualityLow);
    class procedure GeneratePngFile(const FileName : string; const Text : string; Margin : integer = 4; PixelSize : integer = 3; Level : TErrorCorretion = QualityLow);
    class function  GetBitmapImage(const Text : string; Margin : integer = 4; PixelSize : integer = 3; Level : TErrorCorretion = QualityLow) : TBitmap;
    class procedure GetPngStream(Stream : TStream; const Text : string; Margin : integer = 4; PixelSize : integer = 3; Level : TErrorCorretion = QualityLow);
  end;

implementation


{ TQRCode }

class procedure TQRCode.GenerateBitmapFile(const FileName, Text: string; Margin,
  PixelSize: integer; Level : TErrorCorretion);
begin
  GenerateBMP(PChar(FileName), PChar(Text), Margin, PixelSize, ord(Level));
end;

class procedure TQRCode.GeneratePngFile(const FileName, Text: string; Margin,
  PixelSize: integer; Level : TErrorCorretion);
begin
  GeneratePNG(PChar(FileName), PChar(Text), Margin, PixelSize, ord(Level));
end;

class function TQRCode.GetBgColor: TColor;
begin
  Result := GetBackgroundColor;
end;

class function TQRCode.GetBitmapImage(const Text: string; Margin,
  PixelSize: integer; Level : TErrorCorretion): TBitmap;
var
  Bmp : HBITMAP;
  DIB: TDIBSection;
  ScreenDC : THandle;
  DC : THandle;
begin
  Bmp := GetHBitmap(PChar(Text), Margin, PixelSize, ord(Level));
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
end;

class function TQRCode.GetFgColor: TColor;
begin
   Result := GetForegroundColor;
end;

class procedure TQRCode.GetPngStream(Stream: TStream; const Text: string; Margin,
  PixelSize: integer; Level : TErrorCorretion);
var
  size : integer;
  i : integer;
  buffer : PByte;
  ps : PByte;
begin
  size := 0;
  GetPNG(PChar(Text), Margin, PixelSize, ord(Level), size, buffer);
  if (size > 0) then
   begin
     ps := buffer;
     for I := 0 to size - 1 do
       begin
         Stream.Write(ps^, 1);
         inc(ps);
       end;
      DestroyBuffer(buffer);
   end;
end;

class procedure TQRCode.SetBgColor(Value: TColor);
begin
  SetBackgroundColor(ColorToRGB(Value));
end;

class procedure TQRCode.SetFgColor(Value: TColor);
begin
  SetForegroundColor(ColorToRGB(Value));
end;

end.
