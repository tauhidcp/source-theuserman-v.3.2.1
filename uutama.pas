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

unit uutama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SpkToolbar, SpkGUITools, SpkMath, SpkGraphTools,
  spkt_Tab, spkt_Pane, spkt_Types, spkt_Tools, spkt_BaseItem, spkt_Buttons,
  spkt_Checkboxes, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls,
  ExtCtrls, StdCtrls, UDataLimitBW, UTambahLimitBW, UDataUserHotspot,
  UDataUserHotspotAktif, UEksportHapusByGroup, RouterOSAPI, Grids, LCLIntf,
  ubarcodes, libjpfpdf, UUbahPassword, ssl_openssl,
  UTemplateVoucher, IniFiles, bahasa, uqrcodelogin, Types, uquota,
  encode_decode,ulog, uselectitem, uselectcolumn, uhtmltemplate, uvalidityinstall;

type

  { TFUtama }

  TFUtama = class(TForm)
    BackGround: TImage;
    ListImage: TImageList;
    LTLS: TLabel;
    LIP: TLabel;
    LUser: TLabel;
    LPass: TLabel;
    ExportPDFAllUser: TMenuItem;
    ExportPDFByGroup: TMenuItem;
    ExportExcelAllUser: TMenuItem;
    ExportExcelByGroup: TMenuItem;
    EUAndP: TMenuItem;
    MenuCustomVoucherColumn: TMenuItem;
    EksportHTML: TMenuItem;
    HTMLTemplate: TMenuItem;
    AllHotspotUserHTML: TMenuItem;
    ByGroupHTML: TMenuItem;
    CommentHTML: TMenuItem;
    BWLimitHTML: TMenuItem;
    MESItem: TMenuItem;
    MenuByComment: TMenuItem;
    MenuByBandwidthLimit: TMenuItem;
    MenuCComment: TMenuItem;
    MenuCBandwidth: TMenuItem;
    EUAndPAll: TMenuItem;
    EUandPByGroup: TMenuItem;
    EUandPComment: TMenuItem;
    EUandPBandwidth: TMenuItem;
    MenuQuotaComment: TMenuItem;
    MenuQuotaBandwidthLimit: TMenuItem;
    MenuQuotaAllUser: TMenuItem;
    MenuQuotaByGroup: TMenuItem;
    MenuEComment: TMenuItem;
    MenuEBandwith: TMenuItem;
    MenuPComment: TMenuItem;
    MenuPGroup: TMenuItem;
    MenuTimeLimit: TMenuItem;
    MenuValidity: TMenuItem;
    Office2007Blue: TMenuItem;
    MetroLight: TMenuItem;
    MetroDark: TMenuItem;
    PanelTengah: TPanel;
    PopupExPDF: TPopupMenu;
    PopupExExcel: TPopupMenu;
    PopupExVoucher: TPopupMenu;
    PopupLang: TPopupMenu;
    PopupDelete: TPopupMenu;
    PopupExpired: TPopupMenu;
    PopupClear: TPopupMenu;
    PopupHTML: TPopupMenu;
    PopupQuota: TPopupMenu;
    PopupTheme: TPopupMenu;
    ProgressBar: TProgressBar;
    SaveDialog: TSaveDialog;
    ChPassw: TSpkLargeButton;
    ActiveUserList: TSpkLargeButton;
    Language: TSpkLargeButton;
    HotspotUserTool: TSpkPane;
    MenuValiditySetting: TSpkLargeButton;
    MenuQRCodeLogin: TSpkLargeButton;
    MnQuotaLimit: TSpkLargeButton;
    QuotaLimit: TSpkPane;
    PaneLog: TSpkPane;
    BtnLog: TSpkLargeButton;
    HTMLEkspot: TSpkLargeButton;
    Theme: TSpkLargeButton;
    MnExportPDF: TSpkLargeButton;
    MnExportExcel: TSpkLargeButton;
    MnExportVoucher: TSpkLargeButton;
    CCAllUser: TSpkLargeButton;
    CCExpireUser: TSpkLargeButton;
    CCUserByGroup: TSpkLargeButton;
    DelAllUser: TSpkLargeButton;
    DellExpUser: TSpkLargeButton;
    DellUserByGroup: TSpkLargeButton;
    Donate: TSpkLargeButton;
    ApplInfo: TSpkLargeButton;
    Voucher: TSpkLargeButton;
    HotspotUserList: TSpkLargeButton;
    Reboot: TSpkLargeButton;
    ListBandwidthLimitation: TSpkLargeButton;
    HotspotUser: TSpkPane;
    Tool: TSpkPane;
    AppInfo: TSpkPane;
    ExportUser: TSpkPane;
    ClearCounter: TSpkPane;
    DeleteUser: TSpkPane;
    BandwidthLimitation: TSpkPane;
    MenuBandwidthLimitation: TSpkTab;
    MenuTool: TSpkTab;
    MenuInformasi: TSpkTab;
    MenuRibbonSPK: TSpkToolbar;
    HotspotUserM: TSpkTab;
    StatusBar: TStatusBar;
    procedure ActiveUserListClick(Sender: TObject);
    procedure AllHotspotUserHTMLClick(Sender: TObject);
    procedure ApplInfoClick(Sender: TObject);
    procedure BtnLogClick(Sender: TObject);
    procedure BWLimitHTMLClick(Sender: TObject);
    procedure CCAllUserClick(Sender: TObject);
    procedure CCExpireUserClick(Sender: TObject);
  //  procedure CCUserByGroupClick(Sender: TObject);
    procedure ChPasswClick(Sender: TObject);
    procedure CommentHTMLClick(Sender: TObject);
    procedure DelAllUserClick(Sender: TObject);
   // procedure DellExpUserClick(Sender: TObject);
   // procedure DellUserByGroupClick(Sender: TObject);
    procedure DonateClick(Sender: TObject);
    procedure EUAndPAllClick(Sender: TObject);
    procedure EUandPBandwidthClick(Sender: TObject);
    procedure EUandPCommentClick(Sender: TObject);
    procedure HTMLTemplateClick(Sender: TObject);
    procedure MenuCustomVoucherColumnClick(Sender: TObject);
    //procedure MenuPopValidClick(Sender: TObject);
    procedure MenuValiditySettingClick(Sender: TObject);
    procedure MESClick(Sender: TObject);
    procedure ExportExcelAllUserClick(Sender: TObject);
  //  procedure ExportExcelByGroupClick(Sender: TObject);
    procedure ExportPDFAllUserClick(Sender: TObject);
  //  procedure ExportPDFByGroupClick(Sender: TObject);
  //  procedure EUAndPClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HotspotUserListClick(Sender: TObject);
    procedure ListBandwidthLimitationClick(Sender: TObject);
    procedure MenuByBandwidthLimitClick(Sender: TObject);
    procedure MenuByCommentClick(Sender: TObject);
    procedure MenuCBandwidthClick(Sender: TObject);
    procedure MenuCCommentClick(Sender: TObject);
    procedure MenuEBandwithClick(Sender: TObject);
    procedure MenuECommentClick(Sender: TObject);
    procedure MenuPCommentClick(Sender: TObject);
    procedure MenuPGroupClick(Sender: TObject);
    procedure MenuQRCodeLoginClick(Sender: TObject);
    procedure MenuQuotaAllUserClick(Sender: TObject);
    procedure MenuQuotaBandwidthLimitClick(Sender: TObject);
    procedure MenuQuotaCommentClick(Sender: TObject);
    procedure MenuTimeLimitClick(Sender: TObject);
    procedure MenuValidityClick(Sender: TObject);
    procedure Office2007BlueClick(Sender: TObject);
    procedure MetroLightClick(Sender: TObject);
    procedure MetroDarkClick(Sender: TObject);
    procedure RebootClick(Sender: TObject);
    procedure SpkLargeButton13Click(Sender: TObject);
    procedure VoucherClick(Sender: TObject);
    procedure StyleChangeHandler(Sender: TObject);
    procedure PopupLangHandler(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FUtama: TFUtama;
  myinifile, fileiniku   : TIniFile;

implementation
uses
  spkt_Appearance, uqrlogin;

{$R *.lfm}

{ TFUtama }

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

function SaveAsHTMLFile(AGrid: TStringGrid; AFileName: string): Boolean;
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
     after1  := stringreplace(GSMDecode7Bit(ReadString('HTMLTEMPLATE','Row','0')), '%username%', AGrid.Cells[3,i],[rfReplaceAll, rfIgnoreCase]);
     after2  := stringreplace(after1, '%password%', AGrid.Cells[6,i],[rfReplaceAll, rfIgnoreCase]);
     after3  := stringreplace(after2, '%timelimit%', AGrid.Cells[5,i],[rfReplaceAll, rfIgnoreCase]);
     after4  := stringreplace(after3, '%validity%', AGrid.Cells[8,i],[rfReplaceAll, rfIgnoreCase]);
     after5  := stringreplace(after4, '%price%', AGrid.Cells[7,i],[rfReplaceAll, rfIgnoreCase]);
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

function SaveAsPDFFile(AGrid: TStringGrid; AFileName: string): Boolean;
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
    Cell(0, 10, Gunakan(CekBahasa(),'MAIN','ExportPDFTitle'),'1',0,'C',0);
    Ln(15);
    SetFont(ffHelvetica,fsNormal,12);
    Cell(10,7,Gunakan(CekBahasa(),'MAIN','Number'),'1',0,'C',0);
    Cell(40,7,Gunakan(CekBahasa(),'MAIN','UserLogin'),'1',0,'C',0);
    Cell(50,7,Gunakan(CekBahasa(),'MAIN','BandwidthLimitation'),'1',0,'C',0);
    Cell(50,7,Gunakan(CekBahasa(),'MAIN','TimeLimit'),'1',0,'C',0);
    Cell(40,7,Gunakan(CekBahasa(),'MAIN','Password'),'1',0,'C',0);
    for i := 1 to AGrid.RowCount-1 do begin
    Ln(7);
    Cell(10,7,IntToStr(i),'1',0,'C',0);
    Cell(40,7,AGrid.Cells[3,i],'1',0,'C',0);
    Cell(50,7,AGrid.Cells[4,i],'1',0,'C',0);
    Cell(50,7,AGrid.Cells[5,i],'1',0,'C',0);
    Cell(40,7,AGrid.Cells[6,i],'1',0,'C',0);
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
function SaveVoucherCustomQR(AGrid: TStringGrid; AFileName: string; namagb, user, pass, harga, valid, kolom:string): Boolean;
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
    Cell(0, 10, Gunakan(CekBahasa(),'MAIN','VoucherTittle'),'1',0,'C',0);
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

      if (user='Yes') then Text(x1,y1,AGrid.Cells[3,k]);
      if (pass='Yes') then Text(x2,y1,AGrid.Cells[6,k]);
      if (valid='Yes') then Text(x1,y2,AGrid.Cells[8,k]); // tambahan
      if (harga='Yes') then Text(x3,y3,AGrid.Cells[7,k]); // tambahan

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

      if (user='Yes') then Text(x1,y1,AGrid.Cells[3,l]);
      if (pass='Yes') then Text(x2,y1,AGrid.Cells[6,l]);
      if (valid='Yes') then Text(x1,y2,AGrid.Cells[8,l]); // tambahan
      if (harga='Yes') then Text(x3,y3,AGrid.Cells[7,l]); // tambahan

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

      if (user='Yes') then Text(x1,y1,AGrid.Cells[3,k]);
      if (pass='Yes') then Text(x2,y1,AGrid.Cells[6,k]);
      if (valid='Yes') then Text(x1,y2,AGrid.Cells[8,k]); // tambahan
      if (harga='Yes') then Text(x3,y3,AGrid.Cells[7,k]); // tambahan

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
      if (user='Yes') then Text(x1,y1,AGrid.Cells[3,l]);
      if (pass='Yes') then Text(x2,y1,AGrid.Cells[6,l]);
      if (valid='Yes') then Text(x1,y2,AGrid.Cells[8,l]); // tambahan
      if (harga='Yes') then Text(x3,y3,AGrid.Cells[7,l]); // tambahan
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
function SaveVoucherCustom(AGrid: TStringGrid; AFileName: string; namagb, user, pass, harga, valid, kolom:string): Boolean;
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
    Cell(0, 10, Gunakan(CekBahasa(),'MAIN','VoucherTittle'),'1',0,'C',0);
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
      Image(ExtractFilePath(Application.ExeName)+'template/'+namagb,xx,yy,86,53);
      // Samping, Atas
      SetFont(ffHelvetica,fsBold,12);

      if (user='Yes') then Text(x1,y1,AGrid.Cells[3,k]);
      if (pass='Yes') then Text(x2,y1,AGrid.Cells[6,k]);
      if (valid='Yes') then Text(x1,y2,AGrid.Cells[8,k]); // tambahan
      if (harga='Yes') then Text(x3,y3,AGrid.Cells[7,k]); // tambahan

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
         Image(ExtractFilePath(Application.ExeName)+'template/'+namagb,xx,yy,86,53);
         // Samping, Atas
      if (user='Yes') then Text(x1,y1,AGrid.Cells[3,l]);
      if (pass='Yes') then Text(x2,y1,AGrid.Cells[6,l]);
      if (valid='Yes') then Text(x1,y2,AGrid.Cells[8,l]); // tambahan
      if (harga='Yes') then Text(x3,y3,AGrid.Cells[7,l]); // tambahan
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

      Image(ExtractFilePath(Application.ExeName)+'template/'+namagb,xx,yy,62,34);
      // Samping, Atas
      SetFont(ffHelvetica,fsBold,9);

      if (user='Yes') then Text(x1,y1,AGrid.Cells[3,k]);
      if (pass='Yes') then Text(x2,y1,AGrid.Cells[6,k]);
      if (valid='Yes') then Text(x1,y2,AGrid.Cells[8,k]); // tambahan
      if (harga='Yes') then Text(x3,y3,AGrid.Cells[7,k]); // tambahan

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
        Image(ExtractFilePath(Application.ExeName)+'template/'+namagb,xx,yy,62,34);
         // Samping, Atas
      if (user='Yes') then Text(x1,y1,AGrid.Cells[3,l]);
      if (pass='Yes') then Text(x2,y1,AGrid.Cells[6,l]);
      if (valid='Yes') then Text(x1,y2,AGrid.Cells[8,l]); // tambahan
      if (harga='Yes') then Text(x3,y3,AGrid.Cells[7,l]); // tambahan
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
function SaveVoucher(AGrid: TStringGrid; AFileName, user, pass, harga, valid, limit: string): Boolean;
var
JPFpdf1 : TJPFpdf;
i,j, x, xx, yy,k, ba, l, jmlx, hasil : integer;
bagi : double;
OutPutList, hasilxx  : TStringList;
userx, passx, hargax, limitx, validx : string;
begin
  Result := False;
  try
  JPFpdf1 := TJPFpdf.Create;
  with JPFpdf1 do begin
    AddPage;
    SetFont(ffTimes,fsBold,14);
    SetLineWidth(0.3);
    Cell(0, 10, Gunakan(CekBahasa(),'MAIN','VoucherTittle'),'1',0,'C',0);
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
      // Cek Item
      if (user='Yes') then userx := Gunakan(CekBahasa(),'MAIN','UserLogin')+' : '+AGrid.Cells[3,k] else userx :='';
      if (pass='Yes') then passx := sLineBreak+Gunakan(CekBahasa(),'MAIN','Password')+' : '+AGrid.Cells[6,k] else passx :='';
      if (harga='Yes') then hargax := sLineBreak+Gunakan(CekBahasa(),'MAIN','Price')+' : '+AGrid.Cells[7,k] else hargax :='';
      if (valid='Yes') then validx := sLineBreak+Gunakan(CekBahasa(),'MAIN','Validity')+' : '+AGrid.Cells[8,k] else validx :='';
      if (limit='Yes') then limitx := sLineBreak+Gunakan(CekBahasa(),'MAIN','TimeLimit')+' : '+AGrid.Cells[5,k] else limitx :='';

      MultiCell(45,4, userx + passx + limitx + hargax + validx,'1','L',0);

      // End Cek
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

         // Cek Item
         if (user='Yes') then userx := Gunakan(CekBahasa(),'MAIN','UserLogin')+' : '+AGrid.Cells[3,l] else userx :='';
         if (pass='Yes') then passx := sLineBreak+Gunakan(CekBahasa(),'MAIN','Password')+' : '+AGrid.Cells[6,l] else passx :='';
         if (harga='Yes') then hargax := sLineBreak+Gunakan(CekBahasa(),'MAIN','Price')+' : '+AGrid.Cells[7,l] else hargax :='';
         if (valid='Yes') then validx := sLineBreak+Gunakan(CekBahasa(),'MAIN','Validity')+' : '+AGrid.Cells[8,l] else validx :='';
         if (limit='Yes') then limitx := sLineBreak+Gunakan(CekBahasa(),'MAIN','TimeLimit')+' : '+AGrid.Cells[5,l] else limitx :='';

         MultiCell(45,4, userx + passx + limitx + hargax + validx,'1','L',0);

         // End Cek

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

procedure TFUtama.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
Application.Terminate;
end;

procedure TFUtama.FormCreate(Sender: TObject);
var
  Directory, Mask: String;
  sr: TSearchRec;
  Item: TMenuItem;
  OutPutList : TStringList;
begin
  // Tambahkan Bahasa
  Directory := GetCurrentDir+'/language/';
  Mask := '*.ini';
  if FindFirst(Directory+Mask,faAnyFile,sr)=0 then
    repeat
      Item := TMenuItem.Create(nil);
      // Split Bahasa
      OutPutList := TStringList.Create;
      Split('.', sr.Name, OutPutList);
      Item.Caption := OutPutList[0];
      Item.OnClick := @PopupLangHandler;
      PopupLang.Items.Add(Item);
      // Cek Bahasa yang dipilih
      if (FileExists(ExtractFilePath(Application.exename)+'config.ini')) then
      begin
      myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
      with myinifile do begin
      if (GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Language','0')))=OutPutList[0]) then Item.Checked:=True;
      Free;
      end;
      end;
    until FindNext(sr)<>0;
  FindClose(sr);
  // Setup Bahasa
  FUtama.Caption:=Gunakan(CekBahasa(),'MAIN','FormTitle')+' (theuserman v3.2.1) - stable';
  FUtama.HotspotUserM.Caption:=Gunakan(CekBahasa(),'MAIN','THotspotUser');
  FUtama.HotspotUser.Caption:=Gunakan(CekBahasa(),'MAIN','MnHotspotUser');
  FUtama.HotspotUserList.Caption:=Gunakan(CekBahasa(),'MAIN','MnHotspotUserList');
  FUtama.ActiveUserList.Caption:=Gunakan(CekBahasa(),'MAIN','MnActiveUserList');
  FUtama.ExportUser.Caption:=Gunakan(CekBahasa(),'MAIN','MnExportUser');
  FUtama.MnExportPDF.Caption:=Gunakan(CekBahasa(),'MAIN','MnExportPDF');
  FUtama.ExportPDFAllUser.Caption:=Gunakan(CekBahasa(),'MAIN','MnSubExportPDFAll');
  FUtama.ExportPDFByGroup.Caption:=Gunakan(CekBahasa(),'MAIN','MnSubExportPDFByGroup');
  FUtama.MnExportExcel.Caption:=Gunakan(CekBahasa(),'MAIN','MnExportExcel');
  FUtama.ExportExcelAllUser.Caption:=Gunakan(CekBahasa(),'MAIN','MnSubExportExcelAll');
  FUtama.ExportExcelByGroup.Caption:=Gunakan(CekBahasa(),'MAIN','MnSubExportExcelByGroup');
  FUtama.MnExportVoucher.Caption:=Gunakan(CekBahasa(),'MAIN','MnExportVoucher');
  FUtama.ClearCounter.Caption:=Gunakan(CekBahasa(),'MAIN','MnClearCounter');
  FUtama.CCAllUser.Caption:=Gunakan(CekBahasa(),'MAIN','MnClearAll');
  FUtama.CCExpireUser.Caption:=Gunakan(CekBahasa(),'MAIN','MnClearExpired');
  FUtama.CCUserByGroup.Caption:=Gunakan(CekBahasa(),'MAIN','MnClearByGroup');
  FUtama.DeleteUser.Caption:=Gunakan(CekBahasa(),'MAIN','MnDeleteUser');
  FUtama.DelAllUser.Caption:=Gunakan(CekBahasa(),'MAIN','MnDeleteAll');
  FUtama.DellExpUser.Caption:=Gunakan(CekBahasa(),'MAIN','MnDeleteExpired');
  FUtama.DellUserByGroup.Caption:=Gunakan(CekBahasa(),'MAIN','MnDeleteByGroup');
  FUtama.MenuBandwidthLimitation.Caption:=Gunakan(CekBahasa(),'MAIN','TBandwidth');
  FUtama.BandwidthLimitation.Caption:=Gunakan(CekBahasa(),'MAIN','MnBandwidth');
  FUtama.ListBandwidthLimitation.Caption:=Gunakan(CekBahasa(),'MAIN','MnBandwidthList');
  FUtama.MenuTool.Caption:=Gunakan(CekBahasa(),'MAIN','TTool');
  FUtama.Tool.Caption:=Gunakan(CekBahasa(),'MAIN','MnTool');
  FUtama.ChPassw.Caption:=Gunakan(CekBahasa(),'MAIN','MnChPass');
  FUtama.Language.Caption:=Gunakan(CekBahasa(),'MAIN','MnLanguage');
  FUtama.Voucher.Caption:=Gunakan(CekBahasa(),'MAIN','MnVoucher');
  FUtama.Theme.Caption:=Gunakan(CekBahasa(),'MAIN','MnTheme');
  FUtama.Reboot.Caption:=Gunakan(CekBahasa(),'MAIN','MnReboot');
  FUtama.MenuInformasi.Caption:=Gunakan(CekBahasa(),'MAIN','TInfo');
  FUtama.AppInfo.Caption:=Gunakan(CekBahasa(),'MAIN','MnInfo');
  FUtama.ApplInfo.Caption:=Gunakan(CekBahasa(),'MAIN','MnAppInfo');
  FUtama.Donate.Caption:=Gunakan(CekBahasa(),'MAIN','MnDonate');
  FUtama.MenuTimeLimit.Caption:=Gunakan(CekBahasa(),'MAIN','MnTimeLimit');
  FUtama.MenuValidity.Caption:=Gunakan(CekBahasa(),'MAIN','MnValidity');
  FUtama.MenuByComment.Caption:=Gunakan(CekBahasa(),'MAIN','MnComment');
  FUtama.MenuByBandwidthLimit.Caption:=Gunakan(CekBahasa(),'MAIN','MnBWLimit');
  FUtama.MenuEComment.Caption:=Gunakan(CekBahasa(),'MAIN','MnComment');
  FUtama.MenuEBandwith.Caption:=Gunakan(CekBahasa(),'MAIN','MnBWLimit');
  FUtama.MenuCComment.Caption:=Gunakan(CekBahasa(),'MAIN','MnComment');
  FUtama.MenuCBandwidth.Caption:=Gunakan(CekBahasa(),'MAIN','MnBWLimit');
  FUtama.MenuPComment.Caption:=Gunakan(CekBahasa(),'MAIN','MnComment');
  FUtama.MenuPGroup.Caption:=Gunakan(CekBahasa(),'MAIN','MnBWLimit');
  FUtama.MenuValiditySetting.Caption:=Gunakan(CekBahasa(),'MAIN','ValidSetting');
  FUtama.MenuQRCodeLogin.Caption:=Gunakan(CekBahasa(),'MAIN','QRCodeLogin');
  FUtama.QuotaLimit.Caption:=Gunakan(CekBahasa(),'GLOBAL','Quota');
  FUtama.MnQuotaLimit.Caption:=Gunakan(CekBahasa(),'GLOBAL','QuotaLimit');
  FUtama.MenuQuotaAllUser.Caption:=Gunakan(CekBahasa(),'MAIN','MnQuotaAll');
  FUtama.MenuQuotaByGroup.Caption:=Gunakan(CekBahasa(),'MAIN','MnQuotaGroup');
  FUtama.MenuQuotaComment.Caption:=Gunakan(CekBahasa(),'MAIN','MnQuotaComent');
  FUtama.MenuQuotaBandwidthLimit.Caption:=Gunakan(CekBahasa(),'MAIN','MnQuotaBW');
  FUtama.PaneLog.Caption:=Gunakan(CekBahasa(),'MAIN','PLog');
  FUtama.BtnLog.Caption:=Gunakan(CekBahasa(),'MAIN','MLog');

  FUtama.EUAndPAll.Caption:=Gunakan(CekBahasa(),'MAIN','MnSubExportVoucherAll');
  FUtama.EUandPByGroup.Caption:=Gunakan(CekBahasa(),'MAIN','MnSubExportVoucherByGroup');
  FUtama.EUandPComment.Caption:=Gunakan(CekBahasa(),'MAIN','MnComment');
  FUtama.EUandPBandwidth.Caption:=Gunakan(CekBahasa(),'MAIN','MnBWLimit');
  
  FUtama.EUAndP.Caption:=Gunakan(CekBahasa(),'MAIN','MEUAndP');
  FUtama.MESItem.Caption:=Gunakan(CekBahasa(),'MAIN','MESItem');

  FUtama.MenuCustomVoucherColumn.Caption:=Gunakan(CekBahasa(),'MAIN','MnSelectColumn');

  FUtama.HTMLEkspot.Caption:=Gunakan(CekBahasa(),'MAIN','HTMLEx');
  FUtama.EksportHTML.Caption:=Gunakan(CekBahasa(),'MAIN','ExHTML');
  FUtama.HTMLTemplate.Caption:=Gunakan(CekBahasa(),'MAIN','ExHTMLTemplate');
  FUtama.AllHotspotUserHTML.Caption:=Gunakan(CekBahasa(),'MAIN','AllHTMLEx');
  FUtama.ByGroupHTML.Caption:=Gunakan(CekBahasa(),'MAIN','ByHTMLEx');
  FUtama.CommentHTML.Caption:=Gunakan(CekBahasa(),'MAIN','ComHTMLEx');
  FUtama.BWLimitHTML.Caption:=Gunakan(CekBahasa(),'MAIN','BWHTMLEx');
end;

procedure TFUtama.FormResize(Sender: TObject);
begin
  PanelTengah.Align:=alClient;
  // Lebar Status Bar
  StatusBar.Panels.Items[0].Width:=FUtama.Width div 3;
  StatusBar.Panels.Items[1].Width:=FUtama.Width div 3;
  StatusBar.Panels.Items[2].Width:=FUtama.Width div 3;
//  Lebar Kolom Tabel User Aktif
  FDataUserHotspotAktif.GridUserHotspotAktif.ColWidths[0]:=10;
  FDataUserHotspotAktif.GridUserHotspotAktif.ColWidths[1]:=FUtama.Width div 7;
  FDataUserHotspotAktif.GridUserHotspotAktif.ColWidths[2]:=FUtama.Width div 7;
  FDataUserHotspotAktif.GridUserHotspotAktif.ColWidths[3]:=FUtama.Width div 7;
  FDataUserHotspotAktif.GridUserHotspotAktif.ColWidths[4]:=FUtama.Width div 7;
  FDataUserHotspotAktif.GridUserHotspotAktif.ColWidths[5]:=FUtama.Width div 7;
  FDataUserHotspotAktif.GridUserHotspotAktif.ColWidths[6]:=FUtama.Width div 7;
  FDataUserHotspotAktif.GridUserHotspotAktif.ColWidths[7]:=FUtama.Width div 7;
  FDataUserHotspotAktif.BClose.Left:=FUtama.Width-83;
  // Lebar Kolom Tabel User Hotspot
  FDataUserHotspot.GridUserHotspot.ColCount := 17;
  FDataUserHotspot.GridUserHotspot.ColWidths[0]:=10;
  FDataUserHotspot.GridUserHotspot.ColWidths[1]:=27;
  FDataUserHotspot.GridUserHotspot.ColWidths[2]:=30;
  FDataUserHotspot.GridUserHotspot.ColWidths[3]:=FUtama.Width div 14;
  FDataUserHotspot.GridUserHotspot.ColWidths[4]:=FUtama.Width div 14;
  FDataUserHotspot.GridUserHotspot.ColWidths[5]:=FUtama.Width div 14;
  FDataUserHotspot.GridUserHotspot.ColWidths[6]:=FUtama.Width div 14;
  FDataUserHotspot.GridUserHotspot.ColWidths[7]:=FUtama.Width div 14;
  FDataUserHotspot.GridUserHotspot.ColWidths[8]:=FUtama.Width div 14;
  FDataUserHotspot.GridUserHotspot.ColWidths[9]:=FUtama.Width div 14;
  FDataUserHotspot.GridUserHotspot.ColWidths[10]:=FUtama.Width div 14;
  FDataUserHotspot.GridUserHotspot.ColWidths[11]:=FUtama.Width div 14;
  FDataUserHotspot.GridUserHotspot.ColWidths[12]:=FUtama.Width div 14;
  FDataUserHotspot.GridUserHotspot.ColWidths[13]:=FUtama.Width div 14;
  FDataUserHotspot.GridUserHotspot.ColWidths[14]:=FUtama.Width div 14;
  FDataUserHotspot.GridUserHotspot.ColWidths[15]:=FUtama.Width div 14;
  FDataUserHotspot.GridUserHotspot.ColWidths[16]:=FUtama.Width div 14;
  FDataUserHotspot.BClose.Left:=FUtama.Width-83;
  // Lebar Kolom Limit BW
  FDataLimitBW.GridGroupLimitBW.ColWidths[0]:=10;
  FDataLimitBW.GridGroupLimitBW.ColWidths[1]:=FUtama.Width div 4;
  FDataLimitBW.GridGroupLimitBW.ColWidths[2]:=FUtama.Width div 4;
  FDataLimitBW.GridGroupLimitBW.ColWidths[3]:=FUtama.Width div 4;
  FDataLimitBW.GridGroupLimitBW.ColWidths[4]:=FUtama.Width div 4;
  FDataLimitBW.BClose.Left:=FUtama.Width-83;
  // Lebar Panel dan Form Data
  FDataUserHotspot.ParentWindow:=PanelTengah.Handle;
  FDataUserHotspot.WindowState:=wsMaximized;
  FDataUserHotspotAktif.ParentWindow:=PanelTengah.Handle;
  FDataUserHotspotAktif.WindowState:=wsMaximized;
  FDataLimitBW.ParentWindow:=PanelTengah.Handle;
  FDataLimitBW.WindowState:=wsMaximized;
  FLog.ParentWindow:=PanelTengah.Handle;
  FLog.WindowState:=wsMaximized;

  FDataUserHotspotAktif.Width:=FUtama.Width;
  FDataUserHotspotAktif.Height:=PanelTengah.Height;
  FDataUserHotspot.Width:=FUtama.Width;
  FDataUserHotspot.Height:=PanelTengah.Height;
  FDataLimitBW.Width:=FUtama.Width;
  FDataLimitBW.Height:=PanelTengah.Height;
  FLog.Width:=FUtama.Width;
  FLog.Height:=PanelTengah.Height;

  FLog.BClose.Left:=FUtama.Width-83;

  FUtama.PanelTengah.Repaint;
end;

//Handle Popup Menu Lang
procedure TFUtama.PopupLangHandler(Sender: TObject);
begin
  if (FileExists(ExtractFilePath(Application.exename)+'config.ini')) then
     begin
        myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
        with myinifile do begin
        WriteString('CONFIG','Language',GSMEncode7Bit(GSMEncode7Bit(TMenuItem(Sender).Caption)));
        Free;
        end;
        if (MessageDlg(Gunakan(CekBahasa(),'MAIN','LangSettingSuccess_1')+sLineBreak+Gunakan(CekBahasa(),'MAIN','LangSettingSuccess_2')
        +sLineBreak+Gunakan(CekBahasa(),'MAIN','LangSettingSuccess_3'),mtConfirmation,[mbyes,mbno],0))=mrYes then Application.Terminate;
     end;
end;

procedure TFUtama.ActiveUserListClick(Sender: TObject);
begin
  BackGround.Visible:=False;
  PanelTengah.Align:=alClient;
  FDataUserHotspotAktif.ParentWindow:=FUtama.PanelTengah.Handle;
  FDataUserHotspotAktif.WindowState:=wsMaximized;
  FDataUserHotspot.Close;
  FDataLimitBW.Close;
  FLog.Close;

  FDataUserHotspotAktif.Show;
end;

procedure TFUtama.AllHotspotUserHTMLClick(Sender: TObject);
var
nama : String;
begin
  SaveDialog.Filter:='File HTML (*.html)|*.html';
  if SaveDialog.Execute then
  begin
  FDataUserHotspot.FormShow(Sender);
  if (ExtractFileExt(SaveDialog.FileName)='') then nama:=SaveDialog.FileName+'.html' else nama:=SaveDialog.FileName;
  if SaveAsHTMLFile(FDataUserHotspot.GridUserHotspot, nama) then
     if MessageDlg(Gunakan(CekBahasa(),'MAIN','ExportHTMLSuccess')+' ('+nama+'). '+Gunakan(CekBahasa(),'MAIN','OpenDocConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
     begin
     OpenDocument(nama);
     end;
  end;
end;

procedure TFUtama.ApplInfoClick(Sender: TObject);
begin
  ShowMessage(Gunakan(CekBahasa(),'MAIN','AppInfo_1')+sLineBreak+sLineBreak+
              Gunakan(CekBahasa(),'MAIN','AppInfo_2')+sLineBreak+sLineBreak+
              Gunakan(CekBahasa(),'MAIN','AppInfo_3')+sLineBreak+sLineBreak+
              Gunakan(CekBahasa(),'MAIN','AppInfo_4')+sLineBreak+sLineBreak+
              Gunakan(CekBahasa(),'MAIN','AppInfo_5')+sLineBreak+sLineBreak+
              Gunakan(CekBahasa(),'MAIN','AppInfo_6')+' (ahmad.tauhid.cp@gmail.com)'+sLineBreak+sLineBreak+
              Gunakan(CekBahasa(),'MAIN','AppInfo_7')+' : http://theuserman.blogspot.co.id');
end;

procedure TFUtama.BtnLogClick(Sender: TObject);
var
  Res : TRosApiResult;
  ROS       : TRosApiClient;
begin
     ROS := TRosApiClient.Create;

  if (FUtama.LTLS.Caption='TRUE') then
     ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
     ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);

    Res := ROS.Query(['/log/print'], True);

    if ROS.LastError <> '' then
    MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0);

  BackGround.Visible:=False;
  PanelTengah.Left:=0;
  PanelTengah.Top:=0;
  PanelTengah.Align:=alClient;
  FLog.ParentWindow:=PanelTengah.Handle;
  FLog.WindowState:=wsMaximized;
  FDataUserHotspotAktif.Close;
  FDataUserHotspot.Close;
  FDataLimitBW.Close;
  FLog.MLog.Lines.Clear;
  FLog.Show;

  BackGround.Visible:=False;
  PanelTengah.Left:=0;
  PanelTengah.Top:=0;
  PanelTengah.Align:=alClient;
  FLog.ParentWindow:=PanelTengah.Handle;
  FLog.WindowState:=wsMaximized;
  FDataUserHotspotAktif.Close;
  FDataUserHotspot.Close;
  FDataLimitBW.Close;
  FLog.MLog.Lines.Clear;

  while not Res.Eof do
  begin
  FLog.MLog.Lines.Add(Res.ValueByName['time']+' : '+Res.ValueByName['message']);
  Res.Next;
  end;

  FLog.Show;
  ROS.Free;
  Res.Free;
end;

procedure TFUtama.BWLimitHTMLClick(Sender: TObject);
begin
  FEksportHapusByGroup.LBerdasarkan.Caption:='BL';
  FEksportHapusByGroup.CGroup.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectGroup');
  FEksportHapusByGroup.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','HTMLExportByGroup');
  FEksportHapusByGroup.BEksekusi.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','BPDFExportByGroup');
  FEksportHapusByGroup.LStatus.Caption:='EksportHTML';
  FEksportHapusByGroup.ProgressBar.Visible:=False;
  FEksportHapusByGroup.ShowModal;
end;


procedure TFUtama.CCAllUserClick(Sender: TObject);
var
ROS       : TRosApiClient;
begin
    ROS := TRosApiClient.Create;
    if MessageDlg(Gunakan(CekBahasa(),'MAIN','CCAllUserConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
    begin
    if (LTLS.Caption='TRUE') then
    ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
    ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);
    ROS.Execute(['/ip/hotspot/user/reset-counters']);
    // Cek Apakah ada Error
    if ROS.LastError <> '' then
    MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0)
    else
      begin
      FDataUserHotspot.FormShow(Sender);
      FDataUserHotspot.LID.Caption:='';
      FDataUserHotspot.LNama.Caption:='';
      FDataUserHotspot.LLimitUptime.Caption:='';
      FDataUserHotspot.LProfile.Caption:='';
      FDataUserHotspot.LUptime.Caption:='';
      FDataUserHotspot.LPassword.Caption:='';
      FDataUserHotspot.LComment.Caption:='';
      end;
      end else Abort;
      ROS.Free;
end;

procedure TFUtama.CCExpireUserClick(Sender: TObject);
var
Res,Ras       : TRosApiResult;
i,j       : integer;
pa        : array of AnsiString;
perintah  : array[1..2] of String;
s         : String;
ROS       : TRosApiClient;
begin
    ROS := TRosApiClient.Create;
    if MessageDlg(Gunakan(CekBahasa(),'MAIN','CCExpiredUserConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
    begin
    if (LTLS.Caption='TRUE') then
    ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
    ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);
    Res := ROS.Query(['/ip/hotspot/user/print'], True);
    Ras := ROS.Query(['/ip/hotspot/user/print'], True);
    if (Res.RowsCount > 0) then
    begin
        for i := 1 to Res.RowsCount do
        begin
        // Cek Apakah User Expired
        if (Res.ValueByName['limit-uptime']=Ras.ValueByName['uptime']) then
        begin
        perintah[1]:='/ip/hotspot/user/reset-counters';
        perintah[2]:='=.id='+Res.ValueByName['.id'];
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
        Res.Next;
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
      end else MessageDlg(Gunakan(CekBahasa(),'MAIN','DataEmpty'),mtWarning,[mbok],0);
      end else Abort;
      Res.Free;
      Ras.Free;
      ROS.Free;
end;



procedure TFUtama.ChPasswClick(Sender: TObject);
begin
  FUbahPassword.ShowModal;
end;

procedure TFUtama.CommentHTMLClick(Sender: TObject);
begin
  FEksportHapusByGroup.LBerdasarkan.Caption:='CM';
  FEksportHapusByGroup.CGroup.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectComent');
  FEksportHapusByGroup.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','HTMLExportByComent');
  FEksportHapusByGroup.BEksekusi.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','BVoucherExportByGroup');
  FEksportHapusByGroup.LStatus.Caption:='EksportHTML';
  FEksportHapusByGroup.ProgressBar.Visible:=False;
  FEksportHapusByGroup.ShowModal;
end;

procedure TFUtama.DelAllUserClick(Sender: TObject);
var
Res       : TRosApiResult;
i,j       : integer;
pa        : array of AnsiString;
perintah  : array[1..2] of String;
s         : String;
ROS       : TRosApiClient;
begin
    ROS := TRosApiClient.Create;
    if MessageDlg(Gunakan(CekBahasa(),'MAIN','DelAllUserConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
    begin
    if (LTLS.Caption='TRUE') then
    ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
    ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);
    Res := ROS.Query(['/ip/hotspot/user/print'], True);
    if (Res.RowsCount > 0) then
    begin

       ProgressBar.Max:=Res.RowsCount;
       ProgressBar.Visible:=True;
        for i := 1 to Res.RowsCount do
        begin
        ProgressBar.Position:=i;
        // Pecah Perintah Kedalam Array
        perintah[1]:='/ip/hotspot/user/remove';
        perintah[2]:='=.id='+Res.ValueByName['.id'];
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
        Res.Next;
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
      end else MessageDlg(Gunakan(CekBahasa(),'MAIN','DataEmpty'),mtWarning,[mbok],0);
      end else Abort;
      Res.Free;
      ProgressBar.Visible:=False;
      ROS.Free;
end;



procedure TFUtama.DonateClick(Sender: TObject);
begin
  if (GSMDecode7Bit(GSMDecode7Bit(CekBahasa()))='Bahasa [ID]') then
  begin
  ShowMessage(Gunakan(CekBahasa(),'MAIN','Donate_1')+' :'+sLineBreak+sLineBreak+'ahmad.tauhid.cp@gmail.com'+sLineBreak+sLineBreak
             +Gunakan(CekBahasa(),'MAIN','Donate_2')+' :'+sLineBreak+sLineBreak+
              Gunakan(CekBahasa(),'MAIN','Bank')+#32+#32+#32+#32+#32+#32+#32+#32+#32+#32+#32+#32+': PT BANK MANDIRI (PERSERO) Tbk.'+sLineBreak+
              Gunakan(CekBahasa(),'MAIN','Account')+#32+#32+#32+#32+#32+#32+#32+': AHMAD TAUHID'+sLineBreak+
              Gunakan(CekBahasa(),'MAIN','Acc_Number')+#32+#32+': 161-00-0322490-9'
              +sLineBreak+sLineBreak+Gunakan(CekBahasa(),'MAIN','Donate_3_a')+' ahmad.tauhid.cp@gmail.com '+Gunakan(CekBahasa(),'MAIN','Donate_3_b')
              );
  end else
  begin
  ShowMessage(Gunakan(CekBahasa(),'MAIN','Donate_1')+' :'+sLineBreak+sLineBreak+'ahmad.tauhid.cp@gmail.com'+sLineBreak+sLineBreak
             +Gunakan(CekBahasa(),'MAIN','Donate_2')+' :'+sLineBreak+sLineBreak+
              Gunakan(CekBahasa(),'MAIN','Bank')+#32+#32+#32+#32+#32+#32+#32+#32+#32+#32+#32+#32+': PT BANK MANDIRI (PERSERO) Tbk.'+sLineBreak+
              Gunakan(CekBahasa(),'MAIN','Account')+#32+#32+#32+#32+#32+#32+#32+': AHMAD TAUHID'+sLineBreak+
              Gunakan(CekBahasa(),'MAIN','Acc_Number')+#32+#32+': 161-00-0322490-9'+sLineBreak+
              'SWIFT Code '+#32+#32+#32+#32+#32+#32+#32+#32+#32+#32+#32+': BMRIIDJA'
              +sLineBreak+sLineBreak+Gunakan(CekBahasa(),'MAIN','Donate_3_a')+' ahmad.tauhid.cp@gmail.com '+Gunakan(CekBahasa(),'MAIN','Donate_3_b')
              );
  end;
end;

procedure TFUtama.EUAndPAllClick(Sender: TObject);
var
nama,namagb,user,pass,harga,valid,limit,kolom : String;
Bitmap: TBitmap;
Source: TRect;
Dest: TRect;
i : integer;

begin
  SaveDialog.Filter:='File PDF (*.pdf)|*.pdf';
  if SaveDialog.Execute then
  begin
  FDataUserHotspot.FormShow(Sender);
  if (ExtractFileExt(SaveDialog.FileName)='') then nama:=SaveDialog.FileName+'.pdf' else nama:=SaveDialog.FileName;

      myinifile := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'config.ini');
      with myinifile do
      begin
      // Cek Item
      user := GSMDecode7Bit(ReadString('VOUCHER','UserLogin','0'));
      pass := GSMDecode7Bit(ReadString('VOUCHER','Password','0'));
      harga := GSMDecode7Bit(ReadString('VOUCHER','Price','0'));
      valid := GSMDecode7Bit(ReadString('VOUCHER','Validity','0'));
      limit := GSMDecode7Bit(ReadString('VOUCHER','TimeLimit','0'));
      kolom := GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','VoucherColumn','0')));

      if (ReadString('CONFIG','Template','0')=GSMEncode7Bit(GSMEncode7Bit('default'))) then
      begin
      if SaveVoucher(FDataUserHotspot.GridUserHotspot, nama, user, pass, harga, valid, limit) then
         if MessageDlg(Gunakan(CekBahasa(),'MAIN','ExportVoucherSuccess')+' ('+nama+'). '+Gunakan(CekBahasa(),'MAIN','OpenDocConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
         begin
         OpenDocument(nama);
         end;
      end else
      begin
      // Cek Status Apakah Login QR Sudah diseting
      if (ReadString('CONFIG','HotspotAddress','0')='') then begin
      namagb := GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','Template','0')));
      if SaveVoucherCustom(FDataUserHotspot.GridUserHotspot, nama, namagb, user, pass, harga, valid, kolom) then
         if MessageDlg(Gunakan(CekBahasa(),'MAIN','ExportVoucherSuccess')+' ('+nama+'). '+Gunakan(CekBahasa(),'MAIN','OpenDocConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
         begin
         OpenDocument(nama);
         end;
      end else begin
      FQRLogin.GroupQRLogin.Caption:=Gunakan(CekBahasa(),'GLOBAL','QRCodeLoginGen');
      FQRLogin.Show;
      FQRLogin.ProgressQRLogin.Max:=FDataUserHotspot.GridUserHotspot.RowCount-1;
      // Buat QR Code dan Simpan ke Folder tmp
      for i := 1 to FDataUserHotspot.GridUserHotspot.RowCount-1 do begin
      FQRLogin.ProgressQRLogin.Position:=i;
      FQRLogin.QRLogin.Text:='http://'+GSMDecode7Bit(GSMDecode7Bit(GSMDecode7Bit(ReadString('CONFIG','HotspotAddress','0'))))+'/login?username='+FDataUserHotspot.GridUserHotspot.Cells[2,i]+'&password='+FDataUserHotspot.GridUserHotspot.Cells[5,i];
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
      if SaveVoucherCustomQR(FDataUserHotspot.GridUserHotspot, nama, namagb, user, pass, harga, valid, kolom) then
      begin
         if MessageDlg(Gunakan(CekBahasa(),'MAIN','ExportVoucherSuccess')+' ('+nama+'). '+Gunakan(CekBahasa(),'MAIN','OpenDocConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
         begin
         OpenDocument(nama);
         end;
            // Hapus QR Login
      for i := 1 to FDataUserHotspot.GridUserHotspot.RowCount-1 do begin
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

end;

procedure TFUtama.EUandPBandwidthClick(Sender: TObject);
begin
  FEksportHapusByGroup.LBerdasarkan.Caption:='BL';
  FEksportHapusByGroup.CGroup.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectGroup');
  FEksportHapusByGroup.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','VoucherExportByGroup');
  FEksportHapusByGroup.BEksekusi.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','BVoucherExportByGroup');
  FEksportHapusByGroup.LStatus.Caption:='Eksport';
  FEksportHapusByGroup.ProgressBar.Visible:=False;
  FEksportHapusByGroup.ShowModal;
end;

procedure TFUtama.EUandPCommentClick(Sender: TObject);
begin
  FEksportHapusByGroup.LBerdasarkan.Caption:='CM';
  FEksportHapusByGroup.CGroup.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectComent');
  FEksportHapusByGroup.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','VoucherExportByComent');
  FEksportHapusByGroup.BEksekusi.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','BVoucherExportByGroup');
  FEksportHapusByGroup.LStatus.Caption:='Eksport';
  FEksportHapusByGroup.ProgressBar.Visible:=False;
  FEksportHapusByGroup.ShowModal;
end;

procedure TFUtama.HTMLTemplateClick(Sender: TObject);
begin
FHTMLTemplate.ShowModal;
end;

procedure TFUtama.MenuCustomVoucherColumnClick(Sender: TObject);
begin
  FCustomVoucherColumn.ShowModal;
end;


procedure TFUtama.MenuValiditySettingClick(Sender: TObject);
begin
  FValidityInstall.ShowModal;
end;


procedure TFUtama.MESClick(Sender: TObject);
begin
  FSelectItem.ShowModal;
end;

procedure TFUtama.ExportExcelAllUserClick(Sender: TObject);
var
nama : String;
begin
  SaveDialog.Filter:='File Excel (*.xls)|*.xls';
  if SaveDialog.Execute then
  begin
  FDataUserHotspot.FormShow(Sender);
  if (ExtractFileExt(SaveDialog.FileName)='') then nama:=SaveDialog.FileName+'.xls' else nama:=SaveDialog.FileName;
  if SaveAsExcelFile(FDataUserHotspot.GridUserHotspot, nama) then
     if MessageDlg(Gunakan(CekBahasa(),'MAIN','ExportExcelSuccess')+' ('+nama+'). '+Gunakan(CekBahasa(),'MAIN','OpenDocConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
     begin
     OpenDocument(nama);
     end;
  end;
end;



procedure TFUtama.ExportPDFAllUserClick(Sender: TObject);
var
nama : String;
begin
  SaveDialog.Filter:='File PDF (*.pdf)|*.pdf';
  if SaveDialog.Execute then
  begin
  FDataUserHotspot.FormShow(Sender);
  if (ExtractFileExt(SaveDialog.FileName)='') then nama:=SaveDialog.FileName+'.pdf' else nama:=SaveDialog.FileName;
  if SaveAsPDFFile(FDataUserHotspot.GridUserHotspot, nama) then
     if MessageDlg(Gunakan(CekBahasa(),'MAIN','ExportPDFSuccess')+' ('+nama+'). '+Gunakan(CekBahasa(),'MAIN','OpenDocConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
     begin
     OpenDocument(nama);
     end;
  end;
end;


procedure TFUtama.FormShow(Sender: TObject);
begin
  ProgressBar.Visible:=False;
  StatusBar.Panels.Items[0].Width:=FUtama.Width div 3;
  StatusBar.Panels.Items[1].Width:=FUtama.Width div 3;
  StatusBar.Panels.Items[2].Width:=FUtama.Width div 3;
end;

procedure TFUtama.HotspotUserListClick(Sender: TObject);
begin

  PanelTengah.Width:=Width;
  PanelTengah.Height:=Height;
  BackGround.Visible:=False;
  PanelTengah.Left:=0;
  PanelTengah.Top:=0;
  PanelTengah.Align:=alClient;
  FDataUserHotspot.ParentWindow:=PanelTengah.Handle;
  FDataUserHotspot.WindowState:=wsMaximized;
  FDataUserHotspotAktif.Close;
  FDataLimitBW.Close;
  FLog.Close;
  FDataUserHotspot.Show;

  PanelTengah.Width:=Width;
  PanelTengah.Height:=Height;
  BackGround.Visible:=False;
  PanelTengah.Left:=0;
  PanelTengah.Top:=0;
  PanelTengah.Align:=alClient;
  FDataUserHotspot.ParentWindow:=PanelTengah.Handle;
  FDataUserHotspot.WindowState:=wsMaximized;
  FDataUserHotspotAktif.Close;
  FDataLimitBW.Close;
  FLog.Close;
  FDataUserHotspot.Show;

end;

procedure TFUtama.ListBandwidthLimitationClick(Sender: TObject);
begin
  BackGround.Visible:=False;
  PanelTengah.Left:=0;
  PanelTengah.Top:=0;
  PanelTengah.Align:=alClient;
  FDataLimitBW.ParentWindow:=PanelTengah.Handle;
  FDataLimitBW.WindowState:=wsMaximized;
  FDataUserHotspotAktif.Close;
  FDataUserHotspot.Close;
  FLog.Close;
  FDataLimitBW.Show;

  BackGround.Visible:=False;
  PanelTengah.Left:=0;
  PanelTengah.Top:=0;
  PanelTengah.Align:=alClient;
  FDataLimitBW.ParentWindow:=PanelTengah.Handle;
  FDataLimitBW.WindowState:=wsMaximized;
  FDataUserHotspotAktif.Close;
  FDataUserHotspot.Close;
  FLog.Close;
  FDataLimitBW.Show;
end;

procedure TFUtama.MenuByBandwidthLimitClick(Sender: TObject);
begin
  FEksportHapusByGroup.LBerdasarkan.Caption:='BL';
  FEksportHapusByGroup.CGroup.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectGroup');
  FEksportHapusByGroup.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','DeleteByGroup');
  FEksportHapusByGroup.BEksekusi.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','BDeleteByGroup');
  FEksportHapusByGroup.LStatus.Caption:='Hapus';
  FEksportHapusByGroup.ProgressBar.Visible:=False;
  FEksportHapusByGroup.ShowModal;
end;

procedure TFUtama.MenuByCommentClick(Sender: TObject);
begin
  FEksportHapusByGroup.LBerdasarkan.Caption:='CM';
  FEksportHapusByGroup.CGroup.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectComent');
  FEksportHapusByGroup.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','DeleteByComent');
  FEksportHapusByGroup.BEksekusi.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','BDeleteByGroup');
  FEksportHapusByGroup.LStatus.Caption:='Hapus';
  FEksportHapusByGroup.ProgressBar.Visible:=False;
  FEksportHapusByGroup.ShowModal;
end;

procedure TFUtama.MenuCBandwidthClick(Sender: TObject);
begin
  FEksportHapusByGroup.LBerdasarkan.Caption:='BL';
  FEksportHapusByGroup.CGroup.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectGroup');
  FEksportHapusByGroup.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','CCounterByGroup');
  FEksportHapusByGroup.BEksekusi.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','BCCounterByGroup');
  FEksportHapusByGroup.LStatus.Caption:='Clear';
  FEksportHapusByGroup.ProgressBar.Visible:=False;
  FEksportHapusByGroup.ShowModal;
end;

procedure TFUtama.MenuCCommentClick(Sender: TObject);
begin
  FEksportHapusByGroup.LBerdasarkan.Caption:='CM';
  FEksportHapusByGroup.CGroup.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectComent');
  FEksportHapusByGroup.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','CCounterByComent');
  FEksportHapusByGroup.BEksekusi.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','BCCounterByGroup');
  FEksportHapusByGroup.LStatus.Caption:='Clear';
  FEksportHapusByGroup.ProgressBar.Visible:=False;
  FEksportHapusByGroup.ShowModal;
end;

procedure TFUtama.MenuEBandwithClick(Sender: TObject);
begin
  FEksportHapusByGroup.LBerdasarkan.Caption:='BL';
  FEksportHapusByGroup.CGroup.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectGroup');
  FEksportHapusByGroup.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','ExcelExportByGroup');
  FEksportHapusByGroup.BEksekusi.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','BExcelExportByGroup');
  FEksportHapusByGroup.LStatus.Caption:='EksportXLS';
  FEksportHapusByGroup.ProgressBar.Visible:=False;
  FEksportHapusByGroup.ShowModal;
end;

procedure TFUtama.MenuECommentClick(Sender: TObject);
begin
  FEksportHapusByGroup.LBerdasarkan.Caption:='CM';
  FEksportHapusByGroup.CGroup.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectComent');
  FEksportHapusByGroup.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','ExcelExportByComent');
  FEksportHapusByGroup.BEksekusi.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','BExcelExportByGroup');
  FEksportHapusByGroup.LStatus.Caption:='EksportXLS';
  FEksportHapusByGroup.ProgressBar.Visible:=False;
  FEksportHapusByGroup.ShowModal;
end;

procedure TFUtama.MenuPCommentClick(Sender: TObject);
begin
  FEksportHapusByGroup.LBerdasarkan.Caption:='CM';
  FEksportHapusByGroup.CGroup.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectComent');
  FEksportHapusByGroup.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','PDFExportByComent');
  FEksportHapusByGroup.BEksekusi.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','BPDFExportByGroup');
  FEksportHapusByGroup.LStatus.Caption:='EksportPDF';
  FEksportHapusByGroup.ProgressBar.Visible:=False;
  FEksportHapusByGroup.ShowModal;
end;

procedure TFUtama.MenuPGroupClick(Sender: TObject);
begin
  FEksportHapusByGroup.LBerdasarkan.Caption:='BL';
  FEksportHapusByGroup.CGroup.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectGroup');
  FEksportHapusByGroup.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','PDFExportByGroup');
  FEksportHapusByGroup.BEksekusi.Caption:=Gunakan(CekBahasa(),'EXPORTDELETEBYGROUP','BPDFExportByGroup');
  FEksportHapusByGroup.LStatus.Caption:='EksportPDF';
  FEksportHapusByGroup.ProgressBar.Visible:=False;
  FEksportHapusByGroup.ShowModal;
end;

procedure TFUtama.MenuQRCodeLoginClick(Sender: TObject);
begin
  FQRCodeLogin.ShowModal;
end;

procedure TFUtama.MenuQuotaAllUserClick(Sender: TObject);
begin
  FQuota.LStatus.Caption:='ALL';
  FQuota.ProgressBar.Hide;
  FQuota.CPilih.Hide;
  FQuota.Label4.Hide;
  FQuota.Height:=233;
  FQuota.ShowModal;
end;

procedure TFUtama.MenuQuotaBandwidthLimitClick(Sender: TObject);
begin
  FQuota.Label4.Caption:=Gunakan(CekBahasa(),'QuotaLimit','LimitByBW');
  FQuota.CPilih.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectGroup');
  FQuota.Label4.Show;
  FQuota.ProgressBar.Hide;
  FQuota.CPilih.Show;
  FQuota.Height:=262;
  FQuota.LStatus.Caption:='BW';
  FQuota.ShowModal;
end;

procedure TFUtama.MenuQuotaCommentClick(Sender: TObject);
begin
  FQuota.Label4.Caption:=Gunakan(CekBahasa(),'QuotaLimit','LimitByComent');
  FQuota.CPilih.Text:=Gunakan(CekBahasa(),'GLOBAL','SelectComent');
  FQuota.Label4.Show;
  FQuota.CPilih.Show;
  FQuota.ProgressBar.Hide;
  FQuota.LStatus.Caption:='CM';
  FQuota.Height:=262;
  FQuota.ShowModal;
end;

procedure TFUtama.MenuTimeLimitClick(Sender: TObject);
var
Res,Ras   : TRosApiResult;
i,j       : integer;
pa        : array of AnsiString;
perintah  : array[1..2] of String;
s         : String;
ROS       : TRosApiClient;
begin
    ROS := TRosApiClient.Create;
    if MessageDlg(Gunakan(CekBahasa(),'MAIN','DelExpiredUserConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
    begin
    if (LTLS.Caption='TRUE') then
    ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
    ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);
    Res := ROS.Query(['/ip/hotspot/user/print'], True);
    Ras := ROS.Query(['/ip/hotspot/user/print'], True);
    if (Res.RowsCount > 0) then
    begin
        for i := 1 to Res.RowsCount do
        begin
        // Cek Apakah User Expired
        if (Res.ValueByName['limit-uptime']=Ras.ValueByName['uptime']) then
        begin
        perintah[1]:='/ip/hotspot/user/remove';
        perintah[2]:='=.id='+Res.ValueByName['.id'];
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
        Res.Next;
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
      end else MessageDlg(Gunakan(CekBahasa(),'MAIN','DataEmpty'),mtWarning,[mbok],0);
      end else Abort;
      Res.Free;
      Ras.Free;
      ROS.Free;
end;

procedure TFUtama.MenuValidityClick(Sender: TObject);
var
Res       : TRosApiResult;
i,j       : integer;
pa        : array of AnsiString;
perintah  : array[1..2] of String;
s         : String;
ROS       : TRosApiClient;
begin
    ROS := TRosApiClient.Create;
    if MessageDlg(Gunakan(CekBahasa(),'MAIN','DelExpiredUserConfirmV'),mtConfirmation,[mbyes,mbno],0)=mrYes then
    begin
    if (LTLS.Caption='TRUE') then
    ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
    ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);
    Res := ROS.Query(['/ip/hotspot/user/print'], True);
    if (Res.RowsCount > 0) then
    begin
        for i := 1 to Res.RowsCount do
        begin
        // Cek Apakah User Expired
        if (Res.ValueByName['disabled']='true') then
        begin
        perintah[1]:='/ip/hotspot/user/remove';
        perintah[2]:='=.id='+Res.ValueByName['.id'];
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
        Res.Next;
        end;
      FDataUserHotspot.FormShow(Sender);
      FDataUserHotspot.LID.Caption:='';
      FDataUserHotspot.LNama.Caption:='';
      FDataUserHotspot.LLimitUptime.Caption:='';
      FDataUserHotspot.LProfile.Caption:='';
      FDataUserHotspot.LUptime.Caption:='';
      FDataUserHotspot.LPassword.Caption:='';
      FDataUserHotspot.LComment.Caption:='';
      end else MessageDlg(Gunakan(CekBahasa(),'MAIN','DataEmpty'),mtWarning,[mbok],0);
      end else Abort;
      Res.Free;
      ROS.Free;
end;



procedure TFUtama.Office2007BlueClick(Sender: TObject);
begin
  StyleChangeHandler(Sender);
end;

procedure TFUtama.MetroLightClick(Sender: TObject);
begin
  StyleChangeHandler(Sender);
end;

procedure TFUtama.MetroDarkClick(Sender: TObject);
begin
  StyleChangeHandler(Sender);
end;

procedure TFUtama.RebootClick(Sender: TObject);
var
  pa : array of AnsiString;
  perintah : array[1..2] of String;
  s : String;
  i : integer;
  ROS : TRosApiClient;
begin
    ROS := TRosApiClient.Create;
    if MessageDlg(Gunakan(CekBahasa(),'MAIN','RebootConfirm'),mtConfirmation,[mbyes,mbno],0)=mrYes then
    begin
    if (LTLS.Caption='TRUE') then
    ROS.SSLConnect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption) else
    ROS.Connect(FUtama.LIP.Caption, FUtama.LUser.Caption, FUtama.LPass.Caption);
    // Pecah Perintah Kedalam Array
    perintah[1]:='/system/reboot';
    // Menyimpan Perintah Kedalam Variabel pa
    SetLength(pa, 0);
    for i := 1 to 1 do
    begin
      s := Trim(perintah[i]);
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
    MessageDlg('ERROR : ' + ROS.LastError,mtError,[mbok],0)
    else
    Application.Terminate;
      end else Abort;
    end;

procedure TFUtama.SpkLargeButton13Click(Sender: TObject);
begin
  BackGround.Visible:=False;
  PanelTengah.Left:=0;
  PanelTengah.Top:=0;
  FDataUserHotspot.ParentWindow:=PanelTengah.Handle;
  FDataUserHotspot.WindowState:=wsMaximized;
  FDataUserHotspotAktif.Close;
  FDataLimitBW.Close;
  FDataUserHotspot.Show;

  BackGround.Visible:=False;
  PanelTengah.Left:=0;
  PanelTengah.Top:=0;
  FDataUserHotspot.ParentWindow:=PanelTengah.Handle;
  FDataUserHotspot.WindowState:=wsMaximized;
  FDataUserHotspotAktif.Close;
  FDataLimitBW.Close;
  FDataUserHotspot.Show;
end;

procedure TFUtama.VoucherClick(Sender: TObject);
begin
  FTemplateVoucher.ShowModal;
end;

procedure TFUtama.StyleChangeHandler(Sender: TObject);
var
  i: Integer;
begin
  for i:=0 to PopupTheme.Items.Count-1 do
  PopupTheme.Items[i].Checked := PopupTheme.Items[i] = TMenuItem(Sender);
  MenuRibbonSPK.Style := TSpkStyle((Sender as TMenuItem).Tag);
  case MenuRibbonSPK.Style of
    SpkOffice2007Blue    : MenuRibbonSPK.Color := clSkyBlue;
    SpkOffice2007Silver  : MenuRibbonSPK.Color := clWhite;
    SpkMetroLight        : MenuRibbonSPK.Color := clSilver;
    SpkMetroDark         : MenuRibbonSPK.Color := $080808;
  end;
end;




end.

