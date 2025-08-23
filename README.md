# QR-Code-Generator:


```ruby
Compiler    : Delphi10 Seattle, 10.1 Berlin, 10.2 Tokyo, 10.3 Rio, 10.4 Sydney, 11 Alexandria, 12 Athens
Components  : QuricolAPI.pas, QuricolCode.pas, Quricol.dpk
Discription : QR-Code Generator
Last Update : 08/2025
License     : Freeware
```

The QR Codes are a  special kind of images that used to represent two-dimensional barcodes. They are also known as hardlinks or physical world hyperlinks.

The QR Codes can store up to 4,296 alphanumeric characters of arbitrary text. The  QR codes can be read by an optical device with the appropriate software. Such devices range from dedicated QR code readers to mobile phones.

Export Formats : Bitmap; Jpg; Png


| Name | Description |
|---|---|
| GenerateBitmapFile  | Generates Windows Bitmap file with the text encoded as QR code |
| GeneratePngFile  | Generates PNG file with the text encoded as QR code  |
| GetBitmapImage |  Created Windows Bitmap image with the text encoded as QR code |
| GetPngStream | Writes PNG image to the stream. Can be useful for web development |

  <br />


| Parameters | Description |
|---|---|
| const FileName: string | The name of the bitmap file |
| const Text: string | The text to encode |
| Margin: integer = 4 | The margin from the border |
| PixelSize: integer = 3 | The size of the one image point. |  
| Level: TErrorCorretion = QualityLow | The error correction level |

  <br />

![QR-Code-Generator](https://github.com/user-attachments/assets/4402877f-1b66-49f7-bc67-2aada4a671ff)

  <br />

### Code Example:

```
var
  bmp : TBitmap;
  MS : TMemoryStream;
begin
  try
    //Generate Windows bitmap and save to file
    TQRCode.GenerateBitmapFile('delphi1.bmp', 'http://delphi32.blogspot.com', QualityLow);

    //Generate PNG image and save to file
    TQRCode.GeneratePngFile('delphi1.png', 'http://delphi32.blogspot.com');

    //Generate TBitmap
    bmp := TQRCode.GetBitmapImage('http://www.krento.net');
    bmp.SaveToFile('delphi2.bmp');

    //Generate PNG to the memory stream
    MS := TMemoryStream.Create;
    TQRCode.GetPngStream(MS, 'http://www.krento.net');
    MS.Position := 0;
    MS.SaveToFile('delphi2.png');
    MS.Free;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
```

Copyright (c) Serhiy Perevoznyk. All rights reserved. THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. 
