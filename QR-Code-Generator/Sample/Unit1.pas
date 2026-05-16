unit Unit1;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ExtCtrls, StdCtrls, ActnList, JPeg, Menus, ClipBrd, Spin, System.Actions,
  Vcl.ComCtrls, Vcl.Buttons, Printers, GIFImg;
type
  TForm1 = class(TForm)
    ActionList1: TActionList;
    actClose: TAction;
    actSave: TAction;
    actCreate: TAction;
    SaveDialog1: TSaveDialog;
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
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
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
    procedure SpinEdit2Change(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
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

procedure Scale(const src, dest: TGraphic;
  DestWidth, DestHeight: integer; Smooth: Boolean = true);
var
  temp, aCopy: TBitmap;
  faktor: double;
begin
  Assert(Assigned(src) and Assigned(dest));
  if (src.Width = 0) or (src.Height = 0) then
    raise Exception.CreateFmt('Invalid source dimensions: %d x %d',[src.Width, src.Height]);
  if src.Width > DestWidth then
    begin
      faktor := DestWidth / src.Width;
      if (src.Height * faktor) > DestHeight then
        faktor := DestHeight / src.Height;
    end
  else
    begin
      faktor := DestHeight / src.Height;
      if (src.Width * faktor) > DestWidth then
        faktor := DestWidth / src.Width;
    end;
  try
    aCopy := TBitmap.Create;
    try
      aCopy.PixelFormat := pf24Bit;
      aCopy.Assign(src);
      temp := TBitmap.Create;
      try
        temp.Width := round(src.Width * faktor);
        temp.Height := round(src.Height * faktor);
        if Smooth then
          SetStretchBltMode(temp.Canvas.Handle, HALFTONE);
        StretchBlt(temp.Canvas.Handle, 0, 0, temp.Width, temp.Height,
          aCopy.Canvas.Handle, 0, 0, aCopy.Width, aCopy.Height, SRCCOPY);
        dest.Assign(temp);
      finally
        temp.Free;
      end;
    finally
      aCopy.Free;
    end;
  except
    on E: Exception do
      MessageBox(0, PChar(E.Message), nil, MB_OK or MB_ICONERROR);
  end;
end;

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
var
  text : TStringList;
  x, y : integer;
    BMP : TBitmap;
begin
  StatusBar1.SetFocus;

  if Memo1.Lines.Count = 0 then Exit;

  Screen.Cursor := crHourGlass;
  StatusBar1.Panels[5].Text := 'Calculating..';

  if Form2.CheckBox1.Checked = true then
  begin
    text := TStringList.Create();
    text.Text := Memo1.Text;

    // Memo Unicode
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

  // colorize qr-code
  if Form2.CheckBox4.Checked = true then
  begin
    BMP := TBitmap.Create;
    // copy original pixel to bimtap
    BMP := TQRCode.GetBitmapImage(Memo1.Text,SpinEdit1.Value, SpinEdit2.Value);
    // Identify all black pixels and recolor them in RGB.
    // for both height and width
    for x := 0 to BMP.Height do
    begin
      for y := 0 to BMP.Width do
      begin
        if BMP.Canvas.Pixels[y,x] = clBlack then
            BMP.Canvas.Pixels[y,x]:= Form2.Shape1.Brush.Color;
      end;
    end;
  end;

  if Form2.CheckBox2.Checked = true then
  begin
    StatusBar1.Panels[1].Text := IntToStr(Form2.SpinEdit4.Value) + 'x' +
                                 IntToStr(Form2.SpinEdit5.Value) + ' px';
  end else begin
    StatusBar1.Panels[1].Text := IntToStr(SpinEdit2.Value * 29) + 'x' +
                                 IntToStr(SpinEdit2.Value * 29) + ' px';
  end;

  UpdateImage;
  if Form2.CheckBox4.Checked = true then Image1.Picture.Bitmap.Assign(BMP);
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
  Ext : string;
  Jpg : TJPEGImage;
  bmp, bmpscale : TBitmap;
  x, y : integer;
  Image : TImage;
  GIF : TGIFImage;
  MetaFile: TMetaFile;
  MFCanvas, MetaCanvas : TMetaFileCanvas;
begin
  StatusBar1.SetFocus;

  if Image1.Picture.Graphic = nil then begin
    Beep;
    MessageDlg('Generate QR-Code..',mtInformation, [mbOK], 0);
    Exit;
  end;

  if SaveDialog1.Execute then
   begin
     if SaveDialog1.FilterIndex = 1 then
     begin
      { ---------- BITMAP EXPORT --------------------------------------------- }
     try
        { For the direct creation of a bitmap without editing exactly
          as supplied. }
        //TQRCode.GenerateBitmapFile(SaveDialog1.FileName, Memo1.Text,
        //                            SpinEdit1.Value, SpinEdit2.Value);

        // create bitmap
        bmp := TBitmap.Create;
        // create scaled bitmap
        bmpscale := TBitmap.Create;
        // copy qr-code original data into bitmap
        // This is the best way to customize the bitmap
        bmp := TQRCode.GetBitmapImage(Memo1.Text,SpinEdit1.Value, SpinEdit2.Value);

        // colorize bitmap
        if Form2.CheckBox4.Checked = true then
        begin
          Screen.Cursor := crHourGlass;
          // Identify all black pixels and recolor them in RGB.
          // for both height and width
          for x := 0 to BMP.Height do
          begin
            for y := 0 to BMP.Width do
            begin
              if BMP.Canvas.Pixels[y,x] = clBlack then
                  BMP.Canvas.Pixels[y,x]:= Form2.Shape1.Brush.Color;
            end;
          end;
        end;

        if Form2.CheckBox2.Checked = true then
        begin
          // scale the bitmap with smooth to size
          if Form2.CheckBox3.Checked = true then begin
          Scale(bmp,bmpscale, Form2.SpinEdit4.Value, Form2.SpinEdit5.Value, true);
          end;
          // scale the bitmap without smooth to size
          if Form2.CheckBox3.Checked = false then begin
          Scale(bmp,bmpscale, Form2.SpinEdit4.Value, Form2.SpinEdit5.Value, false);
          end;
          // select bitmap pixel bits with scale
           case Form2.RadioGroup2.ItemIndex of
            0 : bmpscale.PixelFormat := pf8bit;
            1 : bmpscale.PixelFormat := pf24bit;
            2 : bmpscale.PixelFormat := pf32bit;
           end;
          // save scaled bitmap
          bmpscale.SaveToFile(SaveDialog1.FileName);
        end else begin
           // select bitmap pixel bits without scale
           case Form2.RadioGroup2.ItemIndex of
            0 : bmp.PixelFormat := pf8bit;
            1 : bmp.PixelFormat := pf24bit;
            2 : bmp.PixelFormat := pf32bit;
           end;
          // save without scale function
          bmp.SaveToFile(SaveDialog1.FileName);
        end;
        finally
          bmp.Free;
        end;
     end;

     if SaveDialog1.FilterIndex = 2 then
     begin
      { ---------- JPG EXPORT ------------------------------------------------ }

      bmp := TBitmap.Create;
      bmpscale := TBitmap.Create;
      bmp := TQRCode.GetBitmapImage(Memo1.Text,SpinEdit1.Value, SpinEdit2.Value);

      if Form2.CheckBox4.Checked = true then
      begin
        Screen.Cursor := crHourGlass;
        for x := 0 to BMP.Height do
        begin
          for y := 0 to BMP.Width do
          begin
            if BMP.Canvas.Pixels[y,x] = clBlack then
                BMP.Canvas.Pixels[y,x]:= Form2.Shape1.Brush.Color;
          end;
        end;
      end;

      if Form2.CheckBox2.Checked = true then
      begin
        if Form2.CheckBox3.Checked = true then begin
        Scale(bmp,bmpscale, Form2.SpinEdit4.Value, Form2.SpinEdit5.Value, true);
        end;
        if Form2.CheckBox3.Checked = false then begin
        Scale(bmp,bmpscale, Form2.SpinEdit4.Value, Form2.SpinEdit5.Value, false);
        end;
      end;

      Jpg := TJPEGImage.Create;
      try
        if Form2.CheckBox3.Checked = true then
        begin
          jpg.Assign(bmp);
        end else begin
          jpg.Assign(bmpscale);
        end;
        Jpg.SaveToFile(SaveDialog1.FileName);
      finally
        bmp.Free;
        Jpg.Free;
      end;
     end;

     if SaveDialog1.FilterIndex = 3 then
     begin
      { ---------- PNG EXPORT ------------------------------------------------ }
      TQRCode.GeneratePngFile(SaveDialog1.FileName, Memo1.Text,
                              SpinEdit1.Value, SpinEdit2.Value)
     end;

     if SaveDialog1.FilterIndex = 4 then
     begin
      { ---------- GIF EXPORT ------------------------------------------------ }

      bmp := TBitmap.Create;
      bmpscale := TBitmap.Create;
      bmp := TQRCode.GetBitmapImage(Memo1.Text,SpinEdit1.Value, SpinEdit2.Value);

      if Form2.CheckBox4.Checked = true then
      begin
        Screen.Cursor := crHourGlass;
        for x := 0 to BMP.Height do
        begin
          for y := 0 to BMP.Width do
          begin
            if BMP.Canvas.Pixels[y,x] = clBlack then
                BMP.Canvas.Pixels[y,x]:= Form2.Shape1.Brush.Color;
          end;
        end;
      end;

      if Form2.CheckBox2.Checked = true then
      begin
        if Form2.CheckBox3.Checked = true then begin
        Scale(bmp,bmpscale, Form2.SpinEdit4.Value, Form2.SpinEdit5.Value, true);
        end;
        if Form2.CheckBox3.Checked = false then begin
        Scale(bmp,bmpscale, Form2.SpinEdit4.Value, Form2.SpinEdit5.Value, false);
        end;
      end;

      Image := TImage.Create(self);
      Image.Picture.Bitmap.Assign(bmp);
      GIF := TGIFImage.Create;
        try
          // Copy Bitmap Pixel to GIF Data
          if Form2.CheckBox3.Checked = true then
          begin
            GIF.Assign(bmp);
          end else begin
            GIF.Assign(bmpscale);
          end;
          // Create GIF File Image
          GIF.SaveToFile(SaveDialog1.FileName)
        finally
          GIF.Free;
          bmp.Free;
          Image.Free;
        end;
     end;

     if SaveDialog1.FilterIndex = 5 then
     begin
      { ---------- WMF EXPORT ------------------------------------------------ }

      bmp := TBitmap.Create;
      bmpscale := TBitmap.Create;
      bmp := TQRCode.GetBitmapImage(Memo1.Text,SpinEdit1.Value, SpinEdit2.Value);

      if Form2.CheckBox4.Checked = true then
      begin
        Screen.Cursor := crHourGlass;
        for x := 0 to BMP.Height do
        begin
          for y := 0 to BMP.Width do
          begin
            if BMP.Canvas.Pixels[y,x] = clBlack then
                BMP.Canvas.Pixels[y,x]:= Form2.Shape1.Brush.Color;
          end;
        end;
      end;

      if Form2.CheckBox2.Checked = true then
      begin
        if Form2.CheckBox3.Checked = true then begin
        Scale(bmp,bmpscale, Form2.SpinEdit4.Value, Form2.SpinEdit5.Value, true);
        end;
        if Form2.CheckBox3.Checked = false then begin
        Scale(bmp,bmpscale, Form2.SpinEdit4.Value, Form2.SpinEdit5.Value, false);
        end;
      end;

      MetaFile := TMetaFile.Create;
      try
        MetaFile.Height := bmp.Height;
        MetaFile.Width  := bmp.Width;
        MFCanvas := TMetafileCanvas.Create(MetaFile, 0);
         try
          MFCanvas.Draw(0, 0, BMP);
         finally
          MFCanvas.Free;
         end;
        MetaFile.SaveToFile(SaveDialog1.FileName);
      finally
        BMP.Free;
        MetaFile.Free;
      end;
     end;

     if SaveDialog1.FilterIndex = 6 then
     begin
      { ---------- EMF EXPORT ------------------------------------------------ }

      bmp := TBitmap.Create;
      bmpscale := TBitmap.Create;
      bmp := TQRCode.GetBitmapImage(Memo1.Text,SpinEdit1.Value, SpinEdit2.Value);

      if Form2.CheckBox4.Checked = true then
      begin
        Screen.Cursor := crHourGlass;
        for x := 0 to BMP.Height do
        begin
          for y := 0 to BMP.Width do
          begin
            if BMP.Canvas.Pixels[y,x] = clBlack then
                BMP.Canvas.Pixels[y,x]:= Form2.Shape1.Brush.Color;
          end;
        end;
      end;

      if Form2.CheckBox2.Checked = true then
      begin
        if Form2.CheckBox3.Checked = true then begin
        Scale(bmp,bmpscale, Form2.SpinEdit4.Value, Form2.SpinEdit5.Value, true);
        end;
        if Form2.CheckBox3.Checked = false then begin
        Scale(bmp,bmpscale, Form2.SpinEdit4.Value, Form2.SpinEdit5.Value, false);
        end;
      end;
     end;

     Metafile := TMetaFile.Create;
      try
        try
          //Bitmap.LoadFromFile(SourceFileName);
          Metafile.Height := bmp.Height;
          Metafile.Width  := bmp.Width;
          MetaCanvas := TMetafileCanvas.Create(Metafile, 0);
          try
            MetaCanvas.Draw(0, 0, bmp);
          finally
            MetaCanvas.Free;
          end;
        finally
          bmp.Free;
        end;
        Metafile.SaveToFile(SaveDialog1.FileName);
      finally
        Metafile.Free;
      end;

   end;
   Screen.Cursor := crDefault;
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  StatusBar1.Panels[3].Text := IntToStr(SpinEdit1.Value * 10) + 'px'
end;

procedure TForm1.SpinEdit2Change(Sender: TObject);
begin
  if Form2.CheckBox2.Checked = false then
  begin
    StatusBar1.Panels[1].Text := IntToStr(SpinEdit2.Value * 29) + 'x' +
                                 IntToStr(SpinEdit2.Value * 29) + ' px';
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  { If a specific target is to be specified for the image's output}
  //SaveDialog1.InitialDir := GetMyPicturesFolder;

  Application.HintPause := 0;
  Application.HintHidePause := 50000;

  if not FileExists(MainDir + 'Data\Drivers\pdf.dll') then
  begin
    ShowMessage('Error "pdf.dll" not found, check Drivers Folder !');
    Application.Terminate;
  end;

  if not FileExists(MainDir + 'Data\Drivers\png.dll') then
  begin
    ShowMessage('Error "png.dll" not found, check Drivers Folder !');
    Application.Terminate;
  end;

  if not FileExists(MainDir + 'Data\Drivers\quricol32.dll') then
  begin
    ShowMessage('Error "quricol32.dll" not found, check Drivers Folder !');
    Application.Terminate;
  end;

  if not FileExists(MainDir + 'Data\Drivers\quricol64.dll') then
  begin
    ShowMessage('Error "quricol64.dll" not found, check Drivers Folder !');
    Application.Terminate;
  end;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Label7.Top := ScrollBox1.Height div 2;
  Label7.Left := (ScrollBox1.Width div 2) -11;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
   SpinEdit2.OnChange(sender);
   SpinEdit1.OnChange(sender);
   Form2.Show;
   Form2.Close;
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
  B := TQRCode.GetBitmapImage(Memo1.Text, SpinEdit1.Value, SpinEdit2.Value);
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
     B := TQRCode.GetBitmapImage(Memo1.Text, SpinEdit1.Value, SpinEdit2.Value);
     normaldruckbitmap(B);
     finally
     B.Free;
     end;
   end;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
begin
  try
    form2 := TForm2.Create(nil);
    form2.ShowModal;
    finally
    end;
end;

procedure TForm1.UpdateImage;
 var
  B : TBitmap;
begin
  B := TQRCode.GetBitmapImage(Memo1.Text, SpinEdit1.Value, SpinEdit2.Value);
  try
    Image1.Height := StrToInt(SpinEdit2.Text) * 29;
    Image1.Width := StrToInt(SpinEdit2.Text) * 29;
    Image1.Picture.Bitmap.Assign(B);
  finally
  B.Free;
  end;
  StatusBar1.Panels[5].Text := 'Calculate done.';
  Screen.Cursor := crDefault;
end;

end.
