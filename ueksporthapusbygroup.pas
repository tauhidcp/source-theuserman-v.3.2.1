{

TheUserman : Simple User Manager (userman) Mikrotik

Author        : Ahmad Tauhid
Description   : Aplikasi manajemen user hotspot mikrotik
Date          : 01/05/2018
Version       : 3.2.1 stable (codename : Ramadhan)
Web Blog      : http://theuserman.blogspot.co.id

Dibangun menggunakan Bahasa Pemrograman Objek Pascal dan dicompile dengan IDE Lazarus v1.6.4.

Aplikasi ini merupakan implementasi dari MikroTik RouterOS API Client yang ditulis oleh Pavel Skuratovich (chupaka@gmail.com)

Free JPDF Pascal yang ditulis oleh Jean Patrick (jpsoft-sac-pa@hotmail.com) digunakan untuk membuat file PDF

Jika ada hal yang ingin ditanyakan silahkan hubungi kami melalui (ahmad.tauhid.cp@gmail.com)

License : anda dapat memodifikasi source code ini tapi tidak diperkenankan menghapus informasi author ini.
          jadilah orang yang cerdas dan hargailah jerih payah kami.

}

unit UEksportHapusByGroup;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, Buttons, RouterOSAPI, Grids, LCLIntf, libjpfpdf, ssl_openssl, encode_decode, inifiles,
  bahasa, uqrlogin;

type

  { TFEksportHapusByGroup }

  TFEksportHapusByGroup = class(TForm)
    BEksekusi: TBitBtn;
    CGroup: TComboBox;
    LBerdasarkan: TLabel;
    LStatus: TLabel;
    ProgressBar: TProgressBar;
    GridUserHotspot: TStringGrid;
    procedure BEksekusiClick(Sender: TObject);
    procedure CGroupKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FEksportHapusByGroup: TFEksportHapusByGroup;
  myinifile   : TIniFile;
  iArray : array of String;

implementation

uses UUtama, UDataUserHotspot;

{$R *.lfm}

{ TFEksportHapusByGroup }

function RefToCell(ARow, ACol: Integer): string;
begin
  Result := Chr(Ord('A') + ACol - 1) + IntToStr(ARow);
end;

procedure XlsWriteCellLabel(XlsStream: TStream; const ACol, ARow: Word;
  const AValue: string);
var
  L: Word;
const
  {$J+}
  CXlsLabel: array[0..5] of Word = ($204, 0, 0, 0, 0, 0);
  {$J-}
begin
  L := Length(AValue);
  CXlsLabel[1] := 8 + L;
  CXlsLabel[2] := ARow;
  CXlsLabel[3] := ACol;
  CXlsLabel[5] := L;
  XlsStream.WriteBuffer(CXlsLabel, SizeOf(CXlsLabel));
  XlsStream.WriteBuffer(Pointer(AValue)^, L);
end;

function SaveAsExcelFile(AGrid: TStringGrid; AFileName: string): Boolean;
const
  {$J+} CXlsBof: array[0..5] of Word = ($809, 8, 00, $10, 0, 0); {$J-}
  CXlsEof: array[0..1] of Word = ($0A, 00);
var
  FStream: TFileStream;
  I, J: Integer;
  nama : String;
begin
  Result := False;
  FStream := TFileStream.Create(PChar(AFileName), fmCreate or fmOpenWrite);
  try
    CXlsBof[4] := 0;
    FStream.WriteBuffer(CXlsBof, SizeOf(CXlsBof));
    for i := 0 to AGrid.ColCount - 1 do
      for j := 0 to AGrid.RowCount - 1 do
        XlsWriteCellLabel(FStream, I, J, AGrid.cells[i, j]);
    FStream.WriteBuffer(CXlsEof, SizeOf(CXlsEof));
    Result := True;
  finally
    FStream.Free;
  end;
end;

function SaveAsHTMLFile(AGrid: TStringGrid; AFileName: string; GroupName: string; KetName: string): Boolean;
var
  f : TextFile;
  after1, after2, after3, after4, after5 : string;
  i : integer;
    myinifile   : TIniFile;
begin
  Result := False;
  try
   AssignFile(f,AFileName);
      if (FileExists(ExtractFilePath(Application.exename)+'config.ini')) then
      begin
      myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
      with myinifile do begin
     Rewrite(f);
     Writeln(f,GSMDecode7Bit(ReadString('HTMLTEMPLATE','Header','0')));
     for i := 1 to AGrid.RowCount-1 do begin
     after1  := stringreplace(GSMDecode7Bit(ReadString('HTMLTEMPLATE','Row','0')), '%username%', AGrid.Cells[2,i],[rfReplaceAll, rfIgnoreCase]);
     after2  := stringreplace(after1, '%password%', AGrid.Cells[5,i],[rfReplaceAll, rfIgnoreCase]);
     after3  := stringreplace(after2, '%timelimit%', AGrid.Cells[4,i],[rfReplaceAll, rfIgnoreCase]);
     after4  := stringreplace(after3, '%validity%', AGrid.Cells[7,i],[rfReplaceAll, rfIgnoreCase]);
     after5  := stringreplace(after4, '%price%', AGrid.Cells[6,i],[rfReplaceAll, rfIgnoreCase]);
     Writeln(f,after5);
     after1:='';
     after2:='';
     after3:='';
     after4:='';
     after5:='';
     end;

     Writeln(f,GSMDecode7Bit(ReadString('HTMLTEMPLATE','Footer','0')));
      end;

      end;
     Result := True;

  finally
    CloseFile(f);
  end;
end;

function SaveAsPDFFile(AGrid: TStringGrid; AFileName: string; GroupName: string; KetName: string): Boolean;
var
JPFpdf1 : TJPFpdf;
i : integer;
begin
  Result := False;
  try
  JPFpdf1 := TJPFpdf.Create;
  with JPFpdf1 do begin
    AddPage;
    SetFont(ffTimes,fsBold,16);
    SetLineWidth(0.3);
    //SetFillColor(clGray);
    Cell(0, 10, Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','ExportPDFTitle')+' '+KetName+' "'+GroupName+'"','1',0,'C',0);
    Ln(15);
    SetFont(ffHelvetica,fsNormal,12);
    Cell(10,7,Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','Number'),'1',0,'C',0);
    Cell(40,7,Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','UserLogin'),'1',0,'C',0);
    Cell(50,7,Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','BandwidthLimitation'),'1',0,'C',0);
    Cell(50,7,Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','TimeLimit'),'1',0,'C',0);
    Cell(40,7,Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','Password'),'1',0,'C',0);
    for i := 1 to AGrid.RowCount-1 do begin
    Ln(7);
    Cell(10,7,IntToStr(i),'1',0,'C',0);
    Cell(40,7,AGrid.Cells[2,i],'1',0,'C',0);
    Cell(50,7,AGrid.Cells[3,i],'1',0,'C',0);
    Cell(50,7,AGrid.Cells[4,i],'1',0,'C',0);
    Cell(40,7,AGrid.Cells[5,i],'1',0,'C',0);
    end;
    SetAuthor('theuserman-v2.2.2');
    SaveToFile(AFileName);
    Result := True;
    end;
    finally
    JPFpdf1.Free;
  end;
end;


procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;

// Voucher Custom Template + QR Login
function SaveVoucherCustomQR(AGrid: TStringGrid; NmGroup, AFileName, namagb, nmk, user, pass, harga, valid, kolom : String): Boolean;
var
JPFpdf1 : TJPFpdf;
i, j, x, xx, x1, x2, x3, x4, y1, y2, y3, y4, yy, k, ba, l, jmlx, hasil : integer;
bagi : double;
OutPutList, hasilxx  : TStringList;
begin
   Result := False;
   // Cetak QR Code
     try
  JPFpdf1 := TJPFpdf.Create;
  with JPFpdf1 do begin
    AddPage;
    SetFont(ffTimes,fsBold,14);
    SetLineWidth(0.3);
    Cell(0, 10, Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','ExportVoucherTitle')+' '+nmk+' "'+NmGroup+'"','1',0,'C',0);
    Ln(15);
    if (kolom='Dua') then
    begin
    bagi := (AGrid.RowCount-1) / 2;
    OutPutList := TStringList.Create;
    hasilxx := TStringList.Create;
    try
    Split(',', FloatToStr(bagi), OutPutList);
    hasil := StrToInt(OutPutList[0]);
    except
    Split('.', FloatToStr(bagi), hasilxx);
    hasil := StrToInt(hasilxx[0]);
    end;
    xx := 10;
    yy := 25;
    x1 := 14;
    x2 := 45;
    y1 := 36;

    x3 := 79;  // tambahan
    y2 := 75; // tambahan
    y3 := 32; // tambahan

    x4 := 65;
    y4 := 48;
    k := 1;
    for i := 1 to hasil do begin
      for j := 1 to 2 do begin
      // Samping, Atas
      if (j=1) then begin
      Image(ExtractFilePath(Application.ExeName)+'tmp/back1-'+IntToStr(k)+namagb,xx,yy,86,53);
      Image(ExtractFilePath(Application.ExeName)+'tmp/qrlogin1-'+IntToStr(k)+'.bmp',x4,y4,25,25); // tambahan
      end else if (j=2) then
      begin
      Image(ExtractFilePath(Application.ExeName)+'tmp/back2-'+IntToStr(k)+namagb,xx,yy,86,53);
      Image(ExtractFilePath(Application.ExeName)+'tmp/qrlogin2-'+IntToStr(k)+'.bmp',x4,y4,25,25); // tambahan
      end;
      SetFont(ffHelvetica,fsBold,12);

      if (user='Yes') then Text(x1,y1,AGrid.Cells[2,k]);
      if (pass='Yes') then Text(x2,y1,AGrid.Cells[5,k]);
      if (valid='Yes') then Text(x1,y2,AGrid.Cells[7,k]); // tambahan
      if (harga='Yes') then Text(x3,y3,AGrid.Cells[6,k]); // tambahan

      x1 := x1+104;
      x2 := x2+104;
      x3 := x3+104; // tambahan
      x4 := x4+104; // tambahan
      xx := xx+104;
      k  := k+1;
      end;
      x1 := 14;
      x2 := 45;
      x3 := 79; // tambahan
      x4 := 65; // tambahan
      xx := 10;
      if (yy>=160) then
      begin
      if (i=hasil) then
      begin
      ba := (AGrid.RowCount-1) mod 2;
      if (ba>0) then begin
      AddPage;
      SetFont(ffHelvetica,fsBold,12);
      y1 := 36;
      y2 := 75; // tambahan
      y3 := 32; // tambahan
      y4 := 48; // tambahan
      yy := 25;
      end;
      end else
      begin
      AddPage;
      SetFont(ffHelvetica,fsBold,12);
      y1 := 36;
      y2 := 75; // tambahan
      y3 := 32; // tambahan
      y4 := 48; // tambahan
      yy := 25;
      end;
      end else
      begin
      yy := yy+65;
      y1 := y1+65;
      y2 := y2+65; // tambahan
      y3 := y3+65; // tambahan
      y4 := y4+65; // tambahan
      end;
    end;
    // Sisa hasil bagi
    ba := (AGrid.RowCount-1) mod 2;
    if (ba>0) then begin
    jmlx := hasil * 2;
    l := jmlx+1;
    for x := 1 to ba do begin
         Image(ExtractFilePath(Application.ExeName)+'tmp/back1-'+IntToStr(l)+namagb,xx,yy,86,53);
         Image(ExtractFilePath(Application.ExeName)+'tmp/qrlogin1-'+IntToStr(l)+'.bmp',x4,y4,25,25); // tambahan
         // Samping, Atas
      if (user='Yes') then Text(x1,y1,AGrid.Cells[2,l]);
      if (pass='Yes') then Text(x2,y1,AGrid.Cells[5,l]);
      if (valid='Yes') then Text(x1,y2,AGrid.Cells[7,l]); // tambahan
      if (harga='Yes') then Text(x3,y3,AGrid.Cells[6,l]); // tambahan
         x1 := x1+104;
         x2 := x2+104;
         x3 := x3+104; // tambahan
         x4 := x4+104; // tambahan
         xx := xx+104;
         l  := l+1;
    end;
    end;
    end else if (kolom='Tiga') then
    begin
    bagi := (AGrid.RowCount-1) / 3;
    OutPutList := TStringList.Create;
    hasilxx := TStringList.Create;
    try
    Split(',', FloatToStr(bagi), OutPutList);
    hasil := StrToInt(OutPutList[0]);
    except
    Split('.', FloatToStr(bagi), hasilxx);
    hasil := StrToInt(hasilxx[0]);
    end;

    xx := 10; // gambar
    yy := 22; // gambar

    x1 := 14;
    y1 := 29;

    x2 := 36;
    y2 := 54;

    x3 := 60;
    y3 := 27;

    x4 := 51;
    y4 := 36;

    k := 1;
    for i := 1 to hasil do begin
      for j := 1 to 3 do begin

      if (j=1) then begin
      Image(ExtractFilePath(Application.ExeName)+'tmp/back1-'+IntToStr(k)+namagb,xx,yy,62,34);
      Image(ExtractFilePath(Application.ExeName)+'tmp/qrlogin1-'+IntToStr(k)+'.bmp',x4,y4,15,15); // tambahan
      end else if (j=2) then
      begin
      Image(ExtractFilePath(Application.ExeName)+'tmp/back2-'+IntToStr(k)+namagb,xx,yy,62,34);
      Image(ExtractFilePath(Application.ExeName)+'tmp/qrlogin2-'+IntToStr(k)+'.bmp',x4,y4,15,15); // tambahan
      end else if (j=3) then
      begin
      Image(ExtractFilePath(Application.ExeName)+'tmp/back3-'+IntToStr(k)+namagb,xx,yy,62,34);
      Image(ExtractFilePath(Application.ExeName)+'tmp/qrlogin3-'+IntToStr(k)+'.bmp',x4,y4,15,15); // tambahan
      end;

      // Samping, Atas
      SetFont(ffHelvetica,fsBold,9);

      if (user='Yes') then Text(x1,y1,AGrid.Cells[2,k]);
      if (pass='Yes') then Text(x2,y1,AGrid.Cells[5,k]);
      if (valid='Yes') then Text(x1,y2,AGrid.Cells[7,k]); // tambahan
      if (harga='Yes') then Text(x3,y3,AGrid.Cells[6,k]); // tambahan

      x1 := x1+64;
      x2 := x2+64;
      x3 := x3+64; // tambahan
      x4 := x4+64;
      xx := xx+64;
      k  := k+1;
      end;
      x1 := 14;
      x2 := 36;
      x3 := 60; // tambahan
      x4 := 51;
      xx := 10;
      if (yy>=220) then
      begin
      if (i=hasil) then
      begin
      ba := (AGrid.RowCount-1) mod 3;
      if (ba>0) then begin
      AddPage;
      SetFont(ffHelvetica,fsBold,9);
      y1 := 29;
      y2 := 54; // tambahan
      y3 := 27; // tambahan
      y4 := 36;
      yy := 22;
      end;
      end else
      begin
      AddPage;
      SetFont(ffHelvetica,fsBold,9);
      y1 := 29;
      y2 := 54; // tambahan
      y3 := 27; // tambahan
      y4 := 36;
      yy := 22;
      end;
      end else
      begin
      yy := yy+36;
      y1 := y1+36;
      y2 := y2+36; // tambahan
      y3 := y3+36; // tambahan
      y4 := y4+36;
      end;
    end;
    // Sisa hasil bagi
    ba := (AGrid.RowCount-1) mod 3;
    if (ba>0) then begin
    jmlx := hasil * 3;
    l := jmlx+1;
    for x := 1 to ba do begin

      if (x=1) then begin
         Image(ExtractFilePath(Application.ExeName)+'tmp/back1-'+IntToStr(l)+namagb,xx,yy,62,34);
         Image(ExtractFilePath(Application.ExeName)+'tmp/qrlogin1-'+IntToStr(l)+'.bmp',x4,y4,15,15); // tambahan
      end else if (x=2) then
          begin
          Image(ExtractFilePath(Application.ExeName)+'tmp/back2-'+IntToStr(l)+namagb,xx,yy,62,34);
          Image(ExtractFilePath(Application.ExeName)+'tmp/qrlogin2-'+IntToStr(l)+'.bmp',x4,y4,15,15); // tambahan
      end;
        // Samping, Atas
      if (user='Yes') then Text(x1,y1,AGrid.Cells[2,l]);
      if (pass='Yes') then Text(x2,y1,AGrid.Cells[5,l]);
      if (valid='Yes') then Text(x1,y2,AGrid.Cells[7,l]); // tambahan
      if (harga='Yes') then Text(x3,y3,AGrid.Cells[6,l]); // tambahan
         x1 := x1+64;
         x2 := x2+64;
         x3 := x3+64; // tambahan
         x4 := x4+64; // tambahan
         xx := xx+64;
         l  := l+1;
    end;
    end;
    end;
    SetAuthor('theuserman-v2.2.2');
    SaveToFile(AFileName);
    Result := True;
    end;
    finally
    JPFpdf1.Free;
  end;
end;

// Voucher Custom Template
function SaveVoucherCustom(AGrid: TStringGrid; NmGroup, AFileName, nmk, namagbx, user, pass, harga, valid, kolom : String): Boolean;
var
JPFpdf1 : TJPFpdf;
i, j, x, xx, x1, x2, x3, x4, y1, y2, y3, y4, yy, k, ba, l, jmlx, hasil : integer;
bagi : double;
OutPutList, hasilxx  : TStringList;
begin
   Result := False;
     try
  JPFpdf1 := TJPFpdf.Create;
  with JPFpdf1 do begin
    AddPage;
    SetFont(ffTimes,fsBold,14);
    SetLineWidth(0.3);
    Cell(0, 10, Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','ExportVoucherTitle')+' '+nmk+' "'+NmGroup+'"','1',0,'C',0);
    Ln(15);
    if (kolom='Dua') then
    begin
    bagi := (AGrid.RowCount-1) / 2;
    OutPutList := TStringList.Create;
    hasilxx := TStringList.Create;
    try
    Split(',', FloatToStr(bagi), OutPutList);
    hasil := StrToInt(OutPutList[0]);
    except
    Split('.', FloatToStr(bagi), hasilxx);
    hasil := StrToInt(hasilxx[0]);
    end;
    xx := 10;
    yy := 25;
    x1 := 14;
    x2 := 45;
    y1 := 36;

    x3 := 79;  // tambahan
    y2 := 75; // tambahan
    y3 := 32; // tambahan
    k := 1;
    for i := 1 to hasil do begin
      for j := 1 to 2 do begin
      Image(ExtractFilePath(Application.ExeName)+'template/'+namagbx,xx,yy,86,53);
      // Samping, Atas
      SetFont(ffHelvetica,fsBold,12);
        if (user='Yes') then Text(x1,y1,AGrid.Cells[2,k]);
        if (pass='Yes') then Text(x2,y1,AGrid.Cells[5,k]);
        if (valid='Yes') then Text(x1,y2,AGrid.Cells[7,k]); // tambahan
        if (harga='Yes') then Text(x3,y3,AGrid.Cells[6,k]); // tambahan
      x1 := x1+104;
      x2 := x2+104;
      x3 := x3+104; // tambahan
      xx := xx+104;
      k  := k+1;
      end;
      x1 := 14;
      x2 := 45;
      x3 := 79; // tambahan
      xx := 10;
      if (yy>=160) then
      begin
      if (i=hasil) then
      begin
      ba := (AGrid.RowCount-1) mod 2;
      if (ba>0) then begin
      AddPage;
      SetFont(ffHelvetica,fsBold,12);
      y1 := 36;
      y2 := 75; // tambahan
      y3 := 32; // tambahan
      yy := 25;
      end;
      end else
      begin
      AddPage;
      SetFont(ffHelvetica,fsBold,12);
      y1 := 36;
      y2 := 75; // tambahan
      y3 := 32; // tambahan
      yy := 25;
      end;
      end else
      begin
      yy := yy+65;
      y1 := y1+65;
      y2 := y2+65; // tambahan
      y3 := y3+65; // tambahan
      end;
    end;
    // Sisa hasil bagi
    ba := (AGrid.RowCount-1) mod 2;
    if (ba>0) then begin
    jmlx := hasil * 2;
    l := jmlx+1;
    for x := 1 to ba do begin
         Image(ExtractFilePath(Application.ExeName)+'template/'+namagbx,xx,yy,86,53);
         // Samping, Atas
      if (user='Yes') then Text(x1,y1,AGrid.Cells[2,l]);
      if (pass='Yes') then Text(x2,y1,AGrid.Cells[5,l]);
      if (valid='Yes') then Text(x1,y2,AGrid.Cells[7,l]); // tambahan
      if (harga='Yes') then Text(x3,y3,AGrid.Cells[6,l]); // tambahan
         x1 := x1+104;
         x2 := x2+104;
         x3 := x3+104; // tambahan
         xx := xx+104;
         l  := l+1;
    end;
    end;
    end else if (kolom='Tiga') then
    begin
    bagi := (AGrid.RowCount-1) / 3;
    OutPutList := TStringList.Create;
    hasilxx := TStringList.Create;
    try
    Split(',', FloatToStr(bagi), OutPutList);
    hasil := StrToInt(OutPutList[0]);
    except
    Split('.', FloatToStr(bagi), hasilxx);
    hasil := StrToInt(hasilxx[0]);
    end;

    xx := 10; // gambar
    yy := 22; // gambar

    x1 := 14;
    y1 := 29;

    x2 := 36;
    y2 := 54;

    x3 := 60;
    y3 := 27;

    k := 1;
    for i := 1 to hasil do begin
      for j := 1 to 3 do begin

      Image(ExtractFilePath(Application.ExeName)+'template/'+namagbx,xx,yy,62,34);
      // Samping, Atas
      SetFont(ffHelvetica,fsBold,9);

      if (user='Yes') then Text(x1,y1,AGrid.Cells[2,k]);
      if (pass='Yes') then Text(x2,y1,AGrid.Cells[5,k]);
      if (valid='Yes') then Text(x1,y2,AGrid.Cells[7,k]); // tambahan
      if (harga='Yes') then Text(x3,y3,AGrid.Cells[6,k]); // tambahan

      x1 := x1+64;
      x2 := x2+64;
      x3 := x3+64; // tambahan
      xx := xx+64;
      k  := k+1;
      end;
      x1 := 14;
      x2 := 36;
      x3 := 60; // tambahan
      xx := 10;
      if (yy>=220) then
      begin
      if (i=hasil) then
      begin
      ba := (AGrid.RowCount-1) mod 3;
      if (ba>0) then begin
      AddPage;
      SetFont(ffHelvetica,fsBold,9);
      y1 := 29;
      y2 := 54; // tambahan
      y3 := 27; // tambahan
      yy := 22;
      end;
      end else
      begin
      AddPage;
      SetFont(ffHelvetica,fsBold,9);
      y1 := 29;
      y2 := 54; // tambahan
      y3 := 27; // tambahan
      yy := 22;
      end;
      end else
      begin
      yy := yy+36;
      y1 := y1+36;
      y2 := y2+36; // tambahan
      y3 := y3+36; // tambahan
      end;
    end;
    // Sisa hasil bagi
    ba := (AGrid.RowCount-1) mod 3;
    if (ba>0) then begin
    jmlx := hasil * 3;
    l := jmlx+1;
    for x := 1 to ba do begin
        Image(ExtractFilePath(Application.ExeName)+'template/'+namagbx,xx,yy,62,34);
         // Samping, Atas
      if (user='Yes') then Text(x1,y1,AGrid.Cells[2,l]);
      if (pass='Yes') then Text(x2,y1,AGrid.Cells[5,l]);
      if (valid='Yes') then Text(x1,y2,AGrid.Cells[7,l]); // tambahan
      if (harga='Yes') then Text(x3,y3,AGrid.Cells[6,l]); // tambahan
         x1 := x1+64;
         x2 := x2+64;
         x3 := x3+64; // tambahan
         xx := xx+64;
         l  := l+1;
    end;
    end;
    end;
    SetAuthor('theuserman-v2.2.2');
    SaveToFile(AFileName);
    Result := True;
    end;
    finally
    JPFpdf1.Free;
  end;

end;

// Voucher Template Default
function SaveVoucher(AGrid: TStringGrid; NmGroup, AFileName, nmk, user, pass, harga, valid, limit : String): Boolean;
var
JPFpdf1 : TJPFpdf;
i,j, x, xx, yy,k, ba, l, jmlx, hasil : integer;
bagi : double;
OutPutList,hasilxx  : TStringList;
userx, passx, hargax, validx, limitx : string;
begin
  Result := False;
  try
  JPFpdf1 := TJPFpdf.Create;
  with JPFpdf1 do begin
    AddPage;
    SetFont(ffTimes,fsBold,14);
    SetLineWidth(0.3);
    Cell(0, 10, Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','ExportVoucherTitle')+' '+nmk+' "'+NmGroup+'"','1',0,'C',0);
    Ln(15);
    SetFont(ffHelvetica,fsNormal,9);
    bagi := (AGrid.RowCount-1) / 4;
    OutPutList := TStringList.Create;
    hasilxx := TStringList.Create;
    try
    Split(',', FloatToStr(bagi), OutPutList);
    hasil := StrToInt(OutPutList[0]);
    except
    Split('.', FloatToStr(bagi), hasilxx);
    hasil := StrToInt(hasilxx[0]);
    end;
    xx := 10;
    yy := 22;
    k := 1;
    for i := 1 to hasil do begin
      for j := 1 to 4 do begin
      SetY(yy); // Jarak dari atas
      SetX(xx); // Jarak dari samping kiri +48
        if (user='Yes') then userx := Gunakan(CekBahasa(),'MAIN','UserLogin')+' : '+AGrid.Cells[2,k] else userx :='';
        if (pass='Yes') then passx := sLineBreak+Gunakan(CekBahasa(),'MAIN','Password')+' : '+AGrid.Cells[5,k] else passx :='';
        if (harga='Yes') then hargax := sLineBreak+Gunakan(CekBahasa(),'MAIN','Price')+' : '+AGrid.Cells[6,k] else hargax :='';
        if (valid='Yes') then validx := sLineBreak+Gunakan(CekBahasa(),'MAIN','Validity')+' : '+AGrid.Cells[7,k] else validx :='';
        if (limit='Yes') then limitx := sLineBreak+Gunakan(CekBahasa(),'MAIN','TimeLimit')+' : '+AGrid.Cells[4,k] else limitx :='';

        MultiCell(45,4, userx + passx + limitx + hargax + validx,'1','L',0);
      xx := xx+48;
      k  := k+1;
      end;
      xx := 10;
      if (yy>=225) then begin
           if (i=hasil) then
            begin
            ba := (AGrid.RowCount-1) mod 4;
            if (ba>0) then begin
            AddPage; yy:=22;
            end;
            end else
            begin
            AddPage; yy:=22;
            end;
            end else
            yy := yy+22;
          end;
    // Sisa hasil bagi
    ba := (AGrid.RowCount-1) mod 4;
    if (ba>0) then begin
    jmlx := hasil * 4;
    l := jmlx+1;
    for x := 1 to ba do begin
         SetY(yy); // Jarak dari atas
         SetX(xx); // Jarak dari samping kiri+48
      if (user='Yes') then userx := Gunakan(CekBahasa(),'MAIN','UserLogin')+' : '+AGrid.Cells[2,l] else userx :='';
      if (pass='Yes') then passx := sLineBreak+Gunakan(CekBahasa(),'MAIN','Password')+' : '+AGrid.Cells[5,l] else passx :='';
      if (harga='Yes') then hargax := sLineBreak+Gunakan(CekBahasa(),'MAIN','Price')+' : '+AGrid.Cells[6,l] else hargax :='';
      if (valid='Yes') then validx := sLineBreak+Gunakan(CekBahasa(),'MAIN','Validity')+' : '+AGrid.Cells[7,l] else validx :='';
      if (limit='Yes') then limitx := sLineBreak+Gunakan(CekBahasa(),'MAIN','TimeLimit')+' : '+AGrid.Cells[4,l] else limitx :='';

      MultiCell(45,4, userx + passx + limitx + hargax + validx,'1','L',0);
         xx := xx+48;
         l  := l+1;
    end;
    end;
    SetAuthor('theuserman-v2.2.2');
    SaveToFile(AFileName);
    Result := True;
    end;
    finally
    JPFpdf1.Free;
  end;
end;

procedure TFEksportHapusByGroup.BEksekusiClick(Sender: TObject);
var
Ras       : TRosApiResult;
i,j       : integer;
pa,pb     : array of AnsiString;
perintah  : array[1..2] of String;
s,t, nama,namagb, user,pass,hargax,valid,limit,kolom : String;
ROS       : TRosApiClient;
ketres    : String;
Hasil1, Hasil2 : TStringList;
keterangan, harga, berlaku : String;
Bitmap: TBitmap;
Source: TRect;
Dest: TRect;
q : integer;
begin
 ROS := TRosApiClient.Create;

     myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
      with myinifile do
      begin
      // Cek Item
      user := GSMDecode7Bit(ReadString('VOUCHER','UserLogin','0'));
      pass := GSMDecode7Bit(ReadString('VOUCHER','Password','0'));
      hargax := GSMDecode7Bit(ReadString('VOUCHER','Price','0'));
      valid := GSMDecode7Bit(ReadString('VOUCHER','Validity','0'));
      limit := GSMDecode7Bit(ReadString('VOUCHER','TimeLimit','0'));
      kolom := GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','VoucherColumn','0')));
      Free;
      end;

  {Jika Bandwidth Limitation }
  if (LBerdasarkan.Caption='BL') then
  begin
  if ((CGroup.Text='') or (CGroup.Text=Gunakan(CekBahasa(),'GLOBAL','SelectGroup'))) then
  MessageDlg(Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','SelectGroupWarning'),mtWarning,[mbok],0) else
    begin
    // Hapus User Hotspot
      if (LStatus.Caption='Hapus') then
      begin
        if MessageDlg(Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','DelUserConfirm_1')+' '+CGroup.Text+'? '+Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','DelUserConfirm_2'),mtConfirmation,[mbyes,mbno],0)=mrYes then
        begin
          if (FUtama.LTLS.Caption='TRUE') then
             ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
             ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);
        // Pecah Perintah Kedalam Array
         perintah[1]:='/ip/hotspot/user/print';
         perintah[2]:='?profile='+CGroup.Text;
         SetLength(pb, 0);
         for j := 1 to 2 do
         begin
         t := Trim(perintah[j]);
         if t <> '' then
         begin
         SetLength(pb, High(pb) + 2);
         pb[High(pb)] := t;
         end;
         end;
         //Eksekusi Perintah
           if High(pb) >= 0 then
           Ras := ROS.Query(pb,True)
           else
           begin
           MessageDlg('ERROR : ' + ROS.LastError,mtWarning,[mbok],0);
           Exit;
           end;
           // Cek Apakah ada Error
           if ROS.LastError <> '' then
           MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);

        if (Ras.RowsCount > 0) then
        begin
           ProgressBar.Max:=Ras.RowsCount;
           ProgressBar.Visible:=True;
            for i := 1 to Ras.RowsCount do
            begin
            ProgressBar.Position:=i;
            // Pecah Perintah Kedalam Array
            perintah[1]:='/ip/hotspot/user/remove';
            perintah[2]:='=.id='+Ras.ValueByName['.id'];
            // Menyimpan Perintah Kedalam Variabel pa
            SetLength(pa, 0);
            for j := 1 to 2 do
            begin
              s := Trim(perintah[j]);
              if s <> '' then
              begin
                SetLength(pa, High(pa) + 2);
                pa[High(pa)] := s;
              end;
            end;
            // Eksekusi Perintah
            if High(pa) >= 0 then
              ROS.Execute(pa)
              else
              begin
                MessageDlg('ERROR : ' + ROS.LastError,mtWarning,[mbok],0);
                Exit;
              end;
            // Cek Apakah ada Error
            if ROS.LastError <> '' then
            MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);
            Ras.Next;
            Sleep(10);
            end;
          FDataUserHotspot.FormShow(Sender);
          FDataUserHotspot.LID.Caption:='';
          FDataUserHotspot.LNama.Caption:='';
          FDataUserHotspot.LLimitUptime.Caption:='';
          FDataUserHotspot.LProfile.Caption:='';
          FDataUserHotspot.LUptime.Caption:='';
          FDataUserHotspot.LPassword.Caption:='';
          FDataUserHotspot.LComment.Caption:='';
          end else MessageDlg(Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','DataEmpty'),mtWarning,[mbok],0);
          end else Abort;
          Ras.Free;
          ProgressBar.Visible:=False;
      end else
      // Eksport User Hotspot
      if (LStatus.Caption='Eksport') then
      begin
      FUtama.SaveDialog.Filter:='File PDF (*.pdf)|*.pdf';
      if FUtama.SaveDialog.Execute then
      begin

      if (FUtama.LTLS.Caption='TRUE') then
         ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
         ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);
      // Pecah Perintah Kedalam Array
      perintah[1]:='/ip/hotspot/user/print';
      perintah[2]:='?profile='+CGroup.Text;
      SetLength(pb, 0);
      for j := 1 to 2 do
      begin
      t := Trim(perintah[j]);
      if t <> '' then
      begin
      SetLength(pb, High(pb) + 2);
      pb[High(pb)] := t;
      end;
      end;
      //Eksekusi Perintah
      if High(pb) >= 0 then
      Ras := ROS.Query(pb,True)
      else
      begin
      MessageDlg('ERROR : ' + ROS.LastError,mtWarning,[mbok],0);
      Exit;
      end;
      // Cek Apakah ada Error
      if ROS.LastError <> '' then
      MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);

      GridUserHotspot.RowCount := Ras.RowsCount+1;

      // Ukuran Kolom
      GridUserHotspot.ColCount := 11;

      j := 1;
      while not Ras.Eof do
      begin
      for i := 1 to Ras.RowsCount do
      begin
      try
      Hasil1 := TStringList.Create;
      Hasil2 := TStringList.Create;
      Split('"', Ras.ValueByName['comment'], Hasil1);
      if (Hasil1.Count>1) then
      begin
      harga      := Hasil1[1];
      berlaku    := Hasil1[2];
      Split(':', Hasil1[0], Hasil2);
      keterangan := Hasil2[0];
      end else
      begin
      harga      := '-';
      berlaku    := '-';
      keterangan := Ras.ValueByName['comment'];
      end;
      except
      end;

      GridUserHotspot.Cells[0,j] := '';
      GridUserHotspot.Cells[1,j] := Ras.ValueByName['.id'];
      GridUserHotspot.Cells[2,j] := Ras.ValueByName['name'];
      GridUserHotspot.Cells[3,j] := Ras.ValueByName['profile'];
      GridUserHotspot.Cells[4,j] := Ras.ValueByName['limit-uptime'];
      GridUserHotspot.Cells[5,j] := Ras.ValueByName['password'];
      GridUserHotspot.Cells[6,j] := harga;
      GridUserHotspot.Cells[7,j] := berlaku;
      GridUserHotspot.Cells[8,j] := Ras.ValueByName['uptime'];
      GridUserHotspot.Cells[9,j] := keterangan;
      GridUserHotspot.Cells[10,j] := Ras.ValueByName['disabled'];
      j := j+1;
      Ras.Next;
      end;
      end;

      if (ExtractFileExt(FUtama.SaveDialog.FileName)='') then nama:=FUtama.SaveDialog.FileName+'.pdf' else nama:=FUtama.SaveDialog.FileName;
      myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
      with myinifile do
      begin
      if (ReadString('CONFIG','Template','0')=GSMEncode7Bit(GSMEncode7Bit('default'))) then
      begin
      if SaveVoucher(GridUserHotspot, CGroup.Text, nama, Gunakan(CekBahasa(),'GLOBAL','Group'), user, pass, hargax, valid, limit) then
         if MessageDlg(Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','ExportVoucherSuccess')+' ('+nama+'). '+Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','OpenDocConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
         begin
         OpenDocument(nama);
         end;
      end else
      begin
      //begin
            // Cek Status Apakah Login QR Sudah diseting
            if (ReadString('CONFIG','HotspotAddress','0')='') then begin
            namagb := GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0')));
            if SaveVoucherCustom(GridUserHotspot, CGroup.Text, nama, Gunakan(CekBahasa(),'GLOBAL','Group'), namagb, user, pass, hargax, valid, kolom) then
               if MessageDlg(Gunakan(CekBahasa(),'MAIN','ExportVoucherSuccess')+' ('+nama+'). '+Gunakan(CekBahasa(),'MAIN','OpenDocConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
               begin
               OpenDocument(nama);
               end;
            end else begin
            FQRLogin.GroupQRLogin.Caption:=Gunakan(CekBahasa(),'GLOBAL','QRCodeLoginGen');
            FQRLogin.Show;
            FQRLogin.ProgressQRLogin.Max:=GridUserHotspot.RowCount-1;
            // Buat QR Code dan Simpan ke Folder tmp
            for i := 1 to GridUserHotspot.RowCount-1 do begin
            FQRLogin.ProgressQRLogin.Position:=i;
            FQRLogin.QRLogin.Text:='http://'+GSMDecode7Bit(GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','HotspotAddress','0'))))+'/login?username='+GridUserHotspot.Cells[2,i]+'&password='+GridUserHotspot.Cells[5,i];
            FQRLogin.QRLogin.Repaint;
            Bitmap := TBitmap.Create;
            try
              with Bitmap do
              begin
                Width := FQRLogin.QRLogin.Width;
                Height := FQRLogin.QRLogin.Height;
                Dest := Rect(0, 0, Width, Height);
              end;
              with FQRLogin.QRLogin do
                Source := Rect(0, 0, Width, Height);
                Bitmap.Canvas.CopyRect(Dest, FQRLogin.QRLogin.Canvas, Source);
                Bitmap.SaveToFile('tmp/qrlogin1-'+IntToStr(i)+'.bmp');
                Bitmap.SaveToFile('tmp/qrlogin2-'+IntToStr(i)+'.bmp');
                Bitmap.SaveToFile('tmp/qrlogin3-'+IntToStr(i)+'.bmp');
            finally
              Bitmap.Free;
            end;
            CopyFile(ExtractFilePath(Application.ExeName)+'template/'+GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0'))),ExtractFilePath(Application.ExeName)+'tmp/back1-'+IntToStr(i)+GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0'))));
            CopyFile(ExtractFilePath(Application.ExeName)+'template/'+GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0'))),ExtractFilePath(Application.ExeName)+'tmp/back2-'+IntToStr(i)+GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0'))));
            CopyFile(ExtractFilePath(Application.ExeName)+'template/'+GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0'))),ExtractFilePath(Application.ExeName)+'tmp/back3-'+IntToStr(i)+GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0'))));
            Sleep(10);
            end;
            FQRLogin.Hide;
            // End Buat Gambar QR Code Login
            namagb := GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0')));
            if SaveVoucherCustomQR(GridUserHotspot, CGroup.Text, nama, namagb, Gunakan(CekBahasa(),'GLOBAL','Group'), user, pass, hargax, valid, kolom) then
             begin
               if MessageDlg(Gunakan(CekBahasa(),'MAIN','ExportVoucherSuccess')+' ('+nama+'). '+Gunakan(CekBahasa(),'MAIN','OpenDocConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
               begin
               OpenDocument(nama);
               end;
             // Hapus QR Login
            for i := 1 to GridUserHotspot.RowCount-1 do begin
            DeleteFile('tmp/qrlogin1-'+IntToStr(i)+'.bmp');
            DeleteFile('tmp/qrlogin2-'+IntToStr(i)+'.bmp');
            DeleteFile('tmp/qrlogin3-'+IntToStr(i)+'.bmp');
            DeleteFile('tmp/back1-'+IntToStr(i)+GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0'))));
            DeleteFile('tmp/back2-'+IntToStr(i)+GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0'))));
            DeleteFile('tmp/back3-'+IntToStr(i)+GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0'))));
            end;
            end;
            end;
            end;
      Free;
      end;

      end;
      end else
      // Hapus Counter User
      if (LStatus.Caption='Clear') then
      begin
        if MessageDlg(Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','CCounterConfirm_1')+' '+CGroup.Text+'? '+Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','CCounterConfirm_2'),mtConfirmation,[mbyes,mbno],0)=mrYes then
        begin
          if (FUtama.LTLS.Caption='TRUE') then
             ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
             ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);
        // Pecah Perintah Kedalam Array
         perintah[1]:='/ip/hotspot/user/print';
         perintah[2]:='?profile='+CGroup.Text;
         SetLength(pb, 0);
         for j := 1 to 2 do
         begin
         t := Trim(perintah[j]);
         if t <> '' then
         begin
         SetLength(pb, High(pb) + 2);
         pb[High(pb)] := t;
         end;
         end;
         //Eksekusi Perintah
           if High(pb) >= 0 then
           Ras := ROS.Query(pb,True)
           else
           begin
           MessageDlg('ERROR : ' + ROS.LastError,mtWarning,[mbok],0);
           Exit;
           end;
           // Cek Apakah ada Error
           if ROS.LastError <> '' then
           MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);

        if (Ras.RowsCount > 0) then
        begin
           ProgressBar.Max:=Ras.RowsCount;
           ProgressBar.Visible:=True;
            for i := 1 to Ras.RowsCount do
            begin
            ProgressBar.Position:=i;
            // Pecah Perintah Kedalam Array
            perintah[1]:='/ip/hotspot/user/reset-counters';
            perintah[2]:='=.id='+Ras.ValueByName['.id'];
            // Menyimpan Perintah Kedalam Variabel pa
            SetLength(pa, 0);
            for j := 1 to 2 do
            begin
              s := Trim(perintah[j]);
              if s <> '' then
              begin
                SetLength(pa, High(pa) + 2);
                pa[High(pa)] := s;
              end;
            end;
            // Eksekusi Perintah
            if High(pa) >= 0 then
              ROS.Execute(pa)
              else
              begin
                MessageDlg('ERROR : ' + ROS.LastError,mtWarning,[mbok],0);
                Exit;
              end;
            // Cek Apakah ada Error
            if ROS.LastError <> '' then
            MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);
            Ras.Next;
            Sleep(10);
            end;
          FDataUserHotspot.FormShow(Sender);
          FDataUserHotspot.LID.Caption:='';
          FDataUserHotspot.LNama.Caption:='';
          FDataUserHotspot.LLimitUptime.Caption:='';
          FDataUserHotspot.LProfile.Caption:='';
          FDataUserHotspot.LUptime.Caption:='';
          FDataUserHotspot.LPassword.Caption:='';
          FDataUserHotspot.LComment.Caption:='';
          end else MessageDlg(Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','DataEmpty'),mtWarning,[mbok],0);
          end else Abort;
          Ras.Free;
          ProgressBar.Visible:=False;
      end else
      // Eksport User Hotspot PDF
      if (LStatus.Caption='EksportPDF') then
      begin
      FUtama.SaveDialog.Filter:='File PDF (*.pdf)|*.pdf';
      if FUtama.SaveDialog.Execute then
      begin

      if (FUtama.LTLS.Caption='TRUE') then
         ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
         ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);
      // Pecah Perintah Kedalam Array
      perintah[1]:='/ip/hotspot/user/print';
      perintah[2]:='?profile='+CGroup.Text;
      SetLength(pb, 0);
      for j := 1 to 2 do
      begin
      t := Trim(perintah[j]);
      if t <> '' then
      begin
      SetLength(pb, High(pb) + 2);
      pb[High(pb)] := t;
      end;
      end;
      //Eksekusi Perintah
      if High(pb) >= 0 then
      Ras := ROS.Query(pb,True)
      else
      begin
      MessageDlg('ERROR : ' + ROS.LastError,mtWarning,[mbok],0);
      Exit;
      end;
      // Cek Apakah ada Error
      if ROS.LastError <> '' then
      MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);

      GridUserHotspot.RowCount := Ras.RowsCount+1;

      // Ukuran Kolom
      GridUserHotspot.ColCount := 11;

      j := 1;
      while not Ras.Eof do
      begin
      for i := 1 to Ras.RowsCount do
      begin
      try
      Hasil1 := TStringList.Create;
      Hasil2 := TStringList.Create;
      Split('"', Ras.ValueByName['comment'], Hasil1);
      if (Hasil1.Count>1) then
      begin
      harga      := Hasil1[1];
      berlaku    := Hasil1[2];
      Split(':', Hasil1[0], Hasil2);
      keterangan := Hasil2[0];
      end else
      begin
      harga      := '-';
      berlaku    := '-';
      keterangan := Ras.ValueByName['comment'];
      end;
      except
      end;

      GridUserHotspot.Cells[0,j] := '';
      GridUserHotspot.Cells[1,j] := Ras.ValueByName['.id'];
      GridUserHotspot.Cells[2,j] := Ras.ValueByName['name'];
      GridUserHotspot.Cells[3,j] := Ras.ValueByName['profile'];
      GridUserHotspot.Cells[4,j] := Ras.ValueByName['limit-uptime'];
      GridUserHotspot.Cells[5,j] := Ras.ValueByName['password'];
      GridUserHotspot.Cells[6,j] := harga;
      GridUserHotspot.Cells[7,j] := berlaku;
      GridUserHotspot.Cells[8,j] := Ras.ValueByName['uptime'];
      GridUserHotspot.Cells[9,j] := keterangan;
      GridUserHotspot.Cells[10,j] := Ras.ValueByName['disabled'];
      j := j+1;
      Ras.Next;
      end;
      end;
      if (ExtractFileExt(FUtama.SaveDialog.FileName)='') then nama:=FUtama.SaveDialog.FileName+'.pdf' else nama:=FUtama.SaveDialog.FileName;
      if SaveAsPDFFile(GridUserHotspot, nama, CGroup.Text, Gunakan(CekBahasa(),'GLOBAL','Group')) then
         if MessageDlg(Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','ExportPDFSuccess')+' ('+nama+'). '+Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','OpenDocConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
         begin
         OpenDocument(nama);
         end;
      end;
      end else
      	// Eksport User Hotspot HTML
      if (LStatus.Caption='EksportHTML') then
      begin
      FUtama.SaveDialog.Filter:='File HTML (*.html)|*.html';
      if FUtama.SaveDialog.Execute then
      begin

      if (FUtama.LTLS.Caption='TRUE') then
         ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
         ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);
      // Pecah Perintah Kedalam Array
      perintah[1]:='/ip/hotspot/user/print';
      perintah[2]:='?profile='+CGroup.Text;
      SetLength(pb, 0);
      for j := 1 to 2 do
      begin
      t := Trim(perintah[j]);
      if t <> '' then
      begin
      SetLength(pb, High(pb) + 2);
      pb[High(pb)] := t;
      end;
      end;
      //Eksekusi Perintah
      if High(pb) >= 0 then
      Ras := ROS.Query(pb,True)
      else
      begin
      MessageDlg('ERROR : ' + ROS.LastError,mtWarning,[mbok],0);
      Exit;
      end;
      // Cek Apakah ada Error
      if ROS.LastError <> '' then
      MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);

      GridUserHotspot.RowCount := Ras.RowsCount+1;

      // Ukuran Kolom
      GridUserHotspot.ColCount := 11;

      j := 1;
      while not Ras.Eof do
      begin
      for i := 1 to Ras.RowsCount do
      begin
      try
      Hasil1 := TStringList.Create;
      Hasil2 := TStringList.Create;
      Split('"', Ras.ValueByName['comment'], Hasil1);
      if (Hasil1.Count>1) then
      begin
      harga      := Hasil1[1];
      berlaku    := Hasil1[2];
      Split(':', Hasil1[0], Hasil2);
      keterangan := Hasil2[0];
      end else
      begin
      harga      := '-';
      berlaku    := '-';
      keterangan := Ras.ValueByName['comment'];
      end;
      except
      end;

      GridUserHotspot.Cells[0,j] := '';
      GridUserHotspot.Cells[1,j] := Ras.ValueByName['.id'];
      GridUserHotspot.Cells[2,j] := Ras.ValueByName['name'];
      GridUserHotspot.Cells[3,j] := Ras.ValueByName['profile'];
      GridUserHotspot.Cells[4,j] := Ras.ValueByName['limit-uptime'];
      GridUserHotspot.Cells[5,j] := Ras.ValueByName['password'];
      GridUserHotspot.Cells[6,j] := harga;
      GridUserHotspot.Cells[7,j] := berlaku;
      GridUserHotspot.Cells[8,j] := Ras.ValueByName['uptime'];
      GridUserHotspot.Cells[9,j] := keterangan;
      GridUserHotspot.Cells[10,j] := Ras.ValueByName['disabled'];
      j := j+1;
      Ras.Next;
      end;
      end;
      if (ExtractFileExt(FUtama.SaveDialog.FileName)='') then nama:=FUtama.SaveDialog.FileName+'.html' else nama:=FUtama.SaveDialog.FileName;
      if SaveAsHTMLFile(GridUserHotspot, nama, CGroup.Text, Gunakan(CekBahasa(),'GLOBAL','Group')) then
         if MessageDlg(Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','ExportHTMLSuccess')+' ('+nama+'). '+Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','OpenDocConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
         begin
         OpenDocument(nama);
         end;
      end;
      end else
      // Eksport User Hotspot Excel
      if (LStatus.Caption='EksportXLS') then
      begin
      FUtama.SaveDialog.Filter:='File Excel (*.xls)|*.xls';
      if FUtama.SaveDialog.Execute then
      begin

      if (FUtama.LTLS.Caption='TRUE') then
         ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
         ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);
      // Pecah Perintah Kedalam Array
      perintah[1]:='/ip/hotspot/user/print';
      perintah[2]:='?profile='+CGroup.Text;
      SetLength(pb, 0);
      for j := 1 to 2 do
      begin
      t := Trim(perintah[j]);
      if t <> '' then
      begin
      SetLength(pb, High(pb) + 2);
      pb[High(pb)] := t;
      end;
      end;
      //Eksekusi Perintah
      if High(pb) >= 0 then
      Ras := ROS.Query(pb,True)
      else
      begin
      MessageDlg('ERROR : ' + ROS.LastError,mtWarning,[mbok],0);
      Exit;
      end;
      // Cek Apakah ada Error
      if ROS.LastError <> '' then
      MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);

      GridUserHotspot.RowCount := Ras.RowsCount+1;

      // Ukuran Kolom
      GridUserHotspot.ColCount := 14;

      j := 1;
      while not Ras.Eof do
      begin
      for i := 1 to Ras.RowsCount do
      begin
      try
      Hasil1 := TStringList.Create;
      Hasil2 := TStringList.Create;
      Split('"', Ras.ValueByName['comment'], Hasil1);
      if (Hasil1.Count>1) then
      begin
      harga      := Hasil1[1];
      berlaku    := Hasil1[2];
      Split(':', Hasil1[0], Hasil2);
      keterangan := Hasil2[0];
      end else
      begin
      harga      := '-';
      berlaku    := '-';
      keterangan := Ras.ValueByName['comment'];
      end;
      except
      end;

      GridUserHotspot.Cells[0,j] := '';
      GridUserHotspot.Cells[1,j] := Ras.ValueByName['.id'];
      GridUserHotspot.Cells[2,j] := Ras.ValueByName['name'];
      GridUserHotspot.Cells[3,j] := Ras.ValueByName['profile'];
      GridUserHotspot.Cells[4,j] := Ras.ValueByName['limit-uptime'];
      GridUserHotspot.Cells[5,j] := Ras.ValueByName['password'];
      GridUserHotspot.Cells[6,j] := harga;
      GridUserHotspot.Cells[7,j] := berlaku;
      GridUserHotspot.Cells[8,j] := Ras.ValueByName['uptime'];
      GridUserHotspot.Cells[9,j] := keterangan;
      GridUserHotspot.Cells[10,j] := Ras.ValueByName['disabled'];
      GridUserHotspot.Cells[11,j] := Ras.ValueByName['limit-bytes-out'];
      GridUserHotspot.Cells[12,j] := Ras.ValueByName['limit-bytes-in'];
      GridUserHotspot.Cells[13,j] := Ras.ValueByName['limit-bytes-total'];
      j := j+1;
      Ras.Next;
      end;
      end;
      if (ExtractFileExt(FUtama.SaveDialog.FileName)='') then nama:=FUtama.SaveDialog.FileName+'.xls' else nama:=FUtama.SaveDialog.FileName;
      if SaveAsExcelFile(GridUserHotspot, nama) then
         if MessageDlg(Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','ExportExcelSuccess')+' ('+nama+'). '+Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','OpenDocConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
         begin
         OpenDocument(nama);
         end;
      end;
      end;
    end;
  end else
  { Jika Komentar }
  if (LBerdasarkan.Caption='CM') then
    begin
    if ((CGroup.Text='') or (CGroup.Text=Gunakan(CekBahasa(),'GLOBAL','SelectComent'))) then
    MessageDlg(Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','SelectComentWarning'),mtWarning,[mbok],0) else
      begin
      // Hapus User Hotspot Berdasarkan Komentar
        if (LStatus.Caption='Hapus') then
        begin
          if MessageDlg(Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','DelUserConfirm_0')+' '+CGroup.Text+'? '+Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','DelUserConfirm_2'),mtConfirmation,[mbyes,mbno],0)=mrYes then
          begin
            if (FUtama.LTLS.Caption='TRUE') then
               ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
               ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

  	  Ras := ROS.Query(['/ip/hotspot/user/print'], True);

  	  if (Ras.RowsCount > 0) then
  	    begin
            ProgressBar.Max:=Ras.RowsCount;
            ProgressBar.Visible:=True;
  	    for i := 1 to Ras.RowsCount do
  	       begin
  		   // Pecah Komentar Ras
  		   try
  		   Hasil1 := TStringList.Create;
  		   Hasil2 := TStringList.Create;
  		   Split('"', Ras.ValueByName['comment'], Hasil1);
  	       if (Hasil1.Count>1) then
  		   begin
  		   Split(':', Hasil1[0], Hasil2);
  		   ketres := Hasil2[0];
  		   end else
  		   begin
  		   ketres := Ras.ValueByName['comment'];
  		   end;
  		   except
  		   end;
  		   // Cek Apakah Komentar Sama
  	       if (Trim(ketres)=CGroup.Text) then
  		   begin
  		   perintah[1]:='/ip/hotspot/user/remove';
  		   perintah[2]:='=.id='+Ras.ValueByName['.id'];
  		   // Menyimpan Perintah Kedalam Variabel pa
  		   SetLength(pa, 0);
  		   for j := 1 to 2 do
  		   begin
  		   s := Trim(perintah[j]);
  		   if s <> '' then
  		   begin
  		   SetLength(pa, High(pa) + 2);
  		   pa[High(pa)] := s;
  		   end;
  		   end;
  		   // Eksekusi Perintah
  		   if High(pa) >= 0 then
  		   ROS.Execute(pa)
  		   else
  		   begin
  		   MessageDlg('ERROR : ' + ROS.LastError,mtWarning,[mbok],0);
  		   Exit;
  		   end;
  		   // Cek Apakah ada Error
  		   if ROS.LastError <> '' then
  		   MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);
  		   end;
                   Sleep(10);
  		   Ras.Next;
  	       end;
  		   FDataUserHotspot.FormShow(Sender);
  		   FDataUserHotspot.LID.Caption:='';
  		   FDataUserHotspot.LNama.Caption:='';
  		   FDataUserHotspot.LLimitUptime.Caption:='';
  		   FDataUserHotspot.LProfile.Caption:='';
  		   FDataUserHotspot.LUptime.Caption:='';
  		   FDataUserHotspot.LPassword.Caption:='';
  		   FDataUserHotspot.LComment.Caption:='';
            end else MessageDlg(Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','DataEmpty'),mtWarning,[mbok],0);
            end else Abort;
            Ras.Free;
            ProgressBar.Visible:=False;
        end else // End Hapus Berdasarkan Komentar
       // Clear Counter Berdasarkan Komentar
        if (LStatus.Caption='Clear') then
        begin
          if MessageDlg(Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','CCounterConfirm_0')+' '+CGroup.Text+'? '+Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','DelUserConfirm_2'),mtConfirmation,[mbyes,mbno],0)=mrYes then
          begin
            if (FUtama.LTLS.Caption='TRUE') then
               ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
               ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);
  	  Ras := ROS.Query(['/ip/hotspot/user/print'], True);
  	  if (Ras.RowsCount > 0) then
  	    begin
            ProgressBar.Max:=Ras.RowsCount;
            ProgressBar.Visible:=True;
  	    for i := 1 to Ras.RowsCount do
  	       begin
  		   // Pecah Komentar Ras
  		   try
  		   Hasil1 := TStringList.Create;
  		   Hasil2 := TStringList.Create;
  		   Split('"', Ras.ValueByName['comment'], Hasil1);
  	       if (Hasil1.Count>1) then
  		   begin
  		   Split(':', Hasil1[0], Hasil2);
  		   ketres := Hasil2[0];
  		   end else
  		   begin
  		   ketres := Ras.ValueByName['comment'];
  		   end;
  		   except
  		   end;
  		   // Cek Apakah Komentar Sama
  	       if (Trim(ketres)=CGroup.Text) then
  		   begin
  		   perintah[1]:='/ip/hotspot/user/reset-counters';
  		   perintah[2]:='=.id='+Ras.ValueByName['.id'];
  		   // Menyimpan Perintah Kedalam Variabel pa
  		   SetLength(pa, 0);
  		   for j := 1 to 2 do
  		   begin
  		   s := Trim(perintah[j]);
  		   if s <> '' then
  		   begin
  		   SetLength(pa, High(pa) + 2);
  		   pa[High(pa)] := s;
  		   end;
  		   end;
  		   // Eksekusi Perintah
  		   if High(pa) >= 0 then
  		   ROS.Execute(pa)
  		   else
  		   begin
  		   MessageDlg('ERROR : ' + ROS.LastError,mtWarning,[mbok],0);
  		   Exit;
  		   end;
  		   // Cek Apakah ada Error
  		   if ROS.LastError <> '' then
  		   MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);
  		   end;
                   Sleep(10);
  		   Ras.Next;
  	       end;
  		   FDataUserHotspot.FormShow(Sender);
  		   FDataUserHotspot.LID.Caption:='';
  		   FDataUserHotspot.LNama.Caption:='';
  		   FDataUserHotspot.LLimitUptime.Caption:='';
  		   FDataUserHotspot.LProfile.Caption:='';
  		   FDataUserHotspot.LUptime.Caption:='';
  		   FDataUserHotspot.LPassword.Caption:='';
  		   FDataUserHotspot.LComment.Caption:='';
            end else MessageDlg(Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','DataEmpty'),mtWarning,[mbok],0);
            end else Abort;
            Ras.Free;
            ProgressBar.Visible:=False;
        end else // End Clear Counter Berdasarkan Komentar

          // Eksport User Hotspot PDF Komentar
        if (LStatus.Caption='EksportPDF') then
          begin
          FUtama.SaveDialog.Filter:='File PDF (*.pdf)|*.pdf';
          if FUtama.SaveDialog.Execute then
          begin

          if (FUtama.LTLS.Caption='TRUE') then
             ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
             ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

          GridUserHotspot.RowCount := 1;

          // Ukuran Kolom
          GridUserHotspot.ColCount := 11;

          j := 1;

          Ras := ROS.Query(['/ip/hotspot/user/print'], True);

  	  if (Ras.RowsCount > 0) then
  	    begin
  	    for i := 1 to Ras.RowsCount do
  	       begin
  		   // Pecah Komentar Ras
  		   try
  		   Hasil1 := TStringList.Create;
  		   Hasil2 := TStringList.Create;
  		   Split('"', Ras.ValueByName['comment'], Hasil1);
  	       if (Hasil1.Count>1) then
  		   begin
  		   Split(':', Hasil1[0], Hasil2);
  		   ketres := Hasil2[0];
  		   end else
  		   begin
  		   ketres := Ras.ValueByName['comment'];
  		   end;
  		   except
  		   end;
  		   // Cek Apakah Komentar Sama
  	       if (Trim(ketres)=CGroup.Text) then
  		   begin
                   GridUserHotspot.RowCount := GridUserHotspot.RowCount+1;
                   try
                   Hasil1 := TStringList.Create;
                   Hasil2 := TStringList.Create;
                   Split('"', Ras.ValueByName['comment'], Hasil1);
                   if (Hasil1.Count>1) then
                   begin
                   harga      := Hasil1[1];
                   berlaku    := Hasil1[2];
                   Split(':', Hasil1[0], Hasil2);
                   keterangan := Hasil2[0];
                   end else
                   begin
                   harga      := '-';
                   berlaku    := '-';
                   keterangan := Ras.ValueByName['comment'];
                   end;
                   except
                   end;

                   GridUserHotspot.Cells[0,j] := '';
                   GridUserHotspot.Cells[1,j] := Ras.ValueByName['.id'];
                   GridUserHotspot.Cells[2,j] := Ras.ValueByName['name'];
                   GridUserHotspot.Cells[3,j] := Ras.ValueByName['profile'];
                   GridUserHotspot.Cells[4,j] := Ras.ValueByName['limit-uptime'];
                   GridUserHotspot.Cells[5,j] := Ras.ValueByName['password'];
                   GridUserHotspot.Cells[6,j] := harga;
                   GridUserHotspot.Cells[7,j] := berlaku;
                   GridUserHotspot.Cells[8,j] := Ras.ValueByName['uptime'];
                   GridUserHotspot.Cells[9,j] := keterangan;
                   GridUserHotspot.Cells[10,j] := Ras.ValueByName['disabled'];
                   j := j+1;
                   end;
                   Ras.Next;
               end;
              end;
          if (ExtractFileExt(FUtama.SaveDialog.FileName)='') then nama:=FUtama.SaveDialog.FileName+'.pdf' else nama:=FUtama.SaveDialog.FileName;
          if SaveAsPDFFile(GridUserHotspot, nama, CGroup.Text, Gunakan(CekBahasa(),'GLOBAL','Coment')) then
             if MessageDlg(Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','ExportPDFSuccess')+' ('+nama+'). '+Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','OpenDocConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
             begin
             OpenDocument(nama);
             end;
          end;
          end else // End Eksport PDF Komentar
            // Eksport User Hotspot HTML Komentar
        if (LStatus.Caption='EksportHTML') then
          begin
          FUtama.SaveDialog.Filter:='File HTML (*.html)|*.html';
          if FUtama.SaveDialog.Execute then
          begin

          if (FUtama.LTLS.Caption='TRUE') then
             ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
             ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

          GridUserHotspot.RowCount := 1;

          // Ukuran Kolom
          GridUserHotspot.ColCount := 11;

          j := 1;

          Ras := ROS.Query(['/ip/hotspot/user/print'], True);

  	  if (Ras.RowsCount > 0) then
  	    begin
  	    for i := 1 to Ras.RowsCount do
  	       begin
  		   // Pecah Komentar Ras
  		   try
  		   Hasil1 := TStringList.Create;
  		   Hasil2 := TStringList.Create;
  		   Split('"', Ras.ValueByName['comment'], Hasil1);
  	       if (Hasil1.Count>1) then
  		   begin
  		   Split(':', Hasil1[0], Hasil2);
  		   ketres := Hasil2[0];
  		   end else
  		   begin
  		   ketres := Ras.ValueByName['comment'];
  		   end;
  		   except
  		   end;
  		   // Cek Apakah Komentar Sama
  	       if (Trim(ketres)=CGroup.Text) then
  		   begin
                   GridUserHotspot.RowCount := GridUserHotspot.RowCount+1;
                   try
                   Hasil1 := TStringList.Create;
                   Hasil2 := TStringList.Create;
                   Split('"', Ras.ValueByName['comment'], Hasil1);
                   if (Hasil1.Count>1) then
                   begin
                   harga      := Hasil1[1];
                   berlaku    := Hasil1[2];
                   Split(':', Hasil1[0], Hasil2);
                   keterangan := Hasil2[0];
                   end else
                   begin
                   harga      := '-';
                   berlaku    := '-';
                   keterangan := Ras.ValueByName['comment'];
                   end;
                   except
                   end;

                   GridUserHotspot.Cells[0,j] := '';
                   GridUserHotspot.Cells[1,j] := Ras.ValueByName['.id'];
                   GridUserHotspot.Cells[2,j] := Ras.ValueByName['name'];
                   GridUserHotspot.Cells[3,j] := Ras.ValueByName['profile'];
                   GridUserHotspot.Cells[4,j] := Ras.ValueByName['limit-uptime'];
                   GridUserHotspot.Cells[5,j] := Ras.ValueByName['password'];
                   GridUserHotspot.Cells[6,j] := harga;
                   GridUserHotspot.Cells[7,j] := berlaku;
                   GridUserHotspot.Cells[8,j] := Ras.ValueByName['uptime'];
                   GridUserHotspot.Cells[9,j] := keterangan;
                   GridUserHotspot.Cells[10,j] := Ras.ValueByName['disabled'];
                   j := j+1;
                   end;
                   Ras.Next;
               end;
              end;
          if (ExtractFileExt(FUtama.SaveDialog.FileName)='') then nama:=FUtama.SaveDialog.FileName+'.html' else nama:=FUtama.SaveDialog.FileName;
          if SaveAsHTMLFile(GridUserHotspot, nama, CGroup.Text, Gunakan(CekBahasa(),'GLOBAL','Coment')) then
             if MessageDlg(Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','ExportHTMLSuccess')+' ('+nama+'). '+Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','OpenDocConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
             begin
             OpenDocument(nama);
             end;
          end;
          end else // End Eksport HTML Komentar
          // Eksport User Hotspot Excel Berdasarkan Komentar
           if (LStatus.Caption='EksportXLS') then
           begin
           FUtama.SaveDialog.Filter:='File Excel (*.xls)|*.xls';
           if FUtama.SaveDialog.Execute then
           begin

           if (FUtama.LTLS.Caption='TRUE') then
              ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
              ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

                     GridUserHotspot.RowCount := 1;

                     // Ukuran Kolom
                           GridUserHotspot.ColCount := 14;
                     j := 1;

                     Ras := ROS.Query(['/ip/hotspot/user/print'], True);

             	  if (Ras.RowsCount > 0) then
             	    begin
             	    for i := 1 to Ras.RowsCount do
             	       begin
             		   // Pecah Komentar Ras
             		   try
             		   Hasil1 := TStringList.Create;
             		   Hasil2 := TStringList.Create;
             		   Split('"', Ras.ValueByName['comment'], Hasil1);
             	       if (Hasil1.Count>1) then
             		   begin
             		   Split(':', Hasil1[0], Hasil2);
             		   ketres := Hasil2[0];
             		   end else
             		   begin
             		   ketres := Ras.ValueByName['comment'];
             		   end;
             		   except
             		   end;
             		   // Cek Apakah Komentar Sama
             	       if (Trim(ketres)=CGroup.Text) then
             		   begin
                              GridUserHotspot.RowCount := GridUserHotspot.RowCount+1;
                              try
                              Hasil1 := TStringList.Create;
                              Hasil2 := TStringList.Create;
                              Split('"', Ras.ValueByName['comment'], Hasil1);
                              if (Hasil1.Count>1) then
                              begin
                              harga      := Hasil1[1];
                              berlaku    := Hasil1[2];
                              Split(':', Hasil1[0], Hasil2);
                              keterangan := Hasil2[0];
                              end else
                              begin
                              harga      := '-';
                              berlaku    := '-';
                              keterangan := Ras.ValueByName['comment'];
                              end;
                              except
                              end;

                              GridUserHotspot.Cells[0,j] := '';
                              GridUserHotspot.Cells[1,j] := Ras.ValueByName['.id'];
                              GridUserHotspot.Cells[2,j] := Ras.ValueByName['name'];
                              GridUserHotspot.Cells[3,j] := Ras.ValueByName['profile'];
                              GridUserHotspot.Cells[4,j] := Ras.ValueByName['limit-uptime'];
                              GridUserHotspot.Cells[5,j] := Ras.ValueByName['password'];
                              GridUserHotspot.Cells[6,j] := harga;
                              GridUserHotspot.Cells[7,j] := berlaku;
                              GridUserHotspot.Cells[8,j] := Ras.ValueByName['uptime'];
                              GridUserHotspot.Cells[9,j] := keterangan;
                              GridUserHotspot.Cells[10,j] := Ras.ValueByName['disabled'];
                              GridUserHotspot.Cells[11,j] := Ras.ValueByName['limit-bytes-out'];
                              GridUserHotspot.Cells[12,j] := Ras.ValueByName['limit-bytes-in'];
                              GridUserHotspot.Cells[13,j] := Ras.ValueByName['limit-bytes-total'];
                              j := j+1;
                              end;
                              Ras.Next;
                          end;
                         end;
           if (ExtractFileExt(FUtama.SaveDialog.FileName)='') then nama:=FUtama.SaveDialog.FileName+'.xls' else nama:=FUtama.SaveDialog.FileName;
           if SaveAsExcelFile(GridUserHotspot, nama) then
              if MessageDlg(Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','ExportExcelSuccess')+' ('+nama+'). '+Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','OpenDocConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
              begin
              OpenDocument(nama);
              end;
           end;
           end else // End Eksport Excel Komentar
           // Eksport User Hotspot Voucher Berdasarkan Komentar
           if (LStatus.Caption='Eksport') then
           begin
           FUtama.SaveDialog.Filter:='File PDF (*.pdf)|*.pdf';
           if FUtama.SaveDialog.Execute then
           begin
           if (FUtama.LTLS.Caption='TRUE') then
              ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
              ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

                     GridUserHotspot.RowCount := 1;

                     // Ukuran Kolom
                     GridUserHotspot.ColCount := 11;

                     j := 1;

                     Ras := ROS.Query(['/ip/hotspot/user/print'], True);

             	  if (Ras.RowsCount > 0) then
             	    begin
             	    for i := 1 to Ras.RowsCount do
             	       begin
             		   // Pecah Komentar Ras
             		   try
             		   Hasil1 := TStringList.Create;
             		   Hasil2 := TStringList.Create;
             		   Split('"', Ras.ValueByName['comment'], Hasil1);
             	       if (Hasil1.Count>1) then
             		   begin
             		   Split(':', Hasil1[0], Hasil2);
             		   ketres := Hasil2[0];
             		   end else
             		   begin
             		   ketres := Ras.ValueByName['comment'];
             		   end;
             		   except
             		   end;
             		   // Cek Apakah Komentar Sama
             	       if (Trim(ketres)=CGroup.Text) then
             		   begin

                              GridUserHotspot.RowCount := GridUserHotspot.RowCount+1;
                              try
                              Hasil1 := TStringList.Create;
                              Hasil2 := TStringList.Create;
                              Split('"', Ras.ValueByName['comment'], Hasil1);
                              if (Hasil1.Count>1) then
                              begin
                              harga      := Hasil1[1];
                              berlaku    := Hasil1[2];
                              Split(':', Hasil1[0], Hasil2);
                              keterangan := Hasil2[0];
                              end else
                              begin
                              harga      := '-';
                              berlaku    := '-';
                              keterangan := Ras.ValueByName['comment'];
                              end;
                              except
                              end;

                              GridUserHotspot.Cells[0,j] := '';
                              GridUserHotspot.Cells[1,j] := Ras.ValueByName['.id'];
                              GridUserHotspot.Cells[2,j] := Ras.ValueByName['name'];
                              GridUserHotspot.Cells[3,j] := Ras.ValueByName['profile'];
                              GridUserHotspot.Cells[4,j] := Ras.ValueByName['limit-uptime'];
                              GridUserHotspot.Cells[5,j] := Ras.ValueByName['password'];
                              GridUserHotspot.Cells[6,j] := harga;
                              GridUserHotspot.Cells[7,j] := berlaku;
                              GridUserHotspot.Cells[8,j] := Ras.ValueByName['uptime'];
                              GridUserHotspot.Cells[9,j] := keterangan;
                              GridUserHotspot.Cells[10,j] := Ras.ValueByName['disabled'];
                              j := j+1;
                              end;
                              Ras.Next;
                          end;
                         end;

              if (ExtractFileExt(FUtama.SaveDialog.FileName)='') then nama:=FUtama.SaveDialog.FileName+'.pdf' else nama:=FUtama.SaveDialog.FileName;
                  myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
                  with myinifile do
                  begin
                  if (ReadString('CONFIG','Template','0')=GSMEncode7Bit(GSMEncode7Bit('default'))) then
                  begin
                  if SaveVoucher(GridUserHotspot, CGroup.Text, nama, Gunakan(CekBahasa(),'GLOBAL','Coment'), user, pass, hargax, valid, limit) then
                     if MessageDlg(Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','ExportVoucherSuccess')+' ('+nama+'). '+Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','OpenDocConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
                     begin
                     OpenDocument(nama);
                     end;
                  end else
                  begin
                  // Cek Status Apakah Login QR Sudah diseting
                   if (ReadString('CONFIG','HotspotAddress','0')='') then begin
                   namagb := GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0')));
                   if SaveVoucherCustom(GridUserHotspot, CGroup.Text, nama, Gunakan(CekBahasa(),'GLOBAL','Coment'),namagb, user, pass, hargax, valid, kolom) then
                      if MessageDlg(Gunakan(CekBahasa(),'MAIN','ExportVoucherSuccess')+' ('+nama+'). '+Gunakan(CekBahasa(),'MAIN','OpenDocConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
                      begin
                      OpenDocument(nama);
                      end;
                   end else begin
                   FQRLogin.Show;
                   FQRLogin.GroupQRLogin.Caption:=Gunakan(CekBahasa(),'GLOBAL','QRCodeLoginGen');
                   FQRLogin.ProgressQRLogin.Max:=GridUserHotspot.RowCount-1;
                   // Buat QR Code dan Simpan ke Folder tmp
                   for q := 1 to GridUserHotspot.RowCount-1 do begin
                   FQRLogin.ProgressQRLogin.Position:=q;
                   FQRLogin.QRLogin.Text:='http://'+GSMDecode7Bit(GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','HotspotAddress','0'))))+'/login?username='+GridUserHotspot.Cells[2,q]+'&password='+GridUserHotspot.Cells[5,q];
                   FQRLogin.QRLogin.Repaint;
                   Bitmap := TBitmap.Create;
                   try
                     with Bitmap do
                     begin
                       Width := FQRLogin.QRLogin.Width;
                       Height := FQRLogin.QRLogin.Height;
                       Dest := Rect(0, 0, Width, Height);
                     end;
                     with FQRLogin.QRLogin do
                       Source := Rect(0, 0, Width, Height);
                       Bitmap.Canvas.CopyRect(Dest, FQRLogin.QRLogin.Canvas, Source);
                       Bitmap.SaveToFile('tmp/qrlogin1-'+IntToStr(q)+'.bmp');
                       Bitmap.SaveToFile('tmp/qrlogin2-'+IntToStr(q)+'.bmp');
                       Bitmap.SaveToFile('tmp/qrlogin3-'+IntToStr(q)+'.bmp');
                   finally
                     Bitmap.Free;
                   end;
                   CopyFile(ExtractFilePath(Application.ExeName)+'template/'+GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0'))),ExtractFilePath(Application.ExeName)+'tmp/back1-'+IntToStr(q)+GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0'))));
                   CopyFile(ExtractFilePath(Application.ExeName)+'template/'+GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0'))),ExtractFilePath(Application.ExeName)+'tmp/back2-'+IntToStr(q)+GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0'))));
                   CopyFile(ExtractFilePath(Application.ExeName)+'template/'+GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0'))),ExtractFilePath(Application.ExeName)+'tmp/back3-'+IntToStr(q)+GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0'))));
                   Sleep(10);
                   end;
                   FQRLogin.Hide;
                   // End Buat Gambar QR Code Login
                   namagb := GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0')));
                   if SaveVoucherCustomQR(GridUserHotspot, CGroup.Text, nama, namagb, Gunakan(CekBahasa(),'GLOBAL','Coment'), user, pass, hargax, valid, kolom) then
                     begin
                      if MessageDlg(Gunakan(CekBahasa(),'MAIN','ExportVoucherSuccess')+' ('+nama+'). '+Gunakan(CekBahasa(),'MAIN','OpenDocConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
                      begin
                      OpenDocument(nama);
                      end;
                   // Hapus QR Login
                   for q := 1 to GridUserHotspot.RowCount-1 do begin
                   DeleteFile('tmp/qrlogin1-'+IntToStr(q)+'.bmp');
                   DeleteFile('tmp/qrlogin2-'+IntToStr(q)+'.bmp');
                   DeleteFile('tmp/qrlogin3-'+IntToStr(q)+'.bmp');
                   DeleteFile('tmp/back1-'+IntToStr(q)+GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0'))));
                   DeleteFile('tmp/back2-'+IntToStr(q)+GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0'))));
                   DeleteFile('tmp/back3-'+IntToStr(q)+GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0'))));
                   end;
                     end;
                   end;
                  end;
                  Free;
                  end;
           end;
           end;

  end;

  end;

end;

procedure TFEksportHapusByGroup.CGroupKeyPress(Sender: TObject; var Key: char);
begin
  key:=#0;
end;

procedure TFEksportHapusByGroup.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin

end;

procedure TFEksportHapusByGroup.FormCreate(Sender: TObject);
begin

end;

procedure TFEksportHapusByGroup.FormShow(Sender: TObject);
var
  Res : TRosApiResult;
  i, pos, last: integer;
  newNumber: boolean;
  ROS       : TRosApiClient;
  rArray : array of String;
  ketres : String;
  Hasil1, Hasil2 : TStringList;
  begin
   ROS := TRosApiClient.Create;
   if (LBerdasarkan.Caption='BL') then
   begin
    if (FUtama.LTLS.Caption='TRUE') then
       ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
       ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);
    Res := ROS.Query(['/ip/hotspot/user/profile/print'], True);
    if ROS.LastError <> '' then
    MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);
    CGroup.Items.Clear;

  while not Res.Eof do
  begin
    for i := 1 to Res.RowsCount do
    begin
      CGroup.Items.Add(Res.ValueByName['name']);
      Res.Next;
    end;
  end;
  end else
  if (LBerdasarkan.Caption='CM') then
  begin
   if (FUtama.LTLS.Caption='TRUE') then
      ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
      ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

   Res := ROS.Query(['/ip/hotspot/user/print'], True);

   if ROS.LastError <> '' then
   MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);
   CGroup.Items.Clear;

   if (Res.RowsCount>0) then
   begin

      SetLength(iArray,Res.RowsCount);
      SetLength(rArray,Res.RowsCount);

     for i := 0 to Res.RowsCount-1 do
     begin
     try

        Hasil1 := TStringList.Create;
        Hasil2 := TStringList.Create;

        Split('"', Res.ValueByName['comment'], Hasil1);
        if (Hasil1.Count>1) then
        begin
        Split(':', Hasil1[0], Hasil2);
        ketres := Hasil2[0];
        end else
        ketres := Res.ValueByName['comment'];
     except end;
       iArray[i] := Trim(ketres);
       Res.Next;
       end;
  // Remove Duplicate Comment dari iArray
  i          := 0;
  rArray[0]  := iArray[0];
  last       := 0;
  pos        := 0;

  while pos < high(iArray) do
  begin
    inc(pos);
    newNumber := true;
    for i := low(rArray) to last do
      if iArray[pos] = rArray[i] then
      begin
        newNumber := false;
	break;
      end;
    if newNumber then
    begin
      inc(last);
      rArray[last] := iArray[pos];
    end;
  end;
  i:=1;
  for i := low(rArray) to last do
  begin
  if not (rArray[i]='') then
    CGroup.Items.Add(rArray[i]);
  end;
 end;
      end;
    Res.Free;
    ROS.Free;
   end;

end.

