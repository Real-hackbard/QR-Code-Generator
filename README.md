# QR-Code-Generator:


</br>

![Compiler](https://github.com/user-attachments/assets/a916143d-3f1b-4e1f-b1e0-1067ef9e0401) ![10 Seattle](https://github.com/user-attachments/assets/c70b7f21-688a-4239-87c9-9a03a8ff25ab) ![10 1 Berlin](https://github.com/user-attachments/assets/bdcd48fc-9f09-4830-b82e-d38c20492362) ![10 2 Tokyo](https://github.com/user-attachments/assets/5bdb9f86-7f44-4f7e-aed2-dd08de170bd5) ![10 3 Rio](https://github.com/user-attachments/assets/e7d09817-54b6-4d71-a373-22ee179cd49c)   
![10 4 Sydney](https://github.com/user-attachments/assets/e75342ca-1e24-4a7e-8fe3-ce22f307d881) ![11 Alexandria](https://github.com/user-attachments/assets/64f150d0-286a-4edd-acab-9f77f92d68ad) ![12 Athens](https://github.com/user-attachments/assets/59700807-6abf-4e6d-9439-5dc70fc0ceca)  
![Components](https://github.com/user-attachments/assets/d6a7a7a4-f10e-4df1-9c4f-b4a1a8db7f0e) ![Quricol dpk](https://github.com/user-attachments/assets/76cf4a65-392d-488e-a55c-166a9874fc78) ![QuricolAPI pas](https://github.com/user-attachments/assets/ad1d1184-5fdb-498b-b0a1-075b24dfdab3) ![QuricolCode pas](https://github.com/user-attachments/assets/d82c75fa-b5e6-45bd-9db1-0ee456c6d051)  
![Description](https://github.com/user-attachments/assets/b8c1e09a-6b02-48af-a7d0-1dd24e2aca83) ![QR Code Generator](https://github.com/user-attachments/assets/979ca4f1-af21-46a4-ab9b-0f5f673541ac)  
![Last Update](https://github.com/user-attachments/assets/e1d05f21-2a01-4ecf-94f3-b7bdff4d44dd) ![012026](https://github.com/user-attachments/assets/1decfcc8-6924-4cc3-84af-2ca41bdbc452)  
![License](https://github.com/user-attachments/assets/ff71a38b-8813-4a79-8774-09a2f3893b48) ![Freeware](https://github.com/user-attachments/assets/1fea2bbf-b296-4152-badd-e1cdae115c43)

</br>

A QR code, short for quick-response code, is a type of two-dimensional [matrix barcode](https://en.wikipedia.org/wiki/Barcode#Matrix_(2D)_codes) invented in 1994 by [Masahiro Hara](https://en.wikipedia.org/wiki/Masahiro_Hara) of the Japanese company [Denso Wave](https://en.wikipedia.org/wiki/Denso#DENSO_Wave) for labelling automobile parts. It features black squares on a white background with fiducial markers, readable by imaging devices like cameras, and processed using Reed–Solomon error correction until the image can be appropriately interpreted. The required data is then extracted from patterns that are present in both the horizontal and the vertical components of the QR image.

</br>

![QR-Code-Generator](https://github.com/user-attachments/assets/4402877f-1b66-49f7-bc67-2aada4a671ff)

</br>

Export Formats : [Bitmap;](https://en.wikipedia.org/wiki/Bitmap) [Jpg;](https://en.wikipedia.org/wiki/JPEG) [Png;](https://en.wikipedia.org/wiki/PNG) [GIF;](https://en.wikipedia.org/wiki/GIF) [WMF;](https://en.wikipedia.org/wiki/Windows_Metafile) [EMF;](https://en.wikipedia.org/w/index.php?title=Windows_Metafile&oldformat=true#EMF+)

</br>

### Graphic:
| Name | Description |
|---|---|
| GenerateBitmapFile  | Generates Windows Bitmap file with the text encoded as QR code |
| GeneratePngFile  | Generates PNG file with the text encoded as QR code  |
| GetBitmapImage |  Created Windows Bitmap image with the text encoded as QR code |
| GetPngStream | Writes PNG image to the stream. Can be useful for web development |

</br>

Whereas a barcode is a machine-readable optical image that contains information specific to the labeled item, the QR code contains the data for a locator, an identifier, and web tracking. To store data efficiently, QR codes use four standardized modes of encoding: [numeric](https://en.wikipedia.org/wiki/Number), alphanumeric, byte or [binary](https://en.wikipedia.org/wiki/Binary_number), and kanji. Compared to standard [UPC barcodes](https://en.wikipedia.org/wiki/Universal_Product_Code), the QR labeling system was applied beyond the automobile industry because of faster reading of the optical image and greater data-storage capacity in applications such as product tracking, item identification, time tracking, document management, and general marketing.

</br>

### Variables:
| Parameters | Description |
|---|---|
| const FileName: string | The name of the bitmap file |
| const Text: string | The text to encode |
| Margin: integer = 4 | The margin from the border |
| PixelSize: integer = 3 | The size of the one image point. |  
| Level: TErrorCorretion = QualityLow | The error correction level |

</br>

### Code Example:

```pascal
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

</br>

# No component for older Versions:
![Delphi Multi](https://github.com/user-attachments/assets/2c68cf53-903c-47c8-833d-ffe61d0f08d1)  
The second project contains no installable component and can be compiled with older versions.

quricol32.dll is a Dynamic Link Library (DLL) developed by [Serhiy Perevoznyk](https://perevoznyk.wordpress.com/) for Quricol QR Barcode Library and is described as QR barcode library.

DLL files (Dynamic Link Library) are used by Windows programs to share code and resources. It allows multiple applications to use the same functions, improving performance and reducing redundancy. Most errors involving qjpeg.dll occur because the DLL is missing, corrupted, or outdated. In many cases, reinstalling the related application, repairing windows or replacing the DLL resolves the issue.

Blog : https://delphi32.blogspot.com  
QR barcode Driver Download : https://www.dllme.com/dll/files/quricol32

</br>

# How to Install this DLL:
To install quricol32.dll, first copy the DLL into the application folder where the .exe is located. Use the Windows system folders if the error continues or you can’t find the application folder. If you are not sure which version (32-bit or 64-bit) to use, you can safely install both.

* 64-bit Application Folder: → copy to:  
```C:\Program Files\AppName\quricol32.dll```

* 32-bit Application Folder: → copy to:  
```C:\Program Files (x86)\AppName\quricol32.dll```

* 64-bit Windows System Folder: → copy to:  
```C:\Windows\System32\quricol32.dll```

* 32-bit Windows System Folder: → copy to:  
```C:\Windows\SysWOW64\quricol32.dll```  

</br>

# How to Register this DLL
Most DLL files do not need registration, but some DLLs are COM components and must be registered to work correctly.

* 64-bit Register DLL: You can drag the DLL into PowerShell to auto-fill the full path.  
```regsvr32 "C:\path\to\quricol32.dll"```

* 32-bit Register DLL:  
```C:\Windows\SysWOW64\regsvr32 "C:\path\to\quricol32.dll"```


