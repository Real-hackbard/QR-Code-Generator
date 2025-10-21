# QR-Code-Generator:


</br>

![Compiler](https://github.com/user-attachments/assets/a916143d-3f1b-4e1f-b1e0-1067ef9e0401) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: ![10 Seattle](https://github.com/user-attachments/assets/c70b7f21-688a-4239-87c9-9a03a8ff25ab) ![10 1 Berlin](https://github.com/user-attachments/assets/bdcd48fc-9f09-4830-b82e-d38c20492362) ![10 2 Tokyo](https://github.com/user-attachments/assets/5bdb9f86-7f44-4f7e-aed2-dd08de170bd5) ![10 3 Rio](https://github.com/user-attachments/assets/e7d09817-54b6-4d71-a373-22ee179cd49c)   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;![10 4 Sydney](https://github.com/user-attachments/assets/e75342ca-1e24-4a7e-8fe3-ce22f307d881) ![11 Alexandria](https://github.com/user-attachments/assets/64f150d0-286a-4edd-acab-9f77f92d68ad) ![12 Athens](https://github.com/user-attachments/assets/59700807-6abf-4e6d-9439-5dc70fc0ceca)  
![Components](https://github.com/user-attachments/assets/d6a7a7a4-f10e-4df1-9c4f-b4a1a8db7f0e) : ![Quricol dpk](https://github.com/user-attachments/assets/76cf4a65-392d-488e-a55c-166a9874fc78) ![QuricolAPI pas](https://github.com/user-attachments/assets/ad1d1184-5fdb-498b-b0a1-075b24dfdab3) ![QuricolCode pas](https://github.com/user-attachments/assets/d82c75fa-b5e6-45bd-9db1-0ee456c6d051)  
![Discription](https://github.com/user-attachments/assets/4a778202-1072-463a-bfa3-842226e300af) &nbsp;&nbsp;: ![QR Code Generator](https://github.com/user-attachments/assets/979ca4f1-af21-46a4-ab9b-0f5f673541ac)  
![Last Update](https://github.com/user-attachments/assets/e1d05f21-2a01-4ecf-94f3-b7bdff4d44dd) &nbsp;: ![102025](https://github.com/user-attachments/assets/62cea8cc-bd7d-49bd-b920-5590016735c0)  
![License](https://github.com/user-attachments/assets/ff71a38b-8813-4a79-8774-09a2f3893b48) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;: ![Freeware](https://github.com/user-attachments/assets/1fea2bbf-b296-4152-badd-e1cdae115c43)

</br>

The QR Codes are a  special kind of images that used to represent two-dimensional barcodes. They are also known as hardlinks or physical world hyperlinks.

The QR Codes can store up to 4,296 alphanumeric characters of arbitrary text. The  QR codes can be read by an optical device with the appropriate software. Such devices range from dedicated QR code readers to mobile phones.

Export Formats : Bitmap; Jpg; Png

</br>

| Name | Description |
|---|---|
| GenerateBitmapFile  | Generates Windows Bitmap file with the text encoded as QR code |
| GeneratePngFile  | Generates PNG file with the text encoded as QR code  |
| GetBitmapImage |  Created Windows Bitmap image with the text encoded as QR code |
| GetPngStream | Writes PNG image to the stream. Can be useful for web development |

</br>


| Parameters | Description |
|---|---|
| const FileName: string | The name of the bitmap file |
| const Text: string | The text to encode |
| Margin: integer = 4 | The margin from the border |
| PixelSize: integer = 3 | The size of the one image point. |  
| Level: TErrorCorretion = QualityLow | The error correction level |

</br>

![QR-Code-Generator](https://github.com/user-attachments/assets/4402877f-1b66-49f7-bc67-2aada4a671ff)

</br>

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

</br>

Copyright (c) Serhiy Perevoznyk. All rights reserved. THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. 
